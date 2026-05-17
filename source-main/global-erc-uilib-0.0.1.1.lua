--[[
    • ERC UI - library UI
    • library ID Version | global-erc-uilib-0.0.1.1
    • Developed by erc.t.tm.th — John-loercol (GitHub)
]]

--// Check status
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

--// library api
local erclib = {} -- data

--// Services
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

--// Utility Functions
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius or 2)
    corner.Parent = parent
    return corner
end

local function createUIStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1.5
    stroke.Color = color or Color3.fromRGB(50,50,50)
    stroke.Transparency = math.clamp(transparency or 0,0,1)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.ZIndex = parent.ZIndex + 10
    stroke.Parent = parent
    return stroke
end

local function CenterFramePosition(Frame, XP, YP)
	local viewportSize = Camera and Camera.ViewportSize or Vector2.new(1280, 720)

	Frame.Position = UDim2.new(
		0, (viewportSize.X - Frame.AbsoluteSize.X) / (XP or 2),
		0, (viewportSize.Y - Frame.AbsoluteSize.Y) / (YP or 2)
	)
end

local function createListLayout(parent, paddingBetween, paddingTopBottom, paddingLeft, paddingRight)
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, paddingBetween or 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = parent

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, paddingTopBottom or 10)
    pad.PaddingBottom = UDim.new(0, paddingTopBottom or 10)
    pad.PaddingLeft = UDim.new(0, paddingLeft or 0)
    pad.PaddingRight = UDim.new(0, paddingRight or 0)
    pad.Parent = parent

    if parent:IsA("ScrollingFrame") then
        parent.AutomaticCanvasSize = Enum.AutomaticSize.None
        parent.CanvasSize = UDim2.new(0,0,0,0)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            parent.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + pad.PaddingTop.Offset + pad.PaddingBottom.Offset)
        end)
    end
    return layout, pad
end

local function createTextSizeConstraint(parent, minSize, maxSize)
    if not parent then return end
    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MinTextSize = minSize or 12
    constraint.MaxTextSize = maxSize or 18
    constraint.Parent = parent
    return constraint
end

local function CopyText(text)
    if setclipboard then setclipboard(text)
    elseif syn and syn.write_clipboard then syn.write_clipboard(text)
    elseif Clipboard and Clipboard.set then Clipboard.set(text) end
end

local function DevConsole()
    local ok = pcall(function()
        local sg = game:GetService("StarterGui")
        local state = sg:GetCore("DevConsoleVisible")
        sg:SetCore("DevConsoleVisible", not state)
    end)
    if ok then return end
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F9, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F9, false, game)
    end)
end

-- //Boot Sys...
pcall(function()
     pcall(function()
          DevConsole()
end)

task.wait(1.5)
     pcall(function()
          warn("[ >_ ] Powered by erclibrary™")
task.wait(1.5)

pcall(function()
     DevConsole()
   end)
end)
task.wait(1.5)

--// GetScreenGui
local function getDevConsole()
return CoreGui:FindFirstChild("DevConsoleMaster", true)
end

-- RobloxGUI
local function RobloxGUI(gui)
	if typeof(gui) ~= "Instance" or (not gui:IsA("GuiObject") and not gui:IsA("ScreenGui")) then
		return nil
	end

	if gui:IsA("ScreenGui") then
		gui.ResetOnSpawn = false
	end

	local destroyed = false
	gui.Destroying:Once(function()
		destroyed = true
	end)

	local targetParent = nil

	-- PRIORITY 1 — DevConsole (skip cleanly if nil)
	local dev = getDevConsole()
	if dev and dev.Parent then
		targetParent = dev
	end

	-- PRIORITY 2 — gethui
	if not targetParent and typeof(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and typeof(hui) == "Instance" and hui.Parent ~= nil then
			targetParent = hui
		end
	end

	-- PRIORITY 3 — syn protect
	if not targetParent and syn and typeof(syn.protect_gui) == "function" then
		pcall(function()
			syn.protect_gui(gui)
		end)
		targetParent = CoreGui
	end

	-- FINAL fallback
	targetParent = targetParent or CoreGui

	pcall(function()
		gui.Parent = targetParent
	end)

	-- lightweight guard
	task.spawn(function()
		while not destroyed do
			task.wait(0.5)
			if gui.Parent ~= targetParent then
				pcall(function()
					gui.Parent = targetParent
				end)
			end
		end
	end)

	return gui
end

local ERCFrame = Instance.new("Frame")
ERCFrame.Name = "erclib-main"
ERCFrame.Size = UDim2.new(1,0,1,0)
ERCFrame.BackgroundTransparency = 1
ERCFrame.ZIndex = 2147483647
ERCFrame.Parent = ERCGui
RobloxGUI(ERCFrame)

--// Connection Cleanup
local connections = {}

local function addConnection(connection)
    table.insert(connections, connection)
end

local function disconnectAll()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
      connections = {}
end

-- <erc frame>
--// Main GUI
function erclib:window(config)
    -- (setting default)
    local MAIN_TITLE = config.TitleText or "ERC UI — library"
    local DESC_TITLE = config.SubTitle or "By erc.t.tm.th | discord.gg/kShJy84u2v"
    local MAIN_IMAGE = config.ImageIcon or "rbxassetid://138560507380517"
    local SIZE_MAIN = config.Size or UDim2.new(0,400,0,232)
    local ICON_TEXT = config.IconText or "open gui"
    local FontGUI = config.FontText or Enum.Font.SourceSansBold
    
    --// Freme
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = SIZE_MAIN
    MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    MainFrame.Parent = ERCFrame
    MainFrame.Active = true
    MainFrame.ZIndex = 5000
    createUICorner(MainFrame)
    createUIStroke(MainFrame)
    CenterFramePosition(MainFrame, 2, 100)

    local MainIcon = Instance.new("Frame")
    MainIcon.Name = "MainIcon"
    MainIcon.Size = UDim2.new(0,150,0,35)
    MainIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
    MainIcon.BackgroundTransparency = 0
    MainIcon.ZIndex = 5000
    MainIcon.Parent = ERCFrame
    MainIcon.Active = true
    createUICorner(MainIcon)
    createUIStroke(MainIcon)
    CenterFramePosition(MainIcon, 2, 100)

    local MainIconText = Instance.new("TextButton")
    MainIconText.Size = UDim2.new(0,113,0,35)
    MainIconText.BackgroundTransparency = 1
    MainIconText.ZIndex = 6000
    MainIconText.Text = ICON_TEXT
    MainIconText.TextColor3 = Color3.new(1,1,1)
    MainIconText.TextYAlignment = Enum.TextYAlignment.Center
    MainIconText.Font = FontGUI
    MainIconText.TextSize = 20
    MainIconText.TextScaled = true
    MainIconText.Parent = MainIcon
    createUICorner(MainIconText)
    createTextSizeConstraint(MainIconText,10,20)

    local iconDiv = Instance.new("Frame")
    iconDiv.Size = UDim2.new(0,2,1,0)
    iconDiv.Position = UDim2.new(0,113,0,0)
    iconDiv.BackgroundColor3 = Color3.fromRGB(50,50,50)
    iconDiv.BorderSizePixel = 0
    iconDiv.ZIndex = 6000
    iconDiv.Parent = MainIcon
    
    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0,25,0,25)
    iconImg.Position = UDim2.new(0,120,0,5)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://116138709011735"
    iconImg.ScaleType = Enum.ScaleType.Fit
    iconImg.ZIndex = 6000
    iconImg.Parent = MainIcon
    createUICorner(iconImg)

    local titleImg = Instance.new("ImageLabel")
    titleImg.Size = UDim2.new(0,25,0,25)
    titleImg.Position = UDim2.new(0,5,0,5)
    titleImg.BackgroundTransparency = 1
    titleImg.Image = MAIN_IMAGE
    titleImg.ScaleType = Enum.ScaleType.Fit
    titleImg.ZIndex = 10000
    titleImg.Parent = MainFrame
    createUICorner(titleImg)
    createUIStroke(titleImg,0.5)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-138,0,16)
    titleLabel.Position = UDim2.new(0,40,0,2)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = MAIN_TITLE
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.Font = FontGUI
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextScaled = true
    titleLabel.ZIndex = 10000
    titleLabel.Parent = MainFrame
    createTextSizeConstraint(titleLabel,10,18)

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1,-138,0,8)
    descLabel.Position = UDim2.new(0,40,0,20)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = DESC_TITLE
    descLabel.TextColor3 = Color3.fromRGB(200,200,200)
    descLabel.Font = FontGUI
    descLabel.TextSize = 16
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextScaled = true
    descLabel.ZIndex = 10000
    descLabel.Parent = MainFrame
    createTextSizeConstraint(descLabel,10,16)

    local sepL = Instance.new("Frame")
    sepL.Size = UDim2.new(0,2,1,0)
    sepL.Position = UDim2.new(0,35,0,0)
    sepL.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sepL.BorderSizePixel = 0
    sepL.ZIndex = 10000
    sepL.Parent = MainFrame

    local sepR = Instance.new("Frame")
    sepR.Size = UDim2.new(0,2,1,0)
    sepR.Position = UDim2.new(1,-95,0,0)
    sepR.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sepR.BorderSizePixel = 0
    sepR.ZIndex = 10000
    sepR.Parent = MainFrame

    local sepT = Instance.new("Frame")
    sepT.Size = UDim2.new(1,0,0,2)
    sepT.Position = UDim2.new(0,0,0,35)
    sepT.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sepT.BorderSizePixel = 0
    sepT.ZIndex = 20005
    sepT.Parent = MainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,25,0,25)
    closeBtn.Position = UDim2.new(1,-30,0,4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "x"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextYAlignment = Enum.TextYAlignment.Center
    closeBtn.Font = FontGUI
    closeBtn.TextSize = 20
    closeBtn.ZIndex = 10000
    closeBtn.Parent = MainFrame

    local fullscreenBtn = Instance.new("TextButton")
    fullscreenBtn.Size = UDim2.new(0,25,0,25)
    fullscreenBtn.Position = UDim2.new(1,-60,0,5)
    fullscreenBtn.BackgroundTransparency = 1
    fullscreenBtn.Text = "☐"
    fullscreenBtn.TextColor3 = Color3.new(1,1,1)
    fullscreenBtn.TextYAlignment = Enum.TextYAlignment.Center
    fullscreenBtn.Font = FontGUI
    fullscreenBtn.TextSize = 20
    fullscreenBtn.ZIndex = 10000
    fullscreenBtn.Parent = MainFrame

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0,25,0,25)
    minimizeBtn.Position = UDim2.new(1,-90,0,5)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "–"
    minimizeBtn.TextColor3 = Color3.new(1,1,1)
    minimizeBtn.TextYAlignment = Enum.TextYAlignment.Center
    minimizeBtn.Font = FontGUI
    minimizeBtn.TextSize = 20
    minimizeBtn.ZIndex = 10000
    minimizeBtn.Parent = MainFrame

    --// Dragging & Positioning Sys
    local SavedPositions = { MainFrame = nil, MainIcon = nil }
    local SavedSizes = { MainFrame = nil, MainIcon = nil }
    local Draggable = { MainFrame = true, MainIcon = true }
    local dragConnections = {}

        local function DraggingGUI(frame, saveKey)
            if not frame then return end
            
        local dragging, dragStart, startPos, dragInput = false
        local function update(input)
        if not dragging or not dragStart or not startPos then return end
        if saveKey and Draggable[saveKey] == false then return end
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end

        local conn1 = frame.InputBegan:Connect(function(input)
        if saveKey and Draggable[saveKey] == false then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragInput = nil
                    if saveKey then
                        SavedPositions[saveKey] = frame.Position
                        SavedSizes[saveKey] = frame.Size
                    end
                end
            end)
        end
    end)
    addConnection(conn1)

    local conn2 = frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    addConnection(conn2)

    local conn3 = UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
    addConnection(conn3)
end

    DraggingGUI(MainFrame, "MainFrame")
    DraggingGUI(MainIcon, "MainIcon")

local function getCenterPosition(frame)
    local vs = workspace.CurrentCamera.ViewportSize
    return UDim2.new(
        0, (vs.X - frame.AbsoluteSize.X) / 2,
        0, (vs.Y - frame.AbsoluteSize.Y) / 2
    )
end

local function getOutOfScreenPosition(frame)
    local vs = Camera.ViewportSize
    return UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, 0, vs.Y + frame.AbsoluteSize.Y + vs.Y*0.05)
end

