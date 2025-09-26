local function loadyewscript(Code)
    local function split(Str,Sep)
        local Out,Length = {},1
        for I in string.gmatch(Str,"([^"..Sep.."]+)") do Out[Length]=I Length=Length+1 end
        return Out
    end

    local CurrentLine=1
    local DoRun = true

    local ifinit,Index={},1
    local ForBuffer,IfBuffer,ElseBuffer,EndBuffer={},{},{},{}

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
        ["Length'"]=function(Variable) return {#tostringyew(Variables[Variable])} end,
        ["Size'"]=function(Data)
            local VariableList,Location = GetValue(Data)
            return {#VariableList[Location]}
        end,
        ["Abs"]=function(Data)return {math.abs(Variables[Data][1])} end,
        ["Acos"]=function(Data)return {math.acos(Variables[Data][1])} end,
        ["Asin"]=function(Data)return {math.asin(Variables[Data][1])} end,
        ["Atan"]=function(Data)return {math.atan(Variables[Data][1])} end,
        ["Cos"]=function(Data)return {math.cos(Variables[Data][1])} end,
        ["Cosh"]=function(Data)return {math.cosh(Variables[Data][1])} end,
        ["Deg"]=function(Data)return {math.deg(Variables[Data][1])} end,
        ["Rad"]=function(Data)return {math.rad(Variables[Data][1])} end,
        ["Sin"]=function(Data)return {math.sin(Variables[Data][1])} end,
        ["Sinh"]=function(Data)return {math.sinh(Variables[Data][1])} end,
        ["Tan"]=function(Data)return {math.tan(Variables[Data][1])} end,
        ["Tanh"]=function(Data)return {math.tanh(Variables[Data][1])} end,
        --["Btan"]=function(Data)return {math.atan2(Variables[Data][1])} end,
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
        ["^"]=function(A,B)
            local Variable = IsVariable(B)local Keyword = IsKeyword(B)
            if Keyword then
                local KeywordReference,Split = Keywords[Keyword],split(B,"'")[2]
                if Split then 
                local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]^KeywordReference()[List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]^KeywordReference()[1] end end
            elseif Variable then
                local Split = split(B,"'")[2]
                if Split then local List,Loc=GetValue(Split)return function()Variables[A][1]=Variables[A][1]^Variables[Variable][List[Loc]] end
                else return function()Variables[A][1]=Variables[A][1]^Variables[Variable][1] end end
            else local E=tonumber(B)E=(E==nil and B or E) return function()Variables[A][1]=Variables[A][1]^E end
            end
        end,
    }
    local LogicOperations={
        ["="]=function(A,B,C,D,Line)return function()
            if tostringyew(A[B])~=tostringyew(C[D]) then CurrentLine=IfBuffer[Line][2]end
        end end,
        ["!"]=function(A,B,C,D,Line)return function()
            if tostringyew(A[B])==tostringyew(C[D]) then CurrentLine=IfBuffer[Line][2]end
        end end,
        [">"]=function(A,B,C,D,Line)return function()
            if not (A[B][1]>C[D][1]) then CurrentLine=IfBuffer[Line][2]end
        end end,
        ["<"]=function(A,B,C,D,Line)return function()
            if not (A[B][1]<C[D][1]) then CurrentLine=IfBuffer[Line][2]end
        end end,
        ["}"]=function(A,B,C,D,Line)return function()
            if not (A[B][1]>=C[D][1]) then CurrentLine=IfBuffer[Line][2]end
        end end,
        ["{"]=function(A,B,C,D,Line)return function()
            if not (A[B][1]<=C[D][1]) then CurrentLine=IfBuffer[Line][2]end
        end end,
        ["]"]=function(A,B,C,D,Line)return function()
            if tostringyew(A[B]):find(tostringyew(C[D])) ~= -1 then CurrentLine=IfBuffer[Line][2]end
        end end,
        ["["]=function(A,B,C,D,Line)return function()
            if tostringyew(A[B]):find(tostringyew(C[D])) == -1 then CurrentLine=IfBuffer[Line][2]end
        end end,
    }

    function IsVariable(String)
        for I,_ in pairs(Variables) do if String:sub(1,#I)==I then return I,#I+1 end end
        return false
    end

    function IsKeyword(String)
        for I,_ in pairs(Keywords) do if String:sub(1,#I)==I then return I,#I+1 end end
        return false
    end

    function tostringyew(Value)
        local Type = type(Value)
        if Type=="table" then return table.concat(Value,";")
        else return Value end
    end

    function GetValue(Data)
        local Keyword = IsKeyword(Data)
        if Keyword then return Keywords,Keyword
        else
            local Variable = IsVariable(Data)
            if Variable then return Variables,Variable
            else local A = tonumber(Data) return {A==nil and Data or A},1 end
        end
    end

    function IsInstruction(String)
        for I,V in ipairs(InstructionArray) do if String:sub(1,#V)==V then return V,#V+1 end end
        return false
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
        ["reset"]=function()return function()
            ForBuffer={}
            CurrentLine=0
            for I,_ in Variables do Variables[I]=0 end
        end end,
        ["for"]=function(Data)return function()
            ForBuffer[#ForBuffer+1] = {1,#Variables[Data],Variables[Data],CurrentLine}
            local a = Variables[Data][1]
            Variables.Z={tonumber(a)==nil and a or tonumber(a)}
        end end,
        ["endloop"]=function()return function()
            local Loop = ForBuffer[#ForBuffer]
            Loop[1]=Loop[1]+1
            if Loop[1]<=Loop[2] then 
                local a = Loop[3][Loop[1]]
                Variables.Z = {tonumber(a)==nil and a or tonumber(a)}
                CurrentLine=Loop[4]
            else    
                table.remove(ForBuffer,#ForBuffer)
            end
        end end,
        ["if"]=function(Data)
            ifinit[#ifinit+1] = Index

            for I,V in pairs(LogicOperations) do
                local Split = split(Data,I)
                if Split[2] then
                    local A,B = GetValue(Split[1])
                    local C,D = GetValue(Split[2])
                    --print(A,B,C,D,Index)
                    return V(A,B,C,D,Index)
                end
            end
        end,
        ["else"]=function()
            local Loc = ifinit[#ifinit]
            IfBuffer[Loc]={Index,Index}
            return function()
                CurrentLine=IfBuffer[Loc][1]
            end
        end,
        ["end"]=function()
            if IfBuffer[ifinit[#ifinit]] then IfBuffer[ifinit[#ifinit]][1]=Index
            else IfBuffer[ifinit[#ifinit]]={Index,Index}end
            table.remove(ifinit,#ifinit)
            return function() end
        end,
    }
    InstructionArray={}
    for I,_ in pairs(Instructions) do InstructionArray[#InstructionArray+1] = I end
    table.sort(InstructionArray,function(a,b)return #a>#b end)-- Longest instruction gets checked first

    local Program={}

    Code = table.concat(split(Code,"\n"))

    for I,V in pairs(split(Code,"/")) do
        local First = V:sub(1,1)
        if V == "" then error("error at line "..I..": line cannot be empty!") end
        if First~="-" then
            local Instruction,Start = IsInstruction(V)
            if Instruction then
                Program[#Program+1] = Instructions[Instruction](V:sub(Start))
            else
                local Variable,Start = IsVariable(V)
                if Variable then
                    Program[#Program+1] = Operations[V:sub(Start,Start)](Variable,V:sub(Start+1))
                end
            end
        else
            Program[#Program+1] = function() end
        end
        Index=Index+1
    end
    
    local Length = #Program
    return function()
        while DoRun do if CurrentLine>Length then break end  Program[CurrentLine]()CurrentLine=CurrentLine+1 end
    end
end

local String=[[A=1/B=1/ifA>B/printA/else/print-1/end]]

local Time = os.clock()
local YewScript = loadyewscript(String)
print("Time to compile: ",os.clock()-Time)
Time = os.clock()
YewScript()
print("Excecuted in "..os.clock()-Time.." seconds.")