if SERVER then
	AddCSLuaFile()
end

MINIGAME.author = "Alf21"
MINIGAME.contact = "TTT2 Discord"

if CLIENT then
	MINIGAME.lang = {
		name = {
			English = "Hardcore Minigame"
		},
		desc = {
			English = "Try to win without some essential HUD elements."
		}
	}

	local ignoreHUDElems = {
		TTTTargetID = true,
		tttdrowning = true,
		tttminiscoreboard = true,
		tttsidebar = true
	}

	function MINIGAME:OnActivation()
		hook.Add("HUDShouldDraw", "TTT2MGHardcore", function(elem)
			local client = LocalPlayer()

			if client:Alive() and client:IsTerror() and ignoreHUDElems[elem] then
				return false
			end
		end)

		-- prevent radio commands
		hook.Add("TTT2ClientRadioCommand", "TTT2MGHardcore", function()
			return true
		end)
	end

	function MINIGAME:OnDeactivation()
		hook.Remove("HUDShouldDraw", "TTT2MGHardcore")
		hook.Remove("TTT2ClientRadioCommand", "TTT2MGHardcore")
	end
else
	function MINIGAME:OnActivation()
		-- prevent radio commands
		hook.Add("TTTPlayerRadioCommand", "TTT2MGHardcore", function()
			return true
		end)
	end

	function MINIGAME:OnDeactivation()
		hook.Remove("TTTPlayerRadioCommand", "TTT2MGHardcore")
	end
end
