\e 1
.boot.loadLib`cron;

SYMS:`JPM`GOOG`TSLA`NVDA`MSFT`META`PLNTR1`GE;
EX:`N`C`L

h:.ipc.conn`tp1;
genTrade:{ 
        n:rand 100;
        (n#.z.p;n?SYMS;n?1000;n?100f;n?EX)
 }

genQuote:{
    n:rand 1000;
    d:n?100f;
    s:n?1000;
    (n#.z.p;n?SYMS;d;d-1;s;s-1;n?EX)
 }

pub:{[t;x] neg[h](`.u.upd;t;x)}

sendtp:{pub'[(`trade`quote);(genTrade`;genQuote`)]}

.event.addHandler[`.z.ts;sendtp]

.z.ts:.event.fire`.z.ts
system"t 100"

/ 
if quote is time sym bid ask bidSize askSize exchange
the use of d and s as variable names is not intuitive
also, ask should be higher than bid, not lower

still a global h