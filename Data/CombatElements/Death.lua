
--[[ A Death Event Element ]]--

_G.Death = class(CombatElement);

function Death:Constructor(timestamp,initiatorName)
	CombatElement.Constructor(self,timestamp,initiatorName);
end

-- Convert a combat element into a summarized string
function Death:ShortString()
	return L[Death][1]..","..timestamp..","..initiatorName;
end
