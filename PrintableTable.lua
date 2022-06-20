--module for creating tables with a custom pairs method and custom tostring method.
local TableToString = require("TableToString")

local PrintableTable = {}

local setmetatable = setmetatable
local type = type
local sort = table.sort

_ENV = PrintableTable


--insert a new item into the table. 
local function newIndex(t,k,v,keyPairs,index)
    if k then 
        --if the key isnt an number then it a key to the hashtable part of table.
        if type(k) ~= "number" then
            --add the key to the end of the array of hashtable key.
            keyPairs[#keyPairs + 1] = k
        else
            --else if the key is a number then it will be part of the array part of table.
            --add array index to the end of the array of array indexes.
            index[#index + 1] = k
        end
    end
    --add key:value to table.
    t[k] = v
end

function PrintableTable:printableTable(t)
    --table to hold all non numeric keys. used for retrieving key:value pairs.
    local keyPairs = {}
    --table to hold all numeric indexes. used to retrieve value from array portion of table.
    local index    = {}
    return setmetatable({}, {
            __index    = t,
            --our custom method to handle inserting new keys or indexes.
            __newindex = function(_,k,v) newIndex(t,k,v,keyPairs,index) end,
            __len      = function() return #t end,
            --can be used to check if a table is our printable type.
           __printable = function() return true end,
           --custom tostring method.
           __tostring  = function() return TableToString.tableKeyValuesToString(t) end,
           --our custom pairs method.
           __pairs     = function() 
            local i = 1
            --make sure the list of array indexes is sorted before starting pairs.
            sort(index)
            --initally we start with the index table. we wish to sort by array part first.
            local tbl = index
            return function (_,_)         
                --if the current index is larger than table size and we are currently using the index table.
                if i > #tbl and tbl == index then
                    --switch to using the keyPairs table.
                     tbl = keyPairs
                     i   = 1
                end
                --if our table isnt empty and the index isnt larger than table size.
                if #tbl > 0  and i <= #tbl then
                    --get the key from index or keyPairs, whichever is in current use.
                    local nextKey   = tbl[i]
                    --the value comes fomr the original table, using the key form our index or keyPairs table.
                    local nextValue = t[nextKey]
                    i = i +1
                return  nextKey,nextValue
            end
            end
        end
        })
end



return setmetatable(PrintableTable,{__index = PrintableTable, __call = PrintableTable.printableTable})

