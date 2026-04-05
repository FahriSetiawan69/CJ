-- [[ CJ Memory Cleaner Module ]] --
_G.CJ_Cleaner = {}

function _G.CJ_Cleaner:Execute()
    -- Mengambil jumlah memori sebelum dibersihkan (dalam KB)
    local memBefore = math.floor(collectgarbage("count"))
    
    -- Menjalankan Garbage Collector
    collectgarbage("collect")
    
    -- Mengambil jumlah memori setelah dibersihkan
    local memAfter = math.floor(collectgarbage("count"))
    local totalFreed = memBefore - memAfter

    -- Notifikasi Sukses
    -- Kita gunakan StarterGui sebagai fallback jika Fluent tidak terdeteksi secara global
    local successMsg = "Berhasil membersihkan " .. tostring(totalFreed) .. " KB sampah data."
    
    if _G.Fluent then
        _G.Fluent:Notify({
            Title = "Memory Cleaned",
            Content = successMsg,
            Duration = 5,
            Image = "rbxassetid://4483345998"
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CJ Memory Cleaner",
            Text = successMsg,
            Duration = 5
        })
    end
    
    print("[CJ-HUB] Memory Cleaned: " .. tostring(totalFreed) .. " KB")
end

return _G.CJ_Cleaner

