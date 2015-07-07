
--[[

Dmg Summary Data.

Includes number of corruptions removed
which is updated manually.

]]--

_G.DmgData = class(DmgTypeSummaryData);

function DmgData:Constructor()
	DmgTypeSummaryData.Constructor(self);
	
	self.corruptions = 0;
	
end

function DmgData:GetState()
	local state = DmgTypeSummaryData.GetState(self);
	
	if (self.corruptions > 0) then state["corruptions"] = self.corruptions end
	
	return state;
end

function DmgData.CombineStates(state1,state2)
	DmgTypeSummaryData.CombineStates(state1,state2);
	
	if (state1["corruptions"] or state2["corruptions"]) then state1["corruptions"] = (state1["corruptions"] or 0) + (state2["corruptions"] or 0) end
end

function DmgData.RestoreState(state)
	local dmgData = DmgData();
	dmgData.empty = false;
	
	if (state["amount"]) then dmgData.amount = state["amount"] end
	
	if (state["min"]) then dmgData.min = state["min"] end
	if (state["max"]) then dmgData.max = state["max"] end
	
	if (state["absorbs"]) then dmgData.absorbs = state["absorbs"] end
	if (state["crits"]) then dmgData.crits = state["crits"] end
	if (state["devs"]) then dmgData.devs = state["devs"] end
	
	local attacks = (state["attacks"] or 0);
	
	local misses = (state["misses"] or 0);
	local deflects = (state["deflects"] or 0);
	local immunes = (state["immunes"] or 0);
	local resists = (state["resists"] or 0);
	
	local blocks = (state["blocks"] or 0);
	local parrys = (state["parrys"] or 0);
	local evades = (state["evades"] or 0);
	
	local pblocks = (state["pblocks"] or 0);
	local pparrys = (state["pparrys"] or 0);
	local pevades = (state["pevades"] or 0);
	
	dmgData.attacks = dmgData.attacks + attacks;
	
	dmgData.misses = dmgData.misses + misses;
	dmgData.deflects = dmgData.deflects + misses;
	dmgData.immunes = dmgData.immunes + immunes;
	dmgData.resists = dmgData.resists + resists;
	
	dmgData.blocks = dmgData.blocks + blocks;
	dmgData.parrys = dmgData.parrys + parrys;
	dmgData.evades = dmgData.evades + evades;
	
	dmgData.pblocks = dmgData.pblocks + pblocks;
	dmgData.pparrys = dmgData.pparrys + pparrys;
	dmgData.pevades = dmgData.pevades + pevades;
	
	dmgData.hits = dmgData.hits + (attacks - misses - deflects - immunes - resists - blocks - parrys - evades);
	dmgData.fullHits = dmgData.fullHits + (attacks - misses - deflects - immunes - resists - blocks - parrys - evades - pblocks - pparrys - pevades);
	
	if (state["amountFullHits"]) then dmgData.amountFullHits = state["amountFullHits"] end
	
	if (state["dmgTypes"]) then dmgData.dmgTypes = state["dmgTypes"] end
	
	if (state["interrupts"]) then dmgData.interrupts = state["interrupts"] end
	if (state["corruptions"]) then dmgData.corruptions = state["corruptions"] end
	
	return dmgData;
end
