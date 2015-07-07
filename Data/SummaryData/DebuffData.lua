
--[[

Debuff Summary Data.

This includes summary information for a
debuff.

A Debuff Summary Data consists of a duration:
the amount of time with which the buff/debuff
was active.

Note that debuffs are recorded via the combat
log so buff termination is usually computed
via a buffDuration timer (how long the buff
is expected to last). This value is overridden
when another debuff overriddes the current one,
or the relevant mob(s) die.

]]--

_G.DebuffData = class(SummaryData);

function DebuffData:Constructor()
	SummaryData.Constructor(self);
	
	self.debuffInfo = {};
	
	self.applications = 0; -- the number of time a debuff has been applied to the target
	self.duration = 0;     -- total duration not including time since durStart
	self.durStart = 0;     -- the timestamp from when a string of consecutive debuffs have remained on the target
	
  self.oldDuration = 0;
	self.oldDurStart = 0;
	
	self.terminated = false;
	self.terminatedTime = 0;
end

function DebuffData:Update(timestamp,mobIsAlive,skillName,targetName,debuffDuration)
	self.empty = false;
	self.applications = self.applications + 1;
	
	-- only alter durations if the mob is still alive
	if (mobIsAlive) then
		-- NB: assume all tracked debuffs are non-stacking (with themselves); they will get automatically overwritten
		self:TerminateDebuff(timestamp,skillName,targetName)
		
		if (self.debuffInfo[targetName] == nil) then self.debuffInfo[targetName] = {} end
		
		self.debuffInfo[targetName][skillName] = {timestamp,debuffDuration};
		if ((not self.terminated and self.durStart == nil) or (self.terminated and self.oldDurStart == nil)) then
			if (self.terminated) then
        self.oldDurStart = math.max(timestamp,self.terminatedTime);
      else
        self.durStart = math.max(timestamp,self.terminatedTime);
      end
		end
	end
end

function DebuffData:TerminateDebuff(timestamp,skillName,targetName)
	-- if the debuff isn't on any targets, do nothing
	if (self.debuffInfo[targetName] == nil or self.debuffInfo[targetName][skillName] == nil) then
		return false;
	end
	local maxTimestamp = (self.debuffInfo[targetName][skillName][2] and math.min(timestamp,self.debuffInfo[targetName][skillName][1]+self.debuffInfo[targetName][skillName][2]) or timestamp);
	
	-- terminate the specified debuff
	self.debuffInfo[targetName][skillName] = nil;
	if (next(self.debuffInfo[targetName]) == nil) then self.debuffInfo[targetName] = nil end
	
	local timedOutDebuffs = {}
	-- determine if any other debuffs are still running
	for t,targetInfo in pairs(self.debuffInfo) do
		for s,debuffInfo in pairs(targetInfo) do
			if (debuffInfo[2] == nil or (debuffInfo[1]+debuffInfo[2] > maxTimestamp)) then
				maxTimestamp = nil;
				break;
			else
				table.insert(timedOutDebuffs,{t,s});
			end
		end
		
		if (maxTimestamp == nil) then break end
	end
	
	-- if all other debuffs have timed out (or there are none), set the debuff duration accordingly, and clear the debuff table
	if (maxTimestamp ~= nil) then
    if (self.terminated) then
      self.oldDuration = self.oldDuration + math.max(0,(maxTimestamp-self.oldDurStart));
			self.oldDurStart = 0;
    else
      self.duration = self.duration + math.max(0,(maxTimestamp-self.durStart));
      self.durStart = 0;
    end
    self.terminatedTime = maxTimestamp;
    self.debuffInfo = {}
	-- clear any timed out debuffs to ensure minimal processing time
	else
		for _,debuffInfo in ipairs(timedOutDebuffs) do
			self.debuffInfo[debuffInfo[1]][debuffInfo[2]] = nil;
			if (next(self.debuffInfo[debuffInfo[1]]) == nil) then self.debuffInfo[debuffInfo[1]] = nil end
		end
	end
	
	return true;
end

