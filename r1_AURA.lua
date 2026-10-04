--[[
    =======================================================
        26 АУР - VFX MENU (Delta / Roblox Luau)
        Мягкая версия: без "ураганов", комфортные ауры.
        Полностью ЛОКАЛЬНЫЙ визуал. Только для себя.
    =======================================================
]]

-- =============== SERVICES ===============
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- =============== SOFT SETTINGS ===============
local SOFT = {
    rate     = 0.55,
    speed    = 0.55,
    size     = 0.65,
    light    = 0.65,
    range    = 0.75,
    emission = 0.75,
    spread   = 0.45,
}

-- =============== STATE ===============
local State = {
    currentAura   = nil,
    auraObjects   = {},
    conns         = {},
    lastApply     = 0,
    DEBOUNCE      = 0.15,
}

-- =============== 26 АУР ===============
local AURAS = {
    { name = "АУРА ВОЗДУХА",               color = Color3.fromRGB(200, 230, 255), type = "air"       },
    { name = "КАРТА (КРАСНЫЙ)",            color = Color3.fromRGB(255,  40,  40), type = "screen"    },
    { name = "КАРТА (СИНИЙ)",              color = Color3.fromRGB( 40, 120, 255), type = "screen"    },
    { name = "КАСТОМ (ЧЁРНАЯ)",            color = Color3.fromRGB( 25,  25,  25), type = "smoke"     },
    { name = "КАСТОМ (СИНЯЯ)",             color = Color3.fromRGB(  0,  90, 255), type = "smoke"     },
    { name = "КАСТОМ (КРАСНАЯ)",           color = Color3.fromRGB(255,   0,   0), type = "smoke"     },
    { name = "АУРА ОГНЯ",                  color = Color3.fromRGB(255, 100,   0), type = "fire"      },
    { name = "АУРА ЛЬДА",                  color = Color3.fromRGB(150, 220, 255), type = "ice"       },
    { name = "АУРА МОЛНИИ",                color = Color3.fromRGB(255, 255, 100), type = "lightning" },
    { name = "АУРА ТЬМЫ",                  color = Color3.fromRGB( 80,   0, 120), type = "dark"      },
    { name = "АУРА СВЕТА",                 color = Color3.fromRGB(255, 220, 100), type = "light"     },
    { name = "АУРА КРОВИ",                 color = Color3.fromRGB(150,   0,   0), type = "blood"     },
    { name = "АУРА ТОКСИЧНОСТИ",           color = Color3.fromRGB(100, 255,  50), type = "toxic"     },
    { name = "АУРА КОСМОСА",               color = Color3.fromRGB( 50,  50, 150), type = "space"     },
    { name = "АУРА РАДУГИ",                color = Color3.fromRGB(255,   0, 255), type = "rainbow"   },
    { name = "АУРА ПРИЗРАКА",              color = Color3.fromRGB(220, 220, 255), type = "ghost"     },
    { name = "АУРА ДЕМОНА",                color = Color3.fromRGB(200,   0,   0), type = "demon"     },
    { name = "АУРА АНГЕЛА",                color = Color3.fromRGB(255, 240, 200), type = "angel"     },
    { name = "АУРА ДРАКОНА",               color = Color3.fromRGB(255, 150,   0), type = "dragon"    },
    { name = "АУРА ВАМПИРА",               color = Color3.fromRGB(120,   0,  30), type = "vampire"   },
    { name = "АУРА НЕОНА",                 color = Color3.fromRGB(255,   0, 200), type = "neon"      },
    { name = "АУРА МАТРИЦЫ",               color = Color3.fromRGB(  0, 255,   0), type = "matrix"    },
    { name = "АУРА ГАЛАКТИКИ",             color = Color3.fromRGB(120,   0, 200), type = "galaxy"    },
    { name = "АУРА ЗОЛОТА",                color = Color3.fromRGB(255, 215,   0), type = "gold"      },
    { name = "АУРА ХАОСА",                 color = Color3.fromRGB(255, 255, 255), type = "chaos"     },
    { name = "АУРА ДИЛДАКОВ",              color = Color3.fromRGB(255, 105, 180), type = "hearts"    },
}

