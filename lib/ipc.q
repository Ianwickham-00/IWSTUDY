.boot.loadLib`event;

.ipc.conns:.boot.processes lj 1!flip `name`proc`port`handle!"ssji"$\:()

.ipc.tryconnect:@[hopen;;0Ni]

.ipc.conn:{[n]
    d:.ipc.conns n;
    if[not null h:d`handle;:h];
    h:.ipc.tryconnect d`port;
    update handle:h from `.ipc.conns where name=n;
    h
 }

.ipc.disconnect:{[h] update handle:0Ni from `.ipc.conns where handle=h;}
.event.addHandler[`.z.pc;.ipc.disconnect]
.z.pc:.event.fire`.z.pc
