modifier_puppet_key = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_puppet_key:IsHidden()
	return true
end

function modifier_puppet_key:IsDebuff()
	return false
end

function modifier_puppet_key:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_puppet_key:OnCreated( kv )
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if IsServer() then
		-- set controllable
		parent:SetTeam( caster:GetTeamNumber() )
		parent:SetOwner( caster )
		parent:SetControllableByPlayer( caster:GetPlayerOwnerID(), true )
	end
end

function modifier_puppet_key:OnRefresh( kv )
	
end

function modifier_puppet_key:CheckState()
	local state = {
		[MODIFIER_STATE_DOMINATED] = true,
	}

	return state
end






