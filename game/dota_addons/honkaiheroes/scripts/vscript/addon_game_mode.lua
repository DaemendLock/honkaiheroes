
if honkaiheroes == nil then
    _G.honkaiheroes = class({})
end

_G.PlayerCount = 0
_G.DBM_ON = true

_G.DAMAGE_ELEMENT_TYPE_PHYSICAL = 1
_G.DAMAGE_ELEMENT_TYPE_ELEMENTAL = 2
_G.DAMAGE_ELEMENT_TYPE_FIRE = 3
_G.DAMAGE_ELEMENT_TYPE_ICE = 4
_G.DAMAGE_ELEMENT_TYPE_LIGHTNING = 5
_G.DAMAGE_ELEMENT_TYPE_CRIT_RATE = 6
_G.DAMAGE_ELEMENT_TYPE_CRIT_DMG = 7
_G.DAMAGE_ELEMENT_TYPE_BURST_MODE = 8
_G.DAMAGE_ELEMENT_TYPE_ADAPTIVE = 0


DamageElementTypes = {
["DAMAGE_ELEMENT_TYPE_PHYSICAL"] = 1,
["DAMAGE_ELEMENT_TYPE_ELEMENTAL"] = 2,
["DAMAGE_ELEMENT_TYPE_FIRE"] = 3,
["DAMAGE_ELEMENT_TYPE_ICE"] = 4,
["DAMAGE_ELEMENT_TYPE_LIGHTNING"] = 5,
["DAMAGE_ELEMENT_TYPE_CRIT_RATE"] = 6,
["DAMAGE_ELEMENT_TYPE_CRIT_DMG"] = 7,
["DAMAGE_ELEMENT_TYPE_BURST_MODE"] = 8,
["DAMAGE_ELEMENT_TYPE_ADAPTIVE"] = 0
}
--require( 'upgrade')
require("utility/filters")
require("addon_setup")
require("stigmata/stigmata_menu")
require("team_setup")

function Precache( context )
	PrecacheResource( "soundfile", "soundevents/keys_sounds.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context ) 
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context ) 
	PrecacheResource( "soundfile", "soundevents/herrschers/herrscher_of_thunder_sound.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/dbm_sounds.vsndevts", context )
	PrecacheResource( "model",     "models/heroes/arc_warden/arc_warden.vmdl", context)
end

GameMode = class({})

function Activate()
	GameRules.AddonTemplate = honkaiheroes()
	GameRules.AddonTemplate:InitGameMode()
end

function honkaiheroes:InitGameMode()
	GameSetup:init()
	stigmata_menu:StartListnening();
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ExpFilter"), self)
	CreateUnitByName("honkai", Vector(0,0,0), false, nil, nil, DOTA_TEAM_NOTEAM)
	
end

function GameMode:DamageFilter(event)
	local caster = EntIndexToHScript(event.entindex_attacker_const)
	local target = EntIndexToHScript(event.entindex_victim_const)
	local damageType = nil
	if event.entindex_inflictor_const ~= nil then
		local ability = EntIndexToHScript(event.entindex_inflictor_const)
		if ability.GetAbilityKeyValues ~= nil then
		damageType = DamageElementTypes[ability:GetAbilityKeyValues().DamageElementType]
		end
	end
	if damageType == nil then
		damageType = 1
	end
	local damage = event.damage
	local casterStats = GetUnitDamageBonusesPct(caster, event)
	local targetBreach = GetUnitBreachPct(target:FindAllModifiers())
	if damageType > 1 then
		damage = damage*(100 + casterStats[2])*(100+ targetBreach[2])/10000
	end
	local bMod = caster:FindModifierByName("modifier_burst_mode")
	if bMod and bMod:IsActive() then
		damage = damage*casterStats[8]/100
	end
	damage = damage*(100 + casterStats[damageType])*(100 + targetBreach[damageType])/10000
	damage = damage*GetSummonBonus(caster)/100
	if damageType == 1 and RollPercentage(casterStats[6]) then
		damage = damage*(100+casterStats[7])/100
		SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_CRITICAL , target, damage, caster:GetPlayerOwner())
	end
	
	event.damage=damage
	return true
