if SERVER then
	util.AddNetworkString("TTT2MGActivateMinigame")
	util.AddNetworkString("TTT2MGDeactivateMinigame")
else
	net.Receive("TTT2MGActivateMinigame", function()
		local minigame = minigames.GetByIndex(net.ReadUInt(MINIGAMES_BITS))
		if not minigame then return end

		ActivateMinigame(minigame)
	end)

	net.Receive("TTT2MGDeactivateMinigame", function()
		local minigame = minigames.GetByIndex(net.ReadUInt(MINIGAMES_BITS))
		if not minigame then return end

		DeactivateMinigame(minigame)
	end)
end
