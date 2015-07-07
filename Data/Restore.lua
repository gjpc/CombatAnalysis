
--[[

The Restore class contains all summary data
relating to a Restore.

Summary data is stored for each player-skill
combination (including totals).

]]--

_G.Restore = class();

function Restore:Constructor(gameStartTime,restoreName)
	self.gameStartTime = gameStartTime;
	self.duration = 0;
	self.oldDuration = 0;
	self.alive = true;
	self.terminated = false;
	
	self.restoreName = restoreName;
	
	self.players = { {RestoreSummaryData()} };
	
end

-- Returns the restores duration. The totals restores may have a total duration
--   "so far" as well as a current running time. 
function Restore:Duration(timestamp)
	if (self.alive and not self.terminated) then
		return self.duration + (timestamp-self.gameStartTime);
	else
		return (self.alive and self.duration or math.max(self.duration,combatData.minDuration));
	end
end

function Restore:Update(updateType,timestamp,playerName,skillName,var1,var2,var3,var4)
	if (self.players[playerName] == nil) then
		self.players[playerName] = {RestoreSummaryData(self.terminated)};
	end
  
	if (self.players[playerName][skillName] == nil) then
		self.players[playerName][skillName] = RestoreSummaryData(self.terminated,(buffs[skillName] ~= nil and buffs[skillName].isStance));
	end
	
	if (updateType == 6) then
		self.players[playerName][skillName]:Update(updateType,timestamp,var1,var2);
	else
		self.players[playerName][skillName]:Update(updateType,var1,var2,var3,var4);
		self.players[playerName][1]:Update(updateType,var1,var2,var3,var4);
	end
	
	-- running totals
	if (updateType == 3 or updateType == 14) then
		self.players[1][1].healData.amount = self.players[1][1].healData.amount+var1;
		self.players[1][1].healData.attacks = self.players[1][1].healData.attacks+1;
	elseif (updateType == 4) then
		self.players[1][1].powerData.amount = self.players[1][1].powerData.amount+var1;
		self.players[1][1].powerData.attacks = self.players[1][1].powerData.attacks+1;
	end
end

function Restore:ResetBuffs()
	if (self.players[player.name] ~= nil) then
		for _,restoreSummData in pairs(self.players[player.name]) do
			restoreSummData.buffData:Reset();
		end
	end
end

function Restore:GetAllPlayerData(dataType)
	local data = {}
	for playerName,playerData in pairs(self.players) do
		data[playerName] = playerData[1][dataType.."Data"];
	end
	return data;
end

function Restore:GetPlayerData(player,dataType,includeTotals)
	if (self.players[player] == nil) then return {} end
	
	local data = {}
	for skillName,playerData in pairs(self.players[player]) do
		if (includeTotals or type(skillName) == "string") then
			data[skillName] = playerData[dataType.."Data"];
		end
	end
	return data;
end

function Restore:GetState(timestamp,buffDataOnly)
	-- get the state of each player data element
	local playerStates = {}
	for playerName,playerInfo in pairs(self.players) do
		if (playerName ~= 1) then
			playerStates[playerName] = {}
			
			for skillName,skillData in pairs(playerInfo) do
				if (skillName ~= 1 and (not buffDataOnly or not skillData.buffData.empty)) then
					playerStates[playerName][skillName] = skillData:GetState(timestamp,buffDataOnly);
				end
			end
			
			if (next(playerStates[playerName]) == nil) then playerStates[playerName] = nil end
		end
	end
	
	-- name, duration, player states
	if (buffDataOnly) then
		return playerStates;
	else
		return { ["restoreName"] = self.restoreName, ["duration"] = self.duration+(self.alive and not self.terminated and (timestamp-self.gameStartTime) or 0), ["restoreData"] = playerStates};
	end
end

function Restore.CombineStates(state1,state2,buffDataOnly,state1BuffDataOnly)
	if (buffDataOnly == nil) then
		state1["duration"] = state1["duration"] + state2["duration"];
	end
	
	local state1PlayerData = (state1BuffDataOnly and state1 or state1["restoreData"]);
	local state2PlayerData = (buffDataOnly and state2 or state2["restoreData"]);
	
	for playerName,state2PlayerState in pairs(state2PlayerData) do
		if (state1PlayerData[playerName] == nil) then
			state1PlayerData[playerName] = {}
		end
		
		for skillName,state2SkillState in pairs(state2PlayerState) do
			if (state1PlayerData[playerName][skillName] == nil) then
				state1PlayerData[playerName][skillName] = {}
			end
			
			RestoreSummaryData.CombineStates(state1PlayerData[playerName][skillName],state2SkillState,buffDataOnly,state1BuffDataOnly);
		end
	end
end

function Restore.RestoreState(state,alive)
	local restore = Restore(Turbine.Engine.GetGameTime(),state["restoreName"]);
	
	restore.duration = state["duration"];
	
	restore.alive = (alive == true);
	restore.terminated = true;
	restore.oldDuration = restore.duration;
	
	for playerName,playerState in pairs(state["restoreData"]) do
		restore.players[playerName] = { RestoreSummaryData() }
		
		local totalsState = {};
		for skillName,skillState in pairs(playerState) do
			restore.players[playerName][skillName] = RestoreSummaryData.RestoreState(skillState);
			-- update player totals
			RestoreSummaryData.CombineStates(totalsState,skillState);
		end
		restore.players[playerName][1] = RestoreSummaryData.RestoreState(totalsState);
		
		-- update all player running totals
		restore.players[1][1].healData.amount = restore.players[1][1].healData.amount+restore.players[playerName][1].healData.amount;
		restore.players[1][1].healData.attacks = restore.players[1][1].healData.attacks+restore.players[playerName][1].healData.attacks;
		restore.players[1][1].powerData.amount = restore.players[1][1].powerData.amount+restore.players[playerName][1].powerData.amount;
		restore.players[1][1].powerData.attacks = restore.players[1][1].powerData.attacks+restore.players[playerName][1].powerData.attacks;
	end
	
	return restore;
end

