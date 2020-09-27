
--[[

Extracts the Player instance, and sets up some player
specific functions, such as detecting combat entry/exit.

]]--

_G.player = Turbine.Gameplay.LocalPlayer.GetInstance();

player.name = player:GetName();

-- extract class
player.class = player:GetClass();
for className,classId in pairs(Turbine.Gameplay.Class) do
	if player.class == classId then
		player.class = className;
	end
end

-- fix for warden bug (still needed?)
if player.class == 194 then
	player.class = "Warden";
elseif player.class == nil then
	player.class = "Unknown";
end

player.isCreep = (player.class == "BlackArrow" or player.class == "Defiler" or player.class == "Reaver" or player.class == "Stalker" or player.class == "WarLeader" or player.class == "Weaver");

-- extract player effects
player.effects = player:GetEffects();

-- a function to initialize the running buffs list with the buffs currently on the player
function _G.InitializeRunningBuffs()
	for i=1,player.effects:GetCount() do
		local effect = player.effects:Get(i);
		
		if (printDebug) then
		  Turbine.Shell.WriteLine( tostring(player.class)..","..tostring(effect:GetName()) );
		end
		
		local targetName = player.name;
		local effectName = effect:GetName();
		
		if (buffApplications[effectName] ~= nil) then
      if (printDebug) then
        Turbine.Shell.WriteLine("buff track > "..tostring(6)..","..tostring(Turbine.Engine.GetGameTime())..","..tostring(targetName)..","..tostring(effectName));
      end
      
      if (buffs[effectName].stacking) then
        -- have to assume we are starting from zero stacking
        effect.stackName = buffs[effectName].stacking[1];
      end
      
      combatData.runningBuffs:Applied(targetName,effect,buffApplications[effectName]);
    end
	end
end


-- track combat state changes

Misc.AddCallback(player,"InCombatChanged",function()
	local inCombat = player:IsInCombat();
	-- send combat state change update
	combatData:Update(inCombat and event_type.COMBAT_START or event_type.COMBAT_END,Turbine.Engine.GetGameTime(),player.name);
	-- if we just exited combat, clear all pending & running debuffs
	if (not inCombat) then
    pendingDebuffs:Clear();
    combatData.runningDebuffs:Clear();
  end
end);


-- track temporary morale and other effects

-- added effect
Misc.AddCallback(player.effects,"EffectAdded",function(sender,args)
	local effect = player.effects:Get(args.Index);
	local timestamp = effect:GetStartTime();
	
	local targetName = player.name;
	local effectName = effect:GetName();
  
	-- 1) Check if this is a tracked effect
	local skillInfo = buffApplications[effectName];
  
	if (skillInfo ~= nil) then
		if (printDebug) then
			Turbine.Shell.WriteLine("buff track > "..tostring(6)..","..tostring(timestamp)..","..tostring(targetName)..","..tostring(effectName));
		end
		
    -- do some additional work if this is a stacking buff
    local stackingBuffName;
    local buffInfo = buffs[effectName];
    if (buffInfo ~= nil and buffInfo.stacking) then
      local stackingBuffs = buffInfo.stacking;
      
      -- find how far through the stack we currently are
      if (combatData.runningBuffs.buffs[targetName] ~= nil) then
        for buff,buffInfo in pairs(combatData.runningBuffs.buffs[targetName]) do
          if (buff:GetName() == effectName) then
            for i=1,#stackingBuffs do
              if (stackingBuffs[i] == buff.stackName) then
                effect.stackName = stackingBuffs[math.min(i+1,#stackingBuffs)];
                stackingBuffName = effect.stackName;
                break;
              end
            end
            break;
          end
        end
      end
      -- the skill isn't currently applied
      if (effect.stackName == nil) then
        effect.stackName = stackingBuffs[1];
        stackingBuffName = effect.stackName;
      end
    end
    
		combatData.runningBuffs:Applied(targetName,effect,buffApplications[effect:GetName()]);
    for skillName,_ in pairs(buffApplications[effectName]) do
      combatData:Update(6,(combatData.currentEncounter == nil and timestamp or math.max(combatData.currentEncounter.orderedMobs[1].gameStartTime,timestamp)),player.name,targetName,stackingBuffName or skillName,effect,true);
    end
	end
	
	-- 2) Check if this is a tracked temporary morale bubble effect
	local logNames = tempMoraleSkills[effectName];
	if (logNames == nil) then return end
	
	-- quickly sort the pending log list by timestamp, and choose the oldest (first) one
	local possibleLogEntries = {}
	if (bubblesL[targetName] ~= nil) then
		for logName,_ in pairs(logNames) do
			if (bubblesL[targetName][logName] ~= nil) then
				for initiatorName,logTimestamp in pairs(bubblesL[targetName][logName]) do
					table.insert(possibleLogEntries,{logTimestamp,initiatorName,logName});
				end
			end
		end
	end
	
	-- if a log entry already exists for this bubble, remove it and store an active bubble instead
	if (#possibleLogEntries > 0) then
		table.sort(possibleLogEntries,function (a,b) return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2]) end);
		timestamp = possibleLogEntries[1][1];
		local initiatorName = possibleLogEntries[1][2];
		local logName = possibleLogEntries[1][3];
		-- record the bubble as active
		if (activeBubbles[targetName] == nil) then activeBubbles[targetName] = {} end
		if (activeBubbles[targetName][logName] == nil) then activeBubbles[targetName][logName] = {} end
		activeBubbles[targetName][logName][initiatorName] = {timestamp,effect,true};
		-- remove effect from the pending temp morale log list table
		bubblesL[targetName][logName][initiatorName] = nil;
		if (next(bubblesL[targetName][logName]) == nil) then bubblesL[targetName][logName] = nil end
		if (next(bubblesL[targetName]) == nil) then bubblesL[targetName] = nil end
		-- ensure any pending temporary morale lost entries are updated
		NotifyPendingTempMorale(targetName);
		
	-- otherwise, temporarily store the effect (to see if a log entry is created later)
	else
		if (bubblesE[targetName] == nil) then bubblesE[targetName] = {} end
		bubblesE[targetName][effectName] = effect;
		-- create timer to remove 
		Misc.StartTimer({targetName,effectName,effect},timestamp,effectDelay,RemovePendingEffectBubble);
		
	end
