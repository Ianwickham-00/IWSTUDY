.boot.loadLib`cron;
.boot.loadSchemas[];

.u.w:tables[`]!count[tables`]#enlist`int$()

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

.u.pub:{[t;data] neg[.u.w t]@\:(`upd;t;data)}

.u.del:{[x] .u.w:.u.w except\:x}

.u.endofday:{neg[distinct raze .u.w]@\:(`.u.end;.z.d)}

.cron.add[`.u.endofday;`timestamp$1+.z.d;24:00:00];

.event.addHandler[`.z.pc;.u.del]

.z.pc:.event.fire`.z.pc

/ .cron.run fires off .z.ts -- without a timer .u.endofday never runs
\t 1000
