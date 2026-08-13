.boot.loadLib`cron;
.boot.loadSchemas[];

if[null .ipc.conn`tp1;: (-1"could not connect";exit 1)]
`sym xkey'tables`;

sub:{[t] .ipc.conn[`tp1](`.u.sub;t)}

upd:{[t;x] t upsert x}

getLast:{[syms;includeQuotes]
    if[not includeQuotes;: ?[0!trade;enlist(in;`sym;enlist syms);0b;()]];
    t:aj[`sym`time;0!trade;0!quote];
    ?[t;enlist(in;`sym;enlist syms);0b;()];
    }

sub`
