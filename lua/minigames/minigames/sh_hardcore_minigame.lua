if SERVER then
	AddCSLuaFile()
end

MINIGAME.author = "Alf21"
MINIGAME.contact = "TTT2 Discord"

MINIGAME.lang = {
	name = {
		English = "Hardcore Minigame"
	},
	desc = {
		English = "Try to win without some essential HUD elements."
	}
}

if CLIENT then
	local ignoreHUDElems = {
		TTTTargetID = true,
		tttdrowning = true,
		tttminiscoreboard = true,
		tttsidebar = true,
		ttttarget = true
	}

	function MINIGAME:OnActivation()
		hook.Add("HUDShouldDraw", "TTT2MGHardcore", function(elem)
			local client = LocalPlayer()

			if client:Alive() and client:IsTerror() and ignoreHUDElems[elem] then
				return false
			end
		end)
	end

	function MINIGAME:OnDeactivation()
		hook.Remove("HUDShouldDraw", "TTT2MGHardcore")
	end
end
