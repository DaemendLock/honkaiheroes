item_key_of_the_void = class({})
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_img_imun", "keys/item_key_of_the_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_img_imun_aura", "keys/item_key_of_the_void", LUA_MODIFIER_MOTION_NONE)

function item_key_of_the_void:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	caster:AddNewModifier(caster,
						  self,
						  "modifier_img_imun",
						  {radius = radius, duration = self:GetChannelTime()}
						  )

	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_ring.vpcf"				  
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetSpecialValueFor("radius")+25, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

end

function item_key_of_the_void:OnChannelFinish(finish)
	
	ParticleManager:DestroyParticle(self.effect_cast, true)
	if not IsServer() or not self:GetCaster():IsAlive() then return end
	if not finish then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor( "radius" )
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
	
	caster:FindModifierByName("modifier_img_imun"):Destroy()
	for _,target in pairs(targets) do
		local mod = target:FindModifierByName("modifier_img_imun_aura")
		if mod then
			mod:Destroy()
		end
		ProjectileManager:ProjectileDodge( target )
		FindClearSpaceForUnit( target, point, true )
	end
end

modifier_img_imun = class({})

function modifier_img_imun:OnCreated(event)
	self.radius = event.radius
end

function modifier_img_imun:IsAura()
	return true
end

function modifier_img_imun:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor( "radius" )
end

function modifier_img_imun:GetAuraDuration()
	return 0.1
end

function modifier_img_imun:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_img_imun:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_img_imun:GetModifierAura()
	return "modifier_img_imun_aura"
end

function modifier_img_imun:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_img_imun:CheckState()
	return {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_img_imun:GetAuraEntityReject(pal)
	return pal==self:GetCaster()
end

function modifier_img_imun:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_aghs_gold_statue.vpcf"
end


modifier_img_imun_aura = class({})

function modifier_img_imun_aura:CheckState()
	return {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end

function modifier_img_imun_aura:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_aghs_gold_statue.vpcf"
end



