--[[--------------------------------------------------------------------------------------------
║                            Trouble in Terrorist Town 2 Minigames                             ║
║                                          By: Alf21                                           ║
║                              ╔═════════╗╔═════════╗╔═════════╗                               ║
║                              ║ ╔═╗ ╔═╗ ║║ ╔═╗ ╔═╗ ║║ ╔═╗ ╔═╗ ║                               ║
║                              ╚═╝ ║ ║ ╚═╝╚═╝ ║ ║ ╚═╝╚═╝ ║ ║ ╚═╝                               ║
║──────────────────────────────────║ ║────────║ ║────────║ ║───────────────────────────────────║
║──────────────────────────────────║ ║────────║ ║────────║ ║───────────────────────────────────║
║──────────────────────────────────╚═╝────────╚═╝────────╚═╝───────────────────────────────────║
║                                                                                              ║
----------------------------------------------------------------------------------------------]]
local CATEGORY_NAME = "TTT2 Minigames"
local gamemode_error = "The current gamemode is not trouble in terrorest town"

local function CheckForTerrortown(calling_ply)
    if engine.ActiveGamemode() ~= "terrortown" then
        ULib.tsayError(calling_ply, gamemode_error, true)

        return false
    end

    return true
end

-- update the minigames list (autocomplete)

ulx.target_minigames = ulx.target_minigames or {}

function updateMinigames()
    table.Empty(ulx.target_minigames)

    local mgs = minigames.GetList()

    for i = 1, #mgs do
        ulx.target_minigames[i] = mgs[i].name
    end

    table.sort(ulx.target_minigames)
end

hook.Add(ULib.HOOK_UCLCHANGED, "ULXMinigamesNamesUpdate", updateMinigames)

updateMinigames()

--

---
-- Forces a specific minigame
-- @param Player calling_ply The player who used the command
-- @param string target_minigame The specific minigame id
function ulx.forceminigame(calling_ply, target_minigame)
    if not CheckForTerrortown(calling_ply) then return end

    local mg = minigames.GetStored(target_minigame)
    if not mg then
        ulx.fancyLogAdmin(calling_ply, "The selected minigame '#s' doesn't exist", target_minigame)

        return
    end

    minigames.ForceNextMinigame(mg)

    ulx.fancyLogAdmin(calling_ply, "#A forced minigame '#s'", target_minigame)
end

local forceminigame = ulx.command(CATEGORY_NAME, "ulx forceminigame", ulx.forceminigame, "!forceminigame")
forceminigame:addParam{type = ULib.cmds.StringArg, completes = ulx.target_minigames, hint = "- Select Minigame -", ULib.cmds.restrictToCompletes}
forceminigame:defaultAccess(ULib.ACCESS_SUPERADMIN)
forceminigame:help("Forces a specific minigame.")

--

---
-- Triggers a specific minigame
-- @param Player calling_ply The player who used the command
-- @param string target_minigame The specific minigame id
function ulx.triggerminigame(calling_ply, target_minigame)
    if not CheckForTerrortown(calling_ply) then return end

    local mg = minigames.GetStored(target_minigame)
    if not mg then
        ulx.fancyLogAdmin(calling_ply, "The selected minigame '#s' doesn't exist", target_minigame)

        return
    end

    if mg:IsActive() then
        ulx.fancyLogAdmin(calling_ply, "The selected minigame '#s' is already active", target_minigame)

        return
    end

    ActivateMinigame(mg)

    ulx.fancyLogAdmin(calling_ply, "#A triggered minigame '#s'", target_minigame)
end

local triggerminigame = ulx.command(CATEGORY_NAME, "ulx triggerminigame", ulx.triggerminigame, "!triggerminigame")
triggerminigame:addParam{type = ULib.cmds.StringArg, completes = ulx.target_minigames, hint = "- Select Minigame -", ULib.cmds.restrictToCompletes}
triggerminigame:defaultAccess(ULib.ACCESS_SUPERADMIN)
triggerminigame:help("Triggers a specific minigame.")
--[End]----------------------------------------------------------------------------------------
