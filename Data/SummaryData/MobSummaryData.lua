
--[[

Mob Summary Data includes a summary of 
Dmg, Taken, and Debuff info.

Restore Summary Data specifies data for a
target-skill pair (may be totals/all skills),
but this info is not stored directly.

]]--

_G.MobSummaryData = class();

function MobSummaryData:Constructor()
	self.dmgData = DmgData();
	self.dmgNonCritData = DmgData();
	self.dmgPartialData = DmgData();
	self.dmgCritData = DmgData();
	self.dmgDevData = DmgData();
	self.dmgAllCritData = DmgData();
	
	self.takenData = TakenData();
	self.takenNonCritData = TakenData();
	self.takenPartialData = TakenData();
	self.takenCritData = TakenData();
	self.takenDevData = TakenData();
	self.takenAllCritData = TakenData();
	
	self.debuffData = DebuffData();
end

function MobSummaryData:Update(updateType,var1,var2,var3,var4,var5)
	if updateType == 1 then
		self.dmgData:Update(var1,var2,var3,var4);
		
		if (var3 == 2) then
			self.dmgCritData:Update(var1,var2,var3,var4);
			self.dmgAllCritData:Update(var1,var2,var3,var4);
		elseif (var3 == 3) then
			self.dmgDevData:Update(var1,var2,var3,var4);
			self.dmgAllCritData:Update(var1,var2,var3,var4);
		elseif (var2 == 1) then
			self.dmgNonCritData:Update(var1,var2,var3,var4);
		end
		
		if (var2 >= 8 and var2 <= 10) then
			self.dmgPartialData:Update(var1,var2,var3,var4);
		end
		
	elseif updateType == 2 then
		self.takenData:Update(var1,var2,var3,var4);
		
		if (var3 == 2) then
			self.takenCritData:Update(var1,var2,var3,var4);
			self.takenAllCritData:Update(var1,var2,var3,var4);
		elseif (var3 == 3) then
			self.takenDevData:Update(var1,var2,var3,var4);
			self.takenAllCritData:Update(var1,var2,var3,var4);
		elseif (var2 == 1) then
			self.takenNonCritData:Update(var1,var2,var3,var4);
		end
		
		if (var2 >= 8 and var2 <= 10) then
			self.takenPartialData:Update(var1,var2,var3,var4);
		end
		
	elseif updateType == 5 then
		self.debuffData:Update(var1,var2,var3,var4,var5);
	elseif updateType == 7 then
		self.dmgData.interrupts = self.dmgData.interrupts + 1;
	elseif updateType == 8 then
		self.dmgData.corruptions = self.dmgData.corruptions + 1;
	elseif updateType == 13 then
		self.takenData.interrupts = self.takenData.interrupts + 1;
	end
end


function MobSummaryData:GetState(timestamp,debuffDataOnly)
	if (debuffDataOnly) then return self.debuffData:GetState(timestamp) end
	
	local state = {}
	
	if (not self.dmgData.empty) then state["allDmgData"] = self.dmgData:GetState() end
	if (not self.dmgNonCritData.empty) then state["nonCritDmgData"] = self.dmgNonCritData:GetState() end
	if (not self.dmgPartialData.empty) then state["partialDmgData"] = self.dmgPartialData:GetState() end
	if (not self.dmgCritData.empty) then state["critDmgData"] = self.dmgCritData:GetState() end
	if (not self.dmgDevData.empty) then state["devDmgData"] = self.dmgDevData:GetState() end
	
	if (not self.takenData.empty) then state["allTakenData"] = self.takenData:GetState() end
	if (not self.takenNonCritData.empty) then state["nonCritTakenData"] = self.takenNonCritData:GetState() end
	if (not self.takenPartialData.empty) then state["partialTakenData"] = self.takenPartialData:GetState() end
	if (not self.takenCritData.empty) then state["critTakenData"] = self.takenCritData:GetState() end
	if (not self.takenDevData.empty) then state["devTakenData"] = self.takenDevData:GetState() end
	
	if (not self.debuffData.empty) then state["debuffData"] = self.debuffData:GetState(timestamp) end
	
	return state;
end

local function CombineEntry(entryName,EntryType,state1,state2)
	if (state2[entryName] ~= nil) then
		if (state1[entryName] ~= nil) then
			EntryType.CombineStates(state1[entryName],state2[entryName]);
		else
			state1[entryName] = Misc.TableCopy(state2[entryName]);
		end
	end
end

