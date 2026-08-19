.boot.loadLib`cron;
.boot.loadSchemas[];

if[null .ipc.conn`tp1;: (-1"could not connect";exit 1)]
`sym xkey'tables`

sub:{[t] .ipc.conn[`tp1](`.u.sub;t)}

upd:{[t;x] t upsert x}

getLast:{[syms;includeQuotes]
    t:?[trade;enlist(in;`sym;enlist syms);0b;()];
    $[includeQuotes;
        t lj `sym xkey(`time`exchange!`quoteTime`quoteExchange)xcol?[quote;enlist(in;`sym;enlist syms);0b;()];
        t]
    }

sub`