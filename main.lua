local function loadyewscript(Code)
    local function split(Str,Sep)
        local Out,Length = {},1
        for I in string.gmatch(Str,"([^"..Sep.."]+)") do Out[Length]=I Length=Length+1 end
        return Out
    end

    local CurrentLine=1
    local DoRun = true

    local Variables={
        A={0},B={0},C={0},D={0},E={0},
        F={0},G={0},H={0},I={0},J={0},
        K={0},L={0},M={0},N={0},O={0},
        P={0},Q={0},R={0},S={0},T={0},
        U={0},V={0},W={0},X={0},Y={0},Z={0},
    }
    local Keywords={
        ["Rand"]=math.random,
        ["Time"]=os.clock,
        ["Self"]=function()return Code end,
        ["Year"]=function()return 0 end,
        ["Port"]=function()return 0 end,
        ["Buffer"]=function(Channel)return 0 end,
        ["RealTime"]=os.time,
        ["Length"]=function(Variable) end,
    }

    local Operations={
        ["="]=function(A,B)
            local Variable = IsVariable(B)
            local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")
                return function()Variables[A]={KeywordReference()} end
            elseif Variable then
                local BReference,Split = Variables[Variable],split(B,"'")
                return function()Variables[A]=BReference end
            else
                return function()Variables[A]={B} end
            end
        end,
        ["+"]=function(A,B)

        end,
    }

    function IsVariable(String)
        for I,_ in pairs(Variables) do if String:sub(1,#I)==I then return I,#I+1 end end
        return false
    end

    function IsKeyword(String)
        for I,_ in pairs(Keywords) do if String:sub(1,#I)==I then return I,#I+1 end end
        return false
    end

    local function tostringyew(Value)
        local Type = type(Value)
        if Type=="table" then return table.concat(Value,",")
        else return Value end
    end

    function GetValue(VariableKeywordDatatype)
        
    end

    local Instructions={
        ["goto"]=function(line)
            
        end,
        ["beep"]=function(pitch)
            
        end,
        ["print"]=function(VariableKeywordDatatype)
            local Variable = IsVariable(VariableKeywordDatatype)
            if Variable then
                local Split = split(VariableKeywordDatatype,"'")
                if Split[2] then

                else
                    return function()print(tostringyew(Variables[Variable])) end
                end
            else
                local Keyword,Start = IsKeyword(VariableKeywordDatatype)
                if Keyword then

                else
                    return function() print(VariableKeywordDatatype) end
                end
            end
        end,
        ["insert"]=function(Variable,Data,Position)
            local Reference = Variables[Variable]
            if Position == nil then
                
            end
        end,
    }

    local function IsInstruction(String)
        for I,_ in pairs(Instructions) do if String:sub(1,#I)==I then return I,#I+1 end end
        return false
    end

    local Program={}

    for _,V in pairs(split(Code,"/")) do
        local Instruction,Start = IsInstruction(V)
        if Instruction then
            print(Instruction,V:sub(Start))
            Program[#Program+1] = Instructions[Instruction](V:sub(Start))
        else
            local Variable,Start = IsVariable(V)
            if Variable then
                print(Variable,V:sub(Start,Start))
                Program[#Program+1] = Operations[V:sub(Start,Start)](Variable,V:sub(Start+1))
            end
        end
    end
    
    local Length = #Program
    return function()
        while DoRun do if CurrentLine==Length then DoRun=false end Program[CurrentLine]()CurrentLine=CurrentLine+1 end
    end
end

local String=[[A=4/B=RealTime/printA/printB]]

local Time = os.clock()
local YewScript = loadyewscript(String)
print("Time to compile: ",os.clock()-Time)
Time = os.clock()
YewScript()
print("Excecuted in "..os.clock()-Time.." seconds.")