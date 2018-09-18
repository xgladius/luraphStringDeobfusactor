local script = [[
    local index = 1 
    local I1li111IIilI1iiI111 = {} 
    local lIl1iI1iiIIll11III111 

    local A = "A"
    local B = "B"
    local C = "C"
    local Bx = "Bx"
    local sBx = "sBx"

    local LVX = {
        bytecode = {
            [1] = {N="LOADBOOL", Args={
                A, B, C
            }};
            [2] = {N="CLOSURE", Args={
                A, B
            }};
            [3] = {N="CALL", Args={
                A, B, C
            }};
            [4] = {N="EQ", Args={
                A, B, C
            }};
            [5] = {N="GETGLOBAL", Args={
                A, B
            }};
            [6] = {N="SETGLOBAL", Args={
                A, B
            }};
            [7] = {N="RETURN", Args={
                A, B
            }};
            [8] = {N="TEST", Args={
                A, C
            }};
            [9] = {N="LOADK", Args={
                A, B
            }};
            [10] = {N="MOVE", Args={
                A, B
            }};
            [11] = {N="JMP", Args={
                sBx
            }};
            [12] = {N="LOADK", Args={
                A, B
            }};
            [13] = {N="CLOSURE", Args={
                A, B
            }};
            [14] = {N="GETGLOBAL", Args={
                A, B
            }};
            [15] = {N="MOVE", Args={
                A, B
            }};
            [16] = {N="SETGLOBAL", Args={
                A, B
            }};
            [17] = {N="GETTABLE", Args={
                A, B, C
            }};
            [18] = {N="LEN", Args={
                A, B
            }};
            [19] = {N="SETLIST", Args={
                A, B, C
            }};
            [20] = {N="LOADBOOL", Args={
                A, B, C
            }};
            [21] = {N="EQ", Args={
                A, B, C
            }};
            [22] = {N="JUMP", Args={
                sBx
            }};
        };
        ChunksDecoded = 0;
    };


    function LVXDecodeChunk(chunk)
        LVX.ChunksDecoded = LVX.ChunksDecoded + 1;
        if (LVX.ChunksDecoded == 1) then
            print("main (CD: " .. LVX.ChunksDecoded .. " ; ADDR: " .. tostring(chunk):gsub("table: ", "") .. ")");
            print("info (IC: " .. #chunk.instructions .. " ; PC: " .. #chunk.prototypes .. ")");
        else
            print("function (CD: " .. LVX.ChunksDecoded .. " ; ADDR: " .. tostring(chunk):gsub("table: ", "") .. ")");
            print("    info (IC: " .. #chunk.instructions .. " ; PC: " .. #chunk.prototypes .. ")");
        end
        local l = 0;
        for _,instruction in pairs(chunk.instructions) do
            l = l + 1;
            print(LVXDecodeInstruction(chunk, instruction, l));
        end
        print("");
    end

    function LVXDecodeInstruction(chunk, instruction, cLine)
        local decoded = cLine .. "	";
        local gtable = false;
        local instructionData = LVX.bytecode[instruction.opcode+1];
        
        decoded = decoded .. "	[" .. instruction.opcode+1 .. "]";
        decoded = decoded .. "	" .. instructionData.N .. "	";

        for _,arg in pairs(instructionData.Args) do
            if (instructionData.N == "GETGLOBAL") then
                local key = chunk.constants[instruction.B].data;

                if (tostring(arg) == B) then
                    if (tostring(instruction[arg]) ~= "0") then
                        decoded = decoded .. "-" .. instruction[arg] .. " ";
                    else
                        decoded = decoded .. instruction[arg] .. " ";
                    end
                    decoded = decoded .. "	; " .. tostring(key);
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "CLOSURE") then
                local proto = chunk.prototypes[0];
                local str = tostring(proto);
                str = str:gsub("table: 0x", "0");
                str = string.upper(str);
                if (tostring(arg) == B) then
                    decoded = decoded .. instruction[arg] .. " ";
                    decoded = decoded .. "	; " .. str;
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "SETTABLE") then
                local k = "\"" .. chunk.constants[instruction.B - 256].data .. "\" -";

                if (tostring(arg) == B) then
                    if (tostring(instruction[arg]) ~= "0") then
                        decoded = decoded .. "-" .. instruction[arg] - 256 .. " ";
                    else
                        decoded = decoded  .. instruction[arg] .. " ";
                    end
                else
                    if (tostring(arg) == C) then
                        decoded = decoded  .. instruction[arg] .. " ";
                        decoded = decoded .. "	; " .. tostring(k);
                    else
                        decoded = decoded  .. instruction[arg] .. " ";
                    end
                end
            elseif (instructionData.N == "SETGLOBAL") then
                local key = chunk.constants[0].data;

                if (tostring(arg) == B) then
                    if (tostring(instruction[arg]) ~= "0") then
                        decoded = decoded .. "-" .. instruction[arg] .. " ";
                    else
                        decoded = decoded .. instruction[arg] .. " ";
                    end
                    decoded = decoded .. "	; " .. tostring(key);
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "GETTABLE") then
                if (tostring(arg) == C) then
                    decoded = decoded .. instruction[arg] - 256 .. " ";
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "LOADK") then
                if (tostring(arg) == B) then
                    decoded = decoded .. instruction[arg] .. " ";

                    local key = chunk.constants[instruction.B].data;
                    decoded = decoded .. "	; \"" .. tostring(key) .. "\"";
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "EQ") then
                if (tostring(arg) == C) then
                    decoded = decoded .. instruction[arg] .. " ";
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "SELF") then
                if (tostring(arg) == C) then
                    decoded = decoded .. instruction[arg] - 256 .. " ";
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            elseif (instructionData.N == "JMP") then
                decoded = decoded .. instruction[arg] .. " ";
                decoded = decoded .. "  ; " .. "--> to " .. cLine + instruction.sBx;
            elseif (instructionData.N == "CALL") then
                if (tostring(arg) == C) then
                    if (tostring(instruction[arg]) == "0") then
                        decoded = decoded .. instruction[arg] + 1 .. " ";
                    else
                        decoded = decoded .. instruction[arg] .. " ";
                    end
                else
                    decoded = decoded .. instruction[arg] .. " ";
                end
            else
                decoded = decoded .. instruction[arg] .. " ";
            end
        end
        return decoded;
    end

    if bit and bit.bxor then 
        lIl1iI1iiIIll11III111 = bit.bxor 
    else 
        function lIl1iI1iiIIll11III111(junk, key) 
            local i1l1IiiiIIl1ilII1ll = function(data, i) 
                return i <= data % (i * 2) 
            end 
            
            local result = 0 
            for i = 0, 31 do 
                result = result + (i1l1IiiiIIl1ilII1ll(junk, 2 ^ i) ~= i1l1IiiiIIl1ilII1ll(key, 2 ^ i) and 2 ^ i or 0) 
            end 
            return result 
        end 
    end 

    local li1lilIii1Il1IlIiil = { 
        (function() 
            local result = "" 
            local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
            local key = 14 
            local bytecodex = "\251\028U\027\239\000\" p\177\183\214L\178Zfg}.XC.mo`.a`bw.|{`.B{|o~f.}m|g~z} %\251\254" 
            local iI1i1Ili1II11ll11lI = "...................................." 
            local i1IiIl111I1Ill1ilIi = "..............." 
            
            for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                local c = string.byte(bytecodex, i) 
                result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
            end 
            return result 
        end)(), 
        (function() 
            local result = "" 
            local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
            local key = 156 
            local bytecodex = "\174\254\131\245o\029Nhv\208\233\238\253\236\244\188\207\255\238\245\236\232\166\205 \214" 
            local iI1i1Ili1II11ll11lI = ".............." 
            local i1IiIl111I1Ill1ilIi = ".........." 
            
            for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                local c = string.byte(bytecodex, i) 
                result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
            end 
            return result 
        end)(), 
        (function() 
            local result = "" 
            local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
            local key = 45 
            local bytecodex = "s\023kE1t@\204Hs\003\006\023\b^\a\005\003\006\004_}\217\"\1508\127" 
            local iI1i1Ili1II11ll11lI = "..........." 
            local i1IiIl111I1Ill1ilIi = ".........." 
            
            for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                local c = string.byte(bytecodex, i) 
                result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
            end 
            return result 
        end)(), 
        (function() 
            local result = "" 
            local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
            local key = 228 
            local bytecodex = "\2049\t\222\196\202\171\217\210\214O\130\164\017]V" 
            local iI1i1Ili1II11ll11lI = ".." 
            local i1IiIl111I1Ill1ilIi = "...." 
            
            for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                local c = string.byte(bytecodex, i) 
                result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
            end 
            return result 
        end)(), 
        ((function() 
            local result = "" 
            local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
            local key = 204 
            local bytecodex = "\243\160\225`f\205\227s\133\132\160\185\190\173\188\164\236\168\163\169\191\162\235\184\236\191\185\188\188\163\190\184\236\184\164\165\191\236\170\169\173\184\185\190\169\226\226\226\236\174\185\184\236\165\170\236\181\163\185\236\162\169\169\168\236\165\184\224\236\166\185\191\184\236\173\191\167\226\226\226M}?" 
            local iI1i1Ili1II11ll11lI = "......................................................................" 
            local i1IiIl111I1Ill1ilIi = "..........." 
            
            for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                local c = string.byte(bytecodex, i) 
                result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
            end 
            return result 
        end)()) 
    } 

    local function Ill1Ill111(bytecode) 
        local function get_int8() 
            local a = bytecode:byte(index, index) 
            index = index + 1 
            return a 
        end 
        local function get_int32() 
            local a, b, c, d = bytecode:byte(index, index + 3) 
            index = index + 4 
            return d * 16777216 + c * 65536 + b * 256 + a 
        end 
        local function get_bits(iii11liIll1liIillii, llillIiIl111lIil1ll, II1l1l1i111l111IlII) 
            if II1l1l1i111l111IlII then
                local I1ili1Il1i1l1i1iill, Illil1I1IlIIiI11II1 = 0, 0 
                for i = llillIiIl111lIil1ll, II1l1l1i111l111IlII do 
                    I1ili1Il1i1l1i1iill = I1ili1Il1i1l1i1iill + 2 ^ Illil1I1IlIIiI11II1 * get_bits(iii11liIll1liIillii, i) 
                    Illil1I1IlIIiI11II1 = Illil1I1IlIIiI11II1 + 1 
                end 
                return I1ili1Il1i1l1i1iill 
            else 
                local illllIIlIlI1il1IiiI = 2 ^ (llillIiIl111lIil1ll - 1) 
                return illllIIlIlI1il1IiiI <= iii11liIll1liIillii % (illllIIlIlI1il1IiiI + illllIIlIlI1il1IiiI) and 1 or 0 
            end 
        end 
        local function get_float64() 
            local a, b = get_int32(), get_int32() 
            if a == 0 and b == 0 then 
                return 0 
            end 
            return (-2 * get_bits(b, 32) + 1) * 2 ^ (get_bits(b, 21, 31) - 1023) * ((get_bits(b, 1, 20) * 4294967296 + a) / 4503599627370496 + 1) 
        end 
        local function l11iI1IIilliI1l1ili(iI1i1Ili1II11ll11lI) 
            local iIl1i1liiiIIIIIi1l1 = bytecode:sub(index, index + iI1i1Ili1II11ll11lI - 1) 
            index = index + iI1i1Ili1II11ll11lI 
            return iIl1i1liiiIIIIIi1l1 
        end 
        local function l11Il1iIiIiI1lIi111(key) 
            local lII1111i1i1Iii1111i = { 
                bytecode:byte(index, index + 3) 
            } 
            index = index + 4 
            local Iil11l1lll11IiIlIii = {} 
            for i = 1, 8 do 
                Iil11l1lll11IiIlIii[i] = get_bits(key, i) 
            end 
            local result = "" 
            for i = 1, 4 do 
                local I1ili1Il1i1l1i1iill, Illil1I1IlIIiI11II1 = 0, 0 
                for ll1l1l1iIiIIlIl1l11 = 1, 8 do 
                    local llilll11I1IiIIiIl1l = get_bits(lII1111i1i1Iii1111i[i], ll1l1l1iIiIIlIl1l11) 
                    if Iil11l1lll11IiIlIii[ll1l1l1iIiIIlIl1l11] == 1 then 
                        llilll11I1IiIIiIl1l = llilll11I1IiIIiIl1l == 1 and 0 or 1 
                    end 
                    I1ili1Il1i1l1i1iill = I1ili1Il1i1l1i1iill + 2 ^ Illil1I1IlIIiI11II1 * llilll11I1IiIIiIl1l 
                    Illil1I1IlIIiI11II1 = Illil1I1IlIIiI11II1 + 1 
                end 
                result = result .. string.char(I1ili1Il1i1l1i1iill) 
            end 
            local a, b, c, d = result:byte(1, 4) 
            return d * 16777216 + c * 65536 + b * 256 + a 
        end 
        local function ilII1lIIiiiIi1iIlli(key) 
            local iI1i1Ili1II11ll11lI = get_int32() 
            index = index + iI1i1Ili1II11ll11lI 
            local Iil11l1lll11IiIlIii = {} 
            for i = 1, 8 do 
                Iil11l1lll11IiIlIii[i] = get_bits(key, i) 
            end 
            local result = "" 
            for i = 1, iI1i1Ili1II11ll11lI do 
                local I1ili1Il1i1l1i1iill, Illil1I1IlIIiI11II1 = 0, 0 
                for ll1l1l1iIiIIlIl1l11 = 1, 8 do 
                    local llilll11I1IiIIiIl1l = get_bits(bytecode:byte(index - iI1i1Ili1II11ll11lI + i - 1), ll1l1l1iIiIIlIl1l11) 
                    if Iil11l1lll11IiIlIii[ll1l1l1iIiIIlIl1l11] == 1 then 
                        llilll11I1IiIIiIl1l = llilll11I1IiIIiIl1l == 1 and 0 or 1 
                    end 
                    I1ili1Il1i1l1i1iill = I1ili1Il1i1l1i1iill + 2 ^ Illil1I1IlIIiI11II1 * llilll11I1IiIIiIl1l 
                    Illil1I1IlIIiI11II1 = Illil1I1IlIIiI11II1 + 1 
                end 
                result = result .. string.char(I1ili1Il1i1l1i1iill) 
            end 
            return result 
        end 
        getfenv()[(function() 
            local result = "" 
            local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
            local key = 52 
            local bytecodex = "\224_\"\169E\029:\177\191\224'h\143\210UGGQF@\142\156\135" 
            local iI1i1Ili1II11ll11lI = "......" 
            local i1IiIl111I1Ill1ilIi = "..............." 
            for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                local c = string.byte(bytecodex, i) 
                result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
            end 
            return result 
        end)()]("\027LPH" == l11iI1IIilliI1l1ili(4), li1lilIii1Il1IlIiil[1]) 
        local i1l1i1i1IililiiIIi1 = get_int8() 
        local l1IiIiIl1lII1li1ii1 = get_int8() 

        local function decode_chunk() 
            local chunk = { 
                debugLines = {}, 
                constants = {}, 
                prototypes = {}, 
                instructions = {} 
            } 
            
            local II1llI1IIliil1Iiili = 1 
            get_int32() 
            get_int8() 
            get_int8() 
            get_int8() 
            get_int8() 
            get_int32() 
            get_int8() 
            get_int32() 
            get_int32() 
            local num = get_int32() 

            for i = II1llI1IIliil1Iiili, num do 
                chunk.debugLines[i] = get_int32() 
            end 
            
            chunk.IIlIliIlil1ii111i1II = get_int8() 
            get_int32() 
            get_int32() 
            get_int8() 

            local num = get_int32() 
            for i = II1llI1IIliil1Iiili, num do 
                chunk.prototypes[i - II1llI1IIliil1Iiili] = decode_chunk() 
            end 
            local num = get_int32() - (133702) 
            
            for i = II1llI1IIliil1Iiili, num do 
                local constant = {} 
                constant.type = get_int8() 
                if constant.type == 187 then 
                    constant.data = get_float64() 
                end 
                if constant.type == 216 then 
                    constant.data = ilII1lIIiiiIi1iIlli(i1l1i1i1IililiiIIi1) 
                end 
                if constant.type == 111 then 
                    constant.data = 102163 == 102163 
                end 
                if constant.type == 142 then 
                    constant.data = 65991 == 10977 
                end 
                chunk.constants[i - II1llI1IIliil1Iiili] = constant 
            end 
            
            get_int32() 
            get_int32() 
            
            local num = get_int32() - (133733) 
            for i = II1llI1IIliil1Iiili, num do 
                local nInstruction = {} 
                local data = l11Il1iIiIiI1lIi111(l1IiIiIl1lII1li1ii1) 
                nInstruction.C = get_bits(data, 18) 
                nInstruction.A = get_bits(data, 19, 26) 
                nInstruction.B = get_bits(data, 1, 9) 
                nInstruction.Bx = get_bits(data, 1, 18) 
                nInstruction.opcode = get_bits(data, 27, 32) 
                nInstruction.sBx = get_bits(data, 1, 18) - (131071) 
                chunk.instructions[i] = nInstruction 
            end 
            
            get_int8() 
            chunk.ll11ii1liiIill1Il1i1 = get_int8() 
            get_int8() 

            LVXDecodeChunk(chunk);
            
            return chunk 
        end 
        
        local function create_wrapper(chunk, upvalues) 
            local data, upvalues, opcode, illiIlI1lI1iiIli11i = "data", "IIlIliIlil1ii111i1II", "opcode", "B" 
            local ilIl1lllll1Iiii1IiI, iI1iI1IIIll1ii1i1Il = 9, -1 
            local wInstructions = chunk.instructions 
            local wConstants = setmetatable({}, { 
                __index = function(t, k) 
                    local result = chunk.constants[k] 
                    if type(result[data]) == "string" then 
                        return { 
                            [data] = result[data]:sub(4) 
                        } 
                    end 
                    return result 
                end 
            }) 
            
            local lIl1Iilll1li1l11II1ll = chunk.prototypes 
            local lIli1Iill11IilIiIIiIi = chunk.ll11ii1liiIill1Il1i1 
            local lIlil1Il1III1lI11iIIl = chunk.debugLines 
            local function i1iIliIlillll111Iii(...) 
                local IP, top, stack, environment, ililIil1llll1l1i1il, iiIIlll1lI1iIl1Ii1I, I111llilI1IlliiIIii 
                local local_stack = {} 
                local ghost_stack = {} 
                top = -1 
                stack = setmetatable(local_stack, { 
                    __index = ghost_stack, 
                    __newindex = function(t, k, v) 
                        if k > top and v then 
                            top = k 
                        end 
                        ghost_stack[k] = v 
                    end 
                }) 
                
                IP = 1 
                environment = (function() 
                    local environment = getfenv()[(function() 
                        local result = "" 
                        local junk = "if ur looking at this, i have some info for u. luraph > luasecure > lumida > all. stop analyzing my software now pls. i will sue you if u keep going. " 
                        local key = 236 
                        local bytecodex = "\173@\223\182\218\018\139\137\152\138\137\130\154x\021" 
                        local iI1i1Ili1II11ll11lI = "......." 
                        local i1IiIl111I1Ill1ilIi = "......." 
                        
                        for i = #i1IiIl111I1Ill1ilIi, #i1IiIl111I1Ill1ilIi + #iI1i1Ili1II11ll11lI - 1 do 
                            local c = string.byte(bytecodex, i) 
                            result = result .. string.char(lIl1iI1iiIIll11III111(c, key)) 
                        end 
                        return result 
                    end)()]()["getfenv"]() 
                    return setmetatable({}, { 
                        __index = function(liiI1iiliIlllIilli1, key) 
                            local result 
                            for i, v in pairs(environment) do 
                                if key == i then 
                                    result = v 
                                end 
                                local d = environment[i] 
                            end 
                            local i1i11IlliIl1liiliIl = { 
                                "math", "string", "pairs", "getmetatable", 
                                "getfenv", "setfenv", "print", "error", 
                                "next", "whitelist", "loadstring", "luraph", 
                                "jakepaul", "fortnite", "abc123", "jailbreak", 
                                "phantomforces", "anticheatbypass", "bigstring", 
                                "getfenv", "loopie", "dontmesswitme", "yuhdood", 
                                "ooooooooooof", "compatibility", "luraph > luasecure" 
                            } 
                            
                            for i = #i1i11IlliIl1liiliIl, 1, -1 do 
                                local lIlli1Il1l1ll1lIlil = math.random(#i1i11IlliIl1liiliIl) i1i11IlliIl1liiliIl[i], i1i11IlliIl1liiliIl[lIlli1Il1l1ll1lIlil] = i1i11IlliIl1liiliIl[lIlli1Il1l1ll1lIlil], i1i11IlliIl1liiliIl[i] 
                            end 
                            local lllIIllillillIi1iiI = math.random(1, #i1i11IlliIl1liiliIl) 
                            
                            for i, v in pairs(i1i11IlliIl1liiliIl) do 
                                if not result and lllIIllillillIi1iiI == i then 
                                    result = environment[key] 
                                end 
                                local d = environment[v] 
                            end 
                            return result 
                        end, 
                        
                        __newindex = function(liiI1iiliIlllIilli1, key, liIi1ilI1ii1IliiI1l) 
                            environment[key] = liIi1ilI1ii1IliiI1l 
                        end 
                    }) 
                end)() 
                
                I111llilI1IlliiIIii = {} 
                local args = { ... } 
                ililIil1llll1l1i1il = {} 
                iiIIlll1lI1iIl1Ii1I = select("#", ...) - 1 
                
                for i = 0, iiIIlll1lI1iIl1Ii1I do 
                    stack[i] = args[i + 1] 
                    ililIil1llll1l1i1il[i] = args[i + 1] 
                end 
                
                local opcode_funcs = { 
                    [7] = function(instruction) -- JUMP
                        local A = instruction.A 
                        local Bx = instruction.Bx 
                        local C = instruction.C 
                        local B = instruction.B 
                        local sBx = instruction.sBx 
                        
                        IP = IP + sBx 
                    end, 
                    [10] = function(instruction) -- CALL
                        local C = instruction.C 
                        local A = instruction.A 
                        local Bx = instruction.Bx 
                        local B = instruction.B 
                        local sBx = instruction.sBx 
                        
                        local handle_return = function(...) 
                            local c = select("#", ...) 
                            local t = { ... } 
                            return c, t 
                        end 

                        local args, results, limit, loop args = {} 
                        if B ~= 1 then 
                            if B ~= 0 then 
                                limit = A + B - 1 
                            else 
                                limit = top 
                            end 
                            loop = 0 
                            for i = A + 1, limit do 
                                loop = loop + 1 args[loop] = stack[i] 
                            end 
                            limit, results = handle_return(stack[A](unpack(args, 1, limit - A))) 
                        else 
                            limit, results = handle_return(stack[A]()) 
                        end 
                        top = A - 1 
                        if C ~= 1 then 
                            if C ~= 0 then 
                                limit = A + C - 2 
                            else 
                                limit = limit + A 
                            end 
                            loop = 0 
                            for i = A, limit do 
                                loop = loop + 1 
                                stack[i] = results[loop] 
                            end 
                        end 
                    end, 
                    [3] = function(instruction) -- LOADK
                        local A = instruction.A 
                        local C = instruction.C 
                        local B = instruction.B 
                        local sBx = instruction.sBx 
                        local Bx = instruction.Bx 
                        
                        stack[A] = wConstants[Bx][data] 
                    end, 
                    [2] = function(instruction) -- RETURN
                        local sBx = instruction.sBx 
                        local C = instruction.C 
                        local A = instruction.A 
                        local Bx = instruction.Bx 
                        local B = instruction.B 
                        
                        local limit, loop, output 
                        if B == 1 then 
                            return true 
                        end 
                        if B == 0 then 
                            limit = top 
                        else 
                            limit = A + B - 2 
                        end 
                        output = {} 
                        loop = 0 
                        for i = A, limit do 
                            loop = loop + 1 output[loop] = stack[i] and stack[i] or I1li111IIilI1iiI111 
                        end 
                        return true, output 
                    end, 
                    [9] = function(instruction) -- MOVE
                        local A = instruction.A 
                        local Bx = instruction.Bx 
                        local sBx = instruction.sBx 
                        local B = instruction.B 
                        local C = instruction.C 
                        
                        stack[A] = stack[B] 
                    end, 
                    [8] = function(instruction) -- SETGLOBAL
                        local sBx = instruction.sBx 
                        local Bx = instruction.Bx 
                        local C = instruction.C 
                        local A = instruction.A 
                        local B = instruction.B 
                        
                        local key = wConstants[Bx][data] 
                        environment[key] = stack[A] 
                    end, 
                    [4] = function(instruction) -- GETGLOBAL
                        local B = instruction.B 
                        local sBx = instruction.sBx 
                        local C = instruction.C 
                        local A = instruction.A 
                        local Bx = instruction.Bx 
                        
                        local key = wConstants[Bx][data] 
                        stack[A] = environment[key] 
                    end, 
                    [0] = function(instruction) -- TEST
                        local sBx = instruction.sBx 
                        local A = instruction.A 
                        local B = instruction.B 
                        local Bx = instruction.Bx 
                        local C = instruction.C 
                        
                        if not not stack[A] == (C == 0) then 
                            IP = IP + 1 
                        end 
                    end, 
                    [5] = function(instruction) -- CLOSURE
                        local Bx = instruction.Bx 
                        local B = instruction.B 
                        local C = instruction.C 
                        local sBx = instruction.sBx 
                        local A = instruction.A 
                        
                        local proto = lIl1Iilll1li1l11II1ll[Bx] 
                        local indices = {} 
                        
                        local new_upvals = setmetatable({}, { 
                            __index = function(t, k) 
                                local upval = indices[k] 
                                return upval.segment[upval.offset] 
                            end, 
                            __newindex = function(t, k, v) 
                                local upval = indices[k] 
                                upval.segment[upval.offset] = v 
                            end 
                        }) 
                        
                        for i = 1, proto[upvalues] do 
                            local movement = wInstructions[IP] 
                            if movement[opcode] == ilIl1lllll1Iiii1IiI then 
                                indices[i - 1] = { 
                                    segment = stack, 
                                    offset = movement[illiIlI1lI1iiIli11i] 
                                } 
                            elseif movement[opcode] == iI1iI1IIIll1ii1i1Il then 
                                indices[i - 1] = { 
                                    segment = upvalues, 
                                    offset = movement[illiIlI1lI1iiIli11i] 
                                } 
                            end 
                            IP = IP + 1 
                        end 
                        I111llilI1IlliiIIii[#I111llilI1IlliiIIii + 1] = indices 
                        local func = create_wrapper(proto, new_upvals) 
                        stack[A] = func 
                    end, 
                    [6] = function(instruction) -- LOADBOOL
                        local C = instruction.C 
                        local B = instruction.B 
                        local A = instruction.A 
                        local sBx = instruction.sBx 
                        local Bx = instruction.Bx 
                        
                        stack[A] = B ~= 0 
                        if C ~= 0 then 
                            IP = IP + 1 
                        end 
                    end, 
                    [1] = function(instruction) -- EQ
                        local C = instruction.C 
                        local Bx = instruction.Bx 
                        local A = instruction.A 
                        local B = instruction.B 
                        local sBx = instruction.sBx 
                        
                        A = A ~= 0 
                        if B > 255 then 
                            B = wConstants[B - 256][data] 
                        else 
                            B = stack[B] 
                        end 
                        if C > 255 then 
                            C = wConstants[C - 256][data] 
                        else 
                            C = stack[C] 
                        end 
                        if B == C ~= A then 
                            IP = IP + 1 
                        end 
                    end 
                } 
                
                local new_opcode_funcs = { 
                    [1] = opcode_funcs[6], 
                    [2] = opcode_funcs[5], 
                    [3] = opcode_funcs[10], 
                    [4] = opcode_funcs[1], 
                    [5] = opcode_funcs[4], 
                    [6] = opcode_funcs[8], 
                    [7] = opcode_funcs[2], 
                    [8] = opcode_funcs[0], 
                    [9] = opcode_funcs[3], 
                    [10] = opcode_funcs[9], 
                    [11] = opcode_funcs[7] 
                } 
                
                local function loop() 
                    local instruction, I1ll1lIiliI1ilill1i, result 
                    while true do 
                        local d = environment.DPJpDxJUDwX70aZqoJFS 
                        instruction = wInstructions[IP] 
                        IP = IP + 1 
                        I1ll1lIiliI1ilill1i, result = new_opcode_funcs[instruction.opcode + 1](instruction) 
                        if I1ll1lIiliI1ilill1i then 
                            return result 
                        end 
                    end 
                end 
                
                local iI1iii1iIili11IillI, result = pcall(loop) 
                if iI1iii1iIili11IillI then 
                    if result then 
                        for i, v in pairs(result) do 
                            if v == I1li111IIilI1iiI111 then 
                                result[i] = nil 
                            end 
                        end 
                        return unpack(result) 
                    end 
                else 
                    error(li1lilIii1Il1IlIiil[2] .. lIlil1Il1III1lI11iIIl[IP - 1] .. li1lilIii1Il1IlIiil[4] .. (result:match(li1lilIii1Il1IlIiil[3]) or result), 0) 
                end 
            end 
            return i1iIliIlillll111Iii 
        end 
        local lIli1Ili1I1Ii1iI1ll1I = decode_chunk() 
        return create_wrapper(lIli1Ili1I1Ii1iI1ll1I)() 
    end 
    Ill1Ill111("\027LPHlG+\220\211xY\138C[\026\016\237>\213\219\153\026Q\241W\194\029\000\000\000\000\000\135\212\021r4 \1416`\001\000\000\000<\163\201Q\253\207\t`\005\179\147L\212\212\183\228H\006\vH\016\017\000\000\000\t\000\000\000\001\000\000\000\v\000\000\000\r\000\000\000\r\000\000\000\014\000\000\000\014\000\000\000\014\000\000\000\015\000\000\000\016\000\000\000\016\000\000\000\016\000\000\000\016\000\000\000\017\000\000\000\017\000\000\000\017\000\000\000\018\000\000\000\000\017|\228{\021\no\n{\001\000\000\000oy\028J<\208\227\199\191i\170&\141\145\022a\t3\187n[\b\000\000\000\002\000\000\000\002\000\000\000\003\000\000\000\004\000\000\000\004\000\000\000\006\000\000\000\a\000\000\000\t\000\000\000\000\242\148\140h\198\218 J\153\000\000\000\000F\n\002\000M]\143RT\224.\021m\n\002\000GGG[EGEoGGGGEGG_FGEoFGGGEGG_FGG_\190\001^J\n\002\000\216\r\000\000\000lll\031\027\005\024\015\004*\000\r\v\216\r\000\000\000lll\000\003\000L\000\\\031\t\030\031\216\b\000\000\000lll\028\030\005\002\024\216\006\000\000\000lll\v\r\021q(\166v\002\250W.v\n\002\000GGGCGGGSFGGgGEEKMGEoEGCWDGOgEECOGGCGGGOWFGKcECOOEGCcEGOWFGKcEEOOFGG_[\000:G\n\002\000\187\000\000\000\000\000\228\148@\132\144Aj5\229\025nj\n\002\000GGGCGGGSGGGWFEGOGGG_\148\000g") 
]]
