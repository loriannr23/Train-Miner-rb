-- After importing the OGG files through Roblox Studio's asset importer, paste their
-- resulting numeric asset IDs below, then run this script once in the Studio command bar.
local SoundService = game:GetService("SoundService")
local ids = {
	UI_Click = "",
	UI_Open = "",
	UI_Confirm = "",
	UI_Error = "",
	Resource_WoodHit = "",
	Resource_WoodBreak = "",
	Resource_StoneHit = "",
	Resource_CrystalHit = "",
}

local folder = SoundService:FindFirstChild("TrainMinerSounds")
if not folder then return "TrainMinerSounds is missing; run build_starter_scene.luau first." end

local configured, total = 0, 0
for name, assetId in pairs(ids) do
	total += 1
	local sound = folder:FindFirstChild(name)
	if sound and assetId ~= "" then
		local digits = string.match(assetId, "%d+")
		if digits then
			sound.SoundId = "rbxassetid://" .. digits
			sound.Volume = name:match("^UI_") and 0.45 or 0.32
			configured += 1
		end
	end
end

return string.format("Configured %d of %d sound IDs.", configured, total)
