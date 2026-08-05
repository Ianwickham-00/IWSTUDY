.boot.loadLib`cron;

.cc.HEARTBEAT:00:00:05;
.cc.MAXTRIES:3;

/ one row per configured process
.cc.status:1!flip`name`proc`port`handle`up`lastBeat`tries!"ssjibpj"$\:();

/ seed .cc.status from .boot.processes, everything down until proven otherwise
.cc.init:{[]
    `.cc.status upsert update handle:0Ni,up:0b,lastBeat:0Np,tries:0 from .boot.processes;
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
    if[.cc.status[n]`up;-1 "cc: ",string[n]," down";];   / only shout on the way down
    h:.cc.status[n]`handle;
    if[not null h;.ipc.disconnect h;@[hclose;h;()]];
    update handle:0Ni,up:0b,tries:0 from `.cc.status where name=n;  / tries restarts on reconnect
 }

/ .z.pc handler - a dead proc closes its socket long before it misses MAXTRIES
.cc.onClose:{[h] .cc.down each exec name from .cc.status where handle=h}

/ what a dashboard or the gw would ask for
.cc.summary:{[] select name,proc,port,up,lastBeat,age:.z.p-lastBeat,tries from .cc.status}

.event.addHandler[`.z.pc;.cc.onClose];
.cron.add[`.cc.beatAll;.z.p;.cc.HEARTBEAT];

.cc.init[];
\t 1000
