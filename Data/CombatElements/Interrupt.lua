
--[[ An Interrupt Combat Element ]]--

_G.Interrupt = class(TargetedCombatElement);

function Interrupt:Constructor(timestamp,targetName,initiatorName)
	TargetedCombatElement.Constructor(self,timestamp,targetName,initiatorName);
end

-- Convert a combat element into a summarized string
function Interrupt:ShortString()
	return L[Interrupt][1]..","..timestamp..","..targetName..","..initiatorName;
end
