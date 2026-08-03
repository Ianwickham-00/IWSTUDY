.event.handlers:enlist[`]!();
.event.addHandler:{[event;handler] .event.handlers[event]:distinct .event.handlers[event],handler};
.event.fire:{[event;x] .event.handlers[event]@\:x};