-- =============== UI PARENT ===============
local function getParentGui()
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return player:WaitForChild("PlayerGui")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AuraMenu_26"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = getParentGui()

-- Кнопка открытия
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 60, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 48)
openBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
openBtn.Text = "АУРЫ"
openBtn.TextSize = 14
openBtn.Font = Enum.Font.GothamBold
openBtn.BorderSizePixel = 0
openBtn.AutoButtonColor = false
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openBtn

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(120, 160, 255)
openStroke.Thickness = 2
openStroke.Parent = openBtn

-- Меню
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 320, 0, 520)
menu.Position = UDim2.new(0, 90, 0.5, -260)
menu.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Active = true
menu.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 14)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(80, 100, 200)
menuStroke.Thickness = 1.5
menuStroke.Transparency = 0.3
menuStroke.Parent = menu

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 42)
title.BackgroundTransparency = 1
title.Text = "ВЫБОР АУРЫ (26)"
title.TextColor3 = Color3.fromRGB(200, 230, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 180, 220)
closeBtn.Text = "X"
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = menu

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- Скролл
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 160, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, #AURAS * 46 + 10)
scroll.Parent = menu

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

-- Кнопка ВЫКЛ
local offBtn = Instance.new("TextButton")
offBtn.Size = UDim2.new(1, -20, 0, 36)
offBtn.Position = UDim2.new(0, 10, 1, -46)
offBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
offBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
offBtn.Text = "ВЫКЛЮЧИТЬ АУРУ"
offBtn.TextSize = 14
offBtn.Font = Enum.Font.GothamBold
offBtn.BorderSizePixel = 0
offBtn.AutoButtonColor = false
offBtn.Parent = menu

local offCorner = Instance.new("UICorner")
offCorner.CornerRadius = UDim.new(0, 8)
offCorner.Parent = offBtn

local offStroke = Instance.new("UIStroke")
offStroke.Color = Color3.fromRGB(255, 100, 100)
offStroke.Thickness = 1
offStroke.Parent = offBtn

-- Кнопки аур
local auraButtons = {}

for i, aura in ipairs(AURAS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 38)
    btn.TextColor3 = aura.color
    btn.Text = string.format("%02d. %s", i, aura.name)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.Parent = scroll

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = aura.color
    bStroke.Thickness = 1
    bStroke.Transparency = 0.7
    bStroke.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn

    auraButtons[i] = { button = btn, stroke = bStroke, base = Color3.fromRGB(22, 22, 38) }
end

-- =============== HELPERS ===============
local function clearAuras()
    for _, obj in ipairs(State.auraObjects) do
        if obj and obj.Parent then
            pcall(function() obj:Destroy() end)
        end
    end
    State.auraObjects = {}

    for _, c in ipairs(State.conns) do
        if c and c.Disconnect then pcall(function() c:Disconnect() end) end
    end
    State.conns = {}
end

local function track(obj)
    table.insert(State.auraObjects, obj)
    return obj
end

local function mkAttachment(hrp, offsetY)
    local a = Instance.new("Attachment")
    a.Position = Vector3.new(0, offsetY or 0, 0)
    a.Parent = hrp
    return track(a)
end

local function mkParticles(parent, color, size, rate, speed, life, emission)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new(color)
    local s = size * SOFT.size
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, s),
        NumberSequenceKeypoint.new(0.5, s * 1.2),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.45),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(life, life * 1.3)
    p.Rate = math.max(5, math.floor(rate * SOFT.rate))
    p.Speed = NumberRange.new(speed * SOFT.speed * 0.5, speed * SOFT.speed)
    p.SpreadAngle = Vector2.new(180 * SOFT.spread, 180 * SOFT.spread)
    p.Rotation = NumberRange.new(-180, 180)
    p.RotSpeed = NumberRange.new(-60, 60)
    p.LightEmission = (emission or 0.5) * SOFT.emission
    p.LightInfluence = 0
    p.Parent = parent
    return track(p)
end

