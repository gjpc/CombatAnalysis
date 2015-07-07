
--[[

The Abstract Base Class for all Dmg Type Summary Data.

This includes summary information for all
attacks, and other kind of events
such as interrupts, and corruption removals.

All Dmg Summary Data includes a count of various
avoid types, a list of damage amounts by type,
and of the number of interrupts which is updated
manually.

]]--

_G.DmgTypeSummaryData = abstract_class(StandardSummaryData);

function DmgTypeSummaryData:Constructor()
	StandardSummaryData.Constructor(self);
	
	self.misses = 0;
  self.deflects = 0;
	self.immunes = 0;
	self.resists = 0;
	
	self.blocks = 0;
	self.parrys = 0;
	self.evades = 0;
	
	self.pblocks = 0;
	self.pparrys = 0;
	self.pevades = 0;
	
	self.hits = 0;
	
	self.amountFullHits = 0;
	self.fullHits = 0;
	
	self.dmgTypes = {};
	
	self.interrupts = 0;
	
end

function DmgTypeSummaryData:Update(amount,avoidType,critType,dmgType)
	self.empty = false;
	
	StandardSummaryData.Update(self,amount,critType);
	
	if avoidType == 2 then
		self.misses = self.misses + 1;
		self.absorbs = self.absorbs - 1;
  elseif avoidType == 11 then
    self.deflects = self.deflects + 1;
    self.absorbs = self.absorbs - 1;
	elseif avoidType == 3 then
		self.immunes = self.immunes + 1;
		self.absorbs = self.absorbs - 1;
	elseif avoidType == 4 then
		self.resists = self.resists + 1;
		self.absorbs = self.absorbs - 1;
	elseif avoidType == 5 then
		self.blocks = self.blocks + 1;
		self.absorbs = self.absorbs - 1;
	elseif avoidType == 6 then
		self.parrys = self.parrys + 1;
		self.absorbs = self.absorbs - 1;
	elseif avoidType == 7 then
		self.evades = self.evades + 1;
		self.absorbs = self.absorbs - 1;
	elseif avoidType == 8 then
		self.pblocks = self.pblocks + 1;
		self.hits = self.hits + 1;
	elseif avoidType == 9 then
		self.pparrys = self.pparrys + 1;
		self.hits = self.hits + 1;
	elseif avoidType == 10 then
		self.pevades = self.pevades + 1;
		self.hits = self.hits + 1;
	elseif avoidType == 13 then
	  self.interrupts = self.interrupts + 1;
	else
		self.hits = self.hits + 1;
		
		self.amountFullHits = self.amountFullHits + amount;
		self.fullHits = self.fullHits + 1;
	end
	
	if (self.dmgTypes[dmgType] == nil) then
		self.dmgTypes[dmgType] = amount;
	else
		self.dmgTypes[dmgType] = self.dmgTypes[dmgType] + amount;
	end
	
end

function DmgTypeSummaryData:Average()
	return self.amount/(math.max(1,self.hits-self.absorbs));
end

function DmgTypeSummaryData:AverageFullHits()
	return self.amountFullHits/(math.max(1,self.fullHits-self.absorbs));
end

function DmgTypeSummaryData:CritPercentage()
	return self.crits/math.max(1,self.fullHits); -- partially avoided attacks cannot crit
end

function DmgTypeSummaryData:DevPercentage()
	return self.devs/math.max(1,self.fullHits); -- partially avoided attacks cannot dev
end

function DmgTypeSummaryData:CritOrDevPercentage()
	return (self.crits+self.devs)/math.max(1,self.fullHits);
end

function DmgTypeSummaryData:PhysicalAvoids()
	return self.blocks+self.parrys+self.evades+self.pblocks+self.pparrys+self.pevades;
end

function DmgTypeSummaryData:FullPhysicalAvoids()
	return self.blocks+self.parrys+self.evades;
end

function DmgTypeSummaryData:PartialAvoids()
	return self.pblocks+self.pparrys+self.pevades;
