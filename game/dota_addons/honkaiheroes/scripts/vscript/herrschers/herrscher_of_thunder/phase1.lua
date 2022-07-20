LinkLuaModifier( "modifier_lightning_judgement", "herrschers/herrscher_of_thunder/phase1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_charged_zone", "herrschers/herrscher_of_thunder/phase1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_2nd_phase", "herrschers/herrscher_of_thunder/phase1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_swift_slash", "herrschers/herrscher_of_thunder/phase1", LUA_MODIFIER_MOTION_NONE )

hot_lightning_judgement = class({})

function hot_lightning_judgement:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function hot_lightning_judgement:IsStealable() return false end

function hot_lightning_judgement:OnSpellStart()
	if _G.DBM_ON == true then
		EmitSoundOn("DBM.Spread", self:GetCaster())
	end
end

function hot_lightning_judgement:OnChannelFinish(succes)
	if succes then 
		self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
	end
	local caster = self:GetCaster()
	local target = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO ,
		0,
		2,
		false
	)
	if (#target>0) then
		for _, i in pairs(target) do
			target = i
			break
		end
	else
		return
	end
	
	local target2 = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetSpecialValueFor("aoe_radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local damageT = {
		attacker = caster,
		damage = self:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_PURE,
		ability = self
	}
	for _,tar in pairs(target2) do
		damageT.victim = tar
		ApplyDamage(damageT)
		tar:AddNewModifier(caster, self, "modifier_lightning_judgement", {})
		
	end
	self:PlayEffect(target)
	self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
end

function hot_lightning_judgement:PlayEffect(target)
	local sound_cast = "Hero_Zuus.LightningBolt"
	local particle_cast = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW  , self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() + Vector(0, 0, 500))
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, target )
end



modifier_lightning_judgement = class({})

function modifier_lightning_judgement:IsPurgable()
	return false
end

function modifier_lightning_judgement:OnCreated()
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
end

function modifier_lightning_judgement:OnRemoved()
	if not IsServer() then return end
	self:GetParent():SetHealth(self:GetParent():GetHealth()/2)
	self:PlayEffect(self:GetParent())
end

function modifier_lightning_judgement:PlayEffect(target)
	local particle_cast = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN , self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() + Vector(0, 0, 500))
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
end

function modifier_lightning_judgement:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
	}
end

function modifier_lightning_judgement:GetModifierIncomingDamage_Percentage()
	return self.bonus_damage_pct
end

hot_static_charge = class({})

function hot_static_charge:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function hot_static_charge:IsStealable() return false end

function hot_static_charge:OnSpellStart()
	if _G.DBM_ON == true then
		EmitSoundOn("DBM.Beware", self:GetCaster())
	end
end

function hot_static_charge:OnChannelFinish(succes)
	if succes then 
		self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
	end
	local target = self:GetCaster():GetOrigin() + RandomVector(1)*self:GetSpecialValueFor("cast_radius")
	self.holder = CreateModifierThinker(
		self:GetCaster(), 
		self, 
		"modifier_charged_zone",
		{ duration = self:GetSpecialValueFor("duration") },
		target,
		self:GetCaster():GetTeamNumber(),
		false
	)
	EmitSoundOn("Hero_ArcWarden.MagneticField", self:GetCaster())
	self.sum_damage = self:GetAbilityDamage()
	self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
end

modifier_charged_zone = class({})

function modifier_charged_zone:IsHidden()
	return false
end

function modifier_charged_zone:IsDebuff()
	return true
end

function modifier_charged_zone:IsStunDebuff()
	return false
end

function modifier_charged_zone:IsPurgable()
	return false
end

function modifier_charged_zone:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "soak_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.owner = kv.isProvidedByAura~=1

	if not IsServer() then return end

	if not self.owner then
		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink( 0.25 )
	else
		self:PlayEffects()
	end
end

function modifier_charged_zone:OnRemoved()
	if not IsServer() then return end
	if self.owner then
		local damageT = {
			attacker = self:GetCaster(),
			damage = self:GetAbility().sum_damage,
			damage_type = DAMAGE_TYPE_PURE ,
			ability = self:GetAbility(), --Optional.
		}
		
		local targets = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),	
			nil,
			self:GetAbility():GetSpecialValueFor( "aoe_damage" ),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			0,	
			0,	
			false
		)
		for _, target in pairs(targets) do
			damageT.victim = target
			ApplyDamage(damageT)
		end
		if self:GetAbility().sum_damage > 0 then
			EmitSoundOn("Hero_ArcWarden.SparkWraith.Damage", self:GetCaster())
		end
		self:GetAbility().sum_damage = 0
		
	end
end

function modifier_charged_zone:OnIntervalThink()
	if self:GetAbility().sum_damage < 1 then
		if self:GetAuraOwner() then
			self:GetAuraOwner():FindModifierByName("modifier_charged_zone"):Destroy()
		end
	else
		ApplyDamage( self.damageTable )
		self:GetAbility().sum_damage = self:GetAbility().sum_damage - self.damageTable.damage
		local sound_cast = "Hero_Viper.NetherToxin.Damage"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
	
end

function modifier_charged_zone:IsAura()
	return self.owner
end

function modifier_charged_zone:GetModifierAura()
	return "modifier_charged_zone"
