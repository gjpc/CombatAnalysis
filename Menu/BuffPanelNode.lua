
_G.BuffPanelNode = class(Turbine.UI.TreeNode);

function BuffPanelNode:Constructor(nodePadding,buffType,title,panel)
  Turbine.UI.TreeNode.Constructor(self);
  
  self.buffType = buffType;
  
  self.title = title;
  self.parentPanel = panel;
  
  self.listeners = {}
  self.creationTime = Turbine.Engine.GetGameTime();
  
  self.nodePadding = nodePadding;
  self.panelPadding = 5;
  self.controlPadding = 4;
  
  local innerPadding = 7;
  local width = 367;
  local height = 256;
  
	self:SetHeight(height);
  self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
	self.panel = Turbine.UI.Control();
	self.panel:SetParent(self);
  self.panel:SetPosition(self.panelPadding,self.panelPadding-self.nodePadding);
  self.panel:SetSize(width-2*self.panelPadding,height-2*self.panelPadding+self.nodePadding);
  self.panel:SetBackColor(Turbine.UI.Color(0.3,0.3,0.42));
  self.panel:SetMouseVisible(false);
  
  self.panelBackground = Turbine.UI.Control();
  self.panelBackground:SetParent(self.panel);
  self.panelBackground:SetPosition(1,1);
  self.panelBackground:SetSize(width-2*self.panelPadding-2,height-2*self.panelPadding-2+self.nodePadding);
  self.panelBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self.panelBackground:SetMouseVisible(false);
  
  self.classNameLabel = MenuLabel(self.panelBackground,innerPadding,140,18,"13");
  self.classNameLabel:SetLeft(innerPadding);
  self.classNameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.classNameLabel:SetText(L.Class..":");  
  self.classNameLabel:SetMouseVisible(true);
  self.classNameLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.classNameLabel,L.ClassTooltip,TooltipStyle.LOTRO,500);
  
  self.classNameDropDown = LabelledComboBox(nil,nil,196,nil,nil,18,"13",1,blueBorderColor,Turbine.UI.ContentAlignment.MiddleLeft);
  self.classNameDropDown:SetParent(self.panelBackground);
  self.classNameDropDown:SetPosition(152,innerPadding);
  
  if (player.isCreep) then
    self.classNameDropDown:AddItem(L.BlackArrow[1],"BlackArrow");
    self.classNameDropDown:AddItem(L.Defiler[1],"Defiler");
    self.classNameDropDown:AddItem(L.Reaver[1],"Reaver");
    self.classNameDropDown:AddItem(L.Stalker[1],"Stalker");
    self.classNameDropDown:AddItem(L.WarLeader[1],"WarLeader");
    self.classNameDropDown:AddItem(L.Weaver[1],"Weaver");
  else
    self.classNameDropDown:AddItem(L.Burglar[1],"Burglar");
    self.classNameDropDown:AddItem(L.Captain[1],"Captain");
    self.classNameDropDown:AddItem(L.Champion[1],"Champion");
    self.classNameDropDown:AddItem(L.Guardian[1],"Guardian");
    self.classNameDropDown:AddItem(L.Hunter[1],"Hunter");
    self.classNameDropDown:AddItem(L.LoreMaster[1],"LoreMaster");
    self.classNameDropDown:AddItem(L.Minstrel[1],"Minstrel");
    self.classNameDropDown:AddItem(L.RuneKeeper[1],"RuneKeeper");
    self.classNameDropDown:AddItem(L.Warden[1],"Warden");
  end
  
  self.classNameDropDown:AddItem(L.Racial[1],"Racial");
  self.classNameDropDown:AddItem(L.Item[1],"Item");
  self.classNameDropDown:AddItem(L.OtherClass[1],"OtherClass");
  
  self.classNameDropDown.SelectionChanged = function(sender,args)
		if (self.buffInfo.class ~= self.classNameDropDown:GetSelection()) then
			Traits.UpdateClass(self.buffType,self.buffInfo,self.classNameDropDown:GetSelection());
		end
	end
  
  local prevControl = self.classNameLabel;
  
  self.buffNameLabel = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding,140,18,"13");
  self.buffNameLabel.prevControl = prevControl;
  self.buffNameLabel:SetLeft(innerPadding);
  self.buffNameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.buffNameLabel:SetText((self.buffType == "TempMorale" and L.EffectName or (self.buffType == "Buff" and L.BuffName or L.DebuffName))..":");
  self.buffNameLabel:SetMouseVisible(true);
  self.buffNameLabel.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  TooltipManager.SetTooltip(self.buffNameLabel,(self.buffType == "TempMorale" and L.TempMoraleEffectNameTooltip or L.SkillNameTooltip),TooltipStyle.LOTRO,500);
  
  self.buffNameTextBox = Turbine.UI.Lotro.TextBox();
  self.buffNameTextBox:SetParent(self.panelBackground);
  self.buffNameTextBox:SetPosition(152,self.classNameDropDown:GetTop()+self.classNameDropDown:GetHeight()+self.controlPadding);
  self.buffNameTextBox:SetSize(196,18);
  self.buffNameTextBox:SetBackColor(blueBorderColor);
  self.buffNameTextBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  self.buffNameTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.buffNameTextBox:SetMultiline(false);
  
  self.buffNameTextBox.KeyDown = function(sender,args)
    if (self.buffNameTextBox:HasFocus() and args.Action == 162) then
      KeyManager.TakeFocus();
    end
  end
  
  self.buffNameTextBox.FocusGained = function(sender,args)
    self.buffNameTextBox.startText = self.buffNameTextBox:GetText();
    
    self.buffNameTextBox:SetWantsKeyEvents(true);
    if (self.buffNameTextBox.error ~= nil) then self.buffNameTextBox.error:SetVisible(true) end
  end
  
  self.buffNameTextBox.FocusLost = function(sender,args)
    self.buffNameTextBox:SetWantsKeyEvents(false);
    
    local oldBuffName = self.buffInfo.skillName;
    
    -- update buff name
		if (self.buffNameTextBox.startText ~= self.buffNameTextBox:GetText()) then
      -- name restored to existing value
      if (oldBuffName == self.buffNameTextBox:GetText()) then
        if (self.buffNameTextBox.error ~= nil) then self.buffNameTextBox.error:Close() end
        self.buffNameTextBox.error = nil;
        self.buffNameTextBox:SetBackColor(blueBorderColor);
        
      -- new name
      else
        local success, errorMsg = Traits.UpdateSkillName(self.buffType,self.buffInfo,self.buffNameTextBox:GetText());
        if (success) then
          if (self.buffNameTextBox.error ~= nil) then self.buffNameTextBox.error:Close() end
          self.buffNameTextBox.error = nil;
          self.buffNameTextBox:SetBackColor(blueBorderColor);
          
          if (self.dummyRow) then
            self.dummyRow = nil;
            self.title:RemoveError();
            self.parentPanel.dummyRow = nil;
          end
          
          -- if there is an applied by value that has the same name as the skill, update it
          if (self.buffInfo.appliedBy ~= nil) then
            if (#self.buffInfo.appliedBy == 0) then
              self.appliedByPanel.ownItems[1].skillTextBox:SetText(self.buffInfo.skillName);
              self.appliedByPanel:SkillAdded(self.buffInfo,self.buffInfo.skillName,false,0,0,self.appliedByPanel.ownItems[1]);
            else
              local itemToUpdate;
              for _,item in pairs(self.appliedByPanel.ownItems) do
                if (item.skillTextBox.lastValidValue == self.buffInfo.skillName) then
                  itemToUpdate = nil;
                  break;
                end
                if (item.skillTextBox.lastValidValue == oldBuffName) then
                  itemToUpdate = item;
                end
              end
              if (itemToUpdate ~= nil) then
                itemToUpdate.skillTextBox:SetText(self.buffInfo.skillName);
                self.appliedByPanel:SkillUpdated(self.buffInfo,self.buffInfo.skillName,oldBuffName,itemToUpdate);
              end
            end
          end
        
        else
          if (self.buffNameTextBox.error ~= nil) then self.buffNameTextBox.error:Close() end
          self.buffNameTextBox.error = Tooltip(errorMsg,TooltipStyle.Menu,204,self.buffNameTextBox,nil,nil,0,2,oldBuffName);
          self.buffNameTextBox:SetBackColor(Menu.errorColor);
          
        end
      end
      
    -- hide error
    elseif (self.buffNameTextBox.error ~= nil) then
      self.buffNameTextBox.error:SetVisible(false);
		end
	end
  
  prevControl = self.buffNameLabel;
  
  if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
    self.iconLabel = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding,140,18,"13");
    self.iconLabel.prevControl = prevControl;
    self.iconLabel:SetLeft(innerPadding);
    self.iconLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.iconLabel:SetText(L.IconFileName..":");
    self.iconLabel.startVisible = 0;
    self.iconLabel.targetVisible = 0;
    self.iconLabel:SetMouseVisible(true);
    self.iconLabel.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.iconLabel,L.IconFileNameTooltip,TooltipStyle.LOTRO,500);
    
    self.iconLabelOverlay = Turbine.UI.Control();
    self.iconLabelOverlay:SetParent(self.iconLabel);
    self.iconLabelOverlay:SetSize(self.iconLabel:GetWidth(),self.iconLabel:GetHeight());
    self.iconLabelOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.iconLabelOverlay:SetMouseVisible(false);
    self.iconLabelOverlay:SetVisible(false);
    
    self.iconTextBox = Turbine.UI.Lotro.TextBox();
    self.iconTextBox:SetParent(self.panelBackground);
    self.iconTextBox:SetPosition(152,self.buffNameTextBox:GetTop()+self.buffNameTextBox:GetHeight()+self.controlPadding);
    self.iconTextBox:SetSize(196,18);
    self.iconTextBox:SetBackColor(blueBorderColor);
    self.iconTextBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    self.iconTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.iconTextBox:SetMultiline(false);
    self.iconTextBox.startVisible = 0;
    self.iconTextBox.targetVisible = 0;
    
    self.iconTextBoxOverlay = Turbine.UI.Control();
    self.iconTextBoxOverlay:SetParent(self.panelBackground);
    self.iconTextBoxOverlay:SetPosition(152,self.buffNameTextBox:GetTop()+self.buffNameTextBox:GetHeight()+self.controlPadding);
    self.iconTextBoxOverlay:SetSize(self.iconTextBox:GetWidth(),self.iconTextBox:GetHeight());
    self.iconTextBoxOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.iconTextBoxOverlay:SetMouseVisible(false);
    self.iconTextBoxOverlay:SetVisible(false);
    
    self.iconTextBox.KeyDown = function(sender,args)
      if (self.iconTextBox:HasFocus() and args.Action == 162) then
        KeyManager.TakeFocus();
      end
    end
    
    self.iconTextBox.FocusGained = function(sender,args)
      self.iconTextBox.startText = self.iconTextBox:GetText();
      
      self.iconTextBox:SetWantsKeyEvents(true);
      if (self.iconTextBox.error ~= nil) then self.iconTextBox.error:SetVisible(true) end
    end
    
    self.iconTextBox.FocusLost = function(sender,args)
      self.iconTextBox:SetWantsKeyEvents(false);
      
      local oldIconName = self.buffInfo.iconName;
      
      -- update icon name
      if (self.iconTextBox.startText ~= self.iconTextBox:GetText()) then
        -- name restored to existing value
        if (oldIconName == self.iconTextBox:GetText()) then
          if (self.iconTextBox.error ~= nil) then self.iconTextBox.error:Close() end
          self.iconTextBox.error = nil;
          self.iconTextBox:SetBackColor(blueBorderColor);
          
        -- new name
        else
          local success, errorMsg = Traits.UpdateIcon(self.buffInfo,self.iconTextBox:GetText());
          if (success) then
            if (self.iconTextBox.error ~= nil) then self.iconTextBox.error:Close() end
            self.iconTextBox.error = nil;
            self.iconTextBox:SetBackColor(blueBorderColor);
          
          else
            if (self.iconTextBox.error ~= nil) then self.iconTextBox.error:Close() end
            self.iconTextBox.error = Tooltip(errorMsg,TooltipStyle.Menu,204,self.iconTextBox,nil,nil,0,2,oldIconName);
            self.iconTextBox:SetBackColor(Menu.errorColor);
          
          end
        end
        
      -- hide error
      elseif (self.iconTextBox.error ~= nil) then
        self.iconTextBox.error:SetVisible(false);
      end
    end
    
    prevControl = self.iconLabel;
    
    self.removalOnly = Turbine.UI.Lotro.CheckBox();
    self.removalOnly.prevControl = prevControl;
    self.removalOnly:SetParent(self.panelBackground);
    self.removalOnly:SetPosition(innerPadding,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding+2);
    self.removalOnly:SetSize(162,18);
    self.removalOnly:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    self.removalOnly:SetForeColor(control2LightColor);
    self.removalOnly:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    self.removalOnly:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.removalOnly:SetText(L.RemovalOnly..":");
    TooltipManager.SetTooltip(self.removalOnly,L.RemovalOnlyTooltip,TooltipStyle.LOTRO,500);
    
    self.removalOnly.MouseDoubleClick = function(sender,args)
      if (self.removalOnly:IsEnabled()) then self.removalOnly:SetChecked(not self.removalOnly:IsChecked()) end
    end
    
    self.removalOnly.CheckedChanged = function(sender,args)
      local removalOnly = (self.buffInfo.removalOnly or (self.buffType == "CrowdControl" and self.buffInfo.skillName ~= L.Daze and self.buffInfo.skillName ~= L.Root and self.buffInfo.skillName ~= L.Fear and self.buffInfo.skillName ~= L.Stun and self.buffInfo.skillName ~= L.Knockdown and self.buffInfo.skillName ~= L.StunImmunity));
      
      if (removalOnly ~= self.removalOnly:IsChecked()) then
        Traits.UpdateRemoval(self.buffInfo,self.removalOnly:IsChecked());
        removalOnly = not removalOnly;
      end
      
      self.iconLabel.startVisible = (self:GetWantsUpdates() and self.iconLabelOverlay:GetBackColor().A or (self.iconLabel:IsVisible() and 0 or 0.925));
      self.iconLabel.targetVisible = (not removalOnly and self.buffInfo.bb and 0 or 0.925);
      
      self.iconTextBox.startVisible = (self:GetWantsUpdates() and self.iconTextBoxOverlay:GetBackColor().A or (self.iconTextBox:IsVisible() and 0 or 0.925));
      self.iconTextBox.targetVisible = (not removalOnly and self.buffInfo.bb and 0 or 0.925);
      
      self.removalOnly.prevControl = (self.iconLabel.targetVisible == 0 and self.iconLabel or self.buffNameLabel);
      
      self.toggleSkill.startVisible = (self:GetWantsUpdates() and self.toggleSkillOverlay:GetBackColor().A or (self.toggleSkill:IsVisible() and 0 or 0.925));
      self.toggleSkill.targetVisible = (not removalOnly and 0 or 0.925);
      
      self.toggleSkill.prevControl = (self.iconLabel.targetVisible == 0 and self.iconLabel or self.buffNameLabel);
      
      self.conflicts.startVisible = (self:GetWantsUpdates() and self.conflictsOverlay:GetBackColor().A or (self.conflicts:IsVisible() and 0 or 0.925));
      self.conflicts.targetVisible = (not removalOnly and 0 or 0.925);
      
      self.conflictsPanel.startVisible = (self:GetWantsUpdates() and self.conflictsPanelOverlay:GetBackColor().A or (self.conflictsPanel:IsVisible() and 0 or 0.925));
      self.conflictsPanel.targetVisible = (not removalOnly and 0 or 0.925);
      
      self.effectModifiers.prevControl = (self.conflictsPanel.targetVisible == 0 and self.conflictsPanel or self.overwritesPanel);
      
      self.effectModifiers.startVisible = (self:GetWantsUpdates() and self.effectModifiersOverlay:GetBackColor().A or (self.effectModifiers:IsVisible() and 0 or 0.925));
      self.effectModifiers.targetVisible = (self.buffType ~= "CrowdControl" and not self.buffInfo.toggleSkill and not removalOnly and 0 or 0.925);
      
      self.effectModifiersPanel.startVisible = (self:GetWantsUpdates() and self.effectModifiersPanelOverlay:GetBackColor().A or (self.effectModifiersPanel:IsVisible() and 0 or 0.925));
      self.effectModifiersPanel.targetVisible = (self.buffType ~= "CrowdControl" and not self.buffInfo.toggleSkill and not removalOnly and 0 or 0.925);
      
      self.appliedByPanel.prevControl = (self.effectModifiersPanel.targetVisible == 0 and self.effectModifiersPanel or (self.conflictsPanel.targetVisible == 0 and self.conflictsPanel or self.overwritesPanel));
      
      self.iconLabelOverlay:SetVisible(true);
      self.iconLabel:SetVisible(true);
      self.iconTextBoxOverlay:SetVisible(true);
      self.iconTextBox:SetVisible(true);
      self.toggleSkillOverlay:SetVisible(true);
      self.toggleSkill:SetVisible(true);
      self.conflictsOverlay:SetVisible(true);
      self.conflicts:SetVisible(true);
      self.conflictsPanelOverlay:SetVisible(true);
      self.conflictsPanel:SetVisible(true);
      self.effectModifiersOverlay:SetVisible(true);
      self.effectModifiers:SetVisible(true);
      self.effectModifiersPanelOverlay:SetVisible(true);
      self.effectModifiersPanel:SetVisible(true);
      
      self.appliedByPanel:UpdateItems(removalOnly or not self.buffInfo.toggleSkill,not removalOnly and not self.buffInfo.toggleSkill,not removalOnly and not self.buffInfo.toggleSkill);
      
      self:UpdateControlHeight();
    end
    
    self.toggleSkill = Turbine.UI.Lotro.CheckBox();
    self.toggleSkill.prevControl = prevControl;
    self.toggleSkill:SetParent(self.panelBackground);
    self.toggleSkill:SetPosition(188,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding+2);
    self.toggleSkill:SetSize(152,18);
    self.toggleSkill:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    self.toggleSkill:SetForeColor(control2LightColor);
    self.toggleSkill:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    self.toggleSkill:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.toggleSkill:SetText(L.ToggleSkill..":");
    self.toggleSkill.startVisible = 0;
    self.toggleSkill.targetVisible = 0;
    TooltipManager.SetTooltip(self.toggleSkill,L.ToggleSkillTooltip,TooltipStyle.LOTRO,500);
    
    self.toggleSkill.MouseDoubleClick = function(sender,args)
      if (self.toggleSkill:IsEnabled()) then self.toggleSkill:SetChecked(not self.toggleSkill:IsChecked()) end
    end
    
    self.toggleSkillOverlay = Turbine.UI.Control();
    self.toggleSkillOverlay:SetParent(self.toggleSkill);
    self.toggleSkillOverlay:SetSize(self.toggleSkill:GetWidth(),self.toggleSkill:GetHeight());
    self.toggleSkillOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.toggleSkillOverlay:SetMouseVisible(false);
    self.toggleSkillOverlay:SetVisible(false);
    
    self.toggleSkill.CheckedChanged = function(sender,args)
      if ((self.buffInfo.toggleSkill and self.toggleSkill:IsChecked()) or (not self.buffInfo.toggleSkill and not self.toggleSkill:IsChecked())) then return end
      
      local success, errorMsg = Traits.UpdateToggle(self.buffType,self.buffInfo,self.toggleSkill:IsChecked());
      if (not success) then
        Tooltip(errorMsg,TooltipStyle.Menu,204,self.toggleSkill,nil,nil,0,2,nil,true);
        self.toggleSkill:SetChecked(not self.toggleSkill:IsChecked());
        return;
      end
      
      self.iconLabel.startVisible = (self:GetWantsUpdates() and self.iconLabelOverlay:GetBackColor().A or (self.iconLabel:IsVisible() and 0 or 0.925));
      self.iconTextBox.startVisible = (self:GetWantsUpdates() and self.iconTextBoxOverlay:GetBackColor().A or (self.iconTextBox:IsVisible() and 0 or 0.925));
      self.toggleSkill.startVisible = (self:GetWantsUpdates() and self.toggleSkillOverlay:GetBackColor().A or (self.toggleSkill:IsVisible() and 0 or 0.925));
      self.conflicts.startVisible = (self:GetWantsUpdates() and self.conflictsOverlay:GetBackColor().A or (self.conflicts:IsVisible() and 0 or 0.925));
      self.conflictsPanel.startVisible = (self:GetWantsUpdates() and self.conflictsPanelOverlay:GetBackColor().A or (self.conflictsPanel:IsVisible() and 0 or 0.925));
      
      self.effectModifiers.startVisible = (self:GetWantsUpdates() and self.effectModifiersOverlay:GetBackColor().A or (self.effectModifiers:IsVisible() and 0 or 0.925));
      self.effectModifiers.targetVisible = (self.buffType ~= "CrowdControl" and not self.buffInfo.toggleSkill and not self.buffInfo.removalOnly and 0 or 0.925);
      
      self.effectModifiersPanel.startVisible = (self:GetWantsUpdates() and self.effectModifiersPanelOverlay:GetBackColor().A or (self.effectModifiersPanel:IsVisible() and 0 or 0.925));
      self.effectModifiersPanel.targetVisible = (self.buffType ~= "CrowdControl" and not self.buffInfo.toggleSkill and not self.buffInfo.removalOnly and 0 or 0.925);
      
      self.appliedByPanel.prevControl = (self.effectModifiersPanel.targetVisible == 0 and self.effectModifiersPanel or (self.conflictsPanel.targetVisible == 0 and self.conflictsPanel or self.overwritesPanel));
      
      self.effectModifiersOverlay:SetVisible(true);
      self.effectModifiers:SetVisible(true);
      self.effectModifiersPanelOverlay:SetVisible(true);
      self.effectModifiersPanel:SetVisible(true);
      
      self.appliedByPanel:UpdateItems(self.buffInfo.removalOnly or not self.buffInfo.toggleSkill,not self.buffInfo.removalOnly and not self.buffInfo.toggleSkill,not self.buffInfo.removalOnly and not self.buffInfo.toggleSkill);
      
      self:UpdateControlHeight();
    end
    
    prevControl = self.removalOnly;
    
    local sharedBuffs = {}
    local sharedItems = {}
    
    self.overwrites = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding,140,22,"13");
    self.overwrites.prevControl = prevControl;
    self.overwrites:SetLeft(innerPadding);
    self.overwrites:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.overwrites:SetText(L.Removes..":");
    self.overwrites:SetMouseVisible(true);
    self.overwrites.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.overwrites,L.RemovesTooltip,TooltipStyle.LOTRO,500);
    
    self.overwritesPanel = BuffInfoPanel(self,width,self.controlPadding,self.panelPadding,innerPadding,"SelectOnly",sharedBuffs,sharedItems);
    self.overwritesPanel:SetParent(self.panelBackground);
    self.overwritesPanel:SetPosition(0,self.overwrites:GetTop()+2);
    TooltipManager.SetTooltip(self.overwritesPanel.addRemove.addControl,L.AddRemoveTooltip,TooltipStyle.LOTRO,500);
    TooltipManager.SetTooltip(self.overwritesPanel.addRemove.removeControl,L.RemoveRemoveTooltip,TooltipStyle.LOTRO,500);
    
    self.overwritesPanel.SkillSelected = function(sender,buff,newValue,oldValue,position)
      if (oldValue ~= nil) then Traits.RemoveOverwrite(self.buffType,buff,oldValue) end
      Traits.AddOverwrite(self.buffType,buff,newValue,position);
    end
    
    self.overwritesPanel.ItemRemoved = function(sender,buff,oldValue,item)
      if (debuffs[buff.skillName] == nil) then return end
      
      Traits.RemoveOverwrite(self.buffType,buff,oldValue.skillName);
      
      self.overwritesPanel.selectedBuffs[oldValue] = nil;
      
      for _,otherItem in ipairs(self.overwritesPanel.items) do
        if (otherItem ~= item) then
          local added = false;
          for i=1,otherItem.skillDropDown.listBox:GetItemCount() do
            if (otherItem.skillDropDown.listBox:GetItem(i).label:GetText() > oldValue.skillName) then
              added = true;
              otherItem.skillDropDown:AddItem(oldValue.skillName,oldValue,i);
              break;
            end
          end
          if (not added) then otherItem.skillDropDown:AddItem(oldValue.skillName,oldValue) end
        end
      end
      
      -- the buff must always be either an overwrite or a conflict (unless it is a remover)
      if (buff.skillName == oldValue.skillName) then
        if (self.overwritesPanel.selected) then self.overwritesPanel.selected:SetSelected(false) end
        self.overwritesPanel.addRemove.removeControl:SetEnabled(false);
        self.overwritesPanel.selected = nil;
        
        Traits.AddConflict(buff,buff.skillName,1);
        local newItem = self.conflictsPanel:InsertItem(1,nil,buff.skillName);
        
        if (self.conflictsPanel.selected) then self.conflictsPanel.selected:SetSelected(false) end
        self.conflictsPanel.addRemove.removeControl:SetEnabled(true);
        self.conflictsPanel.selected = newItem;
        newItem:SetSelected(true);
      end
    end
    
    prevControl = self.overwritesPanel;
    
    self.conflicts = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+(prevControl:GetHeight() == 0 and 0 or self.controlPadding),140,22,"13");
    self.conflicts.prevControl = prevControl;
    self.conflicts:SetLeft(innerPadding);
    self.conflicts:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.conflicts:SetText(L.ConflictsWith..":");
    self.conflicts.startVisible = 0;
    self.conflicts.targetVisible = 0;
    self.conflicts:SetMouseVisible(true);
    self.conflicts.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.conflicts,L.ConflictsWithTooltip,TooltipStyle.LOTRO,500);
    
    self.conflictsOverlay = Turbine.UI.Control();
    self.conflictsOverlay:SetParent(self.conflicts);
    self.conflictsOverlay:SetSize(self.conflicts:GetWidth(),self.conflicts:GetHeight());
    self.conflictsOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.conflictsOverlay:SetMouseVisible(false);
    self.conflictsOverlay:SetVisible(false);
    
    self.conflictsPanel = BuffInfoPanel(self,width,self.controlPadding,self.panelPadding,innerPadding,"SelectOnly",sharedBuffs,sharedItems);
    self.conflictsPanel:SetParent(self.panelBackground);
    self.conflictsPanel:SetPosition(0,self.conflicts:GetTop()+2);
    self.conflictsPanel.startVisible = 0;
    self.conflictsPanel.targetVisible = 0;
    TooltipManager.SetTooltip(self.conflictsPanel.addRemove.addControl,L.AddConflictTooltip,TooltipStyle.LOTRO,500);
    TooltipManager.SetTooltip(self.conflictsPanel.addRemove.removeControl,L.RemoveConflictTooltip,TooltipStyle.LOTRO,500);
    
    self.conflictsPanelOverlay = Turbine.UI.Control();
    self.conflictsPanelOverlay:SetParent(self.conflictsPanel);
    self.conflictsPanelOverlay:SetSize(self.conflictsPanel:GetWidth(),self.conflictsPanel:GetHeight());
    self.conflictsPanelOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.conflictsPanelOverlay:SetMouseVisible(false);
    self.conflictsPanelOverlay:SetVisible(false);
    
    self.conflictsPanel.SkillSelected = function(sender,buff,newValue,oldValue,position)
      if (oldValue ~= nil) then Traits.RemoveConflict(buff,oldValue) end
      Traits.AddConflict(buff,newValue,position);
    end
    
    self.conflictsPanel.ItemRemoved = function(sender,buff,oldValue,item)
      Traits.RemoveConflict(buff,oldValue.skillName);
      
      self.conflictsPanel.selectedBuffs[oldValue] = nil;
      
      for _,otherItem in ipairs(self.conflictsPanel.items) do
        if (otherItem ~= item) then
          local added = false;
          for i=1,otherItem.skillDropDown.listBox:GetItemCount() do
            if (otherItem.skillDropDown.listBox:GetItem(i).label:GetText() > oldValue.skillName) then
              added = true;
              otherItem.skillDropDown:AddItem(oldValue.skillName,oldValue,i);
              break;
            end
          end
          if (not added) then otherItem.skillDropDown:AddItem(oldValue.skillName,oldValue) end
        end
      end
      
      -- the buff must always be either an overwrite or a conflict (unless it is a remover)
      if (buff.skillName == oldValue.skillName) then
        if (self.conflictsPanel.selected) then self.conflictsPanel.selected:SetSelected(false) end
        self.conflictsPanel.addRemove.removeControl:SetEnabled(false);
        self.conflictsPanel.selected = nil;
        
        Traits.AddOverwrite(self.buffType,buff,buff.skillName,1);
        local newItem = self.overwritesPanel:InsertItem(1,nil,buff.skillName);
        
        if (self.overwritesPanel.selected) then self.overwritesPanel.selected:SetSelected(false) end
        self.overwritesPanel.addRemove.removeControl:SetEnabled(true);
        self.overwritesPanel.selected = newItem;
        newItem:SetSelected(true);
      end
    end
    
    prevControl = self.conflictsPanel;
    
    self.effectModifiers = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+(prevControl:GetHeight() == 0 and 0 or self.controlPadding),140,22,"13");
    self.effectModifiers.prevControl = prevControl;
    self.effectModifiers:SetLeft(innerPadding);
    self.effectModifiers:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.effectModifiers:SetText(L.EffectModifiers..":");
    self.effectModifiers.startVisible = 0;
    self.effectModifiers.targetVisible = 0;
    self.effectModifiers:SetMouseVisible(true);
    self.effectModifiers.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.effectModifiers,L.EffectModifiersTooltip,TooltipStyle.LOTRO,500);
    
    self.effectModifiersOverlay = Turbine.UI.Control();
    self.effectModifiersOverlay:SetParent(self.effectModifiers);
    self.effectModifiersOverlay:SetSize(self.effectModifiers:GetWidth(),self.effectModifiers:GetHeight());
    self.effectModifiersOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.effectModifiersOverlay:SetMouseVisible(false);
    self.effectModifiersOverlay:SetVisible(false);
    
    self.effectModifiersPanel = BuffInfoPanel(self,width,self.controlPadding,self.panelPadding,innerPadding,"SelectAndDuration");
    self.effectModifiersPanel:SetParent(self.panelBackground);
    self.effectModifiersPanel:SetPosition(0,self.effectModifiers:GetTop()+2);
    self.effectModifiersPanel.startVisible = 0;
    self.effectModifiersPanel.targetVisible = 0;
    TooltipManager.SetTooltip(self.effectModifiersPanel.addRemove.addControl,L.AddEffectModifierTooltip,TooltipStyle.LOTRO,500);
    TooltipManager.SetTooltip(self.effectModifiersPanel.addRemove.removeControl,L.RemoveEffectModifierTooltip,TooltipStyle.LOTRO,500);
    
    self.effectModifiersPanel.SkillSelected = function(sender,buff,newValue,oldValue,position,duration,item)
      if (oldValue ~= nil) then Traits.RemoveEffectModifier(buff,oldValue) end
      
      local success, errorMsg = Traits.AddEffectModifier(buff,newValue,position,duration);
      
      if (errorMsg == nil) then
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = nil;
        item.duration:SetBackColor(self.effectModifiersPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        item.duration.lastValidValue = duration;
      else
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.duration,nil,nil,0,2,item.duration.lastValidValue);
        item.duration:SetBackColor(Menu.errorColor);
      end
    end
    
    self.effectModifiersPanel.ItemRemoved = function(sender,buff,oldValue)
      Traits.RemoveEffectModifier(buff,oldValue.skillName);
      
      self.effectModifiersPanel.selectedBuffs[oldValue] = nil;
      
      for _,otherItem in ipairs(self.effectModifiersPanel.items) do
        if (otherItem ~= item) then
          local added = false;
          for i=1,otherItem.skillDropDown.listBox:GetItemCount() do
            if (otherItem.skillDropDown.listBox:GetItem(i).label:GetText() > oldValue.skillName) then
              added = true;
              otherItem.skillDropDown:AddItem(oldValue.skillName,oldValue,i);
              break;
            end
          end
          if (not added) then otherItem.skillDropDown:AddItem(oldValue.skillName,oldValue) end
        end
      end
    end
    
    self.effectModifiersPanel.DurationUpdated = function(sender,buff,effect,duration,item)
      local success, errorMsg = Traits.UpdateEffectModifier(buff,effect,duration);
      
      if (success) then
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = nil;
        item.duration:SetBackColor(self.effectModifiersPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        item.duration.lastValidValue = duration;
      else
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.duration,nil,nil,0,2,item.duration.lastValidValue);
        item.duration:SetBackColor(Menu.errorColor);
      end
    end
    
    self.effectModifiersPanelOverlay = Turbine.UI.Control();
    self.effectModifiersPanelOverlay:SetParent(self.effectModifiersPanel);
    self.effectModifiersPanelOverlay:SetSize(self.effectModifiersPanel:GetWidth(),self.effectModifiersPanel:GetHeight());
    self.effectModifiersPanelOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.effectModifiersPanelOverlay:SetMouseVisible(false);
    self.effectModifiersPanelOverlay:SetVisible(false);
    
    if (self.buffType == "CrowdControl") then
      self.effectModifiers:SetVisible(false);
      self.effectModifiers.startVisible = 0.925;
      self.effectModifiers.targetVisible = 0.925;
      self.effectModifiersPanel:SetVisible(false);
      self.effectModifiersPanel.startVisible = 0.925;
      self.effectModifiersPanel.targetVisible = 0.925;
    end
    
    prevControl = self.effectModifiersPanel;
    
  elseif (self.buffType == "Buff") then
    
    self.isStance = Turbine.UI.Lotro.CheckBox();
    self.isStance.prevControl = prevControl;
    self.isStance:SetParent(self.panelBackground);
    self.isStance:SetPosition(innerPadding,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding+2);
    self.isStance:SetSize(162,18);
    self.isStance:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    self.isStance:SetForeColor(control2LightColor);
    self.isStance:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    self.isStance:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.isStance:SetText(L.IsStance..":");
    TooltipManager.SetTooltip(self.isStance,L.IsStanceTooltip,TooltipStyle.LOTRO,500);
    
    self.isStance.MouseDoubleClick = function(sender,args)
      if (self.isStance:IsEnabled()) then self.isStance:SetChecked(not self.isStance:IsChecked()) end
    end
    
    self.isStance.CheckedChanged = function(sender,args)
      if (self.buffInfo.isStance ~= self.isStance:IsChecked()) then
        Traits.UpdateStance(self.buffInfo,self.isStance:IsChecked());
      end
    end
    
    prevControl = self.isStance;
    
    self.stacking = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding,140,22,"13");
    self.stacking.prevControl = prevControl;
    self.stacking:SetLeft(innerPadding);
    self.stacking:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.stacking:SetText(L.StackingBuffs..":");
    self.stacking.startVisible = 0;
    self.stacking.targetVisible = 0;
    self.stacking:SetMouseVisible(true);
    self.stacking.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.stacking,L.StackingBuffsTooltip,TooltipStyle.LOTRO,500);
    
    self.stackingPanel = BuffInfoPanel(self,width,self.controlPadding,self.panelPadding,innerPadding,"OrderedApplications");
    self.stackingPanel:SetParent(self.panelBackground);
    self.stackingPanel:SetPosition(0,self.stacking:GetTop()+2);
    self.stackingPanel.startVisible = 0;
    self.stackingPanel.targetVisible = 0;
    TooltipManager.SetTooltip(self.stackingPanel.addRemove.addControl,L.AddStackingBuffTooltip,TooltipStyle.LOTRO,500);
    TooltipManager.SetTooltip(self.stackingPanel.addRemove.removeControl,L.RemoveStackingBuffTooltip,TooltipStyle.LOTRO,500);
    
    self.stackingPanel.SkillAdded = function(sender,buff,name,critsOnly,delay,duration,item)
      local success, errorMsg = Traits.AddStackingBuff(buff,name);
      if (success) then
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = nil;
        item.skillTextBox:SetBackColor(self.appliedByPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        self.stackingPanel.dummyAdded = false;
        item.skillTextBox.lastValidValue = name;
        
      else
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.skillTextBox,nil,nil,0,2,item.skillTextBox.lastValidValue);
        item.skillTextBox:SetBackColor(Menu.errorColor);
      end
    end
    
    self.stackingPanel.ItemRemoved = function(sender,buff,name)
      Traits.RemoveStackingBuff(buff,name);
    end
    
    self.stackingPanel.SkillUpdated = function(sender,buff,newValue,oldValue,item)
      local success, errorMsg = Traits.UpdateStackedBuffName(buff,newValue,oldValue);
      if (success) then
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = nil;
        item.skillTextBox:SetBackColor(self.appliedByPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        item.skillTextBox.lastValidValue = newValue;
        
      else
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.skillTextBox,nil,nil,0,2,item.skillTextBox.lastValidValue);
        item.skillTextBox:SetBackColor(Menu.errorColor);
      end
    end
    
    prevControl = self.stackingPanel;
    
  elseif (self.buffType == "TempMorale") then
    
    self.logNameLabel = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding,140,18,"13");
    self.logNameLabel.prevControl = prevControl;
    self.logNameLabel:SetLeft(innerPadding);
    self.logNameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.logNameLabel:SetText(L.LogName..":");
    self.logNameLabel:SetMouseVisible(true);
    self.logNameLabel.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.logNameLabel,L.LogNameTooltip,TooltipStyle.LOTRO,500);
    
    self.logNameTextBox = Turbine.UI.Lotro.TextBox();
    self.logNameTextBox:SetParent(self.panelBackground);
    self.logNameTextBox:SetPosition(152,prevControl:GetTop()+prevControl:GetHeight()+self.controlPadding);
    self.logNameTextBox:SetSize(196,18);
    self.logNameTextBox:SetBackColor(blueBorderColor);
    self.logNameTextBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    self.logNameTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.logNameTextBox:SetMultiline(false);
    
    self.logNameTextBox.KeyDown = function(sender,args)
      if (self.logNameTextBox:HasFocus() and args.Action == 162) then
        KeyManager.TakeFocus();
      end
    end
    
    self.logNameTextBox.FocusGained = function(sender,args)
      self.logNameTextBox:SetWantsKeyEvents(true);
    end
    
    self.logNameTextBox.FocusLost = function(sender,args)
      self.logNameTextBox:SetWantsKeyEvents(false);
      
      if (self.buffInfo.logName ~= self.logNameTextBox:GetText()) then
        Traits.UpdateLogName(self.buffInfo,self.logNameTextBox:GetText());
      end
    end
    
    prevControl = self.logNameLabel;
    
  end
  
  if (self.buffType ~= "TempMorale") then
    self.appliedByLabel = MenuLabel(self.panelBackground,prevControl:GetTop()+prevControl:GetHeight()+(prevControl:GetHeight() == 0 and 0 or self.controlPadding),140,22,"13");
    self.appliedByLabel.prevControl = prevControl;
    self.appliedByLabel:SetLeft(innerPadding);
    self.appliedByLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.appliedByLabel:SetText(L.AppliedBy..":");
    self.appliedByLabel:SetMouseVisible(true);
    self.appliedByLabel.MouseDown = function(sender,args)
      KeyManager.TakeFocus();
    end
    TooltipManager.SetTooltip(self.appliedByLabel,(self.buffType == "Buff" and L.BuffAppliedByTooltip or L.DebuffAppliedByTooltip),TooltipStyle.LOTRO,500);
    
    self.appliedByPanel = BuffInfoPanel(self,width,self.controlPadding,self.panelPadding,innerPadding,"AppliedBy",nil,nil,(self.buffType == "Debuff" or self.buffType == "CrowdControl"));
    self.appliedByPanel:SetParent(self.panelBackground);
    self.appliedByPanel:SetPosition(0,self.appliedByLabel:GetTop()+2);
    TooltipManager.SetTooltip(self.appliedByPanel.addRemove.addControl,L.AddAppliedByTooltip,TooltipStyle.LOTRO,500);
    TooltipManager.SetTooltip(self.appliedByPanel.addRemove.removeControl,L.RemoveAppliedByTooltip,TooltipStyle.LOTRO,500);
    
    self.appliedByPanel.SkillAdded = function(sender,buff,name,critsOnly,delay,duration,item)
      local newAppliedBy, delayErrorMsg, durationErrorMsg = Traits.AddAppliedBy(self.buffType,buff,name,critsOnly,delay,duration);
      
      if (newAppliedBy) then
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = nil;
        item.skillTextBox:SetBackColor(self.appliedByPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
      
        self.appliedByPanel.dummyAdded = false;
        item.appliedBy = (newAppliedBy ~= true and newAppliedBy or nil);
        item.skillTextBox.lastValidValue = name;
        
        if (delayErrorMsg ~= nil) then
          if (item.delay.error ~= nil) then item.delay.error:Close() end
          item.delay.error = Tooltip(delayErrorMsg,TooltipStyle.Menu,204,item.delay,nil,nil,0,2,item.delay.lastValidValue);
          item.delay:SetBackColor(Menu.errorColor);
        end
        
        if (durationErrorMsg ~= nil) then
          if (item.duration.error ~= nil) then item.duration.error:Close() end
          item.duration.error = Tooltip(durationErrorMsg,TooltipStyle.Menu,204,item.duration,nil,nil,0,2,item.duration.lastValidValue);
          item.duration:SetBackColor(Menu.errorColor);
        end
        
      else
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = Tooltip(delayErrorMsg,TooltipStyle.Menu,204,item.skillTextBox,nil,nil,0,2,item.skillTextBox.lastValidValue);
        item.skillTextBox:SetBackColor(Menu.errorColor);
      end
    end
    
    self.appliedByPanel.ItemRemoved = function(sender,buff,name)
      Traits.RemoveAppliedBy(self.buffType,buff,name);
    end
    
    self.appliedByPanel.SkillUpdated = function(sender,buff,newValue,oldValue,item)      
      local success, errorMsg = Traits.UpdateAppliedByName(self.buffType,buff,oldValue,newValue);
      if (success) then
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = nil;
        item.skillTextBox:SetBackColor(self.appliedByPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        item.skillTextBox.lastValidValue = newValue;
        
      else
        if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
        item.skillTextBox.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.skillTextBox,nil,nil,0,2,item.skillTextBox.lastValidValue);
        item.skillTextBox:SetBackColor(Menu.errorColor);
      end
    end
    
    self.appliedByPanel.CritsOnlyUpdated = function(sender,buff,skillName,critsOnly)
      Traits.UpdateAppliedByCritsOnly(self.buffType,buff,skillName,critsOnly);
    end
    
    self.appliedByPanel.DelayUpdated = function(sender,buff,skillName,delay,item)
      local success, errorMsg = Traits.UpdateAppliedByDelay(buff,skillName,delay);
      if (success) then
        if (item.delay.error ~= nil) then item.delay.error:Close() end
        item.delay.error = nil;
        item.delay:SetBackColor(self.appliedByPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        item.delay.lastValidValue = delay;
        
      else
        if (item.delay.error ~= nil) then item.delay.error:Close() end
        item.delay.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.delay,nil,nil,0,2,item.delay.lastValidValue);
        item.delay:SetBackColor(Menu.errorColor);
      end
    end
    
    self.appliedByPanel.DurationUpdated = function(sender,buff,skillName,duration,item)
      local success, errorMsg = Traits.UpdateAppliedByDuration(self.buffType,buff,skillName,duration);
      if (success) then
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = nil;
        item.duration:SetBackColor(self.appliedByPanel.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor);
        
        item.duration.lastValidValue = duration;
        
      else
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = Tooltip(errorMsg,TooltipStyle.Menu,204,item.duration,nil,nil,0,2,item.duration.lastValidValue);
        item.duration:SetBackColor(Menu.errorColor);
      end
    end
    
    prevControl = self.appliedByPanel;
  end
  
  self.removeTraitControl = Turbine.UI.Control();
  self.removeTraitControl.prevControl = prevControl;
  self.removeTraitControl:SetParent(self.panelBackground);
  self.removeTraitControl:SetPosition((width-124)/2,prevControl:GetTop()+prevControl:GetHeight()+(prevControl:GetHeight() == 22 and 0 or self.controlPadding));
  self.removeTraitControl:SetSize(138,21);
  
  self.removeTraitConfiguration = Turbine.UI.Control();
  self.removeTraitConfiguration:SetParent(self.removeTraitControl);
  self.removeTraitConfiguration:SetTop(3);
  self.removeTraitConfiguration:SetSize(15,15);
  self.removeTraitConfiguration:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.removeTraitConfiguration:SetBackground("CombatAnalysis/Resources/remove_icon.tga");
  self.removeTraitConfiguration:SetMouseVisible(false);
  
  self.removeTraitConfigurationLabel = MenuLabel(self.removeTraitControl,0,118,21,"14");
  self.removeTraitConfigurationLabel:SetLeft(20);
  self.removeTraitConfigurationLabel:SetMultiline(false);
  self.removeTraitConfigurationLabel:SetOutlineColor(Turbine.UI.Color(0.5,0,0));
  self.removeTraitConfigurationLabel:SetForeColor(Turbine.UI.Color(1,1,1));
  self.removeTraitConfigurationLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.removeTraitConfigurationLabel:SetText((self.buffType == "Debuff" or self.buffType == "CrowdControl") and L.RemoveDebuff or L.RemoveBuff);
  
  self.removeTraitControl.MouseEnter = function(sender,args)
    self.removeTraitConfigurationLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.removeTraitConfigurationLabel:SetText(self.removeTraitConfigurationLabel:GetText());
  end
  
  self.removeTraitControl.MouseLeave = function(sender,args)
    self.removeTraitConfigurationLabel:SetFontStyle(Turbine.UI.FontStyle.None);
    self.removeTraitConfigurationLabel:SetText(self.removeTraitConfigurationLabel:GetText());
  end
  
  self.removeTraitControl.MouseClick = function(sender,args)
    if (self.dummyRow) then
      self.dummyRow = nil;
      self.title:RemoveError();
      self.parentPanel.dummyRow = nil;
    end
    
    self.parentPanel:RemoveBuff(self.title);
    
    Traits.RemoveBuff(self.buffType,self.buffInfo);
  end
  
  TooltipManager.SetTooltip(self.removeTraitControl,L.RemoveBuffTooltip,TooltipStyle.LOTRO,500);
end

function BuffPanelNode:Layout()
  
end

function BuffPanelNode:UpdateControlHeight()
	local w = self:GetWidth();
  
  local h = 0;
  
  if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
    self.removalStartY = self.removalOnly:GetTop();
    self.removalTargetY = (self.removalOnly.prevControl:GetTop()+self.removalOnly.prevControl:GetHeight()+self.controlPadding+2);
    
    self.toggleStartY = self.toggleSkill:GetTop();
    self.toggleTargetY = (self.toggleSkill.prevControl:GetTop()+self.toggleSkill.prevControl:GetHeight()+self.controlPadding+2);
    
    self.overwritesStartY = self.overwrites:GetTop();
    self.overwritesTargetY = ((self.overwrites.prevControl == self.removalOnly and self.removalTargetY or self.overwrites.prevControl:GetTop())+(self.overwrites.prevControl.targetH or self.overwrites.prevControl:GetHeight())+self.controlPadding);
    
    self.overwritesPanelStartY = self.overwritesPanel:GetTop();
    self.overwritesPanelTargetY = (self.overwritesTargetY+(self.overwritesPanel:IsVisible() and 2 or 0));
    
    self.conflictsStartY = self.conflicts:GetTop();
    self.conflictsTargetY = (self.overwritesPanelTargetY+(self.overwritesPanel:IsVisible() and self.overwritesPanel.targetH+(self.overwritesPanel.targetH == self.overwritesPanel.headingHeight and 0 or self.controlPadding) or 0));
    
    self.conflictsPanelStartY = self.conflictsPanel:GetTop();
    self.conflictsPanelTargetY = (self.conflictsTargetY+(self.conflictsPanel.targetVisible == 0 and 2 or 0));
    
    self.conflictsPanelOverlay:SetHeight(self.conflictsPanel:GetHeight());
    
    self.effectModifiersStartY = self.effectModifiers:GetTop();
    self.effectModifiersTargetY = (self.conflictsPanelTargetY+(self.conflictsPanel.targetVisible == 0 and self.conflictsPanel.targetH+(self.conflictsPanel.targetH == self.conflictsPanel.headingHeight and 0 or self.controlPadding) or 0));
    
    self.effectModifiersPanelStartY = self.effectModifiersPanel:GetTop();
    self.effectModifiersPanelTargetY = (self.effectModifiersTargetY+(self.effectModifiersPanel.targetVisible == 0 and 2 or 0));
    
    self.effectModifiersPanelOverlay:SetHeight(self.effectModifiersPanel:GetHeight());
    
  elseif (self.buffType == "Buff") then
    self.stackingStartY = self.stacking:GetTop();
    self.stackingTargetY = (self.stacking.prevControl:GetTop()+(self.stacking.prevControl.targetH or self.stacking.prevControl:GetHeight())+self.controlPadding);
    
    self.stackingPanelStartY = self.stackingPanel:GetTop();
    self.stackingPanelTargetY = (self.stackingTargetY+(self.stackingPanel:IsVisible() and 2 or 0));
    
  end
  
  if (self.buffType ~= "TempMorale") then
    self.appliedByStartY = self.appliedByLabel:GetTop();
    
    if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
      self.appliedByTargetY = (self.effectModifiersPanelTargetY+(self.effectModifiersPanel.targetVisible == 0 and self.effectModifiersPanel.targetH+(self.effectModifiersPanel.targetH == self.effectModifiersPanel.headingHeight and 0 or self.controlPadding) or 0));
    elseif (self.buffType == "Buff") then
      self.appliedByTargetY = (self.stackingPanelTargetY+(self.stackingPanel.targetVisible == 0 and self.stackingPanel.targetH+(self.stackingPanel.targetH == self.stackingPanel.headingHeight and 0 or self.controlPadding) or 0));
    end
    
    self.appliedByPanelStartY = self.appliedByPanel:GetTop();
    self.appliedByPanelTargetY = (self.appliedByTargetY+(self.appliedByPanel:IsVisible() and 2 or 0));
  end
  
  if (self.removeTraitControl ~= nil) then
    self.removeTraitStartY = self.removeTraitControl:GetTop();
    self.removeTraitTargetY = 10+((self.removeTraitControl.prevControl == self.appliedByPanel and self.appliedByPanelTargetY or self.removeTraitControl.prevControl:GetTop())+(self.removeTraitControl.prevControl.targetH or self.removeTraitControl.prevControl:GetHeight())+((self.removeTraitControl.prevControl.targetH or self.removeTraitControl.prevControl:GetHeight()) == self.removeTraitControl.headingHeight and 0 or self.controlPadding));
  end
  
  h = (self.iconLabel ~= nil and self.iconLabel.targetVisible == 0 and self.iconLabel:GetHeight()+self.controlPadding or 0)+
      (self.removalOnly ~= nil and self.removalOnly:IsVisible() and 2+self.removalOnly:GetHeight()+self.controlPadding or 0)+
      (self.isStance ~= nil and self.isStance:IsVisible() and 2+self.isStance:GetHeight()+self.controlPadding or 0)+
      (self.overwritesPanel ~= nil and self.overwritesPanel:IsVisible() and 2+self.overwritesPanel.targetH+(self.overwritesPanel.targetH == self.overwritesPanel.headingHeight and 0 or self.controlPadding) or 0)+
      (self.conflictsPanel ~= nil and self.conflictsPanel.targetVisible == 0 and 2+self.conflictsPanel.targetH+(self.conflictsPanel.targetH == self.conflictsPanel.headingHeight and 0 or self.controlPadding) or 0)+
      (self.effectModifiersPanel ~= nil and self.effectModifiersPanel.targetVisible == 0 and 2+self.effectModifiersPanel.targetH+(self.effectModifiersPanel.targetH == self.effectModifiersPanel.headingHeight and 0 or self.controlPadding) or 0)+
      (self.stackingPanel ~= nil and self.stackingPanel:IsVisible() and 2+self.stackingPanel.targetH+(self.stackingPanel.targetH == self.stackingPanel.headingHeight and 0 or self.controlPadding) or 0)+
      (self.logNameLabel ~= nil and self.logNameLabel:IsVisible() and self.logNameLabel:GetHeight()+self.controlPadding or 0)+
      (self.appliedByPanel ~= nil and self.appliedByPanel:IsVisible() and 2+self.appliedByPanel.targetH+(self.appliedByPanel.targetH > self.appliedByPanel.headingHeight and self.controlPadding-2 or 0) or 0)+
      (self.removeTraitControl ~= nil and self.removeTraitControl:IsVisible() and 10+self.removeTraitControl:GetHeight()+self.controlPadding or 0);
  
  self.startTime = Turbine.Engine.GetGameTime();
  self.startH = self:GetHeight();
  self.targetH = 65+h;
  self:SetWantsUpdates(true);
end

function BuffPanelNode:Update()
  local proportion = (self.initialUpdate and 1 or math.min(1,(Turbine.Engine.GetGameTime()-self.startTime)/0.4));
  
  if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
    self.removalOnly:SetTop(self.removalStartY+Misc.Round(proportion*(self.removalTargetY-self.removalStartY))); 
    self.toggleSkill:SetTop(self.toggleStartY+Misc.Round(proportion*(self.toggleTargetY-self.toggleStartY)));
    
    self.overwrites:SetTop(self.overwritesStartY+Misc.Round(proportion*(self.overwritesTargetY-self.overwritesStartY))); 
    self.overwritesPanel:SetTop(self.overwritesPanelStartY+Misc.Round(proportion*(self.overwritesPanelTargetY-self.overwritesPanelStartY)));
    self:SetPanelHeight(self.overwritesPanel,proportion);
    
    self.conflicts:SetTop(self.conflictsStartY+Misc.Round(proportion*(self.conflictsTargetY-self.conflictsStartY))); 
    self.conflictsPanel:SetTop(self.conflictsPanelStartY+Misc.Round(proportion*(self.conflictsPanelTargetY-self.conflictsPanelStartY)));
    self:SetPanelHeight(self.conflictsPanel,proportion);
    
    self.effectModifiers:SetTop(self.effectModifiersStartY+Misc.Round(proportion*(self.effectModifiersTargetY-self.effectModifiersStartY))); 
    self.effectModifiersPanel:SetTop(self.effectModifiersPanelStartY+Misc.Round(proportion*(self.effectModifiersPanelTargetY-self.effectModifiersPanelStartY)));
    self:SetPanelHeight(self.effectModifiersPanel,proportion);
    
  elseif (self.buffType == "Buff") then
    self.stacking:SetTop(self.stackingStartY+Misc.Round(proportion*(self.stackingTargetY-self.stackingStartY))); 
    self.stackingPanel:SetTop(self.stackingPanelStartY+Misc.Round(proportion*(self.stackingPanelTargetY-self.stackingPanelStartY)));
    self:SetPanelHeight(self.stackingPanel,proportion);
    
  end
  
  if (self.buffType ~= "TempMorale") then
    self.appliedByLabel:SetTop(self.appliedByStartY+Misc.Round(proportion*(self.appliedByTargetY-self.appliedByStartY))); 
    self.appliedByPanel:SetTop(self.appliedByPanelStartY+Misc.Round(proportion*(self.appliedByPanelTargetY-self.appliedByPanelStartY)));
    self:SetPanelHeight(self.appliedByPanel,proportion);
  end
  
  if (self.removeTraitControl ~= nil) then
    self.removeTraitControl:SetTop(self.removeTraitStartY+Misc.Round(proportion*(self.removeTraitTargetY-self.removeTraitStartY)));
  end
  
  self.panelBackground:SetHeight(self.startH-2*self.panelPadding-2+self.nodePadding+Misc.Round(proportion*(self.targetH-self.startH))); 
  self.panel:SetHeight(self.startH-2*self.panelPadding+self.nodePadding+Misc.Round(proportion*(self.targetH-self.startH)));
	self:SetHeight(self.startH+Misc.Round(proportion*(self.targetH-self.startH)));
  
  if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
    self.iconLabelOverlay:SetBackColor(Turbine.UI.Color(self.iconLabel.startVisible+(proportion^(self.iconLabel.startVisible == 0 and self.iconLabel.targetVisible == 0.925 and 0.5 or 2))*(self.iconLabel.targetVisible-self.iconLabel.startVisible),0,0,0));
    self.iconTextBoxOverlay:SetBackColor(Turbine.UI.Color(self.iconTextBox.startVisible+(proportion^(self.iconTextBox.startVisible == 0 and self.iconTextBox.targetVisible == 0.925 and 0.5 or 2))*(self.iconTextBox.targetVisible-self.iconTextBox.startVisible),0,0,0));
    self.toggleSkillOverlay:SetBackColor(Turbine.UI.Color(self.toggleSkill.startVisible+(proportion^(self.toggleSkill.startVisible == 0 and self.toggleSkill.targetVisible == 0.925 and 0.5 or 2))*(self.toggleSkill.targetVisible-self.toggleSkill.startVisible),0,0,0));
    self.conflictsOverlay:SetBackColor(Turbine.UI.Color(self.conflicts.startVisible+(proportion^(self.conflicts.startVisible == 0 and self.conflicts.targetVisible == 0.925 and 0.5 or 2))*(self.conflicts.targetVisible-self.conflicts.startVisible),0,0,0));
    self.conflictsPanelOverlay:SetBackColor(Turbine.UI.Color(self.conflictsPanel.startVisible+(proportion^(self.conflictsPanel.startVisible == 0 and self.conflictsPanel.targetVisible == 0.925 and 0.5 or 2))*(self.conflictsPanel.targetVisible-self.conflictsPanel.startVisible),0,0,0));
    self.effectModifiersOverlay:SetBackColor(Turbine.UI.Color(self.effectModifiers.startVisible+(proportion^(self.effectModifiers.startVisible == 0 and self.effectModifiers.targetVisible == 0.925 and 0.5 or 2))*(self.effectModifiers.targetVisible-self.effectModifiers.startVisible),0,0,0));
    self.effectModifiersPanelOverlay:SetBackColor(Turbine.UI.Color(self.effectModifiersPanel.startVisible+(proportion^(self.effectModifiersPanel.startVisible == 0 and self.effectModifiersPanel.targetVisible == 0.925 and 0.5 or 2))*(self.effectModifiersPanel.targetVisible-self.effectModifiersPanel.startVisible),0,0,0));
  end
  
  if (proportion == 1) then
    if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
      self.iconLabelOverlay:SetVisible(false);
      self.iconLabel:SetVisible(self.iconLabel.targetVisible == 0);
      self.iconTextBoxOverlay:SetVisible(false);
      self.iconTextBox:SetVisible(self.iconTextBox.targetVisible == 0);
      self.toggleSkillOverlay:SetVisible(false);
      self.toggleSkill:SetVisible(self.toggleSkill.targetVisible == 0);
      self.conflictsOverlay:SetVisible(false);
      self.conflicts:SetVisible(self.conflicts.targetVisible == 0);
      self.conflictsPanelOverlay:SetVisible(false);
      self.conflictsPanel:SetVisible(self.conflictsPanel.targetVisible == 0);
      self.effectModifiersOverlay:SetVisible(false);
      self.effectModifiers:SetVisible(self.effectModifiers.targetVisible == 0);
      self.effectModifiersPanelOverlay:SetVisible(false);
      self.effectModifiersPanel:SetVisible(self.effectModifiersPanel.targetVisible == 0);
    end
    
    if (self.overwritesPanel ~= nil) then self.overwritesPanel.startH = self.overwritesPanel.targetH end
    if (self.conflictsPanel ~= nil) then self.conflictsPanel.startH = self.conflictsPanel.targetH end
    if (self.effectModifiersPanel ~= nil) then self.effectModifiersPanel.startH = self.effectModifiersPanel.targetH end
    if (self.stackingPanel ~= nil) then self.stackingPanel.startH = self.stackingPanel.targetH end
    if (self.appliedByPanel ~= nil) then self.appliedByPanel.startH = self.appliedByPanel.targetH end
    
    self.initialUpdate = false;
    self:SetWantsUpdates(false);
  end
end

function BuffPanelNode:SetPanelHeight(panel,proportion)
  local height = panel.startH+Misc.Round(proportion*(panel.targetH-panel.startH));
  panel:SetHeight(height);
  panel.panel:SetHeight(height-25);
  panel.background:SetHeight(height-30);
end

function BuffPanelNode:SetBuff(buff)
  self.buffInfo = buff;
  
  -- clean up listeners to the old buff
  for _,listener in ipairs(self.listeners) do
    Misc.RemoveListener(listener[1],listener[2],listener[3]);
  end
  self.listeners = {}
  
  self.classNameLabel:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
  
  -- configure std details
  self.dummyRow = (self.buffInfo.skillName == "" and true or nil);
  
  if (self.dummyRow) then self.title:AddError() end
  
  self.classNameDropDown:SetEnabled(self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly);
  
  table.insert(self.listeners,{self.buffInfo,"class",self});
  Misc.AddListener(self.buffInfo, "class", function(sender)
		if (self.buffInfo.class ~= self.classNameDropDown:GetSelection()) then
			self.classNameDropDown:SetSelection(self.buffInfo.class);
		end
	end, self, self);
  
  self.buffNameLabel:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
  self.buffNameTextBox:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
  self.buffNameTextBox:SetEnabled(self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly);
  
  if (self.buffType == "Debuff" or self.buffType == "CrowdControl") then
    self.iconLabel:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
    self.iconTextBox:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
    self.iconTextBox:SetEnabled(self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly);
    
    table.insert(self.listeners,{self.buffInfo,"bb",self});
    Misc.AddListener(self.buffInfo, "bb", function(sender)
      self.iconLabel.startVisible = (self:GetWantsUpdates() and self.iconLabelOverlay:GetBackColor().A or (self.iconLabel:IsVisible() and 0 or 0.925));
      self.iconLabel.targetVisible = (not removalOnly and self.buffInfo.bb and 0 or 0.925);
      self.iconTextBox.startVisible = (self:GetWantsUpdates() and self.iconTextBoxOverlay:GetBackColor().A or (self.iconTextBox:IsVisible() and 0 or 0.925));
      self.iconTextBox.targetVisible = (not removalOnly and self.buffInfo.bb and 0 or 0.925);
      
      self.removalOnly.prevControl = (self.iconLabel.targetVisible == 0 and self.iconLabel or self.buffNameLabel);
      self.toggleSkill.prevControl = (self.iconLabel.targetVisible == 0 and self.iconLabel or self.buffNameLabel);
      
      self.toggleSkill.startVisible = (self:GetWantsUpdates() and self.toggleSkillOverlay:GetBackColor().A or (self.toggleSkill:IsVisible() and 0 or 0.925));
      self.conflicts.startVisible = (self:GetWantsUpdates() and self.conflictsOverlay:GetBackColor().A or (self.conflicts:IsVisible() and 0 or 0.925));
      self.conflictsPanel.startVisible = (self:GetWantsUpdates() and self.conflictsPanelOverlay:GetBackColor().A or (self.conflictsPanel:IsVisible() and 0 or 0.925));
      self.effectModifiers.startVisible = (self:GetWantsUpdates() and self.effectModifiersOverlay:GetBackColor().A or (self.effectModifiers:IsVisible() and 0 or 0.925));
      self.effectModifiersPanel.startVisible = (self:GetWantsUpdates() and self.effectModifiersPanelOverlay:GetBackColor().A or (self.effectModifiersPanel:IsVisible() and 0 or 0.925));
      
      self.iconLabelOverlay:SetVisible(true);
      self.iconLabel:SetVisible(true);
      self.iconTextBoxOverlay:SetVisible(true);
      self.iconTextBox:SetVisible(true);
      
      self:UpdateControlHeight();
    end, self, self);
    
    self.overwrites.prevControl = self.iconLabel;
    if (self.buffType == "CrowdControl") then
      if (self.buffInfo.removalOnly) then
        self.removalOnly:SetEnabled(false);
        self.removalOnly:SetForeColor(LabelledComboBox.DisabledColor);
        self.overwrites.prevControl = self.removalOnly;
      else
        self.removalOnly:SetVisible(false);
        self.removalOnly.startVisible = 0.925;
        self.removalOnly.targetVisible = 0.925;
        self.toggleSkill:SetVisible(false);
        self.toggleSkill.startVisible = 0.925;
        self.toggleSkill.targetVisible = 0.925;
      end
    else
      self.overwrites.prevControl = self.removalOnly;
    end
    self.overwrites:SetTop(self.overwrites.prevControl:GetTop()+self.overwrites.prevControl:GetHeight()+self.controlPadding);
    
    self.overwrites:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
    self.conflicts:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
    
    if (self.buffType == "CrowdControl" and not self.buffInfo.removalOnly) then
      if (self.buffInfo.skillName == L.StunImmunity) then
        self.overwrites:SetVisible(false);
        self.overwrites.startVisible = 0.925;
        self.overwrites.targetVisible = 0.925;
        self.overwritesPanel:SetVisible(false);
        self.overwritesPanel.startVisible = 0.925;
        self.overwritesPanel.targetVisible = 0.925;
        self.conflicts:SetVisible(false);
        self.conflicts.startVisible = 0.925;
        self.conflicts.targetVisible = 0.925;
        self.conflictsPanel:SetVisible(false);
        self.conflictsPanel.startVisible = 0.925;
        self.conflictsPanel.targetVisible = 0.925;
      else
        self.overwritesPanel.addRemove:SetVisible(false);
        self.conflictsPanel.addRemove:SetVisible(false);
      end
    end
    
  elseif (self.buffType == "TempMorale") then
    self.logNameTextBox:SetForeColor((self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly) and control2LightColor or LabelledComboBox.DisabledColor);
    self.logNameTextBox:SetEnabled(self.buffType ~= "CrowdControl" or self.buffInfo.removalOnly);
    
  end
  
  if (self.buffType ~= "TempMorale") then
    if (self.buffInfo.skillName == L.StunImmunity) then
      self.appliedByLabel:SetVisible(false);
      self.appliedByLabel.startVisible = 0.925;
      self.appliedByLabel.targetVisible = 0.925;
      self.appliedByPanel:SetVisible(false);
      self.appliedByPanel.startVisible = 0.925;
      self.appliedByPanel.targetVisible = 0.925;
    end
  end
  
  if (self.buffType == "CrowdControl" and (self.buffInfo.skillName == L.Daze or self.buffInfo.skillName == L.Root or self.buffInfo.skillName == L.Fear or self.buffInfo.skillName == L.Stun or self.buffInfo.skillName == L.Knockdown or self.buffInfo.skillName == L.StunImmunity)) then
    self.removeTraitControl:SetVisible(false);
  end
  
  self.classNameDropDown:SetSelection(self.buffInfo.class);
  self.buffNameTextBox:SetText(self.buffInfo.skillName);
  
  if (self.buffType == "TempMorale") then
    self.logNameTextBox:SetText(self.buffInfo.logName);
  elseif (self.buffType == "Buff") then
    self.isStance:SetChecked(self.buffInfo.isStance);
  else
    self.iconTextBox:SetText(self.buffInfo.iconName);
    self.removalOnly:SetChecked(self.buffInfo.removalOnly);
    self.toggleSkill:SetChecked(self.buffInfo.toggleSkill);
  end
  
  -- configure panels
  
  -- clean up listeners to the old buff
  if (self.overwritesPanel ~= nil) then
    Misc.TableClear(self.overwritesPanel.selectedBuffs);
    Misc.TableClear(self.overwritesPanel.items);
    self.overwritesPanel:SetBuff(self.buffType,self.buffInfo,traits.configurations[traits.selected][self.buffType == "Debuff" and "debuffs" or "crowdControl"],self.buffInfo.overwrites);
  end
  
  if (self.conflictsPanel ~= nil) then
    self.conflictsPanel:SetBuff(self.buffType,self.buffInfo,traits.configurations[traits.selected][self.buffType == "Debuff" and "debuffs" or "crowdControl"],self.buffInfo.conflicts);
  end
  
  if (self.effectModifiersPanel ~= nil) then
    Misc.TableClear(self.effectModifiersPanel.selectedBuffs);
    Misc.TableClear(self.effectModifiersPanel.items);
    self.effectModifiersPanel:SetBuff(self.buffType,self.buffInfo,traits.buffs,self.buffInfo.buffEffects);
  end
  
  if (self.stackingPanel ~= nil) then
    Misc.TableClear(self.stackingPanel.selectedBuffs);
    Misc.TableClear(self.stackingPanel.items);
    self.stackingPanel:SetBuff(self.buffType,self.buffInfo,nil,self.buffInfo.stacking);
  end
  
  if (self.appliedByPanel ~= nil) then
    Misc.TableClear(self.appliedByPanel.selectedBuffs);
    Misc.TableClear(self.appliedByPanel.items);
    self.appliedByPanel:SetBuff(self.buffType,self.buffInfo,nil,self.buffInfo.appliedBy);
  end
  
  self.initialUpdate = true;
  self:UpdateControlHeight();
end

-- we update the parent's expand/collapse icons on visible changed of its children since mouse events seem to come one frame too late
function BuffPanelNode:VisibleChanged(sender,args)
  local parent = self:GetParentNode();
  if (parent == nil) then return end
  
  if (parent.clicked) then
    parent:SetExpanded(not parent:IsExpanded());
    parent.clicked = false;
    return;
  end
  
	parent.plus:SetBackground(parent:IsExpanded() and 0x41007E26 or 0x41007E27);
  
  if (self:IsVisible()) then
    if (self.creationTime == Turbine.Engine.GetGameTime()) then
      self.buffNameTextBox:Focus();
      self.focusWhenExpanded = nil;
    else
      self.creationTime = nil;
      KeyManager.TakeFocus();
    end
  end
end

function BuffPanelNode:MouseDown(args)
	KeyManager.TakeFocus(self);
end
