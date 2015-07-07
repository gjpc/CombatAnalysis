
_G.WindowsSubMenuPanel = class(Turbine.UI.Control);

function WindowsSubMenuPanel:Constructor(window,width,parent)
	Turbine.UI.Control.Constructor(self);
	
  self.selectedWindow = nil;
  
	self.window = window;
	self.width = width;
  self.parent = parent;
  self.height = 847;
  
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self:SetHeight(self.height);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self);
  self.content:SetPosition(10,10);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	
	self.windowsTitle = PanelDivider(L.TabsAndWindowsConfigurationTitle,self.content);
  self.windowsTitle:SetTop(6);
	
  self.tabsAndWindowsInstructions = MenuLabel(self.content,43,self.width-20,50);
  self.tabsAndWindowsInstructions:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
  self.tabsAndWindowsInstructions:SetText(L.TabsAndWindowsDescription);
  
  tabsAndWindowsBox.windowsMenu = self;
  
  self.windowSettingsTitle = PanelDivider(L.WindowSettingsTitle,self.content);
  self.windowSettingsTitle:SetTop(244);
  
  self.selectedWindowComboBox = ColoredLabelledComboBox(self.window, L.SelectedWindow..": ", self.width-92, LabelledComboBox.TextOnLeft, Turbine.UI.ContentAlignment.MiddleRight);
  self.selectedWindowComboBox:SetParent(self.content);
	self.selectedWindowComboBox:SetTop(298);
  TooltipManager.SetTooltip(self.selectedWindowComboBox.text,L.SelectWindowTooltip,TooltipStyle.LOTRO,500);
  
  self.selectedWindowComboBox.SelectionChanged = function(sender,window)
    self:SelectWindow(window);
  end
  
  self.windowSettingsPanel = Turbine.UI.Control();
  self.windowSettingsPanel:SetParent(self.content);
  self.windowSettingsPanel:SetTop(338);
  self.windowSettingsPanel:SetSize(self.width-20,472);
  self.windowSettingsPanel:SetBackColor(Turbine.UI.Color(0.2,0.2,0.2));
  
  self.windowSettingsPanelBackground = Turbine.UI.Control();
  self.windowSettingsPanelBackground:SetParent(self.windowSettingsPanel);
  self.windowSettingsPanelBackground:SetPosition(1,1);
  self.windowSettingsPanelBackground:SetSize(self.width-22,470);
  self.windowSettingsPanelBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.backgroundColorLabel = MenuLabel(self.windowSettingsPanelBackground,18,120,15,"14");
  self.backgroundColorLabel:SetLeft(248);
  self.backgroundColorLabel:SetText(L.Background..":");
  self.backgroundColorLabel:SetMouseVisible(true);
  self.backgroundColorLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.backgroundColorLabel,L.BackgroundTooltip,TooltipStyle.LOTRO,500);
  
  self.backgroundColor = ColorPicker();
  self.backgroundColor:SetParent(self.windowSettingsPanelBackground);
  self.backgroundColor:SetPosition(219,40);
  self.backgroundColor.minAlpha = 0;
  self.backgroundColor.defaultColor = Turbine.UI.Color(0.046154,0.4,0.4,0.4);
  
  self.backgroundColor.ColorChanged = function(sender,newColor)
    if (self.selectedWindow ~= nil) then
      self.selectedWindow:SetBackgroundColor(newColor);
    end
  end
  
  self.tabsLabel = MenuLabel(self.windowSettingsPanelBackground,18,50,12,"14");
  self.tabsLabel:SetLeft(62);
  self.tabsLabel:SetText(L.Tabs..":");
  self.tabsLabel:SetMouseVisible(true);
  self.tabsLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.tabsLabel,L.WindowTabsTooltip,TooltipStyle.LOTRO,500);
  
  self.tabsList = {}
  self.tabListeners = {}
  
  for i=1,6 do
    local tabLabel = MenuLabel(self.windowSettingsPanelBackground,23+18*i,100,12,"14");
    tabLabel:SetLeft(32);
    table.insert(self.tabsList,tabLabel);
  end
  
  self.sizeLocationPanel = Turbine.UI.Control();
  self.sizeLocationPanel:SetParent(self.windowSettingsPanelBackground);
  self.sizeLocationPanel:SetPosition(8,191);
  self.sizeLocationPanel:SetSize(self.width-38,78);
  self.sizeLocationPanel:SetBackColor(blueBorderColor);
  
  self.sizeLocationPanelBackground = Turbine.UI.Control();
  self.sizeLocationPanelBackground:SetParent(self.sizeLocationPanel);
  self.sizeLocationPanelBackground:SetPosition(1,1);
  self.sizeLocationPanelBackground:SetSize(self.width-40,76);
  self.sizeLocationPanelBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.xLabel = MenuLabel(self.sizeLocationPanelBackground,10,50,12,"14");
  self.xLabel:SetLeft(15);
  self.xLabel:SetForeColor(controlDisabledColor);
  self.xLabel:SetText(L.XPos..":");
  self.xField = MenuLabel(self.sizeLocationPanelBackground,10,50,12,"14");
  self.xField:SetLeft(60);
  self.xField:SetForeColor(controlDisabledColor);
  
  self.yLabel = MenuLabel(self.sizeLocationPanelBackground,27,50,12,"14");
  self.yLabel:SetLeft(15);
  self.yLabel:SetForeColor(controlDisabledColor);
  self.yLabel:SetText(L.YPos..":");
  self.yField = MenuLabel(self.sizeLocationPanelBackground,27,50,12,"14");
  self.yField:SetLeft(60);
  self.yField:SetForeColor(controlDisabledColor);
  
  self.wLabel = MenuLabel(self.sizeLocationPanelBackground,10,60,12,"14");
  self.wLabel:SetLeft(105);
  self.wLabel:SetForeColor(controlDisabledColor);
  self.wLabel:SetText(L.Width..":");
  self.wField = MenuLabel(self.sizeLocationPanelBackground,10,50,12,"14");
  self.wField:SetLeft(164);
  self.wField:SetForeColor(controlDisabledColor);
  
  self.hLabel = MenuLabel(self.sizeLocationPanelBackground,27,60,12,"14");
  self.hLabel:SetLeft(105);
  self.hLabel:SetText(L.Height..":");
  self.hLabel:SetForeColor(controlDisabledColor);
  self.hField = MenuLabel(self.sizeLocationPanelBackground,27,50,12,"14");
  self.hField:SetLeft(164);
  self.hField:SetForeColor(controlDisabledColor);
  
  self.minimized = Turbine.UI.Lotro.CheckBox();
  self.minimized:SetPosition(35,48);
	self.minimized:SetMultiline(false);
	self.minimized:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.minimized:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.minimized:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.minimized:SetForeColor(controlDisabledColor);
	self.minimized:SetText(L.Minimized.." ");
	self.minimized:SetParent(self.sizeLocationPanelBackground);
	self.minimized:SetSize(100,20);
  self.minimized:SetEnabled(false);
  
  self.centerOnScreen = Turbine.UI.Lotro.Button();
  self.centerOnScreen:SetParent(self.sizeLocationPanelBackground);
  self.centerOnScreen:SetPosition(205,27);
  self.centerOnScreen:SetWidth(135);
  self.centerOnScreen:SetText(L.CenterOnScreen);
  TooltipManager.SetTooltip(self.centerOnScreen,L.CenterWindowOnScreenTooltip,TooltipStyle.LOTRO,500);
  
  self.centerOnScreen.MouseClick = function(sender,args)
    if (self.selectedWindow ~= nil) then
      self.selectedWindow:SetAutoHideTabs(false);
      self.selectedWindow:SetShowBackground(true);
      
      if (self.selectedWindow.minimized) then
        Misc.SetValue(self.selectedWindow,"minimized",false);
        self.selectedWindow:ShowBottomRightIcon(true);
        self.selectedWindow:SetResizable(true);
        self.selectedWindow.titleContent.minimize:SetBackground("CombatAnalysis/Resources/titlebar_min.tga");
        self.selectedWindow:SetSize(self.selectedWindow.w,self.selectedWindow.h);
        self.selectedWindow.selected.panel:FullUpdate(self.selectedWindow.selected:Duration(),true,self.selectedWindow.selected.panel.barsPanel.selectedPlayer);
        
        if (self.selectedWindow.selected.showSendChat) then
          self.selectedWindow.selected.panel.speechButtonWindow:SetVisible(true);
          self.selectedWindow.selected.panel.chatButtonWindow:SetVisible(true);
          if (not self.selectedWindow.selected.isBuffTab) then
            self.selectedWindow.selected.panel.infoButtonWindow:SetVisible(true);
          end
          if (self.selectedWindow.selected.panel.tab.chatSendEnabled) then
            self.selectedWindow.selected.panel.chatSendWindow:SetSize(100,19);
            self.selectedWindow.selected.panel.chatSendWindow:Activate();
          end
        end
      end
      
      WindowManager.CenterOnScreen(self.selectedWindow,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
      self.selectedWindow:SaveState();
		end
  end
  
  self.autoHideTabs = MenuCheckBox(self.windowSettingsPanelBackground,20,285,self.width-62,20,L.AutoHideTabs);
	self.autoHideTabs.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and self.selectedWindow.autoHideTabs ~= self.autoHideTabs:IsChecked()) then
      self.selectedWindow:SetAutoHideTabs(self.autoHideTabs:IsChecked());
      self.selectedWindow:SaveState();
		end
	end
  TooltipManager.SetTooltip(self.autoHideTabs,L.AutoHideTabsTooltip,TooltipStyle.LOTRO,500);
  
  self.showBackground = MenuCheckBox(self.windowSettingsPanelBackground,20,310,self.width-62,20,L.ShowBackground);
	self.showBackground.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and self.selectedWindow.showBackground ~= self.showBackground:IsChecked()) then
      self.selectedWindow:SetShowBackground(self.showBackground:IsChecked());
      self.selectedWindow:SaveState();
		end
	end
  TooltipManager.SetTooltip(self.showBackground,L.ShowBackgroundTooltip,TooltipStyle.LOTRO,500);
  
  self.showTitleBar = MenuCheckBox(self.windowSettingsPanelBackground,20,335,self.width-62,20,L.ShowMiniTitleBar);
	self.showTitleBar.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and ((self.selectedWindow.titleBarWidth == 0 and self.showTitleBar:IsChecked()) or (self.selectedWindow.titleBarWidth > 0 and not self.showTitleBar:IsChecked()))) then
      self.selectedWindow:SetTitleBarWidth(self.showTitleBar:IsChecked() and CombatAnalysisWindow.defaultTitleBarWidth or 0);
      self.selectedWindow:SaveState();
		end
	end
  TooltipManager.SetTooltip(self.showTitleBar,L.ShowMiniTitleBarTooltip,TooltipStyle.LOTRO,500);
  
  self.showTitle = MenuCheckBox(self.windowSettingsPanelBackground,20,360,self.width-62,20,L.ShowTitleAndDuration);
	self.showTitle.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and self.selectedWindow.tabs[1].showTitle ~= self.showTitle:IsChecked()) then
			self.selectedWindow.tabs[1]:SetAllTabsShowTitle(self.showTitle:IsChecked());
		end
	end
  TooltipManager.SetTooltip(self.showTitle,L.ShowTitleAndDurationTooltip,TooltipStyle.LOTRO,500);
  
  self.showEncounters = MenuCheckBox(self.windowSettingsPanelBackground,20,385,self.width-62,20,L.ShowEncountersList);
	self.showEncounters.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and self.selectedWindow.tabs[1].showEncounters ~= self.showEncounters:IsChecked()) then
			self.selectedWindow.tabs[1]:SetAllTabsShowEncounters(self.showEncounters:IsChecked());
		end
	end
  TooltipManager.SetTooltip(self.showEncounters,L.ShowEncountersListTooltip,TooltipStyle.LOTRO,500);
  
  self.showTargets = MenuCheckBox(self.windowSettingsPanelBackground,20,410,self.width-62,20,L.ShowTargetsList);
	self.showTargets.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and self.selectedWindow.tabs[1].showTargets ~= self.showTargets:IsChecked()) then
			self.selectedWindow.tabs[1]:SetAllTabsShowTargets(self.showTargets:IsChecked());
		end
	end
  TooltipManager.SetTooltip(self.showTargets,L.ShowTargetsListTooltip,TooltipStyle.LOTRO,500);
  
  self.showExtraButtons = MenuCheckBox(self.windowSettingsPanelBackground,20,435,self.width-62,20,L.ShowExtraButtons);
	self.showExtraButtons.CheckedChanged = function(sender,args)
		if (self.selectedWindow ~= nil and self.selectedWindow.tabs[1].showSendChat ~= self.showExtraButtons:IsChecked()) then
			self.selectedWindow.tabs[1]:SetAllTabsShowSendChat(self.showExtraButtons:IsChecked());
		end
	end
  TooltipManager.SetTooltip(self.showExtraButtons,L.ShowExtraButtonsTooltip,TooltipStyle.LOTRO,500);
  
  self:EnableAll(false);
