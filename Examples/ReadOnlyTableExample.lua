
local ReadOnly = require("ReadOnlyTable")

local tbl = {x = 5, y = 6}
local tbl2 = {z = 7}
--set a value inside of tbl to a table.
tbl.tbl2 = tbl2
--return a read only version of tbl.
local readOnlyTbl = ReadOnly(tbl)
io.write("we can read values. x in readOnlyTbl is: ",readOnlyTbl.x,"\n")
io.write("read only is shallow, so values in objects inside of table can be modified.\n")
tbl.tbl2.z = 8
io.write("the new tbl2.z value is: ",tbl.tbl2.z,"\n")
io.write("now we attempt to modify a value in readOnlyTbl\n")
readOnlyTbl["x"] = 7