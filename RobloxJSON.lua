local mdl = {}

function startsWith(str,match)
    local p = string.sub(str,1,#match)

    return p == match
end

function find(tbl,thing)
    for _,v in ipairs(tbl) do
        if v == thing then
            return true
        end
    end
    return false
end

local Loaded = {}
local Template = {}

function mdl.SaveConfig(Config)
    local BasicTypes = {
        "string",
        "boolean",
        "number",
        "nil"
    }

    local function GoThrought(tbl,nextIndex)
        local myTbl = nextIndex == nil and tbl or tbl[nextIndex]
        local Ret = {}

        for k,v in pairs(myTbl) do
            if typeof(v) == "table" then
                Ret[k] = GoThrought(myTbl, k)
            elseif typeof(v) == "Color3" then
                Ret[k] = {
                    Type = "Color3",
                    r = v.r,
                    g = v.g,
                    b = v.b
                }
            elseif typeof(v) == "EnumItem" and startsWith(tostring(v), "Enum.KeyCode.") then
                Ret[k] = {
                    Type = "Key",
                    Key = string.split(tostring(v),".")[3]
                }
            elseif find(BasicTypes,typeof(v)) == true then
                Ret[k] = v
            else
                warn("Type is not valid! { Type:",typeof(v),"}")
                Ret[k] = "Invalid type: "..typeof(v)
            end
        end

        return Ret
    end

    return game:GetService("HttpService"):JSONEncode(GoThrought(Config))
end

function mdl.LoadConfig(JSONConfig)
    local Config = game:GetService("HttpService"):JSONDecode(JSONConfig)
    
    local BasicTypes = {
        "string",
        "number",
        "boolean",
        "nil"
    }

    local function GO(tbl,nextIndex)
        local myTbl = nextIndex == nil and tbl or tbl[nextIndex]
        local Ret = {}

        for k,v in pairs(myTbl) do
            if typeof(v) == "table" and rawget(v,"Type") then
                local Type = rawget(v,"Type")
                if Type == "Color3" then
                    Ret[k] = Color3.new(v.r,v.g,v.b)
                elseif Type == "Key" then
                    for _,key in ipairs(Enum.KeyCode:GetEnumItems()) do
                        if string.split(tostring(key),".")[3] == v.Key then
                            Ret[k] = key
                            break
                        end
                    end
                end
            elseif typeof(v) == "table" and (not (rawget(v, "Type") ~= nil)) then
                Ret[k] = GO(myTbl, k)
            elseif find(BasicTypes,typeof(v)) == true then
                Ret[k] = v
            else
                warn("Tried to decode { k:",k,"type:",typeof(v),"}")
                Ret[k] = "Failed! ( k: "..k..", type: "..typeof(v).." )"
            end
        end

        return Ret
    end

    Loaded = GO(Config)
    return Loaded
end

function mdl.LoadTemplate(tmp)
    Template = tmp
end

function mdl.Get(val,...) -- the ... are just indexes
    local Indexes = {...}

    if #Indexes == 1 then
        local v = Loaded[Indexes[1]][val]
        return v == nil and Template[Indexes[1]][val] or v
    end

    local default = Template

    for _,v in ipairs({...}) do
        default = default[v]
    end
    default = default[val]

    local function GO()
        local path = Loaded

        for _,v in ipairs(Indexes) do
            if path[v] == nil then
                return default
            end
            path = path[v]
        end

        return path[val] == nil and default or path[val]
    end

    return GO()
end

return mdl
