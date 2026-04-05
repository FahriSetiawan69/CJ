-- [[ CJ Optimizer - GOD MODE (DATA ACCURATE) ]] --
_G.CJ_Optimizer = {}

local originalData = {}
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Folder Target Spesifik dari hasil Scan kamu
local targets = {"HUTAN", "Object", "BOOTH", "Screen", "StageLamp"}

function _G.CJ_Optimizer:Toggle(state)
    if state then
        -- 1. EXTREME LIGHTING & NIGHT MODE
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
        
        -- Matikan Efek Post-Processing
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostProcessEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
                effect.Enabled = false
            end
        end

        -- 2. HAPUS FOLDER BERAT (Berdasarkan Scan kamu)
        for _, name in pairs(targets) do
            local folder = Workspace:FindFirstChild(name)
            if folder then
                originalData[folder] = {Parent = folder.Parent}
                folder.Parent = nil -- Menghilangkan Hutan, Sawah, Booth, Lampu, & Mirror Screen
            end
        end

        -- 3. OPTIMASI SISA PART (Kecuali Avatar)
        for _, v in pairs(Workspace:GetDescendants()) do
            if not v:FindFirstAncestorOfClass("Humanoid") then
                if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    -- Matikan Texture yang tersisa & Paksa Plastik
                    if v:IsA("MeshPart") then v.TextureID = "" end
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Light") then
                    v.Enabled = false
                end
            end
        end
        print("CJ Hub: GOD MODE ON - Hutan, Sawah, Booth, StageLamp & Mirror Dihilangkan.")
    else
        -- KEMBALIKAN SEMUA
        Lighting.GlobalShadows = true
        Lighting.ClockTime = 12
        Lighting.Brightness = 2

        -- Munculkan kembali folder yang dihilangkan
        for folder, data in pairs(originalData) do
            if folder then folder.Parent = data.Parent end
        end
        
        -- Reset material (Simple way: Rejoin atau manual reset jika perlu detail)
        table.clear(originalData)
        print("CJ Hub: GOD MODE OFF - Menunggu Rejoin untuk reset material total.")
    end
end

return _G.CJ_Optimizer
