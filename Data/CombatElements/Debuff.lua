
--[[ A Debuff Combat Element ]]--

_G.Debuff = class(SkillCombatElement);

function Debuff:Constructor(timestamp,targetName,initiatorName,skillName)
	SkillCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName);
end

-- Convert a combat element into a summarized string
function Debuff:ShortString()
	return L[Debuff][1]..","..timestamp..","..targetName..","..initiatorName..","..skillName;
end
