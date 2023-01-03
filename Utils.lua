
local pairs <const> = pairs
local ipairs <const> = ipairs

local rand <const> = math.random
local type <const> = type

local Utils <const> = {}
Utils.__index = Utils

_ENV = Utils


--fill in the given table with the given val.
--val can be either a single valule or a callback function.
--stop is the index to stop in. default is the lenght of table.
--start is index to start at. default is 1.
--incr is the increment value for each iteration. default is 1.
--returns table after filling it in.
function Utils:fillTbl(tbl,val,stop,start,incr)
    local startI <const> = start and start or 1
    local stopI <const> = stop and stop or #tbl
    local tblIncr <const> = incr and incr or 1
    local func <const> = type(val) == "function" and function(i,v) v[i] = val(i,v); return i,v end or
        function(i,v)v[i] = val; return i,v end
    return self:genericILoop(tbl,startI,stopI,tblIncr,func)
end


--return a copy of the given table.
function Utils:copyTbl(tbl)
    local tblCpy <const> = {}
    for i=1,#tbl,1 do
        tblCpy[i] = tbl[i]
    end
    return tblCpy
end

--return a table which is a shuffled version of the provided table.
function Utils:randShuffleNewTbl(tbl)
    local newTbl <const> = self:copyTbl(tbl)
    return self:randShuffle(newTbl)
end


--shuffle a table in place. returns same table after it has been shuffled.
function Utils:randShuffle(tbl) 
    self:genericILoop(tbl,#tbl,1,-1,
        function(index,value) 
            local newI <const> = rand(#value)
            local temp <const> = value[index]
            value[index] = value[newI]
            value[newI] = temp
            return i,value
    end)
    return tbl
end


function Utils:genericIJLoop(values,startI,stopI,incI,startJ,stopJ,incJ,iFunc,jFunc)
    for i=startI,stopI,incI do
        i,values = iFunc(i,values)
        for j=startJ,stopJ,incJ do
            i,j,values = jFunc(i,j,values)
        end
    end
    return values
end

function Utils:genericILoop(values,startI,stopI,incI,iFunc)
    for i=startI,stopI,incI do
        i,values = iFunc(i,values)
    end
    return values
end

function Utils:genericIPairs(values,tbl,func)
    for i,v in ipairs(tbl) do
        values = func(i,v,tbl,values)
    end
    return values
end

function Utils:genericPairs(values,tbl,func)
    for k,v in pairs(tbl) do
        values = func(k,v,tbl,values)
    end
    return values
end

return Utils

