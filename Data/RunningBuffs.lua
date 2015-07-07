
--[[

The Running Buffs class contains all data
relating to running buffs.

These buffs may be active when combat
begins.

]]--

_G.RunningBuffs = class();

function RunningBuffs:Constructor()
	self.buffs = {};
end

function RunningBuffs:Applied(targetName,effect,names)
	if (self.buffs[targetName] == nil) then
		self.buffs[targetName] = {};
	end
	
	self.buffs[targetName][effect] = names;
end

function RunningBuffs:Terminated(targetName,effect)
	if (self.buffs[targetName] == nil or self.buffs[targetName][effect] == nil) then return end

	self.buffs[targetName][effect] = nil;
	-- clean up table
	if (next(self.buffs[targetName]) == nil) then self.buffs[targetName] = nil end
end

function RunningBuffs:ToString()
	local msg = "Buffs List:\n";
	if (self.buffs[player.name] ~= nil) then
		for effect,_ in pairs(self.buffs[player.name]) do
			msg = msg.." > "..effect:GetName().."\n";
		end
	end
	return msg;
end