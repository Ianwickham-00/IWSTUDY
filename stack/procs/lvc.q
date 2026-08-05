.boot.loadLib`cron;
.boot.loadSchemas[];

if[null h:.ipc.conn`tp1;: (-1"could not connect";exit 1)]
`sym xkey'tables`;
sub:{[t] h(`.u.sub;t)};

upd:{[t;x]                      / such a short function can be a one liner
    t upsert `sym xkey x;       / why are you doing xkey? you have already keyed the tables in your global namespace
    }

getLast:{[syms;includeQuotes]
    if[not includeQuotes;: ?[0!trade;enlist(in;`sym;enlist syms);0b;()]];
    t:aj[`sym`time;0!trade;0!quote];
    ?[t;enlist(in;`sym;enlist syms);0b;()];
    }

sub`

/ 
you still have h as a gloval variable