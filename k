local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 既存GUIがあれば削除
if player:FindFirstChild("PlayerGui"):FindFirstChild("WarpGui") then
	player.PlayerGui.WarpGui:Destroy()
end

-- UI作成
local gui = Instance.new("ScreenGui")
gui.Name = "WarpGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ドラッグ可能なフレーム
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(1, -200, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- ボタン
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "カーソル地点にワープ"
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Parent = frame

-- ヒューマノイドルート取得関数
local function getRoot()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		return character.HumanoidRootPart
	end
	return nil
end

-- レイキャスト関数
local function getCenterRaycast()
	local viewportSize = camera.ViewportSize
	local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
	local ray = camera:ViewportPointToRay(screenCenter.X, screenCenter.Y)

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {player.Character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
	return result
end

-- ワープ処理
local function warp()
	local root = getRoot()
	if not root then return end

	local result = getCenterRaycast()
	if result and result.Position then
		root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0)) -- 少し浮かせる
	end
end

button.MouseButton1Click:Connect(warp)

-- キャラが死んだら再接続
player.CharacterAdded:Connect(function()
	wait(1) -- キャラのロード待ち
	if gui.Parent ~= player:FindFirstChild("PlayerGui") then
		gui:Clone().Parent = player:WaitForChild("PlayerGui")
	end
end)
