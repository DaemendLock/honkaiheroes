item_key_of_corruption = class({})
--LinkLuaModifier( "modifier_item_key_of_the_void", "items/modifier_item_key_of_the_void", LUA_MODIFIER_MOTION_NONE )


function item_key_of_corruption:OnSpellStart()
	--if not IsServer() then return end
	--if not self.success then return end

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
	-- success teleporting
	local targets = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	-- teleport units 
	for _,target in pairs(targets) do
		-- disjoint
		ProjectileManager:ProjectileDodge( target )
		-- move to position
		FindClearSpaceForUnit( target, point, true )
	end

end