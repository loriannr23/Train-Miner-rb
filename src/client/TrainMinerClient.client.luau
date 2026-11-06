local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local package = ReplicatedStorage:WaitForChild("TrainMiner")
local remotes = package:WaitForChild("Remotes")
local request = remotes:WaitForChild("Request")
local stateUpdate = remotes:WaitForChild("StateUpdate")
local gui = Instance.new("ScreenGui")
gui.Name = "TrainMinerHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local palette = {
	Ink = Color3.fromRGB(20, 54, 76), Teal = Color3.fromRGB(34, 132, 163),
	Sky = Color3.fromRGB(71, 193, 224), Gold = Color3.fromRGB(255, 190, 61),
	Cream = Color3.fromRGB(255, 247, 218), White = Color3.fromRGB(255, 255, 255),
}

local function round(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 14)
	corner.Parent = object
	local stroke = Instance.new("UIStroke")
	stroke.Color = palette.Ink
	stroke.Thickness = 2.5
	stroke.Transparency = 0.12
	stroke.Parent = object
end

local function label(parent, text, size, position, dimensions, fontSize)
	local item = Instance.new("TextLabel")
	item.BackgroundTransparency = 1
	item.Text = text
	item.TextColor3 = palette.White
	item.TextStrokeTransparency = 0.75
	item.Font = Enum.Font.GothamBold
	item.TextSize = fontSize or 20
	item.Size = dimensions
	item.Position = position
	item.TextXAlignment = Enum.TextXAlignment.Left
	item.Parent = parent
	return item
end

local header = Instance.new("Frame")
header.Name = "ResourceHeader"
header.Size = UDim2.new(0, 360, 0, 72)
header.Position = UDim2.new(0.025, 0, 0.035, 0)
header.BackgroundColor3 = palette.Teal
header.Parent = gui
round(header, 18)
local stats = label(header, "🪙 0      ⭐ LEVEL 1", UDim2.fromScale(1, 1), UDim2.fromOffset(18, 0), UDim2.new(1, -30, 0.55, 0), 19)
local plankLabel = label(header, "📦 Ladung 0     🪵 Bretter 0", UDim2.fromScale(1, 1), UDim2.fromOffset(18, 36), UDim2.new(1, -30, 0.34, 0), 14)

local toast = Instance.new("TextLabel")
toast.Name = "Toast"
toast.AnchorPoint = Vector2.new(0.5, 0)
toast.Position = UDim2.new(0.5, 0, 0.04, 0)
toast.Size = UDim2.new(0, 360, 0, 42)
toast.BackgroundColor3 = palette.Ink
toast.TextColor3 = palette.White
toast.Font = Enum.Font.GothamBold
toast.TextSize = 17
toast.Visible = false
toast.Parent = gui
round(toast, 13)

local panel = Instance.new("Frame")
panel.Name = "YardPanel"
panel.AnchorPoint = Vector2.new(1, 0.5)
panel.Position = UDim2.new(0.98, 0, 0.53, 0)
panel.Size = UDim2.new(0, 250, 0, 436)
panel.BackgroundColor3 = palette.Ink
panel.Parent = gui
round(panel, 20)
local title = label(panel, "🚂  ZUG & STADT", UDim2.new(1, -24, 0, 32), UDim2.fromOffset(14, 12), UDim2.new(1, -28, 0, 32), 17)
local sawInfo = label(panel, "Säge Lv. 1 · Schaden 2", UDim2.new(1, -24, 0, 26), UDim2.fromOffset(14, 46), UDim2.new(1, -28, 0, 26), 14)

local function button(parent, name, text, color, y, callback)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Text = text
	b.TextColor3 = palette.Ink
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.Size = UDim2.new(1, -24, 0, 43)
	b.Position = UDim2.fromOffset(12, y)
	b.BackgroundColor3 = color
	b.AutoButtonColor = true
	b.Parent = parent
	round(b, 12)
	b.Activated:Connect(callback)
	return b
end

