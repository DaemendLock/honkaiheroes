modifier_elf = class({})

function modifier_elf:IsPermanent()
	return true
end

function modifier_elf:IsDebuff()
	return false
end

function modifier_elf:RemoveOnDeath()
	return false
end

function modifier_elf:IsHiden()
	return true
end

function modifier_elf.OnCreated(self)
    if IsServer() then
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_elf:OnRemoved()
	if IsServer() then
        self:GetParent():SetUnitCanRespawn(false)
		self:GetParent():ForceKill(false)
    end
	
	
end

function modifier_elf:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_RESPAWNTIME
	}
	return funcs
end

function modifier_elf:GetModifierConstantRespawnTime()
	return 20
end
function modifier_elf:OnIntervalThink()
	local elf = self:GetParent()
	local owner = self:GetCaster()
	while owner:GetLevel() > elf:GetLevel() do
		elf:CreatureLevelUp(1)
	end
end

ult_cd = class({})