
--[[

A Stat Overview Tab simply a standard Combat Analysis
Tab.

Stat Overview Tabs contain a StatOverviewPanel and are
automatically added to the same tab group.

They also pass on stat overview type updates to their
associated panel.

]]--

_G.StatOverviewTab = class(CombatAnalysisTab);


-- chat box print out colors
StatOverviewTab.chatboxTitleColor =  "#FFFF00";
StatOverviewTab.chatboxLightColor =  "#FFFF99";
StatOverviewTab.chatboxLightLoadColor = "#AA99FF";
StatOverviewTab.chatboxSubTitleColor =  "#FFF533";
StatOverviewTab.tempMoraleLightColor = "#DD77DD";

function StatOverviewTab:Constructor(saveKey,text,menu,chatMenu,encounters,targets,defaultTempMoraleColor,isBuffTab,defaultColor,chatColor)
	CombatAnalysisTab.Constructor(self,statOverviewTabs,text[1],menu,StatOverviewPanel(self,chatMenu,encounters,targets,(defaultTempMoraleColor ~= nil),isBuffTab));
	
	self.saveKey = saveKey;
	self.titleText = text;
	
	self.autoSelectPlayer = false;
	
  self.defaultColor = defaultColor;
  self.chatColor = (chatColor or self.defaultColor);
  self.defaultTempMoraleColor = defaultTempMoraleColor;
  
	self.showTitle = true;
	self.showEncounters = true;
	self.showTargets = true;
	self.showSendChat = true;
	
	self.isBuffTab = isBuffTab;
	
	-- create the stats panel
	if (not self.isBuffTab) then
		self.showStats = nil; -- 1 = hide, 2 = show on hover, 3 = show    
		self.statsPanel = StatOverviewStatsPanel(self,text[2],text[3],(text == L.Dmg or text == L.Taken),(text == L.Dmg),(defaultTempMoraleColor ~= nil));
	end
	
	-- add this tab to the list of stat overview tabs
	statOverviewTabs[self.saveKey] = self;
end

function StatOverviewTab:UpdateColor(color,loadFromSettings)
  CombatAnalysisTab.UpdateColor(self,color);
  
  self.panel:UpdateColor(self.color);
  
  if (not self.isBuffTab) then
    self.statsPanel:UpdateColor(self.color);
  end
  
  if (self.chatSendEnabled) then
    self.panel.chatButtonOverlay:SetBackColor(Misc.ToGray(0.2,0.8,self.color,1.5));
  else
    self.panel.chatButtonOverlay:SetBackColor(Turbine.UI.Color(0,0,0,0));
  end
  
  if (not loadFromSettings) then
    self:SaveState();
  end
end

function StatOverviewTab:UpdateColor2(color,loadFromSettings)
  Misc.SetValue(self,"tempMoraleColor",color);
  
  self.panel:UpdateColor2(self.tempMoraleColor);
  
  if (not self.isBuffTab) then
    self.statsPanel:UpdateColor2(self.tempMoraleColor);
  end
  
  if (not loadFromSettings) then
    self:SaveState();
  end
end

