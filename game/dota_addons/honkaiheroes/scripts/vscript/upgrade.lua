

if upgrade == nil then
    _G.upgrade = class({})
end

skills = {
	{"modifier_wyvern_arctic_burn_1",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","arctic_burn",18,1,"arctic_burn_1",0},
	{"modifier_wyvern_arctic_burn_2",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","arctic_burn",25,1,"arctic_burn_2",0},
	{"modifier_wyvern_arctic_burn_3",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","arctic_burn",18,1,"arctic_burn_3",0},

	{"modifier_wyvern_splinter_blast_1",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","splinter_blast",22,2,"splinter_blast_1",0},
	{"modifier_wyvern_splinter_blast_2",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","splinter_blast",18,2,"splinter_blast_2",0},
	{"modifier_wyvern_splinter_blast_3",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","splinter_blast",22,2,"splinter_blast_3",0},

	{"modifier_wyvern_winters_curse_1",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","cold_embrace",22,3,"cold_embrace_1",0},
	{"modifier_wyvern_winters_curse_2",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","cold_embrace",22,3,"cold_embrace_2",0},
	{"modifier_wyvern_winters_curse_3",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","cold_embrace",22,3,"cold_embrace_3",0},

	{"modifier_wyvern_winters_curse_1",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","winters_curse",22,4,"wyvern_winters_curse_1",0},
	{"modifier_wyvern_winters_curse_2",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","winters_curse",18,4,"wyvern_winters_curse_2",0},
	{"modifier_wyvern_winters_curse_3",1,"npc_dota_hero_winter_wyvern","blue",3,"blue_skill","winters_curse",22,4,"wyvern_winters_curse_3",0},
	


	{"modifier_wyvern_arctic_burn_4",1,"npc_dota_hero_winter_wyvern","purple",2,"purple_skill","arctic_burn",18,1,"arctic_burn_4",1},
	{"modifier_wyvern_arctic_burn_5",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","arctic_burn",25,1,"arctic_burn_5",1},
	{"modifier_wyvern_arctic_burn_6",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","arctic_burn",18,1,"arctic_burn_6",1},

	{"modifier_wyvern_splinter_blast_4",1,"npc_dota_hero_winter_wyvern","purple",2,"purple_skill","cold_embrace",22,2,"splinter_blast_4",0},
	{"modifier_wyvern_splinter_blast_5",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","cold_embrace",18,2,"splinter_blast_5",1},
	{"modifier_wyvern_splinter_blast_6",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","cold_embrace",22,2,"splinter_blast_6",0},

	{"modifier_wyvern_cold_embrce_4",1,"npc_dota_hero_winter_wyvern","purple",2,"purple_skill","cold_embrace",22,3,"cold_embrace_4",1},
	{"modifier_wyvern_cold_embrce_5",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","cold_embrace",22,3,"cold_embrace_5",0},
	{"modifier_wyvern_cold_embrce_6",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","cold_embrace",22,3,"cold_embrace_6",0},

	{"modifier_wyvern_winters_curse_4",1,"npc_dota_hero_winter_wyvern","purple",2,"purple_skill","winters_curse",22,4,"wyvern_winters_curse_4",1},
	{"modifier_wyvern_winters_curse_5",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","winters_curse",18,4,"wyvern_winters_curse_5",0},
	{"modifier_wyvern_winters_curse_6",1,"npc_dota_hero_winter_wyvern","purple",1,"purple_skill","winters_curse",22,4,"wyvern_winters_curse_6",0},



	{"modifier_wyvern_arctic_burn_deepfreez",1,"npc_dota_hero_winter_wyvern","orange",0,"orange_skill","arctic_burn",25,1,1},
	{"modifier_wyvern_cold_embrce_damagecolb",1,"npc_dota_hero_winter_wyvern","orange",0,"orange_skill","splinter_blast",17,1,2},
	{"modifier_wyvern_splinter_blast_split",1,"npc_dota_hero_winter_wyvern","orange",0,"orange_skill","cold_embrace",22,1,3},
	{"modifier_wyvern_winters_curse_split",1,"npc_dota_hero_winter_wyvern","orange",0,"orange_skill","winters_curse",22,1,4},

}



function upgrade:InitGameMode()
	ListenToGameEvent("entity_killed", Dynamic_Wrap(self,"OnEntityKilled"), self)

	ListenToGameEvent("npc_spawned", Dynamic_Wrap(self,"OnEntitySpawned"), self)

	CustomGameEventManager:RegisterListener( "get_upgrades", function( _,data )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( data.PlayerID), "upgrades_table", {skills = skills, length = #skills} )
	end )

	CustomGameEventManager:RegisterListener( "get_upgrades_end", function( _,data )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( data.PlayerID), "upgrades_table", {skills = skills, length = #skills} )
	end )

	CustomGameEventManager:RegisterListener( "get_upgrades_pick", function( _,data )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( data.PlayerID), "upgrades_table", {skills = skills, length = #skills} )
	end )


    CustomGameEventManager:RegisterListener( "activate_choise", Dynamic_Wrap(self, 'make_choise'))

    CustomGameEventManager:RegisterListener( "refresh_sphere", Dynamic_Wrap(self, 'refresh_sphere'))
end





function upgrade:OnEntitySpawned( params )
local unit = EntIndexToHScript(params.entindex)
local owner = unit:GetOwner()

if not owner or owner == nil or owner:IsNull() then return end

for i = 1,11 do 
	if players[i] ~= nil then 
		if unit:GetUnitName() then

			unit.x_max = players[i].x_max
			unit.x_min = players[i].x_min
			unit.y_max = players[i].y_max
			unit.y_min = players[i].y_min
			unit.z = players[i].z

		end

	end
end

end











function upgrade:OnEntityKilled( param )

if param.entindex_attacker == nil then return end

local hero = EntIndexToHScript( param.entindex_attacker )
local unit = EntIndexToHScript(param.entindex_killed)


if unit:IsRealHero() and unit:IsReincarnating() == false then

	if players[hero:GetTeamNumber()] ~= nil then
		Server_data[players[hero:GetTeamNumber()]:GetPlayerID()].kills = Server_data[players[hero:GetTeamNumber()]:GetPlayerID()].kills + 1
	end

	if unit:HasModifier("modifier_final_duel") then 
		unit:SetBuyBackDisabledByReapersScythe(true)
		unit:SetTimeUntilRespawn(round_timer + 3)

	else 
    	if players[unit:GetTeamNumber()] then 


			if players[hero:GetTeamNumber()] ~= nil and hero ~= unit and hero:IsHero() and unit:HasModifier("modifier_player_damage")  then

				local target_array = players[unit:GetTeamNumber()]
				local killer_array = players[hero:GetTeamNumber()]

				local target_id = unit:GetPlayerID()
				local killer_id = hero:GetPlayerID()


				if (killer_array.damages[target_id] > 0) then 
					killer_array.damages[target_id] = 0
				else 
					if killer_array.damages[target_id] > -Player_damage_max then 
						killer_array.damages[target_id] = killer_array.damages[target_id] - Player_damage_inc	
					end
				end

				if (target_array.damages[killer_id] < 0) then 
					target_array.damages[killer_id] = 0
				else 
					if target_array.damages[killer_id] < Player_damage_max then 
						target_array.damages[killer_id] = target_array.damages[killer_id] + Player_damage_inc	
					end
				end

			end


			Server_data[players[unit:GetTeamNumber()]:GetPlayerID()].death = Server_data[players[unit:GetTeamNumber()]:GetPlayerID()].death + 1

 			local bonus_res = 0
 		
 			if hero:IsHero() then 
 				 --players[unit:GetTeamNumber()].on_streak == true and
 				--bonus_res = Streak_res 
 				--local bonus_gold =  Streak_gold
 				local net_killer = PlayerResource:GetNetWorth(hero:GetPlayerID())
 				local net_victim = PlayerResource:GetNetWorth(unit:GetPlayerID()) 

 				bonus_gold = 0
 				if net_victim > net_killer then 
 					bonus_gold = (net_victim - net_killer)*Streak_k
 				end

				hero:ModifyGold(bonus_gold , true , DOTA_ModifyGold_HeroKill)
 				SendOverheadEventMessage(hero, 0, hero, bonus_gold, nil)

 			end

 			unit:SetTimeUntilRespawn(StartDeathTimer + players[unit:GetTeamNumber()].death*DeathTimer + bonus_res + players[unit:GetTeamNumber()].Players_Died*DeathTimer_PerPlayer)
 			players[unit:GetTeamNumber()].death = players[unit:GetTeamNumber()].death + 1
		else 
			unit:SetTimeUntilRespawn(5)
		end
	end





end

 
if param.entindex_attacker == nil then return end


if (unit:GetTeam() == DOTA_TEAM_CUSTOM_5) and (unit:GetUnitName() == "npc_roshan_custom") and EntIndexToHScript(param.entindex_attacker):GetUnitName() ~= "npc_roshan_custom" then 

	local item = CreateItem("item_aegis", nil, nil)
 	CreateItemOnPositionSync(GetGroundPosition(unit:GetAbsOrigin(), unit), item)
 	if unit.number >= 1 then 
		local item_2 = CreateItem("item_roshan_necro", nil, nil)
 		CreateItemOnPositionSync(GetGroundPosition(unit:GetAbsOrigin()+RandomVector(RandomInt(-1, 1) + 100), unit), item_2)
 	end
end


if not hero:IsHero() and not hero:IsBuilding() then return end

if unit:GetTeam() == DOTA_TEAM_NEUTRALS and not hero:HasModifier("modifier_final_duel")  then 

	local tier = 0
	if (math.floor(GameRules:GetDOTATime(false, false)/60 )) >= 0 then tier = 1 end
	if (math.floor(GameRules:GetDOTATime(false, false)/60 )) >= 10 then tier = 2 end
	if (math.floor(GameRules:GetDOTATime(false, false)/60 )) >= 20 then tier = 3 end
	if (math.floor(GameRules:GetDOTATime(false, false)/60 )) >= 30 then tier = 4 end
	if (math.floor(GameRules:GetDOTATime(false, false)/60 )) >= 40 then tier = 5 end

    local szItemDrop = GetPotentialNeutralItemDrop( tier, hero:GetTeamNumber() )
    local chance = NeutralChance - players[hero:GetTeamNumber()].NeutraItems[tier]*3 

    if my_game:IsAncientCreep(unit) then chance = chance*3 end
    
    local random = RollPseudoRandomPercentage(NeutralChance,153,hero)
        
    if szItemDrop ~= nil and players[hero:GetTeamNumber()].NeutraItems[tier] < MaxNeutral and random then

        players[hero:GetTeamNumber()].NeutraItems[tier] = players[hero:GetTeamNumber()].NeutraItems[tier] + 1

 		if hero:IsIllusion() then 
 			hero = hero.owner
 		end

		local point = Vector(0,0,0)

 		if hero:IsAlive() then
 			point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 
		else
 			if towers[hero:GetTeamNumber()] ~= nil then 
 				point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 			end
 		end

        local hItem = DropNeutralItemAtPositionForHero( szItemDrop, point, hero, tier, true )
    end

end


local name = nil
local effect = nil
local sound = nil
local drop = true
local owner = nil

if (unit:GetTeam() == DOTA_TEAM_CUSTOM_5) and unit.ally and unit.ally ~= nil then

 local count_mob = 0

 	for i = 1,#unit.ally do 
 		if not unit.ally[i]:IsNull() then 
 			if unit.ally[i]:IsAlive() then 
 				drop = false 
 				count_mob = count_mob + 1
 			end 

 		end
	end	

 	if unit.host ~= nil and players[unit.host:GetTeamNumber()] ~= nil then 
		local next_wave = my_game:GetWave(unit.wave_number, unit.isboss)
		local skills = my_game:GetSkills(unit.wave_number, unit.isboss)
		local mkb = my_game:GetMkb(unit.wave_number, unit.isboss)

   		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(players[unit.host:GetTeamNumber()]:GetPlayerID()) , 'timer_progress',  {units = count_mob, units_max = unit.max,  time = -1, max = -1, name = next_wave, skills = skills, mkb = mkb, reward = unit.reward, gold = unit.givegold, number = my_game.current_wave, hide = false})	
   	end


 	if drop then

 		if unit.host ~= nil then 
 		 	players[unit.host:GetTeamNumber()].ActiveWave = nil
 		end

  		if not hero:IsBuilding() or unit.drop == "item_legendary_upgrade" or (unit.drop == "item_purple_upgrade" and my_game.current_wave == 4)  then 
 	 		name = unit.drop 
  			effect = unit.effect
 			sound = unit.sound

 			if unit.drop == "item_legendary_upgrade" or (unit.drop == "item_purple_upgrade" and my_game.current_wave == 4)  then 
 				owner = unit.owner
 			end
 		end
	end 


end




if (unit:GetTeam() == DOTA_TEAM_NEUTRALS) and not hero:IsBuilding()  and not hero:HasModifier("modifier_final_duel") then
	
 	if my_game:BluePoints(unit) ~= nil then 

		players[hero:GetTeamNumber()].bluepoints = players[hero:GetTeamNumber()].bluepoints + (my_game:BluePoints(unit)*(1 + 0.2*players[hero:GetTeamNumber()]:GetUpgradeStack("modifier_up_bluepoints"))) 
				 
		if players[hero:GetTeamNumber()].bluepoints >= players[hero:GetTeamNumber()].bluemax then 
			
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = players[hero:GetTeamNumber()].bluemax, purple = players[hero:GetTeamNumber()].purplepoints, max = players[hero:GetTeamNumber()].bluemax, max_p =  math.floor( players[hero:GetTeamNumber()].purplemax)})
			
			Timers:CreateTimer(0.5,function()
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = players[hero:GetTeamNumber()].purplepoints , max = players[hero:GetTeamNumber()].bluemax, max_p =  math.floor( players[hero:GetTeamNumber()].purplemax)})
			end)

			players[hero:GetTeamNumber()].bluepoints = players[hero:GetTeamNumber()].bluepoints - players[hero:GetTeamNumber()].bluemax
			players[hero:GetTeamNumber()].bluemax = players[hero:GetTeamNumber()].bluemax + PlusBlue
			name = "item_blue_upgrade"	
			effect = "particles/blue_drop.vpcf"
			sound = "powerup_03"
		else 

		    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = players[hero:GetTeamNumber()].purplepoints, max = players[hero:GetTeamNumber()].bluemax, max_p =  math.floor( players[hero:GetTeamNumber()].purplemax) })

		end
				 
 	end

end
	
if hero:IsBuilding() then hero = players[hero:GetTeamNumber()] end

if (unit:IsRealHero() or unit:GetUnitName() == "npc_roshan_custom") and hero:GetTeamNumber() ~= unit:GetTeamNumber() and not unit:HasModifier("modifier_final_duel")  and unit:IsReincarnating() == false  then

	players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + 1 
				 
	if players[hero:GetTeamNumber()].purplepoints >= math.floor( players[hero:GetTeamNumber()].purplemax ) then 
		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = math.floor(players[hero:GetTeamNumber()].purplemax), max = players[hero:GetTeamNumber()].bluemax, max_p = math.floor(players[hero:GetTeamNumber()].purplemax)})
		
		Timers:CreateTimer(0.5,function()
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', {blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = players[hero:GetTeamNumber()].purplepoints, max = players[hero:GetTeamNumber()].bluemax, max_p = math.floor( players[hero:GetTeamNumber()].purplemax)})
		end)

		players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints - math.floor(players[hero:GetTeamNumber()].purplemax)
		players[hero:GetTeamNumber()].purplemax = players[hero:GetTeamNumber()].purplemax + PlusPurple
					
		name = "item_purple_upgrade"
		effect = "particles/purple_drop.vpcf"
		sound = "powerup_05"
	else 
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerID()) , 'kill_progress', { blue = math.floor(players[hero:GetTeamNumber()].bluepoints), purple = players[hero:GetTeamNumber()].purplepoints, max = players[hero:GetTeamNumber()].bluemax , max_p = math.floor( players[hero:GetTeamNumber()].purplemax)})
	end

end


if name ~= nil then 

	if name == "item_purple_upgrade" then 
		players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1
	end

	if hero:IsIllusion() then 
 		hero = hero.owner
 	end

 	if owner ~= nil then 
 		hero = owner
 	end


	local item = CreateItem(name, hero, hero)

 	item_effect = ParticleManager:CreateParticle( effect, PATTACH_WORLDORIGIN, nil )

	local point = Vector(0,0,0)



 	if hero:IsAlive() then

 		point = hero:GetAbsOrigin() + hero:GetForwardVector()*150 

	else

 		if towers[hero:GetTeamNumber()] ~= nil then 
 			point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector()*300
 		end

 	end

    ParticleManager:SetParticleControl( item_effect, 0, point )
       
    EmitSoundOnEntityForPlayer(sound, hero,  hero:GetPlayerOwnerID())

	Timers:CreateTimer(0.8,function()
 		CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
	end)

end	
 	
end


_G.s = nil
for i = 1,#skills do
	if skills[i][2] == 1 then 
		s = 'upgrade/'..skills[i][3]..'/'..skills[i][1]..'.lua'
		LinkLuaModifier(skills[i][1], s, LUA_MODIFIER_MOTION_NONE)
	end
	if skills[i][2] == 0 then 

		s = 'upgrade/general/'..skills[i][1]..'.lua'
		LinkLuaModifier(skills[i][1], s, LUA_MODIFIER_MOTION_NONE)
	end
	if skills[i][2] == 2 then 

		s = 'upgrade/tower/'..skills[i][1]..'.lua'
		LinkLuaModifier(skills[i][1], s, LUA_MODIFIER_MOTION_NONE)
	end
end


chance = {0,0,0}


function my_game:Check_ban(player, s )

if #players[player:GetTeamNumber()].ban == 0 then return true end
	for j = 1,#players[player:GetTeamNumber()].ban do
		if s == players[player:GetTeamNumber()].ban[j] then return false end
	end
return true 
end

function my_game:ActiveSkills(player,  number , rare )
local n = 0
	if rare == 1 then rarity = "gray" end
	if rare == 2 then rarity = "blue" end
	if rare == 3 then rarity = "purple" end
	if rare == 4 then rarity = "orange" end

for i = 1,#skills do
	if skills[i][9] == number and skills[i][4] == rarity and 
		 ((skills[i][2] == 1 and skills[i][3] == player:GetUnitName()) or (skills[i][2] ~= 1))  then 

		 	local mod = player:FindModifierByName(skills[i][1])
		 	if not mod then 
		 		n = n + skills[i][5]
		 else 

				local stacks = mod:GetStackCount()
				n = n + skills[i][5] - stacks
			
		end
		 

		 	
	end
end
return n
end


function my_game:CheckSkill( player , number , rare )

	if rare == 1 then rarity = "gray" end
	if rare == 2 then rarity = "blue" end
	if rare == 3 then rarity = "purple" end
	if rare == 4 then rarity = "orange" end

	for i = 1,#skills do
		if skills[i][9] == number and skills[i][4] == rarity and 
		 ((skills[i][2] == 1 and skills[i][3] == player:GetUnitName()) or (skills[i][2] ~= 1))  then 
		
			local mod = player:FindModifierByName(skills[i][1])

			if not mod then return true end

			if mod then 
				local stacks = mod:GetStackCount()
				if stacks < skills[i][5] then return true end
			end

		end

	end
return false 
end

function my_game:RandomCheck(i, array)
local f = true 

	


 if array ~= nil then



 	for j = 1,#array do 
 		if array[j] == i then return false  end
 	end

end


return true 

end

function my_game:SortSkill( rare , player)
local sort = {}
local j = 0
local f = false
local start = 1

if players[player:GetTeamNumber()].chosen_skill ~= 0
 and (my_game:RandomCheck(players[player:GetTeamNumber()].chosen_skill,players[player:GetTeamNumber()].ban_skills)) 
 then 
 	sort[1] = players[player:GetTeamNumber()].chosen_skill
	start = 2
end


for i = start,2 do
		repeat j = RandomInt(1, 4)
			f = true
			for c = 1,2 do
				if sort[c] == j and #players[player:GetTeamNumber()].ban_skills < 3 then 
					f = false 
					break
				end
			end
			if not my_game:RandomCheck(j,players[player:GetTeamNumber()].ban_skills) then f = false end

		until f == true 

		sort[i] = j
end

return sort
end


 
_G.skill_number = {}


function check_type(player,type_s)
if not IsServer() then return end

for i = 1,#players[player:GetTeamNumber()].HeroType do 
	if players[player:GetTeamNumber()].HeroType[i] == type_s then 
		return true
	end
end

return false
end


function find_skill( player, rare , number, skill )
	local j = 0
	local buffer = {}

	local mod = nil
	local stacks = 0
	local rarity = nil
	if rare == 1 then rarity = "gray" end
	if rare == 2 then rarity = "blue" end
	if rare == 3 then rarity = "purple" end
	if rare == 4 then rarity = "orange" end

	for i = 1,#skills do
		if my_game:Check_ban(player,skills[i]) then

			if skills[i][2] == 2 then 
				mod = towers[player:GetTeamNumber()]:FindModifierByName(skills[i][1])	
			else
				mod = player:FindModifierByName(skills[i][1])
			end	

		stacks = 0

		if (mod ~= nil)  then stacks = mod:GetStackCount() end

			if (rare == 1 or skills[i][9] == skill or skill == 5) and skills[i][4] == rarity and  (stacks < skills[i][5] or skills[i][5] == 0)  then

				if ((skills[i][2] == 1) and (player:GetUnitName() == skills[i][3])) or (((skills[i][2] == 0) or (skills[i][2] == 2)) and 
				((skills[i][3] == "all") or ( check_type(players[player:GetTeamNumber()],skills[i][3]) ))) then
					j = j + 1
					buffer[j] = skills[i]
				end
			end

    	end
	end

       if j == 0 then return find_skill(player,rare-1,number,skill) end

	local r = RandomInt(1, #buffer)
	if number > 1 then
		for i = 1,number-1 do

		 if buffer[r] == players[player:GetTeamNumber()].choise[i] then 
		 		players[player:GetTeamNumber()].ban_i = players[player:GetTeamNumber()].ban_i + 1
		 		players[player:GetTeamNumber()].ban[players[player:GetTeamNumber()].ban_i] = buffer[r]
		 		return find_skill(player,rare,number,skill)
		 	end

		end
	  

	end
	players[player:GetTeamNumber()].ban_i = 0
	players[player:GetTeamNumber()].ban = {}
	return buffer[r]

end

function find_legendary( player )
	
	local j = 0
	for i = 1,#skills do
		if (skills[i][4] == "orange") and (skills[i][3] == player:GetUnitName()) then
			local mod = player:FindModifierByName(skills[i][1])
			if not mod then
			 j = j+1
			 players[player:GetTeamNumber()].choise[j] = skills[i]
			end
		end

	end

end


LinkLuaModifier("using_item", "upgrade/item_upgrade", LUA_MODIFIER_MOTION_NONE)

function upgrade:init_upgrade( player , rarity , can_refresh)



if not  test then
	players[player:GetTeamNumber()].IsChoosing = true
end
players[player:GetTeamNumber()].choise = {}



if rarity == 4 then
	local l = 0
	find_legendary(player)
	if #players[player:GetTeamNumber()].choise == 4 then
		l = 1 else l = 0 end

	local alert = 0
	if players[player:GetTeamNumber()].chosen_skill == 0 then 
		alert = 1
	end

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerID()) , 'show_choise', {choise = players[player:GetTeamNumber()].choise, mods = {}, legendary = l, hasup = players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"), alert = alert})

	players[player:GetTeamNumber()].choise_table = 
{
	players[player:GetTeamNumber()].choise,
	alert,
	false,
	{},
	1,
	false
}


	return

elseif rarity == 1 then 


	players[player:GetTeamNumber()].choise[1] = find_skill(player,rarity,1,5)

	players[player:GetTeamNumber()].choise[2] = find_skill(player,rarity,2,5)

    players[player:GetTeamNumber()].choise[3] = find_skill(player,rarity,3,5)

else  

local j = 0
players[player:GetTeamNumber()].ban_skills = {}
for i = 1,4 do
	if my_game:CheckSkill(player,i,rarity) == false then 
		j = j + 1
		players[player:GetTeamNumber()].ban_skills[j] = i
	end
end

if j == 4 then 


	if rarity == 2 then 
		players[player:GetTeamNumber()].choise[1] = find_skill(player,1,1,5)
		players[player:GetTeamNumber()].choise[2] = find_skill(player,1,2,5)
	else 
		local t = 0
		players[player:GetTeamNumber()].ban_skills = {}
		for i = 1,4 do
			if my_game:CheckSkill(player,i,rarity-1) == false then 
				t = t + 1
				players[player:GetTeamNumber()].ban_skills[t] = i
			end
		end

		if t == 4 then
			players[player:GetTeamNumber()].choise[1] = find_skill(player,1,1,5)
			players[player:GetTeamNumber()].choise[2] = find_skill(player,1,2,5)
		else 
			local skill_number = my_game:SortSkill(rarity-1,player)
			players[player:GetTeamNumber()].choise[1] = find_skill(player,rarity-1,1,skill_number[1])
			players[player:GetTeamNumber()].choise[2] = find_skill(player,rarity-1,2,skill_number[2])
		end 
	end 

else 

	local skill_number = my_game:SortSkill(rarity,player)
	players[player:GetTeamNumber()].choise[1] = find_skill(player,rarity,1,skill_number[1])
	players[player:GetTeamNumber()].choise[2] = find_skill(player,rarity,2,skill_number[2])
end 

  skill_number[3] = 0
  players[player:GetTeamNumber()].choise[3] = find_skill(player,rarity,3,skill_number[3])

end

local b = nil
local mod_stacks = {}

if rarity == 1 and player:HasModifier("modifier_up_grayfour") then 
	players[player:GetTeamNumber()].choise[4] = find_skill(player,1,4,5)
end

local refresh = false

if can_refresh == nil then 
	if rarity == 3 and player:HasModifier("modifier_up_purplepoints") then 
		refresh = true
	end
end

if #players[player:GetTeamNumber()].choise == 4 then
		l = 1 else l = 0 end

for i = 1,3+l do
		mod_stacks[i] = 0
		b = player:FindModifierByName(players[player:GetTeamNumber()].choise[i][1])
		if b then mod_stacks[i] = b:GetStackCount() end

		if players[player:GetTeamNumber()].choise[i][2] == 2 then 
			b = towers[player:GetTeamNumber()]:FindModifierByName(players[player:GetTeamNumber()].choise[i][1])
			if b then mod_stacks[i] = b:GetStackCount() end
		end
end 

players[player:GetTeamNumber()].can_refresh_choise = refresh

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerID()) , 'show_choise', {choise = players[player:GetTeamNumber()].choise, mods = mod_stacks, legendary = l, hasup = players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints") , refresh = refresh})
	
players[player:GetTeamNumber()].choise_table = 
{
	players[player:GetTeamNumber()].choise,
	false,
	players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"),
	mod_stacks,
	0,
	refresh
}


 b = nil
 mod_stacks = {}
end

function upgrade:make_choise( kv )


	local hero = PlayerResource:GetSelectedHeroEntity(kv.PlayerID)
	
	if hero == nil then return end

	if players[hero:GetTeamNumber()] == nil then return end

	if IsEmpty(players[hero:GetTeamNumber()].choise) then return end

	players[hero:GetTeamNumber()].IsChoosing = false
	players[hero:GetTeamNumber()].choise_table = {}
	players[hero:GetTeamNumber()].can_refresh_choise = false 

	local skill = players[hero:GetTeamNumber()].choise[kv.chosen]


	if skill == nil then return end

	if (skill[4] == "orange") and (players[hero:GetTeamNumber()].chosen_skill == 0) then 
		players[hero:GetTeamNumber()].chosen_skill = skill[10]

    	Server_data[players[hero:GetTeamNumber()]:GetPlayerID()].orange_talent = skill[7]
	end

	

	if skill[4] == "orange" or skill[4] == "purple" then 
		CustomGameEventManager:Send_ServerToAllClients('show_skill_event', {hero = hero:GetUnitName(), skill = skill })
	end


local mod = hero:FindModifierByName("using_item")
if mod then
mod:Destroy()
end


if skill[2] == 2 then
	towers[hero:GetTeamNumber()]:AddNewModifier(hero, nil, tostring(skill[1]) , {})
else
	if hero:IsAlive() then 
		hero:AddNewModifier(hero, nil, tostring(skill[1]) , {})
	else
		players[hero:GetTeamNumber()].respawn_mod = tostring(skill[1])
	end	
	if players[hero:GetTeamNumber()].upgrades[tostring(skill[1])] ~= nil then 
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][1] = tostring(skill[1])	
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][2] = hero:FindModifierByName(skill[1]):GetStackCount()
	else 	
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])] = {}
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][1] = tostring(skill[1])
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][2] = 1
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][3] = tostring(skill[4])
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][4] = skill[5]
		players[hero:GetTeamNumber()].upgrades[tostring(skill[1])][5] = skill[9]
	end
end

CustomNetTables:SetTableValue("upgrades_player", hero:GetUnitName(), {upgrades = players[hero:GetTeamNumber()].upgrades, max = #players[hero:GetTeamNumber()].upgrades, hasup = hero:HasModifier("modifier_up_graypoints")})

players[hero:GetTeamNumber()].choise = {}
end	


function IsEmpty(t)
for _,i in pairs(t) do 
	return false
end
return true
end


function upgrade:refresh_sphere( kv )
local hero = PlayerResource:GetSelectedHeroEntity(kv.PlayerID)

if players[hero:GetTeamNumber()] == nil then return end
if IsEmpty(players[hero:GetTeamNumber()].choise) then return end

if not players[hero:GetTeamNumber()].can_refresh_choise then return end

players[hero:GetTeamNumber()].can_refresh_choise = false 

players[hero:GetTeamNumber()].choise = {}

upgrade:init_upgrade(hero,3,false)


end	




upgrade:InitGameMode()