end

function GetUnitDamageBonusesPct(unit, event)
	local bonus = {0, 0, 0, 0, 0, 0, 0, 100, 100}
	local crt = 0
	local list = unit:FindAllModifiers()
	for _, buff in pairs(list) do
		if buff.DeclareFunctions~= nil then
		if buff.GetModifierBonusStats_PhysicalDamage ~= nil then
			bonus[1] = bonus[1] + buff:GetModifierBonusStats_PhysicalDamage(event)
		end
		if buff.GetModifierBonusStats_ElementalDamage ~= nil then
			bonus[2] = bonus[2] + buff:GetModifierBonusStats_ElementalDamage(event)
		end
		if buff.GetModifierBonusStats_FireDamage ~= nil then
			bonus[3] = bonus[3] + buff:GetModifierBonusStats_FireDamage(event)
		end
		if buff.GetModifierBonusStats_IceDamage ~= nil then
			bonus[4] = bonus[4] + buff:GetModifierBonusStats_IceDamage(event)
		end
		if buff.GetModifierBonusStats_LightningDamage ~= nil then
			bonus[5] = bonus[5] + buff:GetModifierBonusStats_LightningDamage(event)
		end
		if buff.GetModifierBonusStat_CritRate ~= nil then
			bonus[6] = bonus[6] + buff:GetModifierBonusStat_CritRate(event)
		end
		if buff.GetModifierBonusStat_CritDamage ~= nil then
			bonus[7] = bonus[7] + buff:GetModifierBonusStat_CritDamage(event)
		end
		if buff.GetModifierStatCRT_Bonus ~= nil then
			crt = crt + buff:GetModifierStatCRT_Bonus(event)
		end
		if buff.GetModifierBonusStat_BurstmodeDamage ~= nil then
			bonus[8] = bonus[8] + buff:GetModifierBonusStat_BurstmodeDamage(event)
		end
		end
	end
	bonus[6] = crt * 100 / (unit:GetLevel() * 5 + 75) + bonus[6]
	return bonus
end

function GetUnitBreachPct(unit)
	local bonus = {0,0,0,0,0,0}
	for _, buff in pairs(unit) do
		if buff.DeclareFunctions ~= nil then
		if buff.GetModifierBreach_PhysicalDamage ~= nil then
			bonus[1] = bonus[1] + buff:GetModifierBreach_PhysicalDamage()
		end
		if buff.GetModifierBreach_ElementalDamage ~= nil then
			bonus[2] = bonus[2] + buff:GetModifierBreach_ElementalDamage()
		end
		if buff.GetModifierBreach_FireDamage ~= nil then
			bonus[3] = bonus[3] + buff:GetModifierBreach_FireDamage()
		end
		if buff.GetModifierBreach_IceDamage ~= nil then
			bonus[4] = bonus[4] + buff:GetModifierBreach_IceDamage()
		end
		if buff.GetModifierBreach_LightningDamage ~= nil then
			bonus[5] = bonus[5] + buff:GetModifierBreach_LightningDamage()
		end
		end
	end
	return bonus
end

function GetSummonBonus(unit)
	local owner = unit:GetPlayerOwner()
	if not owner then return 100 end
	owner = owner:GetAssignedHero()	
	if (owner == unit ) then
		return 100
	end
	local list = owner:FindAllModifiers()
	local bonus = 100
	for _, buff in pairs(list) do	
		if buff.GetModifierBonusStat_SummonBonus ~= nil then
			bonus = bonus + buff:GetModifierBonusStat_SummonBonus()
		end
	end
	return bonus
end



function GameMode:GoldFilter(event)
	if (event.reason_const == DOTA_ModifyGold_HeroKill ) then
		event.gold = 0
	end
	return true
end

function GameMode:ExpFilter(event)
	if (event.reason_const == DOTA_ModifyXP_HeroKill  ) then
		event.experience = 0
	end
	return true
end