function DebuffData:TerminateAll(timestamp,targetName)
	-- if there are no debuffs on the target, do nothing
	if (self.debuffInfo[targetName] == nil) then
		return false;
	end
	
	local maxTimestamp = 0;
	for skillName,debuffInfo in pairs(self.debuffInfo[targetName]) do
		maxTimestamp = math.max(maxTimestamp,(debuffInfo[2] and math.min(timestamp,debuffInfo[1]+debuffInfo[2]) or timestamp));
	end
	
	-- terminate the debuffs on the specified target
	self.debuffInfo[targetName] = nil;
	
	local timedOutDebuffs = {}
	-- determine if any other debuffs are still running
	for t,targetInfo in pairs(self.debuffInfo) do
		for s,debuffInfo in pairs(targetInfo) do
			if (debuffInfo[2] == nil or (debuffInfo[1]+debuffInfo[2] > maxTimestamp)) then
				maxTimestamp = nil;
				break;
			else
				table.insert(timedOutDebuffs,{t,s});
			end
		end
		
		if (maxTimestamp == nil) then break end
	end
	
	-- if all other debuffs have timed out (or there are none), set the debuff duration accordingly, and clear the debuff table
	if (maxTimestamp ~= nil) then
		if (self.terminated) then
      self.oldDuration = self.oldDuration + math.max(0,(maxTimestamp-self.oldDurStart));
			self.oldDurStart = 0;
    else
      self.duration = self.duration + math.max(0,(maxTimestamp-self.durStart));
      self.durStart = 0;
    end
    self.terminatedTime = maxTimestamp;
    self.debuffInfo = {}
	-- clear any timed out debuffs to ensure minimal processing time
	else
		for _,debuffInfo in ipairs(timedOutDebuffs) do
			self.debuffInfo[debuffInfo[1]][debuffInfo[2]] = nil;
			if (next(self.debuffInfo[debuffInfo[1]]) == nil) then self.debuffInfo[debuffInfo[1]] = nil end
		end
	end
	
	return true;
end

function DebuffData:CurrentDuration(timestamp)
	if (self.terminated and self.oldDurStart == 0) then return self.duration end
  if (not self.terminated and self.durStart == 0) then return self.duration end
	
	local maxTimestamp = nil;
	
	local timedOutDebuffs = {}
	-- determine if any debuffs are still running
	for t,targetInfo in pairs(self.debuffInfo) do
		for s,debuffInfo in pairs(targetInfo) do
			-- debuff still running on target
			if (debuffInfo[2] == nil or (debuffInfo[1] + debuffInfo[2] > timestamp)) then
				maxTimestamp = nil;
				break;
			-- debuff has timed out
			else
				table.insert(timedOutDebuffs,{t,s});
				maxTimestamp = (maxTimestamp == nil and (debuffInfo[1]+debuffInfo[2]) or math.max(maxTimestamp,debuffInfo[1]+debuffInfo[2]));
			end
		end
		
		if (maxTimestamp == nil) then break end -- to ensure this function is O(1)
	end
	
	-- if all debuffs have timed out, set the debuff duration accordingly, and clear the debuff tables
	if (maxTimestamp ~= nil) then
		if (self.terminated) then
      self.oldDuration = self.oldDuration + math.max(0,(maxTimestamp-self.oldDurStart));
			self.oldDurStart = 0;
    else
      self.duration = self.duration + math.max(0,(maxTimestamp-self.durStart));
      self.durStart = 0;
    end
    self.terminatedTime = maxTimestamp;
    self.debuffInfo = {}
		
		return self.duration;
	-- clear any timed out debuffs to ensure minimal processing time
	else
		for _,debuffInfo in ipairs(timedOutDebuffs) do
			self.debuffInfo[debuffInfo[1]][debuffInfo[2]] = nil;
			if (next(self.debuffInfo[debuffInfo[1]]) == nil) then self.debuffInfo[debuffInfo[1]] = nil end
		end
	
		return self.duration+(self.durStart == nil and 0 or (timestamp-self.durStart));
	end
end

function DebuffData:CombatEnded(timestamp)
	self.terminated = true;
	self.oldDuration = self.duration;
	self.oldDurStart = self.durStart;
	
	if (self.durStart == 0) then return {} end
	
	self.duration = self.duration + (timestamp-self.durStart);
	self.durStart = 0;
	self.terminatedTime = timestamp;
end

function DebuffData:Reset()
	self.terminated = false;
	self.duration = self.oldDuration;
	self.durStart = self.oldDurStart;
end

-- Note that when saving the state of debuff data, currently running debuffs are ignored (we only care about total current duration)

function DebuffData:GetState(timestamp)
	local state = SummaryData.GetState(self);
	
	state["applications"] = self.applications;
	state["duration"] = self.duration+(self.durStart == 0 and 0 or (timestamp-self.durStart));
	
	return state;
end

function DebuffData.CombineStates(state1,state2)
	SummaryData.CombineStates(state1,state2);
	
	state1["applications"] = state1["applications"] + state2["applications"];
	state1["duration"] = state1["duration"] + state2["duration"];
end

function DebuffData.RestoreState(state)
	local debuffData = DebuffData();
	debuffData.empty = false;
	
	debuffData.applications = state["applications"];
	debuffData.duration = state["duration"];
	
	return debuffData;
end

