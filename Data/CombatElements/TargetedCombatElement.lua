
--[[

The Abstract Base Class for all Targeted Combat Elements.

This includes attacks, restores, and other
kind of events such as interrupts, and
corruption removals, etc.

All Targeted Combat Elements include a target.

]]--

_G.TargetedCombatElement = abstract_class(CombatElement);

function TargetedCombatElement:Constructor(timestamp,targetName,initiatorName)
	CombatElement.Constructor(self,timestamp,initiatorName);
	
	self.targetName = targetName;
end