local function tweenPosition(inst, targetPos, dur, cb)
    local t = TweenService:Create(inst, TweenInfo.new(dur or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
    t.Completed:Connect(function() if cb then cb() end end)
    t:Play()
    return t
end

local function getRestorePosition(frame, key, fallback)
    return SavedPositions[key] or fallback(frame)
end

local function TweenMainFrameOut(cb)
    tweenPosition(MainFrame, getOutOfScreenPosition(MainFrame), 0.18, function()
        MainFrame.Visible = false
        if cb then cb() end
    end)
end

local function TweenMainFrameIn()
    MainFrame.Position = getOutOfScreenPosition(MainFrame)
    MainFrame.Visible = true
    tweenPosition(MainFrame, getRestorePosition(MainFrame, "MainFrame", getCenterPosition), 0.18)
end

local function TweenIconIn()
    MainIcon.Position = getOutOfScreenPosition(MainIcon)
    MainIcon.Visible = true
    tweenPosition(MainIcon, getRestorePosition(MainIcon, "MainIcon", getCenterPosition), 0.18)
end

local function TweenIconOut(cb)
    tweenPosition(MainIcon, getOutOfScreenPosition(MainIcon), 0.18, function()
        MainIcon.Visible = false
        if cb then cb() end
    end)
end

MainIconText.MouseButton1Click:Connect(function()
    TweenIconOut(function() TweenMainFrameIn() end)
end)

    MainFrame.Visible = false
    MainIcon.Visible = false
    TweenIconOut(function() TweenMainFrameIn() end)
    MainFrame.Position = getCenterPosition(MainFrame)
    MainIcon.Position = getOutOfScreenPosition(MainIcon)

local viewportConn = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if MainFrame.Visible then
        MainFrame.Position = getRestorePosition(MainFrame, "MainFrame", getCenterPosition)
    end
    if MainIcon.Visible then
        MainIcon.Position = getRestorePosition(MainIcon, "MainIcon", getCenterPosition)
    end
end)
addConnection(viewportConn)

    --// Close Frame GUI
    local container = Instance.new("Frame")
    container.Name = "Close ScreenGui"
    container.Size = UDim2.new(0,240,0,192)
    container.AnchorPoint = Vector2.new(0.5,0.5)
    container.Position = UDim2.new(0.5,0,0.5,0)
    container.BackgroundColor3 = Color3.fromRGB(30,30,30)
    container.Visible = false
    container.Active = true
    container.ZIndex = 30000
    container.Parent = MainFrame
    createUICorner(container)
    createUIStroke(container, 2, Color3.fromRGB(50,50,50))
    
    local SD = Instance.new("Frame")
    SD.Size = UDim2.new(1,0,1,0)
    SD.AnchorPoint = Vector2.new(0.5,0.5)
    SD.Position = UDim2.new(0.5,0,0.5,0)
    SD.BackgroundColor3 = Color3.fromRGB(0,0,0)
    SD.BackgroundTransparency = 0.6
    SD.Parent = MainFrame
    SD.Visible = false
    SD.Active = true
    SD.ZIndex = 20020
    createUICorner(SD)
    
    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Close Window"
    TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TitleLabel.Font = FontGUI
    TitleLabel.TextSize = 24
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 30002
    TitleLabel.Parent = container
    createUICorner(TitleLabel)

    -- Description Text
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -20, 0, 70)
    DescriptionLabel.Position = UDim2.new(0, 10, 0, 40)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.Text = "Do you want to close this window?\nYou will not be able to open it again."
    DescriptionLabel.TextColor3 = Color3.fromRGB(200,200,200)
    DescriptionLabel.Font = FontGUI
    DescriptionLabel.TextSize = 16
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.ZIndex = 30002
    DescriptionLabel.Parent = container
    createUICorner(DescriptionLabel)
    
    -- Separator
    local Mainseparator = Instance.new("Frame")
    Mainseparator.Size = UDim2.new(1, 0, 0, 2)
    Mainseparator.Position = UDim2.new(0, 0, 0, 140)
    Mainseparator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Mainseparator.BorderSizePixel = 0
    Mainseparator.ZIndex = 30001
    Mainseparator.Parent = container

    -- Done/Cancel
    local DoneButtonFrame = Instance.new("Frame")
    DoneButtonFrame.Size = UDim2.new(0,85,0,26)
    DoneButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
    DoneButtonFrame.Position = UDim2.new(0,60,0,168)
    DoneButtonFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    DoneButtonFrame.ZIndex = 30001
    DoneButtonFrame.Parent = container
    createUICorner(DoneButtonFrame)
    createUIStroke(DoneButtonFrame, 2, Color3.fromRGB(45,45,45))

    local DoneButton = Instance.new("TextButton")
    DoneButton.Size = UDim2.new(0,85,0,26)
    DoneButton.AnchorPoint = Vector2.new(0.5,0.5)
    DoneButton.Position = UDim2.new(0,42.5,0,13)
    DoneButton.BackgroundTransparency = 1
    DoneButton.Text = "Done"
    DoneButton.TextColor3 = Color3.fromRGB(255,255,255)
    DoneButton.Font = FontGUI
    DoneButton.TextSize = 14
    DoneButton.ZIndex = 30002
    DoneButton.Parent = DoneButtonFrame
    createUICorner(DoneButton)

    local CancelButtonFrame = Instance.new("Frame")
    CancelButtonFrame.Size = UDim2.new(0,85,0,26)
    CancelButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
    CancelButtonFrame.Position = UDim2.new(0,180,0,168)
    CancelButtonFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    CancelButtonFrame.ZIndex = 30002
    CancelButtonFrame.Parent = container
    createUICorner(CancelButtonFrame)
    createUIStroke(CancelButtonFrame, 2, Color3.fromRGB(45,45,45))

    local CancelButton = Instance.new("TextButton")
    CancelButton.Size = UDim2.new(0,85,0,26)
    CancelButton.AnchorPoint = Vector2.new(0.5,0.5)
    CancelButton.Position = UDim2.new(0,42.5,0,13)
    CancelButton.BackgroundTransparency = 1
    CancelButton.Text = "Cancel"
    CancelButton.TextColor3 = Color3.fromRGB(255,255,255)
    CancelButton.Font = FontGUI
    CancelButton.TextSize = 14
    CancelButton.ZIndex = 30002
    CancelButton.Parent = CancelButtonFrame
    createUICorner(CancelButton)
    
-- Open the confirmation box
closeBtn.MouseButton1Click:Connect(function()
        container.Visible = true  
        SD.Visible = true  
    local targetPos = getCenterPosition(MainFrame)
    
    tweenPosition(MainFrame, targetPos, 0.18, function()
        SavedPositions["MainFrame"] = targetPos
    end)
end)

DoneButton.MouseButton1Click:Connect(function()
    -- close
    container.Visible = false
    SD.Visible = false
    
    -- close GUI main
    TweenMainFrameOut()
    task.wait(1.5)
    disconnectAll()
    ERCFrame:Destroy()
end)

CancelButton.MouseButton1Click:Connect(function()
    -- close
    container.Visible = false
    SD.Visible = false
end)

--// Fullscreen Syst
local isFullscreen = false
local originalSize = MainFrame.Size
local originalPosition = nil
local beforeFullscreenPos = nil
local FULLSCREEN_MARGIN_X = 10 -- ซ้าย/ขวา
local FULLSCREEN_MARGIN_BOTTOM = 60 -- ล่าง

local function setDraggable(enabled)
    Draggable["MainFrame"] = enabled
end

local activeTween = nil

local function cancelActiveTween()
    if activeTween then
        activeTween:Cancel()
        activeTween = nil
    end
end

local function getCenterForSize(width, height)
    local vs = Camera.ViewportSize
    return UDim2.new(0, (vs.X - width) / 2, 0, (vs.Y - height) / 100)
end

local function smoothTween(inst, duration, props, easingStyle, callback)
    cancelActiveTween()
    local tw = TweenService:Create(inst, TweenInfo.new(
        duration,
        easingStyle or Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), props)
    activeTween = tw
    tw:Play()
    tw.Completed:Connect(function()
        activeTween = nil
        if callback then callback() end
    end)
    return tw
end

local function exitFullscreen(callback)
    isFullscreen = false
    setDraggable(true)

    local restoreSize = SavedSizes["MainFrame"] or originalSize
    local restorePos = beforeFullscreenPos or SavedPositions["MainFrame"] or getCenterPosition(MainFrame)
    local centerPos = getCenterForSize(restoreSize.X.Offset, restoreSize.Y.Offset)

    smoothTween(MainFrame, 0.18, {
        Size = restoreSize,
        Position = centerPos
    }, Enum.EasingStyle.Quad, function()

        smoothTween(MainFrame, 0.22, {
            Position = restorePos
        }, Enum.EasingStyle.Quad, function()

            SavedPositions["MainFrame"] = restorePos
            SavedSizes["MainFrame"] = restoreSize
            beforeFullscreenPos = nil

            if callback then callback() end
        end)
    end)
end

fullscreenBtn.MouseButton1Click:Connect(function()
    isFullscreen = not isFullscreen

    if isFullscreen then
        beforeFullscreenPos = MainFrame.Position
        originalPosition = MainFrame.Position
        originalSize = MainFrame.Size
        SavedPositions["MainFrame"] = MainFrame.Position
        SavedSizes["MainFrame"] = MainFrame.Size

        setDraggable(false)

        local currentSize = MainFrame.Size
        local centerPos = getCenterForSize(currentSize.X.Offset, currentSize.Y.Offset)

        smoothTween(MainFrame, 0.18, {
            Position = centerPos
        }, Enum.EasingStyle.Quad, function()

            local vs = Camera.ViewportSize

            smoothTween(MainFrame, 0.25, {
                Size = UDim2.new(
                    0,
                    vs.X - (FULLSCREEN_MARGIN_X * 2),
                    0,
                    vs.Y - FULLSCREEN_MARGIN_BOTTOM
                ),
                Position = UDim2.new(
                    0,
                    FULLSCREEN_MARGIN_X,
                    0,
                    0
                )
            }, Enum.EasingStyle.Quad, nil)

        end)
    else
        exitFullscreen()
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    if isFullscreen then
        exitFullscreen(function()
            TweenMainFrameOut(function()
                TweenIconIn()
            end)
        end)
    else
        TweenMainFrameOut(function()
            TweenIconIn()
        end)
    end
end)

local viewportFullscreenConn = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if isFullscreen and MainFrame.Visible then
        local vs = Camera.ViewportSize
        cancelActiveTween()
        MainFrame.Size = UDim2.new(
            0,
            vs.X - (FULLSCREEN_MARGIN_X * 2),
            0,
            vs.Y - FULLSCREEN_MARGIN_BOTTOM
        )
        MainFrame.Position = UDim2.new(
            0,
            FULLSCREEN_MARGIN_X,
            0,
            0
        )
    end
end)

addConnection(viewportFullscreenConn)

--// Notification System
local AnchorFrame = Instance.new("Frame")
AnchorFrame.Name = "Notification-01"
AnchorFrame.Size = UDim2.new(1,0,0,1)
AnchorFrame.Position = UDim2.new(0,0,0,0)
AnchorFrame.BackgroundTransparency = 1
AnchorFrame.ZIndex = 50000
AnchorFrame.Parent = ERCFrame

local Container = Instance.new("Frame")
Container.Name = "Notification-02"
Container.Size = UDim2.new(1,0,1,0)
Container.BackgroundTransparency = 1
Container.ZIndex = 50001
Container.Parent = ERCFrame

local NOTIF_WIDTH, NOTIF_HEIGHT, NOTIF_SPACING, SLIDE_OFFSET = 270,75,10,450
local TWEEN_INFO = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local BASE_Y = 0
local activeNotifications = {}

local function syncBaseY() BASE_Y = math.floor(AnchorFrame.AbsolutePosition.Y) end
local conn
conn = AnchorFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if AnchorFrame.AbsolutePosition.Y >= 0 then
        syncBaseY()
        conn:Disconnect()
    end
end)
addConnection(conn)

local function calcY(index) return BASE_Y + (index-1)*(NOTIF_HEIGHT+NOTIF_SPACING) end
local function rearrange()
    for i, notif in ipairs(activeNotifications) do
        TweenService:Create(notif, TWEEN_INFO, {
            Position = UDim2.new(1, -NOTIF_WIDTH-10, 0, calcY(i))
        }):Play()
    end
end

local NOTIFICATION_SOUND_ID = "rbxassetid://87437544236708"
local NOTIF_TITLE = "ERC SYSTEM"

local NotificationSound = Instance.new("Sound")
NotificationSound.Name = "Roblox.API.Notification.Sound"
NotificationSound.SoundId = NOTIFICATION_SOUND_ID
NotificationSound.Volume = 1
NotificationSound.Parent = SoundService

function erclib:Notification(config)
    -- (setting default)
    local title = config.TitleText or NOTIF_TITLE
    local msg = config.MessageText or "(...)"
    local delay = config.DelayTime or 1

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0,NOTIF_WIDTH,0,NOTIF_HEIGHT)
    notif.Position = UDim2.new(1,SLIDE_OFFSET,0,calcY(#activeNotifications+1))
    notif.BackgroundColor3 = Color3.fromRGB(30,30,30)
    notif.ClipsDescendants = true
    notif.ZIndex = 50002
    notif.Parent = Container
    createUICorner(notif)
    createUIStroke(notif)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0,25,0,25)
    img.Position = UDim2.new(0,3,0,3)
    img.BackgroundTransparency = 1
    img.Image = MAIN_IMAGE
    img.ScaleType = Enum.ScaleType.Fit
    img.ZIndex = 50004
    img.Parent = notif
    createUICorner(img)
    createUIStroke(img,0.5)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-75,0,25)
    titleLabel.Position = UDim2.new(0,38,0,3)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.Font = FontGUI
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextScaled = true
    titleLabel.ZIndex = 50003
    titleLabel.Parent = notif
    createTextSizeConstraint(titleLabel,14,16)

    local sep1 = Instance.new("Frame")
    sep1.Size = UDim2.new(0,2,0.4,0)
    sep1.Position = UDim2.new(0,32,0,0)
    sep1.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sep1.BorderSizePixel = 0
    sep1.ZIndex = 50004
    sep1.Parent = notif

    local sep2 = Instance.new("Frame")
    sep2.Size = UDim2.new(0,2,0.4,0)
    sep2.Position = UDim2.new(1,-35,0,0)
    sep2.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sep2.BorderSizePixel = 0
    sep2.ZIndex = 50004
    sep2.Parent = notif

    local sep3 = Instance.new("Frame")
    sep3.Size = UDim2.new(1,0,0,2)
    sep3.Position = UDim2.new(0,0,0,30)
    sep3.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sep3.BorderSizePixel = 0
    sep3.ZIndex = 50004
    sep3.Parent = notif

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,25,0,25)
    closeBtn.Position = UDim2.new(1,-30,0,2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "x"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextYAlignment = Enum.TextYAlignment.Center
    closeBtn.Font = FontGUI
    closeBtn.TextSize = 20
    closeBtn.ZIndex = 50003
    closeBtn.Parent = notif

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1,-5,0,41)
    body.Position = UDim2.new(0,3,0,33)
    body.BackgroundTransparency = 1
    body.Text = msg
    body.TextColor3 = Color3.fromRGB(200,200,200)
    body.Font = FontGUI
    body.TextSize = 14
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.TextScaled = true
    body.ZIndex = 50005
    body.Parent = notif
    createTextSizeConstraint(body,12,14)

    NotificationSound:Stop()
    NotificationSound:Play()

    table.insert(activeNotifications, notif)
    rearrange()

    local closed = false
    local function closeNotification()
        if closed then return end
        closed = true
        local idx = table.find(activeNotifications, notif)
        if idx then table.remove(activeNotifications, idx) end
        TweenService:Create(notif, TweenInfo.new(0.2), {
            Position = UDim2.new(1,SLIDE_OFFSET,0,notif.Position.Y.Offset)
        }):Play()
        task.delay(0.25, function()
            if notif then notif:Destroy() end
            rearrange()
        end)
    end

    task.delay(delay, closeNotification)
    closeBtn.MouseButton1Click:Connect(closeNotification)
