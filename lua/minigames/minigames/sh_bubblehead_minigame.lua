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
	local TREX = 0

	local ttt2_minigames_bubblehead_headscale = CreateConVar("ttt2_minigames_bubblehead_headscale", "1.5", {FCVAR_ARCHIVE}, "Set the headbone scale")
	local ttt2_minigames_bubblehead_trex = CreateConVar("ttt2_minigames_bubblehead_trex", "1", {FCVAR_ARCHIVE}, "Toggle T-Rex arms")

	local function ScaleBone(ply, boneName, scaleValue)

		-- get the head bone
		local boneId = ply:LookupBone(boneName)
		if boneId == nil then
			return false
		end

		-- modify the headbone scaling
		ply:ManipulateBoneScale(boneId, isvector(scaleValue) and scaleValue or Vector(scaleValue, scaleValue, scaleValue)) -- scale up/down by scaleValue

		return true
	end

	local function PositionBone(ply, boneName, position)

		-- get the head bone
		local boneId = ply:LookupBone(boneName)
		if boneId == nil then
			return false
		end

		-- modify the headbone scaling
		ply:ManipulateBonePosition(boneId, isvector(position) and position or Vector(position, position, position))

		return true
	end

	local trex_scales = {
		["ValveBiped.Bip01_L_Hand"] = 0.4,
		["ValveBiped.Bip01_L_Forearm"] = 0.4,
		["ValveBiped.Bip01_L_Clavicle"] = 0.4,
		["ValveBiped.Bip01_L_Upperarm"] = 0.4,

		["ValveBiped.Bip01_R_Hand"] = 0.4,
		["ValveBiped.Bip01_R_Forearm"] = 0.4,
		["ValveBiped.Bip01_R_Clavicle"] = 0.4,
		["ValveBiped.Bip01_R_Upperarm"] = 0.4,
	}

	local trex_positions = {
		["ValveBiped.Bip01_L_Hand"] = Vector(-7, -0.5, 1),
		["ValveBiped.Bip01_L_Forearm"] = Vector(-8, 0, 1),
		["ValveBiped.Bip01_L_Upperarm"] = Vector(-2, 2, 1),

		["ValveBiped.Bip01_R_Hand"] = Vector(-7, -0.5, 1),
		["ValveBiped.Bip01_R_Forearm"] = Vector(-8, 0, 1),
		["ValveBiped.Bip01_R_Upperarm"] = Vector(-2, 2, 1),
	}

	local function TransformPlayer(ply)
		-- scale headbone matrix up
		if table.HasValue(modifiedPlys, ply) or not ScaleBone(ply, "ValveBiped.Bip01_Head1", HEADBONE_SCALE) then return end

		-- scale arms
		if TREX then
			for k, v in pairs(trex_scales) do
				ScaleBone(ply, k, v)
			end

			for k, v in pairs(trex_positions) do
				PositionBone(ply, k, v)
			end
		end

		-- mark player as modified player
		modifiedPlys[#modifiedPlys + 1] = ply
	end

	function MINIGAME:OnActivation()
		local plys = player.GetAll()

		-- update the HEADBONE_SCALE just on activation. Otherwise, realtime changes can lead to weird results
		HEADBONE_SCALE = ttt2_minigames_bubblehead_headscale:GetFloat()
		TREX = ttt2_minigames_bubblehead_trex:GetBool()

		for i = 1, #plys do
			local ply = plys[i]

			-- just do this for alive terrorist that are not already have scaled heads
			if ply:Alive() and ply:IsTerror() then
				TransformPlayer(ply)
			end
		end

		-- prevent any damage that is no headshot (just bullet damage)
		hook.Add("EntityTakeDamage", "TTT2MGBubblehead", function(target, dmginfo)
			if not target:IsPlayer() or not dmginfo:IsBulletDamage() then return end

			if target:LastHitGroup() ~= HITGROUP_HEAD then
				return true
			end
		end)

		-- if a player respawns, the transformation should be done again
		hook.Add("PlayerSetModel", "TTT2MGBubblehead", function(ply)
			if not ply:Alive() then return end

			TransformPlayer(ply)
		end)
	end

	function MINIGAME:OnDeactivation()

		-- remove damage blocking
		hook.Remove("EntityTakeDamage", "TTT2MGBubblehead")

		-- remove spawn transformation
		hook.Remove("PlayerSetModel", "TTT2MGBubblehead")

		-- undo the headbone matrix scale
		for i = 1, #modifiedPlys do
			local ply = modifiedPlys[i]

			-- maybe the player disconnected. Check for valid player here
			if not IsValid(ply) then continue end

			-- scale headbone matrix down
			ScaleBone(ply, "ValveBiped.Bip01_Head1", 1)

			-- scale arms
			if TREX then
				for k, v in pairs(trex_scales) do
					ScaleBone(ply, k, 1)
				end

				for k, v in pairs(trex_positions) do
					PositionBone(ply, k, 1)
				end
			end
		end

		modifiedPlys = {}
	end
end
