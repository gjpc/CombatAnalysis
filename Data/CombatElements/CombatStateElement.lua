
--[[

The Abstract Base Class for Combat State Change Elements.

This includes only combat entry and exit events.

]]--

_G.CombatStateElement = abstract_class(CombatElement);

function CombatStateElement:Constructor(timestamp,initiatorName)
	CombatElement.Constructor(self,initiatorName);
end
