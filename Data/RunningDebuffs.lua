
--[[

The Running Debuffs class contains all data
relating to running debuffs.

These debuffs may be active when combat
begins.

]]--

_G.RunningDebuffs = class(Turbine.UI.Control);

function RunningDebuffs:Constructor()
	Turbine.UI.Control.Constructor(self);
	
	self.debuffs = {}
	self.toggles = {}
	self.crowdControl = {}
	self.expirations = OrderedList();
end

function RunningDebuffs:Applied(timestamp,targetName,skillName,duration,isDebuff,icon,initiatorName,showInBuffBars)
	local effect = CombatAnalysisEffect(skillName,icon,(isDebuff and skillName ~= L.StunImmunity),targetName,timestamp,duration);
	if (isDebuff) then
		if (self.debuffs[targetName] ~= nil and self.debuffs[targetName][skillName] ~= nil) then self:Terminated(timestamp,targetName,skillName) end
		if (self.debuffs[targetName] == nil) then self.debuffs[targetName] = {} end
		self.debuffs[targetName][skillName] = {timestamp,duration,effect,initiatorName};
	else
		self.crowdControl[targetName] = {skillName,effect,timestamp+duration,initiatorName};
	end
	
	-- Send effect added info to Buffbars
	if (buffBarsLoaded and showInBuffBars) then PengorosPlugins.Utils.EffectManager.AddEffect(effect) end
	
	-- if this is a toggle skill (no duration specified), add it to the toggles list
	if (duration == nil) then
		self.toggles[skillName] = targetName;
	else
		self.expirations:Add(timestamp+duration,{targetName,skillName,effect,initiatorName});
		self:SetWantsUpdates(true);
	end
end

function RunningDebuffs:Terminated(timestamp,targetName,skillName,isDebuff)
	-- if no skill name is specified, then terminate all debuffs on the target
	if (skillName == nil) then
		-- terminate all debuffs
		if (self.debuffs[targetName] ~= nil) then
			for sName,skillInfo in pairs(self.debuffs[targetName]) do
				if (skillInfo[2] == nil) then
					self.toggles[sName] = nil;
				else
					self.expirations:Remove(skillInfo[1]+skillInfo[2],{targetName,sName,skillInfo[3],skillInfo[4]});
				end
				-- Send effect removed info to Buffbars
				if (buffBarsLoaded) then PengorosPlugins.Utils.EffectManager.RemoveEffect(skillInfo[3]) end
			end
			
			self.debuffs[targetName] = nil;
		end
		
		-- terminate any crowd control debuff on target
		if (self.crowdControl[targetName] ~= nil) then
			if (buffBarsLoaded) then PengorosPlugins.Utils.EffectManager.RemoveEffect(self.crowdControl[targetName][2]) end
			
			local skillInfo = self.crowdControl[targetName];
			self.expirations:Remove(skillInfo[3],{targetName,skillInfo[1],skillInfo[2],skillInfo[4]});
			
			self.crowdControl[targetName] = nil;
		end
		
		return false;
	end
	
	-- otherwise, terminate the specified debuff
	if ((isDebuff == nil or isDebuff == true) and self.debuffs[targetName] ~= nil and self.debuffs[targetName][skillName] ~= nil) then
		-- if this is was an active toggle skill, remove it from the toggles list
		if (self.debuffs[targetName][skillName][2] == nil) then
			self.toggles[skillName] = nil;
		end
		
		-- Send effect removed info to Buffbars
		if (buffBarsLoaded) then PengorosPlugins.Utils.EffectManager.RemoveEffect(self.debuffs[targetName][skillName][3]) end
		
		local skillInfo = self.debuffs[targetName][skillName];
		if (skillInfo[2] ~= nil) then self.expirations:Remove(skillInfo[1]+skillInfo[2],{targetName,skillName,skillInfo[3],skillInfo[4]}) end
		
		self.debuffs[targetName][skillName] = nil;
		-- clean up table
		if next(self.debuffs[targetName]) == nil then self.debuffs[targetName] = nil end
		
		return true;
	end
	
	-- or crowd control debuff
	if ((isDebuff == nil or isDebuff == false) and self.crowdControl[targetName] ~= nil and self.crowdControl[targetName][1] == skillName) then
		if (buffBarsLoaded) then PengorosPlugins.Utils.EffectManager.RemoveEffect(self.crowdControl[targetName][2]) end
		
		local skillInfo = self.crowdControl[targetName];
		self.expirations:Remove(skillInfo[3],{targetName,skillName,skillInfo[2],skillInfo[4]});
		
		self.crowdControl[targetName] = nil;
		
		return true;
	end
end

function RunningDebuffs:Clear(timestamp)
	-- Send effect removed info to Buffbars
	if (buffBarsLoaded) then 
		for targetName,debuffInfo in pairs(self.debuffs) do
			for sName,skillInfo in pairs(self.debuffs[targetName]) do
				PengorosPlugins.Utils.EffectManager.RemoveEffect(skillInfo[3]);
			end
		end
		
		for targetName,skillInfo in pairs(self.crowdControl) do
			PengorosPlugins.Utils.EffectManager.RemoveEffect(skillInfo[2]);
		end
	end
	
	-- Clear all debuffs
	self.debuffs = {}
	self.toggles = {}
	self.crowdControl = {}
	self.expirations:Clear();
	self:SetWantsUpdates(false);
end

function RunningDebuffs:Update()
	local timestamp = Turbine.Engine.GetGameTime();
	
	while true do
		-- if there are no running (timed) debuffs we can stop checking for terminated debuffs
		if (#self.expirations.list == 0) then
			self:SetWantsUpdates(false);
			break;
		end
		
		if (self.expirations.list[1][1] <= timestamp) then
			local endTime = self.expirations.list[1][1];
			local targetName = self.expirations.list[1][2][1];
			local skillName = self.expirations.list[1][2][2];
			local effect = self.expirations.list[1][2][3];
			local initiatorName = self.expirations.list[1][2][4];
			
			local isStun = (skillName == L.Stun or skillName == L.Knockdown);
			
			if (not self:Terminated(endTime,targetName,skillName)) then
				if (buffBarsLoaded) then PengorosPlugins.Utils.EffectManager.RemoveEffect(effect) end
				self.expirations:Remove(endTime,{targetName,skillName,effect,initiatorName});
			end
			
      -- apply stun immunity after a stun/knockdown
			if (isStun and
            (not combatData.inCombat or
              (not combatData.currentEncounter.orderedMobs[1].terminated and
              (mobIndex == nil or combatData.currentEncounter.orderedMobs[mobIndex[1]].alive or mobIndex[2]))
            )) then
        self:Applied(endTime,targetName,L.StunImmunity,10,true,"CombatAnalysis/Resources/DebuffIcons/cc_stun_immunity.tga",initiatorName);
      end
		else
			break;
		end
	end
end

function RunningDebuffs:ToString()
	local t = Turbine.Engine.GetGameTime();
	
	local msg = "Debuffs List:\n";
	for targetName,targetDebuffs in pairs(self.debuffs) do
		for skillName,debuffInfo in pairs(targetDebuffs) do
			msg = msg.." > ["..targetName.."] "..skillName.." ("..(debuffInfo[2] == nil and "toggle" or debuffInfo[2]-(t-debuffInfo[1]))..")\n";
		end
	end
	return msg;
end