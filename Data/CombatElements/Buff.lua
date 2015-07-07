
--[[ A Buff Combat Element ]]--

_G.Buff = class(SkillCombatElement);

function Buff:Constructor(timestamp,targetName,initiatorName,skillName)
	SkillCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName);
end

-- Convert a combat element into a summarized string
function Buff:ShortString()
	return L[Buff][1]..","..timestamp..","..targetName..","..initiatorName..","..skillName;
end
