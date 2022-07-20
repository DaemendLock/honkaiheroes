

function Spawn( entityKeyValues )
	ABILITY_stun = thisEntity:FindAbilityByName("hot_dragon_stun")
	ABILITY_breath = thisEntity:FindAbilityByName("hot_dragon_breath")
	thisEntity:SetContextThink( "KurikaraThink", KurikaraThink , 4)
end



function KurikaraThink()
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
		thisEntity.target = new
		thisEntity:FindModifierByName("modifier_aggro_counter").max = maxV*1.3
		thisEntity:SetAttacking(new)
		thisEntity:MoveToTargetToAttack(new)
		return 0.5
	end
	
	if ABILITY_stun:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget(ABILITY_stun, -1) 
		return 1
	end
	if ABILITY_breath:IsFullyCastable() then
		thisEntity:CastAbilityNoTarget( ABILITY_breath, -1)
		return 1
	end
	return 1

end