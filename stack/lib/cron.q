.boot.loadLib`event`ipc;

.cron.jobs:1!flip`func`start`period`lastRun`nextRun`error!"spvpp*"$\:();
.cron.add:{[func;start;period] `.cron.jobs upsert (func;start;period;0Np;start;())};

.cron.run1:{[job;now]
    update lastRun:nextRun from `.cron.jobs where func=job;
    update nextRun:lastRun+period from `.cron.jobs where func=job;  / could you combine these two updates in one?
    err:@[{(0b;(value x)[])};job;{(1b;x)}];   / (func x)[] -> func[x][] e.g get[x][]
    if[err 0;update error:enlist err[1] from `.cron.jobs where func=job]
 };

.cron.run:{
    j:exec func from .cron.jobs where nextRun<x;
    .cron.run1[;x] each j;
 };

.event.addHandler[`.z.ts;.cron.run];
.z.ts:.event.fire`.z.ts;

/
Don't know why you have ; at the end of function definitions
Also no need for them at end of assignments e.g. .z.ts:.event.fire`.z.ts;