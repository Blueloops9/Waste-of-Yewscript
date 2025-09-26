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
        ["Rand"]=function()return {math.random()} end,
        ["Time"]=function()return {os.clock()} end,
        ["Self"]=function()return {Code} end,
        ["Year"]=function()return {0} end,
        ["Port"]=function()return {0} end,
        ["Buffer"]=function(Channel)return {0} end,
        ["RealTime"]=function() return {os.time()} end,
        ["Length"]=function(Variable) return {0} end,
    }

    local Operations={
        ["="]=function(A,B)
            local Variable = IsVariable(B)
            local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")[2]
                if Split then 
                    local List,Loc=GetValue(Split)
                    return function()Variables[A]={KeywordReference()[List[Loc]]} end
                else return function()Variables[A]=KeywordReference() end end
            elseif Variable then
                local Split = split(B,"'")[2]
                if Split then
                    local List,Loc=GetValue(Split)
                    return function()Variables[A]={Variables[Variable][List[Loc]]} end
                else return function()Variables[A]=table.pack(table.unpack(Variables[Variable])) end end
            elseif B:find(";") then return function()Variables[A]=split(B,";") end
            else local E = tonumber(B) E=E==nil and B or E return function()Variables[A]={E} end
            end
        end,
        ["+"]=function(A,B)
            local Variable = IsVariable(B)local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")[2]
                if Split then 
                local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]+KeywordReference()[List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]+KeywordReference()[1] end end
            elseif Variable then
                local Split = split(B,"'")[2]
                if Split then local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]+Variables[Variable][List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]+Variables[Variable][1] end end
            else local E=tonumber(B)E=(E==nil and B or E) return function()Variables[A][1]=Variables[A][1]+E end
            end
        end,
        ["-"]=function(A,B)
            local Variable = IsVariable(B)local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")[2]
                if Split then 
                local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]-KeywordReference()[List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]-KeywordReference()[1] end end
            elseif Variable then
                local Split = split(B,"'")[2]
                if Split then local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]-Variables[Variable][List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]-Variables[Variable][1] end end
            else local E=tonumber(B)E=(E==nil and B or E) return function()Variables[A][1]=Variables[A][1]-E end
            end
        end,
        ["*"]=function(A,B)
            local Variable = IsVariable(B)local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")[2]
                if Split then 
                local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]*KeywordReference()[List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]*KeywordReference()[1] end end
            elseif Variable then
                local Split = split(B,"'")[2]
                if Split then local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]*Variables[Variable][List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]*Variables[Variable][1] end end
            else local E=tonumber(B)E=(E==nil and B or E) return function()Variables[A][1]=Variables[A][1]*E end
            end
        end,
        ["\\"]=function(A,B)
            local Variable = IsVariable(B)local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")[2]
                if Split then 
                local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]/KeywordReference()[List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]/KeywordReference()[1] end end
            elseif Variable then
                local Split = split(B,"'")[2]
                if Split then local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]/Variables[Variable][List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]/Variables[Variable][1] end end
            else local E=tonumber(B)E=(E==nil and B or E) return function()Variables[A][1]=Variables[A][1]/E end
            end
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
        if Type=="table" then return table.concat(Value,";")
        else return Value end
    end

    local Instructions={
        ["goto"]=function(line)
            local List,Loc = GetValue(line)
            return function()CurrentLine=List[Loc]-1 end
        end,
        ["leapto"]=function(line)
            local List,Loc = GetValue(line)
            return function()CurrentLine=CurrentLine-List[Loc]-1 end
        end,
        ["beep"]=function(pitch)
            local List,Loc = GetValue(pitch)
            return function() print("Beep!",List[Loc]) end
        end,
        ["print"]=function(VariableKeywordDatatype)
            local Keyword = IsKeyword(VariableKeywordDatatype)
            if Keyword then
                local Split = split(VariableKeywordDatatype,"'")
                if Split[2] then
                    local List,Loc = GetValue(Split[2])
                    return function()print(Keywords[Keyword]()[List[Loc]]) end
                else return function()print(tostringyew(Keywords[Keyword]()))end end
            else
                local Variable = IsVariable(VariableKeywordDatatype)
                if Variable then
                    local Split = split(VariableKeywordDatatype,"'")[2]
                    if Split then
                        local List,Loc = GetValue(Split)
                        return function()print(Variables[Variable][List[Loc]]) end
                    else return function() print(tostringyew(Variables[Variable])) end end
                else return function() print(VariableKeywordDatatype) end end
            end
        end,
        ["insert"]=function(Data)
            Data = split(Data,"'")
            
            local Variable = Data[1]
            local DatL,DatLoc = GetValue(Data[2])
            local Pos,PosLoc = GetValue(Data[3] or "")


            return function ()
                Variables[Variable][Pos[PosLoc]=="" and #Variables[Variable]+1 or Pos[PosLoc]]=DatL[DatLoc]
            end
        end,
    }

    function GetValue(Data)
        local Keyword = IsKeyword(Data)
        if Keyword then return Keywords,Keyword
        else
            local Variable = IsVariable(Data)
            if Variable then return Variables,Variable
            else local A = tonumber(Data) return {A==nil and Data or A},1 end
        end
    end

    local function IsInstruction(String)
        for I,_ in pairs(Instructions) do if String:sub(1,#I)==I then return I,#I+1 end end
        return false
    end

    local Program={}

    for _,V in pairs(split(Code,"/")) do
        if V:sub(1,1)~="-" then
            local Instruction,Start = IsInstruction(V)
            if Instruction then
                print(Instruction,V:sub(Start))
                Program[#Program+1] = Instructions[Instruction](V:sub(Start))
            else
                local Variable,Start = IsVariable(V)
                if Variable then
                    print(Variable,V:sub(Start,Start),V:sub(Start+1))
                    Program[#Program+1] = Operations[V:sub(Start,Start)](Variable,V:sub(Start+1))
                end
            end
        end
    end
    
    local Length = #Program
    return function()
        while DoRun do if CurrentLine>Length then break end  Program[CurrentLine]()CurrentLine=CurrentLine+1 end
    end
end

local String=[[A=5;2/insertA'1'1/printA]]

local Time = os.clock()
local YewScript = loadyewscript(String)
print("Time to compile: ",os.clock()-Time)
Time = os.clock()
YewScript()
print("Excecuted in "..os.clock()-Time.." seconds.")