if SERVER then
    local ttt2_minigames = CreateConVar("ttt2_minigames", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
    local ttt2_minigames_autostart = CreateConVar("ttt2_minigames_autostart", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    -- ConVar Replicating
    hook.Add("TTTUlxInitCustomCVar", "TTT2MGInitRWCVar", function(name)
        ULib.replicatedWritableCvar(ttt2_minigames:GetName(), "rep_" + ttt2_minigames:GetName(), ttt2_minigames:GetBool(), true, true, "xgui_gmsettings")
        ULib.replicatedWritableCvar(ttt2_minigames_autostart:GetName(), "rep_" + ttt2_minigames_autostart:GetName(), ttt2_minigames_autostart:GetInt(), true, true, "xgui_gmsettings")
    end)
else
    CreateConVar("ttt2_minigames_show_popup", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

    hook.Add("TTTUlxModifyAddonSettings", "TTT2MGModifySettings", function(name)
        local pnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

        local clp = vgui.Create("DCollapsibleCategory", pnl)
        clp:SetSize(390, 110)
        clp:SetExpanded(1)
        clp:SetLabel("Basic Settings")

        local lst = vgui.Create("DPanelList", clp)
        lst:SetPos(5, 25)
        lst:SetSize(390, 110)
        lst:SetSpacing(5)

        lst:AddItem(xlib.makelabel{
            x = 0,
            y = 0,
            w = 415,
            wordwrap = true,
            label = "Disabling TTT2 Minigames disables the functionality of any add-on that depends on it.",
            parent = lst
        })

        lst:AddItem(xlib.makecheckbox{
            label = "Enable TTT2 Minigames? (ttt2_minigames) (Def. 1)",
            repconvar = "rep_ttt2_minigames",
            parent = lst
        })

        lst:AddItem(xlib.makelabel{ -- empty line
            x = 0,
            y = 0,
            w = 415,
            wordwrap = true,
            label = "",
            parent = lst
        })

        lst:AddItem(xlib.makelabel{
            x = 0,
            y = 0,
            w = 415,
            wordwrap = true,
            label = "Enabling TTT2 Minigames autostart will lead to the result that a random minigame is activated on every round start.",
            parent = lst
        })

        lst:AddItem(xlib.makecheckbox{
            label = "Enable TTT2 Minigames autostart? (ttt2_minigames_autostart) (Def. 1)",
            repconvar = "rep_ttt2_minigames_autostart",
            parent = lst
        })

        xgui.hookEvent("onProcessModules", nil, pnl.processModules)
        xgui.addSubModule("TTT2 Minigames", pnl, nil, name)
    end)
end
