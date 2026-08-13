.boot.loadLib`cron;

.cc.HEARTBEAT:00:00:05
.cc.MAXTRIES:3
.cc.QBIN:getenv[`QHOME],"/bin/q"
.cc.LOGDIR:.boot.file"log"

.cc.status:1!flip`name`proc`port`handle`up`lastBeat`tries`pid`wanted!"ssjibpjjb"$\:()

.cc.log:{[n;s] -1"cc: ",string[n]," ",s;}

.cc.logFile:{[n] .cc.LOGDIR,"/",string[n],".log"}

.cc.init:{
    `.cc.status upsert update handle:0Ni,up:0b,lastBeat:0Np,tries:0,pid:0N,wanted:1b from .boot.processes;
    delete from `.cc.status where port=system"p";
 }

.cc.connect:{[n]
    h:.ipc.conn n;
    update handle:h,up:not null h from `.cc.status where name=n;
    h
 }

.cc.beat:{[n]
    h:.cc.connect n;
    if[null h;:()];
    update tries:tries+1 from `.cc.status where name=n;
    neg[h]({neg[.z.w](`.cc.pong;x;.z.p)};n);
    neg[h][];
 }

.cc.beatAll:{
    .cc.beat each exec name from .cc.status;
    .cc.down each exec name from .cc.status where tries>=.cc.MAXTRIES;
 }

.cc.pong:{[n;stamp] update up:1b,lastBeat:stamp,tries:0 from `.cc.status where name=n}

.cc.down:{[n]
    d:.cc.status n;
    if[d[`up]and d`wanted;.cc.log[n;"down"]];
    if[not null d`handle;.ipc.disconnect d`handle;@[hclose;d`handle;()]];
    update handle:0Ni,up:0b,tries:0 from `.cc.status where name=n;
 }

.cc.onClose:{[h] .cc.down each exec name from .cc.status where handle=h}

.cc.summary:{select name,proc,port,up,wanted,lastBeat,age:.z.p-lastBeat,tries,pid from .cc.status}

.cc.start:{[n]
    if[.cc.status[n]`up;.cc.log[n;"already up"];:0N];
    system"mkdir -p ",.cc.LOGDIR;
    p:"J"$first system"nohup ",.cc.QBIN," ",.boot.file"boot.q"," -",string[n]," -q > ",.cc.logFile[n]," 2>&1 & echo $!";
    update pid:p,wanted:1b from `.cc.status where name=n;
    .cc.log[n;"started pid ",string p];
    p
 }

.cc.stop:{[n]
    update wanted:0b from `.cc.status where name=n;
    h:.cc.status[n]`handle;
    if[null h;.cc.log[n;"not up"];:()];
    neg[h]"exit 0";
    neg[h][];
    .cc.log[n;"stopped"];
 }

.cc.kill:{[n]
    p:.cc.status[n]`pid;
    if[null p;.cc.log[n;"no pid, not ours to kill"];:()];
    update wanted:0b from `.cc.status where name=n;
    system"kill -9 ",string p;
    .cc.log[n;"killed pid ",string p];
 }

.cc.restart:{[n]
    .cc.stop n;
    .cc.down n;
    .cc.start n;
 }

.cc.startAll:{.cc.start each exec name from .cc.status where not up}

.cc.stopAll:{.cc.stop each reverse exec name from .cc.status where up}

.event.addHandler[`.z.pc;.cc.onClose]

.cron.add[`.cc.beatAll;.z.p;.cc.HEARTBEAT];
.cc.init[]
\t 1000
