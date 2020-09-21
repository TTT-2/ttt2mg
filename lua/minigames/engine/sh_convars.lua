local function GetConVarData(minigame)
	local cvd = minigame.conVarData or {}

	local name = "ttt2_minigames_" .. minigame.name .. "_enabled"

	cvd[name] = cvd[name] or {
		checkbox = true,
		desc = "Enabled? (def. 1)"
	}

	name = "ttt2_minigames_" .. minigame.name .. "_random"

	cvd[name] = cvd[name] or {
		slider = true,
		min = 0,
		max = 100,
		decimal = 0,
		desc = "Random Chance: (def. 100)"
	}

	return cvd
end

if SERVER then
	local function AutoReplicateConVar(name, data)
		local cv = GetConVar(name)

		if not cv then return end

		local cv_value

		if data.slider and not data.decimal then
			cv_value = cv:GetInt()
		elseif data.slider then
			cv_value = cv:GetFloat()
		elseif data.checkbox then
			cv_value = cv:GetBool()
		else
			cv_value = cv:GetString()
		end

		ULib.replicatedWritableCvar(
			name,
			"rep_" .. name,
			cv_value,
			true,
			true,
			"xgui_gmsettings"
		)
	end

	local ttt2_minigames = CreateConVar("ttt2_minigames", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	local ttt2_minigames_autostart_random = CreateConVar("ttt2_minigames_autostart_random", "100", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	local ttt2_minigames_autostart_rounds = CreateConVar("ttt2_minigames_autostart_rounds", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	-- ConVar Replicating
	hook.Add("TTT2MinigamesLoaded", "TTT2MGInitRWCVar", function()
		ULib.replicatedWritableCvar(ttt2_minigames:GetName(), "rep_" .. ttt2_minigames:GetName(), ttt2_minigames:GetBool(), true, true, "xgui_gmsettings")
		ULib.replicatedWritableCvar(ttt2_minigames_autostart_random:GetName(), "rep_" .. ttt2_minigames_autostart_random:GetName(), ttt2_minigames_autostart_random:GetFloat(), true, true, "xgui_gmsettings")
		ULib.replicatedWritableCvar(ttt2_minigames_autostart_rounds:GetName(), "rep_" .. ttt2_minigames_autostart_rounds:GetName(), ttt2_minigames_autostart_rounds:GetInt(), true, true, "xgui_gmsettings")

		---- minigames dynamical ConVars
		local mgs = minigames.GetList()

		for i = 1, #mgs do
			local mg = mgs[i]
			local cvd = GetConVarData(mg)

			for name, data in pairs(cvd) do
				AutoReplicateConVar(name, data)
			end
		end
	end)
else
	CreateConVar("ttt2_minigames_show_popup", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	hook.Add("TTTUlxModifyAddonSettings", "TTT2MGModifySettings", function(settingsName)
		local pnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		local clp = vgui.Create("DCollapsibleCategory", pnl)
		clp:SetSize(390, 200)
		clp:SetExpanded(1)
		clp:SetLabel("Basic Settings")

		local lst = vgui.Create("DPanelList", clp)
		lst:SetPos(5, 25)
		lst:SetSize(390, 250)
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
			label = "Setting TTT2 Minigames autostart rounds to 2 will lead to the result that a random minigame is activated on every second round. Setting it to 0 will activate the autostart randomness and vice-versa.",
			parent = lst
		})

		lst:AddItem(xlib.makeslider{
			label = "ttt2_minigames_autostart_rounds (Def. 0)",
			min = 0,
			max = 100,
			decimal = 0,
			repconvar = "rep_ttt2_minigames_autostart_rounds",
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
			label = "Setting TTT2 Minigames autostart to 100 (%) will lead to the result that a random minigame is activated on every round start. Deactivated if ttt2_minigames_autostart_rounds is not 0!",
			parent = lst
		})

		lst:AddItem(xlib.makeslider{
			label = "ttt2_minigames_autostart_random (Def. 100)",
			min = 0,
			max = 100,
			decimal = 0,
			repconvar = "rep_ttt2_minigames_autostart_random",
			parent = lst
		})

		---- minigames dynamical ConVars
		local mgs = minigames.GetList()
		local b = true

		for i = 1, #mgs do
			local mg = mgs[i]
			local cvd = GetConVarData(mg)
			local size = 0

			for _, data in pairs(cvd) do
				if data.slider then
					size = size + 25
				end

				if data.checkbox then
					size = size + 20
				end

				if data.combobox then
					size = size + 30

					if data.desc then
						size = size + 13
					end
				end

				if data.label then
					size = size + 13
				end
			end

			clp = vgui.Create("DCollapsibleCategory", pnl)
			clp:SetSize(390, size)
			clp:SetExpanded(b and 1 or 0)
			clp:SetLabel(LANG.TryTranslation("ttt2_minigames_" .. mg.name .. "_name"))

			b = false

			lst = vgui.Create("DPanelList", clp)
			lst:SetPos(5, 25)
			lst:SetSize(390, size)
			lst:SetSpacing(5)

			for name, data in pairs(cvd) do
				if data.checkbox then
					lst:AddItem(xlib.makecheckbox{
						label = data.desc or name,
						repconvar = "rep_" .. name,
						parent = lst
					})
				elseif data.slider then
					lst:AddItem(xlib.makeslider{
						label = data.desc or name,
						min = data.min or 1,
						max = data.max or 1000,
						decimal = data.decimal or 0,
						repconvar = "rep_" .. name,
						parent = lst
					})
				elseif data.combobox then
					lst:AddItem(xlib.makelabel{
						label = data.desc or name,
						parent = lst
					})

					lst:AddItem(xlib.makecombobox{
						enableinput = data.enableinput or false,
						choices = data.choices,
						isNumberConvar = true,
						repconvar = "rep_" .. name,
						numOffset = (-1) * (data.numStart or 0) + 1,
						parent = lst
					})
				elseif data.label then
					lst:AddItem(xlib.makelabel{
						label = data.desc or "",
						parent = lst
					})
				end
			end
		end

		xgui.hookEvent("onProcessModules", nil, pnl.processModules)
		xgui.addSubModule("TTT2 Minigames", pnl, nil, settingsName)
	end)
end