end

--// Sidebar & Pages Sys
local sidebarFrame = Instance.new("Frame")
sidebarFrame.Name = "sidebarFrame"
sidebarFrame.Size = UDim2.new(0,180,1,-35)
sidebarFrame.Position = UDim2.new(0,0,0,35)
sidebarFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
sidebarFrame.BorderSizePixel = 0
sidebarFrame.ZIndex = 20000
sidebarFrame.Active = true
sidebarFrame.ClipsDescendants = true
sidebarFrame.Parent = MainFrame
createUICorner(sidebarFrame)

local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "sidebar"
sidebar.Size = UDim2.new(1,0,1,0)
sidebar.BackgroundTransparency = 1
sidebar.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
sidebar.ScrollBarThickness = 0
sidebar.CanvasSize = UDim2.new(0,0,0,0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.None
sidebar.ZIndex = 20001
sidebar.Active = true
sidebar.ElasticBehavior = Enum.ElasticBehavior.Never
sidebar.Parent = sidebarFrame
createUICorner(sidebar)
createListLayout(sidebar,4,6,0,2.5)

local sidebarDiv = Instance.new("Frame")
sidebarDiv.Name = "sidebarDiv"
sidebarDiv.Size = UDim2.new(0,2,1,0)
sidebarDiv.Position = UDim2.new(1,-2,0,0)
sidebarDiv.BackgroundColor3 = Color3.fromRGB(50,50,50)
sidebarDiv.BorderSizePixel = 0
sidebarDiv.ZIndex = 20002
sidebarDiv.Parent = sidebarFrame

local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(1,-180,1,-37.8)
TabsFrame.Position = UDim2.new(0,180,0,37.8)
TabsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabsFrame.BackgroundTransparency = 0
TabsFrame.ZIndex = 19999
TabsFrame.ClipsDescendants = true -- กันล้นขอบ
TabsFrame.Visible = true
TabsFrame.Active = true
TabsFrame.Parent = MainFrame
createUICorner(TabsFrame)

--// Tabpages 
local pages = {}
local pageOrder = {}

local currentTweenIn = nil
local currentTweenOut = nil
local currentPageName = nil

local switchToken = 0 -- ตัวกัน event ซ้อน

local NORMAL_COLOR = Color3.fromRGB(200,200,200)
local ACTIVE_COLOR = Color3.new(1,1,1)
local INDICATOR_COLOR = Color3.fromRGB(45,45,45)
local buttons = {}
local currentSelected = nil

local function forceCleanupPages(exceptName)
    for name, page in pairs(pages) do
        if name ~= exceptName then
            page.Visible = false
            page.Position = UDim2.new(0,0,0,0)
        end
    end
end

local function switchPage(pageName)
    if not pages[pageName] then return end
    if currentPageName == pageName then return end

    switchToken += 1
    local myToken = switchToken

    local newPage = pages[pageName]
    local oldPage = currentPageName and pages[currentPageName]

    -- ยกเลิก tween เก่า
    if currentTweenIn then
        currentTweenIn:Cancel()
        currentTweenIn = nil
    end
    if currentTweenOut then
        currentTweenOut:Cancel()
        currentTweenOut = nil
    end

    -- ถ้ายังไม่มีหน้าเก่า
    if not oldPage then
        forceCleanupPages(pageName)
        newPage.Position = UDim2.new(0,0,0,0)
        newPage.Visible = true
        currentPageName = pageName
        return
    end

    -- หา index
    local oldIndex, newIndex
    for i,v in ipairs(pageOrder) do
        if v == currentPageName then oldIndex = i end
        if v == pageName then newIndex = i end
    end

    local direction = (newIndex > oldIndex) and 1 or -1

    -- ตั้งค่าเริ่มต้น
    forceCleanupPages(nil) -- ปิดทุกหน้าไว้ก่อน
    oldPage.Visible = true
    newPage.Visible = true

    newPage.Position = UDim2.new(0,0,direction,0)
    oldPage.Position = UDim2.new(0,0,0,0)

    currentTweenIn = TweenService:Create(
        newPage,
        TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = UDim2.new(0,0,0,0) }
    )

    currentTweenOut = TweenService:Create(
        oldPage,
        TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = UDim2.new(0,0,-direction,0) }
    )

    currentTweenIn:Play()
    currentTweenOut:Play()

    currentTweenIn.Completed:Connect(function()
        -- ถ้ามีการกดใหม่ระหว่างทาง → ไม่ทำต่อ
        if myToken ~= switchToken then return end

        forceCleanupPages(pageName)
        newPage.Visible = true
        newPage.Position = UDim2.new(0,0,0,0)

        currentPageName = pageName
    end)
end

local function createSidebarButton(name)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1,-12,0,35)
    btnFrame.BackgroundTransparency = 1
    btnFrame.ZIndex = 20000
    btnFrame.Parent = sidebar
    createUICorner(btnFrame)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0,6,0,16)
    indicator.AnchorPoint = Vector2.new(0.5,0.5)
    indicator.Position = UDim2.new(0,6,0,17.5)
    indicator.BackgroundColor3 = INDICATOR_COLOR
    indicator.Visible = false
    indicator.ZIndex = 20003
    indicator.Parent = btnFrame
    createUICorner(indicator)

    local hitBtn = Instance.new("TextButton")
    hitBtn.Size = UDim2.new(1,0,1,0)
    hitBtn.BackgroundTransparency = 1
    hitBtn.Text = ""
    hitBtn.ZIndex = 20005
    hitBtn.Parent = btnFrame
    createUICorner(hitBtn)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-10,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = NORMAL_COLOR
    label.Font = FontGUI
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 18
    label.ZIndex = 20002
    label.Parent = btnFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(45,45,45)
    stroke.Enabled = false
    stroke.Parent = btnFrame

    buttons[name] = { frame = btnFrame, label = label, indicator = indicator, stroke = stroke }

    hitBtn.MouseEnter:Connect(function()
        if currentSelected ~= name then label.TextColor3 = ACTIVE_COLOR end
    end)
    hitBtn.MouseLeave:Connect(function()
        if currentSelected ~= name then label.TextColor3 = NORMAL_COLOR end
    end)

    hitBtn.MouseButton1Click:Connect(function()
        if currentSelected == name then return end
        if currentSelected then
            local old = buttons[currentSelected]
            if old then
                old.stroke.Enabled = false
                TweenService:Create(old.indicator, TweenInfo.new(0.2), { Size = UDim2.new(0,6,0,16) }):Play()
                TweenService:Create(old.label, TweenInfo.new(0.25), { Position = UDim2.new(0,10,0,0), TextColor3 = NORMAL_COLOR }):Play()
                old.indicator.Visible = false
            end
        end
        currentSelected = name
        local mine = buttons[name]
        mine.stroke.Enabled = true
        mine.label.TextColor3 = ACTIVE_COLOR
        mine.indicator.Visible = true
        TweenService:Create(mine.indicator, TweenInfo.new(0.25, Enum.EasingStyle.Sine), { Size = UDim2.new(0,6,1,-8) }):Play()
        TweenService:Create(mine.label, TweenInfo.new(0.25, Enum.EasingStyle.Sine), { Position = UDim2.new(0,18,0,0) }):Play()
        switchPage(name)
    end)

    if not currentSelected then
        currentSelected = name
        stroke.Enabled = true
        indicator.Visible = true
        indicator.Size = UDim2.new(0,6,0,16)
        label.Position = UDim2.new(0,10,0,0)
        label.TextColor3 = ACTIVE_COLOR
        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Size = UDim2.new(0,6,1,-8) }):Play()
        TweenService:Create(label, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = UDim2.new(0,18,0,0) }):Play()
        switchPage(name)
    end
    return btnFrame
end

--// Tabs
local Tabs = {} -- data

function Tabs:CreateTab(config)
    local name = config.Name
    local Tabpage = Instance.new("ScrollingFrame")
    Tabpage.Size = UDim2.new(1,0,1,0)
    Tabpage.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Tabpage.BackgroundTransparency = 0
    Tabpage.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    Tabpage.ScrollBarThickness = 0
    Tabpage.CanvasSize = UDim2.new(0,0,0,0)
    Tabpage.AutomaticCanvasSize = Enum.AutomaticSize.None
    Tabpage.ZIndex = 20000
    Tabpage.Visible = false
    Tabpage.Active = true
    Tabpage.ElasticBehavior = Enum.ElasticBehavior.Never
    Tabpage.ClipsDescendants = true
    Tabpage.Parent = TabsFrame
    createUICorner(Tabpage)
    createListLayout(Tabpage,8,6,2.5,0)
    
    pages[name] = Tabpage
    table.insert(pageOrder, name)
    createSidebarButton(name)

--// Function createToggle Sys
local ContainerContent = {} -- data

--// Function: ฟังก์ชัน สร้างแผงสำหรับหัวข้อกลุ่ม
function ContainerContent:createToggleSection(config)
    -- config
    local Parent = config.Parent
    local Name   = config.Name or "Section"

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)
    createUIStroke(container, 2, Color3.fromRGB(45, 45, 45))

    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(0, 6, 0, 28)
    labelFrame.Position = UDim2.new(0, 4, 0, 3.5)
    labelFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    labelFrame.BackgroundTransparency = 0
    labelFrame.ZIndex = 20001
    labelFrame.Parent = container
    createUICorner(labelFrame)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = FontGUI
    label.TextSize = 17
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 12, 18)

    -- API
    local api = {}

    function api:SetText(text)
        label.Text = tostring(text)
    end
    
    function api:ClearText()
        label.Text = ""
    end
    
    --[[
    • API เรียกใช้ภายนอก (createToggleSection)
    - api:SetText("text") :: เปลี่ยนข้อความใหม่
    - api:ClearText() :: ลบข้อความออก
    ]]
    
    return api
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับรายละเอียด
function ContainerContent:createToggleDescription(config)
    -- config
    local Parent = config.Parent
    local Name   = config.Description or "Description"

    local MIN_CONTAINER_Y = 35          
    local MAX_CONTAINER_Y = 2147483647
      
    local MIN_LABELFRAME_Y = 28          
    local MAX_LABELFRAME_Y = 2147483647
          
    -- UI          
    local container = Instance.new("Frame")            
    container.Size = UDim2.new(1, -18, 0, MAX_CONTAINER_Y)            
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)            
    container.ZIndex = 20000            
    container.Parent = Tabpage            
    createUICorner(container)            
    createUIStroke(container, 2, Color3.fromRGB(45, 45, 45))            
      
    local labelFrame = Instance.new("Frame")            
    labelFrame.Size = UDim2.new(0, 6, 0, MAX_LABELFRAME_Y)            
    labelFrame.Position = UDim2.new(0, 4, 0, 3.5)  
    labelFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)            
    labelFrame.ZIndex = 20001            
    labelFrame.Parent = container            
    createUICorner(labelFrame)            
    
    local label = Instance.new("TextLabel")            
    label.Size = UDim2.new(1, -30, 1, 0)            
    label.Position = UDim2.new(0, 14, 0, 3)            
    label.BackgroundTransparency = 1            
    label.Text = Name            
    label.TextColor3 = Color3.fromRGB(255,255,255)  
    label.Font = FontGUI            
    label.TextSize = 14            
    label.TextWrapped = true            
    label.TextXAlignment = Enum.TextXAlignment.Left     
    label.TextYAlignment = Enum.TextYAlignment.Top  
    label.ZIndex = 20001            
    label.Parent = container            
    createTextSizeConstraint(label, 10, 14)          
      
local TextService = game:GetService("TextService")

local function updateSize()

    local bounds = TextService:GetTextSize(
        label.Text,
        label.TextSize,
        label.Font,
        Vector2.new(label.AbsoluteSize.X, math.huge)
    )

    local textHeight = bounds.Y + 6

    local newContainerY = math.clamp(
        textHeight,
        MIN_CONTAINER_Y,
        MAX_CONTAINER_Y
    )

    local newLabelFrameY = math.clamp(
        newContainerY - 7,
        MIN_LABELFRAME_Y,
        MAX_LABELFRAME_Y
    )

    container.Size = UDim2.new(1, -18, 0, newContainerY)
    labelFrame.Size = UDim2.new(0, 6, 0, newLabelFrameY)

