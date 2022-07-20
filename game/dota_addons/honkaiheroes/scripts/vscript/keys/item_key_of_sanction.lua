item_key_of_sanction = class({})
LinkLuaModifier( "modifier_key_of_sanction", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_rifle", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_sleeper", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_sleeper_cd", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_basilisk", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_basilisk_aura", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_basilisk_mark", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_nuada_buff", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_iris_debuff", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_sanction_iris_buff", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_item_key_of_sanction_mitter", "keys/item_key_of_sanction", LUA_MODIFIER_MOTION_NONE )

--STR  Iris of the Dreams / --
--AGILITY -- / --
--INT catigination
-- LD CrasherBunny
item_key_of_sanction.ability_id = 0
item_key_of_sanction.key_textures = {
	"item_key_of_sanction",
	"item_key_of_sanction_str_melee",
	"item_key_of_sanction_str_range",
	"item_key_of_sanction_agl_melee",
	"item_key_of_sanction_agl_range",
	"item_key_of_sanction_int_melee",
	"item_key_of_sanction_int_range",
	"item_key_of_sanction"
}
item_key_of_sanction.behavior = {
	DOTA_ABILITY_BEHAVIOR_POINT,
	DOTA_ABILITY_BEHAVIOR_NO_TARGET,
	DOTA_ABILITY_BEHAVIOR_NO_TARGET,
	DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL ,
	DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL ,
	DOTA_ABILITY_BEHAVIOR_POINT,
	DOTA_ABILITY_BEHAVIOR_POINT,
	DOTA_ABILITY_BEHAVIOR_POINT
}
item_key_of_sanction.castpoint = {
	0.4,
	0.4,
	0.5,
	0,
	2,
	0,
	0.5,
	0,
}

function item_key_of_sanction:Precache( context ) 
	PrecacheResource( "particle",  "particles/units/heroes/hero_techies/techies_tazer_explode.vpcf", context)
end

function item_key_of_sanction:GetAbilityTextureName() return self.key_textures[self:GetCaster():GetModifierStackCount("modifier_key_of_sanction",self:GetCaster())+1] end
function item_key_of_sanction:GetBehavior()  return self.behavior[self:GetCaster():GetModifierStackCount("modifier_key_of_sanction",self:GetCaster())+1] end
function item_key_of_sanction:IsRefreshable() return false end
function item_key_of_sanction:GetIntrinsicModifierName() return "modifier_key_of_sanction" end

function item_key_of_sanction:OnSpellStart()
	
	if not IsServer() then return end
	if self.ability_id == 1 then self:Iris() return end
	if self.ability_id == 2 then self:Sleepers() return end
	if self.ability_id == 3 then self:Nuada() return end
	if self.ability_id == 4 then self:Rifle() return end
	if self.ability_id == 5 then self:Mitternachts() return end
	if self.ability_id == 6 then self:Basilisk() return end
end

function item_key_of_sanction:Basilisk()
	local unit  = CreateUnitByName("npc_Basilisk_Cross", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster():GetOwner(), self:GetCaster():GetTeamNumber())
	--
	unit:SetModel("models/items/venomancer/ward/venomancer_hydra_snakeward/venomancer_hydra_snakeward.vmdl")
	unit:AddNewModifier(self:GetCaster(), self, "modifier_key_of_sanction_basilisk", {duration=15})
end


function item_key_of_sanction:GetCastRange(l , t)
	if self.ability_id == 1 then return 500 end
	if self.ability_id == 2 then return 0 end
	if self.ability_id == 3 then return 600 end
	if self.ability_id == 4 then return 0 end
	if self.ability_id == 5 then return 2000 end
	if self.ability_id == 6 then return 1200 end
end

