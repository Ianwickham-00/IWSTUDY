.boot.loadLib`event;

.ipc.conns:.boot.processes lj 1!flip `name`proc`port`handle!"ssji"$\:();

.ipc.conn:{[Sname] / not a lover of caps in arg
    d:.ipc.conns Sname;
    if[not null f:d`handle;: f];  / why choose f? h is idiomatic
    h:.ipc.tryconnect d`port;
    update handle:h from `.ipc.conns where name=Sname;
    h
 }

.ipc.tryconnect:{[port] @[hopen;port;0Ni]}

.ipc.disconnect:{[h] update handle:0Ni from `.ipc.conns where handle=h;};
.event.addHandler[`.z.pc;.ipc.disconnect];
.z.pc:.event.fire`.z.pc;

/
.ipc.tryconnect:@[hopen;;0Ni]   / a bit tighter
still caps in arg