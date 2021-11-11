local tableCopy = table.Copy

local virtualSubmenus = {}

CLGAMEMODEMENU.base = "base_gamemodemenu"

CLGAMEMODEMENU.icon = Material("vgui/ttt/vskin/helpscreen/tttc")
CLGAMEMODEMENU.title = "menu_ttt2_minigames_title"
CLGAMEMODEMENU.description = "menu_ttt2_minigames_description"
CLGAMEMODEMENU.priority = 40

CLGAMEMODEMENU.isInitialized = false
CLGAMEMODEMENU.minigames = nil

function CLGAMEMODEMENU:IsAdminMenu()
    return true
end

function CLGAMEMODEMENU:InitializeVirtualMenus()
    virtualSubmenus = {}

    local allMinigames = minigames.GetList()
    local minigamesMenuBase = self:GetSubmenuByName("base_minigames")

    print(minigamesMenuBase)
    local counter = 0
    for i = 1, #allMinigames do
        local minigameData = allMinigames[i]

        virtualSubmenus[i] = tableCopy(minigamesMenuBase)
        virtualSubmenus[i].title = "ttt2_minigames_" .. minigameData.name .. "_name"


        virtualSubmenus[i].minigameData = minigameData
        virtualSubmenus[i].basemenu = self
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