end

function WindowsSubMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.content:SetSize(math.max(self.width,w-20),math.max(self.height,h-20));
	
  self.windowsTitle:SetLeft(math.max(0,(w-20-self.width)/2)-2);
  self.tabsAndWindowsInstructions:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  tabsAndWindowsBox:SetLeft(math.max(0,(w-20-self.width)/2)+16);
  
  self.windowSettingsTitle:SetLeft(math.max(0,(w-20-self.width)/2)-2);
  self.selectedWindowComboBox:SetLeft(math.max(0,(w-20-self.width)/2)+42);
  self.windowSettingsPanel:SetLeft(math.max(0,(w-20-self.width)/2)+10);
end

function WindowsSubMenuPanel:ContentSelected()
  tabsAndWindowsBox:SetParent(self);
  
  if (self.selectedWindow ~= nil) then
    tabsAndWindowsBox:SelectWindow(self.selectedWindow);
  end
end

function WindowsSubMenuPanel:ContentDeselected()
  tabsAndWindowsBox:SetParent(nil);
end

function WindowsSubMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
end

function WindowsSubMenuPanel:SetWindowSet(windowsSet)
  Misc.AddListener(windowsSet, "windowOpened", function(sender,window)
    self:AddWindow(window);
  end, self, self);
  
  Misc.AddListener(windowsSet, "windowClosed", function(sender,window)
    self:RemoveWindow(window);
  end, self, self);
