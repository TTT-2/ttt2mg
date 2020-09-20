---
-- @author Alf21
-- @module MINIGAME

MINIGAME.author = "" -- author
MINIGAME.contact = "" -- contact to the author

MINIGAME.isAbstract = true -- abstract MINIGAME you can derive from

MINIGAME.m_bActive = false

---
-- Activates the @{MINIGAME}
-- @realm shared
function MINIGAME:Activate()
	self:OnActivation()

	self.m_bActive = true

	if CLIENT and GetConVar("ttt2_minigames_show_popup"):GetBool() then -- show popup if the @{MINIGAME} is activated
		self:ShowActivationEPOP()
	end
end

---
-- Called if the @{MINIGAME} activates
-- @note At the time of the call, the @{MINIGAME} does not yet return `true` with @{MINIGAME:IsActive()}
-- @hook
-- @realm shared
function MINIGAME:OnActivation()

end

---
-- Deactivates the @{MINIGAME}
-- @realm shared
function MINIGAME:Deactivate()
	self:OnDeactivation()

	self.m_bActive = false
end

---
-- Called if the @{MINIGAME} deactivates
-- @note At the time of the call, the @{MINIGAME} does not yet return `false` with @{MINIGAME:IsActive()}
-- @hook
-- @realm shared
function MINIGAME:OnDeactivation()

end

---
-- Returns whether the current @{MINIGAME} is active
-- @return bool
-- @realm shared
function MINIGAME:IsActive()
	return self.m_bActive
end

if SERVER then
	---
	-- This function is run in TTTRoundBegin hook and checks whether this @{MINIGAME} should take place in the selection
	-- @return bool whether the @{MINIGAME} should have the chance to get selected
	-- @realm server
	function MINIGAME:IsSelectable()
		return true
	end
else
	---
	-- This function is called as soon as the @{MINIGAME} is activated and should be used to display a EPOP message informing the player about the activation
	-- @realm client
	function MINIGAME:ShowActivationEPOP()
		if not istable(self.lang) or not EPOP then return end

		EPOP:AddMessage({
				text = LANG.TryTranslation("ttt2_minigames_" .. self.name .. "_name"),
				color = COLOR_ORANGE
			},
			self.lang.desc and LANG.TryTranslation("ttt2_minigames_" .. self.name .. "_desc") or nil,
			12,
			true
		)
	end
end
