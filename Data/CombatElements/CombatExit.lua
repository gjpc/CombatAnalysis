
--[[ A Combat Exit Element ]]--

_G.CombatExit = class(CombatStateElement);

function CombatExit:Constructor(timestamp,initiatorName)
	CombatStateElement.Constructor(self,timestamp,initiatorName);
end

-- Convert a combat element into a summarized string
function CombatExit:ShortString()
	return L[CombatExited][1]..","..timestamp..","..initiatorName;
end