end

function WindowsSubMenuPanel:EnableAll(enabled)
  self.enabled = enabled;
  
  for i=1,6 do
    self.tabsList[i]:SetVisible(false);
  end
  
  self.backgroundColor:SetEnabled(enabled);
  
  self.centerOnScreen:SetEnabled(enabled);
  
  self.autoHideTabs:SetEnabled(enabled);
  self.showBackground:SetEnabled(enabled);
  self.showTitleBar:SetEnabled(enabled and (self.selectedWindow == nil or not self.selectedWindow.minimized),not enabled);
  self.showTitle:SetEnabled(enabled);
  self.showEncounters:SetEnabled(enabled);
  self.showTargets:SetEnabled(enabled);
  self.showExtraButtons:SetEnabled(enabled);
  
  self.windowSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(Turbine.UI.Color(0.046154,0.4,0.4,0.4),0.014,0.02),0.975));
  self.selectedWindowComboBox.dropDownBox:SetBackColor(LabelledComboBox.DisabledColor);
end

function WindowsSubMenuPanel:AddWindow(window)
  self.selectedWindowComboBox:AddItem(L.Window.." "..(self.selectedWindowComboBox:GetItemCount()+1), window);
  
  Misc.AddListener(window,"color",function()
    if (self.selectedWindow == window) then
      --self.windowSettingsPanel:SetBackColor(Misc.SetAlpha(Misc.SetShade(window.color,0.1,0.2),0.975));
      self.windowSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(window.color,0.014,0.02),0.975));
      
      self.backgroundColor:SetAllColors(window.color);
    end
    
    local color = (window.color.R == 0 and window.color.G == 0 and window.color.B == 0 and Turbine.UI.Color(0.01,0.01,0.01) or window.color);
    
    self.selectedWindowComboBox:UpdateItem(window,
      nil, --Misc.SetShade(Misc.SimpleToGray(1,color,3/7),0.65/3,1.3/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.25/0.8),0.65/3,1.3/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.2/0.65),0.525/3,1.05/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.18/0.67),0.515/3,1.03/3));
  end,self,self);
  
  if (self.selectedWindowComboBox:GetItemCount() == 1) then
    self:EnableAll(true);
    self.selectedWindowComboBox:SetSelection(window,true);
  end
