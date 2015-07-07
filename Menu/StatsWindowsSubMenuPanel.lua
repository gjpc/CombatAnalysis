
_G.StatsWindowsSubMenuPanel = class(Turbine.UI.Control);

function StatsWindowsSubMenuPanel:Constructor(statsWindow,width,parent)
	Turbine.UI.Control.Constructor(self);
	
  self.selectedWindow = nil;
  
	self.statsWindow = statsWindow;
	self.width = width;
  self.parent = parent;
  self.height = 682;
  
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self:SetHeight(self.height);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self);
  self.content:SetPosition(10,10);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	
	self.statsWindowsTitle = PanelDivider(L.StatsWindowsConfigurationTitle,self.content);
  self.statsWindowsTitle:SetTop(6);
	
  self.tabsAndWindowsInstructions = MenuLabel(self.content,43,self.width,50);
  self.tabsAndWindowsInstructions:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
  self.tabsAndWindowsInstructions:SetText(L.StatsWindowsDescription);
  
  statsWindowsBox.windowsMenu = self;
  statsWindowsBox:SetParent(self);
  
  self.statsWindowSettingsTitle = PanelDivider(L.StatsWindowSettingsTitle,self.content);
  self.statsWindowSettingsTitle:SetTop(244);
  
  self.selectedWindowComboBox = ColoredLabelledComboBox(self.statsWindow, L.SelectedWindow..": ", self.width-92, LabelledComboBox.TextOnLeft, Turbine.UI.ContentAlignment.MiddleRight);
  self.selectedWindowComboBox:SetParent(self.content);
	self.selectedWindowComboBox:SetTop(298);
  TooltipManager.SetTooltip(self.selectedWindowComboBox.text,L.SelectedWindowTooltip,TooltipStyle.LOTRO,500);
  
  self.selectedWindowComboBox.SelectionChanged = function(sender,statsWindow)
    self:SelectWindow(statsWindow);
  end
  
  self.statsWindowSettingsPanel = Turbine.UI.Control();
  self.statsWindowSettingsPanel:SetParent(self.content);
  self.statsWindowSettingsPanel:SetTop(338);
  self.statsWindowSettingsPanel:SetSize(self.width-20,308);
  self.statsWindowSettingsPanel:SetBackColor(Turbine.UI.Color(0.2,0.2,0.2));
  
  self.statsWindowSettingsPanelBackground = Turbine.UI.Control();
  self.statsWindowSettingsPanelBackground:SetParent(self.statsWindowSettingsPanel);
  self.statsWindowSettingsPanelBackground:SetPosition(1,1);
  self.statsWindowSettingsPanelBackground:SetSize(self.width-22,306);
  self.statsWindowSettingsPanelBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.backgroundColorLabel = MenuLabel(self.statsWindowSettingsPanelBackground,18,120,15,"14");
  self.backgroundColorLabel:SetLeft(248);
  self.backgroundColorLabel:SetText(L.Background..":");
  self.backgroundColorLabel:SetMouseVisible(true);
  self.backgroundColorLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.backgroundColorLabel,L.StatsBackgroundTooltip,TooltipStyle.LOTRO,500);
  
  self.backgroundColor = ColorPicker();
  self.backgroundColor:SetParent(self.statsWindowSettingsPanelBackground);
  self.backgroundColor:SetPosition(219,40);
  self.backgroundColor.minAlpha = 0;
  self.backgroundColor.defaultColor = Turbine.UI.Color(0.5,darkBackgroundColor.R,darkBackgroundColor.G,darkBackgroundColor.B);
  
  self.backgroundColor.ColorChanged = function(sender,newColor)
    if (self.selectedWindow ~= nil) then
      self.selectedWindow:SetBackgroundColor(newColor);
    end
  end
  
  self.tabsLabel = MenuLabel(self.statsWindowSettingsPanelBackground,18,50,12,"14");
  self.tabsLabel:SetLeft(62);
  self.tabsLabel:SetText(L.Tabs..":");
  self.tabsLabel:SetMouseVisible(true);
  self.tabsLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.tabsLabel,L.StatsWindowTabsTooltip,TooltipStyle.LOTRO,500);
  
  self.tabsList = {}
  self.tabListeners = {}
  
  for i=1,6 do
    local tabLabel = MenuLabel(self.statsWindowSettingsPanelBackground,23+18*i,100,12,"14");
    tabLabel:SetLeft(32);
    table.insert(self.tabsList,tabLabel);
  end
  
  self.sizeLocationPanel = Turbine.UI.Control();
  self.sizeLocationPanel:SetParent(self.statsWindowSettingsPanelBackground);
  self.sizeLocationPanel:SetPosition(8,191);
  self.sizeLocationPanel:SetSize(self.width-38,56);
  self.sizeLocationPanel:SetBackColor(blueBorderColor);
  
  self.sizeLocationPanelBackground = Turbine.UI.Control();
  self.sizeLocationPanelBackground:SetParent(self.sizeLocationPanel);
  self.sizeLocationPanelBackground:SetPosition(1,1);
  self.sizeLocationPanelBackground:SetSize(self.width-40,54);
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
  
  self.centerOnScreen = Turbine.UI.Lotro.Button();
  self.centerOnScreen:SetParent(self.sizeLocationPanelBackground);
  self.centerOnScreen:SetPosition(205,16);
  self.centerOnScreen:SetWidth(135);
  self.centerOnScreen:SetText(L.CenterOnScreen);
  TooltipManager.SetTooltip(self.centerOnScreen,L.CenterStatsWindowOnScreenTooltip,TooltipStyle.LOTRO,500);
  
  self.centerOnScreen.MouseClick = function(sender,args)
    if (self.selectedWindow ~= nil) then
      self.selectedWindow.panels[1].tab:SetShowStats(3);
      
			WindowManager.CenterOnScreen(self.selectedWindow,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
      self.selectedWindow:SaveState();
		end
  end
  
  self.visibilityMode = LabelledComboBox(nil, L.Visibility, self.width-82);
  self.visibilityMode:SetParent(self.statsWindowSettingsPanelBackground);
	self.visibilityMode:SetPosition(30,267);
	self.visibilityMode:AddItem(L.AlwaysShow,3);
  self.visibilityMode:AddItem(L.ShowOnHover,2);
  self.visibilityMode:AddItem(L.ShowOnLock,1);
  TooltipManager.SetTooltip(self.visibilityMode.text,L.VisibilityTooltip,TooltipStyle.LOTRO,500);
	
	self.visibilityMode.SelectionChanged = function(sender,args)
    if (self.selectedWindow ~= nil and self.selectedWindow.panels[1].tab.showStats ~= self.visibilityMode:GetSelection()) then
			self.selectedWindow.panels[1].tab:SetShowStats(self.visibilityMode:GetSelection());
		end
	end
  
  self:EnableAll(false);
end

function StatsWindowsSubMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.content:SetSize(math.max(self.width,w-20),math.max(self.height,h-20));
	
  self.statsWindowsTitle:SetLeft(math.max(0,(w-20-self.width)/2)-2);
  self.tabsAndWindowsInstructions:SetLeft(math.max(0,(w-20-self.width)/2));
  statsWindowsBox:SetLeft(math.max(0,(w-20-self.width)/2)+16);
  
  self.statsWindowSettingsTitle:SetLeft(math.max(0,(w-20-self.width)/2)-2);
  self.selectedWindowComboBox:SetLeft(math.max(0,(w-20-self.width)/2)+42);
  self.statsWindowSettingsPanel:SetLeft(math.max(0,(w-20-self.width)/2)+10);
end

function StatsWindowsSubMenuPanel:MouseDown()
	if (self.statsWindow ~= nil) then WindowManager.MouseWasPressed(self.statsWindow) end
end

function StatsWindowsSubMenuPanel:SetStatsWindowSet(windowSet)
  Misc.AddListener(windowSet, "windowOpened", function(sender,window)    
    self:AddWindow(window);
  end, self, self);
  
  Misc.AddListener(windowSet, "windowClosed", function(sender,window)
    self:RemoveWindow(window);
  end, self, self);
end

function StatsWindowsSubMenuPanel:EnableAll(enabled)
  for i=1,6 do
    self.tabsList[i]:SetVisible(false);
  end
  
  self.backgroundColor:SetEnabled(enabled);
  
  self.centerOnScreen:SetEnabled(enabled);
  
  self.visibilityMode:SetEnabled(enabled);
  
  self.statsWindowSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(Turbine.UI.Color(0.5,darkBackgroundColor.R,darkBackgroundColor.G,darkBackgroundColor.B),0.014,0.02),0.975));
  self.selectedWindowComboBox.dropDownBox:SetBackColor(LabelledComboBox.DisabledColor);
