local VIOLA       = Color3.fromRGB(124, 58, 237)
local VIOLA_SCURO = Color3.fromRGB(30, 0, 60)
local VIOLA_MED   = Color3.fromRGB(80, 20, 160)
local BIANCO      = Color3.fromRGB(255, 255, 255)
local VIOLA_GLOW  = Color3.fromRGB(180, 100, 255)
local TweenService = game:GetService("TweenService")
local Players      = game:GetService("Players")

local SOSTITUZIONI = {
    ["[Pp][Rr][Oo][Dd][Ii][Gg][Yy]%s*[Hh][Uu][Bb]"] = "LEVON HUB",
    ["[Pp][Rr][Oo][Dd][Ii][Gg][Yy]"] = "LEVON",
    ["PRODIGY HUB"] = "LEVON HUB", ["Prodigy Hub"] = "Levon Hub",
    ["prodigy hub"] = "levon hub", ["prodigy"] = "levon",
    ["PRODIGY"] = "LEVON",
    ["[Tt]eleguiado"] = "Teleport",
    ["[Tt]eleguidado"] = "Teleport",
    ["[Tt]orna hit do 1[°º]%s*boss[,]?%s*from TP%.?"] = "Teleports to 1st boss and hits",
    ["[Tt]orna hit do 1[°º]%s*boss[,]?%s*da TP no%.?"] = "Teleports to 1st boss and hits",
    ["[Tt]orna hit do 1[°º]%s*boss"] = "Hit 1st boss",
    ["[Aa]lvo[:]?%s*[Aa]utom[aá]tico"] = "Target: Automatic",
    ["[Aa]lvo"] = "Target",
    ["[Aa]utom[aá]tico"] = "Automatic",
    ["[Cc]osmico"] = "Cosmic",
    ["[Pp]eso[:]?%s*"] = "Weight: ",
    ["[Cc]omum"] = "Common",
    ["[Ii]ncomum"] = "Uncommon",
    ["[Rr]aro"] = "Rare",
    ["[Ll][eé]ndario"] = "Legendary",
    ["[Ee]x[oó]tico"] = "Exotic",
    ["[Uu]ovo"] = "Egg",
    ["[Uu]ova"] = "Eggs",
    ["[Vv]elocidade"] = "Speed",
    ["[Aa]uto [Ff]azenda"] = "Auto Farm",
    ["[Ff]azenda"] = "Farm",
    ["[Pp]rincipal"] = "Main",
    ["[Ll]igado"] = "On",
    ["[Dd]esligado"] = "Off",
    ["[Mm]odalit[aà]%s*[Ll]enta"] = "Slow Mode",
    ["[Nn]egozio"] = "Shop",
    ["[Íí]ndice"] = "Index",
    ["[Ii]ndice"] = "Index",
    ["[Ss]econdi"] = "seconds",
    ["[Mm]inuti"] = "minutes",
    ["[Ss]econdo"] = "second",
    ["[Mm]inuto"] = "minute",
    ["in%s*(%d+)%s*secondi"] = function(n) return "in "..n.." seconds" end,
    ["in%s*(%d+)%s*minuti"] = function(n) return "in "..n.." minutes" end,
}

local titleLabel        = nil
local loopColoreLabelSet = {}
local billboardKillati  = {}
local guiAbbellita      = {}

local function avviaLoopColore(label)
    if loopColoreLabelSet[label] then return end
    loopColoreLabelSet[label] = true
    task.spawn(function()
        local t = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        while label and label.Parent do
            TweenService:Create(label, t, {TextColor3 = BIANCO}):Play()      task.wait(0.8)
            TweenService:Create(label, t, {TextColor3 = VIOLA_GLOW}):Play()  task.wait(0.8)
        end
        loopColoreLabelSet[label] = nil
    end)
end

local function killBillboard(bg)
    if billboardKillati[bg] then return end
    billboardKillati[bg] = true
    pcall(function() bg.Enabled = false end)
    for _, child in ipairs(bg:GetDescendants()) do
        if child:IsA("ImageLabel") or child:IsA("ImageButton") then
            pcall(function() child.Image = "" child.Visible = false child.BackgroundTransparency = 1 end)
        end
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            pcall(function() child.Text = "" child.Visible = false end)
        end
    end
    pcall(function()
        bg:GetPropertyChangedSignal("Enabled"):Connect(function()
            if bg.Enabled then pcall(function() bg.Enabled = false end) end
        end)
    end)
end

