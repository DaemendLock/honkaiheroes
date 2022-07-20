
LinkLuaModifier( "modifier_honkai_debuff", "honkai/modifier_honkai_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_reason_hex", "keys/item_key_of_reason_items", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_reason_silver_edge_debuff", "keys/item_key_of_reason_items", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_reason_silver_edge", "keys/item_key_of_reason_items", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_reason_silver_edge_timer", "keys/item_key_of_reason_items", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_key_of_reason_bkb", "keys/item_key_of_reason_items", LUA_MODIFIER_MOTION_NONE )

item_key_of_reason_refresher = class({})

function item_key_of_reason_refresher:OnSpellStart( )
	local caster = self:GetCaster()
	EmitSoundOn("DOTA_Item.Refresher.Activate", caster)
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	local effect_cast = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	for i=0,caster:GetAbilityCount()-1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability:GetAbilityType()~=DOTA_ABILITY_TYPE_ATTRIBUTES then
			ability:RefreshCharges()
			ability:EndCooldown()
		end
	end

	-- find all refreshable items
	for i=0,8 do
		local item = caster:GetItemInSlot(i)
		if item then
			local pass = false
			if item:GetPurchaser()==caster and not self:IsItemException( item ) then
				pass = true
			end

			if pass then
				item:EndCooldown()
			end
		end
	end
	
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
end

function item_key_of_reason_refresher:IsItemException( item )
	return self.ItemException[item:GetName()]
end

item_key_of_reason_refresher.ItemException = {
	["item_refresher"] = true,
	["item_refresher_shard"] = true,
	["item_key_of_reason_refresher"] = true
}

item_key_of_reason_bkb = class({})

function item_key_of_reason_bkb:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound_cast = "DOTA_Item.BlackKingBar.Activate"
    local modifier_bkb = "modifier_item_key_of_reason_bkb"
    local duration = ability:GetSpecialValueFor("duration")
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
    EmitSoundOn(sound_cast, caster)
    caster:Purge(false, true, false, false, false)
    caster:AddNewModifier(caster, ability, modifier_bkb, {duration = duration})
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
end

modifier_item_key_of_reason_bkb = modifier_item_key_of_reason_bkb or class({})

function modifier_item_key_of_reason_bkb:IsHidden() return false end
function modifier_item_key_of_reason_bkb:GetTexture() return "item_key_of_reason_bkb" end
function modifier_item_key_of_reason_bkb:IsPurgable() return false end
function modifier_item_key_of_reason_bkb:IsDebuff() return false end

function modifier_item_key_of_reason_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_item_key_of_reason_bkb:GetStatusEffectName()
	return "particles/status_fx/status_effect_guardian_angel.vpcf"
end

function modifier_item_key_of_reason_bkb:OnCreated()
    if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
    self.ability = self:GetAbility()
    self.model_scale = self.ability:GetSpecialValueFor("model_scale")
end

function modifier_item_key_of_reason_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_key_of_reason_bkb:CheckState()
    local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return state
end

function modifier_item_key_of_reason_bkb:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_SCALE}
	return decFuncs
end

function modifier_item_key_of_reason_bkb:GetModifierModelScale()
    return self.model_scale
end

item_key_of_reason_dagon_5 = class({})

function item_key_of_reason_dagon_5:OnSpellStart( )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end
	caster:EmitSound("DOTA_Item.Dagon.Activate")
	target:EmitSound("DOTA_Item.Dagon"..self:GetLevel()..".Target")
	if target:IsIllusion() and not Custom_bIsStrongIllusion(target) then
		target:Kill(self, caster)
	end
	local damage = self:GetSpecialValueFor( "damage" )
	local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
	ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
	ParticleManager:ReleaseParticleIndex(dagon_pfx)
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}
	ApplyDamage(damageTable)
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
end

item_key_of_reason_silver_edge = class({})

function item_key_of_reason_silver_edge:OnSpellStart()
	local caster    =   self:GetCaster()
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	EmitSoundOn("DOTA_Item.InvisibilitySword.Activate", caster)
	caster:AddNewModifier(caster, self, "modifier_item_key_of_reason_silver_edge_timer", {})
end

modifier_item_key_of_reason_silver_edge_timer = class({})

function modifier_item_key_of_reason_silver_edge_timer:IsDebuff() return false end
function modifier_item_key_of_reason_silver_edge_timer:IsHidden() return false end
function modifier_item_key_of_reason_silver_edge_timer:IsPurgable() return false end

function modifier_item_key_of_reason_silver_edge_timer:OnCreated()
	self.ability = self:GetAbility()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("windwalk_fade_time"))
end

