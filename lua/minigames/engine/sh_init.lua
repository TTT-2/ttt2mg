if SERVER then
	AddCSLuaFile("sh_convars.lua")
	AddCSLuaFile("sh_vars.lua")
	AddCSLuaFile("sh_networking.lua")
	AddCSLuaFile("sh_functions.lua")

	include("sv_hooks.lua")
end

include("sh_convars.lua")
include("sh_vars.lua")
include("sh_networking.lua")
include("sh_functions.lua")
