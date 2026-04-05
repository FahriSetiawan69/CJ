-- [[ FahriRoundopHUB - CJ Home UI (Optimization Only) ]] --
local CoreGui = game:GetService("CoreGui")
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/CJ/main/"

-- ANTI-DUPLICATE
if CoreGui:FindFirstChild("FR_CJ_MobileToggle") then CoreGui.FR_CJ_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 1. WINDOW SETUP
local Window = Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Cidro Janji - Optimizer",
    TabWidth = 160, 
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true, 
    Theme = "Dark", 
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 2. MOBILE TOGGLE
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FR_CJ_MobileToggle"
ScreenGui.Enabled = false
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleButton.Image = "rbxassetid://4483345998"
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

local OriginalMinimize = Window.Minimize
Window.Minimize = function(self)
    OriginalMinimize(self)
    ScreenGui.Enabled = Window.Minimized 
end
ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

-- 3. FEATURE LOADER (Otak VD)
local function GetOptimizer()
    if _G.CJ_Optimizer == nil then 
        loadstring(game:HttpGet(BaseURL .. "Features/FPSBoost.lua"))() 
    end
    return _G.CJ_Optimizer
end

-- 4. TABS SETUP
local Tabs = {
    Main = Window:AddTab({ Title = "Optimization", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- 5. MAIN OPTIMIZATION
Tabs.Main:AddParagraph({
    Title = "Server Lag Fixer",
    Content = "Mengurangi beban GPU/CPU akibat 80 player dan efek disko."
})

Tabs.Main:AddToggle("BoostToggle", {Title = "High Performance Mode", Default = false}):OnChanged(function(v)
    local Opti = GetOptimizer()
    if Opti then 
        Opti:Toggle(v) 
    end
end)

Tabs.Main:AddButton({
    Title = "Clean Memory (Manual)",
    Description = "Membersihkan sampah data (Garbage Collector)",
    Callback = function()
        collectgarbage("collect")
        Fluent:Notify({Title = "Memory Cleaned", Content = "RAM usage has been optimized locally.", Duration = 3})
    end
})

-- 6. CLEANUP
CoreGui.ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" then
        ScreenGui:Destroy()
        _G.CJ_Optimizer = nil
    end
end)

Window:SelectTab(1)

