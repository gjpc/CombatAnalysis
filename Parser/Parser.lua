
--[[

The parsing Function is called whenever a chat event is received.

Only combat and death filters are parsed.

]]--

Misc.AddCallback(Turbine.Chat,"Received",function(sender, args)
	-- only parse combat text
	if (not statOverviewEnabled or ((args.ChatType ~= Turbine.ChatType.EnemyCombat) and (args.ChatType ~= Turbine.ChatType.PlayerCombat) and (args.ChatType ~= Turbine.ChatType.Death))) then
		return;
	end
	
	-- immediately grab timestamp (NB: actually it appears this doesn't change over successive calls in the same frame)
	local timestamp = Turbine.Engine.GetGameTime();
	
	-- grab line from combat log, strip it of color, trim it, and parse it according to the localized parsing function
	local updateType,initiatorName,targetName,skillName,var1,var2,var3,var4 = L.Parse(string.gsub(string.gsub(args.Message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"));
	if (updateType == nil) then return end
  
	-- Now, perform some preprocessing on the parsed output, and then pass along the info to update combat data
  
	-- Determine if this is damage dealt or damage received and update accordingly
	if (updateType == event_type.DMG_DEALT or updateType == event_type.INTERRUPT) then
    
		-- a) Check for player name as initiator
		if (initiatorName == player.name) then
      
      -- Check for self damage
			if (targetName == player.name) then
		        -- NB: currently just ignore self interrupts
		        if (updateType == event_type.INTERRUPT) then return end


				if (printDebug) then
					Turbine.Shell.WriteLine("self damage > "..tostring(updateType == event_type.DMG_DEALT and event_type.DMG_TAKEN or event_type.MOB_INTERRUPT)..","..tostring(timestamp)..","..tostring(initiatorName)..","..tostring(targetName)..","..tostring(skillName)..","..tostring(var1)..","..tostring(var2)..","..tostring(var3)..","..tostring(var4));
				end

				updateType = event_type.DMG_TAKEN;
	        
			-- Check if the skill used is a tracked Debuff (if it wasn't avoided)
			elseif (updateType == event_type.DMG_DEALT and (var2 == 1 or (var2 > 7 and var2 < 11))) then

		        if (debuffApplications[skillName] ~= nil) then
		          for debuffName, skillInfo in pairs(debuffApplications[skillName]) do
		            InitiateDebuff(timestamp,var3,initiatorName,targetName,debuffName,skillInfo,true);
		          end
		        end
		        if (ccApplications[skillName] ~= nil) then
		          for debuffName, skillInfo in pairs(ccApplications[skillName]) do
		            InitiateDebuff(timestamp,var3,initiatorName,targetName,debuffName,skillInfo,false);
		          end
		        end
			end
			
		-- b) Check for player name as target
		elseif (targetName == player.name) then
			if (updateType == event_type.INTERRUPT) then
				updateType = event_type.MOB_INTERRUPT;
			else
				updateType = event_type.DMG_TAKEN;
			end
			
			targetName = initiatorName;
			initiatorName = player.name;
    
    -- c) Ignore any interrupts that don't involve the player
    elseif (updateType == event_type.INTERRUPT) then
      return;
      
    -- d) Make adjustments if pet was target
		elseif (updateType == event_type.DMG_DEALT and args.ChatType == Turbine.ChatType.EnemyCombat) then
      -- NB: Currently ignore the possibility of self inflicted pet damage, and debuffs applied by pets
      
      updateType = event_type.DMG_TAKEN;
      local petName = targetName;
      targetName = initiatorName;
      initiatorName = petName;
    
		end
	
	-- Check check if the skill used was a tracked morale bubble
	elseif (updateType == event_type.HEAL or updateType == event_type.POWER_RESTORE) then
		-- TODO (if this is a self heal, we should check to see that the skill name doesn't match the
		--         name of a player in the group - ie: is actually a direct heal with no skill name)
		
		CheckMoraleBubble(timestamp,targetName,skillName,initiatorName,true);
    
	-- terminate all pending & running debuffs on a mob that has died
	elseif (updateType == event_type.DEATH) then
    -- remove all pending debuffs for this target
    local i = 1;
    while i <= #pendingDebuffs.list do
      if (pendingDebuffs.list[i][2][2] == initiatorName) then
        table.remove(pendingDebuffs.list,i);
      else
        i = i+1;
      end
    end
    -- remove all running debuffs for this target
    combatData.runningDebuffs:Terminated(timestamp,initiatorName);
    
	-- Determine who the most recent successful initiator of a temporary morale bubble was
	elseif (updateType == event_type.TEMP_MORALE_LOST) then
		
		-- If there are no active bubbles specified for this target, add this info to a pending list
		if (activeBubbles[targetName] == nil) then
			if (recentTempMorale[targetName] == nil) then recentTempMorale[targetName] = {} end
			table.insert(recentTempMorale[targetName],{timestamp,nil,var1});
			Misc.StartTimer(var1,timestamp,logDelay,RemoveRecentTempMoraleLost);
			return;
			
		-- Otherwise extract the initiator and skill names from the active bubbles list
		else
			initiatorName,skillName = DetermineBubbleInitiatorAndSkill(targetName);
			
			if (recentTempMorale[targetName] == nil) then recentTempMorale[targetName] = {} end
			table.insert(recentTempMorale[targetName],{timestamp,{initiatorName,skillName},var1});
			Misc.StartTimer(var1,timestamp,logDelay,RemoveRecentTempMoraleLost);
		end
		
	elseif (updateType == event_type.CC_BROKEN) then
		
		-- terminate any dazes/roots/fears on the target
		if (combatData.runningDebuffs.crowdControl[targetName] ~= nil) then
			local ccSkillName = combatData.runningDebuffs.crowdControl[targetName][1];
			if (ccSkillName == L.Daze or ccSkillName == L.Root or ccSkillName == L.Fear) then
				combatData.runningDebuffs:Terminated(timestamp,targetName,ccSkillName,false);
			end
		end
		return;
		
	elseif (updateType == event_type.BENEFIT) then
		-- Check if the skill used was a tracked Benefit
		if (benefits[skillName] ~= nil) then
			updateType = event_type.HEAL;
			var1 = 0; -- a zero heal
			var2 = 1; -- a hit
		end
		-- If player wanted to track the benefit as a debuff, initiate
		if (debuffApplications[skillName] ~= nil) then
          for debuffName, skillInfo in pairs(debuffApplications[skillName]) do
            InitiateDebuff(timestamp,var3,initiatorName,targetName,debuffName,skillInfo,true);
          end
        end

		-- Also check if the skill used was a tracked morale bubble
		CheckMoraleBubble(timestamp,targetName,skillName,initiatorName,false);

		-- If this benefit was not tracked, do nothing
		if (updateType == event_type.BENEFIT) then return end
		
	end
	
	-- finally, check if taken damage corresponds to an earlier (always earlier) loss of temporary morale
	if (updateType == event_type.DMG_TAKEN) then
		if (recentTempMorale[initiatorName] ~= nil) then
			for index,tempMoraleInfo in ipairs(recentTempMorale[initiatorName]) do
				if (tempMoraleInfo[3] == var1 and tempMoraleInfo[4] == nil) then
					-- if this heal has already been assigned to an effect, then it can now be removed from the list
					if (tempMoraleInfo[2]) then
						combatData:Update(event_type.TEMP_MORALE_NOT_WASTED,timestamp,tempMoraleInfo[2][1],initiatorName,tempMoraleInfo[2][2],var1);
						table.remove(recentTempMorale[initiatorName],index);
					-- otherwise, just update the wasted status of the item to false
					else
						tempMoraleInfo[4] = false;
					end
					
					break;
				end
			end
		end
	end
	
	if (printDebug) then
		Turbine.Shell.WriteLine(tostring(updateType)..","..tostring(timestamp)..","..tostring(initiatorName)..","..tostring(targetName)..","..tostring(skillName)..","..tostring(var1)..","..tostring(var2)..","..tostring(var3)..","..tostring(var4));
	end
	combatData:Update(updateType,timestamp,initiatorName,targetName,skillName,var1,var2,var3,var4);
	
end);

--[[
	
	Apply an Effect
	
]]--

function _G.InitiateDebuff(timestamp,crit,initiatorName,targetName,debuffName,applicationInfo,isDebuff)
  local skillInfo = (isDebuff and debuffs[debuffName] or cc[debuffName]);
  
  if (skillInfo.toggleSkill or not applicationInfo.critsOnly or crit > 1) then
    -- apply the debuff immediately
    if (applicationInfo.delay == nil or applicationInfo.delay <= 0) then
      ApplyDebuff(timestamp,{initiatorName,targetName,debuffName,applicationInfo,isDebuff});
    -- a debuff with a delay; store it in the pending debuffs list so we can check to see if the mob died between now and then
    else
      local mobIndex = (combatData.currentEncounter and combatData.currentEncounter.mobs[targetName] or nil);
      if (not combatData.inCombat or
              (not combatData.currentEncounter.orderedMobs[1].terminated and
              (mobIndex == nil or combatData.currentEncounter.orderedMobs[mobIndex[1]].alive or mobIndex[2]))) then
        pendingDebuffs:Add(timestamp+applicationInfo.delay,{initiatorName,targetName,debuffName,applicationInfo,isDebuff},nil,true);
        parserControl:SetWantsUpdates(true);
      end
    end
  end
end

function _G.ApplyDebuff(timestamp,effectInfo)
	local initiatorName = effectInfo[1];
	local targetName = effectInfo[2];
	local skillName = effectInfo[3];
	local applicationInfo = effectInfo[4]; -- crits only, duration, delay
	local isDebuff = effectInfo[5];
  	local skillInfo = (isDebuff and debuffs[skillName] or cc[skillName]); -- skill type, removal only, overwrites, icon, conflicts, buff effects
  	timestamp = math.max((combatData.currentEncounter and combatData.currentEncounter.orderedMobs[1].gameStartTime or Turbine.Engine.GetGameTime()), timestamp + (applicationInfo.delay or 0));
  
  	-- 1) ensure that debuffs aren't applied if a conflicting debuff is on the mob
	if (not skillInfo.removalOnly and skillInfo.conflicts ~= nil) then
    -- debuff
    if (isDebuff) then
      for _,conflict in ipairs(skillInfo.conflicts) do
        local conflictIsToggle = debuffs[conflict].toggleSkill;
        if (not debuffs[conflict].removalOnly and ((skillInfo.toggleSkill and conflictIsToggle) or (not skillInfo.toggleSkill and not conflictIsToggle))) then
          if (combatData.runningDebuffs.debuffs[targetName] ~= nil and combatData.runningDebuffs.debuffs[targetName][conflict] ~= nil) then
            return;
          end
        end
      end
    -- cc
    else
      local currentCCName = (combatData.runningDebuffs.crowdControl[targetName] ~= nil and combatData.runningDebuffs.crowdControl[targetName][1] or nil);
      if (currentCCName ~= nil) then
        for _,conflict in ipairs(skillInfo.conflicts) do
          if (conflict == currentCCName) then return end
        end
      end
    end
    
	end
  
  -- 2) adjust the duration based on any running effects
  local duration = applicationInfo.duration;
  if (isDebuff) then
    if (not skillInfo.removalOnly and not skillInfo.toggleSkill and skillInfo.buffEffects ~= nil) then
      for _,buffInfo in pairs(skillInfo.buffEffects) do
        if (combatData.runningBuffs.buffs[player.name] ~= nil) then
          for currentBuff,_ in pairs(combatData.runningBuffs.buffs[player.name]) do
            if (buffInfo.skillName == currentBuff:GetName()) then
              duration = duration + buffInfo.duration;
              break;
            end
          end
        end
      end
      
      -- do nothing if a non-remover skill has no duration after accounting for effect modifiers
      -- note this means we will (intentionally!) not even apply the remover effects
      if (not skillInfo.removalOnly and duration == 0) then return end
    end
  end
  
  local conflictingToggleTarget = nil;
	local conflictingToggleSkillName = nil;
  
	-- 3a) terminate a toggle skill if active on another target - if so, we pass the target info along when updating the combat data
	if (not skillInfo.removalOnly and skillInfo.toggleSkill and skillInfo.overwrites ~= nil) then
    for _,conflictingSkill in ipairs(skillInfo.overwrites) do
      if (not debuffs[conflictingSkill].removalOnly and debuffs[conflictingSkill].toggleSkill and combatData.runningDebuffs.toggles[conflictingSkill] ~= nil) then
        conflictingToggleTarget = combatData.runningDebuffs.toggles[conflictingSkill];
        conflictingToggleSkillName = conflictingSkill;
        combatData.runningDebuffs:Terminated(timestamp,conflictingToggleTarget,conflictingToggleSkillName,true);
        break;
      end
    end
		
	-- 3b) terminate any overwritable debuffs/cc on this target (don't need to pass on this static info)
	elseif (skillInfo.overwrites ~= nil) then
    -- debuff
    if (isDebuff) then
      for _,conflictingSkill in ipairs(skillInfo.overwrites) do
        if (not debuffs[conflictingSkill].removalOnly and not debuffs[conflictingSkill].toggleSkill) then
          combatData.runningDebuffs:Terminated(timestamp,targetName,conflictingSkill,true);
        end
      end
    -- cc
    else
      local currentCCName = (combatData.runningDebuffs.crowdControl[targetName] ~= nil and combatData.runningDebuffs.crowdControl[targetName][1] or nil);
      for _,conflictingSkill in ipairs(skillInfo.overwrites) do
        combatData.runningDebuffs:Terminated(timestamp,targetName,conflictingSkill,false);
      end
    end
    
	end
  
  -- 4) now we can actually record the debuff in CA and/or Buffbars as appropriate
	local mobIndex = (combatData.currentEncounter and combatData.currentEncounter.mobs[targetName] or nil);
  -- only record the debuff in BB if combat has not just been terminated & the mob has not just died
	if (not skillInfo.removalOnly and
        (not combatData.inCombat or
              (not combatData.currentEncounter.orderedMobs[1].terminated and
              (mobIndex == nil or combatData.currentEncounter.orderedMobs[mobIndex[1]].alive or mobIndex[2]))
				)) then
		combatData.runningDebuffs:Applied(timestamp,targetName,skillName,(not skillInfo.toggleSkill and duration or nil),isDebuff,skillInfo.icon,initiatorName,(not isDebuff or skillInfo.bb));
	end
  
	-- record all debuffs in CA
	if (isDebuff and skillInfo.ca) then
		combatData:Update(event_type.DEBUFF_APPLIED,timestamp,initiatorName,targetName,skillName,conflictingToggleTarget,conflictingToggleSkillName,(not skillInfo.toggleSkill and duration or nil));
	end
