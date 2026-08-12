.boot.loadLib`cron;
.boot.loadSchemas[];
if[null h:.ipc.conn`tp1; -1"could not connect";exit 1]

/ every member of the hdb pool has to reload, not just hdb1
hdbh:.ipc.conn each exec name from .boot.processes where proc=`hdb
upd:upsert

sub:{[t] h(`.u.sub;t)}

savetable:{[d;t] 
    .Q.dpft[.boot.hfile"hdb";d;`sym;t];
    delete from t;
    neg[hdbh where not null hdbh]@\:(`refresh;`);
    }

.u.end:{[d] savetable[d] each tables`}

sub`

getTrades:{[daterange;syms;includeQuotes]
    $[not includeQuotes;
        ?[`trade;enlist(in;`sym;enlist syms);0b;()];
        aj[`sym`time;?[`trade;enlist(in;`sym;enlist syms);0b;()];quote]
    ]
    }

/ 
sub` is still in the middle of the file