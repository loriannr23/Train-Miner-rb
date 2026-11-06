-- Run once from Roblox Studio's Luau command bar after importing Assets/Blender/fbx/*.fbx.
-- The imported FBX models are scaled to the 10-stud tile grid and kept in ServerStorage.

local ServerStorage = game:GetService("ServerStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

pcall(function() StarterGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor end)

local assetNames = {
	"Tile_Grass", "Tile_Woodland", "Tile_Crystal",
	"Tree_Full", "Tree_Sparse", "Tree_Bare", "Tree_Stump_Large", "Tree_Stump_Small",
	"Rock_Full", "Rock_Cracked", "Rock_Rubble", "Crystal_Full", "Crystal_Damaged",
	"Sawmill", "TownBank", "TownGym", "LuckyCasino", "Locomotive", "FlatbedWagon",
}

local function assetColor(assetName, partName)
	local name = string.lower(partName)
	local function has(fragment) return string.find(name, string.lower(fragment), 1, true) ~= nil end
	local colors = {
		soil = Color3.fromRGB(103, 68, 43), soilLight = Color3.fromRGB(141, 92, 50), grass = Color3.fromRGB(43, 151, 65), lime = Color3.fromRGB(104, 207, 74),
		wood = Color3.fromRGB(153, 86, 39), woodLight = Color3.fromRGB(221, 163, 83), woodDark = Color3.fromRGB(82, 44, 28),
		leafDark = Color3.fromRGB(20, 120, 55), leaf = Color3.fromRGB(38, 165, 64), leafLight = Color3.fromRGB(89, 193, 62),
		stone = Color3.fromRGB(72, 94, 112), stoneLight = Color3.fromRGB(137, 157, 162), stoneDark = Color3.fromRGB(43, 61, 79), ore = Color3.fromRGB(240, 112, 39),
		crystal = Color3.fromRGB(21, 196, 234), crystalLight = Color3.fromRGB(119, 239, 255), crystalDark = Color3.fromRGB(45, 111, 237),
		teal = Color3.fromRGB(27, 148, 165), tealLight = Color3.fromRGB(74, 203, 192), coral = Color3.fromRGB(244, 82, 65), cream = Color3.fromRGB(255, 222, 148),
		gold = Color3.fromRGB(255, 181, 45), iron = Color3.fromRGB(48, 67, 83), rubber = Color3.fromRGB(27, 33, 39), glass = Color3.fromRGB(89, 213, 247),
		purple = Color3.fromRGB(133, 71, 187), white = Color3.fromRGB(248, 249, 232), pink = Color3.fromRGB(248, 109, 143),
	}
	if assetName:match("^Tile_") then
		if has("rounded soil") then return assetName == "Tile_Crystal" and colors.stoneDark or (assetName == "Tile_Woodland" and colors.soilLight or colors.soil) end
		if has("grass surface") then return assetName == "Tile_Crystal" and Color3.fromRGB(48, 137, 180) or (assetName == "Tile_Woodland" and Color3.fromRGB(74, 163, 67) or colors.grass) end
		if has("pebble") then return colors.soilLight end
		if has("grass tuft") then return colors.lime end
	end
	if assetName:match("^Tree_") then
		if has("trunk") or has("branch") or has("stump") then return colors.wood end
		if has("cut") or has("heartwood") or has("snapped") then return colors.woodLight end
		if has("crown 00") or has("crown 02") then return colors.leafDark end
		if has("crown 01") or has("remaining foliage") then return colors.leaf end
		if has("crown 03") or has("needle tuft") then return colors.leafLight end
		if has("bare fork") then return colors.woodLight end
	end
	if assetName:match("^Rock_") then
		if has("copper") or has("vein") then return colors.ore end
		if has("dark lower") or has("fracture") then return colors.stoneDark end
		if has("pale rear") or has("rubble 1") then return colors.stoneLight end
		return colors.stone
	end
	if assetName:match("^Crystal_") then
		if has("mineral base") then return colors.stoneDark end
		if has("shard 00") or has("shard 04") then return colors.crystalDark end
		if has("shard 01") or has("shard 03") then return colors.crystal end
		if has("shard 02") then return colors.crystalLight end
		return colors.crystal
	end
	if assetName == "Sawmill" then
		if has("painted walls") then return colors.woodLight end
		if has("foundation") then return colors.stoneLight end
		if has("roof") or has("fascia") or has("saw blade") then return colors.teal end
		if has("chimney") then return colors.coral end
		if has("stripe") or has("saw tooth") or has("log cut") then return colors.cream end
		if has("conveyor") then return colors.iron end
		if has("slat") or has("hub") then return colors.gold end
		if has("log") then return colors.wood end
	end
	if assetName == "TownBank" or assetName == "TownGym" or assetName == "LuckyCasino" then
		if has("foundation") then return colors.stoneLight end
		if has("painted walls") then
			if assetName == "TownBank" then return colors.cream end
			if assetName == "TownGym" then return colors.coral end
			return colors.purple
		end
		if has("vent cap") then return colors.coral end
		if has("bold pitched roof") or has("roof vent") then return assetName == "LuckyCasino" and colors.coral or colors.teal end
		if has("sign") or has("fascia") or has("side pilaster") then return assetName == "TownGym" and colors.cream or colors.gold end
		if has("glass") then return colors.glass end
		if has("door") then return colors.wood end
		if has("coin") or has("dumbbell weight") or has("lucky star") or has("marquee bulb") then return colors.gold end
		if has("column") then return colors.white end
		if has("bank sign") or has("gym sign") or has("casino sign") then return colors.white end
	end
	if assetName == "Locomotive" then
		if has("iron") or has("chassis") or has("smokebox") or has("dome base") then return colors.iron end
		if has("teal") or has("boiler") then return colors.teal end
		if has("purple") or has("cab roof") then return colors.purple end
		if has("hub") then return colors.gold end
		if has("wheel") or has("rubber") then return colors.rubber end
		if has("window") or has("glass") then return colors.glass end
		if has("gold") or has("brass") or has("front ring") or has("cowcatcher") or has("connecting rod") then return colors.gold end
		if has("steam dome") then return colors.gold end
		if has("headlamp glow") then return colors.cream end
		if has("coral") or has("cab body") or has("buffer beam") or has("chimney") or has("front badge") then return colors.coral end
	end
	if assetName == "FlatbedWagon" then
		if has("iron") or has("frame") then return colors.iron end
		if has("wooden freight bed") or has("light log") then return colors.woodLight end
		if has("log") then return colors.wood end
		if has("wheel") then return colors.rubber end
		if has("hub") then return colors.gold end
		if has("post") then return colors.teal end
		if has("rail") then return colors.coral end
	end
	return Color3.fromRGB(238, 236, 224)
end

local assetFolder = ServerStorage:FindFirstChild("TrainMinerAssets") or Instance.new("Folder")
assetFolder.Name = "TrainMinerAssets"
assetFolder.Parent = ServerStorage

for _, name in ipairs(assetNames) do
	local model = assetFolder:FindFirstChild(name) or Workspace:FindFirstChild(name)
	if model and model:IsA("Model") then
		if not model:GetAttribute("TrainMinerAssetScaled") then
			model:ScaleTo(0.01)
			model:SetAttribute("TrainMinerAssetScaled", true)
		end
		for _, descendant in ipairs(model:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Color = assetColor(name, descendant.Name)
				descendant.Material = (name:match("^Crystal_") and descendant.Name:find("shard")) and Enum.Material.Neon or Enum.Material.SmoothPlastic
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.Massless = true
				if name:match("^Tile_") and (descendant.Name == "Rounded soil edge" or descendant.Name == "Soft grass surface") then
					descendant.CanCollide = true
				end
			end
		end
		model.Parent = assetFolder
	end
end

for _, child in ipairs(Workspace:GetChildren()) do
	if child:IsA("Model") and child.Name:match("^Create an original") then child:Destroy() end
end

local oldPrototype = Workspace:FindFirstChild("TrainMinerPrototype")
if oldPrototype then
	oldPrototype.Name = "TrainMinerPrototype_Blockout"
	oldPrototype.Parent = ServerStorage
end

local oldArchive = ServerStorage:FindFirstChild("TrainMinerPrototype_Blockout")
if oldArchive and oldArchive ~= oldPrototype then oldArchive:Destroy() end

local baseplate = Workspace:FindFirstChild("Baseplate")
if baseplate and baseplate:IsA("BasePart") then
	baseplate.Transparency = 1
	baseplate.CanCollide = false
	baseplate.CanTouch = false
end

Lighting.ClockTime = 14.25
Lighting.Brightness = 2.25
Lighting.Ambient = Color3.fromRGB(166, 196, 198)
Lighting.OutdoorAmbient = Color3.fromRGB(180, 207, 195)
Lighting.EnvironmentDiffuseScale = 0.55
Lighting.EnvironmentSpecularScale = 0.28
Lighting.GlobalShadows = true

local colorGrade = Lighting:FindFirstChild("TrainMinerColorGrade") or Instance.new("ColorCorrectionEffect")
colorGrade.Name = "TrainMinerColorGrade"
colorGrade.Saturation = 0.12
colorGrade.Contrast = 0.035
colorGrade.Brightness = 0.025
colorGrade.Parent = Lighting

local bloom = Lighting:FindFirstChild("TrainMinerBloom") or Instance.new("BloomEffect")
bloom.Name = "TrainMinerBloom"
bloom.Intensity = 0.18
bloom.Size = 18
bloom.Threshold = 1.05
bloom.Parent = Lighting

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
atmosphere.Density = 0.17
atmosphere.Offset = 0.1
atmosphere.Color = Color3.fromRGB(190, 231, 232)
atmosphere.Decay = Color3.fromRGB(107, 151, 143)
atmosphere.Glare = 0.08
atmosphere.Haze = 1.2
atmosphere.Parent = Lighting

local soundFolder = SoundService:FindFirstChild("TrainMinerSounds") or Instance.new("Folder")
soundFolder.Name = "TrainMinerSounds"
soundFolder.Parent = SoundService
for _, soundName in ipairs({ "UI_Click", "UI_Open", "UI_Confirm", "UI_Error", "Resource_WoodHit", "Resource_WoodBreak", "Resource_StoneHit", "Resource_CrystalHit" }) do
	if not soundFolder:FindFirstChild(soundName) then
		local sound = Instance.new("Sound")
		sound.Name = soundName
		sound.Volume = 0.38
		sound.RollOffMode = Enum.RollOffMode.Linear
		sound.Parent = soundFolder
	end
end

local function folder(parent, name)
	local item = parent:FindFirstChild(name) or Instance.new("Folder")
	item.Name = name
	item.Parent = parent
	return item
end

local prototype = Instance.new("Model")
prototype.Name = "TrainMinerPrototype"
prototype.Parent = Workspace
prototype:SetAttribute("TrainSpeed", 8)
prototype:SetAttribute("SawLevel", 1)
prototype:SetAttribute("TrainLap", 0)

local tileFolder = folder(prototype, "TerrainTiles")
local trackFolder = folder(prototype, "Track")
local resourceFolder = folder(prototype, "ResourceField")
local sceneryFolder = folder(prototype, "Scenery")
local townFolder = folder(prototype, "TownBuilds")

local function part(parent, name, size, cframe, color, material, shape)
	local item = Instance.new("Part")
	item.Name = name
	item.Size = size
	item.CFrame = cframe
	item.Color = color
	item.Material = material or Enum.Material.SmoothPlastic
	item.Anchored = true
	item.TopSurface = Enum.SurfaceType.Smooth
	item.BottomSurface = Enum.SurfaceType.Smooth
	item.CanTouch = false
	item.Shape = shape or Enum.PartType.Block
	item.Parent = parent
	return item
end

local base = part(prototype, "ContinuousForestSoil", Vector3.new(112, 1, 92), CFrame.new(0, -1.04, 0), Color3.fromRGB(83, 49, 34), Enum.Material.Ground)
base.CanCollide = true

local function anchoredVisual(model, collidable)
	for _, item in ipairs(model:GetDescendants()) do
		if item:IsA("BasePart") then
			item.Anchored = true
			item.CanCollide = collidable or false
			item.CanTouch = false
			item.Massless = true
		end
	end
end

local function asset(name)
	return assetFolder:FindFirstChild(name)
end

math.randomseed(2306)
local gridCenters = {}
for x = -50, 50, 10 do
	for z = -40, 40, 10 do
		table.insert(gridCenters, Vector3.new(x, -1, z))
	end
end

for index, center in ipairs(gridCenters) do
	local variation = (math.abs(center.X) * 3 + math.abs(center.Z) * 5 + index) % 13
	local tileName = "Tile_Grass"
	if variation == 0 or variation == 4 or variation == 9 then tileName = "Tile_Woodland" end
	if (center.Z == -30 and math.abs(center.X) <= 10) or (center.Z == 30 and math.abs(center.X) <= 10) then tileName = "Tile_Crystal" end
	local tileTemplate = asset(tileName)
	if tileTemplate then
		local tile = tileTemplate:Clone()
		tile.Name = (tileName == "Tile_Woodland" and "WoodlandTile" or "GrassTile") .. string.format("_%d_%d", center.X, center.Z)
		anchoredVisual(tile, false)
		for _, item in ipairs(tile:GetDescendants()) do
			if item:IsA("BasePart") and (item.Name == "Rounded soil edge" or item.Name == "Soft grass surface") then item.CanCollide = true end
		end
		tile:PivotTo(CFrame.new(center))
		tile.Parent = tileFolder
	end
	if index % 12 == 0 then task.wait() end
end

local nodes = {}
for _, x in ipairs({ -20, -10, 0, 10, 20 }) do
	table.insert(nodes, { x = x, z = -20 })
	table.insert(nodes, { x = x, z = 20 })
end
for _, z in ipairs({ -10, 0, 10 }) do
	table.insert(nodes, { x = -30, z = z })
	table.insert(nodes, { x = 30, z = z })
end

local distribution = { "Tree", "Tree", "Stone", "Tree", "Crystal", "Tree", "Stone", "Tree", "Tree", "Stone", "Crystal", "Tree", "Stone", "Tree", "Tree", "Crystal" }
local templates = {
	Tree = { "Tree_Full", 36 },
	Stone = { "Rock_Full", 48 },
	Crystal = { "Crystal_Full", 64 },
}

for index, data in ipairs(nodes) do
	local resourceType = distribution[(index - 1) % #distribution + 1]
	local templateInfo = templates[resourceType]
	local rootPosition = Vector3.new(data.x, 0.46, data.z)
	local node = Instance.new("Model")
	node.Name = resourceType .. "Node_" .. string.format("%02d", index)
	node:SetAttribute("ResourceType", resourceType)
	node:SetAttribute("Health", templateInfo[2])
	node:SetAttribute("MaxHealth", templateInfo[2])
	node:SetAttribute("DropReady", false)
	node:SetAttribute("Stage", 1)
	node:SetAttribute("TileKey", string.format("%d:%d", data.x, data.z))
	node:SetAttribute("ResourcePosition", rootPosition)
	node:SetAttribute("Yaw", math.random() * math.pi * 2)
	node:PivotTo(CFrame.new(rootPosition))
	local visual = asset(templateInfo[1]):Clone()
	visual.Name = "ResourceVisual"
	anchoredVisual(visual, false)
	visual:PivotTo(CFrame.new(rootPosition) * CFrame.Angles(0, node:GetAttribute("Yaw"), 0))
	visual.Parent = node
	node.Parent = resourceFolder
	if index % 8 == 0 then task.wait() end
end

local decorativePositions = {}
for _, z in ipairs({ -35, 35 }) do
	for x = -40, 40, 10 do table.insert(decorativePositions, Vector3.new(x, 0.46, z)) end
end
for _, x in ipairs({ -50, 50 }) do
	for z = -30, 30, 10 do
		if not (x == 50 and z >= -35 and z <= -5) then table.insert(decorativePositions, Vector3.new(x, 0.46, z)) end
	end
end

local placedForestProps = 0
for index, position in ipairs(decorativePositions) do
	local nearCity = false
	for _, site in ipairs({ Vector3.new(32, 0, -28), Vector3.new(46, 0, -28), Vector3.new(32, 0, -14), Vector3.new(46, 0, -14) }) do
		if (Vector3.new(position.X, 0, position.Z) - site).Magnitude < 10 then nearCity = true; break end
	end
	if not nearCity then
		local pick = (index % 11 == 0 and "Rock_Full") or (index % 7 == 0 and "Crystal_Full") or "Tree_Full"
		local decor = asset(pick):Clone()
		decor.Name = "ForestProp_" .. string.format("%02d", index)
		anchoredVisual(decor, false)
		decor:PivotTo(CFrame.new(position) * CFrame.Angles(0, math.random() * math.pi * 2, 0))
		decor.Parent = sceneryFolder
		placedForestProps += 1
	end
	if index % 10 == 0 then task.wait() end
end

local route = {
	Vector3.new(-18, 0.82, -11), Vector3.new(0, 0.82, -16), Vector3.new(18, 0.82, -11),
	Vector3.new(22, 0.82, 0), Vector3.new(18, 0.82, 11), Vector3.new(0, 0.82, 16),
	Vector3.new(-18, 0.82, 11), Vector3.new(-22, 0.82, 0),
}
for index, start in ipairs(route) do
	local finish = route[index % #route + 1]
	local horizontalStart = Vector3.new(start.X, 0.82, start.Z)
	local horizontalFinish = Vector3.new(finish.X, 0.82, finish.Z)
	local delta = horizontalFinish - horizontalStart
	local length = delta.Magnitude
	local direction = delta.Unit
	local steps = math.max(1, math.floor(length / 3.2))
	for stepIndex = 0, steps do
		local travel = math.min(length, stepIndex * 3.2)
		local center = horizontalStart + direction * travel
		local frame = CFrame.lookAt(center, center + direction)
		local sleeper = part(trackFolder, "HoneyWoodSleeper", Vector3.new(5.4, 0.28, 0.9), frame * CFrame.new(0, -0.17, 0), Color3.fromRGB(127, 72, 41), Enum.Material.WoodPlanks)
		sleeper.CanCollide = true
		for _, offset in ipairs({ -2, 2 }) do
			local rail = part(trackFolder, "BlueSteelRail", Vector3.new(0.38, 0.42, 3.9), frame * CFrame.new(offset, 0.06, 0), Color3.fromRGB(62, 94, 110), Enum.Material.Metal)
			rail.CanCollide = true
		end
	end
	task.wait()
end

local trackbed = part(trackFolder, "SoftTrackBed", Vector3.new(52, 0.2, 40), CFrame.new(0, 0.27, 0), Color3.fromRGB(104, 157, 91), Enum.Material.Grass)
trackbed.CanCollide = false

local salePosition = Vector3.new(0, 0.62, 22)
local salePad = part(prototype, "CoinDropSalePad", Vector3.new(14, 0.34, 7), CFrame.new(salePosition), Color3.fromRGB(255, 193, 63), Enum.Material.Neon)
salePad.Transparency = 0.08
salePad.CanCollide = false

local kioskBody = part(prototype, "Pine Junction Depot", Vector3.new(10, 4.6, 5), CFrame.new(0, 2.5, 30), Color3.fromRGB(31, 115, 127), Enum.Material.SmoothPlastic)
kioskBody.CanCollide = true
local kioskRoof = part(prototype, "Depot Candy Roof", Vector3.new(11.4, 0.9, 6.2), CFrame.new(0, 5.25, 30), Color3.fromRGB(250, 123, 72), Enum.Material.SmoothPlastic)
kioskRoof.CanCollide = false
local counter = part(prototype, "Gold Sell Counter", Vector3.new(8.8, 0.55, 1), CFrame.new(0, 1.25, 27.2), Color3.fromRGB(255, 205, 74), Enum.Material.WoodPlanks)
counter.CanCollide = false

local signAnchor = part(prototype, "SellSignAnchor", Vector3.new(0.2, 0.2, 0.2), CFrame.new(0, 6.2, 30), Color3.new(1, 1, 1))
signAnchor.Transparency = 1
signAnchor.CanCollide = false
local sign = Instance.new("BillboardGui")
sign.Name = "DepotSign"
sign.Size = UDim2.fromOffset(185, 54)
sign.StudsOffset = Vector3.new(0, 1, 0)
sign.AlwaysOnTop = false
sign.Adornee = signAnchor
sign.Parent = signAnchor
local signText = Instance.new("TextLabel")
signText.Size = UDim2.fromScale(1, 1)
signText.BackgroundColor3 = Color3.fromRGB(20, 54, 76)
signText.BackgroundTransparency = 0.04
signText.TextColor3 = Color3.fromRGB(255, 247, 218)
signText.Text = "PINE JUNCTION\nSELL CARGO · EARN COINS"
signText.TextSize = 14
signText.Font = Enum.Font.GothamBlack
signText.TextWrapped = true
signText.Parent = sign
local signCorner = Instance.new("UICorner")
signCorner.CornerRadius = UDim.new(0, 12)
signCorner.Parent = signText

local buildSites = {
	{ "Sawmill", "SAWMILL · 100 COINS", "3 WOOD → 1 PLANK", "", Vector3.new(32, 0.82, -28), Color3.fromRGB(250, 147, 74) },
	{ "TownBank", "BANK · 250 COINS", "10 PLANKS · COINS ×1.20", "", Vector3.new(46, 0.82, -28), Color3.fromRGB(255, 205, 75) },
	{ "TownGym", "GYM · LEVEL 3", "450 COINS + 25 PLANKS", "SPEED ×1.15", Vector3.new(32, 0.82, -14), Color3.fromRGB(79, 205, 226) },
	{ "LuckyCasino", "CASINO · LEVEL 5", "900 COINS + 50 PLANKS", "SAW LUCK ×1.25", Vector3.new(46, 0.82, -14), Color3.fromRGB(162, 110, 236) },
}

for _, data in ipairs(buildSites) do
	local site = Instance.new("Model")
	site.Name = "BuildSite_" .. data[1]
	local pad = part(site, "Foundation", Vector3.new(13, 0.38, 11), CFrame.new(data[5]), data[6], Enum.Material.SmoothPlastic)
	pad.CanCollide = true
	site.Parent = townFolder
end

local train = Instance.new("Model")
train.Name = "Train"
train.WorldPivot = CFrame.new(0, 1.05, 0)
local locomotive = asset("Locomotive"):Clone()
locomotive.Name = "Locomotive"
locomotive:PivotTo(CFrame.new(0, 1.05, 0))
locomotive.Parent = train
for index, z in ipairs({ 10, 19 }) do
	local wagon = asset("FlatbedWagon"):Clone()
	wagon.Name = "WoodWagon_" .. index
	wagon:PivotTo(CFrame.new(0, 1.05, z))
	wagon.Parent = train
end

local sawModule = Instance.new("Folder")
sawModule.Name = "SawModule"
sawModule.Parent = train
local sawCenter = CFrame.new(0, 3.05, -7.25)
local sawBlade = part(sawModule, "SawBlade", Vector3.new(0.34, 3.6, 3.6), sawCenter * CFrame.Angles(math.pi / 2, 0, 0), Color3.fromRGB(69, 111, 134), Enum.Material.Metal, Enum.PartType.Cylinder)
sawBlade.CanCollide = false
local sawHub = part(sawModule, "SawHub", Vector3.new(0.38, 1.2, 1.2), sawCenter * CFrame.new(0, 0, -0.24) * CFrame.Angles(math.pi / 2, 0, 0), Color3.fromRGB(255, 189, 63), Enum.Material.Metal, Enum.PartType.Cylinder)
sawHub.CanCollide = false
for index = 1, 12 do
	local angle = (index - 1) / 12 * math.pi * 2
	local tooth = Instance.new("WedgePart")
	tooth.Name = "SawTooth_" .. index
	tooth.Size = Vector3.new(0.52, 0.62, 0.34)
	tooth.CFrame = sawCenter * CFrame.new(math.cos(angle) * 1.7, math.sin(angle) * 1.7, -0.12) * CFrame.Angles(0, 0, angle)
	tooth.Color = Color3.fromRGB(226, 239, 229)
	tooth.Material = Enum.Material.Metal
	tooth.Anchored = true
	tooth.CanCollide = false
	tooth.CanTouch = false
	tooth.Parent = sawModule
end
anchoredVisual(train, false)
train.Parent = prototype
train:PivotTo(CFrame.lookAt(Vector3.new(-18, 1.05, -11), Vector3.new(-18, 1.05, -11) + Vector3.new(1, 0, -0.4)))

local spawn = Instance.new("SpawnLocation")
spawn.Name = "TownVisitorSpawn"
spawn.Size = Vector3.new(5, 1, 5)
spawn.CFrame = CFrame.new(0, 0.3, 35)
spawn.Anchored = true
spawn.Transparency = 1
spawn.CanCollide = true
spawn.Neutral = true
spawn.AllowTeamChangeOnTouch = false
spawn.Parent = prototype

return string.format("Built tile field (%d tiles), %d damageable nodes, %d forest props, %d rails/sleepers, four city build sites, sale depot, and a 3-car train. Imported models are in ServerStorage.TrainMinerAssets.", #gridCenters, #nodes, placedForestProps, #trackFolder:GetChildren())
