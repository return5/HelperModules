local ReadOnly      = require("ReadOnlyTable")
local TableToString = require("TableToString")

local Logger = {}
Logger.__index = Logger
Logger.__call = Logger.new

local open   = io.open
local date   = os.date
local concat = table.concat
local rep    = string.rep
local setmetatable = setmetatable

_ENV = Logger

--file which logger writes to
local file       = ""
--number of tabs to print
local tabs       = -1
--previous number of tabs
local prevTabs   = -1
--table to use to construct start method string
local startTable  = {"",""," ::: ",""," ::: starting ::: ","", "\n" }
--table to use to create end method string
local endTable    = {"",""," ::: ",""," ::: ending   ::: ","", "\n" }
--table to use to create string for info function
local infoTable   = {"",""," ::: ",""," ::: ",""," ::: info ::: ","", "\n" }
--table to create string for error method
local errTable    = {"","\n\n==== Start Error ==== ",""," ::: ",""," ::: ","","\n\n","", "\n\n=== End Error ===\n\n" }

--table of index values. values are used when creating a string from tables.
local indexTable = ReadOnly({
    start  = ReadOnly({tabIndex = 1, dateIndex = 2,nameIndex = 4,methodIndex = 6}),
    ending = ReadOnly({tabIndex = 1, dateIndex = 2,nameIndex = 4,methodIndex = 6}),
    info   = ReadOnly({tabIndex = 1, dateIndex = 2,nameIndex = 4,methodIndex = 6,strIndex = 8}),
    err    = ReadOnly({tabIndex = 1, dateIndex = 3,nameIndex = 5,methodIndex = 7,strIndex = 9})
})

--create a string from table.
--t is table to use.
--name is name if program.
--method is method which called logger method.
--indexes is index table to use.
--str is optional string to print along with table.
local function createString(t,name,method,indexes,str)
    if indexes == indexTable["starting"] and prevTabs ~= tabs then
        t[indexes["tabIndex"]] = "\n" .. rep("\t",tabs) 
    else
        t[indexes["tabIndex"]] = rep("\t",tabs)
    end
    t[indexes["dateIndex"]]   = date("%b-%d-%y_%X")
    t[indexes["nameIndex"]]   = name
    t[indexes["methodIndex"]] = method
    if indexes["strIndex"] then t[indexes["strIndex"]] = str end
    return concat(t)
end

--set the file which logger will print to.
function Logger:setFile(f)
    file = open("logs/"..date("%b-%d-%y_%X") .. ":::" .. f,"a+")
end

--set the name of the program which is using logger.
function Logger:new(name)
    return setmetatable({name = name},Logger)
end

--log the start of a method.
function Logger:startMethod(methodName)
    tabs = tabs + 1
    file:write(createString(startTable,self.name,methodName,indexTable["start"]))
end

--log the end of a method.
function Logger:endMethod(methodName)
    file:write(createString(endTable,self.name,methodName,indexTable["ending"]))
    prevTabs = tabs
    tabs     = tabs > 0 and tabs - 1 or 0
end

--log both start and end of a method at once.
function Logger:startAndEndMethod(methodName)
    self:startMethod(methodName)
    self:endMethod(methodName)
end

--log a string of information.
function Logger:info(methodName,str,del)
    tabs = tabs + 1
    file:write(createString(infoTable,self.name,methodName,indexTable["info"],TableToString.tableValuesToString(str,del)))
    tabs = tabs > 0 and tabs - 1 or 0
end

--log an error.
function Logger:err(methodName,err)
    file:write(createString(errTable,self.name,methodName,indexTable["err"],err))
end

--close the file used for loggin.
function Logger:close()
    file:close()
end

return Logger