end

function WindowsSubMenuPanel:RemoveWindow(window)
  Misc.RemoveListener(window,"color",self);
  
  local index = self.selectedWindowComboBox:RemoveItem(window);
  if (index ~= nil) then
    for i=index,self.selectedWindowComboBox:GetItemCount() do
      self.selectedWindowComboBox.listBox:GetItem(i).label:SetText(L.Window.." "..i);
      if (self.selectedWindowComboBox.selection == i) then
        self.selectedWindowComboBox.label:SetText(L.Window.." "..i);
      end
    end
  end
  
  if (self.selectedWindow == window) then
    if (self.selectedWindowComboBox:GetItemCount() > 0) then
      self:SelectWindow(self.selectedWindowComboBox.listBox:GetItem(1).value,true);
    else
      self:SelectWindow(nil,true);
    end
  end
  
  if (self.selectedWindowComboBox:GetItemCount() == 0) then
    self:EnableAll(false);
  end
end

function WindowsSubMenuPanel:SelectWindow(window,dontSelectInBox)
  if (window ~= nil) then
    if (not dontSelectInBox) then tabsAndWindowsBox:SelectWindow(window) end
    uiMenuPanel.subMenuPane:SelectTab(2);
  end
  
  if (self.selectedWindow == window) then return end
  
  -- remove existing listeners
  
  if (self.selectedWindow ~= nil) then
    Misc.RemoveListener(self.selectedWindow,"tabs",self);
    for _,tab in pairs(self.tabListeners) do
      Misc.RemoveListener(tab,"color",self);
    end
    self.tabListeners = {}
    
    Misc.RemoveListener(self.selectedWindow,"x",self);
    Misc.RemoveListener(self.selectedWindow,"y",self);
    Misc.RemoveListener(self.selectedWindow,"w",self);
    Misc.RemoveListener(self.selectedWindow,"h",self);
    Misc.RemoveListener(self.selectedWindow,"minimized",self);
    
    Misc.RemoveListener(self.selectedWindow,"autoHideTabs",self);
    Misc.RemoveListener(self.selectedWindow,"showBackground",self);
    Misc.RemoveListener(self.selectedWindow,"titleBarWidth",self);
    
    Misc.RemoveListener(self.selectedWindow,"showTitle",self);
    Misc.RemoveListener(self.selectedWindow,"showEncounters",self);
    Misc.RemoveListener(self.selectedWindow,"showTargets",self);
    Misc.RemoveListener(self.selectedWindow,"showSendChat",self);
  end
  
  -- update selected window
  
  self.selectedWindow = window;
  if (self.selectedWindow == nil) then return end
  
  -- update dependants
  
  self.selectedWindowComboBox:SetSelection(window);
  
  -- update all the fields & styles immediately
  
  if (window.color ~= nil) then
    --self.windowSettingsPanel:SetBackColor(Misc.SetAlpha(Misc.SetShade(window.color,0.1,0.2),0.975));
    self.windowSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(window.color,0.014,0.015),0.975));
    
    self.backgroundColor:SetAllColors(window.color);
  end
  
  for i=1,6 do
    if (#self.selectedWindow.tabs >= i) then
      self.tabsList[i]:SetVisible(true);
      self.tabsList[i]:SetText("> "..self.selectedWindow.tabs[i].titleText[2].." "..L.Tab);
      self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.tabs[i].color,0.25/0.8),0.65/3,1.3/3));
      
      Misc.AddListener(self.selectedWindow.tabs[i],"color",function()
        self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.tabs[i].color,0.25/0.8),0.65/3,1.3/3));
      end,self,self);
      table.insert(self.tabListeners,self.selectedWindow.tabs[i]);
    else
      self.tabsList[i]:SetVisible(false);
    end
  end
  
  if (self.selectedWindow.x ~= nil) then
    local x = math.max(0,self.selectedWindow.x + CombatAnalysisWindow.border + CombatAnalysisWindow.resizeHangover);
    self.xField:SetText(x < 1000 and x or string.format("%d,%03d",x/1000,x%1000));
    local y = math.max(0,self.selectedWindow.y + CombatAnalysisWindow.border + CombatAnalysisWindow.resizeHangover);
    self.yField:SetText(y < 1000 and y or string.format("%d,%03d",y/1000,y%1000));
    local w = self.selectedWindow.w;
    self.wField:SetText(w < 1000 and w or string.format("%d,%03d",w/1000,w%1000));
    local h = self.selectedWindow.h;
    self.hField:SetText(h < 1000 and h or string.format("%d,%03d",h/1000,h%1000));
  end
  
  self.minimized:SetChecked(self.selectedWindow.minimized);
  self.showTitleBar:SetEnabled(self.enabled and (self.selectedWindow == nil or not self.selectedWindow.minimized),true);
  self.autoHideTabs:SetChecked(self.selectedWindow.autoHideTabs);
  self.showBackground:SetChecked(self.selectedWindow.showBackground);
  self.showTitleBar:SetChecked(self.selectedWindow.titleBarWidth > 0);
  
  if (#self.selectedWindow.tabs > 0) then
    self.showTitle:SetChecked(self.selectedWindow.tabs[1].showTitle);
    self.showEncounters:SetChecked(self.selectedWindow.tabs[1].showEncounters);
    self.showTargets:SetChecked(self.selectedWindow.tabs[1].showTargets);
    self.showExtraButtons:SetChecked(self.selectedWindow.tabs[1].showSendChat);
  end
  
  -- add listeners from all values
  
  Misc.AddListener(self.selectedWindow, "tabs", function(sender)
    for _,tab in pairs(self.tabListeners) do
      Misc.RemoveListener(tab,"color",self);
    end
    self.tabListeners = {}
    
    for i=1,6 do
      if (#self.selectedWindow.tabs >= i) then
        self.tabsList[i]:SetVisible(true);
        self.tabsList[i]:SetText("> "..self.selectedWindow.tabs[i].titleText[4]);
        self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.tabs[i].color,0.25/0.8),0.65/3,1.3/3));
        
        Misc.AddListener(self.selectedWindow.tabs[i],"color",function()
          self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.tabs[i].color,0.25/0.8),0.65/3,1.3/3));
        end,self,self);
        table.insert(self.tabListeners,self.selectedWindow.tabs[i]);
      else
        self.tabsList[i]:SetVisible(false);
      end
    end
  end, self, self);
  
  Misc.AddListener(self.selectedWindow, "x", function(sender)
    local x = math.max(0,self.selectedWindow.x + CombatAnalysisWindow.border + CombatAnalysisWindow.resizeHangover);
    sender.xField:SetText(x < 1000 and x or string.format("%d,%03d",x/1000,x%1000));
  end, self, self);
  Misc.AddListener(self.selectedWindow, "y", function(sender)
    local y = math.max(0,self.selectedWindow.y + CombatAnalysisWindow.border + CombatAnalysisWindow.resizeHangover);
    self.yField:SetText(y < 1000 and y or string.format("%d,%03d",y/1000,y%1000));
  end, self, self);
  Misc.AddListener(self.selectedWindow, "w", function(sender)
    local w = self.selectedWindow.w;
    self.wField:SetText(w < 1000 and w or string.format("%d,%03d",w/1000,w%1000));
  end, self, self);
  Misc.AddListener(self.selectedWindow, "h", function(sender)
    local h = self.selectedWindow.h;
    self.hField:SetText(h < 1000 and h or string.format("%d,%03d",h/1000,h%1000));
  end, self, self);
  Misc.AddListener(self.selectedWindow, "minimized", function(sender)
    self.minimized:SetChecked(self.selectedWindow.minimized);
    self.showTitleBar:SetEnabled(self.enabled and (self.selectedWindow == nil or not self.selectedWindow.minimized),true);
  end, self, self);
  
  Misc.AddListener(self.selectedWindow, "autoHideTabs", function(sender)
    self.autoHideTabs:SetChecked(self.selectedWindow.autoHideTabs);
  end, self, self);
  Misc.AddListener(self.selectedWindow, "showBackground", function(sender)
    self.showBackground:SetChecked(self.selectedWindow.showBackground);
  end, self, self);
  Misc.AddListener(self.selectedWindow, "titleBarWidth", function(sender)
    self.showTitleBar:SetChecked(self.selectedWindow.titleBarWidth > 0);
  end, self, self);
  
  Misc.AddListener(self.selectedWindow, "showTitle", function(sender)
    sender.showTitle:SetChecked(self.selectedWindow.tabs[1].showTitle);
  end, self, self);
  Misc.AddListener(self.selectedWindow, "showEncounters", function(sender)
    sender.showEncounters:SetChecked(self.selectedWindow.tabs[1].showEncounters);
  end, self, self);
  Misc.AddListener(self.selectedWindow, "showTargets", function(sender)
    sender.showTargets:SetChecked(self.selectedWindow.tabs[1].showTargets);
  end, self, self);
  Misc.AddListener(self.selectedWindow, "showSendChat", function(sender)
    sender.showExtraButtons:SetChecked(self.selectedWindow.tabs[1].showSendChat);
  end, self, self);
end