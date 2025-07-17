local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid:Humanoid = character:WaitForChild("Humanoid")
local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://110391260523201"
local Track:AnimationTrack = humanoid.Animator:LoadAnimation(Animation)
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial ~= Enum.Material.Air then
		if not Track.IsPlaying then
			Track:Play()
		end 
	else
		if Track.IsPlaying and humanoid.FloorMaterial ~= Enum.Material.Air then
			Track:Stop()
		end
	end
end)
