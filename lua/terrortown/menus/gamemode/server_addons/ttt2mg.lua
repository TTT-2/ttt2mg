CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_addons_ttt2mg_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_ttt2mg")

    form:MakeHelp({
        label = "label_ttt2_minigames_enabled_info"
    })

    local masterEnb = form:MakeCheckBox({
        label = "label_ttt2_minigames_enable",
        serverConvar = "ttt2_minigames"
    })

    form:MakeHelp({
        label = "label_ttt2_minigames_autostart_rounds_info"
    })

    form:MakeSlider({
        label = "label_ttt2_minigames_autostart_rounds",
        serverConvar = "ttt2_minigames_autostart_rounds",
        min = 0,
        max = 30,
        decimal = 0,
        master = masterEnb
    })

    form:MakeHelp({
        label = "label_ttt2_minigames_autostart_random_info"
    })

    form:MakeSlider({
        label = "label_ttt2_minigames_autostart_random",
        serverConvar = "ttt2_minigames_autostart_random",
        min = 0,
        max = 100,
        decimal = 0,
        master = masterEnb
    })
end
