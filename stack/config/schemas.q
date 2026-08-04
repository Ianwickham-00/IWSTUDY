trade:flip`time`sym`size`price`exchange!"psjfs"$\:()
quote:flip`time`sym`bid`ask`bidSize`askSize`exchange!"psffjjs"$\:()
/ unkeyed: rdb appends these and .Q.dpft cannot write a keyed table.
/ CEP keys its own local copy, which is where the merge needs it.
ohlc:flip`sym`barTime`o`h`l`c!"spffff"$\:();

/
This is fine for a simple project
csv based is a little more robust