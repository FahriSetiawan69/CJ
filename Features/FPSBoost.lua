-- [[ CJ Optimizer - PRECISION DELETE + AUTO CLEAN MODE ]] --
_G.CJ_Optimizer = {}

local originalData = {}
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- Konfigurasi Target
local WorkspaceTargets = {"HUTAN", "NekoDono", "PANGGUNG", "Screen", "StageLamp"}
local CleanInterval = 600 -- 600 detik = 10 menit

-- Variable kontrol untuk Loop
_G.CJ_Optimizer.Active = false

-- // FUNGSI BERSIH-BERSIH RAM //
local function CleanMemory()
    local memBefore = math.floor(collectgarbage("count"))
    collectgarbage("collect")
    local memAfter = math.floor(collectgarbage("count"))
    local freed = memBefore - memAfter

    -- Notifikasi Pop-up (Via Fluent)
    if _G.Fluent then
        _G.Fluent:Notify({
            Title = "Auto Clean Berhasil",
            Content = "Membersihkan " .. tostring(freed) .. " KB data player & cache.",
            Duration = 5
        })
    end
    print("[CJ-HUB] Auto Clean: " .. tostring(freed) .. " KB Freed.")
end

-- // LOOP OTOMATIS //
local function StartAutoLoop()
    task.spawn(function()
        while _G.CJ_Optimizer.Active do
            task.wait(CleanInterval)
            if _G.CJ_Optimizer.Active then
                CleanMemory()
            end
        end
    end)
end

function _G.CJ_Optimizer:Toggle(state)
    _G.CJ_Optimizer.Active = state
    
    if state then
        -- 1. OPTIMASI LIGHTING
        Lighting.GlobalShadows = false
        
        -- 2. HAPUS FOLDER TARGET (HUTAN, NEKODONO, DLL)
        for _, name in pairs(WorkspaceTargets) do
            local target = Workspace:FindFirstChild(name)
            if target then
                originalData[target] = {Parent = target.Parent}
                target.Parent = nil
            end
        end

        -- 3. HAPUS SCREENAVATAR DI PLAYERGUI
        local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
        if PlayerGui then
            local screenAvatar = PlayerGui:FindFirstChild("ScreenAvatar")
            if screenAvatar then
                originalData[screenAvatar] = {Parent = screenAvatar.Parent}
                screenAvatar.Parent = nil
            end
        end

        -- 4. JALANKAN AUTO CLEAN PER 10 MENIT
        CleanMemory() -- Jalankan sekali saat pertama kali ON
        StartAutoLoop()

        print("CJ Hub: Extreme Boost & Auto Clean (10m) Active!")
    else
        -- 5. KEMBALIKAN SEMUA
        Lighting.GlobalShadows = true
        
        for obj, data in pairs(originalData) do
            if obj then
                obj.Parent = data.Parent
            end
        end
        
        table.clear(originalData)
        print("CJ Hub: Boost Off. Auto Clean Stopped.")
    end
end

return _G.CJ_Optimizer
