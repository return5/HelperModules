local Logger = require("Logger")

Logger:setFile("test_log.txt")
log = Logger:new("loggingExample")

local function testFunction(x)
    log:startMethod("testFunction")
    --print out info for method
    log:info("testFunction","x is: "..x)
    --log an error
    log:err("testFunction","test error")
    log:endMethod("testFunction")
end

testFunction(5)
Logger:close()