end

function StatsWindowsSubMenuPanel:AddWindow(statsWindow)
  self.selectedWindowComboBox:AddItem("Window "..(self.selectedWindowComboBox:GetItemCount()+1), statsWindow);
  
  Misc.AddListener(statsWindow,"color",function()
    if (self.selectedWindow == statsWindow) then
      --self.statsWindowSettingsPanel:SetBackColor(Misc.SetAlpha(Misc.SetShade(statsWindow.color,0.1,0.2),0.975));
      self.statsWindowSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(statsWindow.color,0.014,0.02),0.975));
      
      self.backgroundColor:SetAllColors(statsWindow.color);
    end
    
    local color = (statsWindow.color.R == 0 and statsWindow.color.G == 0 and statsWindow.color.B == 0 and Turbine.UI.Color(0.01,0.01,0.01) or statsWindow.color);
    
    self.selectedWindowComboBox:UpdateItem(statsWindow,
      nil, --Misc.SetShade(Misc.SimpleToGray(1,color,3/7),0.65/3,1.3/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.25/0.8),0.65/3,1.3/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.2/0.65),0.525/3,1.05/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.18/0.67),0.515/3,1.03/3));
  end,self,self);
  
  if (self.selectedWindowComboBox:GetItemCount() == 1) then
    self:EnableAll(true);
    self.selectedWindowComboBox:SetSelection(statsWindow,true);
  end
