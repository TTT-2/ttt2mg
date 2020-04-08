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

local BASE_MINIGAME_CLASS = "minigame_base"
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
	t.id = name
	t.isAbstract = t.isAbstract or false

	t.index = table.Count(MGList)

	MGList[name] = t
end

---
-- Automatically generates ConVars based on the minigames data
-- @param table minigame The minigame table
-- @todo ConVar list
-- @realm shared
-- @local
local function SetupData(minigame)
	print("[TTT2][MINIGAMES] Adding '" .. minigameData.name .. "' minigame...")

	if not SERVER then return end

	---
	-- @name ttt2_minigames_[MINIGAME]_enabled
	CreateConVar("ttt2_minigames_" .. minigameData.name .. "_enabled", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})

	---
	-- @name ttt2_minigames_[MINIGAME]_random
	CreateConVar("ttt2_minigames_" .. minigameData.name .. "_random", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED})
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
	end

	-- Setup data (eg. convars for all minigames)
	for _, v in pairs(MGList) do
		if v.name ~= BASE_MINIGAME_CLASS then
			SetupData(v)
		end
	end
end

---
-- Get a minigame by name (a copy)
-- @param string name minigame name
-- @param[opt] ?table retTbl this table will be modified and returned. If nil, a new table will be created.
-- @return table returns the modified retTbl or the new minigame table
-- @realm shared
-- @internal
function minigames.Get(name, retTbl)
	local Stored = minigames.GetStored(name)
	if not Stored then return end

	-- Create/copy a new table
	local retval = retTbl or {}

	for k, v in pairs(Stored) do
		if istable(v) then
			retval[k] = table.Copy(v)
		else
			retval[k] = v
		end
	end

	retval.Base = retval.Base or BASE_MINIGAME_CLASS

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

			if minigame:IsActive() then continue end -- don't include active minigames

			if not GetConVar("ttt2_minigames_" .. minigame.name .. "_enabled"):GetBool() then continue end

			if forcedNextMinigame and forcedNextMinigame.name == minigame.name then
				forcedNextMinigame = nil

				return minigame
			end

			local b = true
			local r = GetConVar("ttt2_minigames_" .. minigame.name .. "_random"):GetInt()

			if r > 0 and r < 100 then
				b = math.random(100) <= r
			elseif r <= 0 then
				b = false
			end

			if b then
				availableMinigames[#availableMinigames + 1] = minigame
			end
		end

		if #availableMinigames == 0 then return end

		return availableMinigames[math.random(#availableMinigames)]
	end
end

---
-- Returns a list of active minigames
-- @return table list of active minigames
-- @realm shared
function minigames.GetActiveList()
	local activeMinigames = {}
	local mgs = GetList()

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
-- @param number index minigame id
-- @return table returns the minigame table.
-- @realm shared
function minigames.GetByIndex(index)
	for _, v in pairs(MGList) do
		if v.name ~= BASE_ROLE_CLASS and v.index == index then
			return v
		end
	end
end
