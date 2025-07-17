local Character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart:Part = Character:WaitForChild("HumanoidRootPart")
local Params = RaycastParams.new()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SlidingAnimm = Instance.new("Animation")
SlidingAnimm.AnimationId = "rbxassetid://71920274459942"
local Track:AnimationTrack = Humanoid:WaitForChild("Animator"):LoadAnimation(SlidingAnimm)
Track.Looped = true
Params.FilterType = Enum.RaycastFilterType.Exclude
Params.FilterDescendantsInstances = {Character}

local MostRecentStandingPosition 
local DownOffSet = {
	Vector3.new(0,1,0);
	Vector3.new(0,-1,0);
	Vector3.new(0,0,0);
}
local offsets = {
	Vector3.new(0,0,0);	
	Vector3.new(-1,0,0);
	Vector3.new(1,0,0);
}
local function PrepareToClimb()
	Humanoid.PlatformStand = true
	HumanoidRootPart.Anchored = true
end
local function StopClimbing()
	Humanoid:SetAttribute("Climbing",false)
	Humanoid.PlatformStand = false
	HumanoidRootPart.Anchored = false
end
local function DetectWall()
	for i ,v in offsets do
		local result = workspace:Raycast(HumanoidRootPart.Position,Humanoid.MoveDirection.Unit*2,Params)
		if result then
			return result
			else return false
		end
		
	end
end
RunService.RenderStepped:Connect(function(deltaTime)
	local result:RaycastResult = DetectWall()
	if result == nil and Humanoid.FloorMaterial == Enum.Material.Air then
		StopClimbing()
	end 
	if Humanoid:GetAttribute("Climbing") and not Track.IsPlaying then
		Track:Play()
	elseif not Humanoid:GetAttribute("Climbing") and Track.IsPlaying then
		Track:Stop()
	
	end
	if Humanoid.FloorMaterial ~= Enum.Material.Air then
		MostRecentStandingPosition = HumanoidRootPart.Position
		
	end
	if result and not Humanoid:GetAttribute("Climbing") and Humanoid.FloorMaterial == Enum.Material.Air then
		if result.Instance:GetChildren()[1] == nil then
			PrepareToClimb()
			Track:Play()
			local Trash = Instance.new("IntValue",result.Instance)
			game.Debris:AddItem(Trash,1)
			HumanoidRootPart.CFrame = CFrame.lookAlong(HumanoidRootPart.Position,-result.Normal)
			Humanoid:SetAttribute("Climbing",true)
			task.spawn(function()
				while Humanoid:GetAttribute("Climbing") do
					task.wait(1/60)
					local GoalCFrame = HumanoidRootPart.CFrame - Vector3.new(0,0.8,0)
					HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(GoalCFrame,0.1)
					for i ,v in ipairs(DownOffSet) do
						local DownResult = workspace:Raycast(HumanoidRootPart.Position - Vector3.new(0,HumanoidRootPart.Size.Y*1.7,0),Vector3.new(0,-1,0)+ v,Params)
						if DownResult then
							StopClimbing()
							Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							break
						end
					end
					
					if not Humanoid:GetAttribute("Climbing") then
						break
					end 
				end
			end)
			task.wait(0.3)
			task.spawn(function()
				repeat wait(1/60) until UserInputService:IsKeyDown(Enum.KeyCode.Space)
				StopClimbing()
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				
			end)
			task.spawn(function()
				repeat task.wait(0.1) until Humanoid.FloorMaterial ~= Enum.Material.Air or workspace:Raycast(HumanoidRootPart.Position,HumanoidRootPart.CFrame.LookVector*5,Params) == nil
				StopClimbing()
				for i ,v in ipairs(workspace:GetDescendants()) do
					if v:HasTag("Wall") then
						for _,v2 in ipairs(v:GetChildren()) do
							v2:Destroy()
						end
					end
				end
			end)
		end
	end
end)