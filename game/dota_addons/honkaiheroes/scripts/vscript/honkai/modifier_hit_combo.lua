modifier_hit_combo = class({})

function modifier_hit_combo:OnCreated(kv)
	self:SetStackCount(0)
	self:GetParent().combo_hit = self
end

function modifier_hit_combo:OnRefresh(kv)
if kv.hits then
	self:SetStackCount(self:GetStackCount()+kv.hits)
	end
end

function modifier_hit_combo:DestroyOnExpire()
	return false
end

function modifier_hit_combo:RemoveOnDeath()
	return false
end

function modifier_hit_combo:IsHidden()
	return false
	--return self:GetStackCount()==0
end

function modifier_hit_combo:DeclareFunctions()
	return{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_hit_combo:OnAttackLanded(event)
	if event.attacker == self:GetParent() then
	--and event.fail_type == DOTA_ATTACK_RECORD_FAIL_NO then
		self:IncrementStackCount()
		self:SetDuration(self:GetDuration(), true)
		self:StartIntervalThink(self:GetDuration())
	end
end
function modifier_hit_combo:OnIntervalThink()
	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end