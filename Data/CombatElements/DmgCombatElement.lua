
--[[

The Abstract Base Class for Damage Based Combat Elements.

This includes only damage attacks (dealt or received by a player).

All Damage Based Combat Elements can be avoided, and include a
damage type.

]]--

_G.DmgCombatElement = abstract_class(StandardCombatElement);

function DmgCombatElement:Constructor(timestamp,targetName,initiatorName,skillName,amount,avoidance,critical,dmgType)
	StandardCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName,amount,critical);
	
	self.avoidance = avoidance;
	--[[ Note: 1 = not avoided, 2 = miss, 3 = immune, 4 = resist,
	           5 = block, 6 = parry, 7 = evade,
						 8 = partial block, 9 = partial parry, 10 = partial evade ]]--
						 
	self.dmgType = dmgType;
end

function DmgCombatElement:GetAvoidanceShortString()
	return L[AvoidanceEnum][self.avoidance][1];
end

function DmgCombatElement:GetAvoidanceString()
	return L[AvoidanceEnum][self.avoidance][2];
end

function DmgCombatElement:GetDmgTypeShortString()
	return L[DmgTypeEnum][self.dmgType][1];
end

function DmgCombatElement:GetDmgTypeString()
	return L[DmgTypeEnum][self.dmgType][2];
end

function DmgCombatElement:WasFullyAvoided()
	return self.avoidance > 1 and self.avoidance < 8;
end

function DmgCombatElement:WasPartiallyAvoided()
	return self.avoidance > 7;
end

function DmgCombatElement:WasAtLeastPartiallyAvoided()
	return self.avoidance > 1;
end

function DmgCombatElement:WasAtLeastPartiallyPhysicallyAvoided()
	return self.avoidance > 4;
end

function DmgCombatElement:WasResisted()
	return self.avoidance == 4;
end

function DmgCombatElement:WasImmune()
	return self.avoidance == 3;
end

function DmgCombatElement:Missed()
	return self.avoidance == 2;
end
