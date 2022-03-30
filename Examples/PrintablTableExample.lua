local Printable = require("PrintableTable")

local tbl = Printable({})

--when inserting keys insertion order is preserved when using pairs.
tbl["x"] = 5
tbl["y"] = 6
tbl["z"] = 7
tbl["a"] = 8
tbl["b"] = 9

--since tbl is PrintableTable this pairs method runs in insertion order of keys.
for k,v in pairs(tbl) do
    io.write("key is: ",k," value is: ",v,"\n")
end

--we can add some value to the array part.
tbl[1] = 1
tbl[2] = 2
tbl[3] = 3
tbl[5] = 5
tbl[8] = 8

io.write("after inserting into the array part of tbl\n")

--pairs will print first array part, then the keys which are in insertion order.
for k,v in pairs(tbl) do
    io.write("key is: ",k," value is: ",v,"\n")
end

io.write("printing table using tostring method.\n")
--print will call the TableToString method to convert it ot a string then print it. doesnt preserve insertion order.
print(tbl)