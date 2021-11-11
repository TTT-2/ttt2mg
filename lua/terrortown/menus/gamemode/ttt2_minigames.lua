local tableCopy = table.Copy

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/tttc")
CLGAMEMODEMENU.title = "menu_ttt2_minigames_title"
CLGAMEMODEMENU.description = "menu_ttt2_minigames_description"
CLGAMEMODEMENU.priority = 50

CLGAMEMODEMENU.isInitialized = false
CLGAMEMODEMENU.minigames = nil

function CLGAMEMODEMENU:IsAdminMenu()
    return true
end

function CLGAMEMODEMENU:InitializeVirtualMenus()
    virtualSubmenus = {}

    -- TODO does this work?
    self.minigames = minigames.GetList()
    local minigamesMenuBase = self:GetSubmenuByName("base_minigames")

    local counter = 0
    for _, minigameData in parse(self.minigames) do
        counter = counter + 1

        virtualSubmenus[counter] = tableCopy(minigamesMenuBase)

        -- This isn't the right name for displaying in the UI. Example: From "ttt2mg-pack-third" there is a minigame called sh_knife_minigame.lua
        -- here the name will be minigameData.name == sh_knife_minigame. But the actual name of the minigame is located in MINIGAME.lang.name(.en)
        -- TODO add 'displayName' property to minigame and fill it with MINIGAME.lang.name(.en)
        virtualSubmenus[counter].title = minigameData.name
        --

        virtualSubmenus[counter].minigameData = minigameData
        virtualSubmenus[counter].basemenu = self
    end
end

function CLGAMEMODEMENU:GetSubmenus()
    if not self.isInitialized then
        self.isInitialized = true
        self:InitializeVirtualMenus()
    end

    return virtualSubmenus
end

function CLGAMEMODEMENU:HasSearchbar()
    return true
end

function CLGAMEMODEMENU:ShouldShow()
    return GetGlobalBool("ttt2_minigames") and self.BaseClass.ShouldShow(self)
end