end

function DmgTypeSummaryData:GetState()
	local state = StandardSummaryData.GetState(self);
	
	if (self.misses > 0) then state["misses"] = self.misses end
  if (self.deflects > 0) then state["deflects"] = self.deflects end
	if (self.immunes > 0) then state["immunes"] = self.immunes end
	if (self.resists > 0) then state["resists"] = self.resists end
	
	if (self.blocks > 0) then state["blocks"] = self.blocks end
	if (self.parrys > 0) then state["parrys"] = self.parrys end
	if (self.evades > 0) then state["evades"] = self.evades end
	
	if (self.pblocks > 0) then state["pblocks"] = self.pblocks end
	if (self.pparrys > 0) then state["pparrys"] = self.pparrys end
	if (self.pevades > 0) then state["pevades"] = self.pevades end
	
	if (self.amountFullHits > 0) then state["amountFullHits"] = self.amountFullHits end
	
	local stateDmgTypes = {}
	for dmgType,amount in pairs(self.dmgTypes) do
		if (amount > 0) then stateDmgTypes[dmgType] = amount end
	end
	if (next(stateDmgTypes) ~= nil) then
		state["dmgTypes"] = stateDmgTypes;
	end
	
	if (self.interrupts > 0) then state["interrupts"] = self.interrupts end
	
	return state;
end

function DmgTypeSummaryData.CombineStates(state1,state2)
	StandardSummaryData.CombineStates(state1,state2);
	
	if (state1["misses"] or state2["misses"]) then state1["misses"] = (state1["misses"] or 0) + (state2["misses"] or 0) end
  if (state1["deflects"] or state2["deflects"]) then state1["deflects"] = (state1["deflects"] or 0) + (state2["deflects"] or 0) end
	if (state1["immunes"] or state2["immunes"]) then state1["immunes"] = (state1["immunes"] or 0) + (state2["immunes"] or 0) end
	if (state1["resists"] or state2["resists"]) then state1["resists"] = (state1["resists"] or 0) + (state2["resists"] or 0) end
	
	if (state1["blocks"] or state2["blocks"]) then state1["blocks"] = (state1["blocks"] or 0) + (state2["blocks"] or 0) end
	if (state1["parrys"] or state2["parrys"]) then state1["parrys"] = (state1["parrys"] or 0) + (state2["parrys"] or 0) end
	if (state1["evades"] or state2["evades"]) then state1["evades"] = (state1["evades"] or 0) + (state2["evades"] or 0) end
	
	if (state1["pblocks"] or state2["pblocks"]) then state1["pblocks"] = (state1["pblocks"] or 0) + (state2["pblocks"] or 0) end
	if (state1["pparrys"] or state2["pparrys"]) then state1["pparrys"] = (state1["pparrys"] or 0) + (state2["pparrys"] or 0) end
	if (state1["pevades"] or state2["pevades"]) then state1["pevades"] = (state1["pevades"] or 0) + (state2["pevades"] or 0) end
	
	if (state1["amountFullHits"] or state2["amountFullHits"]) then state1["amountFullHits"] = (state1["amountFullHits"] or 0) + (state2["amountFullHits"] or 0) end
	
	if (state1["dmgTypes"] or state2["dmgTypes"]) then 
		if (state1["dmgTypes"] == nil) then state1["dmgTypes"] = {} end
		local state2DmgTypes = (state2["dmgTypes"] or {});
		
		for dmgType,amount in pairs(state2DmgTypes) do
			if (state1["dmgTypes"][dmgType] == nil) then
				state1["dmgTypes"][dmgType] = amount;
			else
				state1["dmgTypes"][dmgType] = state1["dmgTypes"][dmgType] + amount;
			end
		end
	end
	
	if (state1["interrupts"] or state2["interrupts"]) then state1["interrupts"] = (state1["interrupts"] or 0) + (state2["interrupts"] or 0) end
end
