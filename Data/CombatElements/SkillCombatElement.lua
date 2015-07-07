
--[[

The Abstract Base Class for all Skill Use Combat Elements.

This includes attacks, restores, buffs & debuffs. All Skill
Use Combat Elements include the skill name.

]]--

_G.SkillCombatElement = abstract_class(TargetedCombatElement);

function SkillCombatElement:Constructor(timestamp,targetName,initiatorName,skillName)
	TargetedCombatElement.Constructor(self,timestamp,targetName,initiatorName);
	
	self.skillName = skillName;
end
