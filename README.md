# 🎨 ERC UI Library

> A powerful, lightweight, and easy-to-use UI library for Roblox scripting
> 
> Inspired by **WindUI** — designed to be fast, responsive, and production-ready

![Version](https://img.shields.io/badge/version-0.0.1.1-blue)
![License](https://img.shields.io/badge/license-AGPL--3.0-green)
![Language](https://img.shields.io/badge/language-Lua-purple)
![Status](https://img.shields.io/badge/status-Beta-orange)

---

## 📖 Table of Contents

1. [Overview](#-overview)
2. [Features](#-features)
3. [Installation](#-installation)
4. [Quick Start](#-quick-start)
5. [Architecture](#-architecture)
6. [API Reference](#-api-reference)
   - [Main Window](#1-main-window)
   - [Tabs](#2-tabs-and-navigation)
   - [Components](#3-components)
   - [Component API Methods](#component-api-methods---return-values)
   - [Notifications](#4-notifications)
7. [Complete Examples](#-complete-examples)
8. [Advanced Usage](#-advanced-usage)
9. [Performance Tips](#-performance-tips)
10. [License](#-license)
11. [Contributing](#-contributing)
12. [Support](#-support)

---

## 🎯 Overview

**ERC UI Library** is a comprehensive Roblox UI framework designed to simplify the creation of professional-looking user interfaces. It provides ready-to-use components, automatic layout management, and smooth animations without requiring complex setup.

### Why ERC UI?

- **Zero Boilerplate** — Create a complete UI with just a few lines of code
- **Developer Friendly** — Intuitive API that follows common UI patterns
- **High Performance** — Optimized for Roblox's rendering pipeline
- **Production Ready** — Used in real-world scripts and games
- **Fully Customizable** — Every component can be styled and configured
- **Rich Component Set** — 8+ components to cover most UI needs

---

## ✨ Features

### Core Features
- ✅ **Multi-tab Interface System** — Organize features across multiple tabs
- ✅ **8 UI Components** — Toggle, Button, TextBox, Label, Slider, Dropdown, ColorPicker, Section
- ✅ **Notification System** — Toast-style notifications with auto-dismiss
- ✅ **Window Management** — Draggable, minimizable, fullscreen, closable
- ✅ **Smooth Animations** — Tweening animations for all interactions
- ✅ **Responsive Design** — Automatically adjusts to viewport changes

### Advanced Features
- ✅ **Single & Multi-select Dropdowns** — Flexible selection modes
- ✅ **HSV Color Picker** — Professional color selection with real-time preview
- ✅ **Integer & Decimal Sliders** — Support for both data types
- ✅ **Search-enabled Dropdowns** — Filter options in real-time
- ✅ **Custom Callbacks** — React to user interactions instantly
- ✅ **Component API Returns** — Get/Set values on components programmatically

### Performance
- ✅ **Lightweight** — Minimal memory footprint
- ✅ **Efficient Rendering** — Smart reuse of UI elements
- ✅ **Connection Cleanup** — Automatic disconnection of event listeners
- ✅ **Optimized Tweening** — Cancellation of unused animations

---

## 📦 Installation

### Method 1: Direct Load (Online)
```lua
local erclib = loadstring(game:HttpGet("https://raw.githubusercontent.com/John-loercol/erc-library-ui/main/source-main/global-erc-uilib-0.0.1.1.lua"))()
```

### Method 2: Local File Load
```lua
local erclib = loadstring(readfile("source-main/global-erc-uilib-0.0.1.1.lua"))()
```

### Method 3: Module Script
```lua
local erclib = require(script.Parent:WaitForChild("global-erc-uilib-0.0.1.1"))
```

### Requirements
- Roblox game running
- Script execution enabled (LocalScript or via exploit)
- Access to CoreGui service

---

## 🚀 Quick Start

Here's the simplest way to get started:

```lua
-- Load the library
local erclib = loadstring(game:HttpGet("..."))()

-- Create a window
local Window = erclib:window({
    TitleText = "My Script",
    SubTitle = "v1.0.0",
    IconText = "Open",
    Size = UDim2.new(0, 520, 0, 420)
})

-- Create a tab
local MainTab = Window:CreateTab({ Name = "Main" })

-- Add a toggle and store the API
local AutoFarmToggle = MainTab:createToggle({
    Name = "Enable Feature",
    Description = "Toggle this feature on/off",
    default = false,
    callback = function(state)
        print("Feature enabled:", state)
    end
})

-- Use the returned API to control the component
AutoFarmToggle:SetState(true) -- Enable it programmatically

-- Add a button
MainTab:createToggleButton({
    Name = "Click Me",
    Description = "A simple button",
    callback = function()
        print("Button clicked!")
    end
})

-- Show a notification
erclib:Notification({
    Title = "Success",
    Description = "Script loaded!",
    Time = 3
})
```

That's it! You now have a fully functional UI.

---

## 🏗️ Architecture

### Component Hierarchy

```
ERC UI Library
│
├─ Screen Overlay (ScreenGui)
│  │
│  ├─ Main Window Frame
│  │  ├─ Title Bar
│  │  │  ├─ Icon (Image)
│  │  │  ├─ Title Label
│  │  │  ├─ Subtitle Label
│  │  │  └─ Control Buttons (Close, Minimize, Fullscreen)
│  │  │
│  │  ├─ Sidebar (Tab Navigation)
│  │  │  ├─ Tab Button 1
│  │  │  ├─ Tab Button 2
│  │  │  └─ Tab Button N
│  │  │
│  │  └─ Content Area (Tab Content)
│  │     ├─ ScrollingFrame
│  │     └─ Components
│  │        ├─ Sections
│  │        ├─ Toggles
│  │        ├─ Buttons
│  │        ├─ TextBoxes
│  │        ├─ Sliders
│  │        ├─ Dropdowns
│  │        └─ ColorPickers
│  │
│  ├─ Notification Container
│  │  ├─ Notification 1
│  │  ├─ Notification 2
│  │  └─ Notification N
│  │
│  └─ Modal Overlays (Dropdowns, ColorPicker)
│     ├─ Dropdown Modal
│     └─ ColorPicker Modal
│
└─ Minimized Icon Button (Docked when window is minimized)
```

---

## 📚 API Reference

### 1. Main Window

#### `erclib:window(config)`

Creates the main UI window.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `TitleText` | string | `"ERC UI — library"` | Main window title |
| `SubTitle` | string | `"By erc.t.tm.th"` | Subtitle/description |
| `ImageIcon` | rbxassetid | `"rbxassetid://138560507380517"` | Window icon image ID |
| `Size` | UDim2 | `UDim2.new(0,400,0,232)` | Window size (width, height) |
| `IconText` | string | `"open gui"` | Text on minimize button |
| `FontText` | Enum.Font | `Enum.Font.SourceSansBold` | Font family for all text |

**Returns:** `Window` object

---

### 2. Tabs and Navigation

#### `Window:CreateTab(config)`

Creates a new tab in the window.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Name` | string | Tab name/label |

**Returns:** `Tab` object

---

### 3. Components

#### 3.1 Toggle (Boolean Switch)

##### `Tab:createToggle(config)`

Creates a boolean toggle switch.

**Returns:** Toggle API object with methods `:SetState()` and `:GetState()`

---

#### 3.2 Button

##### `Tab:createToggleButton(config)`

Creates a clickable button.

**Returns:** nil (No return value, only callback)

---

#### 3.3 Text Input Box

##### `Tab:createToggleText(config)`

Creates a text input field.

**Returns:** TextBox API object with methods `:SetText()`, `:GetText()`, `:ClearText()`

---

#### 3.4 Text Label (Read-Only)

##### `Tab:createToggleTextLabel(config)`

Creates a read-only text display.

**Returns:** Label API object with methods `:SetText()`, `:GetText()`, `:ClearText()`

---

#### 3.5 Slider

##### `Tab:createToggleSlider(config)`

Creates a numeric slider.

**Returns:** Slider API object with methods `:SetValue()`, `:GetValue()`

---

#### 3.6 Dropdown (Single & Multi-Select)

##### `Tab:createToggleDropdown(config)`

Creates a dropdown selector.

**Returns:** Dropdown API object with methods `:Add()`, `:AddList()`, `:Get()`, `:Set()`, `:SetMultiple()`, `:Clear()`, `:ClearSelection()`

---

#### 3.7 Color Picker

##### `Tab:createToggleColorPicker(config)`

Creates an HSV-based color picker.

**Returns:** ColorPicker API object with methods `:GetColor()`, `:SetColor()`

---

## Component API Methods - Return Values

Each component returns an API object that allows you to interact with it programmatically. Here are the complete available methods:

### **Toggle API** ✅

Store the returned object to control the toggle:

```lua
local Toggle = Tab:createToggle({
    Name = "Auto Farm",
    default = false,
    callback = function(state)
        print("Toggle changed:", state)
    end
})
```

**Available Methods:**

```lua
-- Set the toggle state (true = enabled, false = disabled)
Toggle:SetState(true)
Toggle:SetState(false)

-- Get the current state
local currentState = Toggle:GetState()
if currentState then
    print("Toggle is ON")
else
    print("Toggle is OFF")
end
```

**Full Example:**
```lua
local autoFarmToggle = MainTab:createToggle({
    Name = "Auto Farm",
    default = false,
    callback = function(state)
        if state then
            print("Auto farming started!")
        else
            print("Auto farming stopped!")
        end
    end
})

-- Enable it after 2 seconds
task.wait(2)
autoFarmToggle:SetState(true)

-- Check status later
task.wait(5)
if autoFarmToggle:GetState() then
    print("Farm is still running")
end
```

---

### **TextBox API** ✅

Store the returned object to control text input:

```lua
local TextInput = Tab:createToggleText({
    Name = "Username",
    PlaceholderText = "Enter username"
})
```

**Available Methods:**

```lua
-- Set the text value
TextInput:SetText("John123")

-- Get the current text
local username = TextInput:GetText()
print("Username entered:", username)

-- Clear all text
TextInput:ClearText()
```

**Full Example:**
```lua
local playerNameInput = MainTab:createToggleText({
    Name = "Target Player",
    PlaceholderText = "Enter player name"
})

MainTab:createToggleButton({
    Name = "Search",
    callback = function()
        local targetName = playerNameInput:GetText()
        
        if targetName == "" then
            playerNameInput:SetText("ERROR: Name is required!")
            task.wait(1.5)
            playerNameInput:ClearText()
            return
        end
        
        print("Searching for:", targetName)
    end
})
```

---

### **Text Label API** ✅

Store the returned object to display dynamic text:

```lua
local StatusLabel = Tab:createToggleTextLabel({
    Name = "Status",
    Text = "Initializing..."
})
```

**Available Methods:**

```lua
-- Update the label text
StatusLabel:SetText("Connected")

-- Get the current text
local currentStatus = StatusLabel:GetText()
print("Status:", currentStatus)

-- Clear the text
StatusLabel:ClearText()
```

**Full Example:**
```lua
local connectionStatus = MainTab:createToggleTextLabel({
    Name = "Connection",
    Text = "Connecting..."
})

-- Simulate connection steps
connectionStatus:SetText("⏳ Connecting...")
task.wait(1)

connectionStatus:SetText("🔐 Authenticating...")
task.wait(1)

connectionStatus:SetText("✓ Connected")
```

---

### **Slider API** ✅

Store the returned object to control numeric values:

```lua
local SpeedSlider = Tab:createToggleSlider({
    Name = "Walk Speed",
    mode = "int",
    minValue = 16,
    maxValue = 200,
    default = 16,
    callback = function(value)
        print("Speed changed to:", value)
    end
})
```

**Available Methods:**

```lua
-- Set the slider to a specific value
SpeedSlider:SetValue(100)

-- Get the current value
local currentSpeed = SpeedSlider:GetValue()
print("Current speed:", currentSpeed)
```

**Full Example:**
```lua
local gravitySlider = MainTab:createToggleSlider({
    Name = "Gravity",
    mode = "decimal",
    minValue = 0,
    maxValue = 100,
    default = workspace.Gravity,
    callback = function(value)
        workspace.Gravity = value
    end
})

MainTab:createToggleButton({
    Name = "Zero Gravity",
    callback = function()
        gravitySlider:SetValue(0)
    end
})

MainTab:createToggleButton({
    Name = "Normal Gravity",
    callback = function()
        gravitySlider:SetValue(workspace.Gravity)
    end
})
```

---

### **Dropdown API** ✅

Store the returned object to manage selections:

```lua
local TeamDropdown = Tab:createToggleDropdown({
    Name = "Choose Team",
    mode = "Single",
    DefaultText = "Pick a team..."
})
```

**Available Methods:**

```lua
-- Add a single option
Dropdown:Add("Red Team")

-- Add multiple options (clears previous)
Dropdown:AddList({"Red Team", "Blue Team", "Green Team"})

-- Get selected value(s)
local selected = Dropdown:Get()
print("Selected:", selected)

-- Set selection (single mode)
Dropdown:Set("Blue Team")

-- Set multiple selections (multi mode only)
Dropdown:SetMultiple({"Red Team", "Green Team"})

-- Clear all options from dropdown
Dropdown:Clear()

-- Deselect all (keeps options visible)
Dropdown:ClearSelection()

-- Refresh visual state
Dropdown:RefreshButtonStates()
```

**Example - Single Select:**
```lua
local gamemodeDropdown = MainTab:createToggleDropdown({
    Name = "Gamemode",
    mode = "Single",
    DefaultText = "Select gamemode..."
})

gamemodeDropdown:AddList({"Survival", "Creative", "Adventure"})

MainTab:createToggleButton({
    Name = "Load Gamemode",
    callback = function()
        local selected = gamemodeDropdown:Get()
        if selected then
            print("Loading:", selected)
        end
    end
})
```

**Example - Multi-Select:**
```lua
local espFilterDropdown = MainTab:createToggleDropdown({
    Name = "ESP Filters",
    mode = "Multi",
    DefaultText = "Select filters..."
})

espFilterDropdown:AddList({"Players", "NPCs", "Enemies", "Items"})

MainTab:createToggleButton({
    Name = "Apply Filters",
    callback = function()
        local selected = espFilterDropdown:Get()
        print("Active filters:", table.concat(selected, ", "))
    end
})
```

---

### **Color Picker API** ✅

Store the returned object to handle colors:

```lua
local ColorPicker = Tab:createToggleColorPicker({
    Name = "ESP Color",
    defaultColor = Color3.fromRGB(0, 170, 255)
})
```

**Available Methods:**

```lua
-- Get the selected color (returns R, G, B, Alpha, Color3)
local r, g, b, alpha, color3 = ColorPicker:GetColor()
print(string.format("RGB(%d, %d, %d)", r, g, b))

-- Set the color and alpha
local newColor = Color3.fromRGB(255, 100, 50)
ColorPicker:SetColor(newColor, 0.8)
```

**Full Example:**
```lua
local espColorPicker = MainTab:createToggleColorPicker({
    Name = "ESP Color",
    defaultColor = Color3.fromRGB(0, 255, 0)
})

MainTab:createToggleButton({
    Name = "Apply Color",
    callback = function()
        local r, g, b, alpha, color3 = espColorPicker:GetColor()
        print(string.format("Applying color RGB(%d, %d, %d)", r, g, b))
        
        -- Apply to all ESP objects
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Frame") and obj.Name == "ESP" then
                obj.BackgroundColor3 = color3
            end
        end
    end
})

MainTab:createToggleButton({
    Name = "Reset to Red",
    callback = function()
        espColorPicker:SetColor(Color3.fromRGB(255, 0, 0), 1)
    end
})
```

---

### 4. Notifications

#### `erclib:Notification(config)`

Displays a toast-style notification.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | string | `"ERC SYSTEM"` | Notification title |
| `Description` | string | `"..."` | Notification message |
| `Time` | number | `1` | Display duration (seconds) |

---

## 📋 Complete Examples with Return Values

### Example 1: Simple Data Collection

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Data Collector",
    SubTitle = "v1.0"
})

local DataTab = Window:CreateTab({ Name = "Data" })

-- Store component references
local usernameInput = DataTab:createToggleText({
    Name = "Username",
    PlaceholderText = "Enter username"
})

local ageSlider = DataTab:createToggleSlider({
    Name = "Age",
    mode = "int",
    minValue = 13,
    maxValue = 100,
    default = 18
})

local countryDropdown = DataTab:createToggleDropdown({
    Name = "Country",
    mode = "Single"
})
countryDropdown:AddList({"USA", "UK", "Canada", "Australia"})

-- Status display
local statusLabel = DataTab:createToggleTextLabel({
    Name = "Status",
    Text = "Ready"
})

-- Submit button that retrieves all values
DataTab:createToggleButton({
    Name = "Submit",
    callback = function()
        statusLabel:SetText("Processing...")
        
        local username = usernameInput:GetText()
        local age = ageSlider:GetValue()
        local country = countryDropdown:Get()
        
        if username == "" or country == nil then
            statusLabel:SetText("❌ Error: Fill all fields")
            return
        end
        
        task.wait(0.5)
        statusLabel:SetText("✓ Submitted!")
        
        erclib:Notification({
            Title = "Success",
            Description = username .. " from " .. country,
            Time = 2
        })
    end
})
```

### Example 2: Control Panel with Multiple Tabs

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Control Panel",
    Size = UDim2.new(0, 600, 0, 500)
})

local SettingsTab = Window:CreateTab({ Name = "Settings" })
local StatusTab = Window:CreateTab({ Name = "Status" })

-- Settings components
local configNameInput = SettingsTab:createToggleText({
    Name = "Config Name",
    PlaceholderText = "e.g., MyConfig"
})

local featureToggle = SettingsTab:createToggle({
    Name = "Enable Feature",
    default = true
})

local qualitySlider = SettingsTab:createToggleSlider({
    Name = "Quality Level",
    mode = "int",
    minValue = 1,
    maxValue = 10,
    default = 5
})

-- Status display (on different tab)
local statusLabel = StatusTab:createToggleTextLabel({
    Name = "Current Config",
    Text = "No config loaded"
})

-- Apply button to save all settings
SettingsTab:createToggleButton({
    Name = "Save Config",
    callback = function()
        local configName = configNameInput:GetText()
        local isEnabled = featureToggle:GetState()
        local quality = qualitySlider:GetValue()
        
        if configName == "" then
            erclib:Notification({
                Title = "Error",
                Description = "Config name required",
                Time = 2
            })
            return
        end
        
        statusLabel:SetText(
            "Config: " .. configName .. "\n" ..
            "Enabled: " .. (isEnabled and "Yes" or "No") .. "\n" ..
            "Quality: " .. quality
        )
        
        erclib:Notification({
            Title = "Saved",
            Description = "Config '" .. configName .. "' saved",
            Time = 2
        })
    end
})
```

### Example 3: Real-Time Settings Monitor

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Settings Monitor"
})

local MainTab = Window:CreateTab({ Name = "Settings" })

-- Input components
local playerNameInput = MainTab:createToggleText({
    Name = "Player Name",
    PlaceholderText = "Your name"
})

local speedToggle = MainTab:createToggle({
    Name = "Speed Hack",
    default = false
})

local speedSlider = MainTab:createToggleSlider({
    Name = "Speed Value",
    mode = "decimal",
    minValue = 1,
    maxValue = 3,
    default = 1
})

local themeDropdown = MainTab:createToggleDropdown({
    Name = "Theme",
    mode = "Single"
})
themeDropdown:AddList({"Dark", "Light", "Custom"})

-- Display all current values
local allSettingsLabel = MainTab:createToggleTextLabel({
    Name = "All Settings",
    Text = "[Click Refresh to update]"
})

-- Refresh button to show all values
MainTab:createToggleButton({
    Name = "Refresh Settings",
    callback = function()
        local name = playerNameInput:GetText()
        local speedEnabled = speedToggle:GetState()
        local speedValue = speedSlider:GetValue()
        local theme = themeDropdown:Get()
        
        allSettingsLabel:SetText(
            "Name: " .. (name == "" and "[Not set]" or name) .. "\n" ..
            "Speed Hack: " .. (speedEnabled and "ON" or "OFF") .. "\n" ..
            "Speed Value: " .. string.format("%.2f", speedValue) .. "x\n" ..
            "Theme: " .. (theme or "[Not selected]")
        )
    end
})
```

---

## 🔧 Advanced Usage

### Chaining Component Operations

```lua
-- Create components and immediately use their APIs
local input = Tab:createToggleText({ Name = "Input" })
input:SetText("Default Value")

local slider = Tab:createToggleSlider({
    Name = "Value",
    minValue = 0,
    maxValue = 100,
    default = 50
})
slider:SetValue(75)

local label = Tab:createToggleTextLabel({
    Name = "Display",
    Text = "Ready"
})
label:SetText("Updated!")
```

### Dynamic Updates Based on User Input

```lua
local dropdown = Tab:createToggleDropdown({
    Name = "Select Option",
    mode = "Single"
})
dropdown:AddList({"Option A", "Option B", "Option C"})

-- Later, update the dropdown based on game state
task.wait(5)
dropdown:Clear()
dropdown:AddList({"New Option 1", "New Option 2"})
```

### Syncing Components Across Tabs

```lua
-- Tab 1: Input
local InputTab = Window:CreateTab({ Name = "Input" })
local textInput = InputTab:createToggleText({ Name = "Enter Text" })

-- Tab 2: Display (different tab)
local DisplayTab = Window:CreateTab({ Name = "Display" })
local textDisplay = DisplayTab:createToggleTextLabel({ Name = "Text Output", Text = "..." })

-- Sync button
InputTab:createToggleButton({
    Name = "Sync to Display",
    callback = function()
        local inputValue = textInput:GetText()
        textDisplay:SetText(inputValue)
    end
})
```

---

## ⚡ Performance Tips

### Batch Component Creation
```lua
-- ✅ Better: Store all component references
local components = {
    toggle = Tab:createToggle({ ... }),
    slider = Tab:createToggleSlider({ ... }),
    text = Tab:createToggleText({ ... }),
}

-- Access them anytime without re-creating
if components.toggle:GetState() then
    print(components.slider:GetValue())
end
```

### Efficient State Management
```lua
-- ❌ Inefficient: Creating new components repeatedly
for i = 1, 100 do
    Tab:createToggle({ ... })
end

-- ✅ Better: Create once, update as needed
local toggle = Tab:createToggle({ ... })
-- Reuse the same toggle, just update its state
for i = 1, 100 do
    toggle:SetState(i % 2 == 0)
    task.wait(0.1)
end
```

---

## 📄 License

GNU Affero General Public License v3.0 (AGPL-3.0)

**Full License:** [GNU Affero General Public License v3.0](https://www.gnu.org/licenses/agpl-3.0.html)

---

<div align="center">

**[⬆ Back to Top](#-erc-ui-library)**

Made with ❤️ by the ERC Community

</div>
