
--[[

The Abstract Base Class for all Standard Combat Elements.

This includes only attacks and restores. All Standard
Combat Elements have a chance to achieve a critical and/or
devastating hit, and include an amount.

]]--

_G.StandardCombatElement = abstract_class(SkillCombatElement);

function StandardCombatElement:Constructor(timestamp,targetName,initiatorName,skillName,amount,critical)
	SkillCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName);
	
	self.amount = amount;
	self.critical = critical; --[[ Note: 1 = non-crit, 2 = crit, 3 = devastate ]]--
end

function StandardCombatElement:GetCriticalHitShortString()
	return L[CriticalEnum][self.critical][1];
end

function StandardCombatElement:GetCriticalHitString()
	return L[CriticalEnum][self.critical][2];
end

function StandardCombatElement:WasCritical()
	return self.criticalHit == 2;
end

function StandardCombatElement:WasDevastate()
	return self.criticalHit == 3;
end

function StandardCombatElement:WasCriticalOrDevastate()
	return self.criticalHit > 1;
end
