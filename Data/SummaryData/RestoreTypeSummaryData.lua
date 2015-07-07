
--[[ The Abstract Base Class for all Restore Type Summary Data ]]--

_G.RestoreTypeSummaryData = abstract_class(StandardSummaryData);

function RestoreTypeSummaryData:Constructor()
	StandardSummaryData.Constructor(self);
end

function RestoreTypeSummaryData:GetState()
	return StandardSummaryData.GetState(self);
end

function RestoreTypeSummaryData.CombineStates(state1,state2)
	StandardSummaryData.CombineStates(state1,state2);
end

