-- [[ FahriRoundopHUB - CJ (Cidro Janji) Official Home UI ]] --
local CoreGui = game:GetService("CoreGui")
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/CJ/main/"

-- 1. ANTI-DUPLICATE (Pembersihan agar tidak double menu)
if CoreGui:FindFirstChild("FR_CJ_MobileToggle") then CoreGui.FR_CJ_MobileToggle:Destroy() end
if CoreGui:FindFirstChild("Fluent") then CoreGui.Fluent:Destroy() end

-- Menggunakan Global variable agar bisa diakses oleh module di folder Features
_G.Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- 2. WINDOW SETUP
local Window = _G.Fluent:CreateWindow({
    Title = "FahriRoundopHUB",
    SubTitle = "Cidro Janji - Optimizer",
    TabWidth = 160, 
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true, 
    Theme = "Dark", 
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 3. MOBILE TOGGLE SYNC
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FR_CJ_MobileToggle"
ScreenGui.Enabled = false
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Position = UDim2.new(0.02, 0, 0.45, 0)
ToggleButton.Image = "rbxassetid://4483345998" -- Icon hiasan
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

local OriginalMinimize = Window.Minimize
Window.Minimize = function(self)
    OriginalMinimize(self)
    ScreenGui.Enabled = Window.Minimized 
end
ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

-- 4. TABS SETUP
local Tabs = {
    Main = Window:AddTab({ Title = "Optimization", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- 5. FEATURES IMPLEMENTATION (Modular Logic)

-- --- TOGGLE SAKTI: FPS BOOST + NIGHT MODE ---
Tabs.Main:AddToggle("MasterOptimizer", {
    Title = "Extreme Performance Mode", 
    Default = false,
    Description = "Aktifkan Plastik Map, No Shadow, & Night Mode sekaligus."
}):OnChanged(function(v)
    local success, err = pcall(function()
        -- Load script dari Features
        loadstring(game:HttpGet(BaseURL .. "Features/FPSBoost.lua"))()
        if _G.CJ_Optimizer then 
            _G.CJ_Optimizer:Toggle(v) 
        end
    end)
    
    if not success then
        warn("[FR-HUB] Gagal memuat FPSBoost: " .. tostring(err))
    end
end)

-- --- BUTTON: CLEAN MEMORY ---
Tabs.Main:AddButton({
    Title = "Clean Memory (Manual)",
    Description = "Bersihkan RAM & Cache Game (Garbage Collection)",
    Callback = function()
        local success, err = pcall(function()
            -- Load script dari Features
            loadstring(game:HttpGet(BaseURL .. "Features/CleanMemory.lua"))()
            if _G.CJ_Cleaner then 
                _G.CJ_Cleaner:Execute() 
            end
        end)
        
        if not success then
            warn("[FR-HUB] Gagal memuat CleanMemory: " .. tostring(err))
        end
    end
})

-- 6. CLEANUP (Saat GUI di-close)
CoreGui.ChildRemoved:Connect(function(child)
    if child.Name == "Fluent" then
        ScreenGui:Destroy()
        _G.CJ_Optimizer = nil
        _G.CJ_Cleaner = nil
        _G.Fluent = nil
    end
end)

-- Notifikasi Awal
_G.Fluent:Notify({
    Title = "CJ Hub Loaded!",
    Content = "Siap digunakan di server 80 player.",
    Duration = 5
})

Window:SelectTab(1)
