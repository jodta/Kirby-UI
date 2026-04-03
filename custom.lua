local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = { Toggled = true, Accent = Color3.fromRGB(160, 60, 255) }

-- Lucide Icons (from dawid-scripts/Fluent verified asset IDs)
local Icons = {
    home = "rbxassetid://10723407389",
    flame = "rbxassetid://10723376114",
    settings = "rbxassetid://10734950309",
    account = "rbxassetid://10747373176", -- Lucide 'user' (verified working)
    eye = "rbxassetid://10723346959",
    ["map-pin"] = "rbxassetid://10734886004",
    ["bar-chart-2"] = "rbxassetid://10709770317",
    swords = "rbxassetid://10734975692",
    user = "rbxassetid://10747373176",
    shield = "rbxassetid://10734951847",
    zap = "rbxassetid://10747398811",
    target = "rbxassetid://10734977012",
    globe = "rbxassetid://10723404337",
    layout = "rbxassetid://10723425376",
    search = "rbxassetid://10734943674",
    save = "rbxassetid://10734941499",
    sliders = "rbxassetid://10734963400",
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in next, props do if i ~= "Parent" then obj[i] = v end end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

function Library:MakeDraggable(gui)
    local drag, dStart, sPos
    gui.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; dStart = i.Position; sPos = gui.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dStart
            gui.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
end

function Library:GetIcon(name)
    return Icons[name] or Icons["home"]
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "KurbyLib",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })
    if getgenv then
        if getgenv()._KurbyUI then getgenv()._KurbyUI:Destroy() end
        getgenv()._KurbyUI = ScreenGui
    end

    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Position = UDim2.new(0.5, -300, 0.5, -220),
        Size = UDim2.new(0, 600, 0, 440)
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    Create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Parent = Main })

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        Size = UDim2.new(0, 65, 1, 0)
    })
    Create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), ApplyStrokeMode = "Border", Parent = Sidebar })

    -- Logo
    Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Font = "GothamBold",
        Text = "K",
        TextColor3 = Library.Accent,
        TextSize = 22
    })

    local List = Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(1, 0, 1, -36)
    })
    Create("UIListLayout", {
        Parent = List,
        HorizontalAlignment = "Center",
        Padding = UDim.new(0, 4)
    })

    -- Content area
    local Container = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 65, 0, 0),
        Size = UDim2.new(1, -65, 1, 0)
    })

    local Header = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48) })
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 180, 1, 0),
        Font = "GothamBold",
        Text = title or "Kurby Hub",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        TextXAlignment = "Left"
    })

    local SubTabBar = Create("Frame", { Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0) })
    Create("UIListLayout", { Parent = SubTabBar, FillDirection = "Horizontal", Padding = UDim.new(0, 16), VerticalAlignment = "Center" })
    Create("Frame", { Parent = Header, BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1) })

    local Folder = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 48), Size = UDim2.new(1, 0, 1, -48) })
    Library:MakeDraggable(Main)

    local Window = { Current = nil }

    function Window:CreateTab(name, iconName)
        local icon = Library:GetIcon(iconName or "home")

        local Btn = Create("ImageButton", {
            Name = name .. "Tab",
            Parent = List,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50)
        })

        -- Hover highlight
        local Highlight = Create("Frame", {
            Parent = Btn,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0)
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Highlight })

        -- Purple indicator
        local Ind = Create("Frame", {
            Name = "Indicator",
            Parent = Btn,
            BackgroundColor3 = Library.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -12),
            Size = UDim2.new(0, 3, 0, 24),
            BackgroundTransparency = 1,
            ZIndex = 5
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Ind })

        -- Lucide icon (ImageLabel — verified Roblox asset IDs)
        local Ico = Create("ImageLabel", {
            Name = "Icon",
            Parent = Btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -12, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = icon,
            ImageColor3 = Color3.fromRGB(140, 140, 140),
            ZIndex = 6
        })

        local Tab = { SubTabs = {}, CurrentST = nil }

        function Tab:Select()
            for _, v in next, List:GetChildren() do
                if v:IsA("ImageButton") then
                    if v:FindFirstChild("Indicator") then Tween(v.Indicator, 0.25, { BackgroundTransparency = 1 }) end
                    if v:FindFirstChild("Icon") then Tween(v.Icon, 0.25, { ImageColor3 = Color3.fromRGB(140, 140, 140) }) end
                    for _, f in next, v:GetChildren() do
                        if f:IsA("Frame") and f.Name ~= "Indicator" then Tween(f, 0.25, { BackgroundTransparency = 1 }) end
                    end
                end
            end
            if Window.Current then
                for _, st in next, Window.Current.Tab.SubTabs do
                    st.Btn.Visible = false
                    st.Page.Visible = false
                end
            end
            Window.Current = { Tab = Tab }
            Tween(Ico, 0.25, { ImageColor3 = Library.Accent })
            Tween(Ind, 0.25, { BackgroundTransparency = 0 })
            Tween(Highlight, 0.25, { BackgroundTransparency = 0.85 })
            for _, st in next, Tab.SubTabs do st.Btn.Visible = true end
            if Tab.CurrentST then Tab.CurrentST:Select() elseif Tab.SubTabs[1] then Tab.SubTabs[1]:Select() end
        end

        Btn.MouseButton1Click:Connect(function() Tab:Select() end)
        Btn.MouseEnter:Connect(function() if not Window.Current or Window.Current.Tab ~= Tab then Tween(Highlight, 0.2, { BackgroundTransparency = 0.92 }) end end)
        Btn.MouseLeave:Connect(function() if not Window.Current or Window.Current.Tab ~= Tab then Tween(Highlight, 0.2, { BackgroundTransparency = 1 }) end end)

        function Tab:CreateSubTab(stName, stIconName)
            local stIcon = Library:GetIcon(stIconName or "layout")
            local SBtn = Create("Frame", { Parent = SubTabBar, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", Visible = false })
            local SClick = Create("TextButton", { Parent = SBtn, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
            local SIco = Create("ImageLabel", {
                Name = "Icon",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = stIcon,
                ImageColor3 = Color3.fromRGB(160, 160, 160)
            })
            local SText = Create("TextLabel", {
                Name = "Label",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 22, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                Font = "Gotham",
                Text = stName,
                TextColor3 = Color3.fromRGB(160, 160, 160),
                TextSize = 13
            })
            local SLine = Create("Frame", {
                Parent = SBtn,
                BackgroundColor3 = Library.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(1, 0, 0, 2)
            })
            local SPage = Create("ScrollingFrame", { Parent = Folder, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = Library.Accent })
            Create("UIListLayout", { Parent = SPage, Padding = UDim.new(0, 10), HorizontalAlignment = "Center" })
            Create("UIPadding", { Parent = SPage, PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18) })

            local SubTab = { Page = SPage, Btn = SBtn }

            function SubTab:Select()
                if Tab.CurrentST then
                    Tab.CurrentST.Page.Visible = false
                    Tween(Tab.CurrentST.Btn.Label, 0.2, { TextColor3 = Color3.fromRGB(160, 160, 160) })
                    Tween(Tab.CurrentST.Btn.Icon, 0.2, { ImageColor3 = Color3.fromRGB(160, 160, 160) })
                    local oldLine = Tab.CurrentST.Btn:FindFirstChildOfClass("Frame")
                    if oldLine then Tween(oldLine, 0.2, { BackgroundTransparency = 1 }) end
                end
                Tab.CurrentST = SubTab
                SPage.Visible = true
                Tween(SText, 0.2, { TextColor3 = Color3.new(1, 1, 1) })
                Tween(SIco, 0.2, { ImageColor3 = Library.Accent })
                Tween(SLine, 0.2, { BackgroundTransparency = 0 })
            end
            SClick.MouseButton1Click:Connect(function() SubTab:Select() end)
            table.insert(Tab.SubTabs, SubTab)

            function SubTab:CreateSection(secName)
                local Sec = Create("Frame", { Parent = SPage, BackgroundColor3 = Color3.fromRGB(16, 16, 16), Size = UDim2.new(1, 0, 0, 30) })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Sec })
                Create("Frame", { Parent = Sec, BackgroundColor3 = Library.Accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 6), Size = UDim2.new(0, 2, 0, 18) })
                Create("TextLabel", { Parent = Sec, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -10, 1, 0), Font = "GothamBold", Text = secName:upper(), TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 11, TextXAlignment = "Left" })
                local Content = Create("Frame", { Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) })
                local L = Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 6) })
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Content.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
                    SPage.CanvasSize = UDim2.new(0, 0, 0, SPage.UIListLayout.AbsoluteContentSize.Y + 40)
                end)
                local S = {}
                function S:CreateToggle(n, def, cb)
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -64, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local O = Create("Frame", { Parent = F, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 36, 0, 18) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                    local I = Create("Frame", { Parent = O, BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(0, 2, 0.5, -7), Size = UDim2.new(0, 14, 0, 14) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })
                    local t = def or false
                    local function u() Tween(O, 0.2, { BackgroundColor3 = t and Library.Accent or Color3.fromRGB(35, 35, 35) }); Tween(I, 0.2, { Position = t and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }); if cb then cb(t) end end
                    F.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then t = not t; u() end end)
                    u()
                end
                function S:CreateButton(n, cb)
                    local B = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = B })
                    Create("TextLabel", { Parent = B, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14 })
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                end
                return S
            end
            return SubTab
        end
        if not Window.Current then Tab:Select() end
        return Tab
    end
    return Window
end

-- ============================================
-- KURBY HUB v4.0 — Lucide Icons (Verified)
-- ============================================
local Window = Library:CreateWindow("Kurby Hub")

--         Tab Name       Lucide Icon Name
local HomeTab   = Window:CreateTab("Home",     "home")        -- House
local FarmTab   = Window:CreateTab("Farming",  "swords")      -- Swords
local UserTab   = Window:CreateTab("Account",  "account")     -- User
local VisTab    = Window:CreateTab("Visuals",  "eye")         -- Eye
local TeleTab   = Window:CreateTab("Teleport", "map-pin")     -- Map Pin
local StatsTab  = Window:CreateTab("Stats",    "bar-chart-2") -- Bar Chart
local ConfigTab = Window:CreateTab("Config",   "settings")    -- Cogwheel

return Library
