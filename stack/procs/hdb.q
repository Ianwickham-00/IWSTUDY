.boot.loadLib`cron;
.ipc.conn`rdb1

refresh:{if[not count key .boot.hfile"hdb";:()];.boot.loadFile"hdb"}
refresh[];

getTrades:{[daterange;syms;includeQuotes]
    $[not includeQuotes;
        ?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];
        aj[`sym`time;?[`trade;((within;`date;daterange);(in;`sym;enlist syms));0b;()];quote]
    ]
    }

/
refresh:{if[count key .boot.hfile"hdb";.boot.loadFile"hdb"]}

you still have a function call in the middle of the file, best to put calls at the end