local BlockID = 41324903;

local screenGui = Instance.new("ScreenGui");
screenGui.Name = "ResponsiveUI";
screenGui.ResetOnSpawn = false;
screenGui.IgnoreGuiInset = true;
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");

local textBox = Instance.new("TextBox");
textBox.Name = "CornerTextBox";
textBox.Parent = screenGui;
textBox.Text = "Enter Block ID...";
textBox.TextColor3 = Color3.new(1, 1, 1);
textBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100);
textBox.Font = Enum.Font.SourceSans;
textBox.TextScaled = true;
textBox.ClearTextOnFocus = false;
textBox.PlaceholderText = "Enter Block ID...";
textBox.AnchorPoint = Vector2.new(1, 0);
textBox.Position = UDim2.new(1, -10, 0, 40);
textBox.Size = UDim2.new(0.25, 0, 0.08, 0);

local uiStroke = Instance.new("UIStroke");
uiStroke.Color = Color3.new(0, 0, 0);
uiStroke.Thickness = 2;
uiStroke.Parent = textBox;

local uicorner = Instance.new("UICorner");
uicorner.CornerRadius = UDim.new(0, 6);
uicorner.Parent = textBox;

textBox:GetPropertyChangedSignal("Text"):Connect(function()
	local currentText = textBox.Text;
    BlockID = tonumber(currentText);
end);

Instance.new("Hint", Workspace).Text = "KEYBINDS: F - FREEZE, Y - KILL MOUSE TARGET, H - ACTIVATE AURA, T - DELETE AURA, J - KILL ALL, L - SPAWN 50 SPIKES, P - SPAWN 50 STEEPLES, M - CRASH, K - BUILD BLOCK (upd)";
--//Services\\--
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local LPlayer = Players.LocalPlayer;
local Mouse = LPlayer:GetMouse();

--//Variables\\--
local Remotes: Folder = ReplicatedStorage.Remotes;
local StampAsset: RemoteFunction = Remotes.StampAsset;
local DeleteAsset: RemoteFunction = Remotes.DeleteAsset;

local ActiveParts: Folder;
local Plates: Model = Workspace.Plates;
local LPlate: Part;
local MSpikes = {};
local WV = {};

for _, Plate in pairs(Plates:GetChildren()) do
    if (Plate.Owner.Value == LPlayer) then
        LPlate = Plate.Plate;
        ActiveParts = Plate.ActiveParts;
        break;
    end;
end;

