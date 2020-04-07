---
-- @author Alf21
-- @module MINIGAME

MINIGAME.printName = "Scripted MINIGAME" -- displayed @{MINIGAME} name (Shown on HUD), language supported
MINIGAME.author = "" -- author
MINIGAME.contact = "" -- contact to the author
MINIGAME.description = "" -- some Instructions for this @{MINIGAME}

local active = false

---
-- Called if the @{MINIGAME} activates
-- @hook
-- @realm shared
function MINIGAME:Activate()
	active = true
end

---
-- Called if the @{MINIGAME} deactivates
-- @hook
-- @realm shared
function MINIGAME:Deactivate()
	active = false
end

---
-- Returns whether the current minigame is active
-- @realm shared
function MINIGAME:IsActive()
	return active
end