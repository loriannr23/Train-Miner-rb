local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local DataStoreService = game:GetService("DataStoreService")

local package = ReplicatedStorage:WaitForChild("TrainMiner")
local shared = package:WaitForChild("Shared")
local Config = require(shared:WaitForChild("GameConfig"))
local remotes = package:FindFirstChild("Remotes") or Instance.new("Folder")
remotes.Name = "Remotes"
remotes.Parent = package

local function remote(className, name)
	local object = remotes:FindFirstChild(name) or Instance.new(className)
	object.Name = name
	object.Parent = remotes
	return object
end

local request = remote("RemoteEvent", "Request")
local stateUpdate = remote("RemoteEvent", "StateUpdate")
local effect = remote("RemoteEvent", "Effect")
local assets = ServerStorage:WaitForChild("TrainMinerAssets")
local prototype = workspace:WaitForChild("TrainMinerPrototype")
local train = prototype:WaitForChild("Train")
local resourceField = prototype:WaitForChild("ResourceField")
local profileStore = DataStoreService:GetDataStore("TrainMiner_Profile_v1")
local profiles = {}
local nodeCooldowns = {}

local function freshProfile()
	return { Coins = 0, Level = 1, XP = 0, Cargo = { Tree = 0, Stone = 0, Crystal = 0 }, Planks = 0, Saws = { [1] = 1 }, EquippedSaw = 1, Buildings = {} }
end

local function publicState(profile)
	local counts = {}
	for level, count in pairs(profile.Saws) do counts[tonumber(level)] = count end
	local cargoCount = 0
	for _, count in pairs(profile.Cargo) do cargoCount += count end
	return {
		Coins = profile.Coins, Level = profile.Level, XP = profile.XP, Cargo = cargoCount, Planks = profile.Planks or 0,
		Saws = counts, EquippedSaw = profile.EquippedSaw, Buildings = profile.Buildings,
		LuckMultiplier = profile.Buildings.LuckyCasino and 1.25 or 1,
		CoinMultiplier = profile.Buildings.TownBank and 1.20 or 1,
	}
end

local function sendState(player, message)
	local profile = profiles[player]
	if profile then stateUpdate:FireClient(player, publicState(profile), message) end
end

local function addXp(player, amount)
	local profile = profiles[player]
	profile.XP += amount
	while profile.XP >= profile.Level * 80 do
		profile.XP -= profile.Level * 80
		profile.Level += 1
	end
end

local function chooseSaw(profile)
	local highestUnlocked, totalWeight = 1, 0
	for level, data in pairs(Config.Saws) do
		if profile.Level >= data.UnlockLevel then
			highestUnlocked = math.max(highestUnlocked, level)
			local luck = profile.Buildings.LuckyCasino and level >= 3 and 1.25 or 1
			totalWeight += data.Weight * luck
		end
	end
	local pick = math.random() * totalWeight
	for level = 1, highestUnlocked do
		local data = Config.Saws[level]
		if data and profile.Level >= data.UnlockLevel then
			local luck = profile.Buildings.LuckyCasino and level >= 3 and 1.25 or 1
			pick -= data.Weight * luck
			if pick <= 0 then return level end
		end
	end
	return 1
end

local function placeBuilding(building)
	local town = prototype:WaitForChild("TownBuilds")
	if town:FindFirstChild(building.Id) then return end
	local template = assets:FindFirstChild(building.Id)
	if not template then return end
	local site = town:FindFirstChild("BuildSite_" .. building.Id)
	if site then site:Destroy() end
	local clone = template:Clone()
	clone.Name = building.Id
	clone:PivotTo(CFrame.new(building.Position))
	clone.Parent = town
end

