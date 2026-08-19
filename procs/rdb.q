.boot.loadLib`cron;
.boot.loadSchemas[];
if[null h:.ipc.conn`tp1; -1"could not connect";exit 1]

hdbh:.ipc.conn each exec name from .boot.processes where proc=`hdb
upd:upsert

sub:{[t] h(`.u.sub;t)}

savetable:{[d;t]
    .Q.dpft[.boot.hfile"hdb";d;`sym;t];
    delete from t;
    neg[hdbh where not null hdbh]@\:(`refresh;`);
    }

.u.end:{[d] savetable[d] each tables`}

getTrades:{[daterange;syms;includeQuotes]       / include the positive case first e.g. $[includeQuotes; aj...; ?[`trade...]
    $[includeQuotes;
        aj[`sym`time;?[`trade;enlist(in;`sym;enlist syms);0b;()];quote];
        ?[`trade;enlist(in;`sym;enlist syms);0b;()]
    ]
    }

sub`
