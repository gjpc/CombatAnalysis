
--[[ A Revive Event Element ]]--

_G.Revive = class(CombatElement);

function Revive:Constructor(timestamp,initiatorName)
	CombatElement.Constructor(self,timestamp,initiatorName);
end

-- Convert a combat element into a summarized string
function Revive:ShortString()
	return L[Revive][1]..","..timestamp..","..initiatorName;
end
