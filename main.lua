--==================================================
-- Create by L | FULL AIMBOT + ESP + GLASS UI (FIXED)
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================

_G.AIM = {
	Enabled = false,
	Part = "HumanoidRootPart",
	Strength = 0.22,
	FOV = 150,
	MinDistance = 200,
	Prediction = 0.14,
	WallCheck = true,
	DeathCheck = true
}

_G.FOV = {
	Color = Color3.fromRGB(0,170,255),
	Thickness = 2
}

_G.ESP = {
	Enabled = true,
	Box = true,
	Name = true,
	Health = true,
	Distance = true,
	Color = Color3.fromRGB(0,170,255),
	Opacity = 0.35
}

--==================================================
-- UI (GLASS)
--==================================================

local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "CreateByL_UI"
gui.ResetOnSpawn = false

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 6 -- 🔥 weniger verschwommen

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(420,430)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BackgroundTransparency = 0.12
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextButton", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Create by L"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

--==================================================
-- COLLAPSE FIX (WICHTIG)
--==================================================

local content = Instance.new("Frame", main)
content.Position = UDim2.fromOffset(0,40)
content.Size = UDim2.new(1,0,1,-40)
content.BackgroundTransparency = 1

local collapsed = false

title.MouseButton1Click:Connect(function()
	collapsed = not collapsed

	TweenService:Create(
		main,
		TweenInfo.new(0.25,Enum.EasingStyle.Quad),
		{Size = collapsed and UDim2.fromOffset(200,40) or UDim2.fromOffset(420,430)}
	):Play()

	content.Visible = not collapsed
end)

--==================================================
-- TABS
--==================================================

local side = Instance.new("Frame", content)
side.Size = UDim2.fromOffset(110,360)
side.BackgroundTransparency = 1

local pages = Instance.new("Frame", content)
pages.Position = UDim2.fromOffset(120,0)
pages.Size = UDim2.fromOffset(280,360)
pages.BackgroundTransparency = 1

local function tab(txt,y)
	local b = Instance.new("TextButton", side)
	b.Size = UDim2.fromOffset(100,40)
	b.Position = UDim2.fromOffset(5,y)
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(55,55,55)
	Instance.new("UICorner", b)
	return b
end

local function page()
	local f = Instance.new("Frame", pages)
	f.Size = UDim2.fromScale(1,1)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

local aimTab = tab("AIMBOT",10)
local espTab = tab("ESP",60)
local setTab = tab("SETTINGS",110)

local aimP = page()
local espP = page()
local setP = page()
aimP.Visible = true

local function show(p)
	aimP.Visible=false espP.Visible=false setP.Visible=false
	p.Visible=true
end

aimTab.MouseButton1Click:Connect(function() show(aimP) end)
espTab.MouseButton1Click:Connect(function() show(espP) end)
setTab.MouseButton1Click:Connect(function() show(setP) end)

--==================================================
-- UI HELPERS (STABLE SLIDER)
--==================================================

local function toggle(p,text,y,default,cb)
	local b = Instance.new("TextButton", p)
	b.Size = UDim2.fromOffset(240,32)
	b.Position = UDim2.fromOffset(10,y)
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)

	local on = default
	local function upd()
		b.Text = text..": "..(on and "ON" or "OFF")
		b.BackgroundColor3 = on and Color3.fromRGB(0,160,0) or Color3.fromRGB(150,0,0)
	end
	upd()
	cb(on)

	b.MouseButton1Click:Connect(function()
		on = not on
		upd()
		cb(on)
	end)
end

local function slider(p,text,y,min,max,val,cb)
	local label = Instance.new("TextLabel", p)
	label.Position = UDim2.fromOffset(10,y)
	label.Size = UDim2.fromOffset(240,18)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)

	local bar = Instance.new("Frame", p)
	bar.Position = UDim2.fromOffset(10,y+20)
	bar.Size = UDim2.fromOffset(240,8)
	bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
	Instance.new("UICorner", fill)

	local dragging = false

	local function set(v)
		val = math.clamp(v,min,max)
		local pct = (val-min)/(max-min)
		fill.Size = UDim2.fromScale(pct,1)
		label.Text = text..": "..math.floor(val)
		cb(val)
	end
	set(val)

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging=true
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging then
			local pct = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			set(min+(max-min)*pct)
		end
	end)

	UIS.InputEnded:Connect(function()
		dragging=false
	end)
end

--==================================================
-- AIMBOT UI
--==================================================

toggle(aimP,"Aimbot",10,false,function(v) _G.AIM.Enabled=v end)
slider(aimP,"FOV",60,50,400,_G.AIM.FOV,function(v) _G.AIM.FOV=v end)
slider(aimP,"Strength",110,5,100,_G.AIM.Strength*100,function(v) _G.AIM.Strength=v/100 end)
slider(aimP,"Min Distance",160,0,1000,_G.AIM.MinDistance,function(v) _G.AIM.MinDistance=v end)

toggle(aimP,"WallCheck",210,_G.AIM.WallCheck,function(v) _G.AIM.WallCheck=v end)
toggle(aimP,"DeathCheck",250,_G.AIM.DeathCheck,function(v) _G.AIM.DeathCheck=v end)

--==================================================
-- ESP UI
--==================================================

toggle(espP,"ESP",10,true,function(v) _G.ESP.Enabled=v end)
toggle(espP,"Box",50,true,function(v) _G.ESP.Box=v end)
toggle(espP,"Name",90,true,function(v) _G.ESP.Name=v end)
toggle(espP,"Health",130,true,function(v) _G.ESP.Health=v end)
toggle(espP,"Distance",170,true,function(v) _G.ESP.Distance=v end)
slider(espP,"Opacity",220,0,100,_G.ESP.Opacity*100,function(v) _G.ESP.Opacity=v/100 end)

