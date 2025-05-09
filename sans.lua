local msg = Instance.new("Message", workspace)
msg.Text = "sanslevetation script, turn to rightctrl (follow to Linux_Pinuks)"
wait(3)
msg:Destroy()


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")


local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SansevelitiUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 160)
Frame.Position = UDim2.new(0.5, -110, 0.45, 0)
Frame.BackgroundColor3 = Color3.fromRGB(100, 200, 255) -- голубой фон
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundTransparency = 0.1
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Sansleveta"
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

local function createButton(text, position)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Size = UDim2.new(0.8, 0, 0.25, 0)
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- белые кнопки
	btn.TextColor3 = Color3.fromRGB(0, 0, 0) -- чёрный текст
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.AutoButtonColor = true
	btn.Parent = Frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local ButtonOn = createButton("Activate", UDim2.new(0.1, 0, 0.38, 0))
local ButtonOff = createButton("Deactivate", UDim2.new(0.1, 0, 0.7, 0))


local uiVisible = true
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function toggleUI()
	uiVisible = not uiVisible
	local goal = {}
	goal.Position = uiVisible and UDim2.new(0.5, -110, 0.45, 0) or UDim2.new(0.5, -110, 1.2, 0)
	TweenService:Create(Frame, tweenInfo, goal):Play()
end

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightControl then
		toggleUI()
	end
end)


local function playSound(id)
	local sound = Instance.new("Sound", HRP)
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = 2
	sound:Play()
	game.Debris:AddItem(sound, 5)
end


local originalC0 = {}
for _, part in pairs(Character:GetDescendants()) do
	if part:IsA("Motor6D") then
		originalC0[part] = part.C0
	end
end


local function setFlyingPose()
	for _, part in pairs(Character:GetDescendants()) do
		if part:IsA("Motor6D") then
			if part.Name == "Right Shoulder" then
				part.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(0, 0, math.rad(90))
			elseif part.Name == "Left Shoulder" then
				part.C0 = CFrame.new(-1, 0.5, 0) * CFrame.Angles(0, 0, math.rad(-90))
			elseif part.Name == "Right Hip" then
				part.C0 = CFrame.new(1, -1, 0)
			elseif part.Name == "Left Hip" then
				part.C0 = CFrame.new(-1, -1, 0)
			elseif part.Name == "Neck" then
				part.C0 = CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
			end
		end
	end
end

local function restorePose()
	for part, c0 in pairs(originalC0) do
		if part.Parent then
			part.C0 = c0
		end
	end
end


local originalGravity = workspace.Gravity
local isFrozen = false

ButtonOn.MouseButton1Click:Connect(function()
	if isFrozen then return end
	isFrozen = true

	playSound("642336941") 

	workspace.Gravity = 0
	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	local velocity = HRP.Velocity
	HRP.Velocity = Vector3.new(velocity.X, math.max(velocity.Y, 0), velocity.Z)

	Humanoid.PlatformStand = true
	setFlyingPose()
end)

ButtonOff.MouseButton1Click:Connect(function()
	if not isFrozen then return end
	isFrozen = false

	playSound("6516202633")

	workspace.Gravity = originalGravity
	Humanoid.PlatformStand = false
	Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	restorePose()
end)
