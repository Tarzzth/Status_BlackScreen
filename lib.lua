-- ModuleScript: StatusBlackScreen
-- เก็บใน ReplicatedStorage.Modules.StatusBlackScreen

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Status = {}
Status.__index = Status

local ScreenGui, Frame, Label, ToggleButton
local watchList = {}
local visible = true

-- สร้าง GUI
local function setupGui()
	if ScreenGui then return end

	ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "StatusBlackScreen"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- Fullscreen black frame
	Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.Position = UDim2.new(0, 0, 0, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0
	Frame.Parent = ScreenGui

	-- Label แสดงข้อมูล
	Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -20, 1, -50)
	Label.Position = UDim2.new(0, 10, 0, 10)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Color3.fromRGB(0, 255, 0)
	Label.Font = Enum.Font.Code
	Label.TextSize = 16
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextYAlignment = Enum.TextYAlignment.Top
	Label.Text = ""
	Label.Parent = Frame

	-- ปุ่มเปิด/ปิด
	ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(0, 120, 0, 30)
	ToggleButton.Position = UDim2.new(1, -130, 0, 10)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 0)
	ToggleButton.Font = Enum.Font.Code
	ToggleButton.TextSize = 14
	ToggleButton.Text = "Toggle Status"
	ToggleButton.Parent = Frame

	ToggleButton.MouseButton1Click:Connect(function()
		visible = not visible
		Frame.Visible = visible
	end)
end

-- อัพเดท GUI
local function updateGui()
	if not Label then return end

	local textLines = {}
	for name, func in pairs(watchList) do
		local success, value = pcall(func)
		if success then
			table.insert(textLines, name .. ": " .. tostring(value))
		else
			table.insert(textLines, name .. ": [Error]")
		end
	end

	Label.Text = table.concat(textLines, "\n")
end

-- Loop อัพเดท
RunService.RenderStepped:Connect(updateGui)

-- API
function Status.Watch(name, callback)
	setupGui()
	watchList[name] = callback
end

function Status.Unwatch(name)
	watchList[name] = nil
end

function Status.Clear()
	table.clear(watchList)
end

function Status.Toggle(state)
	if Frame then
		Frame.Visible = state
		visible = state
	end
end

return Status