end

label:GetPropertyChangedSignal("TextBounds"):Connect(updateSize)          
-- API          
local api = {}          
      
function api:SetText(text)          
    label.Text = tostring(text)          
    updateSize()          
end          
      
function api:ClearText()          
    label.Text = ""          
    updateSize()          
end          

    --[[
    • API เรียกใช้ภายนอก (createToggleDescription)
    - api:SetText("text") :: เปลี่ยนข้อความใหม่
    - api:ClearText() :: ลบข้อความออก
    ]]
      
updateSize()          
return api

end

--// Function: ฟังก์ชัน สร้างแผงสำหรับเปิดใช้งานทั่วไ  (เปิด/ปิด)
function ContainerContent:createToggle(config)
    -- config
    local Parent      = config.Parent
    local Name        = config.Name or "Toggle"
    local Description = config.Description or ""
    local state       = config.State or false
    local callback    = config.callback

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45, 45, 45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0, 150, 255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Enabled = false
    flashBorder.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 0, 15)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = FontGUI
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 14, 16)

    local labelP = Instance.new("TextLabel")
    labelP.Size = UDim2.new(1, -150, 0, 15)
    labelP.Position = UDim2.new(0, 8, 0, 18)
    labelP.BackgroundTransparency = 1
    labelP.Text = Description
    labelP.TextColor3 = Color3.fromRGB(100, 100, 100)
    labelP.Font = FontGUI
    labelP.TextSize = 14
    labelP.TextXAlignment = Enum.TextXAlignment.Left
    labelP.TextScaled = true
    labelP.ZIndex = 20001
    labelP.Parent = container
    createTextSizeConstraint(labelP, 12, 14)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.45, -20, 0.8, 0)
    toggleBtn.Position = UDim2.new(0.55, 15, 0.1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 20001
    toggleBtn.Parent = container

    local statusContainer = Instance.new("Frame")
    statusContainer.Size = UDim2.new(0, 40, 0, 20)
    statusContainer.Position = UDim2.new(1, -55, 0.5, -10)
    statusContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    statusContainer.BorderSizePixel = 0
    statusContainer.ZIndex = 20002
    statusContainer.Parent = container
    createUICorner(statusContainer)
    createUIStroke(statusContainer, 1, Color3.fromRGB(45,45,45))

    local sliderDot = Instance.new("Frame")
    sliderDot.Size = UDim2.new(0, 14, 0, 14)
    sliderDot.Position = UDim2.new(0, 3, 0.5, -7)
    sliderDot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderDot.BorderSizePixel = 0
    sliderDot.ZIndex = 20003
    sliderDot.Parent = statusContainer
    createUICorner(sliderDot)

    -- animation
    local function animate(newState)

        TweenService:Create(mainBorder, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(0,150,255)
        }):Play()

        task.delay(0.6, function()
            TweenService:Create(mainBorder, TweenInfo.new(0.6), {
                Color = Color3.fromRGB(45,45,45)
            }):Play()
        end)

        flashBorder.Enabled = true
        flashBorder.Transparency = 0
        TweenService:Create(flashBorder, TweenInfo.new(0.6), {
            Transparency = 1
        }):Play()

        if newState then
            TweenService:Create(statusContainer, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0,165,255)
            }):Play()

            TweenService:Create(sliderDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0,23,0.5,-7)
            }):Play()
        else
            TweenService:Create(statusContainer, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35,35,35)
            }):Play()

            TweenService:Create(sliderDot, TweenInfo.new(0.2), {
                Position = UDim2.new(0,3,0.5,-7)
            }):Play()
        end
    end

    -- API
    local api = {} 

    function api:SetState(newState)
        if state == newState then return end
        state = newState
        animate(state)
        if callback then callback(state) end
    end

    function api:GetState()
        return state
    end

    toggleBtn.MouseButton1Click:Connect(function()
        api:SetState(not state)
    end)

    task.defer(function()
        animate(state)
        if callback then
            callback(state) -- ยิงค่า default ตอนสร้าง
        end
    end)
    
    --[[
    • API เรียกใช้ภายนอก (createToggle)
    - api:SetState(newState) :: ตั้งค่าสถานะ
    - api:GetState() :: ขอสภานะ
    ]]

    return api
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับใส่ข้อความ
function ContainerContent:createToggleText(config)
    -- config
    local Parent = config.Parent
    local Name = config.Name or "Text"
    local Description = config.Description or ""
    local Text = config.Text or ""
    local PlaceholderText = config.PlaceholderText or ""

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45, 45, 45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0, 150, 255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Enabled = false
    flashBorder.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 0, 15)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = FontGUI
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 14, 16)

    local labelP = Instance.new("TextLabel")
    labelP.Size = UDim2.new(1, -150, 0, 15)
    labelP.Position = UDim2.new(0, 8, 0, 18)
    labelP.BackgroundTransparency = 1
    labelP.Text = Description
    labelP.TextColor3 = Color3.fromRGB(100, 100, 100)
    labelP.Font = FontGUI
    labelP.TextSize = 14
    labelP.TextXAlignment = Enum.TextXAlignment.Left
    labelP.TextScaled = true
    labelP.ZIndex = 20001
    labelP.Parent = container
    createTextSizeConstraint(labelP, 12, 14)

    local inputBoxFrame = Instance.new("Frame")
    inputBoxFrame.Size = UDim2.new(0.45, -20, 0.8, 0)
    inputBoxFrame.Position = UDim2.new(0.55, 15, 0.1, 0)
    inputBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    inputBoxFrame.ZIndex = 20001
    inputBoxFrame.Parent = container
    createUICorner(inputBoxFrame)
    createUIStroke(inputBoxFrame, 1, Color3.fromRGB(45,45,45))

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, 0, 1, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.PlaceholderText = PlaceholderText
    inputBox.Text = Text
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.Font = FontGUI
    inputBox.TextSize = 16
    inputBox.TextScaled = true
    inputBox.ZIndex = 20002
    inputBox.Parent = inputBoxFrame
    createTextSizeConstraint(inputBox, 10, 16)

    -- animation
    inputBox.Focused:Connect(function()

        TweenService:Create(mainBorder,
            TweenInfo.new(0.12),
            {Color = Color3.fromRGB(0,150,255)}
        ):Play()

        flashBorder.Enabled = true
        flashBorder.Transparency = 0

        TweenService:Create(flashBorder,
            TweenInfo.new(0.6),
            {Transparency = 1}
        ):Play()

    end)

    inputBox.FocusLost:Connect(function()

        TweenService:Create(mainBorder,
            TweenInfo.new(0.5),
            {Color = Color3.fromRGB(45,45,45)}
        ):Play()

        flashBorder.Enabled = false

    end)

    -- API
    local api = {}

    function api:SetText(text)
        inputBox.Text = tostring(text)
    end

    function api:GetText()
        return inputBox.Text
    end

    function api:ClearText()
        inputBox.Text = ""
    end

    --[[
    • API เรียกใช้ภายนอก (createToggleText)
    - api:SetText("text") :: เปลี่ยนข้อความใหม่
    - api:GetState() :: ขอข้อความ
    - api:ClearText() :: ลบข้อความออก
    ]]

    return api
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับแสดงค่า
function ContainerContent:createToggleTextLabel(config)
    -- config
    local Parent = config.Parent
    local Name = config.Name or "Label"
    local Description = config.Description or ""
    local Text = config.Text or ""

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45, 45, 45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0, 150, 255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Enabled = false
    flashBorder.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 0, 15)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = FontGUI
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 14, 16)

    local labelP = Instance.new("TextLabel")
    labelP.Size = UDim2.new(1, -150, 0, 15)
    labelP.Position = UDim2.new(0, 8, 0, 18)
    labelP.BackgroundTransparency = 1
    labelP.Text = Description
    labelP.TextColor3 = Color3.fromRGB(100, 100, 100)
    labelP.Font = FontGUI
    labelP.TextSize = 14
    labelP.TextXAlignment = Enum.TextXAlignment.Left
    labelP.TextScaled = true
    labelP.ZIndex = 20001
    labelP.Parent = container
    createTextSizeConstraint(labelP, 12, 14)

    local inputBoxFrame = Instance.new("Frame")
    inputBoxFrame.Size = UDim2.new(0.45, -20, 0.8, 0)
    inputBoxFrame.Position = UDim2.new(0.55, 15, 0.1, 0)
    inputBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    inputBoxFrame.ZIndex = 20001
    inputBoxFrame.Parent = container
    createUICorner(inputBoxFrame)
    createUIStroke(inputBoxFrame, 1, Color3.fromRGB(45,45,45))

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Text = Text
    valueLabel.TextXAlignment = Enum.TextXAlignment.Center
    valueLabel.Font = FontGUI
    valueLabel.TextSize = 16
    valueLabel.TextScaled = true
    valueLabel.ZIndex = 20002
    valueLabel.Parent = inputBoxFrame
    createTextSizeConstraint(valueLabel, 10, 16)

    -- API
    local api = {}

    function api:SetText(text)
        valueLabel.Text = tostring(text)
    end
    
    function api:GetText()
        return valueLabel.Text
    end

    function api:ClearText()
        valueLabel.Text = ""
    end
    
    --[[
    • API เรียกใช้ภายนอก (createToggleTextLabel)
    - api:SetText("text") :: เปลี่ยนข้อความใหม่
    - api:GetState() :: ขอข้อความ
    - api:ClearText() :: ลบข้อความออก
    ]]

    return api
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับรัน Script ได้
function ContainerContent:createToggleButton(config)
    -- config
    local Parent = config.Parent
    local Name = config.Name or ""
    local Description = config.Description or ""
    local Text = config.Text or ""
    local callback = config.callback

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45, 45, 45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0, 150, 255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Enabled = false
    flashBorder.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 0, 15)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = FontGUI
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 14, 16)

    local labelP = Instance.new("TextLabel")
    labelP.Size = UDim2.new(1, -150, 0, 15)
    labelP.Position = UDim2.new(0, 8, 0, 18)
    labelP.BackgroundTransparency = 1
    labelP.Text = Description
    labelP.TextColor3 = Color3.fromRGB(100,100,100)
    labelP.Font = FontGUI
    labelP.TextSize = 14
    labelP.TextXAlignment = Enum.TextXAlignment.Left
    labelP.TextScaled = true
    labelP.ZIndex = 20001
    labelP.Parent = container
    createTextSizeConstraint(labelP, 12, 14)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, -20, 0.8, 0)
    btn.Position = UDim2.new(0.55, 15, 0.1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 20001
    btn.Parent = container
    createUICorner(btn)

    local b = Instance.new("TextLabel")
    b.Size = UDim2.new(0, 20, 0, 20)
    b.Position = UDim2.new(1, -45, 0.5, -10)
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.fromRGB(100,100,100)
    b.Text = Text
    b.Font = FontGUI
    b.TextSize = 16
    b.TextXAlignment = Enum.TextXAlignment.Center
    b.ZIndex = 20002
    b.Parent = container
    createTextSizeConstraint(b, 14, 16)

    -- callback
    btn.MouseButton1Click:Connect(function()

        TweenService:Create(mainBorder,
            TweenInfo.new(0.1, Enum.EasingStyle.Sine),
            {Color = Color3.fromRGB(0,150,255)}
        ):Play()

        task.delay(0.6,function()
            TweenService:Create(mainBorder,
                TweenInfo.new(0.6, Enum.EasingStyle.Sine),
                {Color = Color3.fromRGB(45,45,45)}
            ):Play()
        end)

        flashBorder.Enabled = true
        flashBorder.Transparency = 0

        TweenService:Create(flashBorder,
            TweenInfo.new(0.6, Enum.EasingStyle.Sine),
            {Transparency = 1}
        ):Play()

        if callback then
            task.spawn(function()
                pcall(callback)
            end)
        end
    end)
    
    --[[
    • API เรียกใช้ภายนอก (createToggleButton)
    - ไม่มี
    ]]

    return btn
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับปรับค่าแบบปรับค่าแบบเลื่อนได้
--// แบบจำนวนเต็ม และทศนิยม
function ContainerContent:createToggleSlider(config)
    -- config
    local Parent = config.Parent
    local Name = config.Name or ""
    local mode = config.mode
    local default = config.default or 0
    local minValue = config.minValue or 0
    local maxValue = config.maxValue or 100
    local callback = config.callback or function() end

    --- mode
    if mode ~= "int" and mode ~= "decimal" then
        error("createToggleSlider: mode must be 'int' or 'decimal'")
    end

    local function round3(n)
        return math.floor(n * 1000 + 0.5) / 1000
    end

    local function formatValue(v)
        if mode == "int" then
            return tostring(math.round(v))
        else
            return string.format("%.3f", v)
        end
    end

    local function normalize(v)
        if mode == "int" then
            return math.round(v)
        else
            return round3(v)
        end
    end

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40,40,40)
    container.Active = true
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45,45,45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0,150,255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Transparency = 1
    flashBorder.Parent = container

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,-16,0,10)
    nameLabel.Position = UDim2.new(0,8,0,2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = Name
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.Font = FontGUI
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextScaled = true
    nameLabel.ZIndex = 20001
    nameLabel.Parent = container
    createTextSizeConstraint(nameLabel,14,16)

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1,-16,0,14)
    sliderBar.Position = UDim2.new(0,8,0,18)
    sliderBar.BackgroundColor3 = Color3.fromRGB(20,40,120)
    sliderBar.BorderSizePixel = 0
    sliderBar.ZIndex = 20001
    sliderBar.Parent = container
    createUICorner(sliderBar)
    createUIStroke(sliderBar,1,Color3.fromRGB(0,165,255))

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(150,230,250)
    fill.BorderSizePixel = 0
    fill.ZIndex = 20002
    fill.Parent = sliderBar
    createUICorner(fill)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0,80,1,0)
    valueLabel.Position = UDim2.new(0,4,0,-1)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(255,255,255)
    valueLabel.Font = FontGUI
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.TextScaled = true
    valueLabel.ZIndex = 20003
    valueLabel.Parent = sliderBar
    createTextSizeConstraint(valueLabel,14,16)
    
    -- callback
    local dragInput
    local targetValue = default
    local smoothValue = default
    local fadeTween
    local lastValue = nil

    local function updateVisual(v)
        local rel = (v-minValue)/(maxValue-minValue)
        fill.Size = UDim2.new(0, rel*sliderBar.AbsoluteSize.X,1,0)
        valueLabel.Text = formatValue(v)
    end

    local function updateTarget(x)
        local barX = sliderBar.AbsolutePosition.X
        local barW = sliderBar.AbsoluteSize.X
        local rel = math.clamp((x-barX)/barW,0,1)

        targetValue = normalize(minValue + rel*(maxValue-minValue))
    end

    RunService.RenderStepped:Connect(function()

        smoothValue += (targetValue-smoothValue)*0.35
        local display = normalize(smoothValue)

        updateVisual(display)

        if lastValue ~= display then
            lastValue = display
            callback(display)
        end

        if dragInput or math.abs(targetValue-smoothValue)>0.6 then

            TweenService:Create(mainBorder,
                TweenInfo.new(0.1),
                {Color=Color3.fromRGB(0,150,255)}
            ):Play()

            if fadeTween then fadeTween:Cancel() end
            flashBorder.Transparency = 0

        else
            fadeTween = TweenService:Create(
                flashBorder,
                TweenInfo.new(0.6),
                {Transparency=1}
            )
            fadeTween:Play()

            TweenService:Create(mainBorder,
                TweenInfo.new(0.6),
                {Color=Color3.fromRGB(45,45,45)}
            ):Play()
        end
    end)

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
            updateTarget(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput then
            updateTarget(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == dragInput then
            dragInput = nil
        end
    end)

    updateVisual(default)
    lastValue = normalize(default)
    callback(lastValue)
    
    --[[
    • API เรียกใช้ภายนอก (createToggleSlider)
    - SetValue() :: ตั้วค่า Value
    - GetValue :: ขอค่า Value
    ]]
    
    return {
    SetValue = function(v)
        value = math.clamp(v, min, max)
        updateUI()
    end,

    GetValue = function()
        return value
    end
}
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับ Dropdown
function ContainerContent:createToggleDropdown(config)
    -- config
    local Parent = config.Parent
    local Name = config.Name or ""
    local Description = config.Description or ""
    local DefaultText = config.DefaultText or "Select..."
    local mode = config.mode or "Single"

    if mode ~= "Single" and mode ~= "Multi" then
    warn("[Dropdown] Invalid mode:", mode, "-> fallback to Single")
    mode = "Single"
end

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40,40,40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    -- borders
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45,45,45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0,150,255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Enabled = false
    flashBorder.Parent = container

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 0, 15)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = FontGUI
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true -- ปรับขนาดอัตโนมัติ
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 14, 16)

    local labelP = Instance.new("TextLabel")
    labelP.Size = UDim2.new(1, -150, 0, 15)
    labelP.Position = UDim2.new(0, 8, 0, 18)
    labelP.BackgroundTransparency = 1
    labelP.Text = Description
    labelP.TextColor3 = Color3.fromRGB(100, 100, 100)
    labelP.Font = FontGUI
    labelP.TextSize = 14
    labelP.TextXAlignment = Enum.TextXAlignment.Left
    labelP.TextScaled = true -- ปรับขนาดอัตโนมัติ
    labelP.ZIndex = 20001
    labelP.Parent = container
    createTextSizeConstraint(labelP, 12, 14)

    local inputBoxFrame = Instance.new("Frame")
    inputBoxFrame.Size = UDim2.new(0.45, -20, 0.8, 0)
    inputBoxFrame.Position = UDim2.new(0.55, 15, 0.1, 0)
    inputBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    inputBoxFrame.ZIndex = 20001
    inputBoxFrame.Parent = container
    createUICorner(inputBoxFrame)
    createUIStroke(inputBoxFrame, 1, Color3.fromRGB(45,45,45))

    -- inputBox
    local inputBox = Instance.new("TextLabel")
    inputBox.Size = UDim2.new(0.45, -20, 0.8, 0)
    inputBox.Position = UDim2.new(0.55, 15, 0.1, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    inputBox.BackgroundTransparency = 0
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Text = DefaultText
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.Font = FontGUI
    inputBox.TextSize = 16
    inputBox.TextScaled = true -- ปรับขนาดอัตโนมัติ
    inputBox.ZIndex = 20002
    inputBox.Parent = container
    createUICorner(inputBox)
    createTextSizeConstraint(inputBox, 10, 16)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, -20, 0.8, 0)
    btn.Position = UDim2.new(0.55, 15, 0.1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 20004
    btn.Parent = container
    createUICorner(btn)

    -- panel container
    local containerDropdown = Instance.new("Frame")
    containerDropdown.Size = UDim2.new(0,300,0,240)
    containerDropdown.AnchorPoint = Vector2.new(0.5,0.5)
    containerDropdown.Position = UDim2.new(0.5,0,0.5,0)
    containerDropdown.BackgroundColor3 = Color3.fromRGB(30,30,30)
    containerDropdown.Visible = false
    containerDropdown.Active = true
    containerDropdown.ZIndex = 30000
    containerDropdown.Parent = MainFrame
    createUICorner(containerDropdown)
    createUIStroke(containerDropdown, 2, Color3.fromRGB(50,50,50))

    -- overlay (dimming)
    local ScreenDrunk = Instance.new("Frame")
    ScreenDrunk.Size = UDim2.new(1,0,1,0)
    ScreenDrunk.AnchorPoint = Vector2.new(0.5,0.5)
    ScreenDrunk.Position = UDim2.new(0.5,0,0.5,0)
    ScreenDrunk.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ScreenDrunk.BackgroundTransparency = 0.6
    ScreenDrunk.Parent = MainFrame
    ScreenDrunk.Visible = false
    ScreenDrunk.Active = true
    ScreenDrunk.ZIndex = 20020
    createUICorner(ScreenDrunk)

    local MaintitleLabel = Instance.new("TextLabel")
    MaintitleLabel.Size = UDim2.new(1, -150, 0, 25)
    MaintitleLabel.Position = UDim2.new(0, 5, 0, 5)
    MaintitleLabel.BackgroundTransparency = 1
    MaintitleLabel.Text = Name
    MaintitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaintitleLabel.Font = FontGUI
    MaintitleLabel.TextSize = 18
    MaintitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    MaintitleLabel.TextScaled = true -- ปรับขนาดอัตโนมัติ
    MaintitleLabel.ZIndex = 30001
    MaintitleLabel.Parent = containerDropdown
    createTextSizeConstraint(MaintitleLabel, 16, 18)

    -- Main Separator
    local Mainseparator = Instance.new("Frame")
    Mainseparator.Size = UDim2.new(1, 0, 0, 2)
    Mainseparator.Position = UDim2.new(0, 0, 0, 35)
    Mainseparator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Mainseparator.BorderSizePixel = 0
    Mainseparator.ZIndex = 30002
    Mainseparator.Parent = containerDropdown

    -- Main SeparatorButton
    local MainSeparatorButton = Instance.new("Frame")
    MainSeparatorButton.Size = UDim2.new(0, 2, 1, 0)
    MainSeparatorButton.Position = UDim2.new(1, -35, 0, 0)
    MainSeparatorButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainSeparatorButton.BorderSizePixel = 0
    MainSeparatorButton.ZIndex = 30002
    MainSeparatorButton.Parent = containerDropdown

    -- Main Close Button
    local MaincloseButton = Instance.new("TextButton")
    MaincloseButton.Size = UDim2.new(0, 25, 0, 25)
    MaincloseButton.Position = UDim2.new(1, -30, 0, 4)
    MaincloseButton.BackgroundTransparency = 1
    MaincloseButton.Text = "x"
    MaincloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaincloseButton.TextYAlignment = Enum.TextYAlignment.Center
    MaincloseButton.Font = FontGUI
    MaincloseButton.TextSize = 20
    MaincloseButton.ZIndex = 30001
    MaincloseButton.Parent = containerDropdown

    -- Search Box
    local searchBoxFrame = Instance.new("Frame")
    searchBoxFrame.Size = UDim2.new(0, 90, 0, 22)
    searchBoxFrame.Position = UDim2.new(1, -135, 0, 6)
    searchBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    searchBoxFrame.ZIndex = 30001
    searchBoxFrame.Parent = containerDropdown
    createUICorner(searchBoxFrame)
    createUIStroke(searchBoxFrame, 1, Color3.fromRGB(45, 45, 45))

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0, 90, 0, 22)
    searchBox.AnchorPoint = Vector2.new(0.5,0.5)
    searchBox.Position = UDim2.new(0, 45, 0, 11)
    searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    searchBox.BackgroundTransparency = 0
    searchBox.PlaceholderText = "Search..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextXAlignment = Enum.TextXAlignment.Center
    searchBox.Font = FontGUI
    searchBox.TextSize = 14
    searchBox.TextScaled = true -- ปรับขนาดอัตโนมัติ
    searchBox.ClearTextOnFocus = true
    searchBox.TextWrapped = true
    searchBox.ZIndex = 30002
    searchBox.Parent = searchBoxFrame
    createUICorner(searchBox)
    createTextSizeConstraint(searchBox, 12, 14)
    
    local OptionsArea = Instance.new("ScrollingFrame")
    OptionsArea.Size = UDim2.new(1, 0, 1, -37.8)
    OptionsArea.Position = UDim2.new(0, 0, 0, 37.8)
    OptionsArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OptionsArea.BackgroundTransparency = 0
    OptionsArea.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    OptionsArea.ScrollBarThickness = 0
    OptionsArea.ScrollBarImageColor3 = Color3.fromRGB(0,165,255)
    OptionsArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsArea.ScrollBarImageTransparency = 1
    OptionsArea.AutomaticCanvasSize = Enum.AutomaticSize.None
    OptionsArea.ZIndex = 30003
    OptionsArea.Active = true
    OptionsArea.ElasticBehavior = Enum.ElasticBehavior.Never
    OptionsArea.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    OptionsArea.Parent = containerDropdown
    createUICorner(OptionsArea)
    createListLayout(OptionsArea, 8, 6, 2, 0)
    
    --// Dropdown API Sys
    local api = {}  -- เก็บ API functions
    local optionButtons = {}
    
    -- สถานะการเลือกภายใน
    api._selection = nil
    api._multiSelection = {}
    api._mode = mode
    
    -- ตัวแปรสำหรับการค้นหา
    local currentSearchText = ""
    
    -- ฟังก์ชันสำหรับกรองตัวเลือกตามข้อความค้นหา
    local function filterOptions()
        local searchLower = currentSearchText:lower()
        
        for value, buttonData in pairs(optionButtons) do
            if buttonData and buttonData.Frame then
                local valueLower = value:lower()
                local shouldShow = searchLower == "" or valueLower:find(searchLower, 1, true) ~= nil
                buttonData.Frame.Visible = shouldShow
            end
        end
    end
    
    -- ตั้งค่า event สำหรับกล่องค้นหา
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        currentSearchText = searchBox.Text
        filterOptions()
    end)
    
    -- ฟังก์ชันช่วยเหลือสำหรับคืนค่าการเลือก
    local function _restoreSelection()
        if api._mode == "Single" and api._selection then
            -- ค้นหาปุ่มที่ตรงกับค่าที่เลือกไว้
            local buttonData = optionButtons[api._selection]
            if buttonData then
                TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                    Color = Color3.fromRGB(0,150,255)
                }):Play()
                buttonData.IsSelected = true
                inputBox.Text = api._selection
            else
                inputBox.Text = DefaultText
            end
        elseif api._mode == "Multi" then
            local selectedNames = {}
            for value, selected in pairs(api._multiSelection) do
                if selected then
                    local buttonData = optionButtons[value]
                    if buttonData then
                        TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                            Color = Color3.fromRGB(0,150,255)
                        }):Play()
                        buttonData.IsSelected = true
                        table.insert(selectedNames, value)
                    end
                end
            end
            inputBox.Text = (#selectedNames > 0) and table.concat(selectedNames, ", ") or DefaultText
        else
            inputBox.Text = DefaultText
        end
    end
    
    -- Option Button System
    local function createOptionButton(text)
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(0, 270, 0, 30)
        btnFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btnFrame.ZIndex = 30004
        btnFrame.Parent = OptionsArea
        createUICorner(btnFrame)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(45,45,45)
        stroke.Thickness = 2
        stroke.Parent = btnFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Font = FontGUI
        label.TextSize = 16
        label.TextScaled = true
        label.ZIndex = 30005
        label.Parent = btnFrame
        createTextSizeConstraint(label, 14, 16)

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1,0,1,0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.ZIndex = 30006
        button.Parent = btnFrame
        
        local buttonData = {
            Frame = btnFrame,
            Stroke = stroke,
            Label = label,
            Value = text,
            IsSelected = false
        }
        
        if api._mode == "Single" and api._selection == text then
            buttonData.IsSelected = true
            TweenService:Create(stroke, TweenInfo.new(0.15), {
                Color = Color3.fromRGB(0,150,255)
            }):Play()
        elseif api._mode == "Multi" and api._multiSelection[text] then
            buttonData.IsSelected = true
            TweenService:Create(stroke, TweenInfo.new(0.15), {
                Color = Color3.fromRGB(0,150,255)
            }):Play()
        end
        
        button.MouseButton1Click:Connect(function()
            if api._mode == "Single" then
                -- ถ้าปุ่มนี้ถูกเลือกอยู่แล้ว (กดซ้ำ) ให้ยกเลิกการเลือก
                if api._selection == text then
                    -- ยกเลิกการเลือก
                    TweenService:Create(stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(45,45,45)
                    }):Play()
                    api._selection = nil
                    buttonData.IsSelected = false
                    inputBox.Text = DefaultText
                else
                    -- reset ปุ่มเก่า
                    if api._selection then
                        local oldButtonData = optionButtons[api._selection]
                        if oldButtonData then
                            TweenService:Create(oldButtonData.Stroke, TweenInfo.new(0.15), {
                                Color = Color3.fromRGB(45,45,45)
                            }):Play()
                            oldButtonData.IsSelected = false
                        end
                    end

                    api._selection = text
                    buttonData.IsSelected = true
                    TweenService:Create(stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(0,150,255)
                    }):Play()
                    inputBox.Text = text
                end

            elseif api._mode == "Multi" then
                -- ใช้ value เป็น key
                if api._multiSelection[text] then
                    -- ยกเลิกเลือก (กดซ้ำ)
                    api._multiSelection[text] = nil
                    buttonData.IsSelected = false
                    TweenService:Create(stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(45,45,45)
                    }):Play()
                else
                    -- เลือก
                    api._multiSelection[text] = true
                    buttonData.IsSelected = true
                    TweenService:Create(stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(0,150,255)
                    }):Play()
                end

                -- update display text
                local names = {}
                for value, selected in pairs(api._multiSelection) do
                    if selected then
                        table.insert(names, value)
                    end
                end
                inputBox.Text = (#names > 0) and table.concat(names, ", ") or DefaultText
            end
        end)

        return buttonData
    end
    
    -- เพิ่มปุ่ม
    function api:Add(text)
        local buttonData = createOptionButton(text)
        optionButtons[text] = buttonData
        
        -- กรองตามข้อความค้นหาปัจจุบัน
        local searchLower = currentSearchText:lower()
        local valueLower = text:lower()
        local shouldShow = searchLower == "" or valueLower:find(searchLower, 1, true) ~= nil
        buttonData.Frame.Visible = shouldShow
        
        -- อัพเดทการแสดงผลถ้ามีการเลือกอยู่
        _restoreSelection()
        
        return buttonData
    end

    -- เพิ่มหลายปุ่ม
    function api:AddList(list)
        -- เก็บค่าที่เลือกไว้ก่อนเพิ่มปุ่มใหม่
        local oldSelection = api._selection
        local oldMultiSelection = {}
        for k, v in pairs(api._multiSelection) do
            oldMultiSelection[k] = v
        end
        
        -- ล้างเฉพาะ optionButtons
        for value, btnData in pairs(optionButtons) do
            btnData.Frame:Destroy()
        end
        optionButtons = {}
        
        -- เพิ่มปุ่มใหม่ทั้งหมด
        for _, v in ipairs(list) do
            self:Add(v)
        end
        
        -- คืนค่าที่เลือกไว้เดิม
        if api._mode == "Single" then
            if oldSelection and optionButtons[oldSelection] then
                self:Set(oldSelection)
            else
                api._selection = nil
                inputBox.Text = DefaultText
            end
        elseif api._mode == "Multi" then
            api._multiSelection = {}
            for value, selected in pairs(oldMultiSelection) do
                if selected and optionButtons[value] then
                    self:Set(value)
                end
            end
        end
    end

    -- ล้างทั้งหมด
    function api:Clear()
        for value, btnData in pairs(optionButtons) do
            btnData.Frame:Destroy()
        end
        optionButtons = {}
        
        -- ไม่ล้างค่าที่เลือกภายใน
        -- ค่าเลือกจะยังคงอยู่ และจะถูกคืนค่ากลับมาเมื่อเพิ่มตัวเลือกใหม่
        
        -- รีเฟรช inputBox
        _restoreSelection()
    end

    -- เลือกจากภายนอก
    function api:Set(value)
        if api._mode == "Single" then
            -- ถ้ากำลังเลือกค่าเดิมอยู่แล้ว (กดซ้ำ) ให้ยกเลิก
            if api._selection == value then
                local buttonData = optionButtons[value]
                if buttonData then
                    TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(45,45,45)
                    }):Play()
                    buttonData.IsSelected = false
                end
                api._selection = nil
                inputBox.Text = DefaultText
                return
            end
            
            -- reset ปุ่มเก่า (ถ้ามี)
            if api._selection then
                local oldButtonData = optionButtons[api._selection]
                if oldButtonData then
                    TweenService:Create(oldButtonData.Stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(45,45,45)
                    }):Play()
                    oldButtonData.IsSelected = false
                end
            end

            -- เลือกปุ่มใหม่
            local buttonData = optionButtons[value]
            if buttonData then
                api._selection = value
                buttonData.IsSelected = true
                TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                    Color = Color3.fromRGB(0,150,255)
                }):Play()
                inputBox.Text = value
            end
            
        elseif api._mode == "Multi" then
            local buttonData = optionButtons[value]
            if buttonData then
                if api._multiSelection[value] then
                    -- ถ้ามีอยู่แล้ว (กดซ้ำ) ให้ยกเลิก
                    api._multiSelection[value] = nil
                    buttonData.IsSelected = false
                    TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(45,45,45)
                    }):Play()
                else
                    -- เลือกใหม่
                    api._multiSelection[value] = true
                    buttonData.IsSelected = true
                    TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(0,150,255)
                    }):Play()
                end
                
                -- update display text
                local names = {}
                for val, selected in pairs(api._multiSelection) do
                    if selected then
                        table.insert(names, val)
                    end
                end
                inputBox.Text = (#names > 0) and table.concat(names, ", ") or DefaultText
            end
        end
    end

    -- เลือกหลายค่าจากภายนอก
    function api:SetMultiple(values)
        if api._mode ~= "Multi" then
            warn("SetMultiple ทำงานได้เฉพาะในโหมด Multi เท่านั้น")
            return
        end
        
        -- ล้างการเลือกเก่าทั้งหมด
        for value, selected in pairs(api._multiSelection) do
            if selected then
                local buttonData = optionButtons[value]
                if buttonData then
                    TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                        Color = Color3.fromRGB(45,45,45)
                    }):Play()
                    buttonData.IsSelected = false
                end
            end
        end
        
        api._multiSelection = {}
        
        -- เลือกค่าทั้งหมดที่กำหนด
        for _, value in ipairs(values) do
            local buttonData = optionButtons[value]
            if buttonData then
                api._multiSelection[value] = true
                buttonData.IsSelected = true
                TweenService:Create(buttonData.Stroke, TweenInfo.new(0.15), {
                    Color = Color3.fromRGB(0,150,255)
                }):Play()
            end
        end
        
        -- update display text
        local names = {}
        for value, selected in pairs(api._multiSelection) do
            if selected then
                table.insert(names, value)
            end
        end
        inputBox.Text = (#names > 0) and table.concat(names, ", ") or DefaultText
    end

    -- ตั้งโหมด
    function api:SetMode(mode)
        if mode == "Single" or mode == "Multi" then
            -- ล้างการเลือกเก่า
            self:ClearSelection()
            api._mode = mode
        end
    end

    -- ล้างการเลือก (เฉพาะการเลือก ไม่ล้างตัวเลือก)
    function api:ClearSelection()
        if api._mode == "Single" and api._selection then
            local buttonData = optionButtons[api._selection]
            if buttonData then
                TweenService:Create(buttonData.Stroke, TweenInfo.new(0.1), {
                    Color = Color3.fromRGB(45,45,45)
                }):Play()
                buttonData.IsSelected = false
            end
            api._selection = nil
        elseif api._mode == "Multi" then
            for value, selected in pairs(api._multiSelection) do
                if selected then
                    local buttonData = optionButtons[value]
                    if buttonData then
                        TweenService:Create(buttonData.Stroke, TweenInfo.new(0.1), {
                            Color = Color3.fromRGB(45,45,45)
                        }):Play()
                        buttonData.IsSelected = false
                    end
                end
            end
            api._multiSelection = {}
        end

        inputBox.Text = DefaultText
    end

    -- ดึงค่าที่เลือก
    function api:Get()
        if api._mode == "Single" then
            return api._selection
        else
            local result = {}
            for value, selected in pairs(api._multiSelection) do
                if selected then
                    table.insert(result, value)
                end
            end
            return result
        end
    end

-- ฟังก์ชันรีเฟรชสถานะปุ่มทั้งหมด (ใช้เมื่อปิด/เปิด api)
    function api:RefreshButtonStates()
        if api._mode == "Single" and api._selection then
            local buttonData = optionButtons[api._selection]
            if buttonData then
                TweenService:Create(buttonData.Stroke, TweenInfo.new(0.1), {
                    Color = Color3.fromRGB(0,150,255)
                }):Play()
                buttonData.IsSelected = true
            end
        elseif api._mode == "Multi" then
            for value, selected in pairs(api._multiSelection) do
                if selected then
                    local buttonData = optionButtons[value]
                    if buttonData then
                        TweenService:Create(buttonData.Stroke, TweenInfo.new(0.1), {
                            Color = Color3.fromRGB(0,150,255)
                        }):Play()
                        buttonData.IsSelected = true
                    end
                end
            end
        end
    end

    -- Open / Close behaviour
    btn.MouseButton1Click:Connect(function()
        containerDropdown.Visible = true
        ScreenDrunk.Visible = true
        api:RefreshButtonStates()

        TweenService:Create(mainBorder, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(0,150,255)
        }):Play()
        task.delay(0.6, function()
            TweenService:Create(mainBorder, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
                Color = Color3.fromRGB(45,45,45)
            }):Play()
        end)

        flashBorder.Enabled = true
        flashBorder.Transparency = 0
        TweenService:Create(flashBorder, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
            Transparency = 1
        }):Play()
        
    end)

    MaincloseButton.MouseButton1Click:Connect(function()
        -- ปิด dropdown และล้างกล่องค้นหา
        containerDropdown.Visible = false
        ScreenDrunk.Visible = false
    end)

    --[[
    • API เรียกใช้ภายนอก (createToggleDropdown)
    - api:Add("text") :: เพิ่มตัวเลือกใหม่ 1 รายการ
    - api:AddList({"list"}) :: เพิ่มตัวเลือกหลายรายการพร้อมกัน โดยจะล้างตัวเลือกเดิมทั้งหมดก่อน แล้วเพิ่มรายการใหม่
    - api:Clear() :: ล้างตัวเลือกทั้งหมดออกจาก dropdown (ลบปุ่มตัวเลือกทั้งหมด)
    - api:Set("value') :: ใช้เลือกค่าจากภายนอก (หรือกดซ้ำเพื่อยกเลิกการเลือกในโหมด Single)
    - api:SetMultiple({"values"}) :: ใช้เลือกหลายค่าในโหมด Multi เท่านั้น (เลือกทีละหลายรายการ พร้อมกัน)
    - api:SetMode("mode") :: สลับโหมดการทำงานระหว่างเลือกเดี่ยวและเลือกหลายค่า เมื่อเปลี่ยนโหมดจะล้างการเลือกทั้งหมดอัตโนมัติ
    - api:ClearSelection() :: ล้างเฉพาะค่าที่เลือกไว้ (ไม่ล้างตัวเลือกในรายการ)
    - api:Get() :: ดึงค่าที่เลือกอยู่ในปัจจุบัน
    - api:RefreshButtonStates() :: รีเฟรชสถานะ visual ของปุ่มทั้งหมดให้ตรงกับค่าที่เลือกอยู่ (ใช้เมื่อเปิด dropdown ใหม่ หรือหลัง UI เปลี่ยนแปลง)
    ]]

    return api
end

--// Function: ฟังก์ชัน สร้างแผงสำหรับปรับสีได้
function ContainerContent:createToggleColorPicker(config)
    -- config
    local Parent = config.Parent
    local Name = config.Name or ""
    local Description = config.Description or ""

    -- รองรับหลายรูปแบบ defaultColor
    local defaultColor

    if typeof(config.defaultColor) == "Color3" then
        defaultColor = config.defaultColor

    elseif typeof(config.defaultColor) == "table" then
        local r = config.defaultColor[1] or 0
        local g = config.defaultColor[2] or 0
        local b = config.defaultColor[3] or 0
        defaultColor = Color3.fromRGB(r,g,b)

    else
        defaultColor = Color3.fromRGB(0,150,255)
    end

    -- UI
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -18, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(40,40,40)
    container.ZIndex = 20000
    container.Parent = Tabpage
    createUICorner(container)

    -- borders
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(45,45,45)
    mainBorder.Thickness = 2
    mainBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainBorder.Parent = container

    local flashBorder = Instance.new("UIStroke")
    flashBorder.Color = Color3.fromRGB(0,150,255)
    flashBorder.Thickness = 2
    flashBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    flashBorder.Enabled = false
    flashBorder.Parent = container

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -150, 0, 15)  
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = FontGUI
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true -- ปรับขนาดอัตโนมัติ
    label.ZIndex = 20001
    label.Parent = container
    createTextSizeConstraint(label, 14, 16)
    
    local labelP = Instance.new("TextLabel")
    labelP.Size = UDim2.new(1, -150, 0, 15)  
    labelP.Position = UDim2.new(0, 8, 0, 18)
    labelP.BackgroundTransparency = 1
    labelP.Text = Description
    labelP.TextColor3 = Color3.fromRGB(100, 100, 100)
    labelP.Font = FontGUI
    labelP.TextSize = 14
    labelP.TextXAlignment = Enum.TextXAlignment.Left
    labelP.TextScaled = true -- ปรับขนาดอัตโนมัติ
    labelP.ZIndex = 20001
    labelP.Parent = container
    createTextSizeConstraint(labelP, 12, 14)

    -- btn (คืนค่าเป็น btn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, -20, 0.8, 0)
    btn.Position = UDim2.new(0.55, 15, 0.1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 20001
    btn.Parent = container
    createUICorner(btn)

    -- status light
    local statusLight = Instance.new("Frame")
    statusLight.Size = UDim2.new(0.45, -105, 0.8, 0)
    statusLight.Position = UDim2.new(0.55, 100, 0.1, 0)
    statusLight.BackgroundColor3 = defaultColor
    statusLight.BackgroundTransparency = 0
    statusLight.BorderSizePixel = 0
    statusLight.ZIndex = 20002
    statusLight.Parent = container
    createUICorner(statusLight)
    createUIStroke(statusLight, 1, Color3.fromRGB(45,45,45))

    -- panel container
    local containerRGB = Instance.new("Frame")
    containerRGB.Size = UDim2.new(0,300,0,240)
    containerRGB.AnchorPoint = Vector2.new(0.5,0.5)
    containerRGB.Position = UDim2.new(0.5,0,0.5,0)
    containerRGB.BackgroundColor3 = Color3.fromRGB(30,30,30)
    containerRGB.Visible = false
    containerRGB.Active = true
    containerRGB.ZIndex = 30000
    containerRGB.Parent = MainFrame
    createUICorner(containerRGB)
    createUIStroke(containerRGB, 2, Color3.fromRGB(50,50,50))

    -- input boxes R G B  
    local inputBoxFrameR = Instance.new("Frame")  
    inputBoxFrameR.Size = UDim2.new(0,80,0,30)  
    inputBoxFrameR.AnchorPoint = Vector2.new(0.5,0.5)  
    inputBoxFrameR.Position = UDim2.new(0,250,0,25)  
    inputBoxFrameR.BackgroundColor3 = Color3.fromRGB(35,35,35)  
    inputBoxFrameR.ZIndex = 30001  
    inputBoxFrameR.Parent = containerRGB  
    createUICorner(inputBoxFrameR)  
    createUIStroke(inputBoxFrameR, 2, Color3.fromRGB(45,45,45))  
  
    local inputBoxFrameG = Instance.new("Frame")  
    inputBoxFrameG.Size = UDim2.new(0,80,0,30)  
    inputBoxFrameG.AnchorPoint = Vector2.new(0.5,0.5)  
    inputBoxFrameG.Position = UDim2.new(0,250,0,62)  
    inputBoxFrameG.BackgroundColor3 = Color3.fromRGB(35,35,35)  
    inputBoxFrameG.ZIndex = 30001  
    inputBoxFrameG.Parent = containerRGB  
    createUICorner(inputBoxFrameG)  
    createUIStroke(inputBoxFrameG, 2, Color3.fromRGB(45,45,45))  
  
    local inputBoxFrameB = Instance.new("Frame")  
    inputBoxFrameB.Size = UDim2.new(0,80,0,30)  
    inputBoxFrameB.AnchorPoint = Vector2.new(0.5,0.5)  
    inputBoxFrameB.Position = UDim2.new(0,250,0,100)  
    inputBoxFrameB.BackgroundColor3 = Color3.fromRGB(35,35,35)  
    inputBoxFrameB.ZIndex = 30001  
    inputBoxFrameB.Parent = containerRGB  
    createUICorner(inputBoxFrameB)  
    createUIStroke(inputBoxFrameB, 2, Color3.fromRGB(45,45,45))  
  
    local inputBoxR = Instance.new("TextBox")  
    inputBoxR.Size = UDim2.new(0,80,0,30)  
    inputBoxR.AnchorPoint = Vector2.new(0.5,0.5)  
    inputBoxR.Position = UDim2.new(0,40,0,15)  
    inputBoxR.BackgroundTransparency = 1  
    inputBoxR.TextColor3 = Color3.fromRGB(255,255,255)  
    inputBoxR.PlaceholderText = "0 to 255"  
    inputBoxR.Text = "0"  
    inputBoxR.TextXAlignment = Enum.TextXAlignment.Center  
    inputBoxR.Font = FontGUI  
    inputBoxR.TextSize = 16  
    inputBoxR.TextScaled = true -- ปรับขนาดอัตโนมัติ
    inputBoxR.ZIndex = 30002  
    inputBoxR.Parent = inputBoxFrameR  
    createUICorner(inputBoxR)  
    createTextSizeConstraint(inputBoxR, 14, 16)

    local inputBoxG = inputBoxR:Clone()  
    inputBoxG.Text = "150"  
    inputBoxG.Parent = inputBoxFrameG  
    createUICorner(inputBoxG)  
    createTextSizeConstraint(inputBoxG, 14, 16)

    local inputBoxB = inputBoxR:Clone()  
    inputBoxB.Text = "255"  
    inputBoxB.Parent = inputBoxFrameB  
    createUICorner(inputBoxB)  
    createTextSizeConstraint(inputBoxB, 14, 16)

    -- FrameBarRGB (preview area)
    local FrameBarRGB = Instance.new("Frame")
    FrameBarRGB.Size = UDim2.new(0,190,0,106)
    FrameBarRGB.AnchorPoint = Vector2.new(0.5,0.5)
    FrameBarRGB.Position = UDim2.new(0,105,0,63)
    FrameBarRGB.BackgroundColor3 = defaultColor
    FrameBarRGB.ZIndex = 30001
    FrameBarRGB.Parent = containerRGB
    createUICorner(FrameBarRGB)
    createUIStroke(FrameBarRGB, 2, Color3.fromRGB(45,45,45))

    -- sliderHue
    local sliderBarRGB = Instance.new("Frame")
    sliderBarRGB.Size = UDim2.new(0,280,0,14)
    sliderBarRGB.AnchorPoint = Vector2.new(0.5,0.5)
    sliderBarRGB.Position = UDim2.new(0,150,0,135)
    sliderBarRGB.BackgroundTransparency = 0
    sliderBarRGB.ZIndex = 30001
    sliderBarRGB.Parent = containerRGB
    createUICorner(sliderBarRGB)
    createUIStroke(sliderBarRGB, 2, Color3.fromRGB(45,45,45))

    -- sliderAlpha (transparency)
    local sliderBarBT = Instance.new("Frame")
    sliderBarBT.Size = UDim2.new(0,280,0,14)
    sliderBarBT.AnchorPoint = Vector2.new(0.5,0.5)
    sliderBarBT.Position = UDim2.new(0,150,0,165)
    sliderBarBT.BackgroundTransparency = 0
    sliderBarBT.ZIndex = 30001
    sliderBarBT.Parent = containerRGB
    createUICorner(sliderBarBT)
    createUIStroke(sliderBarBT, 2, Color3.fromRGB(45,45,45))

    -- overlay (dimming)
    local ScreenDrunk = Instance.new("Frame")
    ScreenDrunk.Size = UDim2.new(1,0,1,0)
    ScreenDrunk.AnchorPoint = Vector2.new(0.5,0.5)
    ScreenDrunk.Position = UDim2.new(0.5,0,0.5,0)
    ScreenDrunk.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ScreenDrunk.BackgroundTransparency = 0.6
    ScreenDrunk.Parent = MainFrame
    ScreenDrunk.Visible = false
    ScreenDrunk.Active = true
    ScreenDrunk.ZIndex = 20020
    createUICorner(ScreenDrunk)

    -- Separator
    local Mainseparator = Instance.new("Frame")
    Mainseparator.Size = UDim2.new(1, 0, 0, 2)
    Mainseparator.Position = UDim2.new(0, 0, 0, 183)
    Mainseparator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Mainseparator.BorderSizePixel = 0
    Mainseparator.ZIndex = 30001
    Mainseparator.Parent = containerRGB

    -- Done/Cancel
    local RGBDoneButtonFrame = Instance.new("Frame")
    RGBDoneButtonFrame.Size = UDim2.new(0,100,0,30)
    RGBDoneButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
    RGBDoneButtonFrame.Position = UDim2.new(0,75,0,213)
    RGBDoneButtonFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    RGBDoneButtonFrame.ZIndex = 30001
    RGBDoneButtonFrame.Parent = containerRGB
    createUICorner(RGBDoneButtonFrame)
    createUIStroke(RGBDoneButtonFrame, 2, Color3.fromRGB(45,45,45))

    local RGBDoneButton = Instance.new("TextButton")
    RGBDoneButton.Size = UDim2.new(0,100,0,30)
    RGBDoneButton.AnchorPoint = Vector2.new(0.5,0.5)
    RGBDoneButton.Position = UDim2.new(0,50,0,15)
    RGBDoneButton.BackgroundTransparency = 1
    RGBDoneButton.Text = "Done"
    RGBDoneButton.TextColor3 = Color3.fromRGB(255,255,255)
    RGBDoneButton.Font = FontGUI
    RGBDoneButton.TextSize = 16
    RGBDoneButton.ZIndex = 30002
    RGBDoneButton.Parent = RGBDoneButtonFrame
    createUICorner(RGBDoneButton)

    local RGBCancelButtonFrame = Instance.new("Frame")
    RGBCancelButtonFrame.Size = UDim2.new(0,100,0,30)
    RGBCancelButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
    RGBCancelButtonFrame.Position = UDim2.new(0,225,0,213)
    RGBCancelButtonFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    RGBCancelButtonFrame.ZIndex = 30002
    RGBCancelButtonFrame.Parent = containerRGB
    createUICorner(RGBCancelButtonFrame)
    createUIStroke(RGBCancelButtonFrame, 2, Color3.fromRGB(45,45,45))

    local RGBCancelButton = Instance.new("TextButton")
    RGBCancelButton.Size = UDim2.new(0,100,0,30)
    RGBCancelButton.AnchorPoint = Vector2.new(0.5,0.5)
    RGBCancelButton.Position = UDim2.new(0,50,0,15)
    RGBCancelButton.BackgroundTransparency = 1
    RGBCancelButton.Text = "Cancel"
    RGBCancelButton.TextColor3 = Color3.fromRGB(255,255,255)
    RGBCancelButton.Font = FontGUI
    RGBCancelButton.TextSize = 16
    RGBCancelButton.ZIndex = 30002
    RGBCancelButton.Parent = RGBCancelButtonFrame
    createUICorner(RGBCancelButton)
    
    -- helper functions
    local function color3ToRGBInts(c)
    return math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)
    end
    local function rgbIntsToColor3(r,g,b)
    return Color3.fromRGB(math.clamp(math.floor(r+0.5),0,255), math.clamp(math.floor(g+0.5),0,255), math.clamp(math.floor(b+0.5),0,255))
    end
    local function color3ToHSV(c)
    return Color3.toHSV(c)
    end
    local function safeParseInt(str)
    local n = tonumber(str)
    if not n then return nil end
    return math.floor(n + 0.5)
    end

    -- Hue gradient (use limited keypoints, HSV-based)
    local sRGB_grad = Instance.new("UIGradient")
