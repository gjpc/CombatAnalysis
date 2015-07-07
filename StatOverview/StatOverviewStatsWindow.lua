
--[[

The Stat Overview Stats window is a Combat Analysis window that
contains the stats (details) panel for one or more tabs

]]--

_G.StatOverviewStatsWindow = class(CombatAnalysisWindow);

StatOverviewStatsWindow.fadeDuration = 0.2; -- the time in seconds of the fade in/out animation

function StatOverviewStatsWindow:Constructor(id)
	CombatAnalysisWindow.Constructor(self,statOverviewStatsWindows,true,0.5,true,true,false,0,nil,id);
	
	self.panels = {}
	self.showingPanel = nil;
	
	self.minimumHeight = 123;
	self.minimumWidth = 151;
	
	-- title hover effect (disabled)
	self.titleHoverEffect = Turbine.UI.Control();
	self.titleHoverEffect:SetParent(self);
	self.titleHoverEffect:SetZOrder(100);
	self.titleHoverEffect:SetPosition(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
	self.titleHoverEffect:SetBackColor(Turbine.UI.Color(0.6,0.7,0.7,0));
	self.titleHoverEffect:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.titleHoverEffect:SetMouseVisible(false);
	self.titleHoverEffect:SetVisible(false);
	
	-- skill title hover effect (disabled)
	self.skillTitleHoverEffect = Turbine.UI.Control();
	self.skillTitleHoverEffect:SetParent(self);
	self.skillTitleHoverEffect:SetZOrder(100);
	self.skillTitleHoverEffect:SetPosition(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border,CombatAnalysisWindow.resizeHangover+2*CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight);
	self.skillTitleHoverEffect:SetBackColor(Turbine.UI.Color(0.6,0.7,0.7,0));
	self.skillTitleHoverEffect:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.skillTitleHoverEffect:SetMouseVisible(false);
	self.skillTitleHoverEffect:SetVisible(false);
	
	-- data title effect (disabled)
	self.dataTitleHoverEffect = Turbine.UI.Control();
	self.dataTitleHoverEffect:SetParent(self);
	self.dataTitleHoverEffect:SetZOrder(100);
	self.dataTitleHoverEffect:SetTop(CombatAnalysisWindow.resizeHangover+2*CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight);
	self.dataTitleHoverEffect:SetSize(108,StatOverviewStatsPanel.dataTitleHeight+CombatAnalysisWindow.border);
	self.dataTitleHoverEffect:SetBackColor(Turbine.UI.Color(0.6,0.7,0.7,0));
	self.dataTitleHoverEffect:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.dataTitleHoverEffect:SetMouseVisible(false);
	self.dataTitleHoverEffect:SetVisible(false);
	
	-- hover effect (disabled)
	self.hoverEffect = Turbine.UI.Control();
	self.hoverEffect:SetParent(self);
	self.hoverEffect:SetZOrder(100);
	self.hoverEffect:SetPosition(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border,CombatAnalysisWindow.resizeHangover+3*CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight+StatOverviewStatsPanel.dataTitleHeight);
	self.hoverEffect:SetBackColor(Turbine.UI.Color(0.6,0.7,0.7,0));
	self.hoverEffect:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.hoverEffect:SetMouseVisible(false);
	self.hoverEffect:SetVisible(false);
	
	-- override content layout function to layout showing panel
	self.content.Layout = function(sender)
		if (self.showingPanel ~= nil) then
			self.showingPanel:SetSize(self.content:GetSize());
			self.showingPanel:Layout();
		end
	end
  
  settings.oldStatOverviewStatsWindowState = nil;
  
  Misc.NotifyListeners(statOverviewStatsWindows,"windowOpened",self);
end

function StatOverviewStatsWindow:Layout()
	CombatAnalysisWindow.Layout(self);
	
	local w,h = self:GetSize();
	self.titleHoverEffect:SetSize(w-2*CombatAnalysisWindow.resizeHangover-2*CombatAnalysisWindow.border,CombatAnalysisWindow.titleBarHeight);
	self.skillTitleHoverEffect:SetSize(math.max(0,w-120+CombatAnalysisWindow.border-2*CombatAnalysisWindow.resizeHangover),StatOverviewStatsPanel.dataTitleHeight);
	self.dataTitleHoverEffect:SetLeft(w-120+3*CombatAnalysisWindow.border-CombatAnalysisWindow.resizeHangover);
	self.hoverEffect:SetSize(w-2*CombatAnalysisWindow.resizeHangover-2*CombatAnalysisWindow.border,h-2*CombatAnalysisWindow.resizeHangover-4*CombatAnalysisWindow.border-CombatAnalysisWindow.titleBarHeight-StatOverviewStatsPanel.dataTitleHeight);
end

function StatOverviewStatsWindow:SetVisible(visible,dontActivate,dontFade)
	if (visible) then
		CombatAnalysisWindow.SetVisible(self,true,dontActivate);
	end
	
	-- fade the window in and out
	self.visible = visible;
	if (dontFade) then
		Turbine.UI.Window.SetVisible(self,self.visible);
	else
		if (self:GetWantsUpdates()) then
			local inverseDur = StatOverviewStatsWindow.fadeDuration-(Turbine.Engine.GetGameTime()-self.startTime);
			self.startTime = Turbine.Engine.GetGameTime()-inverseDur;
		else
			self.startTime = Turbine.Engine.GetGameTime();
		end
		self:SetWantsUpdates(true);
	end
end

function StatOverviewStatsWindow:Close(panel,dontSave)
	CombatAnalysisWindow.Close(self,dontSave);
  
  -- if this was the last window, persist its state
  if (#self.windowSet == 0 and #self.panels > 0) then
    local tab = (panel == nil and self.panels[1].tab or panel.tab);
    
    settings.oldStatOverviewStatsWindowState = {
			["w"] = EncodeNumbers(self.w), ["h"] = EncodeNumbers(self.h),
      ["statsWindowVisibility"] = (tab.showStats == 1 and "Hide" or (tab.showStats == 2 and "Hover" or "Show")),
			["color"] = self.color
		};
    
    if (not dontSave) then SaveSettings() end
  end
  
  Misc.NotifyListeners(statOverviewStatsWindows,"windowClosed",self);
end

-- override the update function to perform fading in and out, as stats windows cannot be minimized
function StatOverviewStatsWindow:Update()
	local proportion = math.min(1,(Turbine.Engine.GetGameTime()-self.startTime)/StatOverviewStatsWindow.fadeDuration);
	
	self:SetOpacity(self.visible and proportion or (1-proportion));
	
	if (proportion == 1) then
		self:SetWantsUpdates(false);
		if (not self.visible) then
			Turbine.UI.Window.SetVisible(self,false);
		end
	end
end

function StatOverviewStatsWindow:AddPanel(statsPanel)
	-- add notification of new panel to all current panels, and vice-versa
	for _,panel in ipairs(self.panels) do
		panel:AddIcon(statsPanel);
		statsPanel:AddIcon(panel);
	end
	
	-- add panel to this window
	table.insert(self.panels,statsPanel);
	
	-- update the window of the panel
	statsPanel.window = self;
	
	-- copy over relevant style
	statsPanel.tab.showStats = self.panels[1].tab.showStats;
	statsPanel.tab.panel.infoButton:SetBackground("CombatAnalysis/Resources/info_button"..(statsPanel.tab.showStats == 3 and "_border" or (statsPanel.tab.showStats == 2 and "_quarter_border" or ""))..".tga");
	
	if (#self.panels == 1) then
		self:SetShowingPanel(statsPanel);
	end
  
  Misc.NotifyListeners(self,"panels");
end

function StatOverviewStatsWindow:RemovePanel(statsPanel)
	-- remove notification of the deleted panel from all current panels, and vice-versa
	for index,panel in ipairs(self.panels) do
		if (panel == statsPanel) then
			table.remove(self.panels,index);
			break;
		end
	end
	
	if (statsPanel == self.showingPanel) then
		statsPanel:SetParent(nil);
		if (#self.panels > 0) then
			self:SetShowingPanel(self.panels[1]);
		end
	end
	
	for _,panel in ipairs(self.panels) do
		panel:RemoveIcon(statsPanel);
		statsPanel:RemoveIcon(panel);
	end
	
	statsPanel.window = nil;
	
	-- close the window if empty
	if (#self.panels == 0) then
		self:Close(statsPanel);
	end
  
  Misc.NotifyListeners(self,"panels");
end

function StatOverviewStatsWindow:SetShowingPanel(statsPanel,dontUpdate)
	if (self.showingPanel == statsPanel) then return end
	
	if (self.showingPanel ~= nil) then
		self.showingPanel:SetParent(nil);
	end
	
	self.showingPanel = statsPanel;
	self.showingPanel:SetParent(self.content);
	self:Layout();
	
	if (not dontUpdate) then
		self.showingPanel:FullUpdate(self.showingPanel.tab:Duration(),true,true);
	end
end

-- lock in a value
function StatOverviewStatsWindow:SetLocked(bar,statsPanel,isLocked)
	-- unlock old panel
	if (self.locked ~= nil) then
		self.locked:SetLocked(false);
	end
	if (self.lockedPanel ~= nil) then
		self.lockedPanel.lockIcon:SetParent(nil);
		self.lockedPanel.title:SetWidth(math.max(0,self.lockedPanel:GetWidth()-StatOverviewPanel.durationWidth-6*CombatAnalysisWindow.border-(#self.lockedPanel.panelIcons)*(CombatAnalysisWindow.border+14)));
	end
	if (isLocked == false and self.visible and self.lockedPanel ~= nil) then
		if (self.lockedPanel.tab.showStats == 1 or (self.lockedPanel.tab.showStats == 2 and self.lockedPanel.hoverBar == nil)) then
			self:SetVisible(false);
		end
	end
	
	-- update lock settings
	if (isLocked ~= nil) then
		self.isLocked = isLocked;
	end
	self.locked = bar;
	self.lockedPanel = statsPanel;
	
	-- lock new panel
	if (self.locked ~= nil) then
		self.locked:SetLocked(true);
	end
	if (self.lockedPanel ~= nil) then
		self.lockedPanel.lockIcon:SetParent(self.lockedPanel);
		self.lockedPanel.title:SetWidth(math.max(0,self.lockedPanel:GetWidth()-StatOverviewPanel.durationWidth-6*CombatAnalysisWindow.border-(#self.lockedPanel.panelIcons)*(CombatAnalysisWindow.border+14)-(12+CombatAnalysisWindow.border)));
	end
	if (isLocked) then
		if (not self.visible) then
			self:SetVisible(true);
		end
		self.locked.panel.tab.statsPanel:EnsureShowing(true);
		if (clickable) then
			if (self.locked.panel.tab.statsPanel.selectedPlayer ~= self.locked.label:GetText() or self.locked.panel.tab.statsPanel.selectedSkill ~= nil) then
				self.locked.panel.tab.statsPanel:FullUpdate(nil,true,false,(self.locked.clickable and self.locked.label:GetText() or self.locked.panel.selectedPlayer),(not self.locked.clickable and self.locked.label:GetText() or nil));
			end
		else
			if (self.locked.panel.tab.statsPanel.selectedPlayer ~= self.locked.panel.selectedPlayer or self.locked.panel.tab.statsPanel.selectedSkill ~= self.locked.label:GetText()) then
				self.locked.panel.tab.statsPanel:FullUpdate(nil,true,false,(self.locked.clickable and self.locked.label:GetText() or self.locked.panel.selectedPlayer),(not self.locked.clickable and self.locked.label:GetText() or nil));
			end
		end
	end
end

-- Mouse Events

function StatOverviewStatsWindow:MouseDown(args)
	CombatAnalysisWindow.MouseDown(self,args);

	-- only perform actions on left mouse down
	if (args.Button ~= Turbine.UI.MouseButton.Left or windowsLocked) then return end
	
	WindowManager.ShowHideWindows(self.windowSet,true,true,statOverviewStatsWindows);
	self.mouseDown = true;
end

function StatOverviewStatsWindow:MouseMove(args)
	CombatAnalysisWindow.MouseMove(self,args);
	
	-- if we are dragging, determine if the mouse is hovering over another window in the window set
	if (self.mouseDown) then
		local window = WindowManager.GetMouseInsideWindow(self.windowSet,self);
		-- remove hover effect from previous window
		if (self.prevHover ~= nil and self.prevHover ~= window) then
			self.prevHover.titleHoverEffect:SetVisible(false);
			self.prevHover.skillTitleHoverEffect:SetVisible(false);
			self.prevHover.dataTitleHoverEffect:SetVisible(false);
			self.prevHover.hoverEffect:SetVisible(false);
			
			self.prevHover = nil;
		end
		-- apply hover effect to new window
		if (window ~= nil) then
			window.titleHoverEffect:SetVisible(true);
			window.skillTitleHoverEffect:SetVisible(true);
			window.dataTitleHoverEffect:SetVisible(true);
			window.hoverEffect:SetVisible(true);
			self.prevHover = window;
		end
	end
end

function StatOverviewStatsWindow:MouseUp(args)
	CombatAnalysisWindow.MouseUp(self,args);
	
	-- only perform further actions on left mouse down
	if (args.Button ~= Turbine.UI.MouseButton.Left) then return end
	
	-- if we had been dragging a tab, we now need to determine what action to take
	if (self.mouseDown) then
    WindowManager.ShowHideWindows(self.windowSet,true,false,statOverviewStatsWindows);
    
		if (self.prevHover ~= nil) then
			self.prevHover.titleHoverEffect:SetVisible(false);
			self.prevHover.skillTitleHoverEffect:SetVisible(false);
			self.prevHover.dataTitleHoverEffect:SetVisible(false);
			self.prevHover.hoverEffect:SetVisible(false);
		end
		
		local window = WindowManager.GetMouseInsideWindow(self.windowSet,self);
		-- we only need to do anything if the window was dragged into another window
		if (window ~= nil) then
			-- move all panels into the new window
			while #self.panels > 0 do
				local panel = self.panels[1];
				self:RemovePanel(panel);
				window:AddPanel(panel);
				panel.tab:SaveState();
			end
			
			-- update lock statuses
			if (not window.isLocked and self.isLocked) then
				window:SetLocked(self.locked,self.lockedPanel,true);
			elseif (window.isLocked and self.isLocked) then
				self:SetLocked(nil,nil,false);
			end
		end
	end
	
	self.mouseDown = false;
end

-- Save state method
function StatOverviewStatsWindow:SaveState()
	-- x pos, y pos, w, h
	settings.statsWindowStates[EncodeNumbers(self.id)] = (not self.windowClosed and EncodeNumbers({
			["x"] = EncodeNumbers(self:GetLeft()), ["y"] = EncodeNumbers(self:GetTop()), ["w"] = EncodeNumbers(self:GetWidth()), ["h"] = EncodeNumbers(self:GetHeight()),
      ["backgroundColor"] = EncodeNumbers(Misc.TableCopy(self.color))
		}) or nil);
	
	SaveSettings();
end

-- Restore state method
function StatOverviewStatsWindow.RestoreState(windowId,savedState)
	local newWindow = StatOverviewStatsWindow(windowId);
	newWindow:SetSize(savedState["w"],savedState["h"]);
	
	-- default location (a little bit hacky)
	if (savedState["x"] == nil) then
		savedState["x"] = ((Turbine.UI.Display.GetWidth()-2*savedState["w"])/2)+savedState["w"]+5;
	end
	if (savedState["y"] == nil) then
		savedState["y"] = (Turbine.UI.Display.GetHeight()-savedState["h"])/2;
	end
	
	newWindow:SetPosition(WindowManager.ValidatePosition(savedState["x"],savedState["y"],savedState["w"],savedState["h"],0,
																											 CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover));
	return newWindow;
end
