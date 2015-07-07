
--[[

A Stat Overview Window is a Combat Analysis
Tabbed window that contains a bars display panel
and an optional extra statistics tree panel.

The title bar includes buttons to show/hide the
statistics tree panel, and to reset the totals
encounter stats.

]]--

_G.StatOverviewWindow = class(CombatAnalysisTabbedWindow);

function StatOverviewWindow:Constructor(showBackground,hasTitleBar,autoHideTabs,tabs,id)
	CombatAnalysisTabbedWindow.Constructor(self,statOverviewWindows,showBackground,0.5,showBackground,(not hasTitleBar and 0 or nil),autoHideTabs,true,id);
	
	for i,tab in ipairs(tabs) do
		self:AddTab(tab,(i==1),nil,true);
	end
  
  settings.oldStatOverviewWindowState = nil;
  
  Misc.NotifyListeners(statOverviewWindows,"windowOpened",self);
end

function StatOverviewWindow:TabIndex(tab)
	for index,t in ipairs(self.tabs) do
		if (tab == t) then return index end
	end
	
	return 0;
end

function StatOverviewWindow:AddTab(tab,select,index,dontSave)
	CombatAnalysisTabbedWindow.AddTab(self,tab,select,index,dontSave);
	
	-- change the appearance of the tab to match other tabs in this window (if any)
	if (#self.tabs > 1) then
    local existingTab = (self.tabs[1] ~= tab and self.tabs[1] or self.tabs[2]);
		tab:SetShowTitle(existingTab.showTitle);
		tab:SetShowEncounters(existingTab.showEncounters);
		tab:SetShowTargets(existingTab.showTargets);
		tab:SetShowSendChat(existingTab.showSendChat);
	-- if no tabs are in the window yet, determine the window's minimum border height parameter and minimum width
	else
		tab:DetermineMinimumWindowHeight(0);
		self.minimumWidth = (tab.showSendChat and 178 or CombatAnalysisTabbedWindow.defaultMinWidth);
	end
end

-- override certain window events (activate, close/set visible, minimize, and movement) to ensure the
-- chat send button visibility, Z order, and position are maintained correctly

function StatOverviewWindow:Activate()
	-- ensure the selected tab's stats panel is showing
	if (not self.selected.isBuffTab and self.selected.statsPanel.window ~= nil) then
		if (not self.selected.statsPanel.window.isLocked) then
			self.selected.statsPanel.window:SetShowingPanel(self.selected.statsPanel);
		end
		self.selected.statsPanel.window:Activate();
	end
	
	CombatAnalysisWindow.Activate(self);
	
	self.selected.panel.chatSendWindow:Activate();
end

function StatOverviewWindow:Close(tab,dontSave)
	CombatAnalysisTabbedWindow.Close(self,dontSave);
	
  if (self.selected ~= nil) then
    self.selected.panel.speechButtonWindow:SetVisible(false);
    self.selected.panel.chatButtonWindow:SetVisible(false);
    self.selected.panel.chatSendWindow:SetSize(0,0);
    self.selected.panel.infoButtonWindow:SetVisible(false);	
  end
  
  -- if this was the last window, persist its state
  if (#self.windowSet == 0 and #self.tabs > 0) then
    tab = (tab or self.tabs[1]);
    settings.oldStatOverviewWindowState = {
      ["showTitle"] = tab.showTitle, ["showEncounters"] = tab.showEncounters,
			["showTargets"] = tab.showTargets, ["showSendChat"] = tab.showSendChat,
			["w"] = EncodeNumbers(self.w), ["h"] = EncodeNumbers(self.h),
			["showBackground"] = self.showBackground, ["showTitleBar"] = (self.titleBarWidth > 0 and true or false),
			["autoHideTabs"] = (self.autoHideTabs or self.prevAutoHideTabs), ["color"] = self.color
		};
    
    if (not dontSave) then SaveSettings() end
  end
  
  Misc.NotifyListeners(statOverviewWindows,"windowClosed",self);
end

function StatOverviewWindow:SetVisible(visible,autoReset,dontActivate) -- autoreset no longer used
	CombatAnalysisWindow.SetVisible(self,visible,dontActivate);
	
	self.selected.panel.speechButtonWindow:SetVisible(visible and self.selected.showSendChat and not self.minimized);
	self.selected.panel.chatButtonWindow:SetVisible(visible and self.selected.showSendChat and not self.minimized);
	self.selected.panel.infoButtonWindow:SetVisible(visible and self.selected.showSendChat and not self.minimized);
	
	if (visible and self.selected.panel.tab.chatSendEnabled and self.selected.showSendChat and not self.minimized) then
		self.selected.panel.chatSendWindow:SetSize(100,19);
	else
		self.selected.panel.chatSendWindow:SetSize(0,0);
	end
	
	if (visible) then
		local x,y = WindowManager.GetPositionOnScreen(self.selected.panel);
		local w,h = self.selected.panel:GetSize();
		
		self.selected.panel.chatSendWindow:SetPosition((x+(w-122)/2),(y+(h-CombatAnalysisWindow.border-19)));
    if (not dontActivate) then self.selected.panel.chatSendWindow:Activate() end
	end
end

function StatOverviewWindow:Minimize()
	CombatAnalysisWindow.Minimize(self);
	
	if (self.minimized) then
		self.selected.panel.speechButtonWindow:SetVisible(false);
		self.selected.panel.chatButtonWindow:SetVisible(false);
		self.selected.panel.infoButtonWindow:SetVisible(false);
		self.selected.panel.chatSendWindow:SetSize(0,0);
	else
		-- update the selected panel when we restore a stat overview window
		self.selected.panel:FullUpdate(self.selected:Duration(),true,self.selected.panel.barsPanel.selectedPlayer);
	end
end

function StatOverviewWindow:Update()
	CombatAnalysisWindow.Update(self);
	
	if (not self.minimized and not self:GetWantsUpdates()) then
		local x,y = WindowManager.GetPositionOnScreen(self.selected.panel);
		local w,h = self.selected.panel:GetSize();
		
		self.selected.panel.chatSendWindow:SetPosition((x+(w-122)/2),(y+(h-CombatAnalysisWindow.border-19)));
		
		if (self.selected.showSendChat) then
			self.selected.panel.speechButtonWindow:SetVisible(true);
			self.selected.panel.chatButtonWindow:SetVisible(true);
			self.selected.panel.infoButtonWindow:SetVisible(true)			
			if (self.selected.panel.tab.chatSendEnabled) then
				self.selected.panel.chatSendWindow:SetSize(100,19);
				self.selected.panel.chatSendWindow:Activate();
			end
		end
	end
end

function StatOverviewWindow:MouseMove(args)
	local dragging = self.dragging;
	CombatAnalysisWindow.MouseMove(self,args);
	if (dragging and not self.minimized) then
		local x,y = WindowManager.GetPositionOnScreen(self.selected.panel);
		local w,h = self.selected.panel:GetSize();
		self.selected.panel.chatSendWindow:SetPosition((x+(w-122)/2),(y+(h-CombatAnalysisWindow.border-19)));
	end
end

function StatOverviewWindow:MouseUp(args)
	local dragging = self.dragging;
	CombatAnalysisWindow.MouseUp(self,args);
	if (dragging and not self.minimized) then
		local x,y = WindowManager.GetPositionOnScreen(self.selected.panel);
		local w,h = self.selected.panel:GetSize();
		self.selected.panel.chatSendWindow:SetPosition((x+(w-122)/2),(y+(h-CombatAnalysisWindow.border-19)));
	end
end

function StatOverviewWindow:SetSelectedTab(tab,preventUpdate,dontSave)
	-- hide the chat send button of previously selected tab
	if (self.selected ~= nil) then
		self.selected.panel.speechButtonWindow:SetVisible(false);
		self.selected.panel.chatButtonWindow:SetVisible(false);
		self.selected.panel.infoButtonWindow:SetVisible(false);
		self.selected.panel.chatSendWindow:SetSize(0,0);
	end
	
	-- select the new tab
	CombatAnalysisTabbedWindow.SetSelectedTab(self,tab,preventUpdate,dontSave);
	
	-- show the chat send button of the newly selected tab
	if (not self.minimized) then
		self.selected.panel.chatButtonWindow:SetVisible(self.selected.showSendChat);
		if (self.selected.panel.tab.chatSendEnabled and self.selected.showSendChat) then
			self.selected.panel.chatSendWindow:SetSize(100,19);
		else
			self.selected.panel.chatSendWindow:SetSize(0,0);
		end
		
		-- hack to ensure new button displayed properly
		self:SetVisible(false,true);
		self:SetVisible(true,false);
		
		-- put chat send button in correct location
		local x,y = WindowManager.GetPositionOnScreen(self.selected.panel);
		local w,h = self.selected.panel:GetSize();
		self.selected.panel.chatSendWindow:SetPosition((x+(w-122)/2),(y+(h-CombatAnalysisWindow.border-19)));
	end
end


-- Save state method
function StatOverviewWindow:SaveState()
	-- x pos, y pos, w, h, show background, background opacity, show bottom right icon, title bar width, auto hide tabs, closable, id, minimized, unmin w, unmin h
	settings.windowStates[EncodeNumbers(self.id)] = (not self.windowClosed and {
			["x"] = EncodeNumbers(self.x), ["y"] = EncodeNumbers(self.y), ["w"] = EncodeNumbers(self.w), ["h"] = EncodeNumbers(self.h),
			["showBackground"] = self.showBackground, ["showTitleBar"] = (self.titleBarWidth > 0 and true or false),
			["autoHideTabs"] = (self.autoHideTabs or self.prevAutoHideTabs), ["minimized"] = self.minimized,
      ["backgroundColor"] = EncodeNumbers(Misc.TableCopy(self.color))
		} or nil);
	
	SaveSettings();
end

-- Restore state method
function StatOverviewWindow.RestoreState(windowId,savedState)
	local newWindow = StatOverviewWindow(savedState["showBackground"],savedState["showTitleBar"],savedState["autoHideTabs"],{},windowId);
	
	-- default location
	if (savedState["x"] == nil) then
		savedState["x"] = (Turbine.UI.Display.GetWidth()-2*savedState["w"])/2-5;
	end
	if (savedState["y"] == nil) then
		savedState["y"] = (Turbine.UI.Display.GetHeight()-savedState["h"])/2;
	end
	
	local w = savedState["w"];
	local h = savedState["h"];
	
	if (savedState["minimized"]) then
    Misc.SetValue(newWindow,"w",savedState["w"]);
    Misc.SetValue(newWindow,"h",savedState["h"]);
    
		w = CombatAnalysisWindow.smallTitleBarWidth+2*CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover+15;
		h = CombatAnalysisWindow.titleBarHeight+2*CombatAnalysisWindow.border+2*CombatAnalysisWindow.resizeHangover;
		
    Misc.SetValue(newWindow,"minimized",true);
		newWindow.titleContent.minimize:SetBackground("CombatAnalysis/Resources/titlebar_max.tga");
		newWindow:SetResizable(false);
	end
	
	newWindow:SetSize(w,h,savedState["minimized"]);
	newWindow:SetPosition(WindowManager.ValidatePosition(savedState["x"],savedState["y"],w,h,0,
																											 CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover));
	newWindow:Layout();
	return newWindow;
end