end);

function _G.RemovePendingEffectBubble(timestamp,target)
	local targetName = target[1];
	local effectName = target[2];
	local effect = target[3];

	-- check to see if the effect is still pending
	if (bubblesE[targetName] == nil or bubblesE[targetName][effectName] ~= effect) then return end
	
	-- remove effect from the pending temp morale effects table
	bubblesE[targetName][effectName] = nil;
	if (next(bubblesE[targetName]) == nil) then bubblesE[targetName] = nil end
end

-- removed effect
Misc.AddCallback(player.effects,"EffectRemoved",function(sender,args)
	local effect = args.Effect;
	if (effect == nil) then return end
	
	local timestamp = Turbine.Engine.GetGameTime();
	local targetName = player.name;
	local effectName = effect:GetName();
  
	-- 1) Check if this is a tracked effect
	local skillInfo = buffApplications[effectName];
  
	if (skillInfo ~= nil) then
		if (printDebug) then
			Turbine.Shell.WriteLine("buff removed > "..tostring(targetName)..","..tostring(effectName));
		end
    
    -- do some additional work if this is a stacking buff
    local stackingBuffName;
    local buffInfo = buffs[effectName];
    if (buffInfo ~= nil and buffInfo.stacking ~= nil and effect.stackName ~= nil) then
      stackingBuffName = effect.stackName;
    end
    
		-- terminate combat data buffs
    for skillName,_ in pairs(buffApplications[effectName]) do
      combatData:TerminateBuff(timestamp,targetName,stackingBuffName or skillName,effect);
    end
		combatData.runningBuffs:Terminated(targetName,effect);
	end
	
	-- 2) Check if this is a tracked temporary morale bubble effect
	local logNames = tempMoraleSkills[effectName];
	if (logNames == nil or activeBubbles[targetName] == nil) then return end
	
	for logName,_ in pairs(logNames) do
		if (activeBubbles[targetName][logName] ~= nil) then
			-- remove effect from the active bubbles table
			for initiatorName,effectInfo in pairs(activeBubbles[targetName][logName]) do
				if (effect == effectInfo[2]) then
					effectInfo[3] = false;
					Misc.StartTimer({targetName,logName,initiatorName},timestamp,effectDelay,RemoveActiveBubble);
					
					return;
				end
			end
		end
	end
end);

function _G.RemoveActiveBubble(timestamp,target)
	local targetName = target[1];
	local logName = target[2];
	local initiatorName = target[3];
	
	-- check to see if the effect is still active
	if (activeBubbles[targetName] == nil or activeBubbles[targetName][logName] == nil or activeBubbles[targetName][logName][initiatorName] == nil) then return end
	
	-- remove effect from the active temp morale effects table
	activeBubbles[targetName][logName][initiatorName] = nil;
	if (next(activeBubbles[targetName][logName]) == nil) then activeBubbles[targetName][logName] = nil end
	if (next(activeBubbles[targetName]) == nil) then activeBubbles[targetName] = nil end
end


-- finally add the local player to the global list of players
table.insert(players,player);

