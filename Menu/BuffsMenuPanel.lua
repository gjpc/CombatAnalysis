
_G.BuffsMenuPanel = class(Turbine.UI.Control);

function BuffsMenuPanel:Constructor(window,parent)
	Turbine.UI.Control.Constructor(self);
	
	self.window = window;
	self.width = 420;
	self.height = 147;
  self.baseHeight = self.height;
  self.parent = parent;
	
  self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
  
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self);
	self.listBox:SetPosition(5,5);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self.listBox);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self.content:SetMouseVisible(false);
  
  self.title = PanelDivider(L.TraitConfigurationsTitle,self.content);
  self.title:SetTop(12);
  
  self.traitConfiguration = ColoredLabelledComboBox(self.window, L.SelectedConfiguration, 360);
  self.traitConfiguration:SetParent(self.content);
	self.traitConfiguration:SetTop(56);
  TooltipManager.SetTooltip(self.traitConfiguration.text,L.SelectedConfigurationTooltip,TooltipStyle.LOTRO,500);
  
  self.addRemoveControl = AddRemove();
  self.addRemoveControl:SetParent(self.content);
  self.addRemoveControl:SetTop(86);
  TooltipManager.SetTooltip(self.addRemoveControl.addControl,L.AddConfigurationTooltip,TooltipStyle.LOTRO,500);
  TooltipManager.SetTooltip(self.addRemoveControl.removeControl,L.RemoveConfigurationTooltip,TooltipStyle.LOTRO,500);
  
  self.colorPicker = TraitColorPicker(self.content,190,86,200,nil,true);
  
  self.subMenuPane = TabbedPane(nil,self);
  self.subMenuPane:SetParent(self.content);
  self.subMenuPane:SetTop(125);
  self.subMenuPane:SetWidth(self.width-30);
  
  self.tempMoraleSubMenuPanel = BuffsSubMenuPanel(nil,self.width-24,self);
  self.buffsSubMenuPanel = BuffsSubMenuPanel(nil,self.width-24,self);
  self.debuffsSubMenuPanel = BuffsSubMenuPanel(nil,self.width-24,self);
  self.crowdControlSubMenuPanel = BuffsSubMenuPanel(nil,self.width-24,self);
  
  self.subMenuPane:AddTab(L.Buffs,self.buffsSubMenuPanel);
  self.subMenuPane:AddTab(L.Debuffs,self.debuffsSubMenuPanel);
  self.subMenuPane:AddTab(L.CC,self.crowdControlSubMenuPanel);
  self.subMenuPane:AddTab(L.Bubbles,self.tempMoraleSubMenuPanel);
  
  Misc.DetermineLength(L.Class,Turbine.UI.Lotro.Font.TrajanPro14,function(sender,width)
    for _,tab in ipairs(self.subMenuPane.tabs) do
      tab.content.classHeader:SetWidth(width);
      tab.content.classSortTriangle:SetLeft(10+width+3);
    end
  end,nil);
  
	self.listBox:AddItem(self.content);
	
	self.hScroll = Turbine.UI.Lotro.ScrollBar();
	self.hScroll:SetParent(self);
	self.hScroll:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.hScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.hScroll:SetHeight(10);
	self.listBox:SetHorizontalScrollBar(self.hScroll);
end

function BuffsMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.listBox:SetSize(w-10,h-12);
	self.content:SetSize(math.max(self.width,w-10),math.max(self.height,h-12));
  
  self.title:SetLeft(math.max(0,(w-20-self.width)/2)+10);
  
  self.traitConfiguration:SetLeft(math.max(0,(w-20-self.width)/2)+30);
  
  self.addRemoveControl:SetLeft(math.max(0,(w-20-self.width)/2)+46);
  self.colorPicker:SetLeft(math.max(0,(w-20-self.width)/2)+199);
  
  self.subMenuPane:SetLeft(math.max(0,(w-20-self.width)/2)+16);
  
	self.hScroll:SetTop(h-10);
	self.hScroll:SetWidth(w);
end

