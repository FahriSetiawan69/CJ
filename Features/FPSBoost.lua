-- [[ CJ Optimizer Module - Combined Logic ]] --
_G.CJ_Optimizer = {}

local originalMaterials = {}
local Lighting = game:GetService("Lighting")

-- Menyimpan data lighting asli agar bisa kembali normal
local originalLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows
}

function _G.CJ_Optimizer:Toggle(state)
    if state then
        -- 1. BOOST LIGHTING & NIGHT MODE
        Lighting.ClockTime = 0 -- Malam hari
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(40, 40, 40)
        Lighting.GlobalShadows = false
        
        -- 2. DISABLE EFFECTS
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostProcessEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
                effect.Enabled = false
            end
        end

        -- 3. OPTIMIZE MAP MATERIALS
        for _, v in pairs(game:GetDescendants()) do
            -- Filter: Jangan kena Avatar Player
            if not v:FindFirstAncestorOfClass("Humanoid") then
                if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    originalMaterials[v] = {v.Material, v.CastShadow}
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end
        print("CJ Hub: Extreme Mode ON")
    else
        -- KEMBALIKAN SEMUA KE NORMAL
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.Brightness = originalLighting.Brightness
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.GlobalShadows = originalLighting.GlobalShadows

        for v, props in pairs(originalMaterials) do
            if v and v.Parent then
                v.Material = props[1]
                v.CastShadow = props[2]
            end
        end
        
        -- Aktifkan kembali partikel
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = true
            end
        end
        
        table.clear(originalMaterials)
        print("CJ Hub: Extreme Mode OFF")
    end
end

return _G.CJ_Optimizer
