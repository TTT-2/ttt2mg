if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/minigames/mg_icon.vmt")
end

if CLIENT then
	EVENT.title = "title_minigame"
	EVENT.icon = Material("vgui/ttt/dynamic/minigames/mg_icon.vmt")

	function EVENT:GetText()
		local mgText = {
			{
				string = "desc_minigame_name",
				params = {
					name = self.event.name
				},
				translateParams = true
			}
		}

		if #LANG.TryTranslation(self.event.desc) > 0 then
			mgText[#mgText + 1] = {
				string = "desc_minigame_desc",
				params = {
					desc = self.event.desc
				},
				translateParams = true
			}
		end

		return mgText
	end
end

if SERVER then
	function EVENT:Trigger(minigame)
		return self:Add({
			name = "ttt2_minigames_" .. minigame.name .. "_name",
			desc = "ttt2_minigames_" .. minigame.name .. "_desc",
			serialname = minigame.name
		})
	end
end

function EVENT:Serialize()
	return self.event.serialname .. " activated."
end
