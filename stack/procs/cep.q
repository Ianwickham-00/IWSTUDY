\e 1
.boot.loadLib`cron;
.boot.loadSchemas[];

h:.ipc.conn`tp1;

barInterval:00:01:00.000000000;

ohlc:2!ohlc;   / local copy is keyed; the shared schema is not

upd:{[t;x]
    chunk:update barTime:barInterval xbar time from x;
    batch:0!select o:first price,h:max price,l:min price,c:last price by sym,barTime from chunk;
    k:select sym,barTime from batch;
    op:k inter key ohlc;
    p:op,'ohlc op;
    ohlc::ohlc upsert select o:first o,h:max h,l:min l,c:last c by sym,barTime from p,batch;
 }

pub:{
    o:0!ohlc;
    b:o[`barTime]<cutoff:.z.p-barInterval;
    if[not any b;:()];
    ohlc::2!delete from o where barTime<cutoff;
    neg[h](`.u.upd;`ohlc;value flip o where b);
 }

.u.end:{[d]
    o:0!ohlc;
    if[count o; neg[h](`.u.upd;`ohlc;value flip o)];
    delete from `ohlc;
 }

.event.addHandler[`.z.ts;pub]

sub:{[t] h(`.u.sub;t)}
sub`trade;
\t 1000

/ 
h is still a global variable