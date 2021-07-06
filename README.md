# RobloxScripts

this is where i post my roblox scripts

# AddonForExploits.lua
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
- LocalPlayer (not a function) -- returns the LocalPlayer
- AddToGlobal -- add your function to the exploit's enviroment with the given name {name: string,data: any}

# RobloxJSON.lua
RobloxJSON is more like a configing system for people to use.
Why is it better than roblox's JSON?
because roblox's json formating cannot save Color3's and Key's.
Why should i use it?
because it allows you to save and load configs and even get or set them without running into any issues.
