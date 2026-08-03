\e 1
system"l /home/iwickham/IWSTUDY/stack/lib/cron.q"

.gw.clientRequests:1!flip`clientReqID`handle`requests`responses!"ji**"$\:();
.gw.serverRequests:flip`serverReqID`clientReqID`responded`result`error!"jjb**"$\:();
.gw.CLIENT_REQ:1000
.gw.SERVER_REQ:1000

(hr;hh):.ipc.conn each`rdb1`hdb1;

.gw.query:{[funcargs]
    args:1_funcargs;
    id:.gw.CLIENT_REQ+:1;
    `.gw.clientRequests upsert (id;.z.w;0;0);

    if[args[0;0]<.z.d;
        .gw.runasync[hh;id;funcargs]];

    if[.z.d within args[0];
        .gw.runasync[hr;id;funcargs]];
 }

.gw.runasync:{[sh;id;fa]
    update requests+1 from `.gw.clientRequests where clientReqID=id;
    neg[sh]({neg[.z.w](`.gw.serverResponse;x;@[value;y;{(`ERR;x)}])};id;fa)fa
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