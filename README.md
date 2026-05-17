
# ERC UI Library

**ERC UI Library** เป็นไลบรารี UI สำหรับ Roblox ที่ออกแบบให้ใช้งานง่าย มีประสิทธิภาพสูง และสามารถสร้างหน้าต่าง (Window) เมนู (Tabs) แจ้งเตือน (Notification) และคอมโพเนนต์โมดูลาร์ (Modular Components) ได้อย่างรวดเร็วและมีประสิทธิภาพ

> แรงบันดาลใจจาก **WindUI** — ออกแบบมาให้เบา ใช้งานคล่องตัว และปรับใช้ได้ตามความต้องการของผู้ใช้งาน

---

## 📋 สารบัญ

1. [วัตถุประสงค์โครงการและวิธีการทำงาน](#part-1-วัตถุประสงค์โครงการและวิธีการทำงาน)
2. [เอกสาร API อย่างละเอียด](#part-2-เอกสาร-api-อย่างละเอียด)
3. [ข้อมูลใบอนุญาต](#part-3-ข้อมูลใบอนุญาต)

---

## Part 1: วัตถุประสงค์โครงการและวิธีการทำงาน

### 🎯 วัตถุประสงค์ของโครงการ

ERC UI Library สร้างขึ้นเพื่อ:

- **ลดความซับซ้อนในการสร้าง UI บน Roblox** — มีการสร้าง UI ที่ครบถ้วนด้วยคำสั่งเดียว โดยไม่ต้องจัดการโครงสร้าง Roblox GUI ที่ซับซ้อน
- **ให้ผู้พัฒนาสามารถโฟกัสกับการพัฒนาเกม** — แทนที่จะใช้เวลามากมายในการออกแบบและการเขียนโค้ด UI
- **มีระบบคอมโพเนนต์ที่สามารถนำกลับมาใช้ได้** — เช่น Toggle, Button, Slider, Dropdown, ColorPicker ที่สามารถสร้างหลายครั้งได้โดยไม่ต้องเขียนโค้ดซ้ำ
- **มีประสิทธิภาพทั้งในด้านประสิทธิภาพและการใช้หน่วยความจำ** — ไลบรารีนี้มีน้ำหนักเบา และเหมาะสำหรับสคริปต์ขนาดเล็กไปถึงขนาดใหญ่

### 🔧 วิธีการทำงานของ ERC UI Library

#### ขั้นตอนการทำงาน

1. **เริ่มต้นไลบรารี**
   - โหลดไลบรารี `global-erc-uilib-0.0.1.1.lua` ผ่าน `loadstring` หรือ `require`
   - ไลบรารีจะสร้าง `CoreGui` หลักและตั้งค่าการบริการที่จำเป็น (Services) ทั้งหมด

2. **สร้างหน้าต่าง (Window)**
   - เรียกใช้ฟังก์ชัน `erclib:window(config)` เพื่อสร้างหน้าต่างหลัก
   - หน้าต่างนี้มีระบบ Drag (ลากได้), Minimize (ย่อ), Fullscreen (ขยายเต็มจอ), และ Close (ปิด)

3. **สร้างแท็บ (Tabs)**
   - ใช้ `Window:CreateTab(config)` เพื่อเพิ่มแท็บภายในหน้าต่าง
   - แต่ละแท็บสามารถมีคอมโพเนนต์ที่แตกต่างกันได้

4. **เพิ่มคอมโพเนนต์**
   - ในแต่ละแท็บ สามารถเพิ่มคอมโพเนนต์ต่างๆ เช่น Toggle, Button, Slider เป็นต้น
   - แต่ละคอมโพเนนต์มี callback (ฟังก์ชันเรียกกลับ) เพื่อจัดการเหตุการณ์

5. **แสดง Notification**
   - ใช้ `erclib:Notification(config)` เพื่อแสดงข้อความแจ้งเตือนบน UI

#### สถาปัตยกรรม (Architecture)

```
ERC UI Library
│
├─ Main Frame (หน้าต่างหลัก)
│  ├─ Title Bar (แถบชื่อเรื่อง)
│  ├─ Tab Navigation (การนำทางแท็บ)
│  ├─ Content Area (พื้นที่เนื้อหา)
│  │  └─ Components (คอมโพเนนต์)
│  │     ├─ Toggles
│  │     ├─ Buttons
│  │     ├─ Textboxes
│  │     ├─ Sliders
│  │     ├─ Dropdowns
│  │     └─ ColorPickers
│  └─ Control Buttons (ปุ่มควบคุม: Close, Minimize, etc.)
│
└─ Notification Container (ตัวจัดการแจ้งเตือน)
   └─ Notifications (แจ้งเตือนแต่ละรายการ)
```

### 🎨 คุณสมบัติหลัก

- ✅ **สร้าง UI ได้ทันทีด้วยคำสั่งเดียว** — `erclib:window(config)`
- ✅ **รองรับ 6 ประเภทคอมโพเนนต์หลัก** — Toggle, Button, Text, Slider, Dropdown, ColorPicker
- ✅ **มีระบบ Notification** — แสดงข้อความแจ้งเตือนอัตโนมัติ
- ✅ **มีระบบ Drag / Minimize / Fullscreen / Close** — จัดการหน้าต่างได้สมบูรณ์
- ✅ **รองรับหลายแท็บ (Multi-Tab)** — สามารถแบ่งคอมโพเนนต์ออกเป็นแท็บได้
- ✅ **เบา ใช้หน่วยความจำน้อย** — เหมาะสำหรับ Roblox ที่มีข้อจำกัดด้านประสิทธิภาพ

---

## Part 2: เอกสาร API อย่างละเอียด

### การติดตั้งและการเริ่มต้นใช้งาน

#### 1. โหลดไลบรารี

```lua
-- วิธีที่ 1: ใช้ loadstring (สำหรับสกิปต์ออนไลน์)
local erclib = loadstring(game:HttpGet("https://raw.githubusercontent.com/John-loercol/rbx.Assets.erc/refs/heads/API.Services.get/ERC%20GUI%20-%20library%20UI%20-%20New.lua"))()

-- วิธีที่ 2: ใช้ loadstring จากไฟล์ท้องถิ่น (สำหรับ LocalScript)
local erclib = loadstring(readfile("source-main/global-erc-uilib-0.0.1.1.lua"))()

-- วิธีที่ 3: ใช้ require (สำหรับ ModuleScript)
local erclib = require(script.Parent:WaitForChild("global-erc-uilib-0.0.1.1"))
```

---

### API Reference

#### **1. erclib:window(config)**

สร้างหน้าต่าง (Window) หลักของ UI

**ลักษณะฟังก์ชัน:**
```lua
local Window = erclib:window(config)
```

**พารามิเตอร์ (Parameters):**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | ค่าเริ่มต้น | คำอธิบาย |
|---|---|---|---|
| `TitleText` | string | `"ERC UI — library"` | ชื่อหลักของหน้าต่าง (แสดงในแถบบน) |
| `SubTitle` | string | `"By erc.t.tm.th \| discord.gg/..."` | ชื่อรอง/คำอธิบายสั้น |
| `ImageIcon` | rbxassetid | `"rbxassetid://138560507380517"` | ID ของรูปภาพที่แสดงในมุมบน |
| `Size` | UDim2 | `UDim2.new(0,400,0,232)` | ขนาดของหน้าต่าง (กว้าง, สูง) |
| `IconText` | string | `"open gui"` | ข้อความในปุ่มเปิด GUI |
| `FontText` | Enum.Font | `Enum.Font.SourceSansBold` | ฟอนต์ที่ใช้ในทั้งหน้าต่าง |

**ตัวอย่างการใช้งาน:**

```lua
local Window = erclib:window({
    TitleText = "My Script UI",
    SubTitle = "Version 1.0",
    IconText = "Open",
    Size = UDim2.new(0, 520, 0, 420),
    FontText = Enum.Font.GothamBold,
    ImageIcon = "rbxassetid://138560507380517"
})
```

**ค่าที่ส่งคืน (Return Value):**
- `Window` object ที่มีเมธอด `CreateTab()` และคุณสมบัติอื่นๆ

---

#### **2. Window:CreateTab(config)**

สร้างแท็บใหม่ภายในหน้าต่าง

**ลักษณะฟังก์ชัน:**
```lua
local Tab = Window:CreateTab(config)
```

**พารามิเตอร์ (Parameters):**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | ค่าเริ่มต้น | คำอธิบาย |
|---|---|---|---|
| `Name` | string | `"Tab"` | ชื่อของแท็บ (แสดงใต้หน้าต่าง) |

**ตัวอย่างการใช้งาน:**

```lua
local MainTab = Window:CreateTab({
    Name = "Main"
})

local ConfigTab = Window:CreateTab({
    Name = "Config"
})

local DebugTab = Window:CreateTab({
    Name = "Debug"
})
```

---

#### **3. Tab Components (คอมโพเนนต์ในแท็บ)**

##### **3.1 Tab:createToggleSection(config)**

สร้างส่วนหัวเรื่องในแท็บ

```lua
Tab:createToggleSection({
    Name = "Section Title"
})
```

**พารามิเตอร์:**
- `Name` (string) — ชื่อของส่วนหัวเรื่อง

---

##### **3.2 Tab:createToggleDescription(config)**

สร้างข้อความคำอธิบาย

```lua
Tab:createToggleDescription({
    Description = "This is a description text"
})
```

**พารามิเตอร์:**
- `Description` (string) — ข้อความคำอธิบาย

---

##### **3.3 Tab:createToggle(config)**

สร้างปุ่มสลับ (Toggle Button)

```lua
local Toggle = Tab:createToggle({
    Name = "Auto Farm",
    Description = "Enable or disable autofarm",
    default = false,
    callback = function(state)
        print("Toggle state:", state)
    end
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อของ Toggle |
| `Description` | string | คำอธิบาย |
| `default` | boolean | สถานะเริ่มต้น (true/false) |
| `callback` | function | ฟังก์ชันที่เรียกเมื่อ Toggle เปลี่ยนสถานะ |

**เมธอดของ Toggle:**
- `Toggle:SetState(boolean)` — ตั้งค่าสถานะของ Toggle

---

##### **3.4 Tab:createToggleButton(config)**

สร้างปุ่มกด (Button)

```lua
Tab:createToggleButton({
    Name = "Send Notification",
    Description = "Click to send a test notification",
    callback = function()
        erclib:Notification({
            Title = "Hello!",
            Description = "Button pressed",
            Time = 3
        })
    end
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อปุ่ม |
| `Description` | string | คำอธิบาย |
| `callback` | function | ฟังก์ชันเมื่อปุ่มถูกกด |

---

##### **3.5 Tab:createToggleText(config)**

สร้างกล่องป้อนข้อความ (Textbox)

```lua
local TextInput = Tab:createToggleText({
    Name = "Player Name",
    Description = "Enter player name",
    PlaceHolderText = "Enter username...",
    callback = function(text)
        print("Input:", text)
    end
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อ Textbox |
| `Description` | string | คำอธิบาย |
| `PlaceHolderText` | string | ข้อความตัวอย่างในกล่อง |
| `callback` | function | ฟังก์ชันเมื่อข้อความเปลี่ยน |

---

##### **3.6 Tab:createToggleTextLabel(config)**

สร้างป้ายข้อความแบบอ่านอย่างเดียว (Text Label)

```lua
local Label = Tab:createToggleTextLabel({
    Name = "Status",
    Description = "Current status",
    Text = "Waiting..."
})

-- อัปเดตข้อความ
Label:SetText("Updated Text")
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อป้ายข้อความ |
| `Description` | string | คำอธิบาย |
| `Text` | string | ข้อความเริ่มต้น |

**เมธอด:**
- `Label:SetText(string)` — อัปเดตข้อความ

---

##### **3.7 Tab:createToggleSlider(config)**

สร้างตัวเลื่อน (Slider)

```lua
-- Slider แบบจำนวนเต็ม (Integer)
Tab:createToggleSlider({
    Name = "WalkSpeed",
    mode = "int",
    minValue = 16,
    maxValue = 200,
    default = 16,
    callback = function(value)
        print("WalkSpeed:", value)
    end
})

-- Slider แบบทศนิยม (Decimal)
Tab:createToggleSlider({
    Name = "Gravity",
    mode = "decimal",
    minValue = 0,
    maxValue = 500,
    default = workspace.Gravity,
    callback = function(value)
        workspace.Gravity = value
    end
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อ Slider |
| `Description` | string | คำอธิบาย |
| `mode` | string | `"int"` (จำนวนเต็ม) หรือ `"decimal"` (ทศนิยม) |
| `minValue` | number | ค่าต่ำสุด |
| `maxValue` | number | ค่าสูงสุด |
| `default` | number | ค่าเริ่มต้น |
| `callback` | function | ฟังก์ชันเมื่อค่า Slider เปลี่ยน |

---

##### **3.8 Tab:createToggleDropdown(config)**

สร้างรายการเลือก (Dropdown)

```lua
-- Single Selection (เลือกได้ครั้งละหนึ่งรายการ)
local TeamDropdown = Tab:createToggleDropdown({
    Name = "Team Select",
    Description = "Choose your team",
    DefaultText = "Choose team",
    mode = "Single",
    List = {"Red Team", "Blue Team", "Green Team"},
    callback = function(value)
        print("Selected:", value)
    end
})

-- Multi Selection (เลือกได้หลายรายการ)
Tab:createToggleDropdown({
    Name = "ESP Targets",
    Description = "Select targets to show",
    DefaultText = "Select targets",
    mode = "Multi",
    List = {"Players", "NPCs", "Items", "Bosses"},
    callback = function(values)
        for i, v in pairs(values) do
            print(i, v)
        end
    end
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อ Dropdown |
| `Description` | string | คำอธิบาย |
| `DefaultText` | string | ข้อความเริ่มต้น |
| `mode` | string | `"Single"` หรือ `"Multi"` |
| `List` | table | ตารางรายการเลือก |
| `callback` | function | ฟังก์ชันเมื่อเลือกรายการ |

---

##### **3.9 Tab:createToggleColorPicker(config)**

สร้างเครื่องมือเลือกสี (Color Picker)

```lua
Tab:createToggleColorPicker({
    Name = "ESP Color",
    Description = "Choose ESP highlight color",
    defaultColor = Color3.fromRGB(0, 170, 255),
    callback = function(color)
        print("Color:", color)
    end
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | คำอธิบาย |
|---|---|---|
| `Name` | string | ชื่อ Color Picker |
| `Description` | string | คำอธิบาย |
| `defaultColor` | Color3 | สีเริ่มต้น |
| `callback` | function | ฟังก์ชันเมื่อเลือกสี |

---

#### **4. erclib:Notification(config)**

แสดงข้อความแจ้งเตือน

```lua
erclib:Notification({
    Title = "Success",
    Description = "Operation completed successfully!",
    Time = 3
})
```

**พารามิเตอร์:**

| ชื่อพารามิเตอร์ | ชนิดข้อมูล | ค่าเริ่มต้น | คำอธิบาย |
|---|---|---|---|
| `Title` | string | `"Notification"` | ชื่อแจ้งเตือน |
| `Description` | string | `"..."` | ข้อความแจ้งเตือน |
| `Time` | number | `1` | ระยะเวลาแสดง (วินาที) |

---

### ตัวอย่างการใช้งานที่สมบูรณ์

```lua
local erclib = loadstring(game:HttpGet("https://raw.githubusercontent.com/John-loercol/rbx.Assets.erc/refs/heads/API.Services.get/ERC%20GUI%20-%20library%20UI%20-%20New.lua"))()

-- สร้างหน้าต่าง
local Window = erclib:window({
    TitleText = "My Script",
    SubTitle = "v1.0.0",
    IconText = "Open",
    Size = UDim2.new(0, 520, 0, 420)
})

-- สร้างแท็บ
local MainTab = Window:CreateTab({ Name = "Main" })
local SettingsTab = Window:CreateTab({ Name = "Settings" })

-- เพิ่มคอมโพเนนต์
local AutoClickToggle = MainTab:createToggle({
    Name = "Auto Click",
    Description = "Enable auto clicking",
    default = false,
    callback = function(state)
        print("AutoClick:", state)
    end
})

MainTab:createToggleButton({
    Name = "Click Now",
    Description = "Click immediately",
    callback = function()
        print("Button clicked!")
    end
})

SettingsTab:createToggleSlider({
    Name = "Click Speed",
    mode = "int",
    minValue = 1,
    maxValue = 100,
    default = 10,
    callback = function(value)
        print("Speed:", value)
    end
})

-- แสดงแจ้งเตือน
erclib:Notification({
    Title = "Ready",
    Description = "Script loaded successfully",
    Time = 3
})
```

---

## Part 3: ข้อมูลใบอนุญาต

### 📜 ใบอนุญาต: GNU Affero General Public License v3.0 (AGPL-3.0)

#### วัตถุประสงค์ของใบอนุญาต

ใบอนุญาต AGPL-3.0 ได้รับการออกแบบเพื่อให้:

1. **ความเป็นอิสระของซอฟต์แวร์** — ผู้ใช้สามารถเรียกดู แก้ไข และแจกจ่ายซอฟต์แวร์ได้อย่างอิสระ
2. **การปกป้องสิทธิผู้สร้างสรรค์** — ผู้พัฒนาต้องรักษาสัญญาอนุญาต AGPL-3.0 ไว้ในซอฟต์แวร์เวอร์ชันใดๆ
3. **แบ่งปันความรู้กับชุมชน** — หากมีการแก้ไข ต้องแจกจ่ายรหัสแหล่งที่มาแก้ไขไปยังชุมชน
4. **ป้องกันการนำไปใช้เชิงพาณิชย์แบบปิด** — ไม่สามารถใช้ซอฟต์แวร์นี้เพื่อสร้างซอฟต์แวร์ปิดโดยไม่เปิดเผยซอร์สโค้ด

#### ข้อกำหนดการใช้งาน

**ผู้ใช้มีสิทธิ:**
✅ ใช้ซอฟต์แวร์นี้ได้อย่างอิสระ
✅ ศึกษาโค้ด (Source Code) ได้
✅ แก้ไขและปรับเปลี่ยนโค้ดตามต้องการ
✅ แจกจ่ายซอฟต์แวร์และสำเนา (Copy) ได้
✅ ใช้ซอฟต์แวร์นี้ในโครงการส่วนตัว (Personal) หรือพาณิชย์ (Commercial)

**ผู้ใช้มีหน้าที่:**
❗ ต้องเก็บรักษาข้อความลิขสิทธิ์ (Copyright Notice) ไว้
❗ ต้องเก็บรักษาใบอนุญาต AGPL-3.0 ไว้เมื่อแจกจ่ายซอฟต์แวร์
❗ **หากคุณแก้ไขซอฟต์แวร์นี้ต้องเปิดเผยซอร์สโค้ดแก้ไข** (ถ้าแจกจ่ายให้ผู้อื่น)
❗ **หากใช้ผ่านเครือข่าย (Network) ต้องทำให้ซอร์สโค้ดหรือปรับเปลี่ยนสามารถเข้าถึงได้**
❗ ต้องระบุการเปลี่ยนแปลงที่คุณทำ (รักษาประวัติการแก้ไข)
❗ ห้ามลบหรือแก้ไขประกาศลิขสิทธิ์ต้นฉบับ

#### ข้อแนะนำการใช้งาน

1. **สำหรับใช้ส่วนตัว** — สามารถใช้ได้อย่างอิสระ แต่ต้องเก็บรักษาใบอนุญาตไว้
2. **สำหรับแจกจ่ายเวอร์ชันที่แก้ไขแล้ว** — ต้องแจกจ่ายซอร์สโค้ดแบบเปิด และเปิดเผยการเปลี่ยนแปลง
3. **สำหรับใช้ผ่านเซิร์ฟเวอร์** — ผู้ใช้ควรสามารถเข้าถึงซอร์สโค้ดของซอฟต์แวร์ที่ใช้งาน

#### ลิงก์ของใบอนุญาตเต็มรูปแบบ

👉 [GNU Affero General Public License v3.0 - Full Text](https://www.gnu.org/licenses/agpl-3.0.html)

#### เพิ่มเติม

สำหรับข้อมูลเพิ่มเติมเกี่ยวกับ AGPL-3.0 และการเลือกใบอนุญาต โปรดดู:
- [Choosing a License (ChooseALicense.com)](https://choosealicense.com/licenses/agpl-3.0/)
- [Free Software Foundation](https://www.fsf.org/)

---

## 📚 ทรัพยากรเพิ่มเติม

- **Roblox Documentation:** https://create.roblox.com/docs
- **WindUI Reference:** https://github.com/Footagesus/WindUI
- **Test Script Example:** [tests/test_ercui.lua](tests/test_ercui.lua)
- **Main Module:** [source-main/global-erc-uilib-0.0.1.1.lua](source-main/global-erc-uilib-0.0.1.1.lua)

---

## ⚠️ คำเตือน

- ตัวไลบรารีนี้ยังอยู่ในสถานะทดสอบ (Beta)
- อาจมีฟีเจอร์ที่ยังไม่สมบูรณ์หรือ Bug ได้
- กรุณาแจ้งปัญหาผ่าน GitHub Issues หากพบข้อผิดพลาด

---

## 🤝 การบริจาค

หากคุณสนใจที่จะมีส่วนร่วมในการพัฒนา ERC UI Library ยินดีต้อนรับ! โปรดดู [Contributing Guidelines](CONTRIBUTING.md) (หากมี) หรือสร้าง Pull Request

---

**ผู้พัฒนา:** erc.t.tm.th — John-loercol (GitHub)