sRGB_grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0.00,1,1)),
    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1,1)),
    ColorSequenceKeypoint.new(0.34, Color3.fromHSV(0.34,1,1)),
    ColorSequenceKeypoint.new(0.51, Color3.fromHSV(0.51,1,1)),
    ColorSequenceKeypoint.new(0.68, Color3.fromHSV(0.68,1,1)),
    ColorSequenceKeypoint.new(0.85, Color3.fromHSV(0.85,1,1)),
    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(0.00,1,1)),
}
    sRGB_grad.Parent = sliderBarRGB

    local sBT_grad = Instance.new("UIGradient")
    sBT_grad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)) }
    sBT_grad.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }
    sBT_grad.Parent = sliderBarBT

-- knob maker
local function makeKnob(parent)
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0,13,0,13)
    k.AnchorPoint = Vector2.new(0.5,0.5)
    k.Position = UDim2.new(0,0,0.5,0)
    k.BackgroundColor3 = Color3.fromRGB(30,30,30)
    k.BackgroundTransparency = 0.8
    k.BorderSizePixel = 0
    k.ZIndex = parent.ZIndex + 10
    k.Parent = parent
    createUICorner(k, UDim.new(0,10))
    createUIStroke(k, 2, Color3.fromRGB(45,45,45))
    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -4, 1, -4)
    inner.Position = UDim2.new(0,2,0,2)
    inner.BackgroundTransparency = 1
    inner.BorderSizePixel = 0
    inner.Parent = k
    createUICorner(inner, UDim.new(0,10))
    return k
