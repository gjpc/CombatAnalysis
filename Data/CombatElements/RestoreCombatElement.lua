
--[[

The Abstract Base Class for Restore Based Combat Elements.

This includes both incoming and outgoing heals, and power restores.

]]--

_G.RestoreCombatElement = abstract_class(StandardCombatElement);

function RestoreCombatElement:Constructor(timestamp,targetName,initiatorName,skillName,amount,critical)
	StandardCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName,amount,critical);
end
