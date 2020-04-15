if engine.ActiveGamemode() ~= "terrortown" then return end -- just run it for the terrortown gamemode

-- store the MG var if already exists
local oldMINIGAME = MINIGAME

-- include modules
include("includes/modules/minigames.lua")

-- load minigames
local minigamesPre = "minigames/minigames/"
local minigamesFiles = file.Find(minigamesPre .. "*.lua", "LUA")
local _, minigamesFolders = file.Find(minigamesPre .. "*", "LUA")

for i = 1, #minigamesFiles do
	local fl = minigamesFiles[i]

	MINIGAME = {}

	include(minigamesPre .. fl)

	local cls = string.sub(fl, 0, #fl - 4)

	minigames.Register(MINIGAME, cls)

	MINIGAME = nil
end

for i = 1, #minigamesFolders do
	local folder = minigamesFolders[i]

	MINIGAME = {}

	local subFiles = file.Find(minigamesPre .. folder .. "/*.lua", "LUA")

	for k = 1, #subFiles do
		local fl = subFiles[k]

		if fl == "init.lua" then
			if SERVER then
				include(minigamesPre .. folder .. "/" .. fl)
			end
		elseif fl == "cl_init.lua" then
			if SERVER then
				AddCSLuaFile(minigamesPre .. folder .. "/" .. fl)
			else
				include(minigamesPre .. folder .. "/" .. fl)
			end
		else
			if SERVER and fl == "shared.lua" then
				AddCSLuaFile(minigamesPre .. folder .. "/" .. fl)
			end

			include(minigamesPre .. folder .. "/" .. fl)
		end
	end

	minigames.Register(MINIGAME, folder)

	MINIGAME = nil
end

MINIGAME = oldMINIGAME

-- include minigames base files
if SERVER then
	AddCSLuaFile("minigames/engine/sh_init.lua")
end

include("minigames/engine/sh_init.lua")
