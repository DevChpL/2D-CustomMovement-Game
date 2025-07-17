local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid:Humanoid = character:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local double_jumped = false
local double_jump_animation = game.ReplicatedStorage.Animations:WaitForChild("DoubleJump")
local animator:Animator = humanoid:WaitForChild("Animator")
local double_jump_track = animator:LoadAnimation(double_jump_animation)
local Promise = require(game.ReplicatedStorage.Modules.Promise)
local IsJumping = false
local connection
double_jump_track.Priority = Enum.AnimationPriority.Action4
humanoid.StateChanged:Connect(function(old, new)
	if old == Enum.HumanoidStateType.Running and new == Enum.HumanoidStateType.Jumping 
		or  old == Enum.HumanoidStateType.PlatformStanding and new == Enum.HumanoidStateType.Jumping 
	then
		IsJumping = true
		if not double_jumped then
			Promise.new(function(resolve,reject)
				connection = uis.InputBegan:Connect(function(input,gameproccesedevent)
					if input.KeyCode == Enum.KeyCode.Space and not double_jumped then
						double_jumped = true
						double_jump_track:Play()
						humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						resolve()
					end
				end)
				while true do
					if not IsJumping then
						reject("He is not jumping")
						break
					end
					task.wait()
				end
			end):catch(function()
				if connection then
					connection:Disconnect()
					connection = nil
				end
				
			end):andThen(function()
				if connection  then
					connection:Disconnect()
					connection = nil
				end
				
			end)
		end
	end
	if new == Enum.HumanoidStateType.Landed then
		IsJumping = false
		double_jumped = false
	end
end)
