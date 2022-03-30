local StrLib = require("StringLib")

local str = "   hello world  how are   you?I am  fine, thanks. hello\n "
local hidden = ".,_'hello,. >!_"
io.write("str after removing space in front: ",StrLib.trimSpaceFront(str))
io.write("str after removing space in rear: ",StrLib.trimSpaceRear(str))
io.write("str after removing front and rear spaces: ",StrLib.trim(str))
io.write("str after squishing spaces: ",StrLib.squishSpaces(str))
io.write("word in hidden is: ",StrLib.word(hidden),"\n")
io.write("word count in str is: ",#StrLib.getWords(str),"\n")

math.randomseed(os.time())
io.write("\ngrabbing 12 random words from str: ")
local rand = StrLib.getRandom(str)
for i=1,12,1 do
    io.write("random word is: ",rand(),"\n")
end

io.write("\ngrabbing 12 unique random words from str with no roll over: ")
local uniqueRand = StrLib.getUniqueRandom(str,false)
for i=1,12,1 do
    io.write("unique random word is: ",uniqueRand(),"\n")
end

