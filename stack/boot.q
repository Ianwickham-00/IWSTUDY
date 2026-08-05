.boot.root:` sv hsym[`$getenv`SHOME],`stack;
.boot.hfile:{` sv .boot.root,`$x};
.boot.file:{1_string .boot.hfile x};
.boot.loadFile:{system"l ",.boot.file x};
.boot.loadCsv:{[types;f] (types;enlist",")0:.boot.hfile f};

.boot.loaded:`symbol$();
.boot.loadLib:{{if[not x in .boot.loaded;.boot.loaded,:x;.boot.loadFile"lib/",string[x],".q"]}each(),x};

.boot.loadSchemas:{{x[`table] set flip(`$" "vs string x`cols)!(string x`types)$\:()}each .boot.loadCsv["SSS";"config/schemas.csv"]};

.boot.processes:1!.boot.loadCsv["SSJ";"config/processes.csv"];

.boot.start:{
    d:.boot.processes x;
    if[null d`port;'"unknown proc: ",string x];
    system"p ",string d`port;
    .boot.loadFile"procs/",string[d`proc],".q";
 };

if[count o:.Q.opt .z.x;.boot.start first key o];
