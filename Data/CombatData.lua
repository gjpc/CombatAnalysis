
--[[

The Combat Data class contains all combat data that
has been parsed from the log.

It consists of a list of encounters (which include
summary data), as well as a complete list of combat
elements that specify every combat action that has
occured since parsing began (limited to a user
specified number of max entries).

Note this is an enforced singleton class. The single
instance is created at the bottom of this file.

]]--

local CombatData = class()

function CombatData:Constructor()
	self.timer = 1.5;	-- the amount of time to continue getting events for a mob/restore/encounter after its death/end (a pretty important number!)
	self.minDuration = 1; -- the smallest duration allowed for killing a mob (must be less than the timer)
	
	self.maxEncounters = 50;
	self.maxLoadedEncounters = 5;
	
	self.runningBuffs = RunningBuffs();
	self.runningDebuffs = RunningDebuffs();
end

function CombatData:Initialize()
	encountersComboBox:Clear();
	
	self.combatElements = {}
	
	-- create "Totals" encounter
	local gameStartTime = Turbine.Engine.GetGameTime();
	self.totalsEncounter = Encounter(true,Turbine.Engine.GetDate(),gameStartTime);
	
	-- if in combat on startup, initiate a combat entered update immediately
	if (player:IsInCombat()) then		
		self:Update(11,gameStartTime,player.name);
	end
end

