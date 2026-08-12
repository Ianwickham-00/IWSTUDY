.boot.loadLib`cron;

.cc.HEARTBEAT:00:00:05;
.cc.MAXTRIES:3;

.cc.QBIN:getenv[`QHOME],"/bin/q";       / a real path, a shell alias is no use here
.cc.LOGDIR:.boot.file"log";             / one <name>.log per proc

/ one row per configured process. pid is only set for procs we started ourselves,
/ wanted says whether we mean it to be up - a deliberate stop is not an outage
.cc.status:1!flip`name`proc`port`handle`up`lastBeat`tries`pid`wanted!"ssjibpjjb"$\:();

/ seed .cc.status from .boot.processes, everything down until proven otherwise
.cc.init:{[]
    `.cc.status upsert update handle:0Ni,up:0b,lastBeat:0Np,tries:0,pid:0N,wanted:1b from .boot.processes;
    delete from `.cc.status where port=system"p";     / no point beating ourselves
 }

/ open a handle if we do not already hold one, mark up/down
.cc.connect:{[n] 
    h:.ipc.conn n;
    update handle:h,up:not null h from `.cc.status where name=n;
    h
    }


/ async ping one proc, remote replies to .cc.pong
.cc.beat:{[n]
    h:.cc.connect n;
    if[null h;:()];
    update tries:tries+1 from `.cc.status where name=n;
    neg[h]({neg[.z.w](`.cc.pong;x;.z.p)};n);
    neg[h][];
 }

/ ping everything, bump tries, call .cc.down on anything past MAXTRIES
.cc.beatAll:{[]
    .cc.beat each exec name from .cc.status;
    .cc.down each exec name from .cc.status where tries>=.cc.MAXTRIES;
 }

/ reply handler: stamp lastBeat, clear tries
.cc.pong:{[n;stamp] update up:1b,lastBeat:stamp,tries:0 from `.cc.status where name=n}

/ proc is gone: log it, drop the handle, whatever alerting we want
.cc.down:{[n]
    if[.cc.status[n][`up]and .cc.status[n]`wanted;-1 "cc: ",string[n]," down";];  / a stop is not an outage
    h:.cc.status[n]`handle;
    if[not null h;.ipc.disconnect h;@[hclose;h;()]];
    update handle:0Ni,up:0b,tries:0 from `.cc.status where name=n;  / tries restarts on reconnect
 }

/ .z.pc handler - a dead proc closes its socket long before it misses MAXTRIES
.cc.onClose:{[h] .cc.down each exec name from .cc.status where handle=h}

/ what a dashboard or the gw would ask for
.cc.summary:{[] select name,proc,port,up,wanted,lastBeat,age:.z.p-lastBeat,tries,pid from .cc.status}


/ ---- starting and stopping ----------------------------------------------

/ where a proc's stdout/stderr lands
.cc.logFile:{[n] .cc.LOGDIR,"/",string[n],".log"}

/ q boot.q -<name> in the background, stamp the pid on the row.
/ echo $! is how we get the pid back - system gives us the child's stdout, not its pid
.cc.start:{[n]
    if[.cc.status[n]`up;-1 "cc: ",string[n]," already up";:0N];
    system"mkdir -p ",.cc.LOGDIR;
    p:"J"$first system"nohup ",.cc.QBIN," ",.boot.file"boot.q"," -",string[n],
        " -q > ",.cc.logFile[n]," 2>&1 & echo $!";
    update pid:p,wanted:1b from `.cc.status where name=n;   / p, not pid: pid would read the column
    -1 "cc: started ",string[n]," pid ",string p;
    p
 }

/ ask nicely: exit over the handle, .z.exit is where a proc hooks its own cleanup
.cc.stop:{[n]
    update wanted:0b from `.cc.status where name=n;         / so .cc.down keeps quiet
    h:.cc.status[n]`handle;
    if[null h;-1 "cc: ",string[n]," not up";:()];
    neg[h]"exit 0";
    neg[h][];
    -1 "cc: stopped ",string n;
 }

/ it would not go: signal the pid we recorded in .cc.start
.cc.kill:{[n]
    p:.cc.status[n]`pid;
    if[null p;-1 "cc: no pid for ",string[n],", not ours to kill";:()];
    update wanted:0b from `.cc.status where name=n;
    system"kill -9 ",string p;
    -1 "cc: killed ",string[n]," pid ",string p;
 }

/ .z.pc only fires once we are back in the event loop, so do our own bookkeeping
/ rather than waiting for it - otherwise .cc.start sees a stale up:1b
.cc.restart:{[n]
    .cc.stop n;
    system"sleep 1";
    .cc.down n;
    .cc.start n;
 }

/ everything configured but not up, csv order so the tickerplant leads
.cc.startAll:{[] .cc.start each exec name from .cc.status where not up}

/ reverse, so subscribers go before the tickerplant
.cc.stopAll:{[] .cc.stop each reverse exec name from .cc.status where up}

.event.addHandler[`.z.pc;.cc.onClose];
.cron.add[`.cc.beatAll;.z.p;.cc.HEARTBEAT];

.cc.init[];
\t 1000