function MobSummaryData.CombineStates(state1,state2,debuffDataOnly,state1DebuffDataOnly)
	if (debuffDataOnly == nil or debuffDataOnly == false) then
		CombineEntry("allDmgData",DmgData,state1,state2);
		CombineEntry("nonCritDmgData",DmgData,state1,state2);
		CombineEntry("partialDmgData",DmgData,state1,state2);
		CombineEntry("critDmgData",DmgData,state1,state2);
		CombineEntry("devDmgData",DmgData,state1,state2);
		
		CombineEntry("allTakenData",TakenData,state1,state2);
		CombineEntry("nonCritTakenData",TakenData,state1,state2);
		CombineEntry("partialTakenData",TakenData,state1,state2);
		CombineEntry("critTakenData",TakenData,state1,state2);
		CombineEntry("devTakenData",TakenData,state1,state2);
	end
	
	if (debuffDataOnly == nil) then
		CombineEntry("debuffData",DebuffData,state1,state2);
	elseif (debuffDataOnly == true) then
		local debuffData = (state1DebuffDataOnly and state1 or state1["debuffData"]);
		if (debuffData ~= nil and next(debuffData) ~= nil) then
			DebuffData.CombineStates(debuffData,state2);
		elseif (state1DebuffDataOnly) then
			-- copy state 2 into state1
			Misc.TableCopy(state2,state1);
		else
			state1["debuffData"] = Misc.TableCopy(state2);
		end
	end
end

function MobSummaryData.RestoreState(state)
	local mobSummData = MobSummaryData();
	
	if (state["allDmgData"] ~= nil) then mobSummData.dmgData = DmgData.RestoreState(state["allDmgData"]) end
	if (state["nonCritDmgData"] ~= nil) then mobSummData.dmgNonCritData = DmgData.RestoreState(state["nonCritDmgData"]) end
	if (state["partialDmgData"] ~= nil) then mobSummData.dmgPartialData = DmgData.RestoreState(state["partialDmgData"]) end
	
	if (state["critDmgData"] ~= nil and state["devDmgData"] ~= nil) then
		mobSummData.dmgCritData = DmgData.RestoreState(state["critDmgData"]);
		mobSummData.dmgDevData = DmgData.RestoreState(state["devDmgData"]);
		
		DmgData.CombineStates(state["critDmgData"],state["devDmgData"])
		mobSummData.dmgAllCritData = DmgData.RestoreState(state["critDmgData"]);
	elseif(state["critDmgData"] ~= nil) then
		mobSummData.dmgCritData = DmgData.RestoreState(state["critDmgData"]);
		mobSummData.dmgAllCritData = DmgData.RestoreState(state["critDmgData"]);
	elseif (state["devDmgData"] ~= nil) then
		mobSummData.dmgDevData = DmgData.RestoreState(state["devDmgData"]);
		mobSummData.dmgAllCritData = DmgData.RestoreState(state["devDmgData"]);
	end
	
	
	if (state["allTakenData"] ~= nil) then mobSummData.takenData = TakenData.RestoreState(state["allTakenData"]) end
	if (state["nonCritTakenData"] ~= nil) then mobSummData.takenNonCritData = TakenData.RestoreState(state["nonCritTakenData"]) end
	if (state["partialTakenData"] ~= nil) then mobSummData.takenPartialData = TakenData.RestoreState(state["partialTakenData"]) end
	
	if (state["critTakenData"] ~= nil and state["devTakenData"] ~= nil) then
		mobSummData.takenCritData = TakenData.RestoreState(state["critTakenData"]);
		mobSummData.takenDevData = TakenData.RestoreState(state["devTakenData"]);
		
		TakenData.CombineStates(state["critTakenData"],state["devTakenData"])
		mobSummData.takenAllCritData = TakenData.RestoreState(state["critTakenData"]);
	elseif(state["critTakenData"] ~= nil) then
		mobSummData.takenCritData = TakenData.RestoreState(state["critTakenData"]);
		mobSummData.takenAllCritData = TakenData.RestoreState(state["critTakenData"]);
	elseif (state["devTakenData"] ~= nil) then
		mobSummData.takenDevData = TakenData.RestoreState(state["devTakenData"]);
		mobSummData.takenAllCritData = TakenData.RestoreState(state["devTakenData"]);
	end
	
	
	if (state["debuffData"] ~= nil) then mobSummData.debuffData = DebuffData.RestoreState(state["debuffData"]) end
	
	return mobSummData;
end
