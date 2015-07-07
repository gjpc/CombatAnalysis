
--[[ A Power Restore Combat Element ]]--

_G.Power = class(RestoreCombatElement);

function Power:Constructor(timestamp,targetName,initiatorName,skillName,amount,critical)
	RestoreCombatElement.Constructor(self,timestamp,targetName,initiatorName,skillName,amount,critical);
end

-- Convert a combat element into a summarized string
function Power:ShortString()
	return L[Power][1]..","..timestamp..","..targetName..","..initiatorName..","..skillName..","..amount..","..critical;
end
