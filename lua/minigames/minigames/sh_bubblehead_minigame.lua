if SERVER then
	AddCSLuaFile()
end

MINIGAME.author = "Alf21"
MINIGAME.contact = "TTT2 Discord"

if CLIENT then
	MINIGAME.lang = {
		name = {
			English = "Bubblehead Minigame"
		},
		desc = {
			English = "Make a headshot, make a kill. It shouldn't be as hard as it sounds..."
		}
	}
else
	local modifiedPlys = {}
	local HEADBONE_SCALE = 1
	local ARMBONES_SCALE = 1

	local ttt2_minigames_bubblehead_headscale = CreateConVar("ttt2_minigames_bubblehead_headscale", "1.5", {FCVAR_ARCHIVE}, "Set the headbone scale")
	local ttt2_minigames_bubblehead_armscale = CreateConVar("ttt2_minigames_bubblehead_armscale", "0.15", {FCVAR_ARCHIVE}, "Set the armbones scale")

	local function ScaleBone(ply, boneName, scaleValue)

		-- get the head bone
		local headboneId = ply:LookupBone(boneName)
		if headboneId == nil then
			return false
		end

		-- modify the headbone scaling
		ply:ManipulateBoneScale(headboneId, isvector(scaleValue) and scaleValue or Vector(scaleValue, scaleValue, scaleValue)) -- scale up/down by scaleValue

		return true
	end

	function MINIGAME:OnActivation()
		local plys = player.GetAll()

		-- update the HEADBONE_SCALE just on activation. Otherwise, realtime changes can lead to weird results
		HEADBONE_SCALE = ttt2_minigames_bubblehead_headscale:GetFloat()
		ARMBONES_SCALE = ttt2_minigames_bubblehead_armscale:GetFloat()

		for i = 1, #plys do
			local ply = plys[i]

			-- just do this for alive terrorist that are not already have scaled heads
			if ply:Alive() and ply:IsTerror() and not table.HasValue(modifiedPlys, ply) then

				-- scale headbone matrix up
				if not ScaleBone(ply, "ValveBiped.Bip01_Head1", HEADBONE_SCALE) then continue end

				-- scale arms
				ScaleBone(ply, "ValveBiped.Bip01_L_Hand", ARMBONES_SCALE)
				ScaleBone(ply, "ValveBiped.Bip01_R_Hand", ARMBONES_SCALE)

				ScaleBone(ply, "ValveBiped.Bip01_L_Forearm", Vector(ARMBONES_SCALE * 0.1, ARMBONES_SCALE, ARMBONES_SCALE))
				ScaleBone(ply, "ValveBiped.Bip01_R_Forearm", Vector(ARMBONES_SCALE * 0.1, ARMBONES_SCALE, ARMBONES_SCALE))

				ScaleBone(ply, "ValveBiped.Bip01_L_Elbow", ARMBONES_SCALE)
				ScaleBone(ply, "ValveBiped.Bip01_R_Elbow", ARMBONES_SCALE)

				ScaleBone(ply, "ValveBiped.Bip01_L_Shoulder", ARMBONES_SCALE)
				ScaleBone(ply, "ValveBiped.Bip01_R_Shoulder", ARMBONES_SCALE)

				-- mark player as modified player
				modifiedPlys[#modifiedPlys + 1] = ply
			end
		end

		-- prevent any damage that is no headshot (just bullet damage)
		hook.Add("EntityTakeDamage", "TTT2MGBubblehead", function(target, dmginfo)
			if not target:IsPlayer() or not dmginfo:IsBulletDamage() then return end

			if target:LastHitGroup() ~= HITGROUP_HEAD then
				print(target:Nick() .. " - " .. target:LastHitGroup())

				return true
			end
		end)
	end

	function MINIGAME:OnDeactivation()

		-- remove damage blocking
		hook.Remove("EntityTakeDamage", "TTT2MGBubblehead")

		-- undo the headbone matrix scale
		for i = 1, #modifiedPlys do
			local ply = modifiedPlys[i]

			-- maybe the player disconnected. Check for valid player here
			if not IsValid(ply) then continue end

			-- scale headbone matrix down
			ScaleBone(ply, "ValveBiped.Bip01_Head1", -HEADBONE_SCALE)

			-- scale arms
			ScaleBone(ply, "ValveBiped.Bip01_L_Hand", -ARMBONES_SCALE)
			ScaleBone(ply, "ValveBiped.Bip01_R_Hand", -ARMBONES_SCALE)

			ScaleBone(ply, "ValveBiped.Bip01_L_Forearm", -Vector(ARMBONES_SCALE * 0.1, ARMBONES_SCALE, ARMBONES_SCALE))
			ScaleBone(ply, "ValveBiped.Bip01_R_Forearm", -Vector(ARMBONES_SCALE * 0.1, ARMBONES_SCALE, ARMBONES_SCALE))

			ScaleBone(ply, "ValveBiped.Bip01_L_Elbow", -ARMBONES_SCALE)
			ScaleBone(ply, "ValveBiped.Bip01_R_Elbow", -ARMBONES_SCALE)
		end

		modifiedPlys = {}
	end
end
