-- ModuleScript: StatusBlackScreen
-- เก็บใน ReplicatedStorage.Modules.StatusBlackScreen

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Status = {}
Status.__index = Status

-- GUI ตัวหลัก
local ScreenGui
local BlackFrame, Label
local ToggleFrame, ToggleButton
local watchList = {}   -- name -> callback
local watchOrder = {}  -- ลำดับการเรียก watch
local visible = true

-- สร้าง GUI
local function setupGui()
	if ScreenGui then return end

	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "StatusBlackScreen"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- Fullscreen black frame
	BlackFrame = Instance.new("Frame")
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)
	BlackFrame.Position = UDim2.new(0, 0, 0, 0)
	BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BackgroundTransparency = 0
	BlackFrame.Parent = ScreenGui

	-- Label กลางจอ
	Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, 0, 1, 0)
	Label.Position = UDim2.new(0, 0, 0, 0)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.Font = Enum.Font.Code
	Label.TextSize = 40
	Label.TextScaled = true
	Label.TextXAlignment = Enum.TextXAlignment.Center
	Label.TextYAlignment = Enum.TextYAlignment.Center
	Label.Text = ""
	Label.Parent = BlackFrame

	-- Frame สำหรับปุ่ม toggle แยกออกมา
	ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(0, 160, 0, 50)
	ToggleFrame.Position = UDim2.new(1, -170, 0, 20)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Parent = ScreenGui

	-- ปุ่ม toggle
	ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(1, 0, 1, 0)
	ToggleButton.Position = UDim2.new(0, 0, 0, 0)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButton.Font = Enum.Font.Code
	ToggleButton.TextSize = 20
	ToggleButton.Text = "Toggle Status"
	ToggleButton.Parent = ToggleFrame

	-- กดปุ่ม toggle
	ToggleButton.MouseButton1Click:Connect(function()
		visible = not visible
		BlackFrame.Visible = visible
	end)
end

-- อัพเดท GUI
local function updateGui()
	if not Label or not visible then return end

	local textLines = {}
	for _, name in ipairs(watchOrder) do
		local func = watchList[name]
		if func then
			local success, value = pcall(func)
			if success then
				table.insert(textLines, name .. ": " .. tostring(value))
			else
				table.insert(textLines, name .. ": [Error]")
			end
		end
	end

	Label.Text = table.concat(textLines, "\n")
end

RunService.RenderStepped:Connect(updateGui)

-- API
function Status.Watch(name, callback)
	setupGui()
	if not watchList[name] then
		table.insert(watchOrder, name)
	end
	watchList[name] = callback
end

function Status.Unwatch(name)
	watchList[name] = nil
	for i, key in ipairs(watchOrder) do
		if key == name then
			table.remove(watchOrder, i)
			break
		end
	end
end

function Status.Clear()
	table.clear(watchList)
	table.clear(watchOrder)
end

function Status.Toggle(state)
	setupGui()
	visible = state
	BlackFrame.Visible = state
end

return Status
