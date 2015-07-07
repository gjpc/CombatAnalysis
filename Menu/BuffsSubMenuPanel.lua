
_G.BuffsSubMenuPanel = class(Turbine.UI.Control);

function BuffsSubMenuPanel:Constructor(window,width,parent)
	Turbine.UI.Control.Constructor(self);
	
  self.buffs = {}
  
  self.selectedTab = nil;
  
	self.window = window;
	self.width = width;
  self.parent = parent;
  self.height = 600;
  
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self:SetHeight(self.height);
  
  self:SetMouseVisible(false);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self.content:SetMouseVisible(false);
	
  self.addTraitControl = Turbine.UI.Control();
  self.addTraitControl:SetParent(self.content);
  self.addTraitControl:SetPosition(17,16);
  self.addTraitControl:SetSize(220,21);
  
  self.addTraitConfiguration = Turbine.UI.Control();
  self.addTraitConfiguration:SetParent(self.addTraitControl);
  self.addTraitConfiguration:SetTop(3);
  self.addTraitConfiguration:SetSize(15,15);
  self.addTraitConfiguration:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.addTraitConfiguration:SetBackground("CombatAnalysis/Resources/add_icon.tga");
  self.addTraitConfiguration:SetMouseVisible(false);
  
  self.addTraitConfigurationLabel = MenuLabel(self.addTraitControl,0,200,21);
  self.addTraitConfigurationLabel:SetLeft(20);
  self.addTraitConfigurationLabel:SetOutlineColor(controlColor);
  self.addTraitConfigurationLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.addTraitConfigurationLabel:SetText(L.AddBuff);
  
  self.addTraitControl.MouseEnter = function(sender,args)
    self.addTraitConfigurationLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.addTraitConfigurationLabel:SetText(self.addTraitConfigurationLabel:GetText());
  end
  
  self.addTraitControl.MouseLeave = function(sender,args)
    self.addTraitConfigurationLabel:SetFontStyle(Turbine.UI.FontStyle.None);
    self.addTraitConfigurationLabel:SetText(self.addTraitConfigurationLabel:GetText());
  end
  
  self.addTraitControl.MouseClick = function(sender,args)
    if (self.dummyRow) then
      self.dummyRow:SetExpanded(true);
      for i=2,#self.buffs do
        self.buffs[i][1]:SetExpanded(false);
      end
      return;
    end
    
    local newBuff = Traits.CreateBuff(self.buffType);
    
    local title;
    local panel;
    for i,buff in ipairs(self.buffs) do
      if (buff[3] == false) then
        title = buff[1];
        panel = buff[2];
        buff[3] = true;
        table.remove(self.buffs,i);
        table.insert(self.buffs,1,buff);
        break;
      end
    end
    if (title == nil) then
      title = BuffPanelTitleNode(self,3,self.buffType);
      panel = BuffPanelNode(2,self.buffType,title,self);
      title:GetChildNodes():Add(panel);
      table.insert(self.buffs,1,{title,panel,true});
    end
    
    title:SetBuff(newBuff);
    panel:SetBuff(newBuff);
    
    self.rootNode:Clear();
    for _,buff in ipairs(self.buffs) do self.rootNode:Add(buff[1]) end
    
    self.treePanel:LayoutNode(title,0);
    self.treePanel:LayoutNode(panel,1);
    title:SetExpanded(true);
    
    self.dummyRow = title;
  end
  
  self.filter = Turbine.UI.Lotro.TextBox();
  self.filter:SetParent(self.content);
  self.filter:SetPosition(170,16);
  self.filter:SetSize(196,20);
  self.filter:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.filter:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.filter:SetForeColor(Turbine.UI.Color(0.75,0.7,0.6));
  self.filter:SetMultiline(false);
  self.filter:SetText("  "..L.FilterList);
  self.filter.clear = true;
  
  self.filter.KeyDown = function(sender,args)
    if (self.filter:HasFocus() and args.Action == 162) then
      KeyManager.TakeFocus();
    end
  end
  
  self.filter.FocusGained = function(sender,args)
    if (not self.filter.focused) then
      self.filter.focused = true;
      self.filter:SetText("");
    end
    
    self.filter:SetForeColor(Turbine.UI.Color(1,1,1));
    
    self.filter.text = self.filter:GetText();
    self.filter.clear = false;
    
    self.filter:SetWantsKeyEvents(true);
    self.filter:SetWantsUpdates(true);
  end
  
  self.filter.FocusLost = function(sender,args)
    self.filter:SetWantsKeyEvents(false);
    self.filter:SetWantsUpdates(false);
    
    if (self.filter.clear or self.filter:GetText() == "") then
      self.filter.focused = false;
      self.filter:SetForeColor(Turbine.UI.Color(0.75,0.7,0.6));
      self.filter:SetText("  "..L.FilterList);
      self.filter.clear = true;
    else
      self.filter:SetForeColor(controlYellowColor);
    end
  end
  
  self.filter.Update = function(sender,args)
    if (self.filter.text ~= self.filter:GetText()) then
      self.filter.text = self.filter:GetText();
      self:FilterList(self.filter:GetText());
      
      self.filterClear:SetVisible(self.filter.text ~= "");
    end
  end
  
  self.filterClear = Turbine.UI.Control();
  self.filterClear:SetParent(self.content);
  self.filterClear:SetPosition(170+196-19,16+4);
  self.filterClear:SetSize(19,14);
  self.filterClear:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.filterClear:SetBackground("CombatAnalysis/Resources/cross_small.tga");
  self.filterClear:SetVisible(false);
  
  self.filterClear.MouseClick = function(sender,args)
    KeyManager.TakeFocus();
    
    self.filter:SetText("");
    self.filter:Update();
    self.filter:FocusLost();
  end
  
  local a = 6;
  
  self.toBuffBarsControl = Turbine.UI.Control();
  self.toBuffBarsControl:SetParent(self.content);
  self.toBuffBarsControl:SetPosition(210,40+a);
  self.toBuffBarsControl:SetSize(166,17);
  
  self.toBuffBarsLink = MenuLabel(self.toBuffBarsControl,0,134,15,"13");
  self.toBuffBarsLink:SetMultiline(false);
  self.toBuffBarsLink:SetForeColor(Turbine.UI.Color(1,0.85,0.85));
  self.toBuffBarsLink:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
  self.toBuffBarsLink:SetOutlineColor(controlColor);
  self.toBuffBarsLink:SetText(L.ConfigureInBuffBars);
  
  self.toBuffBarsUnderline = Turbine.UI.Control();
  self.toBuffBarsUnderline:SetParent(self.toBuffBarsControl);
  self.toBuffBarsUnderline:SetPosition(5,14);
  self.toBuffBarsUnderline:SetSize(129,1);
  self.toBuffBarsUnderline:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.toBuffBarsUnderline:SetBackColor(Turbine.UI.Color(0.9,0.5,0.5));
  
  self.toBuffBarsIcon = Turbine.UI.Control();
  self.toBuffBarsIcon:SetParent(self.toBuffBarsControl);
  self.toBuffBarsIcon:SetPosition(140,1);
  self.toBuffBarsIcon:SetSize(16,16);
  self.toBuffBarsIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.toBuffBarsIcon:SetBackground("CombatAnalysis/Resources/buffbars_arrow.tga");
  
  self.toBuffBarsControl.MouseEnter = function(sender,args)
    self.toBuffBarsLink:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.toBuffBarsLink:SetText(self.toBuffBarsLink:GetText());
    self.toBuffBarsUnderline:SetBackColor(controlColor);
    self.toBuffBarsIcon:SetBackground("CombatAnalysis/Resources/buffbars_arrow_mouseover.tga");
  end
  
  self.toBuffBarsControl.MouseLeave = function(sender,args)
    self.toBuffBarsLink:SetFontStyle(Turbine.UI.FontStyle.None);
    self.toBuffBarsLink:SetText(self.toBuffBarsLink:GetText());
    self.toBuffBarsUnderline:SetBackColor(Turbine.UI.Color(0.9,0.5,0.5));
    self.toBuffBarsIcon:SetBackground("CombatAnalysis/Resources/buffbars_arrow.tga");
  end
  
  self.toBuffBarsControl.MouseClick = function(sender,args)
    if (not buffBarsLoaded or Plugins["BuffBars"] == nil) then
      dialog:ShowInfoDialog(L.BuffBarsNotLoadedMessage);
      return;
    end
    
    if (SelectEffectWindowsTabInBuffBarsMenu ~= nil) then SelectEffectWindowsTabInBuffBarsMenu() end
    Turbine.PluginManager.ShowOptions(Plugins["BuffBars"]);
  end
  
  TooltipManager.SetTooltip(self.toBuffBarsControl,L.ConfigureInBuffBarsLinkTooltip,TooltipStyle.LOTRO,500);
  
  self.classHeaderControl = Turbine.UI.Control();
  self.classHeaderControl:SetParent(self.content);
  self.classHeaderControl:SetPosition(5,61+a);
  self.classHeaderControl:SetSize(81,21);
  
  self.classHeaderControl.MouseEnter = function(sender,args)
    self.classHeader:SetForeColor(control2YellowColor);
  end
  
  self.classHeaderControl.MouseLeave = function(sender,args)
    self.classHeader:SetForeColor(control2LightColor);
  end
  
  self.classHeaderControl.MouseClick = function(sender,args)
    self:SortList(false,(not self.classHeader.selected or not self.classHeader.ascending));
  end
  
  self.classHeaderControl.MouseDoubleClick = function(sender,args)
    self.classHeaderControl:MouseClick(args);
  end
  
  self.classHeader = MenuLabel(self.classHeaderControl,0,75,21,"14");
  self.classHeader:SetLeft(10);
  self.classHeader:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.classHeader:SetText(L.Class);
  self.classHeader.selected = true;
  self.classHeader.ascending = true;
  
  self.classSortTriangle = Turbine.UI.Control();
  self.classSortTriangle:SetParent(self.classHeaderControl);
  self.classSortTriangle:SetTop(3);
  self.classSortTriangle:SetSize(16,16);
  self.classSortTriangle:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
  self.buffHeaderControl = Turbine.UI.Control();
  self.buffHeaderControl:SetParent(self.content);
  self.buffHeaderControl:SetPosition(91,61+a);
  self.buffHeaderControl:SetSize(120,21);
  
  self.buffHeaderControl.MouseEnter = function(sender,args)
    self.buffHeader:SetForeColor(control2YellowColor);
  end
  
  self.buffHeaderControl.MouseLeave = function(sender,args)
    self.buffHeader:SetForeColor(control2LightColor);
  end
  
  self.buffHeaderControl.MouseClick = function(sender,args)
    self:SortList(true,(not self.buffHeader.selected or not self.buffHeader.ascending));
  end
  
  self.buffHeaderControl.MouseDoubleClick = function(sender,args)
    self.buffHeaderControl:MouseClick(args);
  end
  
  self.buffHeader = MenuLabel(self.buffHeaderControl,0,120,21,"14");
  self.buffHeader:SetLeft(10);
  self.buffHeader:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.buffHeader.selected = false;
  self.buffHeader.descending = true;
  
  self.buffSortTriangle = Turbine.UI.Control();
  self.buffSortTriangle:SetParent(self.buffHeaderControl);
  self.buffSortTriangle:SetTop(3);
  self.buffSortTriangle:SetSize(16,16);
  self.buffSortTriangle:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.buffSortTriangle:SetBackground(nil);
  
  self.bbActive = Turbine.UI.Lotro.CheckBox();
  self.bbActive:SetParent(self.content);
  self.bbActive:SetPosition(248,61+a);
  self.bbActive:SetSize(50,20);
  self.bbActive:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  self.bbActive:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
  self.bbActive:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
  self.bbActive:SetForeColor(control2LightColor);
  self.bbActive:SetChecked(true);
  self.bbActive:SetText(L.BuffBars[3].." ");
  self.bbActive:SetVisible(false);
  TooltipManager.SetTooltip(self.bbActive,L.DebuffsActiveInBuffBarsTooltip,TooltipStyle.LOTRO,500);
  
  self.bbActive.CheckedChanged = function(sender,args)
    if (self.updatingChecked) then return end
    
    self.uncheckedBB = 0;
    for _,buff in ipairs(self.buffs) do
      if (buff[3] and not buff[1].buffInfo.removalOnly) then
        Traits.UpdateBB(buff[1].buffInfo, self.bbActive:IsChecked());
        buff[1].tick2:SetBackground(buff[1].buffInfo.bb and 0x410e3f4a or "CombatAnalysis/Resources/cross.tga");
        if (not self.bbActive:IsChecked()) then self.uncheckedBB = self.uncheckedBB + 1 end
      end
    end
  end
  
  self.caActive = Turbine.UI.Lotro.CheckBox();
  self.caActive:SetParent(self.content);
  self.caActive:SetPosition(314,61+a);
  self.caActive:SetSize(50,20);
  self.caActive:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  self.caActive:SetForeColor(control2LightColor);
  self.caActive:SetChecked(true);
  self.caActive:SetText(" "..L.CombatAnalysis[3]);
  self.caActive:SetEnabled(false);
  
  self.caActive.CheckedChanged = function(sender,args)
    if (self.updatingChecked) then return end
    
    self.uncheckedCA = 0;
    for _,buff in ipairs(self.buffs) do
      if (buff[3] and not buff[1].buffInfo.removalOnly) then
        Traits.UpdateCA(buff[1].buffInfo, self.caActive:IsChecked());
        buff[1].tick1:SetBackground(buff[1].buffInfo.ca and 0x410e3f4a or "CombatAnalysis/Resources/cross.tga");
        if (not self.caActive:IsChecked()) then self.uncheckedCA = self.uncheckedCA + 1 end
      end
    end
  end
  
  self.uncheckedBB = 0;
  self.uncheckedCA = 0;
  
  self.buffsPanel = Turbine.UI.Control();
  self.buffsPanel:SetParent(self.content);
  self.buffsPanel:SetPosition(0,85+a);
  self.buffsPanel:SetHeight(516);
  self.buffsPanel:SetBackColor(blueBorderColor);
  
  self.buffsPanelBackground = Turbine.UI.Control();
  self.buffsPanelBackground:SetParent(self.buffsPanel);
  self.buffsPanelBackground:SetPosition(0,1);
  self.buffsPanelBackground:SetHeight(514);
  self.buffsPanelBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.treePanel = CombatAnalysisTreePanel(0,true,2,3,2,3);
	self.treePanel:SetParent(self.buffsPanelBackground);
  self.treePanel:SetHeight(514);
  self.treePanel:SetMouseVisible(false);
  
	self.rootNode = self.treePanel.treeView:GetNodes();
  
  self.buffs = {}