function item_key_of_sanction:Rifle()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local projectile_name = "particles/econ/items/drow/drow_arcana/drow_arcana_multishot_linear_proj_frost_v2.vpcf"
	local projectile_speed = 3000
	local projectile_distance = 10000
	local projectile_radius = self:GetSpecialValueFor("shot_radius")
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	if projectile_direction == Vector(0,0,0) then
		projectile_direction = Vector(-1 ,-1,0)
	end
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
		bDrawsOnMinimap = true,	
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )
end

item_key_of_sanction.projectiles = {}


function item_key_of_sanction:OnProjectileHit( target, location)
	if not IsServer() then return end
	if not target then
		return true
	end
	AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), self:GetSpecialValueFor("shot_radius")*4, self:GetSpecialValueFor("shot_breach_duration"), false )
	local damageTable = {
		attacker = self:GetCaster(),
		damage_type = 4,
		ability = self, 
	}
	local damage_radius = 300
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 3, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _, vic in pairs(targets) do
	
		damageTable.victim = vic
		damageTable.damage = self:GetSpecialValueFor( "powershot_damage_pct" ) * self:GetCaster():GetAttackDamage()
		ApplyDamage(damageTable)
		vic:AddNewModifier(self:GetCaster(), self, "modifier_key_of_sanction_rifle", {duration = self:GetSpecialValueFor("shot_breach_duration")})
	end
	local particle_cast = "particles/units/heroes/hero_techies/techies_tazer_explode.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 1,Vector(damage_radius,  0 , 0) )
	ParticleManager:SetParticleControl( effect_cast, 15,Vector(50,  0 , 255) )
	ParticleManager:SetParticleControl( effect_cast, 0,	target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	local sound_cast = "Hero_Zuus.GodsWrath.Target"
	EmitGlobalSound(sound_cast)
	return true
end


function item_key_of_sanction:OnProjectileThink( location )
	StartSoundEventFromPosition( "Hero_Zuus.ArcLightning.Cast", location)
end

modifier_key_of_sanction = class({})

function modifier_key_of_sanction:OnCreated()
	if not IsServer() then 
		return
	end
	self:GetAbility():SetOverrideCastPoint(self:GetAbility().castpoint[self:GetCaster():GetAttackCapability() + self:GetCaster():GetPrimaryAttribute()*2+1])
	self:SetStackCount(self:GetCaster():GetAttackCapability() + self:GetCaster():GetPrimaryAttribute()*2)
	self:SendBuffRefreshToClients()
end

function modifier_key_of_sanction:IsHidden() return true end

modifier_key_of_sanction_rifle = class({})

function modifier_key_of_sanction_rifle:GetModifierBreach_LightningDamage()
	return self:GetAbility():GetSpecialValueFor("shot_breach")
end

function modifier_key_of_sanction_rifle:CheckState()
	return {
		[MODIFIER_STATE_ROOTED ] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
end

function modifier_key_of_sanction_rifle:DeclareFunctions()
	return {}
end



function item_key_of_sanction:Sleepers()
	local caster = self:GetCaster()
	caster:SetHealth(max(1, caster:GetHealth()-100))
	caster:AddNewModifier(caster, self , "modifier_key_of_sanction_sleeper",{duration = 10})
end
--sounds/weapons/hero/shared/large_blade/ring03.vsnd
modifier_key_of_sanction_sleeper = class({})

function modifier_key_of_sanction_sleeper:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_key_of_sanction_sleeper:GetModifierProjectileName() return "particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_immortal_lightning.vpcf" end

function modifier_key_of_sanction_sleeper:OnCreated()
	local caster = self:GetCaster()
	if not IsServer() then return end
	self:SetStackCount(1)
	EmitSoundOn("sounds/weapons/hero/shared/large_blade/ring03.vsnd", caster)
end

function modifier_key_of_sanction_sleeper:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_TAKEDAMAGE ,
	
	}
end

function modifier_key_of_sanction_sleeper:OnTakeDamage(event)
	if event.attacker == self:GetCaster() then
		if event.attacker:HasModifier("modifier_key_of_sanction_sleeper_cd") then return end
		event.attacker:AddNewModifier(event.attacker, self:GetAbility(), "modifier_key_of_sanction_sleeper_cd", {duration = 1})
		ApplyDamage({victim = event.unit, attacker = event.attacker, damage = event.damage * self:GetStackCount(), damage_type = 2, ability = self:GetAbility()})
		local particle_cast = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, event.unit )
		ParticleManager:SetParticleControl( effect_cast, 0,	event.unit:GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1,	event.unit:GetAbsOrigin()+Vector(0,0,500) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		event.unit,
		event.damage * self:GetStackCount(),
		event.attacker:GetPlayerOwner())
		EmitSoundOn("Hero_Zuus.ProjectileImpact", caster)
		self:IncrementStackCount()
		--event.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_key_of_sanction_rifle", {duration = self:GetAbility():GetSpecialValueFor("hit_breach_duration")})
	end