function modifier_item_key_of_reason_silver_edge_timer:OnIntervalThink()
	if not IsServer() then return end
	local particle_invis_start = "particles/generic_hero_status/status_invisibility_start.vpcf"
	local particle_invis_start_fx = ParticleManager:CreateParticle(particle_invis_start, PATTACH_ABSORIGIN, caster)
	local caster = self:GetCaster()
	local duration = self.ability:GetSpecialValueFor("windwalk_duration")
	ParticleManager:SetParticleControl(particle_invis_start_fx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)
	caster:AddNewModifier(caster, self.ability, "modifier_item_key_of_reason_silver_edge", {duration = duration})
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
	self:Destroy()
end

modifier_item_key_of_reason_silver_edge = class({})

function modifier_item_key_of_reason_silver_edge:IsDebuff() return false end
function modifier_item_key_of_reason_silver_edge:IsHidden() return false end
function modifier_item_key_of_reason_silver_edge:IsPurgable() return false end

function modifier_item_key_of_reason_silver_edge:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.bonus_movespeed        =   self:GetAbility():GetSpecialValueFor("windwalk_movement_speed")
	self.bonus_attack_damage    =   self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage")
	
end

function modifier_item_key_of_reason_silver_edge:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end

function modifier_item_key_of_reason_silver_edge:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_item_key_of_reason_silver_edge:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_item_key_of_reason_silver_edge:GetModifierMoveSpeedBonus_Percentage() return self.bonus_movespeed end

function modifier_item_key_of_reason_silver_edge:GetModifierInvisibilityLevel()
	return 1
end

function modifier_item_key_of_reason_silver_edge:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local ability 			=	self:GetAbility()
			local break_duration	=   self:GetAbility():GetSpecialValueFor("break_duration")
			params.target:AddNewModifier(self:GetParent(), ability, "modifier_item_key_of_reason_silver_edge_debuff", {duration = break_duration * (1 - params.target:GetStatusResistance())})
			self:GetParent():EmitSound("DOTA_Item.SilverEdge.Target")
			self:Destroy()
		end
	end
end

function modifier_item_key_of_reason_silver_edge:OnAbilityExecuted( keys )
	if IsServer() then
		local parent =	self:GetParent()
		-- Remove the invis on cast
		if keys.unit == parent then
			self:Destroy()
		end
	end
end

modifier_item_key_of_reason_silver_edge_debuff = modifier_item_key_of_reason_silver_edge_debuff or class({})

function modifier_item_key_of_reason_silver_edge_debuff:IsDebuff() return true end
function modifier_item_key_of_reason_silver_edge_debuff:IsHidden() return false end
function modifier_item_key_of_reason_silver_edge_debuff:IsPurgable() return false end

function modifier_item_key_of_reason_silver_edge_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
end

function modifier_item_key_of_reason_silver_edge_debuff:CheckState()
	return {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
end

item_key_of_reason_greaves = class({})

function item_key_of_reason_greaves:OnSpellStart()
	if IsServer() then
		-- Parameters
		local heal_amount = self:GetSpecialValueFor("replenish_health") * (1 + self:GetCaster():GetSpellAmplification(false) * 0.01)
		local heal_amount_mana = self:GetSpecialValueFor("replenish_mana") * (1 + self:GetCaster():GetSpellAmplification(false) * 0.01)
		local heal_radius = self:GetSpecialValueFor("heal_radius")
	
		-- Play activation sound and particle
		self:GetCaster():EmitSound("Item.GuardianGreaves.Activate")

		local mekansm_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(mekansm_pfx)

		-- Iterate through nearby allies
		local caster_loc = self:GetCaster():GetAbsOrigin()
		local nearby_allies = FindUnitsInRadius(self:GetCaster():GetTeam(), caster_loc, nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do
			-- Heal the ally
			ally:Heal(heal_amount, self:GetCaster())
			ally:GiveMana(heal_amount_mana)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD , ally, heal_amount_mana, nil)
			ally:EmitSound("Item.GuardianGreaves.Target")
			local mekansm_target_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 0, caster_loc)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 1, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(mekansm_target_pfx)
		end
		local honka = caster:FindModifierByName("modifier_honkai_penalti")
		local honkaEnt = honka:GetCaster()
		caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	end
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
end

item_key_of_reason_hex = class({})

function item_key_of_reason_hex:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor("sheep_duration")

	-- add modifier
	target:AddNewModifier(
		caster, 
		self, 
		"modifier_item_key_of_reason_hex", 
		{ duration = duration * (1 - target:GetStatusResistance()) } -- kv
	)

	-- effects
	local sound_cast = "DOTA_Item.Sheepstick.Activate"
	EmitSoundOn( sound_cast, caster )
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
end

modifier_item_key_of_reason_hex = class({})

