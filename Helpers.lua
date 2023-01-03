--Single file containing all the Helper Modules.  returna key/value table containing the modules.

local getmetatable <const> = getmetatable
local setmetatable <const> = setmetatable
local type     <const> = type
local sort     <const> = table.sort
local pairs    <const> = pairs
local tostring <const> = tostring
local concat   <const> = table.concat
local error    <const> = error
local open     <const> = io.open
local gmatch   <const> = string.gmatch
local pairs    <const> = pairs
local ipairs   <const> = ipairs
local rand     <const> = math.random
local match    <const> = string.match
local gsub     <const> = string.gsub
local rep      <const> = string.rep
local unpack   <const> = table.unpack


local Helpers <const> = {}
Helpers.__index = Helpers

_ENV = Helpers

--module for converting a table to a string. 

local TableToString <const> = {}
TableToString.__index = TableToString

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
function TableToString:tableValuesToString(t,del)
    return tableValuesOnly(t,del and del or ",")
end

--convert both key and values in a table to string.use del as the delimiter for key:values.
function TableToString:tableKeyValuesToString(t,del)
    return tableKeyValues(t,del and del or ",")
end


local PrintableTable = {}

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
           __tostring  = function() return TableToString:tableKeyValuesToString(t) end,
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

--set a table to be read only.
local ReadOnlyTable <const> = {}

function ReadOnlyTable:readOnly(t)
    return setmetatable({},{
        __index    = t,
        --custom method for inserting new items/updating existing items.
        __newindex = function(_,k,v)
                    error("attempt to update read only table",2)
                end,
        __len = function() return #t end,
        __metatable = false
        })
end

local ReadFile <const> = {}

local function makeKeyValue(match,t,keyPat,valuePat)
    local key = match:match(keyPat)
    local value = match:match(valuePat)
    t[key] = value
end