end

function BuffsSubMenuPanel:Layout()
	local w,h = self:GetSize();
	self.content:SetSize(math.max(self.width,w),math.max(self.height,h));
  self.buffsPanel:SetWidth(math.max(self.width,w-20));
  self.buffsPanelBackground:SetWidth(math.max(self.width,w-20));
  self.treePanel:SetWidth(math.max(self.width,w-20)-2-10);
  self.treePanel:Layout();
end

function BuffsSubMenuPanel:SortList(skillOnly,ascending)
  if (skillOnly) then
    self.buffSortTriangle:SetBackground("CombatAnalysis/Resources/"..(ascending and "arrowup" or "dropdown_arrow_open")..".tga");
    self.classSortTriangle:SetBackground(nil);
    
    self.buffHeader.ascending = ascending;
    self.buffHeader.selected = true;
    self.classHeader.selected = false;
    
    table.sort(self.buffs,function(a,b)
      if (a[1] == self.dummyRow) then return true end
      if (b[1] == self.dummyRow) then return false end
      
      if (b[1].remover and not a[1].remover) then return true end
      if (a[1].remover and not b[1].remover) then return false end
      
      if (ascending) then
        return a[1].skillName < b[1].skillName;
      else
        return a[1].skillName > b[1].skillName;
      end
    end);
  else
    self.classSortTriangle:SetBackground("CombatAnalysis/Resources/"..(ascending and "arrowup" or "dropdown_arrow_open")..".tga");
    self.buffSortTriangle:SetBackground(nil);
    
    self.classHeader.ascending = ascending;
    self.classHeader.selected = true;
    self.buffHeader.selected = false;
    
    if (ascending) then
      table.sort(self.buffs,function(a,b)
        if (b[3] == false and a[3] ~= false) then return true end
        if (a[3] == false and b[3] ~= false) then return false end
        
        if (a[1] == self.dummyRow) then return true end
        if (b[1] == self.dummyRow) then return false end
        
        if (a[1].class ~= nil or b[1].class ~= nil) then
          if (b[1].class == nil and a[1].class ~= nil) then return false end
          if (a[1].class == nil and b[1].class ~= nil) then return true end
          
          if (b[1].class == "OtherClass" and a[1].class ~= "OtherClass") then return false end
          if (a[1].class == "OtherClass" and b[1].class ~= "OtherClass") then return true end
          
          if (b[1].class == "Item" and a[1].class ~= "Item") then return true end
          if (a[1].class == "Item" and b[1].class ~= "Item") then return false end
          
          if (b[1].class == "Racial" and a[1].class ~= "Racial") then return true end
          if (a[1].class == "Racial" and b[1].class ~= "Racial") then return false end
          
          if (a[1].class < b[1].class) then return true end
          if (a[1].class > b[1].class) then return false end
        end
        
        if (b[1].remover and not a[1].remover) then return true end
        if (a[1].remover and not b[1].remover) then return false end
        
        return a[1].skillName < b[1].skillName;
      end);
      
    else
      table.sort(self.buffs,function(a,b)
        if (b[3] == false and a[3] ~= false) then return true end
        if (a[3] == false and b[3] ~= false) then return false end
        
        if (a[1] == self.dummyRow) then return true end
        if (b[1] == self.dummyRow) then return false end
        
        if (a[1].class ~= nil or b[1].class ~= nil) then
          if (a[1].class == nil and b[1].class ~= nil) then return true end
          if (b[1].class == nil and a[1].class ~= nil) then return false end
          
          if (a[1].class == "OtherClass" and b[1].class ~= "OtherClass") then return true end
          if (b[1].class == "OtherClass" and a[1].class ~= "OtherClass") then return false end
          
          if (a[1].class == "Item" and b[1].class ~= "Item") then return true end
          if (b[1].class == "Item" and a[1].class ~= "Item") then return false end
          
          if (a[1].class == "Racial" and b[1].class ~= "Racial") then return true end
          if (b[1].class == "Racial" and a[1].class ~= "Racial") then return false end
          
          if (a[1].class > b[1].class) then return true end
          if (a[1].class < b[1].class) then return false end
        end
        
        if (b[1].remover and not a[1].remover) then return true end
        if (a[1].remover and not b[1].remover) then return false end
        
        return a[1].skillName > b[1].skillName;
      end);
    end
  end
  
  self:FilterList(self.filter.clear and "" or self.filter:GetText())
