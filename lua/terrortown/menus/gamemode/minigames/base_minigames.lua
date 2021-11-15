CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_ttt2mg_basemg_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local minigameName = self.minigameData.name

	local form = vgui.CreateTTT2Form(parent, "ttt2_minigames_" .. self.minigameData.name .. "_name")

	form:MakeHelp({
		label = "ttt2_minigames_" .. minigameName .. "_desc",
	})

	form:MakeCheckBox({
		label = "label_ttt2_minigames_minigame_enabled",
		params = {
			name = "ttt2_minigames_" .. minigameName .. "_name"
		},
		serverConvar = "ttt2_minigames_" .. minigameName .. "_enabled",
		master = masterEnb
	})

	form:MakeSlider({
		label = "label_ttt2_minigames_minigame_random",
		serverConvar = "ttt2_minigames_" .. minigameName .. "_random",
		min = 0,
		max = 100,
		decimal = 0,
		master = masterEnb
	})
end