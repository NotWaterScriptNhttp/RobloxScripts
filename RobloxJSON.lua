local Ver = "1.0.0"

warn("ConfigLib Version",Ver,"Loaded!")

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

function mdl.Get(...) -- the ... are just indexes {Returns [Tbl: table]}
    local args = {...}

    local ret = Loaded == nil and Template or Loaded

    local default = Template

    for _,v in ipairs(args) do
        if default[v] == nil then
            error("INVALID_INDEX_"..v:upper())
        end
        default = default[v]
    end

    for _,v in ipairs(args) do
        if ret[v] == nil then
            return default
        end
        ret = ret[v]
    end

    return ret
end

function mdl.Set(args,...)
    local Indexes = {...}

    local mt = {}

    local TemplateChildren = Template

    for _,v in ipairs(Indexes) do
        TemplateChildren = TemplateChildren[v]
    end

    local function GetFromTemplatePath(thingInIndexes)
        local p = Template
        for _,v in ipairs(Indexes) do
            if v == thingInIndexes then
                return p[thingInIndexes]
            end
            p = p[v]
        end
        return "INVALID"
    end

    local function FillMissing() -- Fills the missing part of the Loaded table from Template aka default values
        local conf = Loaded
        for _,v in ipairs(Indexes) do
            if conf[v] == nil then
                conf[v] = assert(GetFromTemplatePath(v) ~= "INVALID", "FillMissing failed! {Error Type: Critical}")
            end
            conf = conf[v]
        end
    end


    local function SetValue(index,value)
        local p = Loaded
        for _,v in ipairs(Indexes) do
            p = p[v]
        end
        p[index] = value
    end


    FillMissing()


    setmetatable(mt, {
        __newindex = function (self,index,value)
            SetValue(index, value)
        end,
        __call = function (self,index,value)
            SetValue(index, value)
        end
    })

    return mt
end

function mdl.GetLoadedConfig()
    return Loaded
end

function mdl.SetLoadedAsTemplate()
    if Template ~= nil then
        Loaded = Template
    end
end

return mdl
