CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_ttt2mg_basemg_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local minigameName = self.minigame.name

    local form = vgui.CreateTTT2Form(parent, minigameName)

    -- TODO add 'desc' property to minigame and fill it with MINIGAME.lang.desc(.en)
    -- form:MakeHelp({
    --     label = self.minigame.desc,
    -- })

    -- This isn't the right name for displaying in the UI. Example: From "ttt2mg-pack-third" there is a minigame called sh_knife_minigame.lua
    -- here the name will be self.minigame.name == sh_knife_minigame. But the actual name of the minigame is located in MINIGAME.lang.name(.en)
    -- TODO add 'displayName' property to minigame and fill it with MINIGAME.lang.name(.en)
    form:MakeCheckBox({
        label = {
            string = "label_ttt2_minigames_minigame_enabled",
            params = {
                name = self.minigame.name
            },
            translateParams = true
        },
        serverConvar = "ttt2_minigames_" .. self.minigame.name .. "_enabled",
        master = masterEnb
    })

    form:MakeSlider({
        label = "label_ttt2_minigames_minigame_random",
        serverConvar = "ttt2_minigames_" .. minigame.name .. "_random",
        min = 0,
        max = 100,
        decimal = 0,
        master = masterEnb
    })