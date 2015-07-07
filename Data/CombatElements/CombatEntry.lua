
--[[ A Combat Entry Element ]]--

_G.CombatEntry = class(CombatStateElement);

function CombatEntry:Constructor(timestamp,initiatorName,initiatedViaDmg)
	CombatStateElement.Constructor(self,timestamp,initiatorName);
	
	self.initiatedViaDmg = initiatedViaDmg;
end

-- Convert a combat element into a summarized string
function CombatEntry:ShortString()
	return L[CombatEntered][1]..","..timestamp..","..initiatorName;
end
