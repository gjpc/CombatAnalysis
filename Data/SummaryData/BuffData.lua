
--[[

Buff Summary Data.

This includes summary information for a
buff/debuff.

A Buff Summary Data consists of a duration:
the amount of time with which the buff/debuff
was active.

]]--

_G.BuffData = class(SummaryData);

function BuffData:Constructor(terminated,dontRecordApplications)
	SummaryData.Constructor(self);
	
	if (not dontRecordApplications) then self.applications = 0 end
	
	self.buffInfo = {};
	
	self.duration = 0;   -- total duration not including time since durStart
	self.durStart = 0;   -- the timestamp from when a string of consecutive buffs have remained on the target
	
	self.oldDuration = 0;
	self.oldDurStart = 0;
	
	self.terminated = terminated;
	self.terminatedTime = 0;
end

function BuffData:Update(timestamp,effect,countAsApplication)
	self.empty = false;
	
	if (self.applications ~= nil and countAsApplication) then
		self.applications = self.applications + 1;
	end
	
	self.buffInfo[effect] = true;
	
	-- if the buff is not currently running, then start it running (ensure timers never overlap)
	if ((not self.terminated and self.durStart == 0) or (self.terminated and self.oldDurStart == 0)) then
		if (self.terminated) then
			self.oldDurStart = math.max(timestamp,self.terminatedTime);
		else
			self.durStart = math.max(timestamp,self.terminatedTime);
		end
	end
end

function BuffData:TerminateBuff(timestamp,effect)
	-- if the buff isn't on the restore, do nothing
	if (self.buffInfo[effect] == nil) then
		return false;
	end
	
	self.buffInfo[effect] = nil;
	
	-- for more accurate results, restrict the max time the effect was up for (with a sanity check)
	local latestEndTime = effect:GetStartTime()+effect:GetDuration();
	if (latestEndTime >= (timestamp-combatData.timer)) then timestamp = math.min(timestamp,latestEndTime) end
	
	-- determine if any buffs other than this are still running
	if (next(self.buffInfo) ~= nil) then
		timestamp = nil;
	end
	
	-- if there are no other buffs on the restore, set the buff duration accordingly, and clear the buff table
	if (timestamp ~= nil) then
		self.buffInfo[effect] = nil;
		
		if self.terminated then
			self.oldDuration = self.oldDuration + (timestamp-self.oldDurStart);
			self.oldDurStart = 0;
			-- due to the max time restriction above, there is a remote possibility that the duration may be reduced while terminated
			self.duration = math.min(self.duration,self.oldDuration);
		else
			self.duration = self.duration + (timestamp-self.durStart);
			self.durStart = 0;
		end
		self.terminatedTime = timestamp;
		self.buffInfo = {}
	end
	
	return true;
end

function BuffData:CombatEnded(timestamp)
	self.terminated = true;
	self.oldDuration = self.duration;
	self.oldDurStart = self.durStart;
	
	if (self.durStart == 0) then return {} end
	
	self.duration = self.duration + (timestamp-self.durStart);
	self.durStart = 0;
	self.terminatedTime = timestamp;
end

function BuffData:Reset()
	self.terminated = false;
	self.duration = self.oldDuration;
	self.durStart = self.oldDurStart;
end

-- when combat is finished (after the timer buffer so there is no possibility of resetting), clean up all references to effects
function BuffData:TerminateAll()
	self.buffInfo = {}
end

function BuffData:CurrentDuration(timestamp)
	return self.duration+(self.durStart == nil and 0 or (timestamp-self.durStart));
end

-- Note that when saving the state of buff data, currently running buffs are ignored (we only care about total current duration)

function BuffData:GetState(timestamp)
	local state = SummaryData.GetState(self);
	
	state["applications"] = self.applications;
	state["duration"] = self.duration+(self.durStart == 0 and 0 or (timestamp-self.durStart));
	
	return state;
end

function BuffData.CombineStates(state1,state2)
	SummaryData.CombineStates(state1,state2);
	
	if (state1["applications"] ~= nil or state2["applications"] ~= nil) then
		state1["applications"] = (state1["applications"] or 0) + (state2["applications"] or 0);
	end
	state1["duration"] = state1["duration"] + state2["duration"];
end

function BuffData.RestoreState(state)
	local buffData = BuffData(true,(state["applications"] == nil));
	buffData.empty = false;
	
	buffData.applications = state["applications"];
	buffData.duration = state["duration"];
	buffData.oldDuration = buffData.duration;
	
	return buffData;
end
