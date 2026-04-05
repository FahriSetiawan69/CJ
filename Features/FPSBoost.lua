-- [[ CJ Optimizer - ABSOLUTE PRECISION MODE ]] --
_G.CJ_Optimizer = {}

local originalData = {}
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Folder Target Hasil Scan
local heavyFolders = {"HUTAN", "Object", "BOOTH", "Screen", "StageLamp"}

-- Fungsi Proteksi Avatar
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
        -- 1. LIGHTING & ATMOSPHERE
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 0
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)

        -- 2. PEMBERSIHAN TARGET SPESIFIK (Hutan, Mirror, Sawah, StageLamp)
        for _, name in pairs(heavyFolders) do
            local folder = Workspace:FindFirstChild(name)
            if folder then
                for _, obj in pairs(folder:GetDescendants()) do
                    -- Sembunyikan Part & MeshPart (Termasuk Trunk, MonitorPart2, dan Am)
                    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                        originalData[obj] = {
                            Transparency = obj.Transparency,
                            Material = obj.Material
                        }
                        obj.Transparency = 1 -- Visual Hilang
                        obj.Material = Enum.Material.SmoothPlastic
                        
                        -- Kosongkan Tekstur Mesh (Penting untuk Trunk dan Lampu Stage)
                        if obj:IsA("MeshPart") then
                            obj.TextureID = ""
                        end
                    
                    -- Matikan Mirror/Layar & GUI
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("ViewportFrame") then
                        obj.Enabled = false
                        
                    -- Matikan Lampu & Partikel
                    elseif obj:IsA("Light") or obj:IsA("ParticleEmitter") then
                        obj.Enabled = false
                    end
                end
            end
        end

        -- 3. GLOBAL SWEEP (Target Berdasarkan Nama)
        for _, v in pairs(Workspace:GetDescendants()) do
            if not isPlayer(v) then
                -- Menangani part spesifik yang mungkin terlewat di folder
                if v.Name == "MonitorPart2" or v.Name == "Trunk" or v.Name == "Am" then
                    v.Transparency = 1
                    if v:IsA("MeshPart") then v.TextureID = "" end
                    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
                end
                
                -- Mematikan Mirror cadangan
                if v:IsA("ViewportFrame") then v.Enabled = false end
            end
        end
        print("CJ Hub: Absolute Boost ON - Trunk, MonitorPart2, and StageLamp (Am) Hidden.")
    else
        -- KEMBALIKAN SEMUA KE NORMAL
        for obj, props in pairs(originalData) do
            if obj and obj.Parent then
                obj.Transparency = props.Transparency
                obj.Material = props.Material
            end
        end
        
        -- Aktifkan kembali GUI & Lampu
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("SurfaceGui") or v:IsA("ViewportFrame") or v:IsA("Light") or v:IsA("ParticleEmitter") then
                v.Enabled = true
            end
        end
        
        table.clear(originalData)
        print("CJ Hub: Absolute Boost OFF.")
    end
end

return _G.CJ_Optimizer