button(panel, "RollSaw", "🎲  Säge rollen · 30 Münzen", palette.Gold, 81, function() request:FireServer("Roll") end)
button(panel, "MergeSaw", "🔧  Gleiche Sägen mergen", palette.Sky, 132, function() request:FireServer("Merge") end)
button(panel, "EquipBestSaw", "⚙  Beste Säge ausrüsten", palette.Sky, 183, function() request:FireServer("EquipBest") end)
button(panel, "BuildSawmill", "🪚  Sägewerk · 100 Münzen", palette.Cream, 234, function() request:FireServer("Build", "Sawmill") end)
button(panel, "BuildBank", "🏦  Bank · 250 + 10 Bretter", palette.Cream, 285, function() request:FireServer("Build", "TownBank") end)
button(panel, "BuildGym", "🏋  Fitness · 450 + 25 Bretter", palette.Cream, 336, function() request:FireServer("Build", "TownGym") end)

local cityButton = Instance.new("TextButton")
cityButton.Name = "BuildCasino"
cityButton.Text = "💎 Casino · Lv5 · 900 + 50 Bretter"
cityButton.TextColor3 = palette.Ink
cityButton.Font = Enum.Font.GothamBold
cityButton.TextSize = 14
cityButton.Size = UDim2.new(1, -24, 0, 36)
cityButton.Position = UDim2.fromOffset(12, 387)
cityButton.BackgroundColor3 = palette.Gold
cityButton.Parent = panel
round(cityButton, 11)
cityButton.Activated:Connect(function() request:FireServer("Build", "LuckyCasino") end)

local buildingButtons = {
	{ Id = "Sawmill", Button = panel:FindFirstChild("BuildSawmill"), Name = "Sägewerk", Unlock = 1 },
	{ Id = "TownBank", Button = panel:FindFirstChild("BuildBank"), Name = "Wald-Bank", Unlock = 1 },
	{ Id = "TownGym", Button = panel:FindFirstChild("BuildGym"), Name = "Lok-Fitness", Unlock = 3 },
	{ Id = "LuckyCasino", Button = cityButton, Name = "Kristall-Casino", Unlock = 5 },
}

local cameraButton = Instance.new("TextButton")
cameraButton.Name = "CameraMode"
cameraButton.Text = "📷  Kamera: Diorama"
cameraButton.AnchorPoint = Vector2.new(0, 1)
cameraButton.Position = UDim2.new(0.025, 0, 0.97, 0)
cameraButton.Size = UDim2.new(0, 210, 0, 47)
cameraButton.BackgroundColor3 = palette.Gold
cameraButton.TextColor3 = palette.Ink
cameraButton.Font = Enum.Font.GothamBold
cameraButton.TextSize = 16
cameraButton.Parent = gui
round(cameraButton, 14)

local cameraMode = 1
local cameraNames = { "Diorama", "Third Person", "First Person" }
local cameraConnection
local function setCameraMode()
	local camera = workspace.CurrentCamera
	if cameraConnection then cameraConnection:Disconnect(); cameraConnection = nil end
	if cameraMode == 1 then
		player.CameraMode = Enum.CameraMode.Classic
		camera.CameraType = Enum.CameraType.Scriptable
		cameraConnection = RunService.RenderStepped:Connect(function()
			local focus = Vector3.new(0, 0, 0)
			camera.CFrame = CFrame.lookAt(focus + Vector3.new(48, 58, 56), focus)
		end)
	elseif cameraMode == 2 then
		player.CameraMode = Enum.CameraMode.Classic
		camera.CameraType = Enum.CameraType.Custom
		player.CameraMinZoomDistance = 13
		player.CameraMaxZoomDistance = 36
	else
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		camera.CameraType = Enum.CameraType.Custom
	end
	cameraButton.Text = "📷  Kamera: " .. cameraNames[cameraMode]
end
cameraButton.Activated:Connect(function()
	cameraMode = cameraMode % #cameraNames + 1
	setCameraMode()
end)
setCameraMode()

local function playSound(name)
	local folder = SoundService:FindFirstChild("TrainMinerSounds")
	local sound = folder and folder:FindFirstChild(name)
	if sound and sound:IsA("Sound") and sound.SoundId ~= "" then
		local voice = sound:Clone()
		voice.Parent = SoundService
		voice:Play()
		Debris:AddItem(voice, 4)
	end
end

local soundNames = {
	RollSaw = "UI_Confirm", MergeSaw = "UI_Confirm", EquipBestSaw = "UI_Click", BuildSawmill = "UI_Open",
	BuildBank = "UI_Open", BuildGym = "UI_Open", BuildCasino = "UI_Open", CameraMode = "UI_Click",
}
for _, item in ipairs(panel:GetChildren()) do
	if item:IsA("TextButton") then item.Activated:Connect(function() playSound(soundNames[item.Name] or "UI_Click") end) end
