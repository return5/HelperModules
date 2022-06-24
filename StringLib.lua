local match  = string.match
local gsub   = string.gsub
local rand   = math.random
local type   = type
local rep    = string.rep
local unpack = table.unpack
local pairs  = pairs
local io = io

local StringLib  = {}
StringLib.__index = StringLib

--pattern of a word
local wordsMatch = "[^_,.;:\"\'?!%s\n\r/]+"

--pattern to match word surrounded by punctuation or space characters.
local wordPat	= "[_.,:;\"\'?!%s/]*(" .. wordsMatch .. ")[/_.,:;\"\'?!%s\n\r]+"

_ENV = StringLib


--get a random word from a string or table of words.
--if param is a string it is first converted to a table of words.
--each time it is called it grabs a word at random from the table, so repeated values are expected.
function StringLib:getRandom(str)
	local words = (type(str) == "string" and StringLib:getWordsTbl(str)) or (type(str) == "table" and str)
	return function()
		return words[rand(1,#words)]
	end
end

--get a table which has been randomly shuffled.
local function randShuffle(words)
	local shuff = {}
	local prevI = {}
	for i=1,#words,1 do
		local j
		repeat
			j = rand(1,#words)
		until(not prevI[j])
		prevI[j] = true
		shuff[j] = words[i]
	end
	return shuff
end

--get a unique random word from a string or a table of words
--if param is string then first convert it to a table of words.
--if rollOver is true then once all the words in the original table of words have been used, the word table is reshuffled and is used again.
--if rollOver is false or nil then after all words have been used up all subsequent calls will return an empty string.
function StringLib:getUniqueRandom(str,rollOver)
	local words   = (type(str) == "string" and StringLib:getWordsTbl(str)) or (type(str) == "table" and str)
	local shuffle = randShuffle(words)
	return function()
		if #shuffle == 0 then
			if rollOver then
				shuffle = randShuffle(words)
			else
				return ""
			end
		end
		local word = shuffle[#shuffle]
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
	local pat = "^%s*" .. rep("[%w%-]+[%s%p]*",n - 1) .. "([%w%-]+)"
	return match(str,pat)
end

--get the character at position i.
function StringLib:charAt(str,n)
    local pat = "^" .. rep(".",n - 1) .. "(.)"
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
	local t = {}
	local pattern = pat and pat or "."
	local add = sep and function(char) t[#t + 1] = char .. sep end or function(char) t[#t + 1] = char end
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
    local i = include and n or n -1
    return split(str,"[%s%p]*[%w%-]+[%s%p]*",i)
end

--split string at first instance of the word. if include is true then split string contains word.
function StringLib:splitAtWord(str,word,include)
    local pat = include and "(.-" .. word .. ")(.*)" or "(.-)" .. word .. "(.*)"
    return match(str,pat)
end

--split string on each occurrence of the word.
function StringLib:splitByWord(str,word,whence,include)
    local pat = (whence == "after" and include and "(.-".. word .. ")%s*" or "(.-)".. word .. "%s*") or
            (whence == "before" and include and "(.-)".. word .. "%s*")
    local tbl = self:strToTbl(str,pat)
    tbl[#tbl + 1] = match(str,"^.+"..word.."%s*(.-)$")
    return unpack(tbl)
end

--place a % in front of special regex chars.
local function sanitize(str)
	local str1 = str:gsub("([+%-%%%(%)%[%]%*%.%^%$])","%%%1")
	return str1

end

--format str by using substituting values form the key/values of the given table.
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
	local tbl = self:strToTbl(str)
	return  tableIter,tbl,0
end

--iterate over each word in str.
function StringLib:wordIter(str)
	local tbl = self:strToTbl(str,"(%w*%p*)%s*")
	return  tableIter,tbl,0
end

return StringLib