end

_G.parserControl = Turbine.UI.Control();
_G.parserControl.Update = function()
  local timestamp = Turbine.Engine.GetGameTime();

  while true do
    -- if there are no pending debuffs debuffs we can stop updating
    if (#pendingDebuffs.list == 0) then
      parserControl:SetWantsUpdates(false);
      break;
    end
    
    if (pendingDebuffs.list[1][1] <= timestamp) then
      local endTime = pendingDebuffs.list[1][1];
      local info = pendingDebuffs.list[1][2];
      
      pendingDebuffs:Remove(endTime,info);
      ApplyDebuff(endTime,info);
    else
      break;
    end
  end
end

--[[
	
	Helper methods to assist with temporary morale bubble detection
	
	This is quite complex as we associate log entries with effects (to ensure that if two players use bubbles
	at once, the lost temporary morale is associated to the correct player/skill).
	
	We need to detect the correct info if the morale bubble skill application appears in the log first or if
	it appears as an effect first, and lost temporary morale also needs to be correctly accounted even if it
	appears before or after the associated effect arrives.
	
	This is achieved via the use of several queues & timers.
	
]]--

function _G.DetermineBubbleInitiatorAndSkill(targetName)
	-- quickly sort all the active bubbles on this target by their active status & timestamp, and choose the oldest (first) active one	
	local possibleBubbles = {}
	for skillName,skillInfo in pairs(activeBubbles[targetName]) do
		for initiator,effectInfo in pairs(skillInfo) do
			table.insert(possibleBubbles,{effectInfo[1],effectInfo[3],initiator,skillName});
		end
	end
	table.sort(possibleBubbles,function (a,b) return (a[2] and not b[2]) or (a[2] == b[2] and (a[1] < b[1] or (a[1] == b[1] and a[3] < b[3]))) end);
	initiatorName = possibleBubbles[1][3];
	skillName = possibleBubbles[1][4];
	-- return the extracted info
	return initiatorName,skillName;
end

function _G.NotifyPendingTempMorale(targetName)
	if (recentTempMorale[targetName] == nil) then return end
	local initiatorName,skillName = DetermineBubbleInitiatorAndSkill(targetName);
	
	-- perform a temporary morale update with the extracted info for each pending temporary morale item
	local index = 1;
	while true do
		if (index > #recentTempMorale[targetName]) then break end
		
		local tempMoraleInfo = recentTempMorale[targetName][index];
		if (not tempMoraleInfo[2]) then
			combatData:Update(event_type.TEMP_MORALE_LOST,tempMoraleInfo[1],initiatorName,targetName,skillName,tempMoraleInfo[3],tempMoraleInfo[4]);
			-- if it has already been determined whether or not this heal was wasted, then it can now be removed from the list
			if (tempMoraleInfo[4] ~= nil) then
				table.remove(recentTempMorale[targetName],index);
				index = index-1;
			else
				recentTempMorale[targetName][index][2] = {initiatorName,skillName};
			end
		end
		
		index = index+1;
	end
end

function _G.RemoveRecentTempMoraleLost(timestamp,amount)
	-- if a temp morale lost line cannot be assigned to an effect and assigned to a temp morale lost
	--   line within the time limit, take no further action (ignore it or assume it was wasted respectively)
	for index,tempMoraleInfo in ipairs(recentTempMorale) do
		if (tempMoraleInfo[1] == timestamp and tempMoraleInfo[3] == amount) then
			table.remove(recentTempMorale,index);
			return;
		end
	end
end

function _G.CheckMoraleBubble(timestamp,targetName,logName,initiatorName,wasHeal)
	local effectName = tempMoraleSkills[logName];
	if (effectName == nil) then return end
	
	-- send through an update (type = heal, amount = 0, crit type = none) so #attacks gets incremented by one (do this
	--   even if no effect gets created so that clever users will be able to notice that a bubble has been wasted)
	if (not wasHeal) then
		combatData:Update(event_type.HEAL,timestamp,initiatorName,targetName,logName,0,1);
	end
	
	local effectNames = tempMoraleSkills[logName];
	if (effectNames == nil) then return end
	
	-- quickly sort the pending log list by timestamp, and choose the oldest (first) one
	if (bubblesE[targetName] ~= nil) then
		for effectName,_ in pairs(effectNames) do
			-- if an effect already exists for this bubble, remove it and store an active bubble instead
			if (bubblesE[targetName][effectName] ~= nil) then
				-- record the bubble as active
				if (activeBubbles[targetName] == nil) then activeBubbles[targetName] = {} end
				if (activeBubbles[targetName][logName] == nil) then activeBubbles[targetName][logName] = {} end
				activeBubbles[targetName][logName][initiatorName] = {timestamp,bubblesE[targetName][effectName],true};
				-- remove effect from the pending temp morale effects table
				bubblesE[targetName][effectName] = nil;
				if (next(bubblesE[targetName]) == nil) then bubblesE[targetName] = nil end
				-- ensure any pending temporary morale lost entries are updated
				NotifyPendingTempMorale(targetName);
				
				return;
			end
		end
	end
	
	-- otherwise, temporarily store the log effect (to see if an event is created later)
	if (bubblesL[targetName] == nil) then bubblesL[targetName] = {} end
	if (bubblesL[targetName][logName] == nil) then bubblesL[targetName][logName] = {} end
	bubblesL[targetName][logName][initiatorName] = timestamp;
	-- create timer to remove 
	Misc.StartTimer({targetName,logName,initiatorName},timestamp,logDelay,RemovePendingLogBubble);
end

function _G.RemovePendingLogBubble(timestamp,target)
	local targetName = target[1];
	local logName = target[2];
	local initiatorName = target[3];
	
	-- check to see if the log item is still pending
	if (bubblesL[targetName] == nil or bubblesL[targetName][logName] == nil or bubblesL[targetName][logName][initiatorName] ~= timestamp) then return end
	
	-- remove effect from the pending temp morale log list table
	bubblesL[targetName][logName][initiatorName] = nil;
	if (next(bubblesL[targetName][logName]) == nil) then bubblesL[targetName][logName] = nil end
	if (next(bubblesL[targetName]) == nil) then bubblesL[targetName] = nil end
end
