
--[[

Restore Summary Data includes a summary of 
Heal, Power, and Buff info.

Restore Summary Data specifies data for a
target-skill pair (may be totals/all skills),
but this info is not stored directly.

]]--

_G.RestoreSummaryData = class();

function RestoreSummaryData:Constructor(terminated,dontRecordApplications)
	self.healData = HealData();
	self.healNonCritData = HealData();
	self.healCritData = HealData();
	self.healDevData = HealData();
	self.healAllCritData = HealData();
	
	self.powerData = PowerData();
	self.powerNonCritData = PowerData();
	self.powerCritData = PowerData();
	self.powerDevData = PowerData();
	self.powerAllCritData = PowerData();
	
	self.buffData = BuffData(terminated,dontRecordApplications);
	
end

function RestoreSummaryData:Update(updateType,var1,var2,var3)
	if updateType == 3 then
		self.healData:Update(var1,var2);
		
		if (var2 == 2) then
			self.healCritData:Update(var1,var2);
			self.healAllCritData:Update(var1,var2);
		elseif (var2 == 3) then
			self.healDevData:Update(var1,var2);
			self.healAllCritData:Update(var1,var2);
		elseif (var2 == 1) then
			self.healNonCritData:Update(var1,var2);
		end
		
	elseif updateType == 4 then
		self.powerData:Update(var1,var2);
		
		if (var2 == 2) then
			self.powerCritData:Update(var1,var2);
			self.powerAllCritData:Update(var1,var2);
		elseif (var2 == 3) then
			self.powerDevData:Update(var1,var2);
			self.powerAllCritData:Update(var1,var2);
		elseif (var2 == 1) then
			self.powerNonCritData:Update(var1,var2);
		end
		
	elseif updateType == 6 then
		self.buffData:Update(var1,var2,var3);
	elseif updateType == 14 then
		self.healData:UpdateTemporaryMorale(var1,var2);
	elseif updateType == 15 then
		self.healData:UpdateWastedTemporaryMorale(var1);
	end
end

function RestoreSummaryData:GetState(timestamp,buffDataOnly)
	if (buffDataOnly) then return self.buffData:GetState(timestamp) end
	
	local state = {}
	
	if (not self.healData.empty) then state["allHealData"] = self.healData:GetState() end
	if (not self.healNonCritData.empty) then state["nonCritHealData"] = self.healNonCritData:GetState() end
	if (not self.healCritData.empty) then state["critHealData"] = self.healCritData:GetState() end
	if (not self.healDevData.empty) then state["devHealData"] = self.healDevData:GetState() end
	
	if (not self.powerData.empty) then state["allPowerData"] = self.powerData:GetState() end
	if (not self.powerNonCritData.empty) then state["nonCritPowerData"] = self.powerNonCritData:GetState() end
	if (not self.powerCritData.empty) then state["critPowerData"] = self.powerCritData:GetState() end
	if (not self.powerDevData.empty) then state["devPowerData"] = self.powerDevData:GetState() end
	
	if (not self.buffData.empty) then state["buffData"] = self.buffData:GetState(timestamp) end

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

function RestoreSummaryData.CombineStates(state1,state2,buffDataOnly,state1BuffDataOnly)
	if (buffDataOnly == nil or buffDataOnly == false) then
		CombineEntry("allHealData",HealData,state1,state2);
		CombineEntry("nonCritHealData",HealData,state1,state2);
		CombineEntry("critHealData",HealData,state1,state2);
		CombineEntry("devHealData",HealData,state1,state2);
		
		CombineEntry("allPowerData",PowerData,state1,state2);
		CombineEntry("nonCritPowerData",PowerData,state1,state2);
		CombineEntry("critPowerData",PowerData,state1,state2);
		CombineEntry("devPowerData",PowerData,state1,state2);
	end
	
	if (buffDataOnly == nil) then
		CombineEntry("buffData",BuffData,state1,state2);
	elseif (buffDataOnly == true) then
		local buffData = (state1BuffDataOnly and state1 or state1["buffData"]);
		if (buffData ~= nil and next(buffData) ~= nil) then
			BuffData.CombineStates(buffData,state2);
		elseif (state1BuffDataOnly) then
			-- copy state2 into state1
			Misc.TableCopy(state2,state1);
		else
			state1["buffData"] = Misc.TableCopy(state2);
		end
	end
end

function RestoreSummaryData.RestoreState(state)
	local restoreSummData = RestoreSummaryData(true);
	
	if (state["allHealData"] ~= nil) then restoreSummData.healData = HealData.RestoreState(state["allHealData"]) end
	if (state["nonCritHealData"] ~= nil) then restoreSummData.healNonCritData = HealData.RestoreState(state["nonCritHealData"]) end
	
	if (state["critHealData"] ~= nil and state["devHealData"] ~= nil) then
		restoreSummData.healCritData = HealData.RestoreState(state["critHealData"]);
		restoreSummData.healDevData = HealData.RestoreState(state["devHealData"]);
		
		HealData.CombineStates(state["critHealData"],state["devHealData"])
		restoreSummData.healAllCritData = HealData.RestoreState(state["critHealData"]);
	elseif(state["critHealData"] ~= nil) then
		restoreSummData.healCritData = HealData.RestoreState(state["critHealData"]);
		restoreSummData.healAllCritData = HealData.RestoreState(state["critHealData"]);
	elseif (state["devHealData"] ~= nil) then
		restoreSummData.healDevData = HealData.RestoreState(state["devHealData"]);
		restoreSummData.healAllCritData = HealData.RestoreState(state["devHealData"]);
	end
	
	
	if (state["allPowerData"] ~= nil) then restoreSummData.powerData = PowerData.RestoreState(state["allPowerData"]) end
	if (state["nonCritPowerData"] ~= nil) then restoreSummData.powerNonCritData = PowerData.RestoreState(state["nonCritPowerData"]) end
	
	if (state["critPowerData"] ~= nil and state["devPowerData"] ~= nil) then
		restoreSummData.powerCritData = PowerData.RestoreState(state["critPowerData"]);
		restoreSummData.powerDevData = PowerData.RestoreState(state["devPowerData"]);
		
		PowerData.CombineStates(state["critPowerData"],state["devPowerData"])
		restoreSummData.powerAllCritData = PowerData.RestoreState(state["critPowerData"]);
	elseif(state["critPowerData"] ~= nil) then
		restoreSummData.powerCritData = PowerData.RestoreState(state["critPowerData"]);
		restoreSummData.powerAllCritData = PowerData.RestoreState(state["critPowerData"]);
	elseif (state["devPowerData"] ~= nil) then
		restoreSummData.powerDevData = PowerData.RestoreState(state["devPowerData"]);
		restoreSummData.powerAllCritData = PowerData.RestoreState(state["devPowerData"]);
	end
	
	
	if (state["buffData"] ~= nil) then restoreSummData.buffData = BuffData.RestoreState(state["buffData"]) end
	
	return restoreSummData;
end

