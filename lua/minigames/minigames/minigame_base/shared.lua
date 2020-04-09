---
-- @author Alf21
-- @module MINIGAME

MINIGAME.author = "" -- author
MINIGAME.contact = "" -- contact to the author

local active = false

---
-- Activates the @{MINIGAME}
-- @realm shared
function MINIGAME:Activate()
	self:OnActivation()

	active = true
end

---
-- Called if the @{MINIGAME} activates
-- @hook
-- @realm shared
function MINIGAME:OnActivation()

end

---
-- Deactivates the @{MINIGAME}
-- @realm shared
function MINIGAME:Deactivate()
	self:OnDeactivation()

	active = false
end

---
-- Called if the @{MINIGAME} deactivates
-- @hook
-- @realm shared
function MINIGAME:OnDeactivation()

end

---
-- Returns whether the current minigame is active
-- @realm shared
function MINIGAME:IsActive()
	return active
end

if SERVER then
	---
	-- This function is run in TTTRoundBegin hook and checks whether this @{MINIGAME} should take place in the selection
	-- @return bool whether the @{MINIGAME} should have the chance to get selected
	-- @realm server
	function MINIGAME:IsSelectable()
		return true
	end
end