local function onRequest(player, action, value)
	local profile = profiles[player]
	if not profile then return end
	if action == "Sync" then
		sendState(player)
	elseif action == "Roll" then
		if profile.Coins < Config.RollCost then sendState(player, "Dir fehlen Münzen für einen Sägen-Roll."); return end
		profile.Coins -= Config.RollCost
		local level = chooseSaw(profile)
		profile.Saws[level] = (profile.Saws[level] or 0) + 1
		sendState(player, ("Säge Level %d gezogen!"):format(level))
	elseif action == "Merge" then
		local level = 0
		for candidate = 19, 1, -1 do
			local nextSaw = Config.Saws[candidate + 1]
			if nextSaw and profile.Level >= nextSaw.UnlockLevel and (profile.Saws[candidate] or 0) >= 2 then level = candidate; break end
		end
		if level == 0 then sendState(player, "Du brauchst zwei gleiche, freigeschaltete Sägen."); return end
		profile.Saws[level] -= 2
		profile.Saws[level + 1] = (profile.Saws[level + 1] or 0) + 1
		profile.EquippedSaw = level + 1
		prototype:SetAttribute("SawLevel", profile.EquippedSaw)
		sendState(player, ("Zwei Sägen wurden zu Level %d gemergt!"):format(level + 1))
	elseif action == "Equip" then
		local level = math.floor(tonumber(value) or 1)
		if (profile.Saws[level] or 0) > 0 then profile.EquippedSaw = level; prototype:SetAttribute("SawLevel", level); sendState(player, "Säge ausgerüstet.") end
	elseif action == "EquipBest" then
		local bestLevel = profile.EquippedSaw
		for level, count in pairs(profile.Saws) do
			local numericLevel = tonumber(level)
			local sawData = numericLevel and Config.Saws[numericLevel]
			if numericLevel and count > 0 and numericLevel > bestLevel and sawData and profile.Level >= sawData.UnlockLevel then bestLevel = numericLevel end
		end
		profile.EquippedSaw = bestLevel
		prototype:SetAttribute("SawLevel", bestLevel)
		sendState(player, ("Säge Level %d ausgerüstet."):format(bestLevel))
	elseif action == "Build" then
		local building
		for _, data in ipairs(Config.Buildings) do if data.Id == value then building = data; break end end
		if not building or profile.Buildings[building.Id] then return end
		if profile.Level < building.UnlockLevel then sendState(player, "Dieses Gebäude wird mit einem höheren Level freigeschaltet."); return end
		if profile.Coins < building.Cost then sendState(player, "Dir fehlen Münzen für dieses Gebäude."); return end
		if profile.Planks < (building.MaterialCost or 0) then sendState(player, ("Dir fehlen %d Bretter."):format((building.MaterialCost or 0) - profile.Planks)); return end
		if not assets:FindFirstChild(building.Id) then sendState(player, "Das Gebäudemodell fehlt noch im Asset-Ordner."); return end
		profile.Coins -= building.Cost
		profile.Planks -= (building.MaterialCost or 0)
		profile.Buildings[building.Id] = true
		placeBuilding(building)
		prototype:SetAttribute("TrainSpeed", Config.TrainSpeed * (profile.Buildings.TownGym and 1.15 or 1))
		sendState(player, building.Label .. " gebaut! " .. building.Bonus)
	end
end
request.OnServerEvent:Connect(onRequest)

local function loadProfile(player)
	local profile = freshProfile()
	local ok, saved = pcall(function() return profileStore:GetAsync("Player_" .. player.UserId) end)
	if ok and type(saved) == "table" then
		for key, value in pairs(saved) do profile[key] = value end
		local loadedSaws = {}
		for level, count in pairs(saved.Saws or { [1] = 1 }) do
			local numericLevel = tonumber(level)
			if numericLevel then loadedSaws[numericLevel] = count end
		end
		profile.Saws = next(loadedSaws) and loadedSaws or { [1] = 1 }
		profile.Buildings = profile.Buildings or {}
		profile.Cargo = profile.Cargo or { Tree = 0, Stone = 0, Crystal = 0 }
		profile.Planks = profile.Planks or 0
	end
	profiles[player] = profile
	prototype:SetAttribute("SawLevel", profile.EquippedSaw)
	for _, building in ipairs(Config.Buildings) do
		if profile.Buildings[building.Id] then placeBuilding(building) end
	end
	if profile.Buildings.TownGym then prototype:SetAttribute("TrainSpeed", Config.TrainSpeed * 1.15) end
	sendState(player)
end

local function saveProfile(player)
	local profile = profiles[player]
	if not profile then return end
	local saved = {
		Coins = profile.Coins, Level = profile.Level, XP = profile.XP, Cargo = profile.Cargo,
		Planks = profile.Planks, EquippedSaw = profile.EquippedSaw, Buildings = profile.Buildings, Saws = {},
	}
	for level, count in pairs(profile.Saws) do saved.Saws[tostring(level)] = count end
	pcall(function() profileStore:SetAsync("Player_" .. player.UserId, saved) end)
end
Players.PlayerAdded:Connect(loadProfile)
Players.PlayerRemoving:Connect(function(player) saveProfile(player); profiles[player] = nil end)
game:BindToClose(function() for _, player in ipairs(Players:GetPlayers()) do saveProfile(player) end end)

local function stageFor(resource, health)
	local count = #resource.Stages
	return math.clamp(math.floor((1 - health / resource.MaxHealth) * count) + 1, 1, count)