--[[

The rather complex Data Update function. This method is called when a line from the combat log
is successfully parsed, the player enters or exists combat, or a buff falls off a player.

For reference: the updateType enum
 1 = dmg dealt
 2 = dmg taken
 3 = heal
 4 = power restore
 5 = debuff applied
 6 = buff applied
 7 = interrupt
 8 = corruption
 9 = death
 10 = revive
 11 = combat start
 12 = combat end
 
 13 = mob interrupts (opposite of player interrupts)
 
 14 = temporary morale lost (as of 4.1.0)
 15 = notification that temporary morale was not wasted (as of 4.1.0)

The most special cases are a mob/player death, or the end of combat. In both cases, we use short timers to
ensure extra information that comes immediately after a death/end of combat is accounted for (eg: the death
blow and other damage is almost always listed after a mob's killing blow).

Positive valued damage dealt can initiate combat. In this case, we recheck to see if we are in combat
after 3s to ensure combat doesn't hang (for example, on an aoe attack that one shots mobs).

Note we assume a player will never be revived within 1s from dying. In the unlikely event this does occur,
we auto-fire a revive event the next time the player is healed/given power instead.

All events other than deaths/revivals, and combat start/end are passed on to the current (and "totals")
encounters who update the relevant summary data.

A complete list of all combat events (everything that happened in the combat log) is also built.

]]--

function CombatData:Update(updateType,timestamp,playerName,targetName,skillName,var1,var2,var3,var4)
	-- mob or player death
	if updateType == 9 then
		
		local targetIdentified = false;
		local wasPending = false;
		
		if (self.inCombat) then
			if (self.currentEncounter.mobs[playerName] ~= nil and self.currentEncounter.orderedMobs[self.currentEncounter.mobs[playerName][1]].alive) then
				self.currentEncounter:TerminateDebuffs(timestamp,playerName);
				self.currentEncounter:MobDied(timestamp,playerName,true);
			else
				local pending = self.currentEncounter.pendingDeaths[playerName];
				self.currentEncounter.pendingDeaths[playerName] = (pending == nil and 0 or pending)+1;
				wasPending = true;
			end
		end
    if (self.currentEncounter ~= nil) then
      Misc.StartTimer({playerName,wasPending},timestamp,combatData.timer,Encounter.MobFinished,self.currentEncounter);
    end
		
		wasPending = false;
		if (self.totalsEncounter.mobs[playerName] ~= nil and self.totalsEncounter.orderedMobs[self.totalsEncounter.mobs[playerName][1]].alive) then
			self.totalsEncounter:TerminateDebuffs(timestamp,playerName);
			self.totalsEncounter:MobDied(timestamp,playerName,false);
		else
			local pending = self.totalsEncounter.pendingDeaths[playerName];
			self.totalsEncounter.pendingDeaths[playerName] = (pending == nil and 0 or pending)+1;
			wasPending = true;
		end
		Misc.StartTimer({playerName,wasPending},timestamp,combatData.timer,Encounter.MobFinished,self.totalsEncounter);
		
		-- NB: termination of buffs will be detected by event handlers
		if (self.inCombat and self.currentEncounter.restores[playerName] ~= nil) then
			self.currentEncounter:RestoreDied(timestamp,playerName);
		end
		if (self.totalsEncounter.restores[playerName] ~= nil) then
			self.totalsEncounter:RestoreDied(timestamp,playerName);
		end
		Misc.StartTimer(playerName,timestamp,combatData.timer,CombatData.RestoreFinished,self);
		
	-- player revived
	elseif updateType == 10 then
		if (self.inCombat) then
			self.currentEncounter:RestoreRevived(timestamp,playerName);
			self.totalsEncounter:RestoreRevived(timestamp,playerName);
		end
		
	-- combat entered
	elseif updateType == 11 then
		-- in the rare chance the previous encounter is not yet completed, reset it and continue
		if (self.inCombat) then
			-- note we don't always need to reset (may have entered combat via damage, and then again via actual combat)
			if (self.totalsEncounter.orderedMobs[1].terminated) then
				self.currentEncounter:Reset(true);
				self.totalsEncounter:Reset(false);
			end
		
		-- otherwise, begin a new encounter
		else
			self.inCombat = true;
			
			-- initialize current and totals encounters
			self.currentEncounter = Encounter(false,Turbine.Engine.GetDate(),timestamp);
			self.totalsEncounter:Continue(timestamp);
			
			-- notify encounters that combat has begun
			self.currentEncounter:CombatStarted(true,timestamp);
			self.totalsEncounter:CombatStarted(false,timestamp);
			
			-- update the buff/debuff tabs which may have info applied immediately
			debuffTab:FullUpdate();
			buffTab:FullUpdate();
			
			-- notify all tabs to start refreshing (so duration values, etc, are updated)
			dmgTab:DisableChatSendButton();
			takenTab:DisableChatSendButton();
			healTab:DisableChatSendButton();
			powerTab:DisableChatSendButton();
			debuffTab:DisableChatSendButton();
			buffTab:DisableChatSendButton();
		end
		
		-- notify all tabs to start refreshing (so duration values, etc, are updated)
		dmgTab:SetWantsUpdates(true);
		takenTab:SetWantsUpdates(true);
		healTab:SetWantsUpdates(true);
		powerTab:SetWantsUpdates(true);
		debuffTab:SetWantsUpdates(true);
		buffTab:SetWantsUpdates(true);
		
	-- combat exited
	elseif updateType == 12 then
		-- notify encounters that combat has ended
		self.currentEncounter:CombatExited(true,timestamp);
		self.totalsEncounter:CombatExited(false,timestamp);
		
		-- notify all tabs that they can stop refreshing
		dmgTab:SetWantsUpdates(false);
		takenTab:SetWantsUpdates(false);
		healTab:SetWantsUpdates(false);
		powerTab:SetWantsUpdates(false);
		debuffTab:SetWantsUpdates(false);
		buffTab:SetWantsUpdates(false);
		
		-- update all tabs with final terminated durations
		dmgTab:FullUpdate();
		takenTab:FullUpdate();
		healTab:FullUpdate();
		powerTab:FullUpdate();
		debuffTab:FullUpdate();
		buffTab:FullUpdate();
		
		Misc.StartTimer(nil,timestamp,combatData.timer,CombatData.EncounterFinished,self);
		
	-- standard update of summary data
	elseif (self.inCombat or (updateType == 1 and var1 > 0)) then
		-- initiate combat on positive damage
		if (not self.inCombat) then
			self:Update(11,timestamp,playerName,nil,true);
			-- since combat does not initiate on AoE damage that kills targets instantly, check that we are still in combat after 3 seconds
			Misc.StartTimer(nil,timestamp,3,CombatData.CheckCombatStatus,self);
		end
		
		-- update the relevant encounters
		self.currentEncounter:Update(true,updateType,timestamp,targetName,playerName,skillName,var1,var2,var3,var4);
		self.totalsEncounter:Update(false,updateType,timestamp,targetName,playerName,skillName,var1,var2,var3,var4);
		
		-- update relevant summary displays
		if (updateType == 1 or updateType == 7 or updateType == 8) then
			dmgTab:FullUpdate();
		elseif (updateType == 2 or updateType == 13) then
			takenTab:FullUpdate();
		elseif (updateType == 3 or updateType == 14 or updateType == 15) then
			healTab:FullUpdate();
		elseif (updateType == 4) then
			powerTab:FullUpdate();
		elseif (updateType == 5) then
			debuffTab:FullUpdate();
		elseif (updateType == 6) then
			buffTab:FullUpdate();
		end
	end
	
	-- create combat elements
	--[[
	
	This will be used to generate lists/charts in v4.2.0+
	
	if updateType == 1 then
		table.insert(self.combatElements,Dmg(timestamp,targetName,initiatorName,skillName,var1,var2,var3,var4));
	elseif updateType == 2 then
		table.insert(self.combatElements,Taken(timestamp,targetName,initiatorName,skillName,var1,var2,var3,var4));
	elseif updateType == 3 then
		table.insert(self.combatElements,Heal(timestamp,targetName,initiatorName,skillName,var1,var2));
	elseif updateType == 4 then
		table.insert(self.combatElements,Power(timestamp,targetName,initiatorName,skillName,var1,var2));
	elseif updateType == 5 then
		table.insert(self.combatElements,Debuff(stimestamp,targetName,initiatorName,killName));
	elseif updateType == 6 then
		table.insert(self.combatElements,Buff(timestamp,targetName,initiatorName,skillName));
	elseif updateType == 7 or updateType == 13 then
		table.insert(self.combatElements,Interrupt(timestamp,targetName,initiatorName));
	elseif updateType == 8 then
		table.insert(self.combatElements,Corruption(timestamp,targetName,initiatorName));
	elseif updateType == 9 then
		table.insert(self.combatElements,Death(timestamp,initiatorName));
	elseif updateType == 10 then
		table.insert(self.combatElements,Revive(timestamp,initiatorName));
	elseif updateType == 11 then
		table.insert(self.combatElements,CombatEntry(timestamp,initiatorName));
	elseif updateType == 12 then
		table.insert(self.combatElements,CombatExit(timestamp,initiatorName));
	end
	]]
end

-- notification of removed buff
function CombatData:TerminateBuff(timestamp,targetName,skillName,effect)
	if (self.inCombat) then
		self.currentEncounter:TerminateBuff(timestamp,targetName,skillName,effect);
		self.totalsEncounter:TerminateBuff(timestamp,targetName,skillName,effect);
	end
end

-- notification of restore death completion
function CombatData:RestoreFinished(timestamp,restoreName)
	if (self.currentEncounter ~= nil) then
		self.currentEncounter:RestoreFinished(timestamp,restoreName);
	end
	self.totalsEncounter:RestoreFinished(timestamp,restoreName);
end

-- notification of completed encounter
function CombatData:EncounterFinished(timestamp)
	-- check to see if combat has been reset
	if (not self.currentEncounter.orderedMobs[1].terminated) then return end
	
	-- terminate combat
	self.inCombat = false;
	
	-- terminate all buff info
	self.currentEncounter:CombatFinished(false,timestamp);
	self.totalsEncounter:CombatFinished(true,timestamp);
	
	-- determine the best name for the encounter (based on damage dealt)
	self.currentEncounter:DetermineName();
	encountersComboBox:SetLastItemName(self.currentEncounter.longName);
	fileSelectDialog:NotifyLastItemChanged(self.currentEncounter.longName);
	
	-- now that we are out of combat, update the chatsend buttons
	dmgTab:UpdateChatSendButton();
	takenTab:UpdateChatSendButton();
	healTab:UpdateChatSendButton();
	powerTab:UpdateChatSendButton();
	debuffTab:UpdateChatSendButton();
	buffTab:UpdateChatSendButton();
  
  if (autoSave == "SaveEncounters") then
    -- generate a unique name to save the encounter as
    local saveName = Misc.FormatDateTime(self.currentEncounter.startTime).." "..string.gsub(self.currentEncounter.name,"[^%w ]"," ");
    fileSelectDialog.fileName = string.sub(saveName, 1, math.max(63, string.len(saveName)));
    local index,strExists = dataFileList:BinarySearch(fileSelectDialog.fileName);
    for count = 1,9 do
      if (not strExists) then break end
      fileSelectDialog.fileName = string.sub(saveName, 1, math.max(61, string.len(saveName))).." "..tostring(count);
      index,strExists = dataFileList:BinarySearch(fileSelectDialog.fileName);
    end
    
    -- save the current encounter
    DataStorage.Save(nil,self.currentEncounter);
  end
end

-- notification to check combat state and determine if combat should be ended
function CombatData:CheckCombatStatus(timestamp)
	if (not player:IsInCombat()) then
		self:Update(12,Turbine.Engine.GetGameTime(),playerName,nil,true);
    pendingDebuffs:Clear();
		combatData.runningDebuffs:Clear();
	end
end

function CombatData:ResetTotals(reset)
	if (not reset) then return end
	
	local gameStartTime = Turbine.Engine.GetGameTime();
	
	-- reset totals
	self.totalsEncounter = Encounter(true,Turbine.Engine.GetDate(),gameStartTime);
	if (self.inCombat) then
		self.totalsEncounter:Continue(gameStartTime);
		self.totalsEncounter:CombatStarted(false,gameStartTime);
	end
end

function CombatData:ComboBoxChanged(value)

	-- A new encounter has been selected ==> update the mobs and restores combo boxes
	if (value:GetType():GetName() == "Encounter") then
		self.selectedEncounter = value;
		
		-- clear mobs and restores lists
		mobsComboBox:Clear();
		restoresComboBox:Clear();
		-- rebuild mobs and restores lists using new encounter info
		mobsComboBox:SetTotals(L.Totals,value.orderedMobs[1]);
		for i=2,#value.orderedMobs do
			mobsComboBox:AddItem(value.orderedMobs[i].mobName,value.orderedMobs[i]);
		end
		restoresComboBox:SetTotals(L.Totals,value.orderedRestores[1]);
		for i=2,#value.orderedRestores do
			restoresComboBox:AddItem(value.orderedRestores[i].restoreName,value.orderedRestores[i]);
		end
		
		-- NB: mobs and restores combo box resets will cause an update to bars/stats panels
		
	-- Mobs combo box target has changed ==> update relevant data
	elseif (value:GetType():GetName() == "Mob") then
		self.selectedMob = value;
		
		dmgTab:FullUpdate(true,true);
		takenTab:FullUpdate(true,true);
		debuffTab:FullUpdate(true,true);
		
		-- update chat send buttons to reflect selected encounter
		if (not self.inCombat) then
			dmgTab:UpdateChatSendButton();
			takenTab:UpdateChatSendButton();
			debuffTab:UpdateChatSendButton();
		end
		
	-- Restores combo box target has changed ==> update relevant data
	else
		self.selectedRestore = value;
		
		healTab:FullUpdate(true,true);
		powerTab:FullUpdate(true,true);
		buffTab:FullUpdate(true,true);
		
		-- update chat send buttons to reflect selected encounter
		if (not self.inCombat) then
			healTab:UpdateChatSendButton();
			powerTab:UpdateChatSendButton();
			buffTab:UpdateChatSendButton();
		end
	end

end

-- create singleton class
_G.combatData = CombatData();