end

function BuffsSubMenuPanel:FilterList(text)
  text = text:lower();
  
  self.rootNode:Clear();
  for _,buff in ipairs(self.buffs) do
    if (buff[3]) then
      local buffInfo = buff[1].buffInfo;
      -- search buff name
      if (string.find(buffInfo.skillName:lower(),text)) then
        self.rootNode:Add(buff[1]);
      -- search class
      elseif (buffInfo.class ~= nil and L[buffInfo.class] ~= nil and #L[buffInfo.class] == 2 and (string.find(L[buffInfo.class][1]:lower(),text) == 1 or string.find(L[buffInfo.class][2]:lower(),text) == 1)) then
        self.rootNode:Add(buff[1]);
      -- search log name
      elseif (buffInfo.logName ~= nil and string.find(buffInfo.logName:lower(),text)) then
        self.rootNode:Add(buff[1]);
      -- search "remover"
      elseif (buffInfo.removalOnly and string.find(L.Remov,text) == 1) then
        self.rootNode:Add(buff[1]);
      -- search applied by names
      elseif (buffInfo.appliedBy ~= nil) then
        for _,appliedBy in ipairs(buffInfo.appliedBy) do
          if (string.find(appliedBy.skillName and appliedBy.skillName:lower() or appliedBy,text)) then
            self.rootNode:Add(buff[1]);
            break;
          end
        end
      end
    end
  end
end

function BuffsSubMenuPanel:SetBuffs(buffType,buffsList)
  self.buffType = buffType;
  self.toBuffBarsControl:SetVisible(self.buffType == "Debuff" or self.buffType == "CrowdControl");
  
  if (self.addTraitControl.ShowTooltip == nil) then
    TooltipManager.SetTooltip(self.addTraitControl,((self.buffType == "Debuff" or self.buffType == "CrowdControl") and L.AddNewDebuffTooltip or L.AddNewBuffTooltip),TooltipStyle.LOTRO,500);
  end
  
  self.bbActive:SetVisible(self.buffType == "Debuff");
  self.caActive:SetEnabled(self.buffType == "Debuff");
  self.caActive:SetText(" " .. (self.buffType == "CrowdControl" and L.BuffBars[3] or L.CombatAnalysis[3]));
  
  if (self.caActive.ShowTooltip == nil) then
    TooltipManager.SetTooltip(self.caActive,(self.buffType == "CrowdControl" and L.DebuffsActiveInBuffBarsTooltip or (self.buffType == "Debuff" and L.DebuffsActiveInCombatAnalysisTooltip or L.BuffsActiveInCombatAnalysisTooltip)),TooltipStyle.LOTRO,500);
  end
  
  self.buffHeader:SetText((buffType == "Buff" or buffType == "TempMorale") and L.BuffName or L.DebuffName);
  self.addTraitConfigurationLabel:SetText((buffType == "Buff" or buffType == "TempMorale") and L.AddBuff or L.AddDebuff);
  
  self.uncheckedBB = 0;
  self.uncheckedCA = 0;
  
  for i,buff in ipairs(buffsList) do
    local title;
    local panel;
    if (#self.buffs >= i) then
      title = self.buffs[i][1];
      panel = self.buffs[i][2];
      self.buffs[i][3] = true;
    else
      title = BuffPanelTitleNode(self,3,buffType);
      self.rootNode:Add(title);
      panel = BuffPanelNode(2,buffType,title,self);
      title:GetChildNodes():Add(panel);
      
      table.insert(self.buffs,{title,panel,true});
    end
    title:SetBuff(buff);
    panel:SetBuff(buff);
    
    if (buff.skillName == "") then
      self.dummyRow = title;
    end
    
    if (not buff.bb) then self.uncheckedBB = self.uncheckedBB + 1 end
    if (not buff.ca) then self.uncheckedCA = self.uncheckedCA + 1 end
  end
  
  for i=#buffsList+1,#self.buffs do
    self.buffs[i][3] = false;
  end
  
  self.updatingChecked = true;
  self.bbActive:SetChecked(self.buffType ~= "Debuff" or self.uncheckedBB == 0);
  self.caActive:SetChecked(self.buffType ~= "Debuff" or self.uncheckedCA == 0);
  self.updatingChecked = false;
  
  self:SortList(false,true);
end

function BuffsSubMenuPanel:RemoveBuff(title)
  for i,buff in ipairs(self.buffs) do
    if (title == buff[1]) then
      self.rootNode:Remove(buff[1]);
      buff[3] = false;
      
      if (self.buffType == "Debuff") then
        if (not buff[1].buffInfo.bb) then self:UpdateChecked(false,true) end
        if (not buff[1].buffInfo.ca) then self:UpdateChecked(true,true) end
      end
    end
  end
end

function BuffsSubMenuPanel:UpdateChecked(cc,checked)
  self.updatingChecked = true;
  
  if (cc) then
    self.uncheckedCA = self.uncheckedCA + (checked and -1 or 1);
    if (not checked) then               self.caActive:SetChecked(false)
    elseif (self.uncheckedCA == 0) then self.caActive:SetChecked(true) end
  else
    self.uncheckedBB = self.uncheckedBB + (checked and -1 or 1);
    if (not checked) then               self.bbActive:SetChecked(false)
    elseif (self.uncheckedBB == 0) then self.bbActive:SetChecked(true) end
  end
  
  self.updatingChecked = false;
end

function BuffsSubMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
  
  KeyManager.TakeFocus(self);
end