end

modifier_key_of_sanction_sleeper_cd = class({})

modifier_key_of_sanction_basilisk = class({})

function modifier_key_of_sanction_basilisk:RemoveOnDeath() return true end

function modifier_key_of_sanction_basilisk:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("Cross_interval"))
	self.radius = self:GetAbility():GetSpecialValueFor("Cross_radius")
	self.damage = self:GetAbility():GetSpecialValueFor("Cross_damage_pct")
end

function modifier_key_of_sanction_basilisk:OnIntervalThink()
	
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 3, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local damageTable = {
		attacker = self:GetCaster(),
		damage_type = 2,
		ability = self:GetAbility(), 
	}
	for _, vic in pairs(targets) do
		damageTable.victim = vic
		damageTable.damage = self.damage * self:GetCaster():GetAttackDamage()/ 100
		ApplyDamage(damageTable)
		vic:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_key_of_sanction_basilisk_mark", {duration = self:GetRemainingTime()})
	end
end

function modifier_key_of_sanction_basilisk:OnRemoved()
	if not IsServer() then return end
	self:GetParent():ForceKill(false)
end

function modifier_key_of_sanction_basilisk:GetModifierAura() return "modifier_key_of_sanction_basilisk_aura" end
function modifier_key_of_sanction_basilisk:IsAura() return true end
function modifier_key_of_sanction_basilisk:GetAuraSearchType() return 3 end
function modifier_key_of_sanction_basilisk:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_key_of_sanction_basilisk:GetAuraSearchFlags() return 0 end
function modifier_key_of_sanction_basilisk:GetAuraRadius() return self.radius end

modifier_key_of_sanction_basilisk_aura = class({})

function modifier_key_of_sanction_basilisk_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_key_of_sanction_basilisk_aura:GetModifierMoveSpeedBonus_Percentage()
	return -20
end

function modifier_key_of_sanction_basilisk_aura:GetModifierBreach_LightningDamage()
	return 60
end

modifier_key_of_sanction_basilisk_mark = class({})

function modifier_key_of_sanction_basilisk_mark:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_key_of_sanction_basilisk_mark:OnTakeDamage(event)
	if event.attacker == self:GetCaster() and event.inflictor ~= nil and not event.inflictor:IsItem()  and not self.check then
		self.check = true
		self:Destroy()
		ApplyDamage({victim = event.unit, attacker = event.attacker, damage = event.damage, damage_type = 2, ability = self:GetAbility()})
		SendOverheadEventMessage(nil,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		event.unit,
		event.damage,
		event.attacker:GetPlayerOwner())
	end
end


