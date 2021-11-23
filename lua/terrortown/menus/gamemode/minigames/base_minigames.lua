CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_ttt2mg_basemg_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local minigameName = self.minigameData.name

	local form = vgui.CreateTTT2Form(parent, "ttt2_minigames_" .. self.minigameData.name .. "_name")

	if LANG.TryTranslation("ttt2_minigames_" .. minigameName .. "_desc") ~= "" then
		form:MakeHelp({
			label = "ttt2_minigames_" .. minigameName .. "_desc",
		})
	else
		form:MakeHelp({
			label = "label_ttt2_minigames_no_desc",
		})
	end

	local masterEnb = form:MakeCheckBox({
		serverConvar = "ttt2_minigames_" .. minigameName .. "_enabled",
		label = "label_ttt2_minigames_minigame_enabled"
	})

	form:MakeSlider({
		label = "label_ttt2_minigames_minigame_random",
		serverConvar = "ttt2_minigames_" .. minigameName .. "_random",
		min = 0,
		max = 100,
		decimal = 0,
		master = masterEnb
	})

	self.minigameData:AddToSettingsMenu(parent)

	-- deprecated fallback for convar settings
	if table.Count(self.minigameData.conVarData or {}) == 0 then return end

	local form2 = vgui.CreateTTT2Form(parent, "header_minigames_extra_settings")

	for cvar, data in pairs(self.minigameData.conVarData) do
		if data.checkbox then
			form2:MakeCheckBox({
				serverConvar = cvar,
				label = data.desc
			})
		elseif data.slider then
			form2:MakeSlider({
				serverConvar = cvar,
				label = data.desc,
				min = data.min or 1,
				max = data.max or 1000,
				decimal = data.decimal or 0
			})
		elseif data.label then
			form2:MakeHelp({
				label = data.desc
			})
		end
		-- ToDo: Combo Box is missing
	end
end