--==================================================
-- SETTINGS UI (FARBE)
--==================================================

slider(setP,"ESP Red",30,0,255,_G.ESP.Color.R*255,function(v)
	_G.ESP.Color = Color3.fromRGB(v,_G.ESP.Color.G*255,_G.ESP.Color.B*255)
end)
slider(setP,"ESP Green",80,0,255,_G.ESP.Color.G*255,function(v)
	_G.ESP.Color = Color3.fromRGB(_G.ESP.Color.R*255,v,_G.ESP.Color.B*255)
end)
slider(setP,"ESP Blue",130,0,255,_G.ESP.Color.B*255,function(v)
	_G.ESP.Color = Color3.fromRGB(_G.ESP.Color.R*255,_G.ESP.Color.G*255,v)
end)

--==================================================
-- FOV CIRCLE (FIXED)
--==================================================

local fov = Instance.new("Frame", gui)
fov.AnchorPoint = Vector2.new(0.5,0.5)
fov.Position = UDim2.fromScale(0.5,0.5)
fov.BackgroundTransparency = 1
Instance.new("UICorner", fov).CornerRadius = UDim.new(1,0)

local fovStroke = Instance.new("UIStroke", fov)

--==================================================
-- WALLCHECK
--==================================================

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist
rayParams.IgnoreWater = true

local function visible(part)
	if not _G.AIM.WallCheck then return true end
	rayParams.FilterDescendantsInstances = {LP.Character}
	local r = Workspace:Raycast(Camera.CFrame.Position, part.Position-Camera.CFrame.Position, rayParams)
	return r and r.Instance:IsDescendantOf(part.Parent)
end

--==================================================
-- AIMBOT CORE (STABLE)
--==================================================

local function getTarget()
	local best,bd = nil,math.huge
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local part = p.Character:FindFirstChild(_G.AIM.Part)
			if hum and hum.Health>0 and part and visible(part) then
				local d3 = (Camera.CFrame.Position-part.Position).Magnitude
				if d3>=_G.AIM.MinDistance then
					local s,on = Camera:WorldToViewportPoint(part.Position)
					if on then
						local d2 = (Vector2.new(s.X,s.Y)-Camera.ViewportSize/2).Magnitude
						if d2<_G.AIM.FOV and d2<bd then
							bd=d2 best=part
						end
					end
				end
			end
		end
	end
	return best
end

--==================================================
-- ESP CORE (FIXED)
--==================================================

local ESP = {}

local function addESP(p)
	if p==LP then return end

	local function apply(c)
		if ESP[p] then for _,v in pairs(ESP[p]) do v:Destroy() end end
		local hum = c:WaitForChild("Humanoid")
		local root = c:WaitForChild("HumanoidRootPart")

		local box = Instance.new("BoxHandleAdornment", gui)
		box.Adornee = c
		box.AlwaysOnTop = true
		box.ZIndex = 10

		local name = Instance.new("TextLabel", gui)
		name.BackgroundTransparency=1
		name.Font=Enum.Font.GothamBold
		name.TextSize=14

		local dist = name:Clone()
		local hpBG = Instance.new("Frame", gui)
		hpBG.Size=UDim2.fromOffset(4,50)
		hpBG.BackgroundColor3=Color3.fromRGB(30,30,30)
		local hp = Instance.new("Frame", hpBG)

		ESP[p]={box,name,dist,hpBG,hp}

		RunService.RenderStepped:Connect(function()
			if not _G.ESP.Enabled or hum.Health<=0 then
				for _,v in pairs(ESP[p]) do v.Visible=false end
				return
			end

			local pos,on = Camera:WorldToViewportPoint(root.Position)

			box.Visible=_G.ESP.Box and on
			box.Color3=_G.ESP.Color
			box.Transparency=1-_G.ESP.Opacity

			name.Visible=_G.ESP.Name and on
			name.Text=p.Name
			name.TextColor3=_G.ESP.Color
			name.Position=UDim2.fromOffset(pos.X,pos.Y-35)

			dist.Visible=_G.ESP.Distance and on
			dist.Text=math.floor((Camera.CFrame.Position-root.Position).Magnitude).."m"
			dist.TextColor3=_G.ESP.Color
			dist.Position=UDim2.fromOffset(pos.X,pos.Y-20)

			hpBG.Visible=_G.ESP.Health and on
			hpBG.Position=UDim2.fromOffset(pos.X-30,pos.Y-25)

			local hpp=hum.Health/hum.MaxHealth
			hp.Size=UDim2.fromScale(1,hpp)
			hp.Position=UDim2.fromScale(0,1-hpp)
			hp.BackgroundColor3=Color3.fromRGB(255-255*hpp,255*hpp,0)
		end)
	end

	if p.Character then apply(p.Character) end
	p.CharacterAdded:Connect(apply)
end

for _,p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)

--==================================================
-- MAIN LOOP
--==================================================

RunService.RenderStepped:Connect(function()
	fov.Visible=_G.AIM.Enabled
	fov.Size=UDim2.fromOffset(_G.AIM.FOV*2,_G.AIM.FOV*2)
	fovStroke.Color=_G.FOV.Color
	fovStroke.Thickness=_G.FOV.Thickness

	if not _G.AIM.Enabled then return end
	local t=getTarget()
	if not t then return end

	local predicted=t.Position+t.Velocity*_G.AIM.Prediction
	Camera.CFrame=Camera.CFrame:Lerp(
		CFrame.lookAt(Camera.CFrame.Position,predicted),
		_G.AIM.Strength
	)
end)