function item_key_of_sanction:Nuada()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = 600
	local angle = 45
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		1,	-- int, order filter
		false	-- bool, can grow cache
	)
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y
	local damageT = {
					attacker = caster,
					damage = caster:GetAttackDamage(),
					damage_type = 2,
					ability = self,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
					}
	local tCount = 0
	for _,enemy in pairs(enemies) do
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			tCount = tCount + 1
			enemy:AddNewModifier(caster, self, "modifier_key_of_sanction_rifle", {duration = self:GetSpecialValueFor("nuada_breach_duration")*tCount})
			damageT.victim = enemy
			ApplyDamage(damageT)
		end
		
	end
	caster:AddNewModifier(caster, self, "modifier_key_of_sanction_nuada_buff", {duration = self:GetSpecialValueFor("nuada_burst_duration")*tCount, stack_count = tCount})
	self:PlayEffects(  (point-origin):Normalized() )
end


--------------------------------------------------------------------------------
-- Play Effects
function item_key_of_sanction:PlayEffects( direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
	local sound_cast = "Hero_StormSpirit.StaticRemnantExplode"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(255,255,255) )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(0,0,205) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end


modifier_key_of_sanction_nuada_buff = class({})

function modifier_key_of_sanction_nuada_buff:OnCreated(kv)
	self:SetStackCount(kv.stack_count)
end

function modifier_key_of_sanction_nuada_buff:GetModifierBonusStat_BurstmodeDamage()
	return self:GetAbility():GetSpecialValueFor("nuada_burst_buff")*self:GetStackCount()
end

function item_key_of_sanction:OnAbilityPhaseStart()
	self.ability_id = self:GetCaster():GetModifierStackCount("modifier_key_of_sanction",self:GetCaster())
	if self.ability_id == 1 then self:GetCaster():EmitSoundParams("Honkaiheroes.Iris.Cast", 1 , 1, 0) self:GetCaster():StartGesture(ACT_DOTA_ATTACK ) end
	return true
end

function item_key_of_sanction:OnAbilityPhaseInterrupted()
	if self.ability_id == 1 then self:GetCaster():StopSound("Honkaiheroes.Iris.Cast") end
end

function item_key_of_sanction:Iris()
	local caster = self:GetCaster()
	local radius = 400
	local distance = 100
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local damageT = {
					attacker = caster,
					damage = caster:GetAttackDamage(),
					damage_type = 2,
					ability = self,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
					}
	for _,enemy in pairs(enemies) do
		damageT.victim = enemy
		
		
		
		if not (enemy:IsCurrentlyHorizontalMotionControlled() or enemy:IsCurrentlyVerticalMotionControlled()) then
		-- knockback data
		local direction = enemy:GetOrigin()-caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()

		-- create arc
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				dir_x = direction.x,
				dir_y = direction.y,
				duration = 0.8,
				distance = distance,
				height = 10,
				activity = ACT_DOTA_FLAIL,
			} -- kv
		)
		
		end
		
		
		ApplyDamage(damageT)		
		SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_CRITICAL,
		enemy,
		damageT.damage,
		caster:GetPlayerOwner())
	end
	
	caster:AddNewModifier(caster,self, "modifier_key_of_sanction_iris_buff", {duration=15})
	--sounds/physics/items/weapon_drop_common_04.vsnd
	local particle_cast = "particles/units/heroes/hero_ursa/ursa_earthshock_rings.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(255,255,255) )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(100,0,205) )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(0,radius/1.5,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_key_of_sanction_iris_buff = class({})

function modifier_key_of_sanction_iris_buff:OnCreated()
	self:StartIntervalThink(0.7)
	
end

function modifier_key_of_sanction_iris_buff:OnRefresh()
	self:StartIntervalThink(0.7)
end

