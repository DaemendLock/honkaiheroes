item_key_of_destruction = class({})
LinkLuaModifier( "modifier_key_of_destruction_active", "keys/item_key_of_destruction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_of_destruction_passive", "keys/item_key_of_destruction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_key_stats", "keys/item_key_of_destruction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_honkai_penalti", "honkai/modifier_honkai_penalti", LUA_MODIFIER_MOTION_NONE )	
--LinkLuaModifier( "modifier_item_key_of_the_void", "items/modifier_item_key_of_the_void", LUA_MODIFIER_MOTION_NONE )

function item_key_of_destruction:GetIntrinsicModifierName()
	return "modifier_key_of_destruction_passive"
end

function item_key_of_destruction:OnSpellStart()
	local caster = self:GetCaster()
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	caster:AddNewModifier(caster, self, "modifier_key_of_destruction_active", {duration = self:GetSpecialValueFor("duration")})
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function item_key_of_destruction:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_key_of_destruction_active") then return "item_key_of_destruction2" end
	return "item_key_of_destruction"
end

modifier_key_of_destruction_active = class({})

function modifier_key_of_destruction_active:OnCreated()
	self.attack_bonus	= self:GetAbility():GetSpecialValueFor("atk_damage")
	self.hp_loss = self:GetAbility():GetLevelSpecialValueFor("hp_cost_pct", 1)
	self.hp_loss_low = self:GetAbility():GetLevelSpecialValueFor("hp_cost_pct", 2)
	self.heal_pct = self:GetAbility():GetSpecialValueFor("heal_pct")
	self:StartIntervalThink(0.25)
	self.damageTable = {
		victim = self:GetCaster(),
		attacker = self:GetCaster(),
		damage_type = 1,
		ability = self:GetAbility()
	}
	
end

function modifier_key_of_destruction_active:GetEffectName()
	return "particles/units/heroes/hero_clinkz/clinkz_burning_army_ambient.vpcf"
end

function modifier_key_of_destruction_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_key_of_destruction_active:GetModifierProjectileName() return "particles/world_tower/tower_upgrade/ti7_dire_tower_projectile.vpcf" end

function modifier_key_of_destruction_active:OnIntervalThink()
	if not IsServer() then return end
	local hp = self:GetCaster():GetMaxHealth()
	local damage = 0
	if self:GetCaster():GetHealthPercent() < self.heal_pct then
		damage = hp * self.hp_loss_low / 100
	else
		damage = hp * self.hp_loss / 100
	end
	self.damageTable.damage = damage	
	ApplyDamage(self.damageTable)
end

function modifier_key_of_destruction_active:GetModifierProcAttack_BonusDamage_Magical(kv)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, kv.target, self.attack_bonus, self:GetCaster())
		local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, kv.target )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		EmitSoundOn( "Hero_DoomBringer.InfernalBlade.PreAttack", self:GetParent() )
		return self.attack_bonus
end

modifier_key_of_destruction_passive = class({})

function modifier_key_of_destruction_passive:IsHidden() return true end

function modifier_key_of_destruction_passive:OnCreated()
	self.base_buff	= self:GetAbility():GetSpecialValueFor("damage_buff")
	self.low = self:GetAbility():GetSpecialValueFor("heal_pct")
	self.add_damage	= self:GetAbility():GetSpecialValueFor("damage_bonus")
	self.hps = self:GetAbility():GetSpecialValueFor("heal_amount")
end

function modifier_key_of_destruction_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,	
	}
end

function modifier_key_of_destruction_passive:GetModifierConstantHealthRegen()
	if self:GetCaster():GetHealthPercent() < self.low then
		return self.hps
	end
	return 0
end

function modifier_key_of_destruction_passive:GetModifierTotalDamageOutgoing_Percentage()
	local damage = self.base_buff
	if self:GetCaster():GetHealthPercent() < self.low then
		damage = damage + self.add_damage
	end
	return damage
end

function modifier_key_of_destruction_active:GetTexture() return "item_key_of_destruction2" end