-- Abbellisce la ScreenGui del hub con bordo viola e angoli arrotondati
local function abbellisciGui(sg)
    if guiAbbellita[sg] then return end
    guiAbbellita[sg] = true
    task.spawn(function()
        task.wait(0.2)
        -- Bordo viola lampeggiante su tutti i Frame principali
        for _, obj in ipairs(sg:GetDescendants()) do
            pcall(function()
                if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                    -- Angoli arrotondati
                    if not obj:FindFirstChildOfClass("UICorner") then
                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(0, 8)
                        corner.Parent = obj
                    end
                    -- Bordo viola
                    if not obj:FindFirstChildOfClass("UIStroke") then
                        local stroke = Instance.new("UIStroke")
                        stroke.Color = VIOLA
                        stroke.Thickness = 1.5
                        stroke.Transparency = 0.3
                        stroke.Parent = obj
                        -- Anima il bordo
                        task.spawn(function()
                            local t = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                            while stroke and stroke.Parent do
                                TweenService:Create(stroke, t, {Transparency = 0.7, Color = VIOLA_GLOW}):Play()
                                task.wait(1.2)
                                TweenService:Create(stroke, t, {Transparency = 0.1, Color = VIOLA}):Play()
                                task.wait(1.2)
                            end
                        end)
                    end
                end
                -- Angoli sui pulsanti
                if obj:IsA("TextButton") then
                    if not obj:FindFirstChildOfClass("UICorner") then
                        local corner = Instance.new("UICorner")
                        corner.CornerRadius = UDim.new(0, 6)
                        corner.Parent = obj
                    end
                    if not obj:FindFirstChildOfClass("UIStroke") then
                        local stroke = Instance.new("UIStroke")
                        stroke.Color = VIOLA
                        stroke.Thickness = 1
                        stroke.Transparency = 0.4
                        stroke.Parent = obj
                    end
                end
            end)
        end
    end)
end

local function cambiaColoreSfondo(obj)
    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        local bg = obj.BackgroundColor3
        if bg.R < 0.15 and bg.G < 0.15 and bg.B < 0.15 and obj.BackgroundTransparency < 0.5 then
            pcall(function() obj.BackgroundColor3 = VIOLA_SCURO end)
        end
    end
end

local function modificaOggetto(obj)
    if obj:IsA("BillboardGui") then
        killBillboard(obj) return
    end

    cambiaColoreSfondo(obj)

    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        local nome = string.lower(obj.Name or "")
        if obj:FindFirstAncestorOfClass("BillboardGui") then
            pcall(function() obj.Image = "" obj.Visible = false end) return
        end
        local sg = obj:FindFirstAncestorOfClass("ScreenGui")
        if sg then
            local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pg and sg.Parent == pg then
                local parent = obj.Parent
                if parent then
                    for _, sib in ipairs(parent:GetChildren()) do
                        if sib:IsA("TextLabel") or sib:IsA("TextButton") then
                            local t = string.upper(sib.Text or "")
                            if string.find(t, "LEVON") or string.find(t, "PRODIGY") then
                                pcall(function() obj.Visible = false obj.Image = "" end) return
                            end
                        end
                    end
                    local badNames = {"prodigy","logo","brand","watermark","hublogo"}
                    for _, kw in ipairs(badNames) do
                        if string.find(nome, kw) then
                            pcall(function() obj.Visible = false obj.Image = "" end) return
                        end
                    end
                end
            end
        end
    end

    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local function aggiornaTesto()
            local testo = obj.Text
            if type(testo) ~= "string" or testo == "" then return end
            if string.find(testo, "discord%.gg") or string.find(testo, "http")
            or string.find(string.upper(testo), "DISCORD") then
                obj.Text = "" pcall(function() obj.Visible = false end) return
            end
            for p, r in pairs(SOSTITUZIONI) do
                testo = string.gsub(testo, p, r)
            end
            obj.Text = testo
            if string.find(string.upper(testo), "LEVON HUB") then
                avviaLoopColore(obj)
                titleLabel = obj
                -- Abbellisci la ScreenGui contenitore
                local sg = obj:FindFirstAncestorOfClass("ScreenGui")
                if sg then abbellisciGui(sg) end
            end
        end
        aggiornaTesto()
        pcall(function() obj:GetPropertyChangedSignal("Text"):Connect(aggiornaTesto) end)
    end
end

game.DescendantAdded:Connect(function(obj)
    pcall(function() modificaOggetto(obj) end)
end)

for _, obj in ipairs(game:GetDescendants()) do
    pcall(function() modificaOggetto(obj) end)
end

loadstring(game:HttpGet("https://herculesshield.discloud.app/api/v1/scripts/public/4437d0fa-1e1d-4ea1-ab2a-f7e6f528c8cd/download"))()

task.wait(1)
for _, obj in ipairs(game:GetDescendants()) do
    pcall(function() modificaOggetto(obj) end)
end
print("✅ [LEVON HUB] Attivo") warn("💜 OK")