function modifier_key_of_sanction_iris_buff:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local radius = 500
	local distance = 100
	
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		1,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	
	local origin = caster:GetOrigin()
	local damageT = {
					attacker = caster,
					damage = caster:GetAttackDamage()*4,
					damage_type = 2,
					ability = self,
					damage_flags = DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR
					}
	local particle_cast = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj_hit.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	for _,enemy in pairs(enemies) do
		damageT.victim = enemy
		local direction = enemy:GetOrigin()-caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		
		enemy:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_generic_arc_lua", -- modifier name
			{
				
				dir_x = direction.x,
				dir_y = direction.y,
				duration = 0.8,
				distance = 0,
				height = 150,
				activity = ACT_DOTA_FLAIL,
			} -- kv
		)
		
		
		ParticleManager:SetParticleControl( effect_cast, 0, enemy:GetAbsOrigin()) 
		ParticleManager:SetParticleControl( effect_cast, 1, enemy:GetAbsOrigin()) 
		ParticleManager:SetParticleControl( effect_cast, 3, enemy:GetAbsOrigin()) 
		ParticleManager:ReleaseParticleIndex( effect_cast )
		SendOverheadEventMessage(
		nil,
		OVERHEAD_ALERT_CRITICAL,
		enemy,
		damageT.damage,
		caster:GetPlayerOwner())
		
		ApplyDamage(damageT)		

	end
	particle_cast = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_cast.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector(255,255,255) )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector(100,0,205) )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(0,radius/1.5,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:StartIntervalThink(-1)
end

function item_key_of_sanction:Mitternachts()
	local caster = self:GetCaster()
	--local particle_cast = "particles/units/heroes/hero_zuus/zuus_smaller_lightning_bolt_child.vpcf"
	--local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	--ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
	--ParticleManager:SetParticleControl( effect_cast, 1, target_point )
	local origin_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > self:GetSpecialValueFor("mitter_radius") then  --Clamp the target point to the BlinkRangeClamp range in the same direction.
		target_point = origin_point + (target_point - origin_point):Normalized() * self:GetSpecialValueFor("mitter_radius") 
	end
	EmitSoundOn("Hero_Zuus.ArcLightning.Cast", caster )
	--ParticleManager:ReleaseParticleIndex( effect_cast )
	FindClearSpaceForUnit( caster, target_point, true )
	EmitSoundOn("Hero_Zuus.ArcLightning.Cast", caster )
	caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_item_key_of_sanction_mitter", -- modifier name
			{
				duration = 10,
			} -- kv
		)
	
	
	
end

modifier_item_key_of_sanction_mitter = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_key_of_sanction_mitter:IsHidden()
	return false
end

function modifier_item_key_of_sanction_mitter:IsDebuff()
	return false
end

function modifier_item_key_of_sanction_mitter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_key_of_sanction_mitter:OnCreated(  )
	-- references
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	ProjectileManager:ProjectileDodge( self:GetParent() )
end

function modifier_item_key_of_sanction_mitter:OnRefresh( kv )

	if not IsServer() then return end
	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )
end

function modifier_item_key_of_sanction_mitter:OnRemoved()
end

function modifier_item_key_of_sanction_mitter:OnDestroy()

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_item_key_of_sanction_mitter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT 
	}

	return funcs
end

function modifier_item_key_of_sanction_mitter:GetModifierAttackRangeBonus()
	return self.bonus_range
end
function modifier_item_key_of_sanction_mitter:GetModifierMoveSpeedBonus_Constant() return 550 end
function modifier_item_key_of_sanction_mitter:GetModifierPreAttack_BonusDamage_Magical( params )
	if params.record~=self.record then return end

	-- overhead event
	SendOverheadEventMessage(
		nil, --DOTAPlayer sendToPlayer,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		params.target,
		self.damage,
		self:GetParent():GetPlayerOwner() -- DOTAPlayer sourcePlayer
	)

	-- play effects
	local sound_cast = "Hero_DarkWillow.Shadow_Realm.Damage"
	EmitSoundOn( sound_cast, self:GetParent() )

	return self.damage
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_item_key_of_sanction_mitter:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
	return state
end

function modifier_item_key_of_sanction_mitter:GetModifierBonusStats_ElementalDamage()
print(self:GetAbility():GetSpecialValueFor("mitter_elem_bonus"))
	return self:GetAbility():GetSpecialValueFor("mitter_elem_bonus")
end

function modifier_item_key_of_sanction_mitter:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

