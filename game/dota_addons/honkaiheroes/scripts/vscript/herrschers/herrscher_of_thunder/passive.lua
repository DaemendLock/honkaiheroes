--//3RD--HERRSCHER--OF-THUNDER
--	//TP to any building
--	//PHASE-1 
--	//		CAST ABILITY : Herrscher form - BECOMES LIGHTNING AND ATTACK NEARBY ENEMY EVERY 0.25SEC (DURATION 1 SEC) CD: 7SEC
--//PHASE-2 (1000HC)
--	//		-100% MELEE DAMAGE
--	//		PURE DAMAGE
--	//		SLOWLY PULLS EMENY IN MEDIUS AOE 
--	//		SUMMNON DRAGON AND DISPELL ALL LIGHTNING JUDGMENT
--	//		CAST ABILITY : Herrscher form
--	//		CAST ABILITY : STATIC CHARGE CD: 15SEC
--	//		CAST ABILITY : DRAGON TAIL - CLEAVE AND STUNS(5SEC) ALL ENEMY IN CONUS-FORM MEDIUM RANGE CD: 15SEC
--	// 		CAST ABILITY : LIGHTNING BREATH - STRIKES BEAM APPLYING LIGHTNING VURNABLE(200%) Effect can be refreshed. stacks unlimeted. CD: 10SEC;
--  //		CAST ABILITY : WIPE HUMANITY - AFTER 80SEC KILLS ALL HEROES
	
LinkLuaModifier( "modifier_lightning_blade", "herrschers/herrscher_of_thunder/passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lightning_root", "herrschers/herrscher_of_thunder/passive", LUA_MODIFIER_MOTION_NONE )


hot_passive = class({})

function hot_passive:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function hot_passive:GetIntrinsicModifierName()
	return "modifier_lightning_blade"
end

modifier_lightning_blade = class({})

function modifier_lightning_blade:IsHidden()
	return true
end

function modifier_lightning_blade:OnCreated()
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbility():GetSpecialValueFor("crit_mult")
	self.cleave = self:GetAbility():GetSpecialValueFor("cleave")
	self.root_duration = self:GetAbility():GetSpecialValueFor("root_duration")
	self.hc_restore = self:GetAbility():GetSpecialValueFor("hc_restore")
end

function modifier_lightning_blade:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, 
		MODIFIER_PROPERTY_MANA_DRAIN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH 
	}

	return funcs
end

function modifier_lightning_blade:OnDeath(event)
	if event.unit == self:GetParent() then
	if event.unit.phase == 2 then
		event.unit.linkedUnit:ForceKill()
	end
	return
	end
	local loop = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO ,
		0,
		1,
		false
	)
	if #loop == 0 then
		GameRules:MakeTeamLose(2)
		GameRules:MakeTeamLose(3)
		GameRules:MakeTeamLose(6)
		GameRules:MakeTeamLose(7)
		GameRules:MakeTeamLose(8)
		GameRules:MakeTeamLose(9)
		GameRules:MakeTeamLose(10)
		GameRules:MakeTeamLose(11)
	end
	
end

function modifier_lightning_blade:CheckState()
	local state = {
		[MODIFIER_STATE_FORCED_FLYING_VISION ] = true
	}
	return state
end

function modifier_lightning_blade:GetModifierPercentageManacost()
	return -100
end

function modifier_lightning_blade:GetModifierManaDrainAmplify_Percentage()
	return -100
end

function modifier_lightning_blade:GetModifierConstantManaRegen()
	return 0
end

function modifier_lightning_blade:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if RandomInt(0, 100)<self.crit_chance then
			self.record = params.record
			return self.crit_mult
		end
	end
end

function modifier_lightning_blade:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lightning_root", {duration = self.root_duration } )
			self:GetCaster():GiveMana(self.hc_restore)
			local sound_cast = "Hero_Juggernaut.BladeDance"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end


modifier_lightning_root = class({})

function modifier_lightning_root:IsHidden()
	return false
end

function modifier_lightning_root:IsDebuff()
	return true
end

function modifier_lightning_root:IsStunDebuff()
	return false
end

function modifier_lightning_root:IsPurgable()
	return true
end

function modifier_lightning_root:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_lightning_root:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
		
	}
	return state
end

function modifier_lightning_root:GetEffectName()
	return "particles/units/heroes/hero_siren/siren_net.vpcf"
end

function modifier_lightning_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




