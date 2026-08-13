\e 1
.boot.loadLib`cron;

SYMS:`JPM`GOOG`TSLA`NVDA`MSFT`META`PLNTR1`GE
EX:`N`C`L

genTrade:{
    n:rand 100;
    (n#.z.p;n?SYMS;n?1000;n?100f;n?EX)
 }

genQuote:{
    n:rand 1000;
    bid:n?100f;
    bidSize:n?1000;
    (n#.z.p;n?SYMS;bid;bid+1;bidSize;bidSize+1;n?EX)
 }

pub:{[t;x] neg[.ipc.conn`tp1](`.u.upd;t;x)}

sendtp:{pub'[(`trade`quote);(genTrade`;genQuote`)]}

.event.addHandler[`.z.ts;sendtp]

.z.ts:.event.fire`.z.ts
system"t 100"
