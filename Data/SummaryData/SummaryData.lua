
--[[

The Abstract Base Class for all Summary Data.

This includes summary information for all
attacks, restores, and other kind of events
such as interrupts, corruption removals, as
well as buff/debuff timings, etc.

All Summary Data is specified in terms of an
initiating player and a target, though this
information is not stored directly.

]]--

_G.SummaryData = abstract_class();

function SummaryData:Constructor()
	self.empty = true;
end

function SummaryData:GetState()
	-- empty summary data will not be saved
	return {};
end

function SummaryData.CombineStates(state1,state2)
	-- nothing to combine
end
