system"l /home/iwickham/IWSTUDY/stack/lib/cron.q";
system"l ../config/schemas.q"
if[null h:.ipc.conn`tp1;: (1"could not connect";exit 1)]

hdbh:.ipc.conn`hdb1
upd:upsert

sub:{[t] h(`.u.sub;t)}

savetable:{[d;t] 
    .Q.dpft[`:/home/iwickham/IWSTUDY/stack/hdb;d;`sym;t];
    delete from t;
    neg[hdbh](`refresh;`);
    }

.u.end:{[d] savetable[d] each tables`}

sub`

getTrades:{[daterange;syms;includeQuotes]
    $[not includeQuotes;
        ?[`trade;enlist(in;`sym;enlist syms);0b;()];
        aj[`sym`time;?[`trade;enlist(in;`sym;enlist syms);0b;()];quote]
    ]
    }