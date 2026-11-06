local Config = {}

Config.TileSize = 10
Config.GridWidth = 11
Config.GridDepth = 9
Config.TrainSpeed = 8
Config.HarvestRadius = 8.5
Config.HarvestCooldown = 0.65
Config.SellZonePosition = Vector3.new(0, 1.2, 21)
Config.SellZoneRadius = 10

Config.Resources = {
	Tree = {
		Label = "Holz",
		MaxHealth = 36,
		Drop = 3,
		SellValue = 8,
		Stages = { "Tree_Full", "Tree_Sparse", "Tree_Bare", "Tree_Stump_Large", "Tree_Stump_Small" },
	},
	Stone = {
		Label = "Stein",
		MaxHealth = 48,
		Drop = 2,
		SellValue = 12,
		Stages = { "Rock_Full", "Rock_Cracked", "Rock_Rubble" },
	},
	Crystal = {
		Label = "Kristall",
		MaxHealth = 64,
		Drop = 1,
		SellValue = 24,
		Stages = { "Crystal_Full", "Crystal_Damaged" },
	},
}

Config.Saws = {
	[1] = { Damage = 2, UnlockLevel = 1, Weight = 70, Color = Color3.fromRGB(211, 232, 240) },
	[2] = { Damage = 4, UnlockLevel = 1, Weight = 25, Color = Color3.fromRGB(64, 204, 235) },
	[3] = { Damage = 8, UnlockLevel = 5, Weight = 5, Color = Color3.fromRGB(255, 189, 67) },
	[4] = { Damage = 15, UnlockLevel = 10, Weight = 3, Color = Color3.fromRGB(255, 110, 83) },
	[5] = { Damage = 28, UnlockLevel = 18, Weight = 2, Color = Color3.fromRGB(189, 112, 255) },
}
Config.RollCost = 30
Config.MergeCoinCost = 0
Config.XpPerResource = 8

Config.Buildings = {
	{ Id = "TownBank", Label = "Wald-Bank", Cost = 250, UnlockLevel = 1, Bonus = "Münzen ×1,20", BonusType = "Coins", Multiplier = 1.20, Position = Vector3.new(-8, 1.5, -3) },
	{ Id = "Sawmill", Label = "Pinewood-Sägewerk", Cost = 100, MaterialCost = 0, UnlockLevel = 1, Bonus = "3 Holz → 1 Brett", BonusType = "Process", Position = Vector3.new(32, 0.82, -28) },
	{ Id = "TownBank", Label = "Wald-Bank", Cost = 250, MaterialCost = 10, UnlockLevel = 1, Bonus = "Münzen ×1,20", BonusType = "Coins", Multiplier = 1.20, Position = Vector3.new(46, 0.82, -28) },
	{ Id = "TownGym", Label = "Lok-Fitness", Cost = 450, MaterialCost = 25, UnlockLevel = 3, Bonus = "Zugtempo ×1,15", BonusType = "Speed", Multiplier = 1.15, Position = Vector3.new(32, 0.82, -14) },
	{ Id = "LuckyCasino", Label = "Kristall-Casino", Cost = 900, MaterialCost = 50, UnlockLevel = 5, Bonus = "Säge-Glück ×1,25", BonusType = "Luck", Multiplier = 1.25, Position = Vector3.new(46, 0.82, -14) },
}

return Config
