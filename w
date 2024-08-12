--// UI \\--

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
  Title = "🌚ASTRO.CC🌚",
  Center = true,
  AutoShow = true,
  TabPadding = 8,
  MenuFadeTime = 0.2
})

local Tabs = {
    ['Combat'] = Window:AddTab('Combat'),
    ['Visuals'] = Window:AddTab('Visuals'),
    ['Misc'] = Window:AddTab('Misc'),
    ['Credits'] = Window:AddTab('Credits'),
    ['UI Settings'] = Window:AddTab('Configs'),
}





--// COMBAT \\--
local TabBox = Tabs.Combat:AddLeftTabbox()
local ExploitsTab = TabBox:AddTab('EXPLOITS')


  local BoxESP = {}
  function BoxESP.Create(Player)
      local Box = Drawing.new("Square")
      Box.Visible = false
      Box.Color = Color3.fromRGB(194, 17, 17)
      Box.Filled = false
      Box.Transparency = 0.50
      Box.Thickness = 2

      local DistanceLabel = Drawing.new("Text")
      DistanceLabel.Visible = false
      DistanceLabel.Size = 12
      DistanceLabel.Color = Color3.fromRGB(202, 37, 37)  -- Color blanco para el texto
      DistanceLabel.Center = true
      DistanceLabel.Outline = true

      local Updater

      local function UpdateBox()
          if Player and Player:IsA("Model") and Player:FindFirstChild("HumanoidRootPart") and Player:FindFirstChild("Head") then
              local HumanoidRootPart = Player.HumanoidRootPart
              local Head = Player.Head
              local Camera = workspace.CurrentCamera

              -- Calcular la distancia
              local Distance = (Camera.CFrame.p - HumanoidRootPart.Position).magnitude
              local DistanceText = string.format("%.1f m", Distance)

              -- Actualizar la caja y el texto de distancia
              local Target2dPosition, IsVisible = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
              local scale_factor = 1 / (Target2dPosition.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
              local width, height = math.floor(40 * scale_factor), math.floor(62 * scale_factor)

              Box.Visible = IsVisible
              Box.Size = Vector2.new(width, height)
              Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2, Target2dPosition.Y - Box.Size.Y / 2)

              DistanceLabel.Visible = IsVisible
              DistanceLabel.Position = Vector2.new(Target2dPosition.X, Target2dPosition.Y + Box.Size.Y / 2 + 10)
              DistanceLabel.Text = DistanceText
          else
              Box.Visible = false
              DistanceLabel.Visible = false
              if not Player then
                  Box:Remove()
                  DistanceLabel:Remove()
                  Updater:Disconnect()
              end
          end
      end

      Updater = game:GetService("RunService").RenderStepped:Connect(UpdateBox)

      return Box, DistanceLabel
  end

  local Boxes = {}

  local function EnableBoxESP()
      for _, Player in pairs(game:GetService("Workspace"):GetChildren()) do
          if Player:IsA("Model") and Player:FindFirstChild("HumanoidRootPart") and Player:FindFirstChild("Head") then
              local Box, DistanceLabel = BoxESP.Create(Player)
              table.insert(Boxes, {Box = Box, DistanceLabel = DistanceLabel})
          end
      end
  end

  game.Workspace.DescendantAdded:Connect(function(i)
      if i:IsA("Model") and i:FindFirstChild("HumanoidRootPart") and i:FindFirstChild("Head") then
          local Box, DistanceLabel = BoxESP.Create(i)
          table.insert(Boxes, {Box = Box, DistanceLabel = DistanceLabel})
      end
  end)




--// CREDITS \\--




Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(("🌚ASTRO.CC🌚 | Build: PAID | Game: Trident Survival"):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddRightGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddButton("Rejoin Server", function()
    Library:Notify("Rejoining", 30)
    wait(1)
    local ts = game:GetService("TeleportService")
    local p = game:GetService("Players").LocalPlayer
    ts:Teleport(game.PlaceId, p)
end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'K', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddDivider()
local playerCountLabel = MenuGroup:AddLabel("Player Count: 0", nil, true)
local function updatePlayerCount()
local playerCount = #game:GetService("Players"):GetPlayers()
playerCountLabel:SetText("Players Online : " .. playerCount)
end
game:GetService("Players").PlayerAdded:Connect(updatePlayerCount)
game:GetService("Players").PlayerRemoving:Connect(updatePlayerCount)
updatePlayerCount()
MenuGroup:AddDivider()
MenuGroup:AddLabel('Credits', true)
MenuGroup:AddLabel('Made by 🌚ASTRO🌚', true)
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('🌚ASTRO.CC🌚')
SaveManager:SetFolder('🌚ASTRO.CC🌚/TRIDENT SURVIVAL')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
wait(0)Library:Notify("Thanks for using 🌚ASTRO.CC🌚")
wait(0)Library:Notify("Status : 🟢Undetected")
