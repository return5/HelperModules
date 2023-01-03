
local Utils <const> = require('Utils')

local tbl <const> = {1,2,3,4,5}

Utils:genericILoop(tbl,1,#tbl,1,function(i,t) t[i] = t[i] + 1; return i,tbl end)

Utils:genericIPairs(nil,tbl,function(i,v,t,val) io.write("i is: ",i," value is: ",v,"\n"); return val end)



