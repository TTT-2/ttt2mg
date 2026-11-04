--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 96
CLGAMEMODESUBMENU.title = "submenu_guide_minigames_title"

local TryT = LANG.TryTranslation
local GetRawT = LANG.GetRawTranslation

local heightMinigameButton = 50
local widthMinigameListMin = 200
local widthMinigameListMax = 320
local widthMinigameListPercent = 0.33

local lastActive

---
-- Creates a label that wraps its text if it does not fit into a single line.
-- @note A plain `DLabel` is used here, because `DLabelTTT2` paints its text with
-- `draw.SimpleText`, which does not wrap long texts such as minigame descriptions.
-- @param Panel parent The parent panel
-- @param string text The text that should be displayed
-- @param[opt] string font The font that should be used
-- @return Panel The created label
-- @realm client
local function CreateWrappedLabel(parent, text, font)
	local label = vgui.Create("DLabel", parent)
	label:Dock(TOP)
	label:SetText(text)
	label:SetFont(font or "DermaTTT2Text")
	label:SetWrap(true)
	label:SetAutoStretchVertical(true)
	label:DockMargin(10, 5, 10, 5)

	return label
end

---
-- Returns the translated name of the given minigame.
-- @param table minigameData The minigame table
-- @return string The translated name
-- @realm client
local function GetMinigameTitle(minigameData)
	return GetRawT("ttt2_minigames_" .. minigameData.name .. "_name") or minigameData.name
end

---
-- Returns all minigames that are currently enabled on the server. Minigames that are disabled
-- in the minigame settings are not included, as they cannot be played.
-- @param function callback Called with the list of minigames that should be shown
-- @realm client
local function GetVisibleMinigames(callback)
	minigames.RequestEnabledMinigames(function(enabledMinigames)
		local visibleMinigames = {}
		local allMinigames = minigames.GetList()

		for i = 1, #allMinigames do
			local minigameData = allMinigames[i]

			if enabledMinigames[minigameData.name] then
				visibleMinigames[#visibleMinigames + 1] = {
					minigame = minigameData,
					title = GetMinigameTitle(minigameData),
				}
			end
		end

		-- sort the minigames by their translated name for a stable alphabetical order
		table.SortByMember(visibleMinigames, "title", true)

		callback(visibleMinigames)
	end)
end

---
-- Populates the info panel with the details of the given minigame.
-- @param Panel parent The parent panel
-- @param table minigameData The minigame whose details should be displayed
-- @realm client
local function PopulateMinigameInfo(parent, minigameData)
	CreateWrappedLabel(parent, GetMinigameTitle(minigameData), "DermaTTT2TextLarger")

	-- minigame description, minigame addons provide it with the same language identifier the
	-- minigame settings menu uses
	local description = GetRawT("ttt2_minigames_" .. minigameData.name .. "_desc")
		or TryT("guide_minigame_no_description")

	CreateWrappedLabel(parent, description, "DermaTTT2Text")
end

---
-- Displays the details of the given minigame in the info panel.
-- @param Panel infoPanel The scroll panel that contains the minigame details
-- @param table minigameData The minigame whose details should be displayed
-- @param Panel minigameButton The button that belongs to the minigame
-- @realm client
local function SelectMinigame(infoPanel, minigameData, minigameButton)
	infoPanel:Clear()

	PopulateMinigameInfo(infoPanel, minigameData)

	-- handle the set/unset of active buttons for the draw process
	if IsValid(lastActive) and lastActive.SetActive then
		lastActive:SetActive(false)
	end

	minigameButton:SetActive()
	lastActive = minigameButton

	-- always show the beginning of a minigame's description
	infoPanel:GetVBar():SetScroll(0)
	infoPanel:InvalidateLayout(true)
end

function CLGAMEMODESUBMENU:Populate(parent)
	lastActive = nil

	local width, height = parent:GetSize()

	-- the parent is a scroll panel, the container takes its size to prevent scrolling
	-- of the whole page, the minigame list and the minigame details scroll on their own
	local container = vgui.Create("DPanelTTT2", parent)
	container:Dock(TOP)
	container:SetTall(height)

	local widthMinigameList =
		math.Clamp(width * widthMinigameListPercent, widthMinigameListMin, widthMinigameListMax)

	local listPanel = vgui.Create("DScrollPanelTTT2", container)
	listPanel:Dock(LEFT)
	listPanel:SetWide(widthMinigameList)
	listPanel:DockMargin(0, 0, 10, 0)

	local infoPanel = vgui.Create("DScrollPanelTTT2", container)
	infoPanel:Dock(FILL)

	GetVisibleMinigames(function(visibleMinigames)
		-- the menu can be closed while the minigame settings are fetched from the server
		if not IsValid(listPanel) or not IsValid(infoPanel) then
			return
		end

		-- nothing can be selected if no minigame is enabled
		if #visibleMinigames == 0 then
			CreateWrappedLabel(infoPanel, TryT("guide_minigame_none"))

			return
		end

		local firstMinigame, firstMinigameButton

		for i = 1, #visibleMinigames do
			local minigameData = visibleMinigames[i].minigame

			local minigameButton = vgui.Create("DSubmenuButtonTTT2", listPanel)
			minigameButton:Dock(TOP)
			minigameButton:DockMargin(0, 0, 0, 5)
			minigameButton:SetTitle(visibleMinigames[i].title)

			minigameButton.PerformLayout = function(panel)
				panel:SetSize(panel:GetParent():GetWide(), heightMinigameButton)
			end

			minigameButton.DoClick = function(slf)
				SelectMinigame(infoPanel, minigameData, slf)
			end

			if not firstMinigame then
				firstMinigame = minigameData
				firstMinigameButton = minigameButton
			end
		end

		-- preselect the first minigame so the info panel is never empty
		if firstMinigame then
			SelectMinigame(infoPanel, firstMinigame, firstMinigameButton)
		end
	end)
end
