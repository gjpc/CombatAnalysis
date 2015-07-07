
--[[

The Abstract Base Class for all Standard Summary Data.

This includes summary information for all
attacks and restores, and other kind of events
such as interrupts, and corruption removals.

All Standard Summary Data includes an aggregate amount,
ave/min/max values, a count of attacks, and the number
of critical/devastating hits.

]]--

_G.StandardSummaryData = abstract_class(SummaryData);

function StandardSummaryData:Constructor()
	SummaryData.Constructor(self);
	
	self.amount = 0;
	
	self.min = 0;
	self.max = 0;
	
	self.attacks = 0;
	self.absorbs = 0;
	self.crits = 0;
	self.devs = 0;
	
end

function StandardSummaryData:Update(amount,critType)
	self.empty = false;

	self.amount = self.amount + amount;
	
	self.min = (self.min == 0 and amount or (amount == 0 and self.min or math.min(self.min,amount))); -- ie: min not including zero (but zero if no amounts over zero seen)
	self.max = math.max(self.max,amount);
	
	self.attacks = self.attacks + 1;
	self.absorbs = (amount == 0 and (self.absorbs + 1) or self.absorbs);
	
	if critType == 2 then
		self.crits = self.crits + 1;
	elseif critType == 3 then
		self.devs = self.devs + 1;
	end
	
end

function StandardSummaryData:TotalAmount()
	return self.amount;
end

function StandardSummaryData:Average()
	return self.amount/math.max(1,(self.attacks-self.absorbs));
end

function StandardSummaryData:CritPercentage()
	return self.crits/math.max(1,self.attacks);
end

function StandardSummaryData:DevPercentage()
	return self.devs/math.max(1,self.attacks);
end

function StandardSummaryData:CritOrDevPercentage()
	return (self.crits+self.devs)/math.max(1,self.attacks);
end

function StandardSummaryData:GetState()
	local state = SummaryData.GetState(self);
	
	if (self.amount > 0) then state["amount"] = self.amount end
	if (self.min > 0) then state["min"] = self.min end
	if (self.max > 0) then state["max"] = self.max end
	if (self.attacks > 0) then state["attacks"] = self.attacks end
	if (self.absorbs > 0) then state["absorbs"] = self.absorbs end
	if (self.crits > 0) then state["crits"] = self.crits end
	if (self.devs > 0) then state["devs"] = self.devs end
	
	return state;
end

function StandardSummaryData.CombineStates(state1,state2)
	SummaryData.CombineStates(state1,state2);
	
	if (state1["amount"] or state2["amount"]) then state1["amount"] = (state1["amount"] or 0) + (state2["amount"] or 0) end
	
	if (state1["min"] or state2["min"]) then
		local state1Min = (state1["min"] or 0);
		local state2Min = (state2["min"] or 0);
		state1["min"] = (state1Min == 0 and state2Min or (state2Min == 0 and state1Min or math.min(state1Min,state2Min)));
	end
	
	if (state1["max"] or state2["max"]) then
		state1["max"] = math.max((state1["max"] or 0),(state2["max"] or 0));
	end
	
	if (state1["attacks"] or state2["attacks"]) then state1["attacks"] = (state1["attacks"] or 0) + (state2["attacks"] or 0) end
	if (state1["absorbs"] or state2["absorbs"]) then state1["absorbs"] = (state1["absorbs"] or 0) + (state2["absorbs"] or 0) end
	if (state1["crits"] or state2["crits"]) then state1["crits"] = (state1["crits"] or 0) + (state2["crits"] or 0) end
	if (state1["devs"] or state2["devs"]) then state1["devs"] = (state1["devs"] or 0) + (state2["devs"] or 0) end
end

