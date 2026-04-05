-- [[ CJ Optimizer - SMART & SAFE VERSION ]] --
_G.CJ_Optimizer = {}

local originalData = {}
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Daftar folder yang akan dihilangkan VISUALNYA saja (Tabrakan tetap ada)
local heavyFolders = {"HUTAN", "Object", "BOOTH", "Screen", "StageLamp"}

-- Fungsi cek apakah ini bagian dari Player (Baju, Rambut, Kulit)
local function isPlayer(v)
    if v:FindFirstAncestorOfClass("Humanoid") or 
       v:FindFirstAncestorOfClass("Accessory") or 
       v:FindFirstAncestorOfClass("Shirt") or 
       v:FindFirstAncestorOfClass("Pants") then
        return true
    end
    return false
end

function _G.CJ_Optimizer:Toggle(state)
    if state then
        -- 1. LIGHTING (Tetap Malam tapi lebih terang sedikit agar tidak suram)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)

        -- 2. SEMBUNYIKAN FOLDER BERAT (TANPA TEMBUS TEMBOK)
        for _, name in pairs(heavyFolders) do
            local folder = Workspace:FindFirstChild(name)
            if folder then
                for _, part in pairs(folder:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        -- Simpan data asli
                        originalData[part] = {Transparency = part.Transparency}
                        -- Bikin transparan (GPU tidak render, tapi Kaki tetap bisa menabrak)
                        part.Transparency = 1 
                    elseif part:IsA("Decal") or part:IsA("Texture") then
                        originalData[part] = {Transparency = part.Transparency}
                        part.Transparency = 1
                    elseif part:IsA("Light") or part:IsA("ParticleEmitter") then
                        part.Enabled = false
                    end
                end
            end
        end

        -- 3. OPTIMASI SISANYA (SANGAT HATI-HATI)
        for _, v in pairs(Workspace:GetDescendants()) do
            if not isPlayer(v) then
                -- Hapus Mirror (ViewportFrame) saja, jangan Mesh panggungnya
                if v:IsA("ViewportFrame") then
                    v.Enabled = false
                end
                
                -- Hanya optimasi material jika itu bukan Tembok/Lantai (agar tidak abu-abu semua)
                if v:IsA("BasePart") and v.Name == "Part" then -- Biasanya part hiasan namanya cuma "Part"
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                end
            end
        end
        print("CJ Hub: Smart Boost ON - Collision Safe & Avatar Protected.")
    else
        -- KEMBALIKAN SEMUA KE NORMAL
        for part, data in pairs(originalData) do
            if part then
                part.Transparency = data.Transparency
            end
        end
        
        -- Aktifkan kembali mirror & lampu
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ViewportFrame") or v:IsA("Light") then
                v.Enabled = true
            end
        end
        
        table.clear(originalData)
        print("CJ Hub: Smart Boost OFF.")
    end
end

return _G.CJ_Optimizer
