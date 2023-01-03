
local pairs <const> = pairs
local ipairs <const> = ipairs

local Utils <const> = {}
Utils.__index = Utils

_ENV = Utils


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

