-- ModuleScript: StatusBlackScreen
-- เก็บใน ReplicatedStorage.Modules.StatusBlackScreen

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

	-- Label กลางจอ ตัวใหญ่ สีขาว
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
	Label.Parent = Frame

	-- ปุ่มเปิด/ปิด
	ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(0, 150, 0, 40)
	ToggleButton.Position = UDim2.new(0.5, -75, 0, 20)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ToggleButton.Font = Enum.Font.Code
	ToggleButton.TextSize = 20
	ToggleButton.Text = "Toggle Status"
	ToggleButton.Parent = Frame

	-- ปุ่ม toggle GUI
	ToggleButton.MouseButton1Click:Connect(function()
		visible = not visible
		Frame.Visible = true -- ต้องให้ frame ยังอยู่
		Label.Visible = visible
	end)
end

-- อัพเดท GUI
local function updateGui()
	if not Label or not visible then return end

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

-- Loop update
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
	setupGui()
	visible = state
	Label.Visible = state
	Frame.Visible = true -- Frame ต้องอยู่ตลอด
end

return Status