end

    local knobFrameBarRGB = makeKnob(FrameBarRGB)
    local knobRGB = makeKnob(sliderBarRGB)
    local knobBT = makeKnob(sliderBarBT)

-- current logical values
local h,s,v = color3ToHSV(defaultColor)
local current = {
    color = defaultColor,
    hue = h or 0,
    saturation = s or 1,
    value = v or 1,
    alpha = 0
}

-- SV Render (Vape style)
-- Saturation layer (Hue → White)
local svSatLayer = Instance.new("Frame")
svSatLayer.Size = UDim2.new(1,0,1,0)
svSatLayer.BackgroundTransparency = 0
svSatLayer.ZIndex = FrameBarRGB.ZIndex + 1
svSatLayer.Parent = FrameBarRGB
createUICorner(svSatLayer)

local svSatGradient = Instance.new("UIGradient")
svSatGradient.Rotation = 0
svSatGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromHSV(current.hue, 0, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(current.hue, 1, 1)),
}
svSatGradient.Parent = svSatLayer

-- Value layer (Black overlay)
local svValLayer = Instance.new("Frame")
svValLayer.Size = UDim2.new(1,0,1,0)
svValLayer.BackgroundColor3 = Color3.fromRGB(0,0,0)
svValLayer.BackgroundTransparency = 0
svValLayer.ZIndex = FrameBarRGB.ZIndex + 2
svValLayer.Parent = FrameBarRGB
createUICorner(svValLayer)

