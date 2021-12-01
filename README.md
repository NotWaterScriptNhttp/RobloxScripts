# RobloxScripts

this is where i post my roblox scripts

| Project info |
| - |
| [Exploit Support](#AddonForExploits) |
| [Better Roblox JSON](#RobloxJSON) |

# AddonForExploits
AddonForExploits is used for making compatibillity for more exploits with the same syntax.
List of all Functions:
- MyExploit -- returns what exploit your using {void}
- ProtectGUI -- Protects your gui in a better way than CoreGui would {GUIObject: Instance}
- newCClosure -- does the same thing but not every exploit has it {func: function}
- setReadonly -- functions as setReadonly {Mt: userdata(metatable), readonly: boolean}
- getNamecallMethod -- this allows you to get the namecall method on the called metatable some exploits don't have it so thats why this is here, this is not 100% accuryte {obj: Instance}
- hookFunc -- this is just hookFunction but supports more exploits {old: function,new: function}
- hookMetatable -- this will return the oldFunction for the hooked metamethod supports the hookMetamethod on synapse {metaMethod: string, func: function}
- Request -- makes http request easier to make on all exploits {data: table}
- LoadURL -- is just loadstring with game:HttpGet so nothing that is compatibillity related {url: string}
- LoadLocal -- loads a local file with loadstring {file: string}
- OnDisconnect -- is called when some one leave's the game {func: function}
- Exists -- is used to check if a file exists {string: path/file}
- Base64 -- will return table {encode: func, decode: func}
- Encryption -- will return table {encrypt: func, decrypt: func}
- LocalPlayer (not a function) -- returns the LocalPlayer
- AddToGlobal -- add your function to the exploit's enviroment with the given name {name: string,data: any}

# RobloxJSON
RobloxJSON is more like a configing system for people to use.
Why is it better than roblox's JSON?
because roblox's json formating cannot save Color3s, Vectors, etc...
if the data type is not supported by the script creat an issue

Why should i use it?
because it allows you to save and load configs and even get or set them without running into any issues.

Usage:
```lua
local configLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NotWaterScriptNhttp/RobloxScripts/main/RobloxJSON.lua", true))() -- Loads the configLib
local config = configLib.new() -- creates a new config

local template = {
  Foo = {
    Bar = true
  }
} -- put your values here (Templates are used for the main getting/setting values so everything in template table will be used as your config)
--This does not modify the template table. Template is just used as a struct of the config

--you MUST provide a Template to make this Config System work
config.LoadTemplate(template) -- takes only table as input, returns: none

--also you might need to do config.SetLoadedAsTemplate() -- returns: none

--To load configs do
local cfgData = readfile(<YourConfigName>) or "{\"Foo\": {\"Bar\": true}}"
config.LoadConfig(cfgData) -- takes only JSON string, returns: none

--To save configs do
config.SaveConfig(config.GetLoadedConfig() --[[ This might get removed in the next update ]]-- ) -- takes only table as input, return: string (JSON string)
--To save it to a file use writefile or any other thing that can save strings

--To get values out of the config do
config.Get("Foo", "Bar") -- takes in string of ... (path to the value in the template table), returns: any
config.Get("Foo").Bar -- does the same thing as above

--To set values in the config do
--Planning to add config.Set("Foo", "Bar") = false -- takes in string of ... (path to value in the template table), returns: none
config.Set("Foo").Bar = false -- does the same thing as above
```
