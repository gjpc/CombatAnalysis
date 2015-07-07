
--[[ A Corruption Combat Element ]]--

_G.Corruption = class(TargetedCombatElement);

function Corruption:Constructor(timestamp,targetName,initiatorName)
	TargetedCombatElement.Constructor(self,timestamp,targetName,initiatorName);
end

-- Convert a combat element into a summarized string
function Corruption:ShortString()
	return L[Corruption][1]..","..timestamp..","..targetName..","..initiatorName;
end