local function mkLight(parent, color, range, brightness)
    local l = Instance.new("PointLight")
    l.Color = color
    l.Range = math.floor(range * SOFT.range)
    l.Brightness = brightness * SOFT.light
    l.Shadows = false
    l.Parent = parent
    return track(l)
end

local function mkHighlight(char, fill, outline, transp)
    local h = Instance.new("Highlight")
    h.FillColor = fill
    h.OutlineColor = outline
    h.FillTransparency = transp or 0.75
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = char
    return track(h)
end

local function genericAura(char, hrp, color, opts)
    opts = opts or {}
    local att = mkAttachment(hrp, opts.offsetY or -1)
    local p = mkParticles(
        att,
        color,
        opts.size or 2.5,
        opts.rate or 40,
        opts.speed or 4,
        opts.life or 1.5,
        opts.emission or 0.6
    )
    if opts.accel then p.Acceleration = opts.accel end

    mkLight(hrp, color, opts.lightRange or 20, opts.lightBright or 2)
    mkHighlight(char, color, color, opts.transp or 0.7)
end

-- =============== ФАБРИКА АУР ===============
local AuraFactory = {}

-- 1. ВОЗДУХ
AuraFactory.air = function(char, hrp, color)
    local att = mkAttachment(hrp, -1.5)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 210, 255)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 2),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.65),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(1.5, 2)
    p.Rate = 25
    p.Speed = NumberRange.new(1, 3)
    p.Rotation = NumberRange.new(-180, 180)
    p.RotSpeed = NumberRange.new(-45, 45)
    p.SpreadAngle = Vector2.new(35, 35)
    p.Acceleration = Vector3.new(0, 2, 0)
    p.LightEmission = 0.3
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    local att2 = mkAttachment(hrp, 0)
    local p2 = Instance.new("ParticleEmitter")
    p2.Color = ColorSequence.new(Color3.fromRGB(230, 245, 255))
    p2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    p2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1),
    })
    p2.Lifetime = NumberRange.new(1.8, 2.4)
    p2.Rate = 12
    p2.Speed = NumberRange.new(0.5, 1.5)
    p2.Rotation = NumberRange.new(-360, 360)
    p2.RotSpeed = NumberRange.new(-90, 90)
    p2.SpreadAngle = Vector2.new(180, 180)
    p2.Shape = Enum.ParticleEmitterShape.Sphere
    p2.ShapeInOut = Enum.ParticleEmitterShapeInOut.OuterSphere
    p2.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
    p2.LightEmission = 0.2
    p2.LightInfluence = 0
    p2.Parent = att2
    track(p2)

    mkLight(hrp, Color3.fromRGB(200, 230, 255), 18, 1.5)
    mkHighlight(char, Color3.fromRGB(230, 245, 255), Color3.fromRGB(255, 255, 255), 0.9)
end

-- 2-3. КАРТА
AuraFactory.screen = function(char, hrp, color)
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = color
    overlay.BackgroundTransparency = 0.75
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 100
    overlay.Parent = screenGui

    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.3),
    })
    grad.Parent = overlay

    track(overlay)
end

-- 4-6. КАСТОМ
AuraFactory.smoke = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new(color)
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.3, 4),
        NumberSequenceKeypoint.new(1, 6),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.7, 0.7),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(2, 3)
    p.Rate = 22
    p.Speed = NumberRange.new(1, 2.5)
    p.SpreadAngle = Vector2.new(60, 60)
    p.Rotation = NumberRange.new(-180, 180)
    p.RotSpeed = NumberRange.new(-40, 40)
    p.LightEmission = 0.2
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, color, 16, 1.5)
    mkHighlight(char, color, color, 0.8)
end

-- 7. ОГОНЬ
AuraFactory.fire = function(char, hrp, color)
    local att = mkAttachment(hrp, -2)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 180, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 0)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(0.5, 3),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(0.7, 1.2)
    p.Rate = 55
    p.Speed = NumberRange.new(3, 7)
    p.SpreadAngle = Vector2.new(12, 12)
    p.Acceleration = Vector3.new(0, 6, 0)
    p.LightEmission = 0.8
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, Color3.fromRGB(255, 120, 30), 22, 3)
    mkHighlight(char, Color3.fromRGB(255, 120, 0), Color3.fromRGB(255, 220, 100), 0.65)
