.boot.loadLib`cron;
.boot.loadSchemas[];

.u.w:`trade`quote`ohlc!"iii"$\:();

.u.sub:{[t] 
    $[`=t;
        .u.w:distinct each .u.w,\:.z.w;
        11h=type t;
        .z.s each t;
        .u.w[t]:distinct .u.w[t],.z.w
        ];
 }

.u.upd:{[t;x] 
    a:flip cols[t]!x;
    .u.pub[t;a];
 }

.u.pub:{[t;data]
    neg[.u.w[t]]@\:(`upd;t;data);       / oen liner, no need for square brackets in .u.w[t]
 }

.u.del:{[x] 
    .u.w:.u.w except 'x}            / can be a one liner

.u.endofday:{neg[distinct raze .u.w]@\:(`.u.end;.z.d)}

.cron.add[`.u.endofday;`timestamp$1+.z.d;24:00:00];

.event.addHandler[`.z.pc;.u.del];

.z.pc:.event.fire`.z.pc

/ .cron.run fires off .z.ts -- without a timer .u.endofday never runs
\t 1000

/
Hard coding table names when assigning .u.w is a definite no-no