end

local function setNodeStage(node, stageIndex)
	if node:GetAttribute("Stage") == stageIndex then return end
	local resourceType = node:GetAttribute("ResourceType")
	local resource = Config.Resources[resourceType]
	local stageName = resource.Stages[stageIndex]
	local template = assets:FindFirstChild(stageName)
	if not template then return end
	local old = node:FindFirstChild("ResourceVisual")
	if old then old:Destroy() end
	local clone = template:Clone()
	clone.Name = "ResourceVisual"
	local target = node:GetAttribute("ResourcePosition")
	local position = typeof(target) == "Vector3" and target or node:GetPivot().Position
	clone:PivotTo(CFrame.new(position) * CFrame.Angles(0, node:GetAttribute("Yaw") or 0, 0))
	clone.Parent = node
	node:SetAttribute("Stage", stageIndex)
end

local function sellCargo()
	for player, profile in pairs(profiles) do
		local payout, cargoCount = 0, 0
		local planksMade = 0
		local woodCount = profile.Cargo.Tree or 0
		if profile.Buildings.Sawmill then
			planksMade = math.floor(woodCount / 3)
			profile.Planks += planksMade
			payout += (woodCount - planksMade * 3) * Config.Resources.Tree.SellValue
			cargoCount += woodCount
			profile.Cargo.Tree = 0
		end
		for resourceType, resource in pairs(Config.Resources) do
			if resourceType == "Tree" and profile.Buildings.Sawmill then continue end
			local count = profile.Cargo[resourceType] or 0
			payout += count * resource.SellValue
			cargoCount += count
			profile.Cargo[resourceType] = 0
		end
		if cargoCount > 0 then
			payout = math.floor(payout * (profile.Buildings.TownBank and 1.20 or 1))
			profile.Coins += payout
			addXp(player, math.max(4, math.floor(payout / 5)))
			local message = ("Ladung verkauft: +%d Münzen"):format(payout)
			if planksMade > 0 then message ..= (" · Sägewerk: +%d Bretter"):format(planksMade) end
			sendState(player, message)
		end
	end
end

local lastSale = 0
game:GetService("RunService").Heartbeat:Connect(function()
	local currentPosition = train:GetPivot().Position
	local now = os.clock()
	for _, node in ipairs(resourceField:GetChildren()) do
		if node:IsA("Model") and now - (nodeCooldowns[node] or 0) >= Config.HarvestCooldown then
			local nodePosition = node:GetAttribute("ResourcePosition")
			if typeof(nodePosition) ~= "Vector3" then nodePosition = node:GetPivot().Position end
			if (nodePosition - currentPosition).Magnitude <= Config.HarvestRadius then
				nodeCooldowns[node] = now
				local resourceType = node:GetAttribute("ResourceType")
				local resource = Config.Resources[resourceType]
				if resource then
					if node:GetAttribute("DropReady") then
						local lap = prototype:GetAttribute("TrainLap") or 0
						if lap >= (node:GetAttribute("ReadyLap") or lap) then
							for player, profile in pairs(profiles) do
								local drop = resource.Drop
								profile.Cargo[resourceType] = (profile.Cargo[resourceType] or 0) + drop
								addXp(player, Config.XpPerResource)
								sendState(player, ("Eingesammelt: %d %s"):format(drop, resource.Label))
							end
							node:SetAttribute("DropReady", false)
							node:SetAttribute("Health", resource.MaxHealth)
							setNodeStage(node, 1)
							effect:FireAllClients("Collect", resourceType, nodePosition)
						end
					else
						local damage = 1
						for player, profile in pairs(profiles) do
							local saw = Config.Saws[profile.EquippedSaw] or Config.Saws[1]
							damage = math.max(damage, saw.Damage)
						end
						local health = math.max(0, (node:GetAttribute("Health") or resource.MaxHealth) - damage)
						node:SetAttribute("Health", health)
						if health <= 0 then
							node:SetAttribute("DropReady", true)
							node:SetAttribute("ReadyLap", (prototype:GetAttribute("TrainLap") or 0) + 1)
							setNodeStage(node, #resource.Stages)
						else
							setNodeStage(node, stageFor(resource, health))
						end
						effect:FireAllClients(health <= 0 and "Break" or "Hit", resourceType, nodePosition)
					end
				end
			end
		end
	end
	local sellNear = (currentPosition - Config.SellZonePosition).Magnitude <= Config.SellZoneRadius
	if sellNear and now - lastSale > 4 then lastSale = now; sellCargo() end
end)