local function getContents(file,pat,readOnly,keyValue,keyPat,valuePat)
    local tbl = {}
    local makeValue =  keyValue and function(match,t) makeKeyValue(match,t,keyPat,valuePat)  end or function(match,t) t[#t + 1] = match end
    for match in gmatch(file:read("a*"),pat) do
        makeValue(match,tbl)
    end
    return readOnly and ReadOnlyTable:readOnly(tbl) or tbl
end

--read a file and put the contents into a table.
--table is parsed based on pat.
--if readonly is true then make resulting table a readOnly table.
--if keyValue is true then file is treated as a list of key value pairs.
--if text is a list of key,value pairs then keyPat is pattern to find the keys.
--if text is a list of key,value pairs then valuePat is pattern to find the values.
function ReadFile:new(filePath,pat,readOnly,keyValue,keyPat,valuePat)
    if not filePath then error("filepath is nil\n") end
    local file = open(filePath,"r")
    if not file then error("could not open file at: "..filePath .. "\n") end
    local contents = getContents(file,pat,readOnly,keyValue,keyPat,valuePat)
    file:close()
    return contents
end

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

local StringLib <const> = {}
StringLib.__index = StringLib

--pattern of a word
local wordsMatch <const> = "[^_,.;:\"\'?!%s\n\r/]+"

--pattern to match word surrounded by punctuation or space characters.
local wordPat <const> = "[_.,:;\"\'?!%s/]*(" .. wordsMatch .. ")[/_.,:;\"\'?!%s\n\r]+"

_ENV = StringLib


--get a random word from a string or table of words.
--if param is a string it is first converted to a table of words.
--each time it is called it grabs a word at random from the table, so repeated values are expected.
function StringLib:getRandom(str)
	local words <const> = (type(str) == "string" and StringLib:getWordsTbl(str)) or (type(str) == "table" and str)
	return function()
		return words[rand(1,#words)]
	end
end


--get a unique random word from a string or a table of words
--if param is string then first convert it to a table of words.
--if rollOver is true then once all the words in the original table of words have been used, the word table is reshuffled and is used again.
--if rollOver is false or nil then after all words have been used up all subsequent calls will return an empty string.
function StringLib:getUniqueRandom(str,rollOver)
	local words <const> = (type(str) == "string" and StringLib:getWordsTbl(str)) or (type(str) == "table" and Utils:copyTbl(str) )
	local shuffle = Utils:randShuffle(words)
	return function()
		if #shuffle == 0 then
			if rollOver then
				shuffle = randShuffle(words)
			else
				return ""
			end
		end
		local word <const> = shuffle[#shuffle]
		shuffle[#shuffle] = nil
		return word
	end
end

--return table containing all words from the string.
-- word is defined as group of any non space or non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.
function StringLib:getWordsTbl(str)
	return StringLib:strToTbl(str,wordsMatch)
end

--grab the nth word from the string.
function StringLib:grabWord(str,n)
	local pat <const> = "^%s*" .. rep("[%w%-]+[%s%p]*",n - 1) .. "([%w%-]+)"
	return match(str,pat)
end

--get the character at position i.
function StringLib:charAt(str,n)
    local pat <const> = "^" .. rep(".",n - 1) .. "(.)"
    return match(str,pat)
end

--grab the first word in the string.
--word is defined as group of any non space and non punctuation characters, except hyphen, which is surrounded by space or punctuation characters.
function StringLib:firstWord(str)
	return match(str,wordPat)
end

function StringLib:lastWord(str)
	return match(str,"%s([%w%-]+)%p?$")
end

--function to replace all multi-spaces with a single space.
function StringLib:squishSpaces(str)
	return gsub(str,"  +"," ")
end

--trim space from front and rear of string.
function StringLib:trim(str)
	return StringLib:trimSpaceRear(StringLib:trimSpaceFront(str))
end

--trim space from the rear of a string.
function StringLib:trimSpaceRear(str)
	return match(str,"^(.-)%s*$")
end

--trim space from the front of a string.
function StringLib:trimSpaceFront(str)
	return match(str,"^%s*(.+)$")
end

--convert a string to a table.
--use patter to set each index or if nil then each index is one character from the string.
--if sep isnt nil then append it to the end of each index in table..
function StringLib:strToTbl(str,pat,sep)
	local t <const> = {}
	local pattern <const> = pat and pat or "."
	local add <const> = sep and function(char) t[#t + 1] = char .. sep end or function(char) t[#t + 1] = char end
	for char in str:gmatch(pattern) do
		add(char)
	end
	return t
end

--returns true if string is nil or contains only spaces.
function StringLib:isEmpty(str)
   return str == nil or self:trim(str) == ""
end

local function split(str,pat,i)
    local pattern = "(" .. rep(pat,i) .. ")(.*)"
    return match(str,pattern)
end

--split string at position i.
function StringLib:splitAt(str,i)
    return split(str,".",i)
end

--split string at the nth word. if include is true then first string includes split word.
function StringLib:splitAround(str,n,include)
    local i <const> = include and n or n -1
    return split(str,"[%s%p]*[%w%-]+[%s%p]*",i)
end

--split string at first instance of the word. if include is true then split string contains word.
function StringLib:splitAtWord(str,word,include)
    local pat <const> = include and "(.-" .. word .. ")(.*)" or "(.-)" .. word .. "(.*)"
    return match(str,pat)
end

--split string on each occurrence of the word.
function StringLib:splitByWord(str,word,whence,include)
    local pat <const> = (whence == "after" and include and "(.-".. word .. ")%s*" or "(.-)".. word .. "%s*") or
            (whence == "before" and include and "(.-)".. word .. "%s*")
    local tbl <const> = self:strToTbl(str,pat)
    tbl[#tbl + 1] = match(str,"^.+"..word.."%s*(.-)$")
    return unpack(tbl)
end

--place a % in front of special regex chars.
local function sanitize(str)
	local str1 <const> = str:gsub("([+%-%%%(%)%[%]%*%.%^%$])","%%%1")
	return str1

end

--format str by using substituting values from the key/values of the given table.
function StringLib:format(str,formatters)
	for search,sub in pairs(formatters)do
		str = str:gsub("%${?"..sanitize(search).."}?",sub)
	end
	return str
end

--pad front of given str with char to given length
function StringLib:padFront(str,char,n)
	if #str >= n then return str end
	return rep(char,n - #str) .. str
end

--pad back of string with given char to the given length
function StringLib:padBack(str,char,n)
	if #str >= n then return str end
	return str .. rep(char,n - #str)
end

local function tableIter(tbl,i)
	i = i + 1
	if tbl[i] then return i,tbl[i] end
end

-- iterate over each character in str.
function StringLib:charIter(str)
	local tbl <const> = self:strToTbl(str)
	return  tableIter,tbl,0
end

--iterate over each word in str.
function StringLib:wordIter(str)
	local tbl <const> = self:strToTbl(str,"(%w*%p*)%s*")
	return  tableIter,tbl,0
end

Helpers["StringLib"]      = StringLib
Helpers["Utils"]          = Utils
Helpers["PrintableTable"] = setmetatable(PrintableTable,{__index = PrintableTable, __call = PrintableTable.printableTable})
Helpers["ReadFile"]       = setmetatable(ReadFile,{__index = ReadFile,__call = ReadFile.new})
Helpers["ReadOnlyTable"]  = setmetatable(ReadOnlyTable,{__index = ReadOnlyTable,__call = ReadOnlyTable.readOnly})
Helpers["TableToString"]  = TableToString

return Helpers

