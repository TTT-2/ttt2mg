if SERVER then
	AddCSLuaFile("sh_vars.lua")
	AddCSLuaFile("sh_networking.lua")
	AddCSLuaFile("sh_functions.lua")

	include("sv_convars.lua")
	include("sv_hooks.lua")
end

include("sh_vars.lua")
include("sh_networking.lua")
include("sh_functions.lua")