function modifier_item_key_of_reason_hex:OnCreated( kv )
	self.base_speed = self:GetAbility():GetSpecialValueFor( "sheep_movement_speed" )
	self.model = "models/props_gameplay/pig.vmdl"
	if IsServer() then
		self:PlayEffects( true )
		if self:GetParent():IsIllusion() then
			self:GetParent():Kill( self:GetAbility(), self:GetCaster() )
		end
	end
end

function modifier_item_key_of_reason_hex:OnRefresh( kv )
	self.base_speed = self:GetAbility():GetSpecialValueFor( "sheep_movement_speed" )
	if IsServer() then
		self:PlayEffects( true )
	end
end

function modifier_item_key_of_reason_hex:OnDestroy( kv )
	if IsServer() then
		self:PlayEffects( false )
	end
end

function modifier_item_key_of_reason_hex:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	return funcs
end

function modifier_item_key_of_reason_hex:GetModifierMoveSpeedOverride()
	return self.base_speed
end

function modifier_item_key_of_reason_hex:GetModifierModelChange()
	return self.model
end

function modifier_item_key_of_reason_hex:CheckState()
	local state = {
	[MODIFIER_STATE_HEXED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}

	return state
end

function modifier_item_key_of_reason_hex:PlayEffects( bStart )
	local sound_cast = "General.Pig"
	local particle_cast = "particles/items_fx/item_sheepstick.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if bStart then
		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

item_key_of_reason_halberd = class({})

-- function item_key_of_reason_halberd:OnSpellStart()
	-- -- unit identifier
	-- local caster = self:GetCaster()
	-- local target = self:GetCursorTarget()

	-- -- cancel if linken
	-- if target:TriggerSpellAbsorb( self ) then return end

	-- -- load data
	-- local duration = 0
	-- -- self:GetSpecialValueFor("duration")

	-- -- add modifier
	-- target:AddNewModifier(
		-- caster, -- player source
		-- self, -- ability source
		-- "modifier_item_key_of_reason_halberd", -- modifier name
		-- { duration = duration } -- kv
	-- )

	-- -- effects
	-- local sound_cast = "Hero_Lion.Voodoo"
	-- EmitSoundOn( sound_cast, caster )
-- end

item_key_of_reason_blink = class({})

item_key_of_reason_blink_cd = class({})

function item_key_of_reason_blink:GetIntrinsicModifierName()
	return "item_key_of_reason_blink_cd"
end

function item_key_of_reason_blink:GetCastAnimation( )
	local anim = ACT_DOTA_FLAIL
	return anim
end

function item_key_of_reason_blink:OnSpellStart()
	local caster = self:GetCaster()
	local vPoint = self:GetCursorPosition() 
	local vOrigin = caster:GetAbsOrigin()
	local nMaxBlink = self:GetSpecialValueFor( "blink_range" )
	local nClamp = self:GetSpecialValueFor( "blink_range_clamp" )
	local vOrigin = caster:GetAbsOrigin()
	local honka = caster:FindModifierByName("modifier_honkai_penalti")
	local honkaEnt = honka:GetCaster()
	caster:AddNewModifier(honkaEnt,
						  honka:GetAbility(),
						  "modifier_honkai_debuff",
						  {extra_stack = self:GetSpecialValueFor("apply_stacks")}
						  )
	ProjectileManager:ProjectileDodge(caster)
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local vDiff = vPoint - vOrigin 
	if vDiff:Length2D() > nMaxBlink then  
		vPoint = vOrigin + (vPoint - vOrigin):Normalized() * nClamp 
	end
	caster:SetAbsOrigin(vPoint) 
	FindClearSpaceForUnit(caster, vPoint, false) 
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
	caster:RemoveModifierByName("modifier_key_of_reason_sim")
end

function item_key_of_reason_blink_cd:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
 
	return funcs
end

function item_key_of_reason_blink_cd:OnTakeDamage( params )
	if IsServer() then 
		local hAbility = self:GetAbility() 
		if params.attacker ~= self:GetParent() and params.unit == self:GetParent() and not self:GetParent():HasScepter() then
		hAbility:StartCooldown(hAbility:GetSpecialValueFor( "blink_damage_cooldown" ))
		end
	end
end

function item_key_of_reason_blink_cd:IsHidden()
	return true --we want item's passive abilities to be hidden most of the times
end

modifier_key_of_reason_sim = class({})

function modifier_key_of_reason_sim:OnCreated(kv)
	if not IsServer() then return end
	self.key_item = self:GetAbility()
	local caster = self:GetCaster()
	self.key_item = caster:TakeItem(self.key_item)
	self.item_sim = caster:AddItemByName(kv.item_name)
end

function modifier_key_of_reason_sim:OnRemoved()
	if not IsServer() then return end
	local caster = self:GetCaster()
	caster:RemoveItem(self.item_sim)
	caster:AddItem(self.key_item):StartCooldown(self:GetRemainingTime())
end