end
cityButton.Activated:Connect(function() playSound("UI_Open") end)
cameraButton.Activated:Connect(function() playSound("UI_Click") end)

local function burst(position, resourceType, isBreak)
	local colors = { Tree = Color3.fromRGB(255, 191, 86), Stone = Color3.fromRGB(164, 194, 207), Crystal = Color3.fromRGB(74, 224, 245) }
	local color = resourceType == "Coin" and palette.Gold or colors[resourceType] or palette.Gold
	local count = isBreak and 12 or 5
	for index = 1, count do
		local chip = Instance.new("Part")
		chip.Name = "HarvestSpark"
		chip.Shape = index % 3 == 0 and Enum.PartType.Ball or Enum.PartType.Block
		chip.Size = Vector3.new(0.24, 0.24, 0.24)
		chip.Material = Enum.Material.Neon
		chip.Color = color
		chip.Anchored = true
		chip.CanCollide = false
		chip.CFrame = CFrame.new(position + Vector3.new(0, 1.5, 0))
		chip.Parent = workspace
		local angle = index / count * math.pi * 2
		local destination = chip.Position + Vector3.new(math.cos(angle) * (isBreak and 3.2 or 1.7), math.random(12, 34) / 10, math.sin(angle) * (isBreak and 3.2 or 1.7))
		TweenService:Create(chip, TweenInfo.new(isBreak and 0.58 or 0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = destination, Transparency = 1, Size = Vector3.zero }):Play()
		Debris:AddItem(chip, 0.7)
	end
end

local lastUiSound = 0
stateUpdate.OnClientEvent:Connect(function(state, message)
	stats.Text = ("🪙 %d      ⭐ LEVEL %d · %d/%d XP"):format(state.Coins, state.Level, state.XP, state.Level * 80)
	plankLabel.Text = ("📦 Ladung %d     🪵 Bretter %d"):format(state.Cargo, state.Planks or 0)
	local sawLevel = state.EquippedSaw
	local damage = ({ [1] = 2, [2] = 4, [3] = 8, [4] = 15, [5] = 28 })[sawLevel] or 2
	sawInfo.Text = ("Säge Lv. %d · Schaden %d · Anzahl %d"):format(sawLevel, damage, state.Saws[sawLevel] or 0)
	for _, entry in ipairs(buildingButtons) do
		if state.Buildings[entry.Id] then
			entry.Button.Text = "✅ " .. entry.Name .. " gebaut"
			entry.Button.Active = false
			entry.Button.AutoButtonColor = false
			entry.Button.BackgroundColor3 = palette.Sky
		elseif state.Level < entry.Unlock then
			entry.Button.Text = ("🔒 %s · Level %d"):format(entry.Name, entry.Unlock)
			entry.Button.Active = false
			entry.Button.AutoButtonColor = false
			entry.Button.BackgroundColor3 = Color3.fromRGB(155, 171, 177)
		else
			entry.Button.Active = true
			entry.Button.AutoButtonColor = true
		end
	end
	if message then
		toast.Text = message
		toast.Visible = true
		task.delay(2.6, function() toast.Visible = false end)
		if os.clock() - lastUiSound > 0.35 then
			local failed = string.find(message, "Dir fehlen", 1, true) or string.find(message, "Du brauchst", 1, true) or string.find(message, "gesperrt", 1, true)
			playSound(failed and "UI_Error" or "UI_Confirm")
			lastUiSound = os.clock()
		end
	end
end)

remotes:WaitForChild("Effect").OnClientEvent:Connect(function(effectName, resourceType, position)
	if effectName == "Hit" then
		local soundName = ({ Tree = "Resource_WoodHit", Stone = "Resource_StoneHit", Crystal = "Resource_CrystalHit" })[resourceType]
		if soundName then playSound(soundName) end
		burst(position, resourceType, false)
	elseif effectName == "Break" then
		local soundName = ({ Tree = "Resource_WoodBreak", Stone = "Resource_StoneHit", Crystal = "Resource_CrystalHit" })[resourceType]
		if soundName then playSound(soundName) end
		burst(position, resourceType, true)
	elseif effectName == "Collect" then
		burst(position, "Coin", true)
	end
end)

request:FireServer("Sync")

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.C then cameraButton:Activate() end
end)
