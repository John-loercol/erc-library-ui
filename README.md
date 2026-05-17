
# ERC UI Library

ERC UI Library เป็นไลบรารี UI สำหรับ Roblox ที่ออกแบบให้ใช้งานง่าย และสามารถสร้างหน้าต่าง เมนู แจ้งเตือน และคอนโทรลแบบโมดูลาร์ได้ทันที

> แรงบันดาลใจจาก WindUI ขนาดเล็ก ใช้งานคล่องตัว และปรับใช้ได้ตามความต้องการ

## จุดเด่น

- สร้าง UI ได้ทันทีด้วยคำสั่งเดียว `erclib:window(config)`
- รองรับ `Toggle`, `Text`, `Button`, `Slider`, `Dropdown`, `ColorPicker` และระบบ Notification
- มีระบบ Drag / Minimize / Fullscreen / Close แบบ built-in
- เหมาะสำหรับผู้ที่ต้องการ UI เบา ๆ แต่ครบเครื่องใน Roblox

## ตัวอย่างการใช้งาน

```lua
local erclib = loadstring(readfile("source-main/global-erc-uilib-0.0.1.1.lua"))()

erclib:window({
    TitleText = "ERC UI - Demo",
    SubTitle = "Built for fast Roblox UI",
    IconText = "Open GUI",
})
```

## การติดตั้ง

1. ดาวน์โหลดไฟล์ `source-main/global-erc-uilib-0.0.1.1.lua`
2. วางในสคริปต์ Roblox ที่สามารถเรียกใช้ `loadstring` / `require`
3. เรียกใช้งานฟังก์ชัน `erclib:window(config)` เพื่อสร้าง UI

## ไฟล์ทดสอบ

ไฟล์ตัวอย่างการใช้งานทั้งหมด: [tests/test_ercui.lua](tests/test_ercui.lua)

สคริปต์ทดสอบรวมถึง:
- สร้างหน้าต่าง UI พร้อม 3 แท็บ (Main, Config, Debug)
- ทดสอบทุกคอมโพเนนต์ (Toggle, Button, Textbox, Slider, Dropdown, ColorPicker)
- แจ้งเตือน Notification และการจัดการสถานะ UI
- ฟังก์ชันดีบัก เช่น ตรวจสอบ Executor, JobId, Rejoin

## ลิงก์สำคัญ

- WindUI README: https://github.com/Footagesus/WindUI#
- โมดูลหลัก: `source-main/global-erc-uilib-0.0.1.1.lua`

## คำเตือน

ตัวไลบรารีนี้ยังอยู่ในสถานะทดสอบ เบื้องต้นอาจมีฟีเจอร์ที่ยังไม่สมบูรณ์หรือมีบั๊กได้

## ขยายงานต่อได้

- เพิ่มหน้าจอใหม่ในระบบ `Tabs`
- ปรับแต่งธีมสี และขนาดของ UI
- เชื่อมต่อกับสคริปต์เกมและตัวเลือกจากผู้เล่น
