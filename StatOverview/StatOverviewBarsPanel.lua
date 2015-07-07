
--[[

A Stats Overview Bars Panel is a Combat Analysis
Bars Panel that obtains data to fill the bars with
from a Stats Overview tab.

]]--


_G.StatOverviewBarsPanel = class(CombatAnalysisBarsPanel);

function StatOverviewBarsPanel:Constructor(tab,hasTwoPartBars)
	CombatAnalysisBarsPanel.Constructor(self);
	
	self.tab = tab;
  self.hasTwoPartBars = hasTwoPartBars;
	self.selectedPlayer = nil;
end

function StatOverviewBarsPanel:Layout()
	CombatAnalysisBarsPanel.Layout(self);
	
	if (not self.tab.showSendChat) then
		self.scrollBar:SetHeight(self:GetHeight()-2*CombatAnalysisWindow.border-16);
	end
end

function StatOverviewBarsPanel:UpdateColor(color)
  CombatAnalysisBarsPanel.UpdateColor(self,color);
  
  for _,bar in ipairs(self.bars) do
    bar:UpdateColor(self.backColor);
  end
end

function StatOverviewBarsPanel:UpdateColor2(color)
  self.backColor2 = color;
  
  for _,bar in ipairs(self.bars) do
    bar:UpdateColor2(self.backColor2);
  end
end

-- A full update requires recomputing all values
function StatOverviewBarsPanel:FullUpdate(duration)
	-- get relevant data
	local dataSummary = (self.selectedPlayer == nil and self.tab:GetData() or self.tab:GetDataForPlayer(self.selectedPlayer));
	-- sort the data, and determine the max value, and the player's value
	local maxValue = 1;
	local myValue = 1;
	local sortedData = {};
	for playerName,data in pairs(dataSummary) do
		if not data.empty then
			-- if auto select player mode is activated, this is not a view level change (ie: a new encounter was
			--   selected, or new combat data has arrived), and this bar shows the player's data, then select the
			--   player and update the bar panel with the new relevant data
			if (self.tab.autoSelectPlayer and self.tab.viewLevelYetToBeChanged and self.selectedPlayer == nil and playerName == player.name) then
				self.tab.panel:FullUpdate(duration,true,player.name);
				self.tab.viewLevelYetToBeChanged = false;
				return;
			end
			-- determine the max value & the player's value (where applicable)
			if (not self.tab.isBuffTab) then
				maxValue = math.max(maxValue,data:TotalAmount());
				if (playerName == player.name) then
					myValue = data:TotalAmount();
				end
			end
			
			table.insert(sortedData,{playerName,data});
		end
	end
	-- sort data
	if (self.tab.isBuffTab) then
		Misc.SortOnDurations(sortedData);
	else
		Misc.Sort(sortedData);
	end
	
	-- update bars
	for i,data in ipairs(sortedData) do
		-- note we perform lazy (but persistent) initialization of bars
		if self.listBox:GetItemCount() < i then
			-- lazy initialization of new bar
			if #self.bars < i  then
        local newBar = StatOverviewBar(self,self.hasTwoPartBars,(i == 1));
        newBar:UpdateColor(self.backColor);
        newBar:UpdateColor2(self.backColor2);
				self:AddBar(newBar);
			else
				self:RestoreBar(i);
			end
			-- update the clickable status of the bar
			self.bars[i]:SetClickable(self.selectedPlayer == nil);
		end
		-- update the bar values
		self.bars[i]:UpdateData(data[1],data[2],duration,maxValue,myValue);
	end
end

-- The Update method is used to signify that durations need updating. An update
-- to durations can be significantly more efficient than a full update as it only
-- affects labels (not bar sizes).
-- 
-- However, extra work needs to be done for buff and debuff bars as they may
-- require re-ordering.
function StatOverviewBarsPanel:Update(duration)
	if (self.tab.isBuffTab) then
		-- sort bars by amount
		local sortedBarData = {}
		for i=1,self.listBox:GetItemCount() do
			local bar = self.listBox:GetItem(i);
			table.insert(sortedBarData,{bar.label:GetText(),bar.amount});
		end
		Misc.SortOnDurations(sortedBarData);
		
		-- determine if bar order has changed
		for i=1,self.listBox:GetItemCount() do
			local bar = self.listBox:GetItem(i);
			if (sortedBarData[i][2] ~= bar.amount) then
				bar:UpdateData(sortedBarData[i][1],sortedBarData[i][2],duration);
			else
				bar:UpdateDuration(duration);
			end
		end
		
	else
		for i=1,self.listBox:GetItemCount() do
			self.bars[i]:UpdateDuration(duration);
		end
	end
end

-- on a right-mouse click, move back "up" one level (to view all player data)
function StatOverviewBarsPanel:MouseClick(args)
	if (args.Button ~= Turbine.UI.MouseButton.Right or self.selectedPlayer == nil) then return end
	
	-- update the bars panel
	self.tab.panel:FullUpdate(nil,true,nil,false);
end
