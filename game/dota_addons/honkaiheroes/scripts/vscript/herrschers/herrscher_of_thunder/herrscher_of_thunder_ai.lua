

function Spawn( entityKeyValues )
	ABILITY_spam_p1 = thisEntity:FindAbilityByName("hot_lightning_judgement")
	ABILITY_hform = thisEntity:FindAbilityByName("hot_herrscher_form")
	ABILITY_soak = thisEntity:FindAbilityByName("hot_static_charge")
	ABILITY_phase_change = thisEntity:FindAbilityByName("hot_phase_change")
	ABILITY_remnant = thisEntity:FindAbilityByName("hot_lightning_illusion")
	thisEntity.phase = 1
	thisEntity.target = 0
	thisEntity:SetContextThink( "HoThunderThink", HoThunderThink , 7)
end



function HoThunderThink()
	if thisEntity.target == 0 then
		target2 = FindUnitsInRadius(
			thisEntity:GetTeamNumber(),	
			thisEntity:GetOrigin(),
			nil,
			FIND_UNITS_EVERYWHERE,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BUILDING,	
			0,	
			1,	
			false
			)
		for _,tar in pairs(target2) do
			thisEntity:SetAttacking(tar)
			thisEntity:MoveToTargetToAttack(thisEntity.target)
			return 0.5
		end
		return 1
	end
	if not thisEntity.target:IsAlive() then
		thisEntity.aggroList[thisEntity.target] = nil
		local new;
		local maxV = 0
		for k, v in pairs(thisEntity.aggroList) do
			if maxV < v then
				new = k
				maxV = v
			end
 		end
		
		thisEntity.target = EntIndexToHScript(new)
		thisEntity:FindModifierByName("modifier_aggro_counter").max = maxV*1.3
		thisEntity:SetAttacking(thisEntity.target)
		thisEntity:MoveToTargetToAttack(thisEntity.target)
		return 0.5
	end
	if thisEntity:GetManaPercent() == 100 and thisEntity.phase == 1 then
		
		thisEntity:CastAbilityNoTarget(ABILITY_phase_change, -1)
		thisEntity.phase = 2
		return 3
	end
	
	if ABILITY_soak:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ABILITY_soak, -1) 
		return 4 
	end
	if ABILITY_hform:IsFullyCastable() then
		thisEntity:CastAbilityOnTarget(thisEntity.target, ABILITY_hform, -1) 
		return 0.8
	end
	if ABILITY_spam_p1:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ABILITY_spam_p1, -1) 
		return 4
	end
	if ABILITY_remnant:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget( ABILITY_remnant, -1)
		return 4
	end
	return 1
end