local StrLib = require("StringLib")


local str = "   hello   world  how   are   you?  I am  fine, thanks. hello\n "
local hidden = ".,_'hello,. >!_"
io.write("str after removing space in front: ",StrLib:trimSpaceFront(str),"\n")
io.write("str after removing space in rear: ",StrLib:trimSpaceRear(str),"\n")
io.write("str after removing front and rear spaces: ",StrLib:trim(str),"\n")
io.write("str after squishing spaces: ",StrLib:squishSpaces(str),"\n")
io.write("word in hidden is: ",StrLib:firstWord(hidden),"\n")
io.write("word count in str is: ",#StrLib:getWordsTbl(str),"\n")

math.randomseed(os.time())
io.write("\ngrabbing 12 random words from str: ")
local rand = StrLib:getRandom(str)
for i=1,12,1 do
	io.write("random word is: ",rand(),"\n")
end

io.write("\ngrabbing 12 unique random words from str with no roll over: ")
local uniqueRand = StrLib:getUniqueRandom(str,false)
for i=1,12,1 do
	io.write("unique random word is: ",uniqueRand(),"\n")
end


local strToFormat = "i like ${C++}, i do not like $lua."
io.write("after formatting: ",StrLib:format(strToFormat,{lua = "C++",["C++"] = "lua"}),"\n")

local strToSplit = "This string will split into two string."
local str1,str2 = StrLib:splitAtWord(strToSplit,"split",true)
io.write("str1: ",str1,"\n")
io.write("str2: ",str2,"\n")


io.write("iterating over each character in string.\n")
for i,char in StrLib:charIter("hello, world!") do
	io.write("char ",i," is: ",char,"\n")
end
