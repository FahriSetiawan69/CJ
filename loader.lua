-- [[ FahriRoundopHUB - CJ (CIDRO JANJI) EDITION ]] --
-- URL di bawah ini sudah diarahkan ke repository CJ kamu
local BaseURL = "https://raw.githubusercontent.com/FahriSetiawan69/CJ/main/"
local StarterGui = game:GetService("StarterGui")

-- 1. Pop-up Hiasan (Sudah disesuaikan teksnya)
StarterGui:SetCore("SendNotification", {
    Title = "FahriRoundopHUB",
    Text = "CJ Hub (Cidro Janji) Loading...",
    Duration = 5
})

-- 2. Logika Pemanggilan HomeGui
local function StartHub()
    -- Mengambil HomeGui.lua dari repo CJ
    local targetURL = BaseURL .. "HomeGui.lua"
    local success, content = pcall(function()
        return game:HttpGet(targetURL)
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            print("[FR-HUB] CJ HomeGui Terdeteksi! Menjalankan...")
            func()
        else
            warn("[FR-HUB] Error Compile: " .. tostring(err))
        end
    else
        -- Jika URL salah atau file belum diupload, ini akan muncul di F9
        warn("[FR-HUB] HTTP 404: File tidak ditemukan di " .. targetURL)
    end
end

task.spawn(StartHub)

