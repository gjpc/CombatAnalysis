
--[[
	
	Mimicks (ie: implements the same interface as) the Turbine API Effect class
	so that recorded debuff/CC information can be sent to Buffbars.
	
]]

_G.CombatAnalysisEffect = class();

function CombatAnalysisEffect:Constructor(effectName,effectIcon,isDebuff,targetName,startTime,duration)
	self.effectName = effectName;
	self.effectIcon = effectIcon;
	
	self.isDebuff = isDebuff;
	
	self.targetName = targetName;
	
	self.startTime = startTime;
	self.duration = duration;
end

function CombatAnalysisEffect:GetName()
	return self.effectName;
end

function CombatAnalysisEffect:GetIcon()
	return self.effectIcon;
end

function CombatAnalysisEffect:GetTargetName()
	return self.targetName;
end

function CombatAnalysisEffect:GetStartTime()
	return self.startTime;
end

function CombatAnalysisEffect:GetDuration()
	return (self.duration == nil and 3.4028234663853e+038 or self.duration);
end

function CombatAnalysisEffect:GetCategory()
	if (self.isDebuff) then
		return CombatAnalysisEffectCategory.Debuff;
	else
		return CombatAnalysisEffectCategory.CrowdControl;
	end
end

function CombatAnalysisEffect:GetDescription()
	return "No Description";
end

function CombatAnalysisEffect:GetID()
	return 0;
end

function CombatAnalysisEffect:IsDebuff()
	return self.isDebuff;
end

function CombatAnalysisEffect:IsCurable()
	return false;
end

function CombatAnalysisEffect:IsDispellable()
	return false;
end
