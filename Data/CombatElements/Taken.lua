
--[[ A Damage Taken Combat Element ]]--

_G.Taken = class(DmgCombatElement);

function Taken:Constructor(timestamp,targetName,initiatorName,skillName,amount,avoidance,critical,dmgType)
	DmgCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName,amount,avoidance,critical,dmgType);
end

-- Convert a combat element into a summarized string
function Taken:ShortString()
	return L[Taken][1]..","..timestamp..","..targetName..","..initiatorName..","..skillName..","..amount..","..avoidance..","..crtical..","..dmgType;
end
