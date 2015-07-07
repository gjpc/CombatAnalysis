
--[[

The Mob class contains all summary data
relating to a Mob.

Summary data is stored for each player-skill
combination (including totals).

]]--

_G.Mob = class();

function Mob:Constructor(gameStartTime,mobName)
	self.gameStartTime = gameStartTime;
	self.duration = 0;
	self.oldDuration = 0;
	self.alive = true;
	self.deathTime = nil;
	self.finishTime = nil;
	self.terminated = false;
	
	self.mobName = mobName;
	
	self.players = {{MobSummaryData()}};
	
end

-- Returns the mobs duration. The totals mob may have a total duration
--   "so far" as well as a current running time.
function Mob:Duration(timestamp)
	if (self.alive and not self.terminated) then
		return self.duration + (timestamp-self.gameStartTime);
	else
		return (self.alive and self.duration or math.max(self.duration,combatData.minDuration));
	end
end

function Mob:Update(updateType,timestamp,playerName,skillName,var1,var2,var3,var4)
	if (self.players[playerName] == nil) then
		self.players[playerName] = { MobSummaryData() };
	end
	
	if (updateType < 7) then
		if (self.players[playerName][skillName] == nil) then
			self.players[playerName][skillName] = MobSummaryData();
		end
		
		-- special case: debuff application (terminate any other debuffs that may have been overridden)
		if (updateType == 5) then
      local skillInfo = debuffs[skillName];
			-- clear any conflicting debuffs that may currently be on the mob
			if (debuffs[skillName].overwrites ~= nil) then
				for _,conflictingSkill in ipairs(debuffs[skillName].overwrites) do
          local conflictIsToggle = debuffs[conflictingSkill].toggleSkill;
          if (not debuffs[conflictingSkill].removalOnly and ((skillInfo.toggleSkill and conflictIsToggle) or (not skillInfo.toggleSkill and not conflictIsToggle))) then
            local mobSummData = self.players[playerName][conflictingSkill];
            if (mobSummData ~= nil) then mobSummData.debuffData:TerminateDebuff(timestamp,conflictingSkill,var1) end
          end
				end
			end
			-- don't record remover skills
			if (skillInfo.removalOnly) then return end
			
			self.players[playerName][skillName]:Update(updateType,timestamp,var2,skillName,var1,var3);
		else
			self.players[playerName][skillName]:Update(updateType,var1,var2,var3,var4);
		end
		
	end
	
	if (updateType ~= 5) then
		self.players[playerName][1]:Update(updateType,var1,var2,var3,var4);
	end
	
	-- running totals
	if (updateType == 1) then
		self.players[1][1].dmgData.amount = self.players[1][1].dmgData.amount+var1;
		self.players[1][1].dmgData.attacks = self.players[1][1].dmgData.attacks+1;
	elseif (updateType == 2) then
		self.players[1][1].takenData.amount = self.players[1][1].takenData.amount+var1;
		self.players[1][1].takenData.attacks = self.players[1][1].takenData.attacks+1;
	end
end

function Mob:ResetDebuffs()
	if (self.players[player.name] ~= nil) then
		for _,mobSummData in pairs(self.players[player.name]) do
			mobSummData.debuffData:Reset();
		end
	end
end

function Mob:GetAllPlayerData(dataType)
	local data = {}
	for playerName,playerData in pairs(self.players) do
		data[playerName] = playerData[1][dataType.."Data"];
	end
	
	return data;
end

function Mob:GetPlayerData(player,dataType,includeTotals)
	if (self.players[player] == nil) then return {} end
	
	local data = {}
	for skillName,playerData in pairs(self.players[player]) do
		if (includeTotals or type(skillName) == "string") then
			data[skillName] = playerData[dataType.."Data"];
		end
	end
	return data;
end

function Mob:GetState(timestamp,debuffDataOnly)
	-- get the state of each player data element (excluding totals)
	local playerStates = {}
	for playerName,playerInfo in pairs(self.players) do
		if (playerName ~= 1) then
			playerStates[playerName] = {}
			
			for skillName,skillData in pairs(playerInfo) do
				if (skillName ~= 1 and (not debuffDataOnly or not skillData.debuffData.empty)) then
					playerStates[playerName][skillName] = skillData:GetState(timestamp,debuffDataOnly);
				end
			end
			
			if (next(playerStates[playerName]) == nil) then playerStates[playerName] = nil end
		end
	end
	
	-- name, duration, player states
	if (debuffDataOnly) then
		return playerStates;
	else
		return { ["mobName"] = self.mobName, ["duration"] = self.duration+(self.alive and not self.terminated and (timestamp-self.gameStartTime) or 0), ["mobData"] = playerStates };
	end
end

function Mob.CombineStates(state1,state2,debuffDataOnly,state1DebuffDataOnly)
	if (debuffDataOnly == nil) then
		state1["duration"] = state1["duration"] + state2["duration"];
	end
	
	local state1PlayerData = (state1DebuffDataOnly and state1 or state1["mobData"]);
	local state2PlayerData = (debuffDataOnly and state2 or state2["mobData"]);
	
	for playerName,state2PlayerState in pairs(state2PlayerData) do
		if (state1PlayerData[playerName] == nil) then
			state1PlayerData[playerName] = {}
		end
		
		for skillName,state2SkillState in pairs(state2PlayerState) do
			if (state1PlayerData[playerName][skillName] == nil) then
				state1PlayerData[playerName][skillName] = {}
			end
			
			MobSummaryData.CombineStates(state1PlayerData[playerName][skillName],state2SkillState,debuffDataOnly,state1DebuffDataOnly);
		end
	end
end

function Mob.RestoreState(state,alive)
	local mob = Mob(Turbine.Engine.GetGameTime(),state["mobName"]);
	
	mob.duration = state["duration"];
	
	mob.alive = (alive == true);
	mob.finishTime = 0;
	mob.terminated = true;
	mob.oldDuration = mob.duration;
	
	for playerName,playerState in pairs(state["mobData"]) do
		mob.players[playerName] = { MobSummaryData() }
		
		local totalsState = {};
		for skillName,skillState in pairs(playerState) do
			mob.players[playerName][skillName] = MobSummaryData.RestoreState(skillState);
			
			-- update player totals
			MobSummaryData.CombineStates(totalsState,skillState);
		end
		mob.players[playerName][1] = MobSummaryData.RestoreState(totalsState);
		
		-- update all player running totals
		mob.players[1][1].dmgData.amount = mob.players[1][1].dmgData.amount+mob.players[playerName][1].dmgData.amount;
		mob.players[1][1].dmgData.attacks = mob.players[1][1].dmgData.attacks+mob.players[playerName][1].dmgData.attacks;
		mob.players[1][1].takenData.amount = mob.players[1][1].takenData.amount+mob.players[playerName][1].takenData.amount;
		mob.players[1][1].takenData.attacks = mob.players[1][1].takenData.attacks+mob.players[playerName][1].takenData.attacks;
	end
	
	return mob;
end
