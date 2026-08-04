system"l /home/iwickham/IWSTUDY/stack/lib/cron.q";
system"l ../config/schemas.q"

if[null h:.ipc.conn`tp1;: (-1"could not connect";exit 1)]
`sym xkey'tables`;
sub:{[t] h(`.u.sub;t)};

upd:{[t;x] 
    t upsert `sym xkey x;
    }

getLast:{[syms;includeQuotes]
    if[not includeQuotes;: ?[0!trade;enlist(in;`sym;enlist syms);0b;()]];
    t:aj[`sym`time;0!trade;0!quote];
    ?[t;enlist(in;`sym;enlist syms);0b;()];
    }

sub`