system"l /home/iwickham/IWSTUDY/stack/lib/cron.q";
system"l ../config/schemas.q"

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
The following looks strange to me:
 if[null h:.ipc.conn`tp1;: (-1"could not connect";exit 1)]

I would've thought the following to be standard:
 if[null h:.ipc.conn`tp1;-1"could not connect";exit 1]

-> an if statement runs all blocks, so ; between each one is fine. Leave the exit until last