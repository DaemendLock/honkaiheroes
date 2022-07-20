honkai_beast= class({})
LinkLuaModifier( "modifier_honkai_beast", "honkai/honkai_beast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function honkai_beast:GetIntrinsicModifierName()
	return "modifier_honkai_beast"
end


modifier_honkai_beast= class({})

function modifier_honkai_beast:IsHiden()
	return false
end

function modifier_honkai_beast:IsDebuff()
	return false
end

function modifier_honkai_beast:IsPurgable()
	return false
end

function modifier_honkai_beast:OnCreated()
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.damage_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
	self.spreadtime = self:GetAbility():GetSpecialValueFor("spread_time")
	
	self:StartIntervalThink( self.spreadtime )
end

function modifier_honkai_beast:DeclareFunctions()
	return  {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_BONUSDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS	
			}
end

function modifier_honkai_beast:OnIntervalThink()
	local creeps = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
									self:GetParent():GetOrigin(),
									nil,
									self:GetAbility():GetSpecialValueFor("spread_radius"),
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_CREEP,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER ,
									false
									)
	for _, creep in pairs(creeps) do
		if creep ~= self:GetCaster() and creep ~= self:GetParent() and not creep:HasModifier("modifier_honkai_beast") then
		creep:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_honkai_beast", {})
		end
	end
end

function modifier_honkai_beast:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end

function modifier_honkai_beast:GetModifierBonusDamageOutgoing_Percentage()
	return self.damage_pct
end
function modifier_honkai_beast:GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_honkai_beast:GetModifierHealthBonus()
	return self.hp
end

modifier_ai = class({})

local AI_STATE_IDLE = 0
local AI_STATE_AGGRESSIVE = 1
local AI_STATE_RETURNING = 2

local AI_THINK_INTERVAL = 0.5

function modifier_ai:OnCreated(params)
    -- Only do AI on server
    if IsServer() then
        -- Set initial state
        self.state = AI_STATE_IDLE

        -- Store parameters from AI creation:
        -- unit:AddNewModifier(caster, ability, "modifier_ai", { aggroRange = X, leashRange = Y })
        self.aggroRange = params.aggroRange
        self.leashRange = params.leashRange

        -- Store unit handle so we don't have to call self:GetParent() every time
        self.unit = self:GetParent()

        -- Set state -> action mapping
        self.stateActions = {
            [AI_STATE_IDLE] = self.IdleThink,
            [AI_STATE_AGGRESSIVE] = self.AggressiveThink,
            [AI_STATE_RETURNING] = self.ReturningThink,
        }

        -- Start thinking
        self:StartIntervalThink(AI_THINK_INTERVAL)
    end
end

function modifier_ai:OnIntervalThink()
    -- Execute action corresponding to the current state
    self.stateActions[self.state](self)    
end

function modifier_ai:IdleThink()
    -- Find any enemy units around the AI unit inside the aggroRange
    local units = FindUnitsInRadius(self.unit:GetTeam(), self.unit:GetAbsOrigin(), nil,
        self.aggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false)

    -- If one or more units were found, start attacking the first one
    if #units > 0 then
        self.spawnPos = self.unit:GetAbsOrigin() -- Remember position to return to
        self.aggroTarget = units[1] -- Remember who to attack
        self.unit:MoveToTargetToAttack(self.aggroTarget) --Start attacking
        self.state = AI_STATE_AGGRESSIVE --State transition
        return -- Stop processing this state
    end

    -- Nothing else to do in Idle state
end

function modifier_ai:AggressiveThink()
    -- Check if the unit has walked outside its leash range
    if (self.spawnPos - self.unit:GetAbsOrigin()):Length() > self.leashRange then
        self.unit:MoveToPosition(self.spawnPos) --Move back to the spawnpoint
        self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
        return -- Stop processing this state
    end
    
    -- Check if the target has died
    if not self.aggroTarget:IsAlive() then
        self.unit:MoveToPosition(self.spawnPos) --Move back to the spawnpoint
        self.state = AI_STATE_RETURNING --Transition the state to the 'Returning' state(!)
        return -- Stop processing this state
    end
    
    -- Still in the aggressive state, so do some aggressive stuff.
    self.unit:MoveToTargetToAttack(self.aggroTarget)
end

function modifier_ai:ReturningThink()
    -- Check if the AI unit has reached its spawn location yet
    if (self.spawnPos - self.unit:GetAbsOrigin()):Length() < 10 then
        self.state = AI_STATE_IDLE -- Transition the state to the 'Idle' state(!)
        return -- Stop processing this state
    end

    -- If not at return position yet, try to move there again
    self.unit:MoveToPosition(self.spawnPos)
end