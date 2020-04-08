# ttt2mg
TTT2 Minigames gamemode

# How to add an own minigame?

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
