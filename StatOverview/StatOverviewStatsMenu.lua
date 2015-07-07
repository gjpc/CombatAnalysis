
--[[

A Stat Overview Stats Menu specifies the different
data options available in the stats window.

This includes All Data, or just regular hits,
crits, devs, crits & devs, or partial avoids.

]]--

_G.StatOverviewStatsMenu = class(Turbine.UI.Window);

StatOverviewStatsMenu.animationDuration = 0.07;
StatOverviewStatsMenu.selectionColor = Turbine.UI.Color(1,0.96,0.8);
StatOverviewStatsMenu.itemColor = Turbine.UI.Color(0.45,0.45,0.35);

function StatOverviewStatsMenu:Constructor()
	Turbine.UI.Window.Constructor(self);
	
	self:SetBackColor(borderColor);
	
	-- drop down window background
	self.dropDownBackground = Turbine.UI.Control();
	self.dropDownBackground:SetParent(self);
	self.dropDownBackground:SetPosition(CombatAnalysisWindow.border,CombatAnalysisWindow.border);
	self.dropDownBackground:SetBackColor(Turbine.UI.Color(0.95,0.16,0.16,0.16));
	
	-- list box to contain the drop down items
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self);
	self.listBox:SetPosition(3*CombatAnalysisWindow.border,CombatAnalysisWindow.border);
	self.listBox:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.listBox:SetMaxItemsPerLine(1);
	self.listBox:SetMouseVisible(false);
	
	self.listBox:AddItem(self:CreateItem(L.AllData,""));
	self.listBox:AddItem(self:CreateItem(L.NonCrits,"NonCrit"));
	self.listBox:AddItem(self:CreateItem(L.Criticals,"Crit"));
	self.listBox:AddItem(self:CreateItem(L.Devastates,"Dev"));
	self.listBox:AddItem(self:CreateItem(L.CritsAndDevs,"AllCrit"));
	
	self.partialAvoids = self:CreateItem(L.Partials,"Partial");
end

function StatOverviewStatsMenu:SetVisible(visible)
	Turbine.UI.Window.SetVisible(self,visible);
  
  if (visible) then
    self:Activate();
    self:Focus();
  end
end

function StatOverviewStatsMenu:Deactivated(args)
  if (not self.mouse) then
    self:CloseDropDown(false);
  end
end

-- open/close

function StatOverviewStatsMenu:OpenDropDown(x,y,w,statsPanel)
	local itemCount = self.listBox:GetItemCount();
	if self.open then return end
	
	self.statsPanel = statsPanel;
	_G.openComboBox = self;
	self.open = true;
	
	x = x + CombatAnalysisWindow.border;
	w = w - 2*CombatAnalysisWindow.border;
	
	-- determine if the partial avoids option should show
	if (statsPanel.tab.titleText == L.Dmg or statsPanel.tab.titleText == L.Taken) then
		if (self.partialAvoids:GetParent() == nil) then
			self.listBox:AddItem(self.partialAvoids);
		end
	else
		if (self.partialAvoids:GetParent() ~= nil) then
			self.listBox:RemoveItem(self.partialAvoids);
		end
	end
	
	-- determine the selected value
	self:SetSelected(self.statsPanel.category);
	
	-- update the width and selection status of each list item
	local listHeight = 0;
	for i=1,self.listBox:GetItemCount() do
		local item = self.listBox:GetItem(i);
		item:SetWidth(w-6*CombatAnalysisWindow.border);
		listHeight = listHeight + item:GetHeight();
	end
	
	-- window position and size
	self.targetH = listHeight+2*CombatAnalysisWindow.border;
	self.animateDown = true;
	
	self.targetY = y+CombatAnalysisWindow.border;
	if (self.targetY+self.targetH-CombatAnalysisWindow.border > Turbine.UI.Display.GetHeight()) then
		self.targetY = self.targetY-CombatAnalysisWindow.titleBarHeight-4*CombatAnalysisWindow.border-self.targetH;
		self.animateDown = false;
	end
	
	self:SetPosition(WindowManager.ValidatePosition(x,self.targetY,w,self.targetH,CombatAnalysisWindow.border));
	self:SetWidth(w);
	self.dropDownBackground:SetSize(w-2*CombatAnalysisWindow.border,self.targetH-2*CombatAnalysisWindow.border);
	self.listBox:SetSize(w-12-2*CombatAnalysisWindow.border,listHeight);
	
	self.start = Turbine.Engine.GetGameTime();
	self:SetWantsUpdates(true);
	
	self.statsPanel.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_pressed.tga");
	self:SetVisible(true);
end

function StatOverviewStatsMenu:CloseDropDown()
	if (not self.open) then return end
	
	_G.openComboBox = nil;
	self.open = false;
	
	self.statsPanel.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_"..(self.mouse and "rollover" or "normal")..".tga");
	self:SetVisible(false);
end

-- create item

function StatOverviewStatsMenu:CreateItem(text,value,statsPanel)
	local listItem = Turbine.UI.Label();
	listItem:SetZOrder(1);
	listItem:SetHeight(StatOverviewStatsPanel.dataTitleHeight);
	listItem:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	listItem:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	listItem:SetForeColor(StatOverviewStatsMenu.selectionColor);
	listItem:SetOutlineColor(Turbine.UI.Color(0.5,0.5,0));
	listItem:SetMultiline(false);
	listItem:SetText(text);
	
	listItem.value = value;
	
	listItem.MouseEnter = function(sender, args)
		if (sender ~= self.selected) then
			sender:SetFontStyle(Turbine.UI.FontStyle.Outline);
		end
		-- hack to ensure text UI update
		local text = sender:GetText();
		sender:SetText(text or "");
	end
	listItem.MouseLeave = function(sender, args)
		sender:SetFontStyle(Turbine.UI.FontStyle.None);
		-- hack to ensure text UI update
		local text = sender:GetText();
		sender:SetText(text or "");
	end
	listItem.MouseClick = function(sender, args)
		if (self.selected ~= listItem) then
			self.statsPanel:SetCategory(listItem:GetText(),listItem.value);
			self:CloseDropDown();
		end
	end
	
	return listItem;
end

function StatOverviewStatsMenu:Update()
	-- animate combo box drop down
	local diff = Turbine.Engine.GetGameTime()-self.start;
	if diff >= StatOverviewStatsMenu.animationDuration then
		diff = StatOverviewStatsMenu.animationDuration;
		self:SetWantsUpdates(false);
	end
	
	local currentH = self.targetH*(diff/StatOverviewStatsMenu.animationDuration);
	if (not self.animateDown) then
		self:SetTop(self.targetY+(self.targetH-currentH));
	end
	self:SetHeight(currentH);
end

function StatOverviewStatsMenu:SetSelected(category)
	if (self.selected ~= nil) then
		self.selected:SetForeColor(StatOverviewStatsMenu.selectionColor);
	end
	
	local listItem;
	for index=1,self.listBox:GetItemCount() do
		if (self.listBox:GetItem(index).value == category) then
			listItem = self.listBox:GetItem(index);
			break;
		end
	end
	
	self.selected = listItem;
	self.selected:SetForeColor(StatOverviewStatsMenu.itemColor);
end
