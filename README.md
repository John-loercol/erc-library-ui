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
   - [Notifications](#4-notifications)
7. [Complete Examples](#-complete-examples)
8. [Advanced Usage](#-advanced-usage)
9. [Performance Tips](#-performance-tips)
10. [License](#-license)
11. [Contributing](#-contributing)
12. [Support](#-support)

---

## ���� Overview

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
- ✅ **API Returns** — Get/Set values on components programmatically

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

-- Add a toggle
MainTab:createToggle({
    Name = "Enable Feature",
    Description = "Toggle this feature on/off",
    default = false,
    callback = function(state)
        print("Feature enabled:", state)
    end
})

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

### Data Flow

```
User Interaction
       ↓
InputEvent Detection
       ↓
Component Handler
       ↓
User Callback Function
       ↓
State Update
       ↓
Visual Update (Tween Animation)
       ↓
UI Refresh
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

**Example:**

```lua
local Window = erclib:window({
    TitleText = "Advanced Script",
    SubTitle = "Version 2.0.1",
    IconText = "Open",
    Size = UDim2.new(0, 600, 0, 500),
    FontText = Enum.Font.GothamBold,
    ImageIcon = "rbxassetid://138560507380517"
})
```

**Window Properties & Methods:**

| Method | Description |
|--------|-------------|
| `Window:CreateTab(config)` | Create a new tab in the window |

**Window Features:**
- Draggable title bar
- Minimize button → docks to corner
- Fullscreen button → expands to fill screen
- Close button → closes the entire UI
- Automatic viewport adjustment
- Window state persistence (position memory)

---

### 2. Tabs and Navigation

#### `Window:CreateTab(config)`

Creates a new tab in the window.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Tab"` | Tab name/label |

**Returns:** `Tab` object

**Example:**

```lua
local MainTab = Window:CreateTab({ Name = "Main" })
local SettingsTab = Window:CreateTab({ Name = "Settings" })
local DebugTab = Window:CreateTab({ Name = "Debug" })
```

**Tab Features:**
- Automatic sidebar navigation
- Smooth slide transitions between tabs
- Scroll-enabled content area
- Auto-layout with configurable padding

---

### 3. Components

All components are created using `Tab:createComponentType(config)` pattern.

#### 3.1 Section Header

##### `Tab:createToggleSection(config)`

Creates a section header to organize components.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Name` | string | Section title |

**Example:**

```lua
MainTab:createToggleSection({
    Name = "General Settings"
})

-- More components...

MainTab:createToggleSection({
    Name = "Advanced Settings"
})
```

---

#### 3.2 Description Text

##### `Tab:createToggleDescription(config)`

Creates a descriptive text block that auto-adjusts height.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Description` | string | Descriptive text (supports multiline) |

**Example:**

```lua
MainTab:createToggleDescription({
    Description = "This is a long description that explains what the following options do. It will automatically adjust height to fit the text."
})
```

---

#### 3.3 Toggle (Boolean Switch)

##### `Tab:createToggle(config)`

Creates a boolean toggle switch.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Toggle"` | Toggle label |
| `Description` | string | `""` | Toggle description |
| `State` | boolean | `false` | Initial state |
| `callback` | function | `nil` | Called when toggled: `function(state)` |

**Returns:** Toggle API object

**Example:**

```lua
local AutoFarmToggle = MainTab:createToggle({
    Name = "Auto Farm",
    Description = "Automatically farm resources",
    State = false,
    callback = function(state)
        if state then
            print("Auto farm enabled")
            -- Start farming loop
        else
            print("Auto farm disabled")
            -- Stop farming loop
        end
    end
})

-- Later: Update toggle programmatically
AutoFarmToggle:SetState(true)
local currentState = AutoFarmToggle:GetState()
```

**Toggle API:**

| Method | Description |
|--------|-------------|
| `:SetState(boolean)` | Set toggle state |
| `:GetState()` | Get current state |

---

#### 3.4 Button

##### `Tab:createToggleButton(config)`

Creates a clickable button.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Name` | string | Button label |
| `Description` | string | Button description |
| `Text` | string | Button text (alternative) |
| `callback` | function | Called on click: `function()` |

**Example:**

```lua
MainTab:createToggleButton({
    Name = "Send Request",
    Description = "Execute an HTTP request",
    Text = "Execute",
    callback = function()
        print("Request sent!")
        -- Your code here
    end
})

MainTab:createToggleButton({
    Name = "Teleport to Spawn",
    Description = "Return to spawn location",
    callback = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:MoveTo(Vector3.new(0, 50, 0))
        end
    end
})
```

**Button Animations:**
- Border flash on click
- Color transition feedback
- Visual state change

---

#### 3.5 Text Input Box

##### `Tab:createToggleText(config)`

Creates a text input field.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Name` | string | Input label |
| `Description` | string | Input description |
| `Text` | string | Initial text |
| `PlaceholderText` | string | Placeholder text |

**Returns:** TextBox API object

**Example:**

```lua
local PlayerNameInput = MainTab:createToggleText({
    Name = "Target Player",
    Description = "Enter player name to target",
    PlaceholderText = "Enter username...",
    Text = ""
})

-- Get current input
local targetName = PlayerNameInput:GetText()

-- Set new text
PlayerNameInput:SetText("NewValue")

-- Clear input
PlayerNameInput:ClearText()
```

**TextBox API:**

| Method | Description |
|--------|-------------|
| `:SetText(string)` | Set input text |
| `:GetText()` | Get current text |
| `:ClearText()` | Clear all text |

---

#### 3.6 Text Label (Read-Only)

##### `Tab:createToggleTextLabel(config)`

Creates a read-only text display.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `Name` | string | Label name |
| `Description` | string | Label description |
| `Text` | string | Initial text to display |

**Returns:** Label API object

**Example:**

```lua
local StatusLabel = MainTab:createToggleTextLabel({
    Name = "Current Status",
    Description = "Shows system status",
    Text = "Waiting for input..."
})

-- Update label
StatusLabel:SetText("Connected")

-- Later...
StatusLabel:SetText("Processing...")
StatusLabel:SetText("Complete!")
```

**Label API:**

| Method | Description |
|--------|-------------|
| `:SetText(string)` | Update display text |
| `:GetText()` | Get current text |
| `:ClearText()` | Clear text |

---

#### 3.7 Slider

##### `Tab:createToggleSlider(config)`

Creates a numeric slider with integer or decimal modes.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `""` | Slider label |
| `Description` | string | `""` | Slider description |
| `mode` | string | `"int"` | `"int"` (integer) or `"decimal"` (float) |
| `minValue` | number | `0` | Minimum value |
| `maxValue` | number | `100` | Maximum value |
| `default` | number | `0` | Initial value |
| `callback` | function | `nil` | Called on change: `function(value)` |

**Returns:** Slider API object

**Example:**

```lua
-- Integer slider (for counts, speeds, etc.)
local SpeedSlider = MainTab:createToggleSlider({
    Name = "Animation Speed",
    Description = "Control animation playback speed",
    mode = "int",
    minValue = 1,
    maxValue = 100,
    default = 50,
    callback = function(value)
        print("Speed:", value)
        -- Apply speed
    end
})

-- Decimal slider (for precise values)
local OpacitySlider = MainTab:createToggleSlider({
    Name = "Opacity",
    Description = "Adjust transparency (0-1)",
    mode = "decimal",
    minValue = 0,
    maxValue = 1,
    default = 0.5,
    callback = function(value)
        print("Opacity:", string.format("%.3f", value))
    end
})

-- Get slider value
local currentValue = SpeedSlider:GetValue()
```

**Slider API:**

| Method | Description |
|--------|-------------|
| `:SetValue(number)` | Set slider value |
| `:GetValue()` | Get current value |

**Slider Features:**
- Real-time value display
- Smooth lerping animation
- Keyboard/mouse support
- Visual feedback on interaction

---

#### 3.8 Dropdown (Single & Multi-Select)

##### `Tab:createToggleDropdown(config)`

Creates a dropdown selector with single or multi-select modes.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `""` | Dropdown label |
| `Description` | string | `""` | Dropdown description |
| `DefaultText` | string | `"Select..."` | Placeholder text |
| `mode` | string | `"Single"` | `"Single"` or `"Multi"` |

**Returns:** Dropdown API object

**Example - Single Select:**

```lua
local TeamDropdown = MainTab:createToggleDropdown({
    Name = "Choose Team",
    Description = "Select your team",
    DefaultText = "Pick a team...",
    mode = "Single"
})

-- Add options
TeamDropdown:Add("Red Team")
TeamDropdown:Add("Blue Team")
TeamDropdown:Add("Green Team")

-- Or add multiple at once (clears previous options)
TeamDropdown:AddList({"Red Team", "Blue Team", "Green Team", "Yellow Team"})

-- Get selected value
local selected = TeamDropdown:Get()
print("Selected team:", selected)

-- Set selection programmatically
TeamDropdown:Set("Blue Team")

-- Clear selection
TeamDropdown:ClearSelection()
```

**Example - Multi-Select:**

```lua
local FilterDropdown = MainTab:createToggleDropdown({
    Name = "Select Targets",
    Description = "Choose multiple targets to show",
    DefaultText = "Select targets...",
    mode = "Multi"
})

FilterDropdown:AddList({"Players", "NPCs", "Enemies", "Items", "Treasures"})

-- Get selected values (returns array)
local selected = FilterDropdown:Get()
for i, value in ipairs(selected) do
    print(i, value)
end

-- Set multiple selections
FilterDropdown:SetMultiple({"Players", "Enemies"})
```

**Dropdown API:**

| Method | Description |
|--------|-------------|
| `:Add(string)` | Add single option |
| `:AddList(table)` | Add multiple options (clears previous) |
| `:Clear()` | Remove all options |
| `:Set(value)` | Select option (single mode) or toggle (multi mode) |
| `:SetMultiple(table)` | Select multiple options (multi mode) |
| `:SetMode(mode)` | Switch between `"Single"` and `"Multi"` |
| `:ClearSelection()` | Deselect all (keeps options) |
| `:Get()` | Get selected value(s) |
| `:RefreshButtonStates()` | Refresh visual state |

**Dropdown Features:**
- Real-time search/filter
- Scrollable options list
- Single and multi-select modes
- Dynamic option management
- Smooth animations

---

#### 3.9 Color Picker

##### `Tab:createToggleColorPicker(config)`

Creates an HSV-based color picker with real-time preview.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `""` | Picker label |
| `Description` | string | `""` | Picker description |
| `defaultColor` | Color3 | `Color3.fromRGB(0,150,255)` | Initial color |

**Returns:** ColorPicker API object

**Example:**

```lua
local ColorPicker = MainTab:createToggleColorPicker({
    Name = "Highlight Color",
    Description = "Choose the highlight color for ESP",
    defaultColor = Color3.fromRGB(0, 170, 255)
})

-- Later: Get selected color
local r, g, b, alpha, color3 = ColorPicker:GetColor()
print("Color - R:", r, "G:", g, "B:", b, "Alpha:", alpha)

-- Set color programmatically
local newColor = Color3.fromRGB(255, 100, 50)
ColorPicker:SetColor(newColor, 0.5) -- color, alpha
```

**ColorPicker API:**

| Method | Description |
|--------|-------------|
| `:GetColor()` | Returns: `r, g, b, alpha, color3` |
| `:SetColor(Color3, alpha)` | Set picker to color |

**ColorPicker Features:**
- HSV color space picker
- Live RGB sliders
- Transparency (alpha) slider
- Gradient preview area
- Hue spectrum selector
- Done/Cancel buttons

---

### 4. Notifications

#### `erclib:Notification(config)`

Displays a toast-style notification that auto-dismisses.

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | string | `"ERC SYSTEM"` | Notification title |
| `Description` | string | `"..."` | Notification message |
| `Time` | number | `1` | Display duration (seconds) |

**Returns:** None

**Example:**

```lua
-- Simple notification
erclib:Notification({
    Title = "Success",
    Description = "Operation completed!",
    Time = 3
})

-- Error notification
erclib:Notification({
    Title = "Error",
    Description = "Failed to connect to server",
    Time = 5
})

-- Quick notification
erclib:Notification({
    Title = "Info",
    Description = "Short message",
    Time = 2
})
```

**Notification Features:**
- Auto-dismisses after delay
- Stacks vertically
- Manual close button
- Sound effect on appear
- Smooth slide-in animation
- Multiple notifications queue

---

## 📋 Complete Examples

### Example 1: Simple Toggle Script

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Simple Toggle",
    SubTitle = "v1.0"
})

local MainTab = Window:CreateTab({ Name = "Main" })

local enabled = false

MainTab:createToggle({
    Name = "Enable Feature",
    default = false,
    callback = function(state)
        enabled = state
        if enabled then
            erclib:Notification({
                Title = "Enabled",
                Description = "Feature is now active"
            })
        else
            erclib:Notification({
                Title = "Disabled",
                Description = "Feature is now inactive"
            })
        end
    end
})

MainTab:createToggleButton({
    Name = "Test Button",
    callback = function()
        print("Button pressed!")
        erclib:Notification({
            Title = "Button Clicked",
            Description = "You pressed the test button"
        })
    end
})
```

### Example 2: Settings Manager

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Settings Manager",
    Size = UDim2.new(0, 600, 0, 500)
})

local SettingsTab = Window:CreateTab({ Name = "Settings" })

-- General Section
SettingsTab:createToggleSection({ Name = "General Settings" })

local playerNameInput = SettingsTab:createToggleText({
    Name = "Player Name",
    Description = "Enter your player name",
    PlaceholderText = "Type here..."
})

local speedSlider = SettingsTab:createToggleSlider({
    Name = "Walk Speed",
    mode = "int",
    minValue = 16,
    maxValue = 200,
    default = 16,
    callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

-- Advanced Section
SettingsTab:createToggleSection({ Name = "Advanced Options" })

local themeDropdown = SettingsTab:createToggleDropdown({
    Name = "Theme",
    Description = "Select UI theme",
    DefaultText = "Choose theme...",
    mode = "Single"
})

themeDropdown:AddList({"Dark", "Light", "Custom"})

local colorPicker = SettingsTab:createToggleColorPicker({
    Name = "Accent Color",
    Description = "Choose accent color",
    defaultColor = Color3.fromRGB(0, 170, 255)
})

-- Action Buttons
SettingsTab:createToggleButton({
    Name = "Save Settings",
    Description = "Save all settings",
    callback = function()
        local settings = {
            playerName = playerNameInput:GetText(),
            theme = themeDropdown:Get(),
            color = colorPicker:GetColor()
        }
        print("Settings saved:", settings)
        erclib:Notification({
            Title = "Saved",
            Description = "Settings saved successfully!"
        })
    end
})

SettingsTab:createToggleButton({
    Name = "Reset to Defaults",
    callback = function()
        playerNameInput:SetText("Player")
        speedSlider:SetValue(16)
        themeDropdown:Set("Dark")
        erclib:Notification({
            Title = "Reset",
            Description = "Settings reset to defaults"
        })
    end
})
```

### Example 3: Multi-Tab Script

```lua
local erclib = loadstring(game:HttpGet("..."))()

local Window = erclib:window({
    TitleText = "Advanced Script",
    SubTitle = "Multi-feature system",
    Size = UDim2.new(0, 600, 0, 450)
})

-- ==== MAIN TAB ====
local MainTab = Window:CreateTab({ Name = "Main" })

MainTab:createToggleSection({ Name = "Core Features" })

local feature1 = MainTab:createToggle({
    Name = "Auto Farm",
    Description = "Automatically collect resources",
    default = false,
    callback = function(state)
        print("Auto Farm:", state)
    end
})

local feature2 = MainTab:createToggle({
    Name = "Auto Sell",
    Description = "Automatically sell collected items",
    default = false,
    callback = function(state)
        print("Auto Sell:", state)
    end
})

MainTab:createToggleSection({ Name = "Advanced" })

local speedSlider = MainTab:createToggleSlider({
    Name = "Farm Speed",
    mode = "decimal",
    minValue = 0.1,
    maxValue = 5.0,
    default = 1.0,
    callback = function(value)
        print("Speed multiplier:", value)
    end
})

-- ==== STATS TAB ====
local StatsTab = Window:CreateTab({ Name = "Stats" })

StatsTab:createToggleSection({ Name = "Account Statistics" })

StatsTab:createToggleTextLabel({
    Name = "Level",
    Description = "Your current level",
    Text = "Loading..."
})

StatsTab:createToggleTextLabel({
    Name = "Experience",
    Description = "Current EXP progress",
    Text = "0 / 1000"
})

StatsTab:createToggleTextLabel({
    Name = "Resources",
    Description = "Total resources collected",
    Text = "0"
})

-- Refresh stats button
StatsTab:createToggleButton({
    Name = "Refresh Stats",
    callback = function()
        print("Refreshing stats...")
        -- Update stat labels here
        erclib:Notification({
            Title = "Stats Updated",
            Description = "Your statistics have been refreshed"
        })
    end
})

-- ==== SETTINGS TAB ====
local SettingsTab = Window:CreateTab({ Name = "Settings" })

SettingsTab:createToggleSection({ Name = "Preferences" })

local notificationsToggle = SettingsTab:createToggle({
    Name = "Notifications",
    Description = "Enable/disable notifications",
    default = true
})

local soundToggle = SettingsTab:createToggle({
    Name = "Sound Effects",
    Description = "Enable/disable sound",
    default = true
})

SettingsTab:createToggleSection({ Name = "UI Options" })

local uiThemeDropdown = SettingsTab:createToggleDropdown({
    Name = "UI Theme",
    mode = "Single"
})

uiThemeDropdown:AddList({"Dark", "Light"})

SettingsTab:createToggleButton({
    Name = "About",
    callback = function()
        erclib:Notification({
            Title = "About",
            Description = "Advanced Script v1.0\nPowered by ERC UI"
        })
    end
})
```

---

## 🔧 Advanced Usage

### Working with Multiple Windows

Currently, `erclib` creates a single global window. For multiple UI windows, create separate instances:

```lua
local erclib = loadstring(game:HttpGet("..."))()

-- Each call creates an independent window instance
local mainWindow = erclib:window({ TitleText = "Main" })
local toolsWindow = erclib:window({ TitleText = "Tools" })

-- Position them differently
-- (Note: Both will be centered by default)
```

### Dynamic Component Management

```lua
local dropdown = MainTab:createToggleDropdown({
    Name = "Dynamic Options",
    mode = "Single"
})

-- Start with default options
dropdown:AddList({"Option A", "Option B"})

-- Later, update options
task.wait(2)
dropdown:Clear()
dropdown:AddList({"New A", "New B", "New C"})

-- Preserve selection if possible
local previousSelection = dropdown:Get()
dropdown:ClearSelection()
```

### Reactive UI Updates

```lua
local statusLabel = MainTab:createToggleTextLabel({
    Name = "Status",
    Text = "Initializing..."
})

local toggleFeature = MainTab:createToggle({
    Name = "Feature",
    callback = function(state)
        if state then
            statusLabel:SetText("Active")
            print("Feature activated")
        else
            statusLabel:SetText("Inactive")
            print("Feature deactivated")
        end
    end
})
```

### Color Picker Integration

```lua
local colorPicker = MainTab:createToggleColorPicker({
    Name = "Custom Color",
    defaultColor = Color3.fromRGB(255, 0, 0)
})

MainTab:createToggleButton({
    Name = "Apply Color",
    callback = function()
        local r, g, b, alpha, color3 = colorPicker:GetColor()
        print(string.format("Color: RGB(%d, %d, %d), Alpha: %.2f", r, g, b, alpha))
        
        -- Apply to game object
        local part = workspace:FindFirstChild("TargetPart")
        if part then
            part.Color = color3
            part.Transparency = alpha
        end
    end
})
```

### Slider Value Formatting

```lua
MainTab:createToggleSlider({
    Name = "Rotation",
    mode = "decimal",
    minValue = 0,
    maxValue = 360,
    default = 0,
    callback = function(value)
        -- Format as degrees
        local degrees = string.format("%.1f°", value)
        print("Rotation:", degrees)
    end
})
```

---

## ⚡ Performance Tips

### 1. Minimize Callbacks
```lua
-- ❌ Inefficient: Heavy computation on every change
slider:createToggleSlider({
    callback = function(value)
        for i = 1, 1000000 do
            -- Heavy computation
        end
    end
})

-- ✅ Better: Use debounce or throttle
local lastUpdate = 0
local debounceTime = 0.1

slider:createToggleSlider({
    callback = function(value)
        local now = tick()
        if now - lastUpdate >= debounceTime then
            -- Do update
            lastUpdate = now
        end
    end
})
```

### 2. Lazy Load Content
```lua
local contentLoaded = false

local settingsTab = Window:CreateTab({ Name = "Settings" })

settingsTab:createToggleButton({
    Name = "Advanced Settings",
    callback = function()
        if not contentLoaded then
            -- Load settings only when needed
            settingsTab:createToggleSlider({ ... })
            settingsTab:createToggleDropdown({ ... })
            contentLoaded = true
        end
    end
})
```

### 3. Clean Up Unused References
```lua
-- ✅ Good practice: Null out references when done
local tempVariable = someComponent
-- ... use tempVariable ...
tempVariable = nil -- Allow garbage collection
```

### 4. Batch Notifications
```lua
-- ❌ Inefficient: Multiple notifications spam
for i, item in ipairs(items) do
    erclib:Notification({
        Title = item,
        Description = "Processed"
    })
end

-- ✅ Better: Single notification with summary
local processedCount = 0
for i, item in ipairs(items) do
    -- ... process ...
    processedCount = processedCount + 1
end

erclib:Notification({
    Title = "Processing Complete",
    Description = processedCount .. " items processed"
})
```

---

## 🎨 Customization

### Colors

The library uses a dark theme by default. Colors can be found in the source code:
- Background: `Color3.fromRGB(30, 30, 30)`
- Accent: `Color3.fromRGB(0, 150, 255)`
- Border: `Color3.fromRGB(45, 45, 45)`
- Text: `Color3.fromRGB(255, 255, 255)`

To customize, modify the source code or create CSS-like overrides.

### Fonts

Supported fonts from Roblox:
- `Enum.Font.GothamBold`
- `Enum.Font.SourceSansBold`
- `Enum.Font.Nunito`
- And others...

Set via the `FontText` parameter when creating the window.

---

## 🐛 Troubleshooting

### Issue: Window doesn't appear

**Solution:**
```lua
-- Make sure script runs in LocalScript or executor with access to CoreGui
local CoreGui = game:GetService("CoreGui")
local ScreenGui = CoreGui:FindFirstChild("ScreenGui")
print("CoreGui accessible:", ScreenGui ~= nil)
```

### Issue: Components not responding to clicks

**Solution:**
```lua
-- Ensure the window is visible and not minimized
-- Check that callbacks are properly defined
-- Verify no overlapping UI elements are blocking interaction
```

### Issue: Performance drops with many components

**Solution:**
```lua
-- Reduce number of active components
-- Use tabs to organize features
-- Enable/disable components based on need
-- Monitor with: print("Current FPS:", 1 / game:GetService("RunService").Heartbeat:Wait())
```

---

## 📄 License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

### Key Points:
- ✅ **Free to use** — Personal or commercial
- ✅ **Free to modify** — Create your own version
- ✅ **Free to distribute** — Share with others
- ❗ **Must share modifications** — If you modify and distribute, source must be available
- ❗ **Must preserve license** — Keep AGPL-3.0 notice
- ❗ **Network clause** — If used over network, source must be accessible to users

**Full License:** [GNU Affero General Public License v3.0](https://www.gnu.org/licenses/agpl-3.0.html)

---

## 🤝 Contributing

### Ways to Contribute:
1. **Report Bugs** — Found an issue? [Create an issue](https://github.com/John-loercol/erc-library-ui/issues)
2. **Suggest Features** — Have an idea? Discuss it in issues
3. **Submit PRs** — Code improvements welcome
4. **Documentation** — Help improve docs

### Development Setup:
```bash
git clone https://github.com/John-loercol/erc-library-ui.git
cd erc-library-ui
# Edit source-main/global-erc-uilib-0.0.1.1.lua
# Test in Roblox Studio
```

---

## 📞 Support

### Getting Help:
- 📖 **Documentation:** Check this README
- 🔍 **Search Issues:** Look for similar problems
- 💬 **Discord:** Join our Discord community
- 🐛 **Report Bugs:** [GitHub Issues](https://github.com/John-loercol/erc-library-ui/issues)

### Resources:
- Roblox API Documentation: https://create.roblox.com/docs
- Lua Documentation: https://www.lua.org/manual/
- Inspired by WindUI: https://github.com/Footagesus/WindUI

---

## 📊 Project Status

| Component | Status | Notes |
|-----------|--------|-------|
| Window Management | ✅ Stable | Draggable, minimizable, fullscreen |
| Tab System | ✅ Stable | Multi-tab navigation working |
| Toggle | ✅ Stable | Boolean switching fully functional |
| Button | ✅ Stable | Click callbacks working |
| TextBox | ✅ Stable | Input/output functional |
| Label | ✅ Stable | Read-only text display |
| Slider | ✅ Stable | Integer and decimal modes |
| Dropdown | ✅ Stable | Single and multi-select working |
| ColorPicker | ✅ Stable | HSV picker fully functional |
| Notifications | ✅ Stable | Toast notifications working |

**Version:** 0.0.1.1 (Beta)

---

## 📝 Changelog

### v0.0.1.1 (Current)
- Initial release
- 9 UI components
- Notification system
- Tab-based organization
- Window management (drag, minimize, fullscreen)
- HSV color picker
- Multi-select dropdown

### Roadmap
- [ ] Dark/Light theme toggle
- [ ] Custom theme editor
- [ ] Keybind system
- [ ] Auto-layout improvements
- [ ] Mobile UI support
- [ ] Preset configurations
- [ ] UI builder tool

---

## 👨‍💻 Author

**erc.t.tm.th** (GitHub: [@John-loercol](https://github.com/John-loercol))

- 🎮 Roblox enthusiast
- 💻 Full-stack developer
- 📚 Open source contributor

### Social:
- GitHub: [@John-loercol](https://github.com/John-loercol)

---

## ⭐ Show Your Support

If this library helped you, consider:
- ⭐ Starring the repository
- 🔗 Sharing with friends
- 💬 Providing feedback
- 🐛 Reporting issues
- 🚀 Contributing code

---

## 📜 Legal

This project is provided as-is without warranty. Use at your own risk. Ensure compliance with Roblox Terms of Service when using this library.

**© 2024 ERC Library - All Rights Reserved**

---

<div align="center">

**[⬆ Back to Top](#-erc-ui-library)**

Made with ❤️ by the ERC Community

</div>
