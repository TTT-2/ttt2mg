# ttt2mg
The TTT2 Minigames gamemode. It adds custom minigames into TTT2. It fully supports TTT2 ULX.

# Customization
## TTT2 ULX
You can modify or force a gamemode with the help of TTT2 ULX

## ConVars
If you don't wanna use TTT2 ULX, you can modify these ConVars on your own:

ConVar | Utilization | Realm
--- | --- | ---
`ttt2_minigames` | Toggle whether the `Minigame`s gamemode is enabled | `server`
`ttt2_minigames_autostart_random` | Set the randomness so that it switches (randomly) whether a `Minigame` should start with each round | `server`
`ttt2_minigames_autostart_rounds` | Set the amount of rounds a `Minigame` should start | `server`
`ttt2_minigames_show_popup` | Toggle whether the `Minigame`'s name and the description should be displayed on start | `client`

# Developer section
## How to create a custom `Minigame`?

1. Create a folder with the add-on name you prefere (need to be an unique folder name). Pay attention to keep the name lowercase.
2. Create a `lua` folder in this new created folder
3. Create a `minigames` folder in the `lua` folder
4. Create another `minigames` folder in the previously created `minigames` folder. Yea, seems to be redundant, but it isn't.
5. Create a .lua file with the name of your new minigame (need to be an unique name!), e.g. `sh_my_unique_cool_minigame.lua`, in the folder `lua/minigames/minigames/`.
6. Modify the following code as you prefere:

```lua
MINIGAME.author = "TheNameNobodyIsInterestedInAndNobodyGonnaGiveALook" -- author
MINIGAME.contact = "NobodyWritesMe@mail.cry" -- contact to the author

---
-- Called if the @{MINIGAME} activates
-- @hook
-- @realm shared
function MINIGAME:OnActivation()

end

---
-- Called if the @{MINIGAME} deactivates
-- @hook
-- @realm shared
function MINIGAME:OnDeactivation()

end
```

Here is an easy example of a `Minigame`: [Hardcore Minigame](https://github.com/TTT-2/ttt2mg/blob/master/lua/minigames/minigames/sh_hardcore_minigame.lua)

## How to customize and interact with this TTT2 gamemode?

### MINIGAME
#### Hooks (**`shared`**)
Hook | Utilization
--- | ---
`MINIGAME:PreInitialize()` | Called before the `Minigame`'s data is loaded
`MINIGAME:SetupData()` | Called as soon as the default data has been loaded and the `Minigame` has be pre-initialized
`MINIGAME:Initialize()` | Is automatically called as soon as the `Minigame` data has been loaded
`MINIGAME:OnActivation()` | Called if the `Minigame` is activated
`MINIGAME:OnDeactivation()` | Called if the `Minigame` is deactivated

#### Functions
Function | Utilization | Realm
--- | --- | ---
`MINIGAME:Activate()` | Activates the `Minigame`. By default, this is done autimatically (internally) | `shared`
`MINIGAME:Deactivate()` | Deactivates the `Minigame`. By default, this is done autimatically (internally) | `shared`
`MINIGAME:IsActive()` | Returns whether the `Minigame` is active | `shared`
`MINIGAME:IsSelectable()` | Returns whether the `Minigame` is selectable (and take place in the `minigame`s selection) | `server`
`MINIGAME:ShowActivationEPOP()` | Should be used to display a EPOP message informing the player about the `Minigame` activation (automatically called as soon as the `Minigame` is activated) | `client`

### `minigames` module
#### Functions
Function | Utilization | Realm
--- | --- | ---
`minigames.IsBasedOn(name, base)` | Checks if name is based on base | `shared`
`minigames.GetStored(name)` | Gets the real `Minigame` table (not a copy) | `shared`
`minigames.GetList()` | Get a list (copy) of all registered `Minigame`s, that can be displayed (no abstract `Minigame`s) | `shared`
`minigames.GetRealList()`| Get an indexed list of all the registered `Minigame`s including abstract `Minigame`s | `shared`
`minigames.GetActiveList()`| Returns a list of active `Minigame`s | `shared`
`minigames.GetById(id)` | Get the `Minigame` table by the `Minigame` id | `shared`
`minigames.ForceNextMinigame(minigame)` | Forces the next `Minigame` | `server`
`minigames.GetForcedNextMinigame()`| Returns the next forced `Minigame` | `server`
`minigames.Select()`| Selects a `Minigame` based on the current available `Minigame`s | `server`

### global functions (**`shared`**)
Function | Utilization
--- | ---
`ActivateMinigame(minigame)` | Activates a `Minigame`. If called on `server`, the sync with the `client`s will be run. If called on `client`, a popup will be displayed for 12 seconds
`DeactivateMinigame(minigame)` | Deactivates a `Minigame`. If called on `server`, the sync with the `client`s will be run.

### `GAMEMODE` hooks (**`shared`**)
Hook | Utilization
--- | ---
`TTT2MGPreActivate(minigame)`| Called right before the `Minigame` activates
`TTT2MGActivate(minigame)` | Called if the `Minigame` activates
`TTT2MGPostActivate(minigame)` | Called after the `Minigame` was activated
`TTT2MGPreDeactivate(minigame)`| Called right before the `Minigame` deactivates
`TTT2MGDeactivate(minigame)` | Called if the `Minigame` deactivates
`TTT2MGPostDeactivate(minigame)` | Called after the `Minigame` was deactivated
`TTT2MinigamesLoaded()` | Called as soon as every `MINIGAME` was loaded

### Multilanguage support
Here is an example how to add language support to your `Minigame`:

```lua
MINIGAME.lang = {
	name = {
		English = "Example Minigame"
	},
	desc = {
		English = "Some interesting facts about or something similar."
	}
}
```

### Dynamical ULX ConVar support
If you wanna add ConVars with ULX support easily to your `Minigame`, use this codesnippet:

```lua
MINIGAME.conVarData = {
	ttt2_minigames_minigamename_uniquename = { -- the ConVar name. Should match the serverside ConVar name
		slider = true, -- if it's a number, you should use a slider
		min = 1,
		max = 2,
		decimal = 2, -- it's a float
		desc = "Set the ... (Def. 1.5)"
	},
	ttt2_minigames_minigamename_bool = {
		checkbox = true, -- if it's a bool, you should use a checkbox
		desc = "Toggle ... (Def. 1)"
	}
}
```
