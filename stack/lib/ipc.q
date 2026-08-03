processes:1!("SSJ";enlist",")0:`:/home/iwickham/IWSTUDY/stack/config/processes.csv;

.ipc.conns:processes lj 1!flip `name`proc`port`handle!"ssji"$\:();


.ipc.conn:{[Sname] 
    d:.ipc.conns Sname;
    if[not null f:d`handle;: f];
    h:.ipc.tryconnect d`port;
    update handle:h from `.ipc.conns where name=Sname;
    h
 }

.ipc.tryconnect:{[port] @[hopen;port;0Ni]}


.ipc.disconnect:{[h] update handle:0Ni from `.ipc.conns where handle=h;};
.event.addHandler[`.z.pc;.ipc.disconnect];
.z.pc:.event.fire`.z.pc;