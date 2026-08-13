\e 1
.boot.loadLib`cron;

.gw.clientRequests:1!flip`clientReqID`handle`requests`responses!"ji**"$\:();
.gw.serverRequests:flip`serverReqID`clientReqID`responded`result`error!"jjb**"$\:();
.gw.CLIENT_REQ:1000
.gw.SERVER_REQ:1000

.gw.pending:(`int$())!()

.gw.pool:{[p]
    .ipc.conn each exec name from .boot.processes where proc=p;
    exec handle from .ipc.conns where proc=p,not null handle
 }

.gw.pick:{[s] s d?min d:count each .gw.pending s}

.gw.query:{[funcargs]
    args:1_funcargs;
    id:.gw.CLIENT_REQ+:1;
    `.gw.clientRequests upsert (id;.z.w;0;0);

    if[args[0;0]<.z.d;
        .gw.runasync[`hdb;id;funcargs]];

    if[.z.d within args[0]; / no need for square brackets
        .gw.runasync[`rdb;id;funcargs]];
 }

.gw.runasync:{[p;id;fa]
    update requests+1 from `.gw.clientRequests where clientReqID=id;
    if[not count s:.gw.pool p;:.gw.serverResponse[id;(`ERR;`noslaves)]];
    .gw.pending[h:.gw.pick s],:enlist id;
    neg[h]({neg[.z.w](`.gw.reply;@[value;x;{(`ERR;x)}])};fa);
    neg[h][];
 }

.gw.reply:{[data]
    id:first .gw.pending h:.z.w;
    .gw.pending[h]:1_.gw.pending h;
    .gw.serverResponse[id;data];
 }

.gw.serverResponse:{[id;data]
    sid:.gw.SERVER_REQ+:1;
    `.gw.serverRequests upsert (sid;id;0b;();());
    update clientReqID:id from `.gw.serverRequests where serverReqID=sid;
    update responded:1b from `.gw.serverRequests where serverReqID=sid;

    if[98h=type data;
        update result:enlist data from `.gw.serverRequests where serverReqID=sid];

    if[`ERR~first data;
        update error:enlist data from `.gw.serverRequests where serverReqID=sid];

    if[(.gw.clientRequests[id]`requests)=exec sum responded from .gw.serverRequests where clientReqID=id;
        neg[.gw.clientRequests[id]`handle](`gwResponse;raze exec result from .gw.serverRequests where clientReqID=id)]

   }
