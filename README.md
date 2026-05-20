# ERC UI Library

**ERC UI Library** is a powerful, lightweight, and easy-to-use UI library for Roblox scripting.

> Inspired by **WindUI** — designed to be fast, responsive, and production-ready

![Version](https://img.shields.io/badge/version-0.0.1.1-blue)
![License](https://img.shields.io/badge/license-AGPL--3.0-green)
![Language](https://img.shields.io/badge/language-Lua-purple)
![Status](https://img.shields.io/badge/status-Beta-orange)

---

## » Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Installation](#installation)
4. [Quick Start](#quick-start)
5. [Architecture](#architecture)
6. [API Reference](#api-reference)
7. [Component API Methods](#component-api-methods---return-values)
8. [Complete Examples](#complete-examples-with-return-values)
9. [Advanced Usage](#advanced-usage)
10. [Performance Tips](#performance-tips)
11. [License](#license)

---

## ▸ Overview

**ERC UI Library** is a comprehensive Roblox UI framework designed to simplify the creation of professional-looking user interfaces. It provides ready-to-use components, automatic layout management, and smooth animations without requiring complex setup.

### ► Why ERC UI?

- **Zero Boilerplate** — Create a complete UI with just a few lines of code
- **Developer Friendly** — Intuitive API that follows common UI patterns
- **High Performance** — Optimized for Roblox's rendering pipeline
- **Production Ready** — Used in real-world scripts and games
- **Fully Customizable** — Every component can be styled and configured
- **Rich Component Set** — 8+ components to cover most UI needs

---

## ▸ Features

### ► Core Features
- [✓] **Multi-tab Interface System** — Organize features across multiple tabs
- [✓] **8 UI Components** — Toggle, Button, TextBox, Label, Slider, Dropdown, ColorPicker, Section
- [✓] **Notification System** — Toast-style notifications with auto-dismiss
- [✓] **Window Management** — Draggable, minimizable, fullscreen, closable
- [✓] **Smooth Animations** — Tweening animations for all interactions
- [✓] **Responsive Design** — Automatically adjusts to viewport changes

### ► Advanced Features
- [✓] **Single & Multi-select Dropdowns** — Flexible selection modes
- [✓] **HSV Color Picker** — Professional color selection with real-time preview
- [✓] **Integer & Decimal Sliders** — Support for both data types
- [✓] **Search-enabled Dropdowns** — Filter options in real-time
- [✓] **Custom Callbacks** — React to user interactions instantly
- [✓] **Component API Returns** — Get/Set values on components programmatically

### ► Performance
- [✓] **Lightweight** — Minimal memory footprint
- [✓] **Efficient Rendering** — Smart reuse of UI elements
- [✓] **Connection Cleanup** — Automatic disconnection of event listeners
- [✓] **Optimized Tweening** — Cancellation of unused animations

---

## ▸ Installation

### ► Method 1: Direct Load (Online)
```lua
local erclib = loadstring(game:HttpGet("https://raw.githubusercontent.com/John-loercol/erc-library-ui/main/source-main/global-erc-uilib-0.0.1.1.lua"))()
```

### ► Method 2: Local File Load
```lua
local erclib = loadstring(readfile("source-main/global-erc-uilib-0.0.1.1.lua"))()
```

### ► Method 3: Module Script
```lua
local erclib = require(script.Parent:WaitForChild("global-erc-uilib-0.0.1.1"))
```

### ► Requirements
- Roblox game running
- Script execution enabled (LocalScript or via exploit)
- Access to CoreGui service

---

## ▸ Quick Start

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

## ▸ Architecture

### ► Component Hierarchy

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

## ▸ API Reference

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

## ▸ Component API Methods - Return Values

Each component returns an API object that allows you to interact with it programmatically.

### ■ Toggle API

**Methods:**
```lua
:SetState(bool)     -- Enable/disable toggle
:GetState()         -- Get current state (returns boolean)
```

**Full Example:**
```lua
local autoFarmToggle = MainTab:createToggle({
    Name = "Auto Farm",
    default = false,
    callback = function(state)
        print("Auto farming:", state and "enabled" or "disabled")
    end
})

-- Programmatically enable
autoFarmToggle:SetState(true)

-- Check current state
if autoFarmToggle:GetState() then
    print("Auto farm is active")
end
```

---

### ■ TextBox API

**Methods:**
```lua
:SetText(string)    -- Set input value
:GetText()          -- Get current text (returns string)
:ClearText()        -- Clear all text
```

**Full Example:**
```lua
local playerInput = MainTab:createToggleText({
    Name = "Player Name",
    PlaceholderText = "Enter name"
})

playerInput:SetText("John123")

MainTab:createToggleButton({
    Name = "Submit",
    callback = function()
        local name = playerInput:GetText()
        print("Player:", name)
        playerInput:ClearText()
    end
})
```

---

### ■ Text Label API

**Methods:**
```lua
:SetText(string)    -- Update display text
:GetText()          -- Get current text (returns string)
:ClearText()        -- Clear text
```

**Full Example:**
```lua
local statusLabel = MainTab:createToggleTextLabel({
    Name = "Status",
    Text = "Initializing..."
})

statusLabel:SetText("Ready")
print("Current status:", statusLabel:GetText())
```

---

### ■ Slider API

**Methods:**
```lua
:SetValue(number)   -- Set slider position
:GetValue()         -- Get current value (returns number)
```

**Full Example:**
```lua
local speedSlider = MainTab:createToggleSlider({
    Name = "Speed",
    mode = "int",
    minValue = 1,
    maxValue = 100,
    default = 50
})

speedSlider:SetValue(75)
local currentSpeed = speedSlider:GetValue()
print("Speed:", currentSpeed)
```

---

### ■ Dropdown API

**Methods:**
```lua
:Add(string)                -- Add single option
:AddList(table)             -- Add multiple options
:Get()                      -- Get selection(s)
:Set(value)                 -- Set selection (single mode)
:SetMultiple(table)         -- Set multiple selections (multi mode)
:Clear()                    -- Remove all options
:ClearSelection()           -- Deselect all items
:RefreshButtonStates()      -- Refresh visual state
```

**Single-Select Example:**
```lua
local gameDropdown = MainTab:createToggleDropdown({
    Name = "Gamemode",
    mode = "Single",
    DefaultText = "Pick mode..."
})

gameDropdown:AddList({"Survival", "Creative", "Adventure"})

MainTab:createToggleButton({
    Name = "Load",
    callback = function()
        local selected = gameDropdown:Get()
        print("Loading:", selected)
    end
})
```

**Multi-Select Example:**
```lua
local filterDropdown = MainTab:createToggleDropdown({
    Name = "Filters",
    mode = "Multi",
    DefaultText = "Select filters..."
})

filterDropdown:AddList({"Players", "NPCs", "Items", "Enemies"})

MainTab:createToggleButton({
    Name = "Apply",
    callback = function()
        local selected = filterDropdown:Get()
        for _, filter in ipairs(selected) do
            print("Active filter:", filter)
        end
    end
})
```

---

### ■ Color Picker API

**Methods:**
```lua
:GetColor()                 -- Get color (returns r, g, b, alpha, Color3)
:SetColor(Color3, alpha)    -- Set color and transparency
```

**Full Example:**
```lua
local colorPicker = MainTab:createToggleColorPicker({
    Name = "ESP Color",
    defaultColor = Color3.fromRGB(0, 255, 0)
})

MainTab:createToggleButton({
    Name = "Apply",
    callback = function()
        local r, g, b, alpha, color3 = colorPicker:GetColor()
        print(string.format("Color: RGB(%d,%d,%d) Alpha:%.2f", r, g, b, alpha))
    end
})

MainTab:createToggleButton({
    Name = "Reset",
    callback = function()
        colorPicker:SetColor(Color3.fromRGB(255, 0, 0), 1)
    end
})
```

---

## ▸ Complete Examples with Return Values

### ► Example 1: Form with Validation

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Registration",
    SubTitle = "User Data Form"
})

local FormTab = Window:CreateTab({ Name = "Register" })

-- Store references
local nameInput = FormTab:createToggleText({
    Name = "Full Name",
    PlaceholderText = "John Doe"
})

local emailInput = FormTab:createToggleText({
    Name = "Email",
    PlaceholderText = "user@example.com"
})

local ageSlider = FormTab:createToggleSlider({
    Name = "Age",
    mode = "int",
    minValue = 18,
    maxValue = 100,
    default = 25
})

local statusLabel = FormTab:createToggleTextLabel({
    Name = "Status",
    Text = "Ready to register"
})

-- Submit handler
FormTab:createToggleButton({
    Name = "Register",
    callback = function()
        local name = nameInput:GetText()
        local email = emailInput:GetText()
        local age = ageSlider:GetValue()
        
        if name == "" or email == "" then
            statusLabel:SetText("[ERROR] Please fill all fields")
            return
        end
        
        statusLabel:SetText("[SUCCESS] Account created!")
        
        erclib:Notification({
            Title = "Welcome",
            Description = "Registered: " .. name,
            Time = 3
        })
    end
})
```

### ► Example 2: Multi-Tab Dashboard

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Dashboard",
    Size = UDim2.new(0, 600, 0, 500)
})

local ConfigTab = Window:CreateTab({ Name = "Settings" })
local StatsTab = Window:CreateTab({ Name = "Stats" })

-- Settings components
local configInput = ConfigTab:createToggleText({
    Name = "Config Name",
    PlaceholderText = "MyConfig"
})

local autoStartToggle = ConfigTab:createToggle({
    Name = "Auto Start",
    default = false
})

local qualitySlider = ConfigTab:createToggleSlider({
    Name = "Quality",
    mode = "int",
    minValue = 1,
    maxValue = 10,
    default = 5
})

-- Stats display (different tab)
local statsLabel = StatsTab:createToggleTextLabel({
    Name = "Current Settings",
    Text = "No config loaded"
})

-- Save button (updates stats in other tab)
ConfigTab:createToggleButton({
    Name = "Save",
    callback = function()
        local name = configInput:GetText()
        local autoStart = autoStartToggle:GetState()
        local quality = qualitySlider:GetValue()
        
        if name == "" then
            erclib:Notification({
                Title = "Error",
                Description = "Config name required",
                Time = 2
            })
            return
        end
        
        -- Update stats tab
        statsLabel:SetText(
            "Config: " .. name .. "\n" ..
            "Auto Start: " .. (autoStart and "YES" or "NO") .. "\n" ..
            "Quality: " .. quality .. "/10"
        )
        
        erclib:Notification({
            Title = "Saved",
            Description = "Config '" .. name .. "' saved",
            Time = 2
        })
    end
})
```

---

## ▸ Advanced Usage

### ► Chaining Operations

```lua
local myToggle = Tab:createToggle({ Name = "Feature" })
myToggle:SetState(true)

local mySlider = Tab:createToggleSlider({ Name = "Value", minValue = 0, maxValue = 100 })
mySlider:SetValue(50)

if myToggle:GetState() then
    print("Value is:", mySlider:GetValue())
end
```

### ► Dynamic Dropdown Updates

```lua
local dropdown = Tab:createToggleDropdown({
    Name = "Server List",
    mode = "Single"
})

dropdown:AddList({"Loading..."})

-- Update after fetch
task.wait(2)
dropdown:Clear()
dropdown:AddList({"Server 1", "Server 2", "Server 3"})
```

### ► Cross-Tab Synchronization

```lua
local InputTab = Window:CreateTab({ Name = "Input" })
local OutputTab = Window:CreateTab({ Name = "Output" })

local input = InputTab:createToggleText({ Name = "Enter text" })
local output = OutputTab:createToggleTextLabel({ Name = "Output", Text = "..." })

InputTab:createToggleButton({
    Name = "Sync",
    callback = function()
        output:SetText(input:GetText())
    end
})
```

---

## ▸ Performance Tips

### ► Store Component References

```lua
-- [✓] GOOD: Store and reuse
local components = {
    toggle = Tab:createToggle({ ... }),
    slider = Tab:createToggleSlider({ ... }),
    input = Tab:createToggleText({ ... })
}

-- Use multiple times
components.toggle:SetState(true)
local val = components.slider:GetValue()
```

### ► Avoid Recreating Components

```lua
-- [✗] BAD: Creates 100 toggles
for i = 1, 100 do
    Tab:createToggle({ Name = "Toggle " .. i })
end

-- [✓] GOOD: Create once, reuse
local toggle = Tab:createToggle({ Name = "Toggle" })
for i = 1, 100 do
    toggle:SetState(i % 2 == 0)
    task.wait(0.1)
end
```

---

## ▸ License

GNU Affero General Public License v3.0 (AGPL-3.0)

**Full License:** [Read here](https://www.gnu.org/licenses/agpl-3.0.html)

---

<div align="center">

[↑ Back to Top](#erc-ui-library)

Made with ♡ by the ERC Community

</div>
