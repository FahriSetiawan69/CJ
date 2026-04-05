-- [[ CJ Optimizer - GOD MODE (MIRROR & FLORA KILLER) ]] --
_G.CJ_Optimizer = {}

local originalData = {}
local Lighting = game:GetService("Lighting")
local Terrain = game:GetService("Workspace").Terrain

function _G.CJ_Optimizer:Toggle(state)
    if state then
        -- 1. MATIKAN LIGHTING & GLOBAL EFFECTS
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
        Terrain.Decoration = false -- Matikan rumput otomatis Roblox

        -- 2. PEMBERSIHAN TOTAL (MAP & UI)
        for _, v in pairs(game:GetDescendants()) do
            -- A. HANCURKAN MIRROR / VIEWPORT (Penyebab Utama Lag)
            if v:IsA("ViewportFrame") then
                v.Enabled = false -- Matikan semua mirror/render ganda
            end
            
            -- B. DETEKSI OBJEK BERDASARKAN NAMA (Pohon, Rumput, Mirror)
            local name = v.Name:lower()
            if name:find("tree") or name:find("leaf") or name:find("leaves") or name:find("grass") or name:find("bush") or name:find("flower") or name:find("mirror") or name:find("kaca") then
                -- Simpan data sebelum dihilangkan agar bisa balik
                originalData[v] = {Parent = v.Parent}
                v.Parent = nil -- Hilangkan dari Workspace (lebih ringan dari Destroy)
            end

            -- C. OPTIMASI MATERIAL & CAHAYA (Kecuali Avatar)
            if not v:FindFirstAncestorOfClass("Humanoid") then
                -- Matikan semua Lampu Map
                if v:IsA("Light") then
                    v.Enabled = false
                
                -- Hapus Tekstur (Batu Bata, Lantai, dll)
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                
                -- Paksa Plastik Polos
                elseif v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                
                -- Matikan Partikel Disko
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                end
            end
        end
        print("CJ Hub: GOD MODE ACTIVATED (Mirror & Flora Removed)")
    else
        -- KEMBALIKAN SEMUA KE NORMAL
        Lighting.GlobalShadows = true
        Lighting.ClockTime = 12
        Lighting.Brightness = 2
        Terrain.Decoration = true

        for v, data in pairs(originalData) do
            if v then v.Parent = data.Parent end
        end
        
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ViewportFrame") or v:IsA("Light") or v:IsA("ParticleEmitter") then
                v.Enabled = true
            end
        end
        
        table.clear(originalData)
        print("CJ Hub: GOD MODE DEACTIVATED")
    end
end

return _G.CJ_Optimizer
