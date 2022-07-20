if GameSetup == nil then
  GameSetup = class({})
end


_G.honkai_debuff_max_stack = 20
_G.honkai_debuff_bonus_armor = 5
_G.honkai_debuff_bonus_movement_speed = -10
_G.honkai_debuff_damage = 5
_G.honkai_debuff_dot_stack = 10
_G.honkai_damage_type = DAMAGE_TYPE_PURE

function GameSetup:init()
    GameRules:SetShowcaseTime(0)
    
    if IsInToolsMode() then  --debug build
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS,  16 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS,   5 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1,  4 )
    --skip all the starting game mode stages e.g picking screen, showcase, etc
	
    --GameRules:EnableCustomGameSetupAutoLaunch(true)
    --GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    GameRules:SetHeroSelectionTime(20)
    GameRules:SetStrategyTime(0)
   -- GameRules:SetPreGameTime(1)
    
    GameRules:SetPostGameTime(5)
    GameRules:SetStartingGold(99999)
    --disable some setting which are annoying then testing
    --local GameMode = GameRules:GetGameModeEntity()
    --GameMode:SetAnnouncerDisabled(true)
    --GameMode:SetKillingSpreeAnnouncerDisabled(true)
    --GameMode:DisableHudFlip(true)
    --GameMode:SetWeatherEffectsDisabled(true)

    --disable music events


    --multiple players can pick the same hero
    GameRules:SetSameHeroSelectionEnabled(true)

    else --release build
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS,  16 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS,   0 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1,  4 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2,  4 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3,  4 )
        GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4,  4 )
        GameRules:SetGoldPerTick(0)
        GameRules:SetStartingGold(90000)
        GameRules:SetHeroSelectionTime(60)
        GameRules:SetCustomGameAllowBattleMusic(false)
        GameRules:SetCustomGameBansPerTeam(0)
        GameRules:SetCustomVictoryMessage("YOU PROTECTED HUMANITY... FOR A WHILE")
        GameRules:SetHideKillMessageHeaders(true)
        GameRules:SetHeroRespawnEnabled(false)
        GameRules:SetHeroSelectPenaltyTime(0)
        GameRules:SetSameHeroSelectionEnabled(false)
        GameRules:SetStrategyTime(0)
        GameRules:SetTreeRegrowTime(600)
        GameRules:SetUseUniversalShopMode(true)
    end
  
  
end




