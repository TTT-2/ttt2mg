---
-- This is the <code>minigames</code> module
-- @author Alf21
-- @author saibotk
-- @module minigames
minigames = {}

local baseclass = baseclass
local pairs = pairs
local istable = istable

if SERVER then
	AddCSLuaFile()
end

local MGList = MGList or {}

---
-- Copies any missing data from base table to the target table
-- @param table t target table
-- @param table base base (fallback) table
-- @return table t target table
-- @realm shared
local function TableInherit(t, base)
	for k, v in pairs(base) do
		if t[k] == nil then
			t[k] = v
		elseif k ~= "BaseClass" and istable(t[k]) and istable(v[k]) then
			TableInherit(t[k], v)
		end
	end

	return t
end

---
-- Checks if name is based on base
-- @param table name table to check
-- @param table base base (fallback) table
-- @return boolean returns whether name is based on base
-- @realm shared
function minigames.IsBasedOn(name, base)
	local t = minigames.GetStored(name)

	if not t then
		return false
	end

	if t.Base == name then
		return false
	end

	if t.Base == base then
		return true
	end

	return minigames.IsBasedOn(t.Base, base)
end

---
-- Used to register your minigame with the engine.<br />
-- <b>This is done automatically for all the files in the <code>lua/terrortown/entities/minigames</code> folder</b>
-- @param table t minigame table
-- @param string name minigame name
-- @realm shared
-- @internal
function minigames.Register(t, name)
	name = string.lower(name)

	t.ClassName = name
	t.name = name
	t.isAbstract = t.isAbstract or false

	t.id = table.Count(MGList)

	MGList[name] = t
end

---
-- Automatically generates ConVars based on the minigames data
-- @param table minigame The minigame table
-- @todo ConVar list
-- @realm shared
-- @local
local function SetupData(minigame)
	print("[TTT2][MINIGAMES] Adding '" .. minigame.name .. "' minigame...")

	if not SERVER then return end

	---
	-- @name ttt2_minigames_[MINIGAME]_enabled
	CreateConVar("ttt2_minigames_" .. minigame.name .. "_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	---
	-- @name ttt2_minigames_[MINIGAME]_random
	CreateConVar("ttt2_minigames_" .. minigame.name .. "_random", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	minigame:SetupData()
end

---
-- All scripts have been loaded...
-- @realm shared
-- @internal
function minigames.OnLoaded()

	--
	-- Once all the scripts are loaded we can set up the baseclass
	-- - we have to wait until they're all setup because load order
	-- could cause some entities to load before their bases!
	--
	for k in pairs(MGList) do
		local newTable = minigames.Get(k)
		MGList[k] = newTable

		baseclass.Set(k, newTable)

		if not newTable.isAbstract then
			newTable:PreInitialize()
		end
	end

	-- Setup data (eg. convars for all @{MINIGAME}s)
	for _, v in pairs(MGList) do
		if not v.isAbstract then
			SetupData(v)
		end
	end

	-- Call Initialize() on all @{MINIGAME}s
	for _, v in pairs(MGList) do
		if not v.isAbstract then
			v:Initialize()
		end
	end

	hook.Run("TTT2MinigamesLoaded")
end

---
-- Get a minigame by name (a copy)
-- @param string name minigame name
-- @param[opt] ?table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @return table returns the modified retTbl or the new minigame table
-- @realm shared
-- @internal
function minigames.Get(name, retTbl)
	local stored = minigames.GetStored(name)
	if not stored then return end

	-- Create/copy a new table
	local retval = retTbl or {}

	if retTbl ~= stored then
		for k, v in pairs(stored) do
			if istable(v) then
				retval[k] = table.Copy(v)
			else
				retval[k] = v
			end
		end
	end

	retval.Base = retval.Base or "minigame_base"

	-- If we're not derived from ourselves (a base minigame element)
	-- then derive from our 'Base' minigame element.
	if retval.Base ~= name then
		local base = minigames.Get(retval.Base)

		if not base then
			Msg("ERROR: Trying to derive minigame " .. tostring(name) .. " from non existant minigame " .. tostring(retval.Base) .. "!\n")
		else
			retval = TableInherit(retval, base)
		end
	end

	return retval
end

---
-- Gets the real minigame table (not a copy)
-- @param string name minigame name
-- @return table returns the real minigame table
-- @realm shared
function minigames.GetStored(name)
	return MGList[name]
end

---
-- Get a list (copy) of all registered minigames, that can be displayed (no abstract minigames)
-- @return table available minigames
-- @realm shared
function minigames.GetList()
	local result = {}

	for _, v in pairs(MGList) do
		if not v.isAbstract then
			result[#result + 1] = v
		end
	end

	return result
end

---
-- Get an indexed list of all the registered minigames including abstract minigames
-- @return table all registered minigames
-- @realm shared
function minigames.GetRealList()
	local result = {}

	for _, v in pairs(MGList) do
		result[#result + 1] = v
	end

	return result
end

if SERVER then
	local forcedNextMinigame

	---
	-- Forces the next minigame
	-- @param table minigame minigames table
	function minigames.ForceNextMinigame(minigame)
		forcedNextMinigame = minigame
	end

	---
	-- Returns the next forced minigame
	-- @return table minigames table
	function minigames.GetForcedNextMinigame()
		return forcedNextMinigame
	end

	---
	-- Selects a minigame based on the current available minigames
	-- @return ?table minigame table
	-- @realm server
	function minigames.Select()
		local mgs = minigames.GetList()

		if #mgs == 0 then return end

		local availableMinigames = {}

		for i = 1, #mgs do
			local minigame = mgs[i]

			-- don't include active, disabled or unselectable minigames
			if minigame:IsActive()
			or not GetConVar("ttt2_minigames_" .. minigame.name .. "_enabled"):GetBool()
			or not minigame:IsSelectable() then
				continue
			end

			if forcedNextMinigame and forcedNextMinigame.name == minigame.name then
				forcedNextMinigame = nil

				return minigame
			end

			if math.random(100) <= GetConVar("ttt2_minigames_" .. minigame.name .. "_random"):GetInt() then
				availableMinigames[#availableMinigames + 1] = minigame
			end
		end

		if #availableMinigames == 0 then return end

		return availableMinigames[math.random(#availableMinigames)]
	end

	---
	-- Returns whether a random minigame should start
	-- @return bool
	-- @realm server
	-- @internal
	function minigames.CheckAutostart()
		local autostartRounds = GetConVar("ttt2_minigames_autostart_rounds"):GetInt()

		if autostartRounds > 0 then
			local roundCount = GetConVar("ttt_round_limit"):GetInt() - GetGlobalInt("ttt_rounds_left")

			return roundCount % autostartRounds == 0
		end

		return math.random(100) <= GetConVar("ttt2_minigames_autostart_random"):GetFloat()
	end
end

---
-- Returns a list of active minigames
-- @return table list of active minigames
-- @realm shared
function minigames.GetActiveList()
	local activeMinigames = {}
	local mgs = minigames.GetList()

	for i = 1, #mgs do
		local mg = mgs[i]

		if mg:IsActive() then
			activeMinigames[#activeMinigames + 1] = mg
		end
	end

	return activeMinigames
end

---
-- Get the minigame table by the minigame id
-- @param number id minigame id
-- @return table returns the minigame table.
-- @realm shared
function minigames.GetById(id)
	for _, v in pairs(MGList) do
		if v.name ~= BASE_ROLE_CLASS and v.id == id then
			return v
		end
	end
end
