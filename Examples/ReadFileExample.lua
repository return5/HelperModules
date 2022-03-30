local ReadFile = require("ReadFile")

--read a file and return a table where each index is a line from the file.
--we pass int eh file to read, the pattern which tells the reader how to parse each line, and true to make it a readonly table.
local f = ReadFile("test.txt",".-[\n\r]+",true)

--print out each line from the table
for _,v in ipairs(f) do
    io.write("v is: ",v)
end

--read a file of key/value pairs. set readonly ot false and keyValue to true. pass in key and value patterns.
local kv = ReadFile("test2.txt",".-[\n\r]+",false,true,"([^ ]+)%s+=","=%s+([^\n\r,]+)")

--print out the key value pairs
for k,v in pairs(kv) do
    io.write("key is: ",k," value is: ",v,"\n")
end


