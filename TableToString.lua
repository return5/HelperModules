--module for converting a table to a string. 

local pairs    = pairs
local tostring = tostring
local type     = type
local concat   = table.concat
local getmetatable = getmetatable

local TableToString = {}
TableToString.__index = TableToString

_ENV = TableToString

--convert only the values in a table to string.
local function tableValuesOnly(t,del)
    if type(t) ~= "table" then return tostring(t) end
    local str = {"{"}
    for _,v in pairs(t) do
        str[#str + 1] = tableValuesOnly(v,del)
        str[#str + 1] = del
    end
    str[#str] = "}"
    return concat(str)
end

--convert both key and values in a table to string.
local function tableKeyValues(t,del)
    if type(t) ~= "table" then return tostring(t) end
    local tMT = getmetatable(t)
    local typeName = (tMT and tMT.__typeName) and tMT.__typeName() or "table" 
    local str = {typeName,":{"}
    for k,v in pairs(t) do
        local keyType = type(k)
        if keyType == "string" then
            str[#str + 1] = "["
            str[#str + 1] = k
            str[#str + 1] = "] = "
        elseif keyType == "table" then
            str[#str + 1] = "["
            str[#str + 1] = tableKeyValues(k,del)
            str[#str + 1] = "] = "
        end
        str[#str + 1] = tableKeyValues(v,del)
        str[#str + 1] = del
    end
    str[#str + (#str >2 and 0 or 1)] = "}"
    return concat(str)
end

--convert only the values in a table to string. use del as the delimiter for values.
function tableValuesToString(t,del)
    return tableValuesOnly(t,del and del or ",")
end

--convert both key and values in a table to string.use del as the delimiter for key:values.
function tableKeyValuesToString(t,del)
    return tableKeyValues(t,del and del or ",")
end

return TableToString

