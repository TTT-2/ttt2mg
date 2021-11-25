CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_ttt2mg_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_addons_ttt2mg")

	form:MakeHelp({
		label = "help_minigames_show_popup"
	})

	form:MakeCheckBox({
		serverConvar = "ttt2_minigames_show_popup",
		label = "label_minigames_show_popup"
	})
end
