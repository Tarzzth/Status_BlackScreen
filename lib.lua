-- BlackScreenDebug.lua
-- Module แสดงหน้าจอดำพร้อมข้อมูล + ปุ่มเปิดปิด

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local module = {}
local ScreenGui, Frame, InfoLabel, ToggleButton
local isVisible = false

-- ฟังก์ชันสร้าง UI
local function createUI()
    if ScreenGui then return end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlackScreenDebug"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- พื้นหลังดำ
    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.Visible = false
    Frame.Parent = ScreenGui

    -- ข้อความข้อมูล
    InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextColor3 = Color3.new(1, 1, 1)
    InfoLabel.TextScaled = true
    InfoLabel.Text = ""
    InfoLabel.Font = Enum.Font.SourceSansBold
    InfoLabel.Parent = Frame

    -- ปุ่ม toggle
    ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 120, 0, 40)
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.Text = "Toggle Debug"
    ToggleButton.Parent = ScreenGui

    ToggleButton.MouseButton1Click:Connect(function()
        module.Toggle()
    end)
end

-- API: อัพเดทข้อมูลที่โชว์
function module.Update(infoTable)
    createUI()
    local text = ""
    for k, v in pairs(infoTable) do
        text = text .. tostring(k) .. ": " .. tostring(v) .. "\n"
    end
    InfoLabel.Text = text
end

-- API: เปิด/ปิด
function module.Toggle()
    createUI()
    isVisible = not isVisible
    Frame.Visible = isVisible
end

-- API: เปิด
function module.Show()
    createUI()
    isVisible = true
    Frame.Visible = true
end

-- API: ปิด
function module.Hide()
    createUI()
    isVisible = false
    Frame.Visible = false
end

return module
