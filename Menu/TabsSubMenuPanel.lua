
_G.TabsSubMenuPanel = class(Turbine.UI.Control);

function TabsSubMenuPanel:Constructor(window,width,parent)
	Turbine.UI.Control.Constructor(self);
	
  self.selectedTab = nil;
  
	self.window = window;
	self.width = width;
  self.parent = parent;
  self.height = 607;
  
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
  
  tabsAndWindowsBox.tabsMenu = self;
  
  self.tabSettingsTitle = PanelDivider(L.TabSettingsTitle,self.content);
  self.tabSettingsTitle:SetTop(244);
  
  self.selectedTabComboBox = ColoredLabelledComboBox(self.window, L.SelectedTab..": ", self.width-90, LabelledComboBox.TextOnLeft, Turbine.UI.ContentAlignment.MiddleRight);
  self.selectedTabComboBox:SetParent(self.content);
	self.selectedTabComboBox:SetTop(298);
  TooltipManager.SetTooltip(self.selectedTabComboBox.text,L.SelectedTabTooltip,TooltipStyle.LOTRO,500);
  
  self.selectedTabComboBox.SelectionChanged = function(sender,tab)
    self:SelectTab(tab);
  end
  
  self.tabSettingsPanel = Turbine.UI.Control();
  self.tabSettingsPanel:SetParent(self.content);
  self.tabSettingsPanel:SetTop(338);
  self.tabSettingsPanel:SetSize(self.width-20,234);
  self.tabSettingsPanel:SetBackColor(blueBorderColor);
  
  self.tabSettingsPanelBackground = Turbine.UI.Control();
  self.tabSettingsPanelBackground:SetParent(self.tabSettingsPanel);
  self.tabSettingsPanelBackground:SetPosition(1,1);
  self.tabSettingsPanelBackground:SetSize(self.width-22,232);
  self.tabSettingsPanelBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.colorSchemeLabel = MenuLabel(self.tabSettingsPanelBackground,18,120,15,"14");
  self.colorSchemeLabel:SetLeft(55);
  self.colorSchemeLabel:SetText(L.ColorScheme..":");
  self.colorSchemeLabel:SetMouseVisible(true);
  self.colorSchemeLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.colorSchemeLabel,L.ColorSchemeTooltip,TooltipStyle.LOTRO,500);
  
  self.colorScheme = ColorPicker();
  self.colorScheme:SetParent(self.tabSettingsPanelBackground);
  self.colorScheme:SetPosition(32,40);
  
  self.colorScheme.ColorChanged = function(sender,newColor)
    if (self.selectedTab ~= nil) then
      self.selectedTab:UpdateColor(newColor);
    end
  end
  
  self.tempMoraleColorLabel = MenuLabel(self.tabSettingsPanelBackground,18,120,15,"14");
  self.tempMoraleColorLabel:SetLeft(235);
  self.tempMoraleColorLabel:SetText(L.TempMorale..":");
  self.tempMoraleColorLabel:SetMouseVisible(true);
  self.tempMoraleColorLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.tempMoraleColorLabel,L.TempMoraleTooltip,TooltipStyle.LOTRO,500);
  
  self.tempMoraleColor = ColorPicker();
  self.tempMoraleColor:SetParent(self.tabSettingsPanelBackground);
  self.tempMoraleColor:SetPosition(205,40);
  
  self.tempMoraleColor.ColorChanged = function(sender,newColor)
    if (self.selectedTab == healTab) then
      self.selectedTab:UpdateColor2(newColor);
    end
  end
  
  self.autoSelectPlayer = Turbine.UI.Lotro.CheckBox();
  self.autoSelectPlayer:SetParent(self.tabSettingsPanelBackground);
	self.autoSelectPlayer:SetPosition(20,197);
  self.autoSelectPlayer:SetSize(self.width-62,20);
	self.autoSelectPlayer:SetMultiline(false);
	self.autoSelectPlayer:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.autoSelectPlayer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.autoSelectPlayer:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.autoSelectPlayer:SetForeColor(control2LightColor);
	self.autoSelectPlayer:SetText(" " .. L.AutoSelectPlayer);
  TooltipManager.SetTooltip(self.autoSelectPlayer,L.AutoSelectPlayerTooltip,TooltipStyle.LOTRO,500);
  
	self.autoSelectPlayer.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	self.autoSelectPlayer.MouseDoubleClick = function(sender,args)
		self.autoSelectPlayer:SetChecked(not self.autoSelectPlayer:IsChecked());
	end
	
	self.autoSelectPlayer.CheckedChanged = function(sender,args)
		if (self.selectedTab ~= nil and self.selectedTab.autoSelectPlayer ~= self.autoSelectPlayer:IsChecked()) then
			Misc.SetValue(self.selectedTab,"autoSelectPlayer",self.autoSelectPlayer:IsChecked());
      self.selectedTab:SaveState();
		end
	end
end

function TabsSubMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.content:SetSize(math.max(self.width,w-20),math.max(self.height,h-20));
	
  self.windowsTitle:SetLeft(math.max(0,(w-20-self.width)/2)-2);
  self.tabsAndWindowsInstructions:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  tabsAndWindowsBox:SetLeft(math.max(0,(w-20-self.width)/2)+16);
  
  self.tabSettingsTitle:SetLeft(math.max(0,(w-20-self.width)/2)-2);
  self.selectedTabComboBox:SetLeft(math.max(0,(w-20-self.width)/2)+24);
  self.tabSettingsPanel:SetLeft(math.max(0,(w-20-self.width)/2)+10);
end

function TabsSubMenuPanel:ContentSelected()
  tabsAndWindowsBox:SetParent(self);
  
  if (self.selectedTab ~= nil) then
    tabsAndWindowsBox:SelectTab(self.selectedTab);
  end
end

function TabsSubMenuPanel:ContentDeselected()
  tabsAndWindowsBox:SetParent(nil);
end

function TabsSubMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
end

function TabsSubMenuPanel:AddTab(tab)
  self.selectedTabComboBox:AddItem(tab.titleText[4], tab, nil, nil, nil, nil, nil, nil, tab.titleText[5]);
  
  Misc.AddListener(tab,"color",function()
    if (self.selectedTab == tab) then
      self.tabSettingsPanel:SetBackColor(Misc.SetAlpha(Misc.SetShade(tab.color,0.1,0.2),0.975));
      self.tabSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(tab.color,0.014,0.015),0.975));
      
      self.colorScheme:SetAllColors(tab.color);
      
      if (tab == healTab) then
        self.tempMoraleColor:SetAllColors(tab.tempMoraleColor);
      end
    end
    
    local color = (tab.color.R == 0 and tab.color.G == 0 and tab.color.B == 0 and Turbine.UI.Color(0.01,0.01,0.01) or tab.color);
    
    self.selectedTabComboBox:UpdateItem(tab,
      nil, --Misc.SetShade(Misc.SimpleToGray(1,color,3/7),0.65/3,1.3/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.25/0.8),0.65/3,1.3/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.2/0.65),0.525/3,1.05/3),
      Misc.SetShade(Misc.SimpleToGray(1,color,0.18/0.67),0.515/3,1.03/3));
  end,self,self);
  
  if (self.selectedTabComboBox:GetItemCount() == 1) then
    self.selectedTabComboBox:SetSelection(tab);
  end
end

function TabsSubMenuPanel:SelectTab(tab)
  tabsAndWindowsBox:SelectTab(tab);
  uiMenuPanel.subMenuPane:SelectTab(1);
  
  if (self.selectedTab == tab) then return end
  
  -- remove existing listeners
  
  if (self.selectedTab ~= nil) then
    Misc.RemoveListener(self.selectedTab, "autoSelectPlayer", self);
  end
  
  -- update selected tab
  
  self.selectedTab = tab;
  
  -- update dependants
  
  self.selectedTabComboBox:SetSelection(tab);
  tabsAndWindowsBox:SelectTab(tab);
  uiMenuPanel.subMenuPane:SelectTab(1);
  
  -- update all the fields & styles immediately
  
  self.colorScheme.defaultColor = tab.defaultColor;
  
  if (tab.color ~= nil) then
    self.tabSettingsPanel:SetBackColor(Misc.SetAlpha(Misc.SetShade(tab.color,0.1,0.2),0.975));
    self.tabSettingsPanelBackground:SetBackColor(Misc.SetAlpha(Misc.SetShade(tab.color,0.014,0.015),0.975));
    
    self.colorScheme:SetAllColors(tab.color);
  end
  
  if (tab == healTab) then
    self.tempMoraleColorLabel:SetVisible(true);
    self.tempMoraleColor:SetVisible(true);
    
    if (tab.tempMoraleColor ~= nil) then
      self.tempMoraleColor:SetAllColors(tab.tempMoraleColor);
      self.tempMoraleColor.defaultColor = tab.defaultTempMoraleColor;
    end
    
    self.colorSchemeLabel:SetLeft(55);
    self.colorScheme:SetLeft(32);
  else
    self.tempMoraleColorLabel:SetVisible(false);
    self.tempMoraleColor:SetVisible(false);
    
    self.colorSchemeLabel:SetLeft(142);
    self.colorScheme:SetLeft(119);
  end
  
  if (tab.isBuffTab) then
    self.autoSelectPlayer:SetVisible(false);
    
    self.colorSchemeLabel:SetTop(34);
    self.colorScheme:SetTop(56);
  else
    self.autoSelectPlayer:SetVisible(true);
    
    self.colorSchemeLabel:SetTop(18);
    self.colorScheme:SetTop(40);
  end
  
  -- update values
  
  self.autoSelectPlayer:SetChecked(self.selectedTab.autoSelectPlayer);
  
  -- add listeners from all values
  
  Misc.AddListener(self.selectedTab, "autoSelectPlayer", function(sender)
		sender.autoSelectPlayer:SetChecked(self.selectedTab.autoSelectPlayer);
	end, self, self);
end