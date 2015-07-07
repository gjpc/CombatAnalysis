
--[[ A Heal Combat Element ]]--

_G.Heal = class(RestoreCombatElement);

function Heal:Constructor(timestamp,targetName,initiatorName,skillName,amount,critical)
	RestoreCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName,amount,critical);
end

-- Convert a combat element into a summarized string
function Heal:ShortString()
	return L[Heal][1]..","..timestamp..","..targetName..","..initiatorName..","..skillName..","..amount..","..critical;
end
