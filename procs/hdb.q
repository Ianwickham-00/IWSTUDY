.boot.loadLib`cron;

refresh:{if[count key .boot.hfile"hdb";.boot.loadFile"hdb"]}

getTrades:{[daterange;syms;includeQuotes]
    $[includeQuotes;
        aj[`sym`time;?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];quote];
        ?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()]
    ]
    }

.ipc.conn`rdb1;
refresh[]
