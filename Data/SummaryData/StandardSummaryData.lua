
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
	
	--- Added in v4.4.7 to support Normal Hits
	self.normals = 0;      
	self.normalAmount = 0; 
	self.normalMin = 0;    
	self.normalMax = 0;    
	
	--- Added in v4.4.7 to support Critical Hits
	self.crits = 0;        
	self.critAmount = 0;   
	self.critMin = 0;      
	self.critMax = 0;      
	
	--- Added in v4.4.7 to support Devastate Hits
	self.devs = 0;         
	self.devAmount = 0;    
	self.devMin = 0;       
  self.devMax = 0;       
	
  self.attacks = 0;
  self.absorbs = 0;
	
end

function StandardSummaryData:Update(amount,critType)
	self.empty = false;

	self.amount = self.amount + amount;
	
	self.min = (self.min == 0 and amount or (amount == 0 and self.min or math.min(self.min,amount))); -- ie: min not including zero (but zero if no amounts over zero seen)
	self.max = math.max(self.max,amount);
	
	self.attacks = self.attacks + 1;
	self.absorbs = (amount == 0 and (self.absorbs + 1) or self.absorbs);
	
	if critType == 1 then --- Added in v4.4.7 to support Normal Hits
	  self.normals = self.normals + 1;
	  
	  self.normalAmount = self.normalAmount + amount; 
    self.normalMin = (self.normalMin == 0 and amount or (amount == 0 and self.normalMin or math.min(self.normalMin,amount))); -- ie: min not including zero (but zero if no amounts over zero seen)
    self.normalMax = math.max(self.normalMax,amount);
	  
	elseif critType == 2 then --- Added in v4.4.7 to support Critical Hits
		self.crits = self.crits + 1;
		
		self.critAmount = self.critAmount + amount; 
		self.critMin = (self.critMin == 0 and amount or (amount == 0 and self.critMin or math.min(self.critMin,amount))); -- ie: min not including zero (but zero if no amounts over zero seen)
    self.critMax = math.max(self.critMax,amount); 
		
	elseif critType == 3 then --- Added in v4.4.7 to support Devastate Hits
		self.devs = self.devs + 1;
		
    self.devAmount = self.devAmount + amount;
    self.devMin = (self.devMin == 0 and amount or (amount == 0 and self.devMin or math.min(self.devMin,amount))); -- ie: min not including zero (but zero if no amounts over zero seen)
    self.devMax = math.max(self.devMax,amount);
		
	end
	
end

function StandardSummaryData:TotalAmount()
	return self.amount;
end

function StandardSummaryData:TotalNormalAmount() --- Added in v4.4.7 to support Normal Hits
  return self.normalAmount;
end

function StandardSummaryData:TotalCritAmount()   --- Added in v4.4.7 to support Critical Hits
  return self.critAmount;
end

function StandardSummaryData:TotalDevAmount()    --- Added in v4.4.7 to support Devastate Hits
  return self.devAmount;
end

function StandardSummaryData:Average()
	return self.amount/math.max(1,(self.attacks-self.absorbs));
end

function StandardSummaryData:NormalAverage()            --- Added in v4.4.7 to support Normal Hits
  return self.normalAmount/math.max(1,(self.normals));
end

function StandardSummaryData:CriticalAverage()          --- Added in v4.4.7 to support Critical Hits
  return self.critAmount/math.max(1,(self.crits));
end

function StandardSummaryData:DevastateAverage()         --- Added in v4.4.7 to support Devastate Hits
  return self.devAmount/math.max(1,(self.devs));
end

function StandardSummaryData:NormalChance()     --- Added in v4.4.7 to support Normal Hits
  return self.normals/math.max(1,self.attacks);
end

function StandardSummaryData:CriticalChance()   --- Added in v4.4.7 to support Critical Hits
	return self.crits/math.max(1,self.attacks);
end

function StandardSummaryData:DevastateChance()  --- Added in v4.4.7 to support Devastate Hits
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
	--- Added in v4.4.7 to support Normal Hits
	if (self.normals > 0) then state["normals"] = self.crits end                 
  if (self.normalAmount > 0) then state["normalAmount"] = self.critAmount end  
  if (self.normalMin > 0) then state["normalMin"] = self.critMin end           
  if (self.normalMax > 0) then state["normalMax"] = self.critMax end           
  --- Added in v4.4.7 to support Critical Hits
	if (self.crits > 0) then state["crits"] = self.crits end                     
	if (self.critAmount > 0) then state["critAmount"] = self.critAmount end      
  if (self.critMin > 0) then state["critMin"] = self.critMin end               
  if (self.critMax > 0) then state["critMax"] = self.critMax end               
  --- Added in v4.4.7 to support Devastate Hits
	if (self.devs > 0) then state["devs"] = self.devs end                        
	if (self.devAmount > 0) then state["devAmount"] = self.devAmount end         
	if (self.devMin > 0) then state["devMin"] = self.devMin end                  
	if (self.devMax > 0) then state["devMax"] = self.devMax end                  
	
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

