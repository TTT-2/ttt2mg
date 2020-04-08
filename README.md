# ttt2mg
The TTT2 Minigames gamemode. It adds custom minigames into TTT2. It fully supports TTT2 ULX.


# Developer section
## How to create a custom Minigame?

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

## How to customize and interact with this TTT2 gamemode?

### MINIGAME
#### Hooks (**`shared`**)
Hook | Utilization
--- | ---
`MINIGAME:OnActivation` | Called if the Minigame is activated
`MINIGAME:OnDeactivation` | Called if the Minigame is deactivated

#### Functions (**`shared`**)
Function | Utilization
--- | ---
`MINIGAME:Activate` | Activates the Minigame. By default, this is done autimatically (internally)
`MINIGAME:Deactivate` | Deactivates the Minigame. By default, this is done autimatically (internally)
`MINIGAME:IsActive` | Returns whether the Minigame is active

### minigames module
#### Functions
Function | Utilization | realm
--- | --- | ---
`minigames.IsBasedOn` | Checks if name is based on base | `shared`
`minigames.GetStored` | Gets the real minigame table (not a copy) | `shared`
`minigames.GetList` | Get a list (copy) of all registered minigames, that can be displayed (no abstract minigames) | `shared`
`minigames.GetRealList`| Get an indexed list of all the registered minigames including abstract minigames | `shared`
`minigames.GetActiveList`| Returns a list of active minigames | `shared`
`minigames.GetByIndex` | Get the minigame table by the minigame id | `shared`
`minigames.ForceNextMinigame` | Forces the next minigame | `server`
`minigames.GetForcedNextMinigame`| Returns the next forced minigame | `server`
`minigames.Select`| Selects a minigame based on the current available minigames | `server`

# TODO
- global functions
- ConVars
- Hooks