end

function modifier_charged_zone:GetAuraRadius()
	return self.radius
end

function modifier_charged_zone:GetAuraDuration()
	return 0.5
end

function modifier_charged_zone:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_charged_zone:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_charged_zone:GetEffectName()
	if not self.owner then
		return "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
	end
end

function modifier_charged_zone:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_charged_zone:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_viper/viper_nethertoxin.vpcf"
	local sound_cast = "Hero_Viper.NetherToxin"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	self:AddParticle(
		effect_cast,
		false, 
		false,
		-1, 
		false,
		false
	)

	EmitSoundOn( sound_cast, self:GetParent() )
end

hot_phase_change = class({})

function hot_phase_change:IsStealable() return false end

function hot_phase_change:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function hot_phase_change:OnSpellStart()
	local caster = self:GetCaster()
	caster:GetAbilityByIndex(2):SetLevel(2)
	EmitSoundOn("Hero_Zuus.GodsWrath", self:GetCaster())
	EmitSoundOn("Honkaiheroes.HerrscherOfThunder.PhaseSwap", self:GetCaster())
	if not IsServer() then return end
	local targets = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO ,
		0,
		1,
		false
	)
	local t = 1
	for _, target in pairs(targets) do
		if target:HasModifier("modifier_lightning_judgement") then
			target:FindModifierByName("modifier_lightning_judgement"):SetDuration(t*0.25, true)
			t = t+1
		end
	end
	caster:SwapAbilities("hot_lightning_judgement", "hot_lightning_illusion", false, true)
	caster:GetAbilityByIndex(0):SetLevel(1)
	caster:AddNewModifier(caster, self, "modifier_2nd_phase", {duration = self:	GetSpecialValueFor("phase_2_duration")})
	ScreenShake(caster:GetOrigin(), 20, 2, self:GetChannelTime(), 1000, 0, true)
end

function hot_phase_change:OnChannelFinish(succes)
	local caster = self:GetCaster()
	caster.linkedUnit = CreateUnitByName("npc_hot_dragon", caster:GetOrigin() + RandomVector(500), false, caster, caster:GetOwner(),caster:GetTeam())
	caster.linkedUnit.target = caster.target
	if _G.DBM_ON == true then
		EmitSoundOn("DBM.Adds", caster)
	end
	caster:RemoveAbilityByHandle(self)
	caster:MoveToTargetToAttack(caster.target)
	
end

modifier_2nd_phase = class({})

function modifier_2nd_phase:IsPurgable() return false end

function modifier_2nd_phase:GetTexture() return "obsidian_destroyer_equilibrium" end

function modifier_2nd_phase:OnCreated()
	self:StartIntervalThink(self:GetDuration() - 2)
end

function modifier_2nd_phase:DeclareFunctions()
	return {	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 	}
end

function modifier_2nd_phase:GetModifierIncomingDamage_Percentage(event)
	if event.ranged_attack or event.ranged_attack == nil then
		return 0
	end
	return -100
end

function modifier_2nd_phase:OnRemoved()

	EmitSoundOn("Hero_Zuus.GodsWrath", self:GetCaster())
   	if not IsServer() then return end
	if self:GetParent():GetHealth() < 1 then
	print("early")
		return
	end
	local caster = self:GetCaster()
	local targets = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO ,
		0,
		0,
		false
	)
	for _, target in pairs(targets) do
		self:PlayEffect(target)
		target:Kill(self:GetAbility(), self:GetCaster())
	end
	
end

function modifier_2nd_phase:OnIntervalThink()
 	EmitSoundOn("Honkaiheroes.HerrscherOfThunder.Wipe", self:GetCaster())
end

function modifier_2nd_phase:PlayEffect(target)
	local particle_cast = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN , self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() + Vector(0, 0, 500))
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin())
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
end

hot_herrscher_form = class({})

function hot_herrscher_form:IsStealable() return false end

function hot_herrscher_form:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function hot_herrscher_form:OnChannelFinish(succes)
	if succes then 
		self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_swift_slash", {duration = self:GetDuration()}).target = self:GetCursorTarget()	
	self:GetCaster():MoveToTargetToAttack(self:GetCaster().target)
end

modifier_swift_slash = class({})

function modifier_swift_slash:IsPurgable()
	return false
end

function modifier_swift_slash:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self:StartIntervalThink(self:GetDuration()/(1+self:GetAbility():GetSpecialValueFor("slash_count")))
end

function modifier_swift_slash:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	caster:PerformAttack(self.target, false, true, true, true, false, false, true)
	FindClearSpaceForUnit(caster, self.target:GetOrigin()+RandomVector(self.radius)/2, true)
	caster:SetForwardVector(self.target:GetOrigin()-self:GetParent():GetOrigin())
	local targets = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO ,
		0,
		0,
		false
	)
	if(#targets==0) then
		self:Destroy()
		return
	end
	for _,i in pairs(targets) do
		self.target = i
		break
	end
	EmitSoundOn("Hero_Zuus.ArcLightning.Target", self:GetCaster())
end

function modifier_swift_slash:StatusEffectPriority()
    return 20
end

function modifier_swift_slash:GetStatusEffectName()
    return "particles/status_fx/status_effect_phase_shift.vpcf"
end