ActiveParts.ChildAdded:Connect(function(Block)
    if (Block.Name == "Spikes - Moving") then
        local MSpike = Block:WaitForChild("Spike_Retracting"):WaitForChild("Spikes");
        MSpikes[#MSpikes+1] = MSpike;
        Block.AncestryChanged:Wait();
        if (not Block.Parent) then
            table.remove(MSpikes, table.find(MSpikes, MSpike));
        end;
    end;
end);

ActiveParts.ChildAdded:Connect(function(Block)
    if (Block.Name == "Weathervane") then
        local WVPart = Block:WaitForChild("castleWeathervane"):WaitForChild("castleWeathervaneTop2b");
        WV[#WV+1] = WVPart;
        Block.AncestryChanged:Wait();
        if (not Block.Parent) then
            table.remove(WV, table.find(WV, VWPart));
        end;
    end;
end);

local Module = {};

function Module.Freeze(Part: Part)
    if (typeof(Part) == "Instance") then Part = {Part}; end;
    StampAsset:InvokeServer(
        56447956,
        LPlate.CFrame + Vector3.new(0, 12, 0),
        "{3ee17b14-c66d-4cdd-8500-3782d1dceab5}",
        Part,
        0
    );
end;

function Module.Weld(...)
    StampAsset:InvokeServer(
        41324904,
        LPlate.CFrame + Vector3.new(0, 200, 0),
        "{3ae31e60-5cd0-4d80-96b6-a1dd894ece8a}",
        {...},
        0
    );
end;

function Module.CreateSpike(CF: CFrame, Weld: table)
    return StampAsset:InvokeServer(41324903, CF, "{bf0c5c8b-6f25-4321-9251-300beb818121}", Weld or {}, 0);
end;

function Module.CreateMSpike(CF: CFrame, Weld: table)
    return StampAsset:InvokeServer(41324904, CF, "{fca81e11-1ead-4817-afde-4dc29e72ea1b}", Weld or {}, 0);
end;

function Module.Kill(Player)
    if Player.Parent.Name == "tertthfhttyr" or Player.Parent.Name == "efrefeds" then
        return;
    end;
    StampAsset:InvokeServer(
        56447956,
        LPlate.CFrame - Vector3.new(0, 9e9, 0),
        "{99ab22df-ca29-4143-a2fd-0a1b79db78c2}",
        {Player, LPlate},
        0
    );
end;

function Module.KillSpike(Player)
    StampAsset:InvokeServer(
        56447956,
        LPlate.CFrame + Vector3.new(0, 10, 0),
        "{99ab22df-ca29-4143-a2fd-0a1b79db78c2}",
        {Player},
        0
    );
    StampAsset:InvokeServer(41324903, LPlate.CFrame + Vector3.new(0, 10, 0), "{bf0c5c8b-6f25-4321-9251-300beb818121}", {}, 0);
    
end;

function Module.Fling(Player)
    if (Player:IsA("Player")) then Player = Player.Character.PrimaryPart; end;
    StampAsset:InvokeServer(
        41324885,
        LPlate.CFrame + Vector3.new(0, 9e9, 0),
        "{99ab22df-ca29-4143-a2fd-0a1b79db78c2}",
        {Player},
        0
    );
end;

function Module.Hang(Part: Part)
    Module.CreateMSpike(
        (LPlate.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))) - Vector3.new(0, -5, 0),
        {LPlate}
    );
    Module.Weld(Part, MSpikes[#MSpikes]);
end;

function Module.Delete(Part)
    DeleteAsset:InvokeServer(Part);
end;

local Aura;
function Module.DestroyAura(Radius: number)
    if (Aura) then Aura:Destroy(); end;
    Radius = Vector3.new(Radius, Radius, Radius);
    local Blacklist = {};
    local Hrp = LPlayer.Character.PrimaryPart;
    local Weld = Instance.new("Weld", Hrp);
    Aura = Instance.new("Part", Hrp);
    Aura.Size = Radius;
    Aura.Massless = true;
    Aura.Transparency = 0;
    Aura.Material = Enum.Material.ForceField;
    Aura.Color = Color3.new(1, 0, 0);
    Aura.CanCollide = false;
    Aura.Shape = Enum.PartType.Ball;
    Aura.Touched:Connect(function(Part)
        if (Blacklist[Part] or Part.Anchored) then return; end;
        if (Part.CFrame.Y <= LPlate.CFrame.Y + 4) then return; end;
        if (Part:IsDescendantOf(LPlayer.Character)) then return; end;
        Blacklist[Part] = true;
        Module.Hang(Part);
    end);
    Weld.Part0 = Hrp;
    Weld.Part1 = Aura;
    Aura.Destroying:Wait();
    table.clear(Blacklist);
    Blacklist = nil;
end;

function Module.Lag()    
    for i,v in pairs(game.Players:GetChildren()) do
        if v.Name == "tertthfhttyr" or v.Name == "efrefeds" then
        else
            Module.Hang(v.Character.HumanoidRootPart);
        end;
    end;
end;

function Module.SpikeGrind()
    for i=1,50 do
        StampAsset:InvokeServer(41324903, LPlate.CFrame + Vector3.new(math.random(-30,30), 10, math.random(-30,30)), "{bf0c5c8b-6f25-4321-9251-300beb818121}", {}, 0);
    end;
end;

function Module.SteepleGrind()
    for i=1,50 do
        StampAsset:InvokeServer(56448122, LPlate.CFrame + Vector3.new(math.random(-30,30), 10, math.random(-30,30)), "{bf0c5c8b-6f25-4321-9251-300beb818121}", {}, 0);
    end;
end;

function Module.Crash()
    StampAsset:InvokeServer(56447956, LPlate.CFrame + Vector3.new(40, 15, 0), "{99ab22df-ca29-4143-a2fd-0a1b79db78c2}", {}, 0);
    for i=1,600 do
        wait(0.060);
        StampAsset:InvokeServer(56450197, LPlate.CFrame + Vector3.new(40, 30, 0), "{99ab22df-ca29-4143-a2fd-0a1b79db78c2}", {WV[#WV]}, 0);
    end;
end;

function Module.PlaceSpike()
    StampAsset:InvokeServer(BlockID, LPlate.CFrame + Vector3.new(0, 5, 0), game:GetService("HttpService"):GenerateGUID(true), {LPlayer.Character.HumanoidRootPart}, 0);
end;

UserInputService.InputBegan:Connect(function(InputObject, Proccessed)
    if (Proccessed) then return; end;
    if (InputObject.KeyCode == Enum.KeyCode.F) then
        Module.Freeze(Mouse.Target);
    elseif (InputObject.KeyCode == Enum.KeyCode.Y) then
        Module.Kill(Mouse.Target);
    elseif (InputObject.KeyCode == Enum.KeyCode.H) then
        Module.DestroyAura(20);
    elseif (InputObject.KeyCode == Enum.KeyCode.J) then
        Module.Lag();
    elseif (InputObject.KeyCode == Enum.KeyCode.L) then
        Module.SpikeGrind();
    elseif (InputObject.KeyCode == Enum.KeyCode.P) then
        Module.SteepleGrind();
    elseif (InputObject.KeyCode == Enum.KeyCode.M) then
        Module.Crash();
    elseif (InputObject.KeyCode == Enum.KeyCode.K) then
        Module.PlaceSpike();
    elseif (InputObject.KeyCode == Enum.KeyCode.T) then
        Aura:Destroy();
        Aura = nil;
    end;
end);
