---
-- Activates a minigame. If called on server, the sync with the clients will be run
-- @param table minigame the minigame table
function ActivateMinigame(minigame)
	hook.Run("TTT2MGPreActivate", minigame)

	minigame:Activate()

	if SERVER then
		net.Start("TTT2MGActivateMinigame")
		net.WriteUInt(minigame.id, MINIGAMES_BITS)
		net.Broadcast()
	end

	hook.Run("TTT2MGActivate", minigame)

	hook.Run("TTT2MGPostActivate", minigame)
end

---
-- Deactivates a minigame. If called on server, the sync with the clients will be run
-- @param table minigame the minigame table
function DeactivateMinigame(minigame)
	hook.Run("TTT2MGPreDeactivate", minigame)

	minigame:Deactivate()

	if SERVER then
		net.Start("TTT2MGDeactivateMinigame")
		net.WriteUInt(minigame.id, MINIGAMES_BITS)
		net.Broadcast()
	end

	hook.Run("TTT2MGDeactivate", minigame)

	hook.Run("TTT2MGPostDeactivate", minigame)
end
