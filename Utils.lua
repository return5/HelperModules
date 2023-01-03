
local pairs <const> = pairs
local ipairs <const> = ipairs

local rand <const> = math.random
local type <const> = type

local Utils <const> = {}
Utils.__index = Utils

_ENV = Utils


function Utils:fillTbl(tbl,val,stop,start,incr)
    local startI <const> = start and start or 1
    local stopI <const> = stop and stop or #tbl
    local tblIncr <const> = incr and incr or 1
    local func <const> = type(val) == "function" and function(i,v) v[i] = val(i,v); return i,v end or
        function(i,v)v[i] = val; return i,v end
    return self:genericILoop(tbl,startI,stopI,tblIncr,func)
end

function Utils:copyTbl(tbl)
    local tblCpy <const> = {}
    for i=1,#tbl,1 do
        tblCpy[i] = tbl[i]
    end
    return tblCpy
end

function Utils:randShuffleNewTbl(tbl)
    local newTbl <const> = self:copyTbl(tbl)
    return self:randShuffle(newTbl)
end

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

