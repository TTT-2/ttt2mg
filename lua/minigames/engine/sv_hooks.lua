local ttt2_minigames = GetConVar("ttt2_minigames")
local ttt2_minigames_autostart = GetConVar("ttt2_minigames_autostart")

hook.Add("TTTPrepareRound", "TTT2MGPrepareRound", function()
	local activeMinigames = minigames.GetActiveList()

	for i = 1, i < #activeMinigames do
		DeactivateMinigame(activeMinigames[i])
	end
end)

hook.Add("TTTBeginRound", "TTT2MGSync", function()
	if not ttt2_minigames:GetBool() or not ttt2_minigames_autostart:GetBool() then return end

	local minigame = minigames.Select()
	if not minigame then return end

	ActivateMinigame(minigame)
end)
