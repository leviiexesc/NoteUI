repeat wait() until game:IsLoaded()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local folderName = "UI"
local fileName = "config.json"

-- create folder
if makefolder and not isfolder(folderName) then
	makefolder(folderName)
end

-- NOTE TEXT reference (needed for save/load)
local noteText


local function SaveConfig()
	if writefile and noteText then
		local data = {
			Username = LocalPlayer.Name,
			Note = noteText.Text
		}

		writefile(
			folderName.."/"..fileName,
			HttpService:JSONEncode(data)
		)
	end
end

local function LoadConfig()
	if readfile and isfile and isfile(folderName.."/"..fileName) and noteText then
		local success, result = pcall(function()
			return HttpService:JSONDecode(
				readfile(folderName.."/"..fileName)
			)
		end)

		if success and result then
			noteText.Text = result.Note or ""

			-- optional safety check
			if result.Username and result.Username ~= LocalPlayer.Name then
				warn("Loaded config from different user:", result.Username)
			end
		end
	end
end


local gui = Instance.new("ScreenGui")
gui.Name = "Note"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- MAIN PANEL
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 380, 0, 95)
panel.Position = UDim2.new(0.5, -190, 0.3, 0)
panel.BackgroundColor3 = Color3.fromRGB(0,0,0)
panel.BackgroundTransparency = 0.5
panel.BorderSizePixel = 0
panel.Parent = gui

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(120,120,120)
panelStroke.Thickness = 1
panelStroke.Transparency = 0.4
panelStroke.Parent = panel

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,26)
topBar.BackgroundColor3 = Color3.fromRGB(0,0,0)
topBar.BackgroundTransparency = 0.45
topBar.BorderSizePixel = 0
topBar.Parent = panel

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,16,0,16)
closeBtn.Position = UDim2.new(1,-22,0.5,-8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar

-- BODY
local body = Instance.new("Frame")
body.Size = UDim2.new(1,0,1,-26)
body.Position = UDim2.new(0,0,0,26)
body.BackgroundTransparency = 1
body.Parent = panel

local username = LocalPlayer.Name
local visiblePart = string.sub(username,1,math.ceil(#username/2))
local hiddenPart = string.rep("*",#username - math.ceil(#username/2))

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1,-20,0,26)
nameLabel.Position = UDim2.new(0,12,0,6)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Name : "..visiblePart..hiddenPart
nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 20
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = body

-- NOTE LABEL
local noteLabel = Instance.new("TextLabel")
noteLabel.Size = UDim2.new(0,70,0,24)
noteLabel.Position = UDim2.new(0,12,0,36)
noteLabel.BackgroundTransparency = 1
noteLabel.Text = "Note :"
noteLabel.TextColor3 = Color3.fromRGB(255,210,50)
noteLabel.Font = Enum.Font.GothamBold
noteLabel.TextSize = 18
noteLabel.TextXAlignment = Enum.TextXAlignment.Left
noteLabel.Parent = body

-- NOTE TEXTBOX
noteText = Instance.new("TextBox")
noteText.Size = UDim2.new(1,-95,0,24)
noteText.Position = UDim2.new(0,82,0,36)
noteText.BackgroundTransparency = 1
noteText.Text = ""
noteText.TextColor3 = Color3.fromRGB(255,255,255)
noteText.Font = Enum.Font.GothamBold
noteText.TextSize = 18
noteText.TextXAlignment = Enum.TextXAlignment.Left
noteText.ClearTextOnFocus = false
noteText.BorderSizePixel = 0
noteText.Parent = body


LoadConfig()

noteText.FocusLost:Connect(function()
	SaveConfig()
end)

local dragging = false
local dragStart
local startPos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		panel.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
