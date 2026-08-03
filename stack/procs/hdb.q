system"l ../lib/cron.q"
.ipc.conn`rdb1
system"l /home/iwickham/IWSTUDY/stack/hdb"

refresh:{system"l /home/iwickham/IWSTUDY/stack/hdb"}

getTrades:{[daterange;syms;includeQuotes]
    $[not includeQuotes;
        ?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];
        aj[`sym`time;?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];quote]
    ]
    }