local svValGradient = Instance.new("UIGradient")
svValGradient.Rotation = 90
svValGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1), -- top = transparent
    NumberSequenceKeypoint.new(1, 0), -- bottom = black
}
svValGradient.Parent = svValLayer

-- target values (for smooth display)
local target = { r=0, g=0, b=0, alpha = current.alpha }
local smooth = { r=0, g=0, b=0, alpha = current.alpha }

-- SV knob control (Smooth 2D movement)
local svKnobControl = {
    targetX = current.saturation or 0,
    targetY = 1 - (current.value or 0),
    smoothX = current.saturation or 0,
    smoothY = 1 - (current.value or 0),
    isDragging = false,
    
    set = function(self, sat, val)
        self.targetX = sat or self.targetX
        self.targetY = 1 - (val or (1 - self.targetY))
    end,
    
    get = function(self)
        return self.smoothX, 1 - self.smoothY
    end
}

-- init rgb targets from default
do
    local rr,gg,bb = color3ToRGBInts(current.color)
    target.r, target.g, target.b = rr, gg, bb
    smooth.r, smooth.g, smooth.b = rr, gg, bb
end

-- utility to set target from current.color
local function setTargetFromCurrentColor()
    local rr,gg,bb = color3ToRGBInts(current.color)
    target.r, target.g, target.b = rr, gg, bb
end

-- apply immediate (non-smooth) preview (used rarely)
local function applyImmediatePreview()
    FrameBarRGB.BackgroundColor3 = current.color
    FrameBarRGB.BackgroundTransparency = current.alpha
    sliderBarBT.BackgroundColor3 = current.color
    local r, g, b = color3ToRGBInts(current.color)

    inputBoxR.Text = tostring(r)
    inputBoxG.Text = tostring(g)
    inputBoxB.Text = tostring(b)
end

-- set up smooth updater (RenderStepped)
local SMOOTH = 0.18 -- lerp factor (0..1), ปรับได้
RunService:BindToRenderStep("ColorPickerSmooth_"..tostring(math.random()), Enum.RenderPriority.Camera.Value + 1, function()
    -- smooth each rgb and alpha
    smooth.r = smooth.r + (target.r - smooth.r) * SMOOTH
    smooth.g = smooth.g + (target.g - smooth.g) * SMOOTH
    smooth.b = smooth.b + (target.b - smooth.b) * SMOOTH
    smooth.alpha = smooth.alpha + (target.alpha - smooth.alpha) * SMOOTH
    
    -- smooth SV knob
    svKnobControl.smoothX = svKnobControl.smoothX + (svKnobControl.targetX - svKnobControl.smoothX) * SMOOTH
    svKnobControl.smoothY = svKnobControl.smoothY + (svKnobControl.targetY - svKnobControl.smoothY) * SMOOTH
    
    -- apply to preview frames
    local c = rgbIntsToColor3(smooth.r, smooth.g, smooth.b)
    FrameBarRGB.BackgroundColor3 = c
    FrameBarRGB.BackgroundTransparency = smooth.alpha
    sliderBarBT.BackgroundColor3 = c
    
    -- update SV knob position
    knobFrameBarRGB.Position = UDim2.new(
        svKnobControl.smoothX, 0,
        svKnobControl.smoothY, 0
    )
    
    -- update input boxes text if not focused
    if not inputBoxR:IsFocused() then inputBoxR.Text = tostring(math.floor(smooth.r+0.5)) end
    if not inputBoxG:IsFocused() then inputBoxG.Text = tostring(math.floor(smooth.g+0.5)) end
    if not inputBoxB:IsFocused() then inputBoxB.Text = tostring(math.floor(smooth.b+0.5)) end
end)

-- SV logic (2D picker)
local function updateSVFromPosition(screenPos)
    local absPos = FrameBarRGB.AbsolutePosition
    local absSize = FrameBarRGB.AbsoluteSize

    local sx = math.clamp((screenPos.X - absPos.X) / absSize.X, 0, 1)
    local sy = math.clamp((screenPos.Y - absPos.Y) / absSize.Y, 0, 1)

    current.saturation = sx
    current.value = 1 - sy

    current.color = Color3.fromHSV(
        current.hue,
        current.saturation,
        current.value
    )

    setTargetFromCurrentColor()
    svKnobControl.targetX = current.saturation
    svKnobControl.targetY = 1 - current.value
end

-- setHueRatio: update logical color from hue (keeps saturation/value)
local function setHueRatio(ratio)
    ratio = math.clamp(ratio, 0, 1)
    current.hue = ratio

    current.color = Color3.fromHSV(
        current.hue,
        current.saturation,
        current.value
    )

    setTargetFromCurrentColor()

    -- อัพเดท saturation gradient
    svSatGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHSV(current.hue, 0, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(current.hue, 1, 1)),
    }
    
    -- อัพเดท target position ของ knob
    svKnobControl.targetX = current.saturation
    svKnobControl.targetY = 1 - current.value
end

-- setAlphaRatio
local function setAlphaRatio(ratio)
    ratio = math.clamp(ratio, 0, 1)
    current.alpha = ratio
    target.alpha = current.alpha
end

-- slider draggable factory returns control with setTarget to programmatically move knob smoothly
local function makeSliderDraggable(slider, knob, onChangeRatio)
    local dragging = false
    local dragInput = nil
    local targetRatio = 0
    local smoothRatio = 0
    local sliderWidthCached = 0

    -- update position based on input
    local function updateFromInput(input)
        if not slider or slider.Parent == nil then return end
        local absPos = slider.AbsolutePosition
        local absSize = slider.AbsoluteSize
        sliderWidthCached = absSize.X
        local x = 0
        if input and input.Position then
            x = input.Position.X - absPos.X
        else
            return
        end
        targetRatio = math.clamp(x / math.max(1, absSize.X), 0, 1)
        if onChangeRatio then
            onChangeRatio(targetRatio)
        end
    end

    -- RenderStepped for knob smooth
    local conn
    conn = RunService.RenderStepped:Connect(function()
        smoothRatio = smoothRatio + (targetRatio - smoothRatio) * 0.22
        local width = slider.AbsoluteSize.X
        knob.Position = UDim2.new(0, smoothRatio * math.max(1, width), 0.5, 0)
    end)

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    dragInput = nil
                end
            end)
        end
    end)

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- return control to allow programmatic set
    return {
        set = function(ratio)
            targetRatio = math.clamp(ratio or 0, 0, 1)
        end,
        get = function() return targetRatio, smoothRatio end
    }
end

-- SV dragging
local draggingSV = false

FrameBarRGB.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSV = true
        updateSVFromPosition(input.Position)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSV and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateSVFromPosition(input.Position)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSV = false
    end
end)

-- init knobs controls (so we can set them programmatically)
local hueControl = makeSliderDraggable(sliderBarRGB, knobRGB, function(ratio)
    -- when user moves hue knob: update logical hue -> update target color
    setHueRatio(ratio)
    -- update alpha slider's background color to reflect new chosen hue (target will be lerped)
    target.alpha = target.alpha or current.alpha
    setTargetFromCurrentColor()
end)

local alphaControl = makeSliderDraggable(sliderBarBT, knobBT, function(ratio)
    setAlphaRatio(ratio)
end)

-- helper to set knobs to current hue/alpha (smoothly)
local function moveKnobsToCurrent()
    if hueControl and hueControl.set then hueControl.set(current.hue) end
    if alphaControl and alphaControl.set then alphaControl.set(current.alpha) end
    svKnobControl.targetX = current.saturation
    svKnobControl.targetY = 1 - current.value
end

-- input -> update current and target (typing)
local function updateFromInputs()
    local r = safeParseInt(inputBoxR.Text)
    local g = safeParseInt(inputBoxG.Text)
    local b = safeParseInt(inputBoxB.Text)
    if r and g and b then
        r = math.clamp(r,0,255)
        g = math.clamp(g,0,255)
        b = math.clamp(b,0,255)

        -- อัพเดท logical color
        current.color = rgbIntsToColor3(r,g,b)
        local hh, ss, vv = color3ToHSV(current.color)
        current.hue = hh
        current.saturation = ss
        current.value = vv

        -- อัพเดท display target (smooth preview) but DO NOT restrict knob range
        target.r = r
        target.g = g
        target.b = b

        -- อัพเดท saturation gradient
        svSatGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(current.hue, 0, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(current.hue, 1, 1)),
        }

        -- ensure knobs reflect new logical hue/alpha (programmatically move them)
        moveKnobsToCurrent()
    end
end

inputBoxR.FocusLost:Connect(function() updateFromInputs() end)
inputBoxG.FocusLost:Connect(function() updateFromInputs() end)
inputBoxB.FocusLost:Connect(function() updateFromInputs() end)

-- Open / Close behaviour
btn.MouseButton1Click:Connect(function()
    containerRGB.Visible = true
    ScreenDrunk.Visible = true

    TweenService:Create(mainBorder, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {
        Color = Color3.fromRGB(0,150,255)
    }):Play()
    task.delay(0.6, function()
        TweenService:Create(mainBorder, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
            Color = Color3.fromRGB(45,45,45)
        }):Play()
    end)

    flashBorder.Enabled = true
    flashBorder.Transparency = 0
    TweenService:Create(flashBorder, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
        Transparency = 1
    }):Play()

    -- move knobs to reflect current values when opening
    moveKnobsToCurrent()
end)

RGBDoneButton.MouseButton1Click:Connect(function()
    -- commit color to statusLight
    statusLight.BackgroundColor3 = current.color
    statusLight.BackgroundTransparency = current.alpha

    -- close
    containerRGB.Visible = false
    ScreenDrunk.Visible = false
end)

RGBCancelButton.MouseButton1Click:Connect(function()
    -- simply close without saving (statusLight stays as before)
    containerRGB.Visible = false
    ScreenDrunk.Visible = false
    -- when closed, also reset target to statusLight color so preview returns to last saved
    local rr,gg,bb = color3ToRGBInts(statusLight.BackgroundColor3)
    target.r, target.g, target.b = rr, gg, bb
    target.alpha = statusLight.BackgroundTransparency
end)

-- initialization
setTargetFromCurrentColor()
target.alpha = current.alpha or 0

-- set initial SV knob position
svKnobControl.targetX = current.saturation
svKnobControl.targetY = 1 - current.value
svKnobControl.smoothX = current.saturation
svKnobControl.smoothY = 1 - current.value
knobFrameBarRGB.Position = UDim2.new(
    current.saturation, 0,
    1 - current.value, 0
)

-- set input boxes initial text
if not inputBoxR:IsFocused() then inputBoxR.Text = tostring(target.r) end
if not inputBoxG:IsFocused() then inputBoxG.Text = tostring(target.g) end
if not inputBoxB:IsFocused() then inputBoxB.Text = tostring(target.b) end

-- ensure knob positions are initialized
moveKnobsToCurrent()

return {
    GetColor = function()
        local r = math.floor(current.color.R * 255)
        local g = math.floor(current.color.G * 255)
        local b = math.floor(current.color.B * 255)
        return r, g, b, current.alpha, current.color
    end,

    SetColor = function(newColor, newAlpha)
        current.color = newColor or current.color
        current.alpha = newAlpha or current.alpha

        -- sync HSV
        local h,s,v = color3ToHSV(current.color)
        current.hue = h
        current.saturation = s
        current.value = v

        -- update preview
        applyImmediatePreview()

        -- update knobs
        moveKnobsToCurrent()
    end
}

    --[[
    • API เรียกใช้ภายนอก (createToggleColorPicker)
    - api:GetColor("r, g, b, current.alpha, current.color") :: ขอค่าสี
    - api:SetColor("newColor, newAlpha") :: ตั้งค่าสี
    
    return {
    GetColor = function()
        local r = math.floor(current.color.R * 255)
        local g = math.floor(current.color.G * 255)
        local b = math.floor(current.color.B * 255)
        return r, g, b, current.alpha, current.color
    end,

    SetColor = function(newColor, newAlpha)
        current.color = newColor or current.color
        current.alpha = newAlpha or current.alpha

        -- sync HSV
        local h,s,v = color3ToHSV(current.color)
        current.hue = h
        current.saturation = s
        current.value = v

        -- update preview
        applyImmediatePreview()

        -- update knobs
        moveKnobsToCurrent()
    end}
    
    ]]

               end
                --// return ContainerContent api
                return ContainerContent
                
        end -- function Tabs:CreateTab
        --// return Tabs api
        return Tabs
        
end -- function erclib:window
--// return library api
return erclib
