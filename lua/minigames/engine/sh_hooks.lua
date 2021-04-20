if SERVER then
	local ttt2_minigames = GetConVar("ttt2_minigames")

	hook.Add("TTTEndRound", "TTT2MGPrepareRound", function()
		local activeMinigames = minigames.GetActiveList()

		for i = 1, #activeMinigames do
			DeactivateMinigame(activeMinigames[i])
		end
	end)

	hook.Add("TTTBeginRound", "TTT2MGSync", function()
		if not ttt2_minigames:GetBool() or not minigames.CheckAutostart() then return end

		local minigame = minigames.Select()
		if not minigame then return end

		ActivateMinigame(minigame)
	end)
else
	hook.Add("TTT2FinishedLoading", "TTT2MGInitLang", function()
		if not LANG then return end

		local mgs = minigames.GetList()

		for i = 1, #mgs do
			local mg = mgs[i]

			if not istable(mg.lang) then continue end

			for key, tbl in pairs(mg.lang) do
				for lang, text in pairs(tbl) do
					LANG.AddToLanguage(lang, "ttt2_minigames_" .. mg.name .. "_" .. key, text)
				end
			end
		end
	end)
end

hook.Add("TTT2Initialize", "TTT2MGInitialize", function()
	minigames.OnLoaded()
end)
