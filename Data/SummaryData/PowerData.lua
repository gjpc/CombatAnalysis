
--[[ Power Summary Data ]]--

_G.PowerData = class(RestoreTypeSummaryData);

function PowerData:Constructor()
	RestoreTypeSummaryData.Constructor(self);
end

function PowerData:GetState()
	return RestoreTypeSummaryData.GetState(self);
end

function PowerData.CombineStates(state1,state2)
	RestoreTypeSummaryData.CombineStates(state1,state2);
end

function PowerData.RestoreState(state)
	local powerData = PowerData();
	powerData.empty = false;
	
	if (state["amount"]) then powerData.amount = state["amount"] end
	
	if (state["min"]) then powerData.min = state["min"] end
	if (state["max"]) then powerData.max = state["max"] end
	
	if (state["attacks"]) then powerData.attacks = state["attacks"] end
	if (state["absorbs"]) then powerData.absorbs = state["absorbs"] end
	if (state["crits"]) then powerData.crits = state["crits"] end
	if (state["devs"]) then powerData.devs = state["devs"] end
	
	return powerData;
end
