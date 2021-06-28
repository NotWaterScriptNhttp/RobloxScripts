function comment(...)end

comment("You can use this module in anyway. Find more at https://github.com/NotWaterScriptNhttp/RobloxScripts")

local module = {}
local Utils = {}

----------------------------
------------Utils-----------
----------------------------


function Utils.OffsetColor(col,r,g,b,op)
	col = col or Color3.new(0,0,0)
	
	op = op or "p"
	
	r = r or 0
	g = g or 0
	b = b or 0
	
	if op == "p" then
		return Color3.fromRGB((col.R * 255) + r,(col.G * 255) + g,(col.B * 255) + b)
	elseif op == "n" then
		return Color3.fromRGB((col.R * 255) - r,(col.G * 255) - g,(col.B * 255) - b)
	else
		return Color3.fromRGB((col.R * 255) + r,(col.G * 255) + g,(col.B * 255) + b)
	end
end

----------------------------
------------UIlib-----------
----------------------------

function module.CreateLabel(parent,pos,size,text,spoiler,onSpoilerClick)
	assert(typeof(parent) == "Instance","Argument #1 must be 'Instance', got '"..typeof(parent).."'")
	assert((typeof(pos) == "UDim2" and typeof(size) == "UDim2") == true,"Pos or Size expected 'UDim2', got (Pos: "..typeof(pos)..", Size: "..typeof(size)..")")
	assert(typeof(text) == "string","Argument #4 expected 'string', got '"..typeof(text).."'")
	
	local LabelBackground = Instance.new("Frame",parent)
	LabelBackground.Size = size
	LabelBackground.Position = pos
	
	LabelBackground.BorderSizePixel = 0
	LabelBackground.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
	
	local Label = Instance.new("TextLabel",LabelBackground)
	Label.Size = UDim2.new(1,0,1,0)
	Label.Position = UDim2.new(0,0,0,0)
	Label.TextScaled = true
	Label.TextWrapped = true
	Label.BorderSizePixel = 0
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Text = text

	if typeof(spoiler) == "boolean" and spoiler == true then
		local Spoiler = Instance.new("Frame",Label)
		Spoiler.BorderSizePixel = 0
		Spoiler.Size = UDim2.new(1,0,1,0)
		Spoiler.Position = UDim2.new(0,0,0,0)
		
		Spoiler.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
		
		local SpoilerLabel = Instance.new("TextLabel",Spoiler)
		SpoilerLabel.Size = UDim2.new(1,0,1,0)
		SpoilerLabel.Position = UDim2.new(0,0,0,0)
		SpoilerLabel.TextScaled = true
		SpoilerLabel.TextColor3 = Color3.new(1,1,1)
		SpoilerLabel.Text = "Spoiler"
		SpoilerLabel.BackgroundTransparency = 1
		
		local active = false
		
		Spoiler.InputBegan:Connect(function(key)
			if key.UserInputType == Enum.UserInputType.MouseButton1 then
				active = not active
				SpoilerLabel.Visible = not active
				
				if onSpoilerClick then
					onSpoilerClick(active)
				end
				
				if active == true then
					Spoiler.BackgroundTransparency = 0.7
					Spoiler.BackgroundColor3 = Color3.new(1,1,1)
					Label.TextColor3 = Color3.new(0,0,0)
				else
					Spoiler.BackgroundTransparency = 0
					Spoiler.BackgroundColor3 = Color3.new(0.137255, 0.137255, 0.137255)
					Label.TextColor3 = Color3.new(1,1,1)
				end
			end
		end)
	end
	return LabelBackground
end

function module.CreateButton(parent,pos,size,text,color,func)
	assert(typeof(parent) == "Instance","Argument #1 expected 'Instance', got '"..typeof(parent).."'")
	assert((typeof(pos) == "UDim2" and typeof(size) == "UDim2") == true,"Pos or Size expected 'UDim2', got (Pos: "..typeof(pos)..", Size: "..typeof(size)..")")
	assert(typeof(text) == "string","Argument #4 expected 'string', got '"..typeof(text).."'")
	assert(typeof(color) == "Color3","Arguments #5 expected 'Color3', got '"..typeof(color).."'")
	assert(typeof(func) == "function","Arguments #6 expected 'function', got '"..typeof(func).."'")
	
	local ButtonBack = Instance.new("TextLabel",parent)
	ButtonBack.BorderSizePixel = 0
	ButtonBack.Size = size
	ButtonBack.Position = pos
	ButtonBack.BackgroundColor3 = color
	
	ButtonBack.Text = text
	ButtonBack.TextScaled = true
	
	ButtonBack.MouseEnter:Connect(function()
		ButtonBack.BackgroundColor3 = Utils.OffsetColor(color,100,100,100,"p")
	end)
	ButtonBack.InputBegan:Connect(function(key)
		if key.UserInputType  == Enum.UserInputType.MouseButton1 then
			func()
		end
	end)
	ButtonBack.MouseLeave:Connect(function()
		ButtonBack.BackgroundColor3 = color
	end)
	
	return ButtonBack
end

return module
