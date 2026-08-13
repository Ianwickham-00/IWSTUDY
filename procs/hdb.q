.boot.loadLib`cron;

refresh:{if[count key .boot.hfile"hdb";.boot.loadFile"hdb"]}

getTrades:{[daterange;syms;includeQuotes]
    $[not includeQuotes;
        ?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];
        aj[`sym`time;?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];quote]
    ]
    }

.ipc.conn`rdb1;
refresh[]
