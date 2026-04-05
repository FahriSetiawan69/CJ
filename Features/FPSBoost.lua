-- [[ CJ Optimizer - SUPER EXTREME VERSION ]] --
_G.CJ_Optimizer = {}

local originalData = {}
local Lighting = game:GetService("Lighting")
local Terrain = game:GetService("Workspace").Terrain

-- Simpan status Lighting awal
local originalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation
}

function _G.CJ_Optimizer:Toggle(state)
    if state then
        -- 1. LIGHTING MATI TOTAL (FLAT)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 0 -- Malam
        Lighting.Brightness = 0 -- Hilangkan pantulan cahaya matahari/lampu
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100) -- Terang rata tanpa bayangan
        Lighting.ExposureCompensation = 0
        
        -- Hapus semua efek (Bloom, Blur, dll)
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostProcessEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") then
                effect.Enabled = false
            end
        end

        -- 2. PEMBERSIHAN EKSTREM (MAP ONLY)
        for _, v in pairs(game:GetDescendants()) do
            -- Filter: JANGAN SENTUH AVATAR PLAYER
            if not v:FindFirstAncestorOfClass("Humanoid") then
                
                -- Hapus Tekstur & Gambar (Ini yang bikin berat di SS kamu)
                if v:IsA("Decal") or v:IsA("Texture") then
                    originalData[v] = {Transparency = v.Transparency}
                    v.Transparency = 1 -- Gambar hilang total
                
                -- Paksa Material Jadi Plastik Licin & Tanpa Bayangan
                elseif v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    originalData[v] = {
                        Material = v.Material,
                        Reflectance = v.Reflectance,
                        CastShadow = v.CastShadow,
                        Color = v.Color -- Opsional: bisa simpan warna
                    }
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                    
                -- Matikan Partikel & Cahaya Lampu di Map
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") then
                    v.Enabled = false
                elseif v:IsA("Light") then
                    v.Enabled = false -- Matikan lampu pilar dan panggung
                end
            end
        end

        -- 3. TERRAIN OPTIMIZATION
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
        
        print("CJ Hub: SUPER EXTREME MODE ACTIVATED")
    else
        -- KEMBALIKAN KE NORMAL
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.Brightness = originalLighting.Brightness
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        
        for v, props in pairs(originalData) do
            if v and v.Parent then
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = props.Transparency
                else
                    v.Material = props.Material
                    v.Reflectance = props.Reflectance
                    v.CastShadow = props.CastShadow
                end
            end
        end
        
        -- Aktifkan kembali Lampu & Partikel
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Light") then
                v.Enabled = true
            end
        end

        table.clear(originalData)
        print("CJ Hub: SUPER EXTREME MODE DEACTIVATED")
    end
end

return _G.CJ_Optimizer