function BuffsMenuPanel:SetTraits(traits,dontAddListeners)
  _G.tempMoraleSkills = {}
  _G.buffs = {}
  _G.buffApplications = {}
  
  for _,skillInfo in ipairs(traits.tempMorale) do
    AddSkillInfo("TempMorale", skillInfo);
  end
  for _,skillInfo in ipairs(traits.buffs) do
    AddSkillInfo("Buff", skillInfo);
  end
  
  table.sort(buffs,function(a,b) return a.skillName < b.skillName end);
  
  self.tempMoraleSubMenuPanel:SetBuffs("TempMorale",traits.tempMorale);
  self.buffsSubMenuPanel:SetBuffs("Buff",traits.buffs);
  
  local sortedConfigurations = {}
  for name,configuration in pairs(traits.configurations) do
    table.insert(sortedConfigurations,{name,configuration});
  end
  table.sort(sortedConfigurations,function(a,b) return a[1] < b[1] end);
  
  for _,configuration in ipairs(sortedConfigurations) do
    local color = _G.TraitConfigTextToColor(configuration[2].color);
    self.traitConfiguration:AddItem(configuration[1],configuration[2],nil,nil,nil,
        --Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
        Misc.SetShade(Misc.SimpleToGray(1,color,0.125/0.8),0/3,3/3),
        Misc.SetShade(Misc.SimpleToGray(1,color,0.1/0.65),0/3,3/3),
        Misc.SetShade(Misc.SimpleToGray(1,color,0.09/0.67),0/3,3/3));
  end
  
  table.sort(traits.tempMorale,function(a,b) return a.skillName < b.skillName end);
  table.sort(traits.buffs,function(a,b) return a.skillName < b.skillName end);
  
  if (not dontAddListeners) then
    self.traitConfiguration.SelectionChanged = function(sender,args)
      local selected = (self.traitConfiguration.selection ~= -1 and self.traitConfiguration.listBox:GetItem(self.traitConfiguration.selection).label:GetText() or nil);
      
      local first = self.init;
      self.init = nil;
      if (traits.selected == selected and not first) then return end
      
      traits.selected = selected;
      if (not first) then SaveTraits() end
      Misc.NotifyListeners(nil, "traitConfigurationSelected", traits.selected);
    end
    
    Misc.AddListener(nil, "traitConfigurationAdded", function(sender,name)
      local configuration = traits.configurations[name];
      local color = _G.TraitConfigTextToColor(configuration.color);
      
      local index = self.traitConfiguration.listBox:GetItemCount()+1;
      for i=1,self.traitConfiguration.listBox:GetItemCount() do
        local configName = self.traitConfiguration.listBox:GetItem(i).label:GetText();
        
        if (configName > name) then
          index = i;
          break;
        end
      end
      
      self.traitConfiguration:AddItem(name,configuration,index,nil,nil,
          --Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
          Misc.SetShade(Misc.SimpleToGray(1,color,0.125/0.8),0/3,3/3),
          Misc.SetShade(Misc.SimpleToGray(1,color,0.1/0.65),0/3,3/3),
          Misc.SetShade(Misc.SimpleToGray(1,color,0.09/0.67),0/3,3/3));
      
      self.traitConfiguration:SetSelection(configuration);
    
    end, self, self);
    
    Misc.AddListener(nil, "traitConfigurationRemoved", function(sender,name)
      for i=1,self.traitConfiguration.listBox:GetItemCount() do
        local configName = self.traitConfiguration.listBox:GetItem(i).label:GetText();
        
        if (configName == name) then
          self.traitConfiguration:RemoveItem(self.traitConfiguration.listBox:GetItem(i).value);
          break;
        end
      end
    end, self, self);
    
    Misc.AddListener(nil, "traitConfigurationSelected", function (sender,name)
      if (self.configuration ~= nil) then
        Misc.RemoveListener(self.configuration,"color",self);
      end
      
      self.traitConfiguration:SetSelection(traits.selected ~= nil and traits.configurations[traits.selected] or nil);
      
      self:SetTraitConfiguration(traits.selected ~= nil and traits.configurations[traits.selected] or nil);
      
      self.addRemoveControl.removeControl:SetEnabled(self.configuration ~= nil and self.configuration.deletable or false);
      self.colorPicker:SetEnabled(self.configuration ~= nil and self.configuration.deletable or false);
      
      if (self.configuration ~= nil) then
        self.colorPicker:SetSelectedColor(self.configuration.color);
        self.subMenuPane.tabs[2]:SetColor(self.configuration.color);
        self.subMenuPane.tabs[3]:SetColor(self.configuration.color);
        
        Misc.AddListener(self.configuration,"color",function(sender,color)
        self.colorPicker:SetSelectedColor(color);
        self.subMenuPane.tabs[2]:SetColor(color);
        self.subMenuPane.tabs[3]:SetColor(color);
        color = TraitConfigTextToColor(color);
        self.traitConfiguration:UpdateItem(self.configuration,nil,nil,
            --Misc.SetShade(Misc.SimpleToGray(1,color,1/6),0.4/3,0.8/3),
            Misc.SetShade(Misc.SimpleToGray(1,color,0.125/0.8),0/3,3/3),
            Misc.SetShade(Misc.SimpleToGray(1,color,0.1/0.65),0/3,3/3),
            Misc.SetShade(Misc.SimpleToGray(1,color,0.09/0.67),0/3,3/3));
        end, self, self);
      end
    end, self, self);
    
    self.addRemoveControl.addControl.MouseClick = function(sender,args)
      addConfigurationDialog:Show();
    end
    
    self.addRemoveControl.removeControl.MouseClick = function(sender,args)
      if (self.addRemoveControl.removeControl.disabled) then return end
      
      dialog:ShowConfirmDialog(L.RemoveTraitConfigurationConfirmation,Traits.RemoveTraitConfiguration,traits.selected)
    end
    
    self.colorPicker.SelectionChanged = function(sender,color)
      Traits.UpdateTraitConfigurationColor(traits.selected,color);
    end
    
    Misc.DetermineLength(L.BuffName,Turbine.UI.Lotro.Font.TrajanPro14,function(sender,width)
      self.tempMoraleSubMenuPanel.buffHeader:SetWidth(width);
      self.tempMoraleSubMenuPanel.buffSortTriangle:SetLeft(10+width+3);
      self.buffsSubMenuPanel.buffHeader:SetWidth(width);
      self.buffsSubMenuPanel.buffSortTriangle:SetLeft(10+width+3);
    end);
    
    Misc.DetermineLength(L.DebuffName,Turbine.UI.Lotro.Font.TrajanPro14,function(sender,width)
      self.debuffsSubMenuPanel.buffHeader:SetWidth(width);
      self.debuffsSubMenuPanel.buffSortTriangle:SetLeft(10+width+3);
      self.crowdControlSubMenuPanel.buffHeader:SetWidth(width);
      self.crowdControlSubMenuPanel.buffSortTriangle:SetLeft(10+width+3);
    end);
  end
  
  self.init = true;
  self.traitConfiguration:SetSelection(traits.configurations[traits.selected]);
  
  self.subMenuPane:Layout();
end

function BuffsMenuPanel:SetTraitConfiguration(configuration)
  self.configuration = configuration;
  
  if (self.configuration ~= nil) then
    table.sort(self.configuration.debuffs,function(a,b)
      if (b.removalOnly and not a.removalOnly) then return true end
      if (a.removalOnly and not b.removalOnly) then return false end
      return a.skillName < b.skillName;
    end);
    table.sort(self.configuration.crowdControl,function(a,b)
      if (b.removalOnly and not a.removalOnly) then return true end
      if (a.removalOnly and not b.removalOnly) then return false end
      return a.skillName < b.skillName;
    end);
  end
  
  _G.SetTraitConfiguration(self.configuration,true);
  
  if (self.configuration ~= nil) then
    self.debuffsSubMenuPanel:SetBuffs("Debuff",self.configuration.debuffs);
    self.crowdControlSubMenuPanel:SetBuffs("CrowdControl",self.configuration.crowdControl);
  end
  
  if (self.subMenuPane.selected == 2 or self.subMenuPane.selected == 3) then
    self.subMenuPane:Layout();
  end
end

function BuffsMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
  
  KeyManager.TakeFocus(self);
end