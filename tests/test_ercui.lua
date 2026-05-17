--// ERC UI Library Test
--// API Source:
--// https://raw.githubusercontent.com/John-loercol/rbx.Assets.erc/refs/heads/API.Services.get/ERC%20GUI%20-%20library%20UI%20-%20New.lua

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/John-loercol/rbx.Assets.erc/refs/heads/API.Services.get/ERC%20GUI%20-%20library%20UI%20-%20New.lua"))()

--// Create Window
local Window = Library:window({
    TitleText = "ERC GUI TEST",
    SubTitle = "UI Library Test Script",
    IconText = "Open GUI",
    Size = UDim2.new(0, 520, 0, 420),
    FontText = Enum.Font.GothamBold,
    ImageIcon = "rbxassetid://138560507380517"
})

--// Create Tabs
local MainTab = Window:CreateTab({
    Name = "Main"
})

local ConfigTab = Window:CreateTab({
    Name = "Config"
})

local DebugTab = Window:CreateTab({
    Name = "Debug"
})

--====================================================
-- MAIN TAB
--====================================================

MainTab:createToggleSection({
    Name = "Basic Components"
})

MainTab:createToggleDescription({
    Description = "This tab demonstrates every major component from ERC UI Library."
})

--// Toggle
local AutoFarmToggle = MainTab:createToggle({
    Name = "Auto Farm",
    Description = "Enable or disable autofarm system.",
    default = false,
    callback = function(state)
        print("[Toggle] Auto Farm:", state)
    end
})

--// Button
MainTab:createToggleButton({
    Name = "Test Notification",
    Description = "Send a test notification",
    callback = function()
        Library:Notification({
            Title = "ERC GUI",
            Description = "Notification test successful!",
            Time = 3
        })
        print("[Button] Notification Fired")
    end
})

--// Textbox
local PlayerTextbox = MainTab:createToggleText({
    Name = "Player Name",
    Description = "Type any player name",
    PlaceHolderText = "Enter username...",
    callback = function(text)
        print("[Textbox] Input:", text)
    end
})

--// Text Label
local StatusLabel = MainTab:createToggleTextLabel({
    Name = "Status",
    Description = "Runtime status",
    Text = "Waiting..."
})

task.spawn(function()
    while task.wait(1) do
        StatusLabel:SetText("Current Time: " .. os.date("%X"))
    end
end)

--// Slider INT
MainTab:createToggleSlider({
    Name = "WalkSpeed",
    mode = "int",
    minValue = 16,
    maxValue = 200,
    default = 16,
    callback = function(value)
        print("[Slider INT] WalkSpeed:", value)
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

--// Slider DECIMAL
MainTab:createToggleSlider({
    Name = "Gravity",
    mode = "decimal",
    minValue = 0,
    maxValue = 500,
    default = workspace.Gravity,
    callback = function(value)
        workspace.Gravity = value
        print("[Slider DECIMAL] Gravity:", value)
    end
})

--// Dropdown Single
local TeamDropdown = MainTab:createToggleDropdown({
    Name = "Team Select",
    Description = "Single selection dropdown",
    DefaultText = "Choose team",
    mode = "Single",
    List = {
        "Red Team",
        "Blue Team",
        "Green Team",
        "Yellow Team"
    },
    callback = function(value)
        print("[Dropdown Single] Selected:", value)
    end
})

--// Dropdown Multi
MainTab:createToggleDropdown({
    Name = "ESP Targets",
    Description = "Multi selection dropdown",
    DefaultText = "Select targets",
    mode = "Multi",
    List = {
        "Players",
        "NPCs",
        "Items",
        "Chests",
        "Bosses"
    },
    callback = function(values)
        print("[Dropdown Multi] Values:")
        for i, v in pairs(values) do
            print(i, v)
        end
    end
})

--// Color Picker
MainTab:createToggleColorPicker({
    Name = "ESP Color",
    Description = "Choose ESP highlight color",
    defaultColor = Color3.fromRGB(0, 170, 255),
    callback = function(color)
        print("[ColorPicker]", color)
    end
})

--====================================================
-- CONFIG TAB
--====================================================

ConfigTab:createToggleSection({
    Name = "Config Utilities"
})

ConfigTab:createToggleDescription({
    Description = "Utility functions for testing UI updates."
})

ConfigTab:createToggleButton({
    Name = "Enable Auto Farm",
    Description = "Force toggle state to true",
    callback = function()
        AutoFarmToggle:SetState(true)
    end
})

ConfigTab:createToggleButton({
    Name = "Disable Auto Farm",
    Description = "Force toggle state to false",
    callback = function()
        AutoFarmToggle:SetState(false)
    end
})

ConfigTab:createToggleButton({
    Name = "Set Random Team",
    Description = "Random dropdown value",
    callback = function()
        local teams = {
            "Red Team",
            "Blue Team",
            "Green Team",
            "Yellow Team"
        }
        TeamDropdown:Set(teams[math.random(1, #teams)])
    end
})

ConfigTab:createToggleButton({
    Name = "Clear Textbox",
    Description = "Reset textbox content",
    callback = function()
        PlayerTextbox:ClearText()
    end
})

ConfigTab:createToggleButton({
    Name = "Test Warning Notification",
    Description = "Another notification example",
    callback = function()
        Library:Notification({
            Title = "Warning",
            Description = "This is another notification test.",
            Time = 5
        })
    end
})

--====================================================
-- DEBUG TAB
--====================================================

DebugTab:createToggleSection({
    Name = "Debug Output"
})

DebugTab:createToggleDescription({
    Description = "Executor / Runtime debug testing."
})

DebugTab:createToggleButton({
    Name = "Print Executor",
    Description = "Print executor name",
    callback = function()
        local executor = identifyexecutor and identifyexecutor() or "Unknown"
        warn("Executor:", executor)
    end
})

DebugTab:createToggleButton({
    Name = "Print JobId",
    Description = "Print current server JobId",
    callback = function()
        warn("JobId:", game.JobId)
    end
})

DebugTab:createToggleButton({
    Name = "Rejoin",
    Description = "Teleport back to current server",
    callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

DebugTab:createToggleButton({
    Name = "Destroy GUI",
    Description = "Close ERC UI completely",
    callback = function()
        local gui = game:GetService("CoreGui"):FindFirstChild("ERC_GUI")
        if gui then
            gui:Destroy()
        end
    end
})

--====================================================
-- STARTUP NOTIFICATION
--====================================================

Library:Notification({
    Title = "ERC GUI",
    Description = "Test script loaded successfully.",
    Time = 5
})

print("[ERC GUI] Test script loaded.")
