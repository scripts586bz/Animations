-- Script Lua para Roblox (LocalScript)
-- Colócalo en StarterPlayer > StarterPlayerScripts
-- Crea un GUI con botones para cambiar paquetes de animaciones: Ninja, Toy, Zombies y Desactivar (default)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local packs = {
    ninja = {
        idle = {656117400, 656118341, 886742569},
        run = 656118852,
        walk = 656121766,
        jump = 656117878,
        fall = 656115606,
        climb = 656114359,
        swim = 656119721,
        swimidle = 656121397
    },
    toy = {
        idle = {782841498, 782845736, 980952228},
        run = 782842708,
        walk = 782843345,
        jump = 782847020,
        fall = 782846423,
        climb = 782843869,
        swim = 782844582,
        swimidle = 782845186
    },
    zombies = {
        idle = {616158929, 616160636, 885545458},
        run = 616163682,
        walk = 616168032,
        jump = 616161997,
        fall = 616157476,
        climb = 616156119,
        swim = 616165109,
        swimidle = 616166655
    }
}

local originals = {}
local currentGui = nil

local function getId(anim)
    return tonumber(anim.AnimationId:match("%d+")) or 0
end

local function setId(anim, id)
    if anim then
        anim.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

local function saveOriginals(animate)
    originals.idle = {
        getId(animate.idle.Animation1),
        getId(animate.idle.Animation2),
        getId(animate.idle.Animation3)
    }
    originals.run = getId(animate.run.RunAnim)
    originals.walk = getId(animate.walk.WalkAnim)
    originals.jump = getId(animate.jump.JumpAnim)
    originals.fall = getId(animate.fall.FallAnim)
    originals.climb = getId(animate.climb.ClimbAnim)
    originals.swim = getId(animate.swim.SwimAnim)
    originals.swimidle = getId(animate.swimidle.SwimIdleAnim)
end

local function applyPack(packName)
    local char = player.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    local idleFolder = animate:FindFirstChild("idle")
    local runFolder = animate:FindFirstChild("run")
    local walkFolder = animate:FindFirstChild("walk")
    local jumpFolder = animate:FindFirstChild("jump")
    local fallFolder = animate:FindFirstChild("fall")
    local climbFolder = animate:FindFirstChild("climb")
    local swimFolder = animate:FindFirstChild("swim")
    local swimidleFolder = animate:FindFirstChild("swimidle")

    if not idleFolder or not runFolder then return end -- Básico requerido

    if packName == "default" then
        -- Restaurar originales
        setId(idleFolder.Animation1, originals.idle[1])
        setId(idleFolder.Animation2, originals.idle[2])
        setId(idleFolder.Animation3, originals.idle[3])
        setId(runFolder.RunAnim, originals.run)
        setId(walkFolder.WalkAnim, originals.walk)
        setId(jumpFolder.JumpAnim, originals.jump)
        setId(fallFolder.FallAnim, originals.fall)
        setId(climbFolder.ClimbAnim, originals.climb)
        if swimFolder then setId(swimFolder.SwimAnim, originals.swim) end
        if swimidleFolder then setId(swimidleFolder.SwimIdleAnim, originals.swimidle) end
    else
        local p = packs[packName]
        if not p then return end

        -- Idles (3)
        local idles = p.idle
        setId(idleFolder.Animation1, idles[1])
        setId(idleFolder.Animation2, idles[2] or idles[1])
        setId(idleFolder.Animation3, idles[3] or idles[1])

        -- Otros
        setId(runFolder.RunAnim, p.run)
        setId(walkFolder.WalkAnim, p.walk)
        setId(jumpFolder.JumpAnim, p.jump)
        setId(fallFolder.FallAnim, p.fall)
        setId(climbFolder.ClimbAnim, p.climb)
        if swimFolder and p.swim then setId(swimFolder.SwimAnim, p.swim) end
        if swimidleFolder and p.swimidle then setId(swimidleFolder.SwimIdleAnim, p.swimidle) end
    end
end

local function createGui()
    if currentGui then currentGui:Destroy() end

    currentGui = Instance.new("ScreenGui")
    currentGui.Name = "AnimationPacksGui"
    currentGui.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Size = UDim2.new(0, 180, 0, 160)
    frame.Position = UDim2.new(0, 10, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = currentGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Paquetes Animaciones"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = frame

    local buttons = {
        {text = "ninja", pack = "ninja"},
        {text = "toy", pack = "toy"},
        {text = "zombies", pack = "zombies"},
        {text = "desactivar", pack = "default"}
    }

    for i, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Name = btnData.text
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, 35 + (i-1)*35)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Text = btnData.text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = frame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            applyPack(btnData.pack)
        end)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
    end

    -- Hacer draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Inicializar GUI
createGui()

-- Manejar respawns
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Animate")
    local animate = char.Animate
    saveOriginals(animate)
end)

-- Guardar originales en el primer spawn
if player.Character then
    local animate = player.Character:FindFirstChild("Animate")
    if animate then
        saveOriginals(animate)
    end
end

print("¡Script de paquetes de animaciones cargado! Usa los botones para cambiar.")<grok:render card_id="2e8e03" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">82</argument></grok:render><grok:render card_id="08bff2" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">71</argument></grok:render>
