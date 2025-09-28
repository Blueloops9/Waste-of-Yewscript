local loadyewscript = require("yewscript")


local Code = "printhello world!"

local Time = os.clock()
local Yewscript = loadyewscript(Code)
print("Compile: ",os.clock()-Time)
local Time = os.clock()
Yewscript()
print("Execution:",os.clock()-Time)
