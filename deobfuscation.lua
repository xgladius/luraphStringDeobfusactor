local Decoder = {};

function Decoder:getStringDecodedScript(script) 
    split = {}
	for c in script:gmatch"." do table.insert(split, c) end
	local lookReturn = false
	local returnFunc = "local functionPoints = {} local script = [["..script.."]]".." "
    local tempStr = ""
    local startOfFunction = 0
	for i=1, #split do
        if split[i] == " " then
            tempStr = ""
        else
            tempStr = tempStr..split[i]
        end
        if string.find(tempStr, '"') and string.find(tempStr, '\\') then
            for m=i-300, i do
                if split[m] == ")" and split[m-1] == "(" and split[m-2] == "n" then
                    startOfFunction = m - #"(function(" - 1
                    break
                end
            end
            lookReturn = true
            tempStr = ""
        end
        if lookReturn then
            if tempStr == "return" then
                local varname = ""
                local endOfFunction = 0
                for m=i+2, i+25 do
                    if split[m] == " " then
                        break
                    end
                    varname = varname..split[m]
                end
                local tempVar = ""
                for m=i+2, i+25 do
                    if tempVar:find("end)") ~= nil then
                        endOfFunction = m + 2
                        break
                    end
                    tempVar = tempVar..split[m]
                end
                --
                split[i] = " = nil table.insert(functionPoints, ".."{"..startOfFunction..", "..endOfFunction..", "..varname.." }) return "
                lookReturn = false
                tempStr = ""
                startOfFunction = 0
            end
        end
        returnFunc = returnFunc..split[i]
    end
    returnFunc = returnFunc..[[split = {} 
                                for c in script:gmatch"." do 
                                    table.insert(split, c) 
                                end 
                                
                                local newscript = ""

                                --functionPoints = res
                                for _,v in pairs(functionPoints) do
                                    local isMember = false
                                    for i=v[1], v[2] do
                                        --if i == v[2]-1 and split[i] == "[" then
                                        if split[i] == "[" then
                                            isMember = true
                                        else
                                            split[i] = ""
                                        end
                                    end
                                    local lol = v[1]
                                    if isMember then
                                        split[lol] = '["'..tostring(v[3])..'"]'
                                    else
                                        split[lol] = '"'..tostring(v[3])..'",'
                                    end
                                end
                                print(table.concat(split))]]
	loadstring(returnFunc)()
end

Decoder:getStringDecodedScript(script)

return Decoder