end

function StatsWindowsSubMenuPanel:RemoveWindow(statsWindow)
  Misc.RemoveListener(statsWindow,"color",self);
  
  local index = self.selectedWindowComboBox:RemoveItem(statsWindow);
  if (index ~= nil) then
    for i=index,self.selectedWindowComboBox:GetItemCount() do
      self.selectedWindowComboBox.listBox:GetItem(i).label:SetText(L.Window.." "..i);
      if (self.selectedWindowComboBox.selection == i) then
        self.selectedWindowComboBox.label:SetText(L.Window.." "..i);
      end
    end
  end
  
  if (self.selectedWindow == statsWindow) then
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

function StatsWindowsSubMenuPanel:SelectWindow(statsWindow,dontSelectInBox)
  if (statsWindow ~= nil) then
    if (not dontSelectInBox) then statsWindowsBox:SelectWindow(statsWindow) end
    uiMenuPanel.subMenuPane:SelectTab(3);
  end
  
  if (self.selectedWindow == statsWindow) then return end
  
  -- remove existing listeners
  
  if (self.selectedWindow ~= nil) then
    Misc.RemoveListener(self.selectedWindow,"panels",self);
    for _,tab in pairs(self.tabListeners) do
      Misc.RemoveListener(tab,"color",self);
    end
    self.tabListeners = {}
    
    Misc.RemoveListener(self.selectedWindow,"x",self);
    Misc.RemoveListener(self.selectedWindow,"y",self);
    Misc.RemoveListener(self.selectedWindow,"w",self);
    Misc.RemoveListener(self.selectedWindow,"h",self);
    Misc.RemoveListener(self.selectedWindow,"minimized",self);
    
    Misc.RemoveListener(self.selectedWindow,"showStats",self);
  end
  
  -- update selected statsWindow
  
  self.selectedWindow = statsWindow;
  
  if (self.selectedWindow == nil) then return end
  
  -- update dependants
  
  self.selectedWindowComboBox:SetSelection(statsWindow);
  
  -- update all the fields & styles immediately
  
  if (statsWindow.color ~= nil) then
    --self.statsWindowSettingsPanel:SetBackColor(Misc.SetAlpha(Misc.SetShade(statsWindow.color,0.1,0.2),0.975));
    self.statsWindowSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(statsWindow.color,0.014,0.015),0.975));
    
    self.backgroundColor:SetAllColors(statsWindow.color);
  end
  
  for i=1,6 do
    if (#self.selectedWindow.panels >= i) then
      self.tabsList[i]:SetVisible(true);
      self.tabsList[i]:SetText("> "..self.selectedWindow.panels[i].tab.titleText[2].." "..L.Tab);
      self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.panels[i].tab.color,0.25/0.8),0.65/3,1.3/3));
      
      Misc.AddListener(self.selectedWindow.panels[i],"color",function()
        self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.panels[i].tab.color,0.25/0.8),0.65/3,1.3/3));
      end,self,self);
      table.insert(self.tabListeners,self.selectedWindow.panels[i]);
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
  
  if (#self.selectedWindow.panels > 0) then
    self.visibilityMode:SetSelection(self.selectedWindow.panels[1].tab.showStats);
  end
  
  -- add listeners from all values
  
  Misc.AddListener(self.selectedWindow, "panels", function(sender)
    for _,tab in pairs(self.tabListeners) do
      Misc.RemoveListener(tab,"color",self);
    end
    self.tabListeners = {}
    
    for i=1,6 do
      if (#self.selectedWindow.panels >= i) then      
        self.tabsList[i]:SetVisible(true);
        self.tabsList[i]:SetText("> "..self.selectedWindow.panels[i].tab.titleText[4]);
        self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.panels[i].tab.color,0.25/0.8),0.65/3,1.3/3));
        
        Misc.AddListener(self.selectedWindow.panels[i],"color",function()
          self.tabsList[i]:SetForeColor(Misc.SetShade(Misc.SimpleToGray(1,self.selectedWindow.panels[i].tab.color,0.25/0.8),0.65/3,1.3/3));
        end,self,self);
        table.insert(self.tabListeners,self.selectedWindow.panels[i]);
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
  
  Misc.AddListener(self.selectedWindow, "showStats", function(sender)
    self.visibilityMode:SetSelection(self.selectedWindow.panels[1].tab.showStats);
  end, self, self);
end