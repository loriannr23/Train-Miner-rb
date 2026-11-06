-- The server owns train movement so every client sees the same lap and resource hits.
local RunService = game:GetService("RunService")
local prototype = workspace:WaitForChild("TrainMinerPrototype")
local train = prototype:WaitForChild("Train")
local sawModule = train:WaitForChild("SawModule")
local blade = sawModule:WaitForChild("SawBlade")
local hub = sawModule:WaitForChild("SawHub")
local teeth = {}
for _, item in ipairs(sawModule:GetChildren()) do
	if item:IsA("BasePart") and item.Name:match("^SawTooth_") then table.insert(teeth, item) end
end

local sawColors = {
	[1] = Color3.fromRGB(205, 228, 235), [2] = Color3.fromRGB(64, 204, 235),
	[3] = Color3.fromRGB(255, 189, 67), [4] = Color3.fromRGB(255, 110, 83),
	[5] = Color3.fromRGB(189, 112, 255),
}

local points = {
	Vector3.new(-18, 1.05, -11), Vector3.new(0, 1.05, -16), Vector3.new(18, 1.05, -11),
	Vector3.new(22, 1.05, 0), Vector3.new(18, 1.05, 11), Vector3.new(0, 1.05, 16),
	Vector3.new(-18, 1.05, 11), Vector3.new(-22, 1.05, 0),
}

local function sampleLoop(distance)
	local lengths, total = {}, 0
	for index, point in ipairs(points) do
		local nextPoint = points[index % #points + 1]
		local length = (nextPoint - point).Magnitude
		lengths[index] = length
		total += length
	end
	local remaining = distance % total
	for index, point in ipairs(points) do
		local length = lengths[index]
		if remaining <= length then
			local nextPoint = points[index % #points + 1]
			local alpha = remaining / length
			local position = point:Lerp(nextPoint, alpha)
			return position, (nextPoint - point).Unit, math.floor(distance / total)
		end
		remaining -= length
	end
	return points[1], Vector3.xAxis, math.floor(distance / math.max(total, 1))
end

local distance = 0
local sawSpin = 0
RunService.Heartbeat:Connect(function(deltaTime)
	local speed = prototype:GetAttribute("TrainSpeed") or 8
	distance += speed * deltaTime
	local position, direction, lap = sampleLoop(distance)
	prototype:SetAttribute("TrainLap", lap)
	train:PivotTo(CFrame.lookAt(position, position + direction))
	sawSpin += deltaTime * (16 + speed * 0.4)
	local level = prototype:GetAttribute("SawLevel") or 1
	local radius = 1.8 + math.clamp(level - 1, 0, 6) * 0.13
	local color = sawColors[level] or sawColors[5]
	blade.Size = Vector3.new(0.34, radius * 2, radius * 2)
	blade.Color = color
	local pivot = train:GetPivot()
	local center = pivot * CFrame.new(0, 3.05, -7.25)
	local spin = CFrame.Angles(0, 0, sawSpin)
	blade.CFrame = center * spin * CFrame.Angles(math.pi / 2, 0, 0)
	hub.CFrame = center * spin * CFrame.new(0, 0, -0.24) * CFrame.Angles(math.pi / 2, 0, 0)
	for index, tooth in ipairs(teeth) do
		local angle = (index - 1) / #teeth * math.pi * 2
		local toothAngle = angle + sawSpin
		tooth.CFrame = center * CFrame.Angles(0, 0, sawSpin) * CFrame.new(math.cos(angle) * radius, math.sin(angle) * radius, -0.12) * CFrame.Angles(0, 0, toothAngle)
	end
end)
