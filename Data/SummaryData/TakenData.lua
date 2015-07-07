
--[[ Taken Summary Data ]]--

_G.TakenData = class(DmgTypeSummaryData);

function TakenData:Constructor()
	DmgTypeSummaryData.Constructor(self);
end

function TakenData:GetState()
	return DmgTypeSummaryData.GetState(self);
end

function TakenData.CombineStates(state1,state2)
	DmgTypeSummaryData.CombineStates(state1,state2);
end

function TakenData.RestoreState(state)
	local takenData = TakenData();
	takenData.empty = false;
	
	if (state["amount"]) then takenData.amount = state["amount"] end
	
	if (state["min"]) then takenData.min = state["min"] end
	if (state["max"]) then takenData.max = state["max"] end
	
	if (state["absorbs"]) then takenData.absorbs = state["absorbs"] end
	if (state["crits"]) then takenData.crits = state["crits"] end
	if (state["devs"]) then takenData.devs = state["devs"] end
	
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
	
	takenData.attacks = takenData.attacks + attacks;
	
	takenData.misses = takenData.misses + misses;
  takenData.deflects = takenData.deflects + deflects;
	takenData.immunes = takenData.immunes + immunes;
	takenData.resists = takenData.resists + resists;
	
	takenData.blocks = takenData.blocks + blocks;
	takenData.parrys = takenData.parrys + parrys;
	takenData.evades = takenData.evades + evades;
	
	takenData.pblocks = takenData.pblocks + pblocks;
	takenData.pparrys = takenData.pparrys + pparrys;
	takenData.pevades = takenData.pevades + pevades;
	
	takenData.hits = takenData.hits + (attacks - misses - deflects - immunes - resists - blocks - parrys - evades);
	takenData.fullHits = takenData.fullHits + (attacks - misses - deflects - immunes - resists - blocks - parrys - evades - pblocks - pparrys - pevades);
	
	if (state["dmgTypes"]) then takenData.dmgTypes = state["dmgTypes"] end
	
	if (state["interrupts"]) then takenData.interrupts = state["interrupts"] end
	
	return takenData;
end
