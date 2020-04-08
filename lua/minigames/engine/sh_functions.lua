---
-- Activates a minigame. If called on server, the sync with the clients will be run
-- @param table minigame the minigame table
function ActivateMinigame(minigame)
	hook.Run("TTT2MGPreActivate", minigame)

	minigame:Activate()

	if SERVER then
		net.Start("TTT2MGActivateMinigame")
		net.WriteUInt(minigame.index, MINIGAMES_BITS)
		net.Broadcast()
	elseif GetConVar("ttt2_minigames_show_popup"):GetBool() then -- show popup if a minigame is activated
			if istable(minigame.lang) then
				EPOP:AddMessage({
						text = LANG.TryTranslation("ttt2_minigames_" .. minigame.name .. "_name"),
						color = COLOR_ORANGE
					},
					minigame.lang.desc and LANG.TryTranslation("ttt2_minigames_" .. minigame.name .. "_desc") or nil,
					12
				)
			end
		end
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
		net.WriteUInt(minigame.index, MINIGAMES_BITS)
		net.Broadcast()
	end

	hook.Run("TTT2MGDeactivate", minigame)

	hook.Run("TTT2MGPostDeactivate", minigame)
end
