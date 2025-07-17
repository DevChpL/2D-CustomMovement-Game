local player = game:GetService("Players").LocalPlayer
local HumanoidRootPart : Part = player.Character:WaitForChild("HumanoidRootPart")
local Params = RaycastParams.new()
local RunService = game:GetService("RunService")
local Humanoid:Humanoid = player.Character:WaitForChild("Humanoid")
local DefaultWalkSpeed = Humanoid.WalkSpeed
local Camera = game.Workspace.CurrentCamera
local DefaultFoV = Camera.FieldOfView
Params.FilterType = Enum.RaycastFilterType.Exclude
Params.FilterDescendantsInstances = {player.Character}
local RayDirection:Vector3 = Vector3.new(0, -HumanoidRootPart.Size.Y, 0)*1.7
local TweenService = game:GetService("TweenService")
function AnglePlayerGround()
	local result = workspace:Raycast(HumanoidRootPart.Position,RayDirection,Params)
	if result then
		return math.deg(math.acos(result.Normal:Dot(RayDirection)/(result.Normal.Magnitude*RayDirection.Magnitude)))
	else
		return false
	end
	
end
function PlayAscendingAnimation()
    local Tween = TweenService:Create(Camera,TweenInfo.new(0.2),{FieldOfView = DefaultFoV*0.8})
	Humanoid.WalkSpeed = DefaultWalkSpeed*0.8
	if Tween.PlaybackState ~= Enum.PlaybackState.Playing then
		Tween:Play()
	end
end
function PlayDescendingAnimation()
	local Tween = TweenService:Create(Camera,TweenInfo.new(0.2),{FieldOfView = DefaultFoV*1.2})
	Humanoid.WalkSpeed = DefaultWalkSpeed*1.2
	if Tween.PlaybackState ~= Enum.PlaybackState.Playing then
		Tween:Play()
	end
end
function PlayStillAnimation()
	local Tween = TweenService:Create(Camera,TweenInfo.new(0.2),{FieldOfView = DefaultFoV})
	Humanoid.WalkSpeed = DefaultWalkSpeed
	if Tween.PlaybackState ~= Enum.PlaybackState.Playing then
		Tween:Play()
	end
end
RunService.RenderStepped:Connect(function()
	if typeof(AnglePlayerGround()) == "number" then
		if HumanoidRootPart.AssemblyLinearVelocity.Y > 0 and AnglePlayerGround() ~= 180 then
			print("player is ascending on surface with degree of: "..tostring(AnglePlayerGround()))
			PlayAscendingAnimation()
		elseif HumanoidRootPart.AssemblyLinearVelocity.Y < 0 and AnglePlayerGround() ~= 180 then
			print("player is descending on surface with degree of: "..tostring(AnglePlayerGround()))
			PlayDescendingAnimation()
		elseif AnglePlayerGround() == 180 then
			PlayStillAnimation()
		end
	end	
end)