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

/ 
The standard for an rdb is for upd to be insert
tables will never be keyed
Is it the done thing to tell the hdb to refresh each time you save a table
or do it after you've saved all?
I would think doing it after each table could great incosistencies

The sub` looks a bit lost in the middle
More standard to leave actions until end of file