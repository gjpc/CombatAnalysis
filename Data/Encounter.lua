
--[[

The Encounter class contains all summary data
relating to an Encounter.

Summary data is stored for each target-player-skill
combination (including totals).

]]--

_G.Encounter = class();

function Encounter:Constructor(isTotalsEncounter,startTime,gameStartTime)
	self.startTime = startTime;
	
	self.mobs = { [L.Totals] = {1,false} };
	self.orderedMobs = { Mob(gameStartTime,L.Totals) }
	self.restores = { [L.Totals] = 1 };
	self.deadRestores = {};
	self.orderedRestores = { Restore(gameStartTime,L.Totals) }
	
	self.pendingDeaths = {};
	
	if (isTotalsEncounter) then
		-- totals encounter always starts out of combat
		self.orderedMobs[1].terminated = true;
		self.orderedRestores[1].terminated = true;
		
		self.name = L.Totals;
		self.longName = self.name .. (self.startTime ~= nil and " ("..Misc.FormatTime(self.startTime)..")" or "");
		
		encountersComboBox:SetTotals(self.longName,self);
		fileSelectDialog:NotifyTotalsChanged(self.longName);
	elseif (isTotalsEncounter ~= nil) then
		self.name = L.CurrentEncounter;
		self.longName = self.name .. " ("..Misc.FormatTime(self.startTime)..")";
		
		encountersComboBox:AddItem(self.longName,self);
		-- select the new encounter if applicable
		if (autoSelectNewEncounters) then
			encountersComboBox:SelectLastItem();
		end
		
		fileSelectDialog:NotifyNewEncounter(self.longName);
	end
end

function Encounter:CombatStarted(isCurrentEncounter,timestamp)
	-- add/revive restore for player immediately
	if (self.deadRestores[player.name]) then
		self:RestoreRevived(timestamp,player.name);
		
	elseif (not self.restores[player.name]) then
		table.insert(self.orderedRestores,Restore(timestamp,player.name));
		self.restores[player.name] = #(self.orderedRestores);
		-- if this is the selected encounter, update restores comboBox
		if (combatData.selectedEncounter == self) then
			restoresComboBox:AddItem(player.name,self.orderedRestores[#self.orderedRestores]);
		end
	end
	
	-- take record of any currently running debuffs & buffs
	for t,targetInfo in pairs(combatData.runningDebuffs.debuffs) do
		for s,debuffInfo in pairs(targetInfo) do
			local durationRemaining = (debuffInfo[2] ~= nil and (debuffInfo[2]-(timestamp-debuffInfo[1])) or nil);
			if (debuffInfo[3] and debuffInfo[2] == nil or durationRemaining > 0) then
				self:Update(isCurrentEncounter,5,timestamp,t,player.name,s,nil,nil,debuffInfo[2] and durationRemaining or nil);
			end
		end
	end
	
	for t,targetInfo in pairs(combatData.runningBuffs.buffs) do
		for effect,skillNames in pairs(targetInfo) do
      for skillName,_ in pairs(skillNames) do
        self:Update(isCurrentEncounter,6,timestamp,t,player.name,(effect.stackName ~= nil and effect.stackName or skillName),effect,false);
      end
		end
	end
end

-- Determines the best name for this encounter; that is, the mob that took the most damage in the
--  encounter, or just "Encounter" if no mobs were present at all.
function Encounter:DetermineName()
	local maxDmg = -1;
	local bestName = L.Encounter;
	for i=2,#self.orderedMobs do
		if (maxDmg < 0 or (self.orderedMobs[i].players[1][1] ~= nil and self.orderedMobs[i].players[1][1].dmgData.amount >= maxDmg)) then
			maxDmg = (self.orderedMobs[i].players[1][1] == nil and 0 or self.orderedMobs[i].players[1][1].dmgData.amount);
			bestName = self.orderedMobs[i].mobName;
		end
	end
	
	self.name = bestName;
	self.longName = self.name .. " ("..Misc.FormatTime(self.startTime)..")";
end

function Encounter:Update(isCurrentEncounter,updateType,timestamp,targetName,playerName,skillName,var1,var2,var3,var4)
	if updateType == 1 or updateType == 2 or updateType == 5 or updateType == 7 or updateType == 8 or updateType == 13 then
		
		local mob = nil;
		local mobInfo = self.mobs[targetName];
		if (mobInfo == nil or (isCurrentEncounter and mobInfo[2])) then
			local startTime = timestamp;
			-- if this is the current encounter, check mob timers
			if (mobInfo) then
				local prevMob = self.orderedMobs[mobInfo[1]];
				startTime = (prevMob.finishTime > (timestamp-combatData.timer) and prevMob.deathTime or timestamp);
			end
			-- create mob
			mob = Mob(startTime,targetName);
			if (self.pendingDeaths[targetName] ~= nil) then mob.alive = false; mob.deathTime = timestamp; end
			if (self.orderedMobs[1].terminated) then mob.terminated = true end
			table.insert(self.orderedMobs,mob);
			self.mobs[targetName] = {#self.orderedMobs,false};
			-- if this is the selected encounter, update mobs comboBox
			if (combatData.selectedEncounter == self) then mobsComboBox:AddItem(targetName,mob) end
		else
			mob = self.orderedMobs[mobInfo[1]];
			
			-- if this is the totals encounter, check to see if this is a mob that was previously finished and whose timers need updating
			if (not isCurrentEncounter and mobInfo[2]) then
				-- check to see if we should restart the timer using the current timestamp, or use the death time
				mob.gameStartTime = (mob.finishTime > (timestamp-combatData.timer) and mob.deathTime or timestamp);
				-- also set the mob to alive, and reset the timers
				mob.alive = true;
				mob.deathTime = nil;
				mobInfo[2] = false;
				mob.finishTime = nil;
			end
		end
		
		if (updateType == 5) then
			-- in the special case of a debuff, we may need to take care of terminating a toggle skill on an alternative target
			if (var1 ~= nil and var2 ~= nil) then
				if (self.mobs[var1] ~= nil and not self.mobs[var1][2]) then
					local mobSummData = self.orderedMobs[self.mobs[var1][1]].players[playerName][var2];
					if (mobSummData ~= nil) then mobSummData.debuffData:TerminateDebuff(timestamp,var2,var1) end
				end
				mobSummData = self.orderedMobs[1].players[playerName][var2];
				if (mobSummData ~= nil) then mobSummData.debuffData:TerminateDebuff(timestamp,var2,var1) end
			end
			
			-- finally provide some target info to the mob (ie: the "totals" mob needs to know the target name, and the debuff shouldn't be recorded if mob terminated/not alive)
			var1 = targetName;
			var2 = (mob.alive and not mob.terminated);
		end
		
		mob:Update(updateType,timestamp,playerName,skillName,var1,var2,var3,var4);
		self.orderedMobs[1]:Update(updateType,timestamp,playerName,skillName,var1,var2,var3,var4);
		
	elseif updateType == 3 or updateType == 4 or updateType == 6 or updateType == 14 or updateType == 15 then
		
		if (self.restores[targetName] == nil) then
			-- check to see if this was a previously dead restore target, in which case we will assume the target must have been revived
			if (self.deadRestores[targetName] ~= nil) then
				self:RestoreRevived(timestamp,targetName);
				
			-- a new restore as expected
			else
				local newRestore = Restore(timestamp,targetName);
				if (self.orderedRestores[1].terminated) then
					newRestore.terminated = true;
				end
				table.insert(self.orderedRestores,newRestore);
				self.restores[targetName] = #self.orderedRestores;
				-- if this is the selected encounter, update restores comboBox
				if (combatData.selectedEncounter == self) then
					restoresComboBox:AddItem(self.orderedRestores[#self.orderedRestores].restoreName,self.orderedRestores[#self.orderedRestores]);
				end
			end
		end
		self.orderedRestores[self.restores[targetName]]:Update(updateType,timestamp,playerName,skillName,var1,var2,var3,var4);
		self.orderedRestores[1]:Update(updateType,timestamp,playerName,skillName,var1,var2,var3,var4);
		
	end
end

function Encounter:MobDied(timestamp,mobName,isCurrentEncounter)
	local mobInfo = self.mobs[mobName];
	if (mobInfo == nil) then return end
	local mob = self.orderedMobs[mobInfo[1]];
	
	if (mob.terminated) then
		mob.oldDuration = mob.oldDuration+(timestamp-mob.gameStartTime);
	else
		mob.duration = mob.duration+(timestamp-mob.gameStartTime);
	end
	mob.alive = false;
	mob.deathTime = timestamp;
end

function Encounter:RestoreDied(timestamp,restoreName)
	local index = self.restores[restoreName];
	if (index == nil) then return end
	
	local restore = self.orderedRestores[index];
	self.deadRestores[restoreName] = index;
	
	if (restore.terminated) then
		restore.oldDuration = restore.oldDuration+(timestamp-restore.gameStartTime);
	else
		restore.duration = restore.duration+(timestamp-restore.gameStartTime);
	end
	restore.alive = false;
end

-- terminate all the debuffs on a mob (eg: when it died)
function Encounter:TerminateDebuffs(timestamp,mobName)
	local mob = self.orderedMobs[self.mobs[mobName][1]];
	-- terminate the debuffs on the mob
	if (mob.alive and mob.players[player.name] ~= nil) then
		for _,mobSummData in pairs(mob.players[player.name]) do
			mobSummData.debuffData:TerminateAll(timestamp,mobName);
		end
	end
	-- terminate the debuffs for the specified mob in the totals
	if (self.orderedMobs[1].players[player.name] ~= nil) then
		for _,mobSummData in pairs(self.orderedMobs[1].players[player.name]) do
			mobSummData.debuffData:TerminateAll(timestamp,mobName);
		end
	end
end

-- terminate a buff (when effect is removed)
function Encounter:TerminateBuff(timestamp,restoreName,skillName,effect)
	local restore = self.orderedRestores[self.restores[restoreName]];
	-- terminate the buff on the restore
	if (restore ~= nil and restore.players[player.name] ~= nil and restore.players[player.name][skillName] ~= nil) then
		restore.players[player.name][skillName].buffData:TerminateBuff(timestamp,effect);
	end
	-- terminate the buff for the specified restore in the totals
	if (self.orderedRestores[1].players[player.name] ~= nil and self.orderedRestores[1].players[player.name][skillName] ~= nil) then
		self.orderedRestores[1].players[player.name][skillName].buffData:TerminateBuff(timestamp,effect);
	end
end

-- update timers when restore is revived
function Encounter:RestoreRevived(timestamp,restoreName)
	local index = self.deadRestores[restoreName]
	-- NB: if the restoreName did not exist in the list, the revive line will just be ignored
	if (index == nil) then return end
	
	self.deadRestores[restoreName] = nil;
	
	local restore = self.orderedRestores[index];
	if (restore.alive) then return end
	
	self.restores[restoreName] = index;
	restore.gameStartTime = timestamp;
	restore.alive = true;
end

-- notification of completed mob death
function Encounter:MobFinished(timestamp,mobData)
	local mobName = mobData[1];
	local wasPending = mobData[2];
	
	if (wasPending) then
		local pending = self.pendingDeaths[mobName];
		if (pending ~= nil) then
			self.pendingDeaths[mobName] = pending-1;
			if (self.pendingDeaths[mobName] <= 0) then self.pendingDeaths[mobName] = nil end
		end
	end
	
	local mobInfo = self.mobs[mobName];
	if (mobInfo == nil or mobInfo[2]) then return end
	
	local mob = self.orderedMobs[mobInfo[1]];
	timestamp = Turbine.Engine.GetGameTime()
	
	mobInfo[2] = true;
	mob.finishTime = timestamp;
	
	-- ensure target set to dead (as a second mob, with the same name, may have died while the timer was running)
	if (mob.alive) then
		mob.alive = false;
	end
end

-- notification of completed restore death
function Encounter:RestoreFinished(timestamp,restoreName)
	local restoreIndex = self.restores[restoreName];
	if (restoreIndex == nil) then return end
	local restore = self.orderedRestores[restoreIndex];
	if (restore.alive) then return end
	
	-- NB: the restore could potentially be alive again if it was revived while the timer
	--   was running (or possibly via a buff effect received before the revive line),
	--   so we do nothing if it is already alive
	
	-- It may be possible (though very unlikely) that a player's death event can
	--   come before the first heal/power restore to that player. In that case, the death
	--   event will be (safely but slightly incorrectly) ignored
	
	self.restores[restoreName] = nil;
end

-- update all durations and terminate all buffs & debuffs on combat end (debuffs will always be cleared on combat end, and buffs will be reset later if combat resets)
function Encounter:CombatExited(isCurrentEncounter,timestamp)
	-- update totals encounter durations
	for _,mob in ipairs(self.orderedMobs) do
		mob.terminated = true;
		mob.oldDuration = mob.duration;
		if (mob.alive) then
			mob.duration = mob.duration + (timestamp-mob.gameStartTime);
      -- terminate debuffs
			--[[
      if (mob.mobName ~= L.Totals) then
				self:TerminateDebuffs(timestamp,mob.mobName);
			end
      ]]--
    end
    -- special terminate of all debuffs (allowing for reset later)
		if (mob.players[player.name] ~= nil) then
			for _,mobSummData in pairs(mob.players[player.name]) do
				mobSummData.debuffData:CombatEnded(timestamp);
			end
		end
	end
	for _,restore in ipairs(self.orderedRestores) do
		restore.terminated = true;
		restore.oldDuration = restore.duration;
		if (restore.alive) then
			restore.duration = restore.duration + (timestamp-restore.gameStartTime);
		end
		-- special terminate of all buffs (allowing for reset later)
		if (restore.players[player.name] ~= nil) then
			for _,restoreSummData in pairs(restore.players[player.name]) do
				restoreSummData.buffData:CombatEnded(timestamp);
			end
		end
	end
	
	-- update encounter name on reset
	if (isCurrentEncounter) then
		self.name = L.CompletedEncounter;
		self.longName = L.CompletedEncounter.." ("..Misc.FormatTime(self.startTime)..")";
		encountersComboBox:SetLastItemName(self.longName);
		fileSelectDialog:NotifyLastItemChanged(self.longName);
	end
end

-- reset the encounter (combat restarted within ~1.5s)
function Encounter:Reset(isCurrentEncounter)
	for name,mobInfo in pairs(self.mobs) do
		local mob = self.orderedMobs[mobInfo[1]];
		
		if mob.terminated then
			mob.duration = mob.oldDuration;
			mob.terminated = false;
      mob:ResetDebuffs();
		end
	end
	
	for name,index in pairs(self.restores) do
		local restore = self.orderedRestores[index];
		
		if restore.terminated then
			restore.duration = restore.oldDuration;
			restore.terminated = false;
			restore:ResetBuffs();
		end
	end
	
	-- update encounter name on reset
	if (isCurrentEncounter) then
		self.name = L.CurrentEncounter;
		self.longName = L.CurrentEncounter.." ("..Misc.FormatTime(self.startTime)..")";
		
		encountersComboBox:SetLastItemName(self.longName);
		fileSelectDialog:NotifyLastItemChanged(self.longName);
	end
end

-- set all mobs and restores to dead/finished, and terminate all remaining buff info, 
function Encounter:CombatFinished(isTotalsEncounter,timestamp)
  for _,mob in ipairs(self.orderedMobs) do
		if (mob.alive and mob.mobName ~= L.Totals) then
      self:TerminateDebuffs(timestamp,mob.mobName);
    end
  end
  
	for _,restore in pairs(self.orderedRestores) do
		if (restore.players[player.name] ~= nil) then
			for _,restoreSummData in pairs(restore.players[player.name]) do
				restoreSummData.buffData:TerminateAll();
			end
		end
	end
	
	if (isTotalsEncounter) then
		-- set all mobs and restores to not alive (not necessary for the current encounter as it won't be reset)
		for mobName,mobInfo in pairs(self.mobs) do
			if (mobName ~= L.Totals) then
				mobInfo[2] = true;
				
				local mob = self.orderedMobs[mobInfo[1]];
				mob.alive = false;
				mob.resetTime = nil;
				mob.finishTime = timestamp; -- ie: when combat ended
			end
		end
		
		for restoreName,restoreIndex in pairs(self.restores) do
			if (restoreName ~= L.Totals and restoreName ~= player.name) then
				self.deadRestores[restoreName] = restoreIndex;
				self.orderedRestores[restoreIndex].alive = false;
			end
		end
		
		self.restores = { [L.Totals] = 1, [player.name] = self.restores[player.name] }
	end
end


function Encounter:Continue(timestamp)
	-- unterminate mobs & restores
	for _,mob in ipairs(self.orderedMobs) do
		if (mob.alive) then mob.gameStartTime = timestamp end
		mob.terminated = false;
    -- unterminate debuffs
		if (mob.players[player.name] ~= nil) then
			for _,mobSummData in pairs(mob.players[player.name]) do
				mobSummData.debuffData.terminated = false;
			end
		end
	end
	for _,restore in ipairs(self.orderedRestores) do
		if (restore.alive) then restore.gameStartTime = timestamp end
		restore.terminated = false;
		-- unterminate buffs
		if (restore.players[player.name] ~= nil) then
			for _,restoreSummData in pairs(restore.players[player.name]) do
				restoreSummData.buffData.terminated = false;
			end
		end
	end
end

-- returns all of the encounter's data in a table so that it can be restored/combined with the data from other encounters
--  (note we save the minimal amount of data required to recreate the encounter, and don't encode numbers)
function Encounter:GetState(timestamp)
	-- NB: We combine mobs/restores with the same name within the lists before returning the state
	
	-- store the total mob debuff times
	local totalDebuffTimes = self.orderedMobs[1]:GetState(timestamp,true);
	
	-- store all other mob info
	local mobsToStateIndexes = {};
	local mobStates = {}
	for index = 2,#self.orderedMobs do
		local mobInfo = self.orderedMobs[index];
		
		if (mobsToStateIndexes[mobInfo.mobName] ~= nil) then
			Mob.CombineStates(mobStates[mobsToStateIndexes[mobInfo.mobName]],mobInfo:GetState(timestamp));
		else
			table.insert(mobStates,mobInfo:GetState(timestamp));
			mobsToStateIndexes[mobInfo.mobName] = #mobStates;
		end
	end
	
	-- store the total restore buff times
	local totalBuffTimes = self.orderedRestores[1]:GetState(timestamp,true);
	
	-- store all other restore info
	local restoresToStateIndexes = {};
	local restoreStates = {}
	for index = 2,#self.orderedRestores do
		local restoreInfo = self.orderedRestores[index];
		
		if (restoresToStateIndexes[restoreInfo.restoreName] ~= nil) then
			Restore.CombineStates(restoreStates[restoresToStateIndexes[restoreInfo.restoreName]],restoreInfo:GetState(timestamp));
		else
			table.insert(restoreStates,restoreInfo:GetState(timestamp));
			restoresToStateIndexes[restoreInfo.restoreName] = #restoreStates;
		end
	end
	
	return {
		["versionNo"] = versionNo, ["startTime"] = Misc.TableCopy(self.startTime),
		["totalDuration"] = (self.orderedMobs[1].duration+(self.orderedMobs[1].alive and not self.orderedMobs[1].terminated and (timestamp-self.orderedMobs[1].gameStartTime) or 0)),
		["totalDebuffTimes"] = totalDebuffTimes,["mobs"] = mobStates,
		["totalBuffTimes"] = totalBuffTimes,["restores"] = restoreStates
	};
end

-- combines state2 into state1
function Encounter.CombineStates(state1,state2,terminated)
	state1["startTime"] = Misc.MinTime(state1["startTime"],state2["startTime"]);
	
	local state1Mobs = state1["mobs"];
	local state2Mobs = state2["mobs"];
	-- merge the mob lists (they may be in completely different orders, so this is a O(2*m*n) operation)
	for _,state1MobState in ipairs(state1Mobs) do
		for index,state2MobState in ipairs(state2Mobs) do
			if (state1MobState["mobName"] == state2MobState["mobName"]) then
				Mob.CombineStates(state1MobState,state2MobState,nil);
				table.remove(state2Mobs,index);
				break;
			end
		end
	end
	for _,state2MobState in ipairs(state2Mobs) do
		table.insert(state1Mobs,state2MobState);
	end
	
	local state1Restores = state1["restores"];
	local state2Restores = state2["restores"];
	-- merge the mob lists (they may be in completely different orders, so this is a O(2*m*n) operation)
	for _,state1RestoreState in ipairs(state1Restores) do
		for index,state2RestoreState in ipairs(state2Restores) do
			if (state1RestoreState["restoreName"] == state2RestoreState["restoreName"]) then
				Restore.CombineStates(state1RestoreState,state2RestoreState,nil);
				table.remove(state2Restores,index);
				break;
			end
		end
	end
	for _,state2RestoreState in ipairs(state2Restores) do
		table.insert(state1Restores,state2RestoreState);
	end
	
	-- update total duration & buff/debuff durations
	state1["totalDuration"] = state1["totalDuration"] + state2["totalDuration"];
	
	Mob.CombineStates(state1["totalDebuffTimes"],state2["totalDebuffTimes"],true,true);
	Restore.CombineStates(state1["totalBuffTimes"],state2["totalBuffTimes"],true,true);
end

function Encounter.RestoreState(state,gameStartTime)
	local encounter = Encounter(nil,nil,gameStartTime);
	encounter.loaded = true;
	
	encounter.orderedMobs[1].terminated = true;
	encounter.orderedRestores[1].terminated = true;
	
	table.insert(encounter.orderedRestores,Restore(gameStartTime,player.name));
	encounter.restores[player.name] = #(encounter.orderedRestores);
	
	encounter.startTime = state["startTime"];
	
	local mobStates = state["mobs"];
	local mobTotalsState = { ["mobName"] = L.Totals, ["duration"] = 0, ["mobData"] = {} };
	for _,mobState in ipairs(mobStates) do
		table.insert(encounter.orderedMobs,Mob.RestoreState(mobState));
		encounter.mobs[mobState["mobName"]] = {#encounter.orderedMobs,true};
		
		-- update totals
		Mob.CombineStates(mobTotalsState,mobState,false);
	end
	
	local restoreStates = state["restores"];
	local restoreTotalsState = { ["restoreName"] = L.Totals, ["duration"] = 0, ["restoreData"] = {} };
	for _,restoreState in ipairs(restoreStates) do
		if (restoreState["restoreName"] == player.name) then
			encounter.orderedRestores[encounter.restores[player.name]] = Restore.RestoreState(restoreState,true);
		else
			table.insert(encounter.orderedRestores,Restore.RestoreState(restoreState));
		end
		encounter.restores[restoreState["restoreName"]] = #encounter.orderedRestores;
		
		-- update totals
		Restore.CombineStates(restoreTotalsState,restoreState,false);
	end
	
	-- set encounter total duration & buff/debuff durations
	Mob.CombineStates(mobTotalsState,state["totalDebuffTimes"],true);
	encounter.orderedMobs[1] = Mob.RestoreState(mobTotalsState,true);
	
	Restore.CombineStates(restoreTotalsState,state["totalBuffTimes"],true);
	encounter.orderedRestores[1] = Restore.RestoreState(restoreTotalsState,true);
	
	encounter.orderedMobs[1].duration = state["totalDuration"];
	encounter.orderedRestores[1].duration = state["totalDuration"];
	
	return encounter;
end
