--Variables
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Camera = workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Scriptable
local RunService = game:GetService("RunService")
local HumanoidRootPart:Part = character:WaitForChild("HumanoidRootPart")
local Humanoid:Humanoid = character:WaitForChild("Humanoid")
local Animator:Animator = Humanoid:WaitForChild("Animator")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Left = Vector3.new(0,0,1)-- Default Movement Direction of a 2d game
local Right = Vector3.new(0,0,-1)--  Default Movement Direction of a 2d game 
local Debounce =  false
local KeyPressed --Table to detect all the keys that're being pressed right now
local MovementDirection = Vector3.zero -- A place of memory to chooose which direction the player's moving rn
local Moving = false
local DefaultFoV = Camera.FieldOfView -- Default Field Of View of The Camera 
local CameraDirection = 9 -- the space between the camera and HumanoidRootPart in the XZ axis
local CameraDirTween
local OriginalCamera = workspace.CurrentCamera
--Functions
player.CharacterAdded:Connect(function()
	HumanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
	Humanoid = character:WaitForChild("Humanoid")
	Animator = Humanoid:WaitForChild("Animator")
end)

--Proccesing
RunService.RenderStepped:Connect(function()
	
	
	KeyPressed = UserInputService:GetKeysPressed()
	local ComparedWalls:number = {}
	
	
	if typeof(MovementDirection) == "Vector3" then
		Humanoid:Move(MovementDirection)
	end
	Camera.CFrame =  Camera.CFrame:Lerp(CFrame.lookAt(Vector3.new(HumanoidRootPart.Position.X + CameraDirection,HumanoidRootPart.Position.Y+6,HumanoidRootPart.Position.Z-CameraDirection),HumanoidRootPart.Position),0.1)
	
	
	if #KeyPressed == 0 then
		MovementDirection = Vector3.zero
	end
	for i,v:InputObject in ipairs(KeyPressed) do
		if v.KeyCode == Enum.KeyCode.A  then
			MovementDirection += Left
			if MovementDirection ~= Vector3.zero then
				MovementDirection = MovementDirection.Unit
				CameraDirection = 9
			end
		elseif v.KeyCode == Enum.KeyCode.D  then
			MovementDirection += Right
			if MovementDirection ~= Vector3.zero then
				MovementDirection = MovementDirection.Unit
				CameraDirection = -9
			end
		elseif v.KeyCode == Enum.KeyCode.Space then
			Humanoid.Jump = true
		end
	end
	if Humanoid.MoveDirection.Magnitude ~= 0 or Humanoid.MoveDirection.Magnitude >= 0.25 then
		Moving = true
	else
		Moving = false
	end
	
end)