end

-- 8. ЛЁД
AuraFactory.ice = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 230, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(0.4, 2.8),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(1.5, 2.5)
    p.Rate = 30
    p.Speed = NumberRange.new(1, 3)
    p.SpreadAngle = Vector2.new(180, 180)
    p.Rotation = NumberRange.new(-360, 360)
    p.RotSpeed = NumberRange.new(-90, 90)
    p.Shape = Enum.ParticleEmitterShape.Box
    p.ShapeInOut = Enum.ParticleEmitterShapeInOut.OuterBox
    p.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    p.LightEmission = 0.5
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, color, 20, 2)
    mkHighlight(char, Color3.fromRGB(180, 230, 255), Color3.fromRGB(255, 255, 255), 0.75)
end

-- 9. МОЛНИЯ
AuraFactory.lightning = function(char, hrp, color)
    local att = mkAttachment(hrp, 0)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 255)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 1.6),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new(0.5)
    p.Lifetime = NumberRange.new(0.3, 0.5)
    p.Rate = 45
    p.Speed = NumberRange.new(4, 9)
    p.SpreadAngle = Vector2.new(60, 60)
    p.LightEmission = 0.85
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, color, 20, 3)
    mkHighlight(char, Color3.fromRGB(255, 255, 150), Color3.fromRGB(255, 255, 255), 0.65)
end

-- 10. ТЬМА
AuraFactory.dark = function(char, hrp, color)
    genericAura(char, hrp, color, {
        size = 3, rate = 35, speed = 2.5, life = 2,
        emission = 0.4, lightRange = 18, lightBright = 1.8,
        transp = 0.8, accel = Vector3.new(0, 1, 0),
    })
end

-- 11. СВЕТ
AuraFactory.light = function(char, hrp, color)
    local att = mkAttachment(hrp, -0.5)
    mkParticles(att, color, 2.5, 35, 3, 1.5, 0.7)
    mkLight(hrp, color, 24, 3)
    mkHighlight(char, color, Color3.fromRGB(255, 255, 200), 0.6)
end

-- 12. КРОВЬ
AuraFactory.blood = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2, 35, 5, 1.2, 0.5)
    p.Acceleration = Vector3.new(0, -20, 0)
    p.SpreadAngle = Vector2.new(30, 30)

    mkLight(hrp, color, 16, 1.5)
    mkHighlight(char, Color3.fromRGB(150, 0, 0), Color3.fromRGB(80, 0, 0), 0.75)
end

-- 13. ТОКСИЧНОСТЬ
AuraFactory.toxic = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2.5, 45, 3, 1.8, 0.7)
    p.Acceleration = Vector3.new(0, 1.5, 0)

    mkLight(hrp, color, 18, 2.5)
    mkHighlight(char, color, Color3.fromRGB(180, 255, 100), 0.7)
end

-- 14. КОСМОС
AuraFactory.space = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(160, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 120)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new(0.5)
    p.Lifetime = NumberRange.new(2, 3.5)
    p.Rate = 30
    p.Speed = NumberRange.new(0.5, 2)
    p.SpreadAngle = Vector2.new(180, 180)
    p.LightEmission = 0.6
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, Color3.fromRGB(100, 80, 200), 20, 2)
    mkHighlight(char, Color3.fromRGB(120, 80, 220), Color3.fromRGB(200, 180, 255), 0.8)
end

-- 15. РАДУГА
AuraFactory.rainbow = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2.5, 40, 4, 1.5, 0.6)

    local light = mkLight(hrp, color, 20, 2.5)
    local hl = mkHighlight(char, color, color, 0.7)

    table.insert(State.conns, RunService.RenderStepped:Connect(function()
        local t = tick() * 0.3
        local c1 = Color3.fromHSV(t % 1, 0.8, 1)
        local c2 = Color3.fromHSV((t + 0.5) % 1, 0.8, 1)
        if p.Parent then p.Color = ColorSequence.new(c1) end
        if light.Parent then light.Color = c2 end
        if hl.Parent then
            hl.FillColor = c1
            hl.OutlineColor = c2
        end
    end))
end

-- 16. ПРИЗРАК
AuraFactory.ghost = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 3, 25, 2, 2.5, 0.35)
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(1, 1),
    })

    mkLight(hrp, color, 16, 1.5)
    mkHighlight(char, Color3.fromRGB(230, 230, 255), Color3.fromRGB(255, 255, 255), 0.9)
end

-- 17. ДЕМОН
AuraFactory.demon = function(char, hrp, color)
    local att = mkAttachment(hrp, -1.5)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 0)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 4),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(1.5, 2.5)
    p.Rate = 35
    p.Speed = NumberRange.new(1.5, 3)
    p.SpreadAngle = Vector2.new(90, 90)
    p.LightEmission = 0.6
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, Color3.fromRGB(200, 0, 0), 22, 3)
    mkHighlight(char, Color3.fromRGB(150, 0, 0), Color3.fromRGB(255, 40, 40), 0.65)
end

-- 18. АНГЕЛ
AuraFactory.angel = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2.5, 40, 3.5, 2, 0.6)
    p.Acceleration = Vector3.new(0, 4, 0)

    mkLight(hrp, Color3.fromRGB(255, 240, 200), 24, 3)
    mkHighlight(char, Color3.fromRGB(255, 250, 220), Color3.fromRGB(255, 215, 100), 0.65)
end

-- 19. ДРАКОН
AuraFactory.dragon = function(char, hrp, color)
    local att = mkAttachment(hrp, -1.5)
    local p = mkParticles(att, color, 3, 50, 6, 1.5, 0.85)
    p.SpreadAngle = Vector2.new(20, 20)
    p.Acceleration = Vector3.new(0, 4, 0)

    mkLight(hrp, Color3.fromRGB(255, 150, 0), 24, 3.5)
    mkHighlight(char, Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 220, 100), 0.6)
end

-- 20. ВАМПИР
AuraFactory.vampire = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2, 30, 3, 1.8, 0.5)

    mkLight(hrp, Color3.fromRGB(120, 0, 30), 18, 2)
    mkHighlight(char, Color3.fromRGB(90, 0, 20), Color3.fromRGB(200, 0, 50), 0.75)
end

-- 21. НЕОН
AuraFactory.neon = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2, 45, 4, 1.2, 0.8)

    mkLight(hrp, color, 22, 3)
    mkHighlight(char, color, Color3.fromRGB(255, 200, 255), 0.55)
end

-- 22. МАТРИЦА
AuraFactory.matrix = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 1.5, 40, 3, 1.5, 0.8)
    p.Acceleration = Vector3.new(0, -4, 0)
    p.Shape = Enum.ParticleEmitterShape.Box
    p.ShapeInOut = Enum.ParticleEmitterShapeInOut.OuterBox
    p.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume

    mkLight(hrp, color, 18, 2)
    mkHighlight(char, Color3.fromRGB(0, 255, 0), Color3.fromRGB(150, 255, 150), 0.75)
end

-- 23. ГАЛАКТИКА
AuraFactory.galaxy = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = Instance.new("ParticleEmitter")
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(120, 0, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 0, 80)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 2.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new(0.45)
    p.Lifetime = NumberRange.new(2, 3.5)
    p.Rate = 40
    p.Speed = NumberRange.new(0.5, 2)
    p.SpreadAngle = Vector2.new(180, 180)
    p.LightEmission = 0.7
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, Color3.fromRGB(150, 0, 255), 22, 2.5)
    mkHighlight(char, Color3.fromRGB(140, 60, 220), Color3.fromRGB(255, 200, 255), 0.7)
end

-- 24. ЗОЛОТО
AuraFactory.gold = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2.5, 40, 3.5, 1.6, 0.75)

    mkLight(hrp, color, 22, 3)
    mkHighlight(char, color, Color3.fromRGB(255, 250, 180), 0.6)
end

-- 25. ХАОС
AuraFactory.chaos = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = mkParticles(att, color, 2.5, 45, 4, 1.2, 0.7)

    local light = mkLight(hrp, color, 20, 2.5)
    local hl = mkHighlight(char, color, color, 0.6)

    table.insert(State.conns, RunService.RenderStepped:Connect(function()
        local c = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        if p.Parent then p.Color = ColorSequence.new(c) end
        if light.Parent then light.Color = c end
        if hl.Parent then
            hl.FillColor = c
            hl.OutlineColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        end
    end))
end

-- 26. ДИЛДАКОВ
AuraFactory.hearts = function(char, hrp, color)
    local att = mkAttachment(hrp, -1)
    local p = Instance.new("ParticleEmitter")
    p.Texture = "rbxassetid://6855087706"
    p.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147)),
    })
    p.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(0.5, 3),
        NumberSequenceKeypoint.new(1, 0),
    })
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Lifetime = NumberRange.new(2, 3)
    p.Rate = 30
    p.Speed = NumberRange.new(2, 4)
    p.SpreadAngle = Vector2.new(60, 60)
    p.Rotation = NumberRange.new(-30, 30)
    p.RotSpeed = NumberRange.new(-30, 30)
    p.LightEmission = 0.5
    p.LightInfluence = 0
    p.Parent = att
    track(p)

    mkLight(hrp, Color3.fromRGB(255, 105, 180), 20, 2.5)
    mkHighlight(char, Color3.fromRGB(255, 150, 200), Color3.fromRGB(255, 220, 240), 0.65)
end

-- =============== ПРИМЕНЕНИЕ АУРЫ ===============
local function applyAura(index)
    local now = tick()
    if now - State.lastApply < State.DEBOUNCE then return end
    State.lastApply = now

    local aura = AURAS[index]
    if not aura then return end

    clearAuras()
    State.currentAura = index

    for i, data in pairs(auraButtons) do
        if i == index then
            TweenService:Create(data.button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(60, 30, 80),
            }):Play()
            data.stroke.Transparency = 0
        else
            TweenService:Create(data.button, TweenInfo.new(0.15), {
                BackgroundColor3 = data.base,
            }):Play()
            data.stroke.Transparency = 0.7
        end
    end

    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local factory = AuraFactory[aura.type]
    if factory then
        pcall(factory, char, hrp, aura.color)
    else
        genericAura(char, hrp, aura.color)
    end
end

-- =============== UI ЛОГИКА ===============
for i, data in pairs(auraButtons) do
    data.button.MouseButton1Click:Connect(function()
        applyAura(i)
    end)
end

offBtn.MouseButton1Click:Connect(function()
    clearAuras()
    State.currentAura = nil
    for _, data in pairs(auraButtons) do
        TweenService:Create(data.button, TweenInfo.new(0.15), {
            BackgroundColor3 = data.base,
        }):Play()
        data.stroke.Transparency = 0.7
    end
end)

local function toggleMenu(show)
    if show == nil then
        menu.Visible = not menu.Visible
    else
        menu.Visible = show
    end
end

openBtn.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(function() toggleMenu(false) end)

-- =============== ПЕРЕТАСКИВАНИЕ ===============
do
    local dragging, dragStart, startPos

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = menu.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            menu.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- =============== МОБИЛЬНАЯ АДАПТАЦИЯ ===============
if UserInputService.TouchEnabled then
    openBtn.Size = UDim2.new(0, 80, 0, 50)
    openBtn.TextSize = 16
    menu.Size = UDim2.new(0, 340, 0.7, 0)
    menu.Position = UDim2.new(0.5, -170, 0.15, 0)
end

-- =============== ВОССТАНОВЛЕНИЕ ПОСЛЕ СМЕРТИ ===============
player.CharacterAdded:Connect(function()
    task.wait(1)
    if State.currentAura then
        local idx = State.currentAura
        State.currentAura = nil
        applyAura(idx)
    end
end)

print("[26 АУР] загружено | Мягкие ауры | Delta-ready ТГК КАНАЛ DELTA_ROBLOX_2")
