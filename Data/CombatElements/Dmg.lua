
--[[ A Damage Combat Element ]]--

_G.Dmg = class(DmgCombatElement);

function Dmg:Constructor(timestamp,targetName,initiatorName,skillName,amount,avoidance,critical,dmgType)
	DmgCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName,amount,avoidance,critical,dmgType);
end

-- Convert a combat element into a summarized string
function Dmg:ShortString()
	return L[Dmg][1]..","..timestamp..","..targetName..","..initiatorName..","..skillName..","..amount..","..avoidance..","..critical..","..dmgType;
end
