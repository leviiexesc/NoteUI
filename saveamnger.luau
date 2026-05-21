local HttpService = game:GetService("HttpService")

local folderName = "UI"
local fileName = "config.json"

-- create folder
if makefolder and not isfolder(folderName) then
	makefolder(folderName)
end

-- save function
local function SaveConfig()
	if writefile then
		local data = {
			Note = noteText.Text
		}

		writefile(
			folderName.."/"..fileName,
			HttpService:JSONEncode(data)
		)
	end
end

-- load function
local function LoadConfig()
	if readfile and isfile and isfile(folderName.."/"..fileName) then
		local success, result = pcall(function()
			return HttpService:JSONDecode(
				readfile(folderName.."/"..fileName)
			)
		end)

		if success and result then
			noteText.Text = result.Note or ""
		end
	end
end

-- auto save when textbox changes
noteText.FocusLost:Connect(function()
	SaveConfig()
end)

-- load config on startup
LoadConfig()
