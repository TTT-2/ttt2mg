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

function GamemodeCheck(calling_ply)
    if GetConVar("gamemode"):GetString() ~= "terrortown" then
        ULib.tsayError(calling_ply, gamemode_error, true)

        return true
    else
        return false
    end
end

-- update the minigames list (autocomplete)

ulx.target_minigames = ulx.target_minigames or {}

function updateMinigames()
    table.Empty(ulx.target_minigames)

    local mgs = minigames.GetList()

    for i = 1, #mgs do
        ulx.target_minigames[#ulx.target_minigames + 1] = mgs[i].name
    end
end

hook.Add(ULib.HOOK_UCLCHANGED, "ULXMinigamesNamesUpdate", updateMinigames)

updateMinigames()

--

---
-- Forces a specific minigame
-- @param Player calling_ply The player who used the command
-- @param string target_minigame The specific minigame id
function ulx.forceminigame(calling_ply, target_minigame)
    if not GamemodeCheck(calling_ply) or not target_minigame then return end

    local mg = minigames.GetByName(target_minigame)
    if not mg then return end

    minigames.ForceNextMinigame(mg)

    ulx.fancyLogAdmin(calling_ply, should_silent, "#A forced minigame '#S'", calling_ply, target_minigame)
end

local forceminigame = ulx.command(CATEGORY_NAME, "ulx forceminigame", ulx.forceminigame, "!forceminigame")
forceminigame:addParam{type = ULib.cmds.StringArg, completes = ulx.target_minigames, hint = "- Select Minigame -", ULib.cmds.restrictToCompletes}
forceminigame:defaultAccess(ULib.ACCESS_SUPERADMIN)
forceminigame:setOpposite("ulx silent forceminigame", {nil, nil, nil, true}, "!sforceminigame", true)
forceminigame:help("Forces a specific minigame.")
--[End]----------------------------------------------------------------------------------------
