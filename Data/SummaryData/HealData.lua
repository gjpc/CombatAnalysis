
--[[ Heal Summary Data ]]--

_G.HealData = class(RestoreTypeSummaryData);

function HealData:Constructor()
	RestoreTypeSummaryData.Constructor(self);
	
	self.temporaryMoraleAmount = 0;
	self.wastedTemporaryMoraleAmount = 0;
end

function HealData:UpdateTemporaryMorale(amount,wasted)
	self.empty = false;
	
	self.temporaryMoraleAmount = self.temporaryMoraleAmount + amount;
	-- if wasted is not false, it will be nil and the wasted status is currently unknown (the usual case)
	if (wasted ~= false) then
		self.wastedTemporaryMoraleAmount = self.wastedTemporaryMoraleAmount + amount;
	end
end

function HealData:UpdateWastedTemporaryMorale(reduceByAmount)
	-- verification that the specified amount of (already recorded) lost temporary morale was in fact not wasted
	self.wastedTemporaryMoraleAmount = self.wastedTemporaryMoraleAmount - reduceByAmount;
end

function HealData:TotalAmount()
	return self.amount + self.temporaryMoraleAmount;
end

function HealData:GetState()
	local state = RestoreTypeSummaryData.GetState(self);
	
	if (self.temporaryMoraleAmount > 0) then state["temporaryMoraleAmount"] = self.temporaryMoraleAmount end
	if (self.wastedTemporaryMoraleAmount > 0) then state["wastedTemporaryMoraleAmount"] = self.wastedTemporaryMoraleAmount end
	
	return state;
end

function HealData.CombineStates(state1,state2)
	RestoreTypeSummaryData.CombineStates(state1,state2);
	
	if (state1["temporaryMoraleAmount"] or state2["temporaryMoraleAmount"]) then state1["temporaryMoraleAmount"] = (state1["temporaryMoraleAmount"] or 0) + (state2["temporaryMoraleAmount"] or 0) end
	if (state1["wastedTemporaryMoraleAmount"] or state2["wastedTemporaryMoraleAmount"]) then state1["wastedTemporaryMoraleAmount"] = (state1["wastedTemporaryMoraleAmount"] or 0) + (state2["wastedTemporaryMoraleAmount"] or 0) end
end

function HealData.RestoreState(state)
	local healData = HealData();
	healData.empty = false;
	
	if (state["amount"]) then healData.amount = state["amount"] end
	
	if (state["min"]) then healData.min = state["min"] end
	if (state["max"]) then healData.max = state["max"] end
	
	if (state["attacks"]) then healData.attacks = state["attacks"] end
	if (state["absorbs"]) then healData.absorbs = state["absorbs"] end
	if (state["crits"]) then healData.crits = state["crits"] end
	if (state["devs"]) then healData.devs = state["devs"] end
	
	if (state["temporaryMoraleAmount"]) then healData.temporaryMoraleAmount = state["temporaryMoraleAmount"] end
	if (state["wastedTemporaryMoraleAmount"]) then healData.wastedTemporaryMoraleAmount = state["wastedTemporaryMoraleAmount"] end
	
	return healData;
end
