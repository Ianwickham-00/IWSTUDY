.boot.root:hsym`$getenv`SHOME
.boot.hfile:` sv .boot.root,`$
.boot.file:1_string .boot.hfile@
.boot.loadFile:system"l ",.boot.file@
.boot.loadCSV:{[types;f] (types;enlist",")0:.boot.hfile f}

/ infer a typed value from a config string (adapted from .qi.infer)
.boot.infer:{[x]
    if[10<>type x;:x];
    if[x like"'*'";:1_-1_x];
    if[x like"[A-z]";:x];
    if[x like"[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]";:x];
    if[(count a)=sum(a:-1_x)in .Q.n," .:-";:get x];
    if[":"=x 0;:`$x];
    if["`"=x 0;:`$1_x];
    x}

/ settings values are heterogeneous, so type them per row rather than declaring a column type
.boot.loadSettings:{[f]
    t:.boot.loadCSV["S*";f];
    t:flip`variable`value!(t`variable;.boot.infer each t`value);
    (t`variable) set' t`value;
    1!t}

.boot.loaded:`symbol$()
.boot.loadLib:{{if[not x in .boot.loaded;.boot.loaded,:x;.boot.loadFile"lib/",string[x],".q"]}each(),x}

.boot.loadSchemas:{{x[`table] set flip(`$" "vs string x`cols)!(string x`types)$\:()}each .boot.loadCSV["SSS";"config/schemas.csv"]}

.boot.processes:1!.boot.loadCSV["SSJ";"config/processes.csv"]

.boot.start:{
    d:.boot.processes x;
    if[null d`port;'"unknown proccess: ",string x];
    system"p ",string d`port;
    .boot.loadFile"procs/",string[d`proc],".q";
 }

if[count o:.Q.opt .z.x;.boot.start first key o]

/
some chaining might make things a bit neater