-- generate a new window stat overview window with the same settings as the current one
function StatOverviewTab:GenerateNewWindow(currentWindow,x,y,dontActivate)
  -- if a tab was dragged from an existing window, copy the same settings
  local window = currentWindow;
  -- otherwise, copy the settings of the newest window
  if (window == nil and #statOverviewWindows > 0) then
    local windows = {}
    for _,window in ipairs(statOverviewWindows) do
      table.insert(windows,{window.id,window});
    end
    table.sort(windows,function(a,b) return a[1] > b[1] end);
    window = windows[1][2];
  end
  -- finally, if there are no windows active, use the old window state saved in settings
  local windowState = (window or settings.oldStatOverviewWindowState);
  
  -- update tab settings if necessary
  if (currentWindow == nil) then
    tabState = (window ~= nil and window.tabs[1] or settings.oldStatOverviewWindowState);
    
    self:SetShowTitle(tabState.showTitle);
    self:SetShowEncounters(tabState.showEncounters);
    self:SetShowTargets(tabState.showTargets);
    self:SetShowSendChat(tabState.showSendChat);
  end
  
	-- create new window
	local newWindow = StatOverviewWindow(windowState.showBackground,
    (window ~= nil and window.titleBarWidth > 0) or (windowState ~= nil and windowState.showTitleBar),
    windowState.autoHideTabs,{self});
  -- configure the new window
	if ((window ~= nil and not window.resizable) or (windowState ~= nil and not windowState.showBackground)) then
		newWindow:SetResizable(false);
	end
  -- set the back color
  newWindow:SetBackgroundColor(Turbine.UI.Color(DecodeNumbers(windowState.color.A),DecodeNumbers(windowState.color.R),DecodeNumbers(windowState.color.G),DecodeNumbers(windowState.color.B)),true);
  -- set the window size/position
  local w = DecodeNumbers(windowState.w);
  local h = DecodeNumbers(windowState.h);
  if (x == nil) then x = (Turbine.UI.Display.GetWidth()-w)/2 end
  if (y == nil) then y = (Turbine.UI.Display.GetHeight()-h)/2 end
  newWindow:SetSize(w,h);
  local x,y = WindowManager.ValidatePosition(x,y,w,h,-1,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
  newWindow:SetPosition(x,y);
  
  newWindow:SetVisible(true,false,dontActivate);
  return newWindow;
end

-- called every time a new combat element is logged (a line from the combat log is parsed)
function StatOverviewTab:FullUpdate(newEnc,selectionChange)
	local duration = self:Duration();
	-- if a new target has been selected, set the view level has not yet been changed (for the auto select player details feature)
	if (selectionChange ~= nil) then
		self.viewLevelYetToBeChanged = selectionChange;
	end
	-- only update the tab if it is showing on screen
	if (self.window ~= nil and self.window:IsVisible() and not self.window.minimized and self.selected) then
		self.panel:FullUpdate(duration,newEnc);
	elseif (newEnc) then
		self.panel.barsPanel.selectedPlayer = nil;
	end
	
	if (not self.isBuffTab) then
		-- unlock the stats panel if the target has changed
		if (selectionChange and self.statsPanel.window ~= nil) then
			self.statsPanel.window:SetLocked(nil,nil,false);
		end
		-- only update the stats panel if it is showing on screen
		if (self.statsPanel.window ~= nil and self.statsPanel.window:IsVisible() and self.statsPanel.window.showingPanel == self.statsPanel) then
			self.statsPanel:FullUpdate(duration,newEnc,newEnc);
		end
	end
end

-- called every frame while in combat
function StatOverviewTab:Update()
	local duration = self:Duration();
	-- only update the tab if it is showing on screen
	if (self.window ~= nil and self.window:IsVisible() and not self.window.minimized and self.selected) then
		self.panel:Update(duration);
	end
	-- only update the stats panel if it is showing on screen
	if (not self.isBuffTab and self.statsPanel.window ~= nil and self.statsPanel.window:IsVisible() and self.statsPanel.window.showingPanel == self.statsPanel) then
		self.statsPanel:Update(duration);
	end
end

-- called only once on combat termination, or when the selected encounter/channel/info is changed
function StatOverviewTab:UpdateChatSendButton()
	-- get relevant data
	local dataSummary = self:GetData();
	local duration = self:Duration();
	
	local amounts = {};
	if (self.panel.selectedInfo ~= nil) then
		if (self.isBuffTab) then
			table.insert(amounts,{self.panel.selectedInfo,(dataSummary[self.panel.selectedInfo] == nil and 0 or (dataSummary[self.panel.selectedInfo]:CurrentDuration(timestamp)/duration))});
		else
			table.insert(amounts,{self.panel.selectedInfo,(dataSummary[self.panel.selectedInfo] == nil and 0 or dataSummary[self.panel.selectedInfo]:TotalAmount()),
				(dataSummary[self.panel.selectedInfo] ~= nil and self.panel.barsPanel.backColor2 and dataSummary[self.panel.selectedInfo].temporaryMoraleAmount or nil)});
		end
	else
		local sortedData = Misc.SortData(dataSummary,self.isBuffTab);
		local timestamp = Turbine.Engine.GetGameTime();
		
		for _,data in ipairs(sortedData) do
			if (self.isBuffTab) then
				table.insert(amounts,{data[1],(data[2]:CurrentDuration(timestamp)/duration)});
			else
				table.insert(amounts,{data[1],data[2]:TotalAmount(),(self.panel.barsPanel.backColor2 and data[2].temporaryMoraleAmount or nil)});
			end
		end
	end
	
	if (#amounts > 0) then
		-- enable chat send button
		self:EnableChatSendButton();
		
		-- build list of info
		local infoString = "";
		for index=1,math.min(#amounts,5) do
			infoString = infoString .. (#amounts == 1 and " " or "\n") ..
				"<rgb="..StatOverviewTab.chatboxSubTitleColor..">"..amounts[index][1].."</rgb> <rgb="..StatOverviewTab.chatboxTitleColor..">-</rgb> "..
				"<rgb="..Misc.DecimalToHex(self.chatColor)..">"..self.titleText[1]..":</rgb> "..
					"<rgb="..StatOverviewTab.chatboxLightColor..">"..(self.isBuffTab and Misc.FormatPerc(amounts[index][2]) or Misc.FormatValue(amounts[index][2]))..
						(not self.isBuffTab and #amounts[index] > 2 and amounts[index][3] > 0 and 
						" (<rgb="..StatOverviewTab.tempMoraleLightColor..">"..Misc.FormatValue(amounts[index][3],true).."</rgb>)" or "").."</rgb>"..
				"<rgb="..StatOverviewTab.chatboxTitleColor..">;</rgb> "..
				(not self.isBuffTab and "<rgb="..Misc.DecimalToHex(self.chatColor)..">"..self.titleText[3]..":</rgb> "..
					"<rgb="..StatOverviewTab.chatboxLightColor..">"..Misc.FormatPs(amounts[index][2]/duration,true).."</rgb>".."<rgb="..StatOverviewTab.chatboxTitleColor..">;</rgb>" or "");
		end
		
		-- update chat send button
		self.panel.chatSendShortcut:SetData(
			"/"..(self.panel.chatMenu.selectedChannel == 2 and L.Fellowship[1] or
					self.panel.chatMenu.selectedChannel == 3 and L.Raid[1] or
					self.panel.chatMenu.selectedChannel == 4 and (player.isCreep and L.Tribe or L.Kinship)[1] or
					L.Say[1]) .." "..
				"<rgb="..(encountersComboBox:GetSelectedValue().loaded and StatOverviewTab.chatboxLightLoadColor or StatOverviewTab.chatboxLightColor)..">"..
					encountersComboBox:GetSelectedValue().name.."</rgb><rgb="..StatOverviewTab.chatboxLightColor..">"..
				(self.panel.targets:GetSelectedText() == L.Totals and "" or " > "..self.panel.targets:GetSelectedText())..
				" ("..Misc.FormatDuration(duration,true)..")</rgb><rgb="..StatOverviewTab.chatboxTitleColor..">;</rgb> "..
				infoString);
		
		self.panel.chatSend:SetShortcut(self.panel.chatSendShortcut);
	else
		self:DisableChatSendButton();
	end
end

function StatOverviewTab:EnableChatSendButton()
	self.chatSendEnabled = true;
	
	if (self.window ~= nil and self.window.selected == self and not self.window.minimized and not self.window:GetWantsUpdates() and self.showSendChat) then
		self.panel.chatSendWindow:SetSize(100,19);
	end
	
	self.panel.chatButtonOverlay:SetBackColor(Misc.ToGray(0.2,0.8,self.color,1.5));
	self.panel.chatLabel:SetForeColor(Turbine.UI.Color(0.75,0.75,0.6));
end

function StatOverviewTab:SetSelected(selected)
	CombatAnalysisTab.SetSelected(self,selected);
	
	if (selected) then
		self.panel:FullUpdate(self:Duration(),true,self.panel.barsPanel.selectedPlayer);
	end
end

function StatOverviewTab:SetShowStats(newShowStats,loadFromSettings)
	if (self.showStats == newShowStats) then return end
	
	local oldShowStats = self.showStats;
	self.showStats = newShowStats;
	
	self.panel.infoButton:SetBackground("CombatAnalysis/Resources/info_button"..(self.showStats == 3 and "_border" or (self.showStats == 2 and "_quarter_border" or ""))..".tga");
	
	if (self.statsPanel.window ~= nil) then
		if (self.statsPanel.window.locked == nil) then
			if (self.showStats == 3) then
				self.statsPanel.window:SetVisible(true,loadFromSettings,loadFromSettings);
				self.statsPanel:FullUpdate(self:Duration(),true,true);
			elseif (oldShowStats == 3) then
				self.statsPanel.window:SetVisible(false);
			end
		end
		
		for _,panel in ipairs(self.statsPanel.window.panels) do
			if (panel.tab ~= self) then
				panel.tab.showStats = self.showStats;
				panel.tab.panel.infoButton:SetBackground("CombatAnalysis/Resources/info_button"..(self.showStats == 3 and "_border" or (self.showStats == 2 and "_quarter_border" or ""))..".tga");
			end
			if (not loadFromSettings) then
				panel.tab:SaveState();
			end
		end
    
    Misc.NotifyListeners(self.statsPanel.window,"showStats");
	end
end

-- called only once on beginning combat (or when there is no data to send)
function StatOverviewTab:DisableChatSendButton()
	self.chatSendEnabled = false;
	self.panel.chatSendWindow:SetSize(0,0);
	self.panel.chatButtonOverlay:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.panel.chatLabel:SetForeColor(Turbine.UI.Color(0.5,0.5,0.5));
end

-- returns the duration of the selected target
function StatOverviewTab:Duration()
	return combatData[self.panel.selectedTarget]:Duration(Turbine.Engine.GetGameTime());
end

function StatOverviewTab:SetAllTabsShowTitle(show)
	local sizeChange = ((not self.showTitle and show) and 1 or ((self.showTitle and not show) and -1 or 0))*(CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border);
	
	for _,tab in pairs(self.window.tabs) do
		tab:SetShowTitle(show);
		tab:SaveState();
	end
	
	self:DetermineMinimumWindowHeight(sizeChange);
  Misc.NotifyListeners(self.window,"showTitle");
  self.window:SaveState();
end

function StatOverviewTab:SetShowTitle(show,detMinHeight)
	self.showTitle = show;
	self.panel.durationBar:SetVisible(self.showTitle);
	self.panel.upperBorder:SetVisible(self.showTitle);
	if (detMinHeight) then self:DetermineMinimumWindowHeight(0) end
end

function StatOverviewTab:SetAllTabsShowEncounters(show)
	local sizeChange = ((not self.showEncounters and show) and 1 or ((self.showEncounters and not show) and -1 or 0))*(CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border);
	if (sizeChange == 0) then return end
	
	for _,tab in pairs(self.window.tabs) do
		tab:SetShowEncounters(show);
		tab:SaveState();
	end
	
	self:DetermineMinimumWindowHeight(sizeChange);
  Misc.NotifyListeners(self.window,"showEncounters");
	self.window:SaveState();
end

function StatOverviewTab:SetShowEncounters(show,detMinHeight)
	self.showEncounters = show;
	self.panel.encounters:SetVisible(self.showEncounters);
	self.panel.middleBorder:SetVisible(self.showEncounters);
	if (detMinHeight) then self:DetermineMinimumWindowHeight(0) end
end

function StatOverviewTab:SetAllTabsShowTargets(show)
	local sizeChange = ((not self.showTargets and show) and 1 or ((self.showTargets and not show) and -1 or 0))*(CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border);
	if (sizeChange == 0) then return end
	
	for _,tab in pairs(self.window.tabs) do
		tab:SetShowTargets(show);
		tab:SaveState();
	end
	
	self:DetermineMinimumWindowHeight(sizeChange);
  Misc.NotifyListeners(self.window,"showTargets");
	self.window:SaveState();
end

function StatOverviewTab:SetShowTargets(show,detMinHeight)
	self.showTargets = show;
	self.panel.targets:SetVisible(self.showTargets);
	self.panel.lowerBorder:SetVisible(self.showTargets);
	if (detMinHeight) then self:DetermineMinimumWindowHeight(0) end
end

function StatOverviewTab:SetAllTabsShowSendChat(show)
	local sizeChange = ((not self.showSendChat and show) and 1 or ((self.showSendChat and not show) and -1 or 0))*(19 + CombatAnalysisWindow.border);
	
	for _,tab in pairs(self.window.tabs) do
		tab:SetShowSendChat(show);
		tab:SaveState();
	end
  
  self.window.minimumWidth = (show and 178 or CombatAnalysisTabbedWindow.defaultMinWidth);
  local resize = (self.window:GetWidth() < self.window.minimumWidth);
  self:DetermineMinimumWindowHeight(sizeChange,resize);
  
  if (not self.window.minimized and resize) then
    self.window:SetWidth(self.window.minimumWidth);
    WindowManager.ConstrainWindowToScreen(self.window,0,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
    self.window:Layout();
  end
  
  Misc.NotifyListeners(self.window,"showSendChat");
	self.window:SaveState();
end

function StatOverviewTab:SetShowSendChat(show,detMinHeight)
	self.showSendChat = show;
	if (self.window ~= nil and self.window.minimized) then return end
	
	self.panel.speechButtonWindow:SetVisible(show);
	self.panel.chatButtonWindow:SetVisible(show);
	self.panel.infoButtonWindow:SetVisible(show);
	
	if (show and self.chatSendEnabled) then
		self.panel.chatSendWindow:SetSize(100,19);
	else
		self.panel.chatSendWindow:SetSize(0,0);
	end
	
	if (show) then self.panel.chatSendWindow:Activate() end
	
	if (detMinHeight and self.window ~= nil) then
		self.window.minimumWidth = (show and 178 or CombatAnalysisTabbedWindow.defaultMinWidth);
		local resize = (self.window:GetWidth() < self.window.minimumWidth);
		self:DetermineMinimumWindowHeight(0,resize);
		if (resize) then
			self.window:SetWidth(self.window.minimumWidth);
			WindowManager.ConstrainWindowToScreen(self.window,0,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
			self.window:Layout();
		end
	end
end

function StatOverviewTab:DetermineMinimumWindowHeight(sizeChange,dontResize,window)
  window = (window or self.window);
	if (window == nil) then return end
	
	-- determine and set new minimum window title border height
	window.minimumBorderHeight = ((self.showTitle or self.showEncounters or self.showTargets) and CombatAnalysisWindow.border or 0)+
																		(self.showTitle and CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border or 0)+
																		(self.showEncounters and CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border or 0)+
																		(self.showTargets and CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border or 0);
	
	-- if the window background is not showing, adjust it to cover the new title area size
	if (not window.showBackground and not window.minimized) then
		window.border:SetHeight(window.minimumBorderHeight);
	end
	
	-- determine and set new minimum window height
	window.minimumHeight = 2*CombatAnalysisWindow.resizeHangover + 7*CombatAnalysisWindow.border +
																CombatAnalysisWindow.titleBarHeight + CombatAnalysisBarsPanel.barThickness +
																(self.showTitle and CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border or 0)+
																(self.showEncounters and CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border or 0)+
																(self.showTargets and CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.border or 0)+
																(self.showSendChat and 19 + CombatAnalysisWindow.border or 0);
	
	-- change the window size by the amount of space gained or lost
	if (sizeChange ~= 0) then
    if (window.minimized) then
      Misc.SetValue(window,"h",window.h+sizeChange);
    else
      window:SetHeight(window:GetHeight()+sizeChange);
    end
    
		if (not dontResizeand and not window.minimized) then
			WindowManager.ConstrainWindowToScreen(window,0,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
			window:Layout();
		end
	end
end


-- Save state method
function StatOverviewTab:SaveState()
	-- tab window id, stats panel window id, showStats state (1->3), auto select player, show title bar, show encounters, show targets, show extra buttons, stats panel state 
	settings.tabStates[self.saveKey] = {
			["indexInWindow"] = (self.window ~= nil and EncodeNumbers(self.window:TabIndex(self)) or nil), ["selected"] = self.selected,
			["windowID"] = (self.window ~= nil and EncodeNumbers(self.window.id) or nil),
			["statsWindowID"] = (not self.isBuffTab and self.statsPanel.window ~= nil and EncodeNumbers(self.statsPanel.window.id) or nil),
			["statsWindowVisibility"] = (not self.isBuffTab and (self.showStats == 1 and "Hide" or (self.showStats == 2 and "Hover" or "Show")) or nil),
			["autoSelectPlayer"] = self.autoSelectPlayer, ["showTitle"] = self.showTitle, ["showEncounters"] = self.showEncounters,
			["showTargets"] = self.showTargets, ["showExtraButtons"] = self.showSendChat,
			["expandedStatHeadings"] = (not self.isBuffTab and self.statsPanel:GetState() or nil),
      ["colorScheme"] = EncodeNumbers(Misc.TableCopy(self.color)), ["tempMoraleColor"] = self.tempMoraleColor
		};
	
	SaveSettings();
end


