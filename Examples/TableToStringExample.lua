local TableStr = require("TableToString")

--table to be turned into a string.
local tbl = {1,2,3,4, x = 5, y = 6, z = {1,2,3},a = {g = 5, h = 7}}

--convert the entire table to a string then print it.
io.write("the entire table to be printed is: \n",TableStr.tableKeyValuesToString(tbl,","),"\n")

--convert only the values of the table and sub tables to a string then print it.
io.write("only the values of tbl are: \n",TableStr.tableValuesToString(tbl,","),"\n")