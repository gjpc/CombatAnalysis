
_G.BuffInfoPanel = class(Turbine.UI.Control);

function BuffInfoPanel:Constructor(node,width,controlPadding,panelPadding,innerPadding,panelType,items,selectedBuffs,isDebuff)
	Turbine.UI.TreeNode.Constructor(self);
  
  self.panelType = panelType;
  self.ownItems = {};
  self.items = (items or {});
  self.selectedBuffs = (selectedBuffs or {});
  
  self.listeners = {}
  
  local headingIncrease = 11;
  self.headingHeight = 22+((self.panelType == "AppliedBy" and isDebuff) and headingIncrease or 0);
  
  self.controlPadding = controlPadding;
  self.panelPadding = panelPadding;
  self.innerPadding = innerPadding;
  self.itemHeight = 19;
  
  self.selected = nil;
  
  self.node = node;
  self.width = width;
  self.startH = self.headingHeight;
  self.targetH = self.headingHeight;
  
	self:SetSize(width,self.headingHeight);
  self:SetMouseVisible(false);
  
  self.addRemove = AddRemove();
  self.addRemove:SetParent(self);
  self.addRemove:SetPosition(173,0);
  self.addRemove.removeControl:SetVisible(false);
  
  self.addRemove.addControl.MouseDown = function(sender,args)
    KeyManager.TakeFocus(self);
  end
  
  self.addRemove.addControl.MouseClick = function(sender,args)
    if (not self.dummyAdded) then
      local item = self:AddItem();
      if (self.selected ~= nil) then self.selected:SetSelected(false) end
      self.selected = item;
      self.addRemove.removeControl:SetEnabled(true);
      item:SetSelected(true);
      self.dummyAdded = item;
    else
      if (self.selected ~= nil) then self.selected:SetSelected(false) end
      self.selected = self.dummyAdded;
      self.selected:SetSelected(true);
      self.addRemove.removeControl:SetEnabled(true);
    end
  end
  
  self.addRemove.removeControl.MouseDown = function(sender,args)
    KeyManager.TakeFocus(self);
  end
  
  self.addRemove.removeControl.MouseClick = function(sender,args)
    if (self.selected == nil) then return end -- shouldn't happen
    if (#self.ownItems == 1 and self.panelType == "AppliedBy" and not args.removeLast) then return end -- can't remove last item from applied by panel
    
    local prevSelected = self.selected;
    local removingDummy = (prevSelected == self.dummyAdded);
    
    -- remove from lists, etc
    
    local ownIndex;
    
    for index,item in ipairs(self.items) do
      if (item == prevSelected) then
        table.remove(self.items,index);
        break;
      end
    end
    
    for index,item in ipairs(self.ownItems) do
      if (item == prevSelected) then
        ownIndex = index;
        table.remove(self.ownItems,index);
        break;
      end
    end
    
    prevSelected:SetParent(nil);
    
    -- update positions of remaining items
    
    local itemCount = 0;
    for index=1,#self.ownItems do
      local item = self.ownItems[index];
      item.position = index;
      
      itemCount = itemCount + (item.hidden and 0 or 1);
      
      item:SetTop(1+(itemCount-1)*self.itemHeight);
      item.label:SetLeft(itemCount > 9 and 5 or 9);
      item.label:SetWidth(itemCount > 9 and 14 or 10);
      item.label:SetText(itemCount);
    end
    
    self.startH = self:GetHeight();
    self.targetH = (itemCount == 0 and self.headingHeight or self.headingHeight + 3 + self.controlPadding + itemCount*self.itemHeight);
    
    self.node:UpdateControlHeight(self);
    
    if (itemCount == 0 or (itemCount == 1 and self.panelType == "AppliedBy")) then self.addRemove.removeControl:SetVisible(false) end
    
    -- remove all listeners to ensure the item is removed from memory
    
    for _,listener in ipairs(prevSelected.listeners) do
      Misc.RemoveListener(listener[1],listener[2],listener[3]);
    end
    prevSelected.listeners = {}
    
    -- update selection status, etc
    
    if (removingDummy) then self.dummyAdded = false end
    prevSelected:SetSelected(false);
    self.selected = (#self.ownItems > 0 and self.ownItems[math.min(ownIndex,#self.ownItems)] or nil);
    if (self.selected ~= nil) then self.selected:SetSelected(true) end
    self.addRemove.removeControl:SetEnabled(self.selected ~= nil);
    
    -- hide the titles if necessary
    
    local hasItems = false;
    for index = 1,#self.ownItems do
      if (not self.ownItems[index].hidden) then
        hasItems = true;
        break;
      end
    end
    
    if (not hasItems) then
      self.critsTitle:SetVisible(false);
      self.delayTitle:SetVisible(false);
      self.durationTitle:SetVisible(false);
    end
    
    -- finally fire the listeners if necessary
    
    if (not args.dontRemove and not removingDummy and self.ItemRemoved) then
      self:ItemRemoved(self.buff,(prevSelected.skillDropDown ~= nil and prevSelected.skillDropDown:GetSelection() or prevSelected.skillTextBox.lastValidValue),prevSelected);
    end
  end
  
  self.critsTitle = MenuLabel(self,10+headingIncrease,25,15);
  self.critsTitle:SetLeft(263);
  self.critsTitle:SetText(L.CritsOnlyAbbreviation);
  self.critsTitle:SetMouseVisible(true);
  self.critsTitle.MouseDown = function(sender,args) KeyManager.TakeFocus() end
  TooltipManager.SetTooltip(self.critsTitle,L.CritsOnlyTooltip,TooltipStyle.LOTRO,500);
  
  self.delayTitle = MenuLabel(self,10+headingIncrease,25,15);
  self.delayTitle:SetLeft(295);
  self.delayTitle:SetText(L.DelayAbbreviation);
  self.delayTitle:SetMouseVisible(true);
  self.delayTitle.MouseDown = function(sender,args) KeyManager.TakeFocus() end
  TooltipManager.SetTooltip(self.delayTitle,L.DelayTooltip,TooltipStyle.LOTRO,500);
  
  self.durationTitle = MenuLabel(self,10+(self.panelType == "AppliedBy" and headingIncrease or 0),25,15);
  self.durationTitle:SetLeft(323);
  self.durationTitle:SetText(L.DurationAbbreviation);
  self.durationTitle:SetMouseVisible(true);
  self.durationTitle.MouseDown = function(sender,args) KeyManager.TakeFocus() end
  TooltipManager.SetTooltip(self.durationTitle,(self.panelType == "AppliedBy" and L.DurationTooltip or L.EffectModifierDurationTooltip),TooltipStyle.LOTRO,500);
  
  self.panel = Turbine.UI.Control();
  self.panel:SetParent(self);
  self.panel:SetPosition(5,self.headingHeight+self.controlPadding);
  self.panel:SetSize(width-2*self.panelPadding-2-10,0);
  self.panel:SetBackColor(blueBorderColor);
  self.panel:SetMouseVisible(false);
  
  self.background = Turbine.UI.Control();
  self.background:SetParent(self.panel);
  self.background:SetPosition(2,2);
  self.background:SetSize(width-2*self.panelPadding-2-10-4,0);
  self.background:SetBackground("CombatAnalysis/Resources/buff_panel_background_selected.tga");
  self.background:SetMouseVisible(false);
end

function BuffInfoPanel:Layout()
	local w = self:GetWidth();
  
end

function BuffInfoPanel:MouseDown(args)
	KeyManager.TakeFocus();
end

local function AddItemToDropDown(panel,item,skillInfo,skillName)
  if (panel.selectedBuffs[skillInfo]) then return end
  
  if (skillInfo.skillName == "") then
    item.skillDropDown.listBox.emptyItem = skillInfo;
  end
  
  local newIndex;
  for i=item.skillDropDown.listBox:GetItemCount(),1,-1 do
    if (item.skillDropDown.listBox:GetItem(i).label:GetText() < skillInfo.skillName) then
      newIndex = i+1;
      item.skillDropDown:AddItem((skillInfo.skillName == "" and "< "..L.NameRequiredPrefix.." >" or skillInfo.skillName),skillInfo,newIndex);
      break;
    end
  end
  if (newIndex == nil) then
    newIndex = 1;
    item.skillDropDown:AddItem((skillInfo.skillName == "" and "< "..L.NameRequiredPrefix.." >" or skillInfo.skillName),skillInfo,newIndex);
  end
  
  if (skillInfo.skillName == skillName) then
    item.skillDropDown:ItemSelected(newIndex);
    panel.selectedBuffs[skillInfo] = true;
    for _,existingItem in ipairs(panel.items) do
      existingItem.skillDropDown:RemoveItem(skillInfo);
      Misc.RemoveListener(skillInfo, "skillName", existingItem);
      for index,info in ipairs(existingItem.listeners) do
        if (info[1] == skillInfo and info[2] == "skillName" and info[3] == existingItem) then
          table.remove(existingItem.listeners,index);
          break;
        end
      end
    end
  end
  
  table.insert(item.listeners,{skillInfo,"skillName",item});
  Misc.AddListener(skillInfo, "skillName", function(sender)
    local listBoxItem = item.skillDropDown:GetItemWithValue(skillInfo);
    
    if (listBoxItem ~= nil and listBoxItem.label:GetText() ~= skillInfo.skillName) then
      local oldName = item.skillDropDown.label:GetText();
      
      if (item.skillDropDown.listBox.emptyItem == skillInfo) then
        oldName = "";
        item.skillDropDown.listBox.emptyItem = nil;
      end
      
      listBoxItem.label:SetText(skillInfo.skillName);
      local index = item.skillDropDown.listBox:IndexOfItem(listBoxItem);
      
      -- remove and re-insert the listboxitem, without recreating it
      item.skillDropDown.listBox:RemoveItemAt(index);
      local newIndex;
      for i=1,item.skillDropDown.listBox:GetItemCount() do
        if (item.skillDropDown.listBox:GetItem(i).label:GetText() > skillInfo.skillName) then
          newIndex = i;
          item.skillDropDown.listBox:InsertItem(newIndex,listBoxItem);
          break;
        end
      end
      if (newIndex == nil) then
        newIndex = item.skillDropDown.listBox:GetItemCount()+1;
        item.skillDropDown.listBox:AddItem(listBoxItem);
      end
      
      -- update the selection index
      if (index == item.skillDropDown.selection) then
        item.skillDropDown.label:SetText((skillInfo.skillName == "" and "< "..L.NameRequiredPrefix.." >" or skillInfo.skillName));
        item.skillDropDown.selection = newIndex;
        -- also fire a skill selected event so that the name will be updated
        if (panel.SkillSelected) then
          panel:SkillSelected(panel.buff,skillInfo.skillName,oldName,item.position,item.duration:GetText(),item);
        end
        
      elseif (item.skillDropDown.selection ~= -1) then
        if (index < newIndex) then
          if (item.skillDropDown.selection > index and item.skillDropDown.selection <= newIndex) then
            item.skillDropDown.selection = item.skillDropDown.selection - 1;
          end
        elseif (index > newIndex) then
          if (item.skillDropDown.selection < index and item.skillDropDown.selection >= newIndex) then
            item.skillDropDown.selection = item.skillDropDown.selection + 1;
          end
        end
      end
    end
  end, item, item);
end

function BuffInfoPanel:AddNewSkillInfo(item, skillInfo, skillName)

  table.insert(item.listeners,{skillInfo,"removalOnly",item});
  Misc.AddListener(skillInfo, "removalOnly", function(sender)
    if (skillInfo.removalOnly) then
      if (item.skillDropDown:GetSelection() ~= skillInfo) then
        item.skillDropDown:RemoveItem(skillInfo);
        Misc.RemoveListener(skillInfo, "skillName", item);
        for index,info in ipairs(item.listeners) do
          if (info[1] == skillInfo and info[2] == "skillName" and info[3] == item) then
            table.remove(item.listeners,index);
            break;
          end
        end
      else
        self:HideItem(item,true);
      end
    elseif ((skillInfo.toggleSkill and self.buff.toggleSkill) or (not skillInfo.toggleSkill and not self.buff.toggleSkill)) then
      if (item.skillDropDown:GetSelection() == skillInfo) then
        self:HideItem(item,false);
      else
        AddItemToDropDown(self,item,skillInfo);
      end
    end
  end, item, item);
  
  table.insert(item.listeners,{skillInfo,"toggleSkill",item});
  Misc.AddListener(skillInfo, "toggleSkill", function(sender)
    if ((skillInfo.toggleSkill and self.buff.toggleSkill) or (not skillInfo.toggleSkill and not self.buff.toggleSkill)) then
      if (not skillInfo.removalOnly) then
        if (item.skillDropDown:GetSelection() == skillInfo) then
          self:HideItem(item,false);
        else
          AddItemToDropDown(self,item,skillInfo);
        end
      end
    else
      if (item.skillDropDown:GetSelection() ~= skillInfo) then
        item.skillDropDown:RemoveItem(skillInfo);
        Misc.RemoveListener(skillInfo, "skillName", item);
        for index,info in ipairs(item.listeners) do
          if (info[1] == skillInfo and info[2] == "skillName" and info[3] == item) then
            table.remove(item.listeners,index);
            break;
          end
        end
      else
        self:HideItem(item,true);
      end
    end
  end, item, item);
  
  if (not skillInfo.removalOnly and ((skillInfo.toggleSkill and self.buff.toggleSkill) or (not skillInfo.toggleSkill and not self.buff.toggleSkill))) then
    AddItemToDropDown(self,item,skillInfo,skillName);
  elseif (skillInfo.skillName == skillName) then
    AddItemToDropDown(self,item,skillInfo,skillName);
    self:HideItem(item,true,true);
  end
end

function BuffInfoPanel:SetBuff(buffType, buff, buffSet, buffItems)
  for _,item in ipairs(self.ownItems) do
    for _,listener in ipairs(item.listeners) do
      Misc.RemoveListener(listener[1],listener[2],listener[3]);
    end
    item.listeners = {}
    item:SetParent(nil);
  end
  Misc.TableClear(self.ownItems);
  
  for _,listener in ipairs(self.listeners) do
    Misc.RemoveListener(listener[1],listener[2],listener[3]);
  end
  self.listeners = {}
  
  self.dummyAdded = false;
  
  self.startH = self.headingHeight;
  self.targetH = self.headingHeight;
  
  self.buffType = buffType;
  self.buff = buff;
  self.buffSet = buffSet;
  
  local hasItems = false;
  for index = 1,#self.ownItems do
    if (not self.ownItems[index].hidden) then
      hasItems = true;
      break;
    end
  end
  
  self.critsTitle:SetVisible(hasItems and (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl")));
  self.delayTitle:SetVisible(hasItems and (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl") and not self.buff.removalOnly));
  self.durationTitle:SetVisible(hasItems and (self.panelType == "SelectAndDuration" or (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl") and not self.buff.removalOnly)));
  
  if (self.panelType == "AppliedBy") then
    table.insert(self.listeners,{self.buff,"AppliedByAdded",self});
    Misc.AddListener(self.buff, "AppliedByAdded", function(sender,appliedBy)
      self:InsertItem((self.dummyAdded and #self.ownItems or #self.ownItems+1), appliedBy, appliedBy.skillName, (appliedBy.critsOnly or false), (appliedBy.delay or 0), (appliedBy.duration or 0));
    end, self, self);
    
    table.insert(self.listeners,{self.buff,"AppliedByRemoved",self});
    Misc.AddListener(self.buff, "AppliedByRemoved", function(sender,appliedBy)
      local removedItem;
      for _,item in ipairs(self.ownItems) do
        if (item.skillTextBox.lastValidValue == appliedBy.skillName) then
          removedItem = item;
        end
      end
      if (removedItem == nil) then return end
      
      local prevSelected = self.selected;
      self.selected = removedItem;
      self.addRemove.removeControl:MouseClick({dontRemove = true});
      if (self.selected) then self.selected:SetSelected(false) end
      self.selected = prevSelected;
      if (self.selected) then prevSelected:SetSelected(true) end
    end, self, self);
  
  elseif (self.panelType == "SelectOnly") then
    table.insert(self.listeners,{self.buff,"toggleSkill",self});
    Misc.AddListener(self.buff, "toggleSkill", function(sender)
      for _,item in ipairs(self.ownItems) do
        for i=#self.buffSet,1,-1 do
          local skillInfo = self.buffSet[i];
          
          if ((skillInfo.toggleSkill and self.buff.toggleSkill) or (not skillInfo.toggleSkill and not self.buff.toggleSkill)) then
            if (not skillInfo.removalOnly) then
              if (item.skillDropDown:GetSelection() == skillInfo) then
                self:HideItem(item,false);
              else
                AddItemToDropDown(self,item,skillInfo);
              end
            end
          else
            if (item.skillDropDown:GetSelection() ~= skillInfo) then
              item.skillDropDown:RemoveItem(skillInfo);
              Misc.RemoveListener(skillInfo, "skillName", item);
              for index,info in ipairs(item.listeners) do
                if (info[1] == skillInfo and info[2] == "skillName" and info[3] == item) then
                  table.remove(item.listeners,index);
                  break;
                end
              end
            else
              self:HideItem(item,true);
            end
          end
        end
      end
    end, self, self);
    
  end
  
  if (buffItems ~= nil) then
    for _,itemDetails in ipairs(buffItems) do
      local critsOnly = nil;
      if (self.panelType == "AppliedBy" and self.buffType ~= "Buff") then critsOnly = (itemDetails.critsOnly or false) end
      
      self:AddItem(
        -- applied by
        (self.panelType == "AppliedBy" and self.buffType ~= "Buff" and itemDetails or nil),
        -- skill name
        ((self.panelType == "SelectOnly" or self.panelType == "OrderedApplications" or (self.panelType == "AppliedBy" and self.buffType == "Buff")) and itemDetails or itemDetails.skillName),
        -- crits only
        critsOnly,
        -- delay
        (self.panelType == "AppliedBy" and self.buffType ~= "Buff" and (itemDetails.delay or 0) or nil),
        -- duration
        ((self.panelType == "SelectAndDuration" or (self.panelType == "AppliedBy" and self.buffType ~= "Buff")) and (itemDetails.duration or 0) or nil)
      );
    end
    
    -- if there is no applied by data, add a dummy row, as there should always be at least one
    if (self.panelType == "AppliedBy" and #buffItems == 0 and (self.buffType ~= "CrowdControl" or self.buff.skillName ~= L.StunImmunity)) then self.addRemove.addControl.MouseClick() end
  end
end

function BuffInfoPanel:AddItem(appliedBy, skillName, critsOnly, delay, duration)
  return self:InsertItem(#self.ownItems+1, appliedBy, skillName, critsOnly, delay or 0, duration or 0);
end

function BuffInfoPanel:InsertItem(position, appliedBy, skillName, critsOnly, delay, duration)
  local item = Turbine.UI.Control();
  item:SetParent(self.panel);
  item:SetLeft(1);
  item:SetSize(self.width-2*self.panelPadding-2-10-2,self.itemHeight+1);
  item:SetBackColor(blueBorderColor);
  
  item.appliedBy = appliedBy;
  item.listeners = {}
  
  item.background = Turbine.UI.Control();
  item.background:SetParent(item);
  item.background:SetPosition(1,1);
  item.background:SetSize(self.width-2*self.panelPadding-2-10-4,self.itemHeight-1);
  item.background:SetBackground("CombatAnalysis/Resources/buff_panel_background.tga");
  item.background:SetMouseVisible(false);
  
  item.label = Turbine.UI.Label();
  item.label:SetParent(item);
  item.label:SetTop(1);
  item.label:SetHeight(20);
  item.label:SetForeColor(Turbine.UI.Color(1,1,1));
  item.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  item.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  item.label:SetMultiline(false);
  item.label:SetMouseVisible(false);
  
  if (self.panelType ~= "AppliedBy" and self.panelType ~= "OrderedApplications" and self.buffType == "CrowdControl" and (self.buff.skillName == L.Daze or self.buff.skillName == L.Fear or self.buff.skillName == L.Root or self.buff.skillName == L.Stun or self.buff.skillName == L.Knockdown)) then
    item.label:SetForeColor(LabelledComboBox.DisabledColor);
  end
  
  if (self.panelType == "AppliedBy" or self.panelType == "OrderedApplications") then
    item.skillTextBox = Turbine.UI.Lotro.TextBox();
    item.skillTextBox:SetParent(item);
    item.skillTextBox:SetPosition(20,0);
    item.skillTextBox:SetSize(210,20);
    item.skillTextBox:SetForeColor(control2LightColor);
    item.skillTextBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    item.skillTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    item.skillTextBox:SetBackColor(blueBorderColor);
    item.skillTextBox:SetMultiline(false);
    item.skillTextBox:SetText(skillName);
    item.skillTextBox.lastValidValue = skillName;
    if (skillName ~= nil) then self.selectedBuffs[skillName] = true end
    
    item.skillTextBox.KeyDown = function(sender,args)
      if (item.skillTextBox:HasFocus() and args.Action == 162) then
        KeyManager.TakeFocus();
      end
    end
    
    item.skillTextBox.FocusGained = function(sender,args)
      item.skillTextBox.startText = item.skillTextBox:GetText();
      
      item.skillTextBox:SetWantsKeyEvents(true);
      if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:SetVisible(true) end
      
      if (self.selected) then self.selected:SetSelected(false) end
      self.selected = item;
      self.addRemove.removeControl:SetEnabled(true);
      item:SetSelected(true);
    end
    
    item.skillTextBox.FocusLost = function(sender,args)
      item.skillTextBox:SetWantsKeyEvents(false);
      
      -- update skill name
      if (item.skillTextBox.startText ~= item.skillTextBox:GetText()) then
        -- name restored to existing value
        if (item.skillTextBox.lastValidValue == item.skillTextBox:GetText()) then
          if (item.skillTextBox.error ~= nil) then item.skillTextBox.error:Close() end
          item.skillTextBox.error = nil;
          item.skillTextBox:SetBackColor(item.skillTextBox.error and Menu.errorColor or (self.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor));
          
        -- new name
        else
          if (self.panelType ~= "AppliedBy" or item.appliedBy == nil or item.appliedBy.skillName ~= item.skillTextBox:GetText()) then
            if (self.dummyAdded == item) then
              if (self.SkillAdded) then
                self:SkillAdded(self.buff,item.skillTextBox:GetText(),item.critsOnly:IsChecked(),item.delay:GetText(),item.duration:GetText(),item);
              end
            else
              if (self.SkillUpdated) then
                self:SkillUpdated(self.buff,item.skillTextBox:GetText(),item.skillTextBox.lastValidValue,item);
              end
            end
          end
        end
          
      -- hide error
      elseif (item.skillTextBox.error ~= nil) then
        item.skillTextBox.error:SetVisible(false);
      end
    end
    
    item.critsOnly = Turbine.UI.Lotro.CheckBox();
    item.critsOnly:SetParent(item);
    item.critsOnly:SetPosition(self.width-2*self.panelPadding-3-10-60-18-4,1);
    item.critsOnly:SetSize(18,18);
    item.critsOnly:SetChecked(critsOnly);
    if (self.buffType == "Buff" or self.showCrits == false) then
      item.critsOnly:SetVisible(false);
    end
    
    item.critsOnly.CheckedChanged = function(sender,args)
      if (self.dummyAdded ~= item and (self.panelType ~= "AppliedBy" or item.appliedBy.critsOnly ~= item.critsOnly:IsChecked()) and self.CritsOnlyUpdated) then
        self:CritsOnlyUpdated(self.buff,item.skillTextBox.lastValidValue,item.critsOnly:IsChecked());
        
        if (self.selected) then self.selected:SetSelected(false) end
        self.selected = item;
        self.addRemove.removeControl:SetEnabled(true);
        item:SetSelected(true);
      end
    end
    
    item.delay = Turbine.UI.Lotro.TextBox();
    item.delay:SetParent(item);
    item.delay:SetPosition(self.width-2*self.panelPadding-3-10-60,0);
    item.delay:SetSize(30,20);
    item.delay:SetForeColor(control2LightColor);
    item.delay:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    item.delay:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
    item.delay:SetBackColor(blueBorderColor);
    item.delay:SetMultiline(false);
    item.delay:SetText(delay);
    item.delay.lastValidValue = delay;
    
    if (self.buffType == "Buff" or self.showDelay == false) then
      item.delay:SetVisible(false);
    end
    
    item.delay.KeyDown = function(sender,args)
      if (item.delay:HasFocus() and args.Action == 162) then
        KeyManager.TakeFocus();
      end
    end
    
    item.delay.FocusGained = function(sender,args)
      item.delay.startText = item.delay:GetText();
      
      item.delay:SetWantsKeyEvents(true);
      if (item.delay.error ~= nil) then item.delay.error:SetVisible(true) end
      
      if (self.selected) then self.selected:SetSelected(false) end
      self.selected = item;
      self.addRemove.removeControl:SetEnabled(true);
      item:SetSelected(true);
    end
    
    item.delay.FocusLost = function(sender,args)
      item.delay:SetWantsKeyEvents(false);
      
      -- update delay
      if (item.delay.startText ~= item.delay:GetText()) then
        -- delay restored to existing value
        if (item.delay.lastValidValue == item.delay:GetText()) then
          if (item.delay.error ~= nil) then item.delay.error:Close() end
          item.delay.error = nil;
          item.delay:SetBackColor(item.delay.error and Menu.errorColor or (self.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor));
          
        -- new delay
        else
          if (self.dummyAdded ~= item and self.DelayUpdated) then
            self:DelayUpdated(self.buff,item.skillTextBox.lastValidValue,item.delay:GetText(),item);
          end
          
        end
        
      -- hide error
      elseif (item.delay.error ~= nil) then
        item.delay.error:SetVisible(false);
      end
    end
    
  else
    item.skillDropDown = LabelledComboBox(nil,nil,210,nil,nil,20,"13",1,blueBorderColor,Turbine.UI.ContentAlignment.MiddleLeft);
    item.skillDropDown:SetParent(item);
    item.skillDropDown:SetPosition(20,0);
    
    table.insert(item.listeners,{self.buffSet,"buffAdded",item});
    Misc.AddListener(self.buffSet, "buffAdded", function(sender,newBuffInfo)
      self:AddNewSkillInfo(item,newBuffInfo);
    end, item, item);
    
    table.insert(item.listeners,{self.buffSet,"buffRemoved",item});
    Misc.AddListener(self.buffSet, "buffRemoved", function(sender,oldBuffInfo)
      -- if the buff is selected, just remove the whole item
      if (item.skillDropDown:GetSelection() == oldBuffInfo) then
        local prevSelected = self.selected;
        self.selected = item;        
        self.addRemove.removeControl:MouseClick({});
        if (self.selected) then self.selected:SetSelected(false) end
        self.selected = prevSelected;
        if (self.selected) then prevSelected:SetSelected(true) end
      
      -- otherwise clear the listeners, and remove the buff from the drop down
      else
        Misc.RemoveListener(oldBuffInfo, "skillName", item);
        for index,info in ipairs(item.listeners) do
          if (info[1] == oldBuffInfo and info[2] == "skillName" and info[3] == item) then
            table.remove(item.listeners,index);
            break;
          end
        end
        
        Misc.RemoveListener(oldBuffInfo, "removalOnly", item);
        for index,info in ipairs(item.listeners) do
          if (info[1] == oldBuffInfo and info[2] == "removalOnly" and info[3] == item) then
            table.remove(item.listeners,index);
            break;
          end
        end
        
        Misc.RemoveListener(oldBuffInfo, "toggleSkill", item);
        for index,info in ipairs(item.listeners) do
          if (info[1] == oldBuffInfo and info[2] == "toggleSkill" and info[3] == item) then
            table.remove(item.listeners,index);
            break;
          end
        end
        
        item.skillDropDown:RemoveItem(oldBuffInfo);
      end
    end, item, item);
    
    for i=#self.buffSet,1,-1 do
      if (self.buffSet[i].skillName ~= L.StunImmunity or (self.buff.skillName == L.Stun or self.buff.skillName == L.Knockdown)) then
        self:AddNewSkillInfo(item,self.buffSet[i],skillName);
      end
    end
    
    item.skillDropDown.SelectionChanged = function(sender,newValue,oldValue)
      if (newValue == oldValue) then return end
      
      if (oldValue ~= nil) then
        self.selectedBuffs[oldValue] = nil;
      else
        self.dummyAdded = false;
      end
      
      self.selectedBuffs[newValue] = true;
      
      for _,otherItem in ipairs(self.items) do
        if (otherItem ~= item) then
          otherItem.skillDropDown:RemoveItem(newValue);
          
          if (oldValue ~= nil) then
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
      
      if (self.SkillSelected) then
        self:SkillSelected(self.buff,newValue.skillName,(oldValue and oldValue.skillName or nil),item.position,item.duration:GetText(),item);
      end
    end
    
    item.skillDropDown.DropDownOpened = function(sender)
      if (self.selected) then self.selected:SetSelected(false) end
      self.selected = item;
      self.addRemove.removeControl:SetEnabled(true);
      item:SetSelected(true);
    end
    
    if (self.panelType == "SelectOnly" and (self.buff.skillName == skillName or (self.buffType == "CrowdControl" and (self.buff.skillName == L.Daze or self.buff.skillName == L.Fear or self.buff.skillName == L.Root or self.buff.skillName == L.Stun or self.buff.skillName == L.Knockdown)))) then
      item.skillDropDown:SetEnabled(false);
    end
  end
  
  item.duration = Turbine.UI.Lotro.TextBox();
  item.duration:SetParent(item);
  item.duration:SetPosition(self.width-2*self.panelPadding-3-10-31,0);
  item.duration:SetSize(30,20);
  item.duration:SetForeColor(control2LightColor);
  item.duration:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  item.duration:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
  item.duration:SetBackColor(blueBorderColor);
  item.duration:SetMultiline(false);
  item.duration:SetText(duration);
  item.duration.lastValidValue = (duration);
  
  if (self.buffType == "Buff" or (self.panelType ~= "AppliedBy" and self.panelType ~= "SelectAndDuration") or self.showDuration == false) then
    item.duration:SetVisible(false);
  end
  
  item.duration.KeyDown = function(sender,args)
    if (item.duration:HasFocus() and args.Action == 162) then
      KeyManager.TakeFocus();
    end
  end
  
  item.duration.FocusGained = function(sender,args)
    item.duration.startText = item.duration:GetText();
    
    item.duration:SetWantsKeyEvents(true);
    if (item.duration.error ~= nil) then item.duration.error:SetVisible(true) end
    
    if (self.selected) then self.selected:SetSelected(false) end
    self.selected = item;
    self.addRemove.removeControl:SetEnabled(true);
    item:SetSelected(true);
  end
  
  item.duration.FocusLost = function(sender,args)
    item.duration:SetWantsKeyEvents(false);
    
    -- update duration
    if (item.duration.startText ~= item.duration:GetText()) then
      -- duration restored to existing value
      if (item.duration.lastValidValue == item.duration:GetText()) then
        if (item.duration.error ~= nil) then item.duration.error:Close() end
        item.duration.error = nil;
        item.duration:SetBackColor(item.duration.error and Menu.errorColor or (self.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor));
        
      -- new duration
      else
        if (self.dummyAdded ~= item and self.DurationUpdated) then
          self:DurationUpdated(self.buff,item.skillDropDown and item.skillDropDown:GetSelection().skillName or item.skillTextBox.lastValidValue,item.duration:GetText(),item);
        end
        
      end
      
    -- hide error
    elseif (item.duration.error ~= nil) then
      item.duration.error:SetVisible(false);
    end
  end
  
  item.SetSelected = function(sender,selected)
    item:SetZOrder(math.max(item:GetZOrder(),selected and 1 or 0));
    item.background:SetBackground("CombatAnalysis/Resources/buff_panel_background"..(selected and "_selected" or "")..".tga");
    
    if (item:GetZOrder() < 2) then
      if (item.skillTextBox ~= nil) then item.skillTextBox:SetBackColor(item.skillTextBox.error and Menu.errorColor or (selected and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor)) end
      if (item.delay ~= nil) then item.delay:SetBackColor(item.delay.error and Menu.errorColor or (selected and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor)) end
      if (item.duration ~= nil) then item.duration:SetBackColor(item.duration.error and Menu.errorColor or (selected and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor)) end
    end
  end
  
  item.MouseDown = function(sender,args)
    KeyManager.TakeFocus(item);
  end
  
  item.MouseEnter = function(sender,args)
    item.mouseIn = true;
    
    item:SetZOrder(2);
    item:SetBackColor(Turbine.UI.Color(0.3,0.3,0.15));
    
    if (item.skillTextBox ~= nil) then item.skillTextBox:SetBackColor(item.skillTextBox.error and Menu.errorColor or Turbine.UI.Color(0.3,0.3,0.15)) end
    if (item.skillDropDown ~= nil) then item.skillDropDown.dropDownBox:SetBackColor(Turbine.UI.Color(0.3,0.3,0.15)) end
    if (item.delay ~= nil) then item.delay:SetBackColor(item.delay.error and Menu.errorColor or Turbine.UI.Color(0.3,0.3,0.15)) end
    if (item.duration ~= nil) then item.duration:SetBackColor(item.duration.error and Menu.errorColor or Turbine.UI.Color(0.3,0.3,0.15)) end
  end
  
  item.MouseClick = function(sender,args)
    if (self.selected) then self.selected:SetSelected(false) end
    self.selected = (self.selected ~= item and item or nil);
    self.addRemove.removeControl:SetEnabled(self.selected ~= nil);
    if (self.selected) then item:SetSelected(true) end
  end
  
  item.MouseLeave = function(sender,args)
    item.mouseIn = false;
    
    item:SetZOrder(self.selected == item and 1 or 0);
    item:SetBackColor(blueBorderColor);
    
    if (item.skillTextBox ~= nil) then item.skillTextBox:SetBackColor(item.skillTextBox.error and Menu.errorColor or (self.selected == item and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor)) end
    if (item.skillDropDown ~= nil) then item.skillDropDown.dropDownBox:SetBackColor(blueBorderColor) end
    if (item.delay ~= nil) then item.delay:SetBackColor(item.delay.error and Menu.errorColor or (self.selected == item  and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor)) end
    if (item.duration ~= nil) then item.duration:SetBackColor(item.duration.error and Menu.errorColor or (self.selected == item  and Turbine.UI.Color(0.3,0.15,0.2) or blueBorderColor)) end
  end
  
  table.insert(self.ownItems,position,item);
  table.insert(self.items,item);
  
  local itemCount = 0;
  for i=1,#self.ownItems do
    local item = self.ownItems[i];
    item.position = i;
    
    itemCount = itemCount + (item.hidden and 0 or 1);
    
    item:SetTop(1+(itemCount-1)*self.itemHeight);
    item.label:SetLeft(itemCount > 9 and 5 or 9);
    item.label:SetWidth(itemCount > 9 and 14 or 10);
    item.label:SetText(itemCount);
  end
  
  self.addRemove.removeControl:SetVisible(itemCount > 1 or (itemCount == 1 and self.panelType ~= "AppliedBy"));
  
  self.startH = self:GetHeight();
  self.targetH = (itemCount == 0 and self.headingHeight or self.headingHeight + 3 + self.controlPadding + itemCount*self.itemHeight);
  
  self.node:UpdateControlHeight(self);
  
  self.critsTitle:SetVisible(self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl"));
  self.delayTitle:SetVisible(self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl") and not self.buff.removalOnly);
  self.durationTitle:SetVisible(self.panelType == "SelectAndDuration" or (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl") and not self.buff.removalOnly));
  
  return item;
end

function BuffInfoPanel:HideItem(item,hidden,dontUpdateLength)
  item.hidden = hidden;
  
  item:SetParent(not hidden and self.panel or nil);
  
  -- update positions of remaining items
  
  local itemCount = 0;
  for index = 1,#self.ownItems do
    local i = self.ownItems[index];
    i.position = index;
    
    itemCount = itemCount + (i.hidden and 0 or 1);
    
    if (not dontUpdateLength) then
      i:SetPosition(1,1+(itemCount-1)*self.itemHeight);
      i.label:SetPosition((itemCount > 9 and 5 or 9),1);
      i.label:SetSize((itemCount > 9 and 14 or 10),20);
      i.label:SetText(itemCount);
    end
  end
    
  if (not dontUpdateLength) then
    self.startH = self:GetHeight();
    self.targetH = (itemCount == 0 and self.headingHeight or self.headingHeight + 3 + self.controlPadding + itemCount*self.itemHeight);
    
    self.node:UpdateControlHeight(self);
  end
  
  self.addRemove.removeControl:SetVisible(itemCount > 1 or (itemCount == 1 and self.panelType ~= "AppliedBy"));
  
  -- update selection status, etc
  
  if (hidden and self.selected == item) then
    item:SetSelected(false);
    self.selected = nil;
    self.addRemove.removeControl:SetEnabled(false);
  end
end

function BuffInfoPanel:UpdateItems(showCritsOnly,showDelay,showDuration)
  for _,item in ipairs(self.ownItems) do
    self.showCrits = showCritsOnly;
    self.showDelay = showDelay;
    self.showDuration = showDuration;
    
    item.critsOnly:SetVisible(showCritsOnly);
    item.delay:SetVisible(showDelay);
    item.duration:SetVisible(showDuration);
  end
  
  local hasItems = false;
  for index = 1,#self.ownItems do
    if (not self.ownItems[index].hidden) then
      hasItems = true;
      break;
    end
  end
  
  self.critsTitle:SetVisible(showCritsOnly and hasItems and (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl")));
  self.delayTitle:SetVisible(showDelay and hasItems and (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl") and not self.buff.removalOnly));
  self.durationTitle:SetVisible(showDuration and hasItems and (self.panelType == "SelectAndDuration" or (self.panelType == "AppliedBy" and (self.buffType == "Debuff" or self.buffType == "CrowdControl") and not self.buff.removalOnly)));
end

--[[
function BuffInfoPanel:Reset(newAppliedByItems)
  -- clear all current items
  local count = 1;
  while (#self.ownItems > 0) do
    self.selected = self.ownItems[1];
    self.addRemove.removeControl:MouseClick({dontRemove = true, removeLast = true});
    count = count + 1;
    if (count > 10) then break end
  end
  -- add all new items
  for _,appliedBy in ipairs(newAppliedByItems) do
    self:InsertItem((self.dummyAdded and #self.ownItems or #self.ownItems+1), appliedBy, appliedBy.skillName, (appliedBy.critsOnly or false), (appliedBy.delay or 0), (appliedBy.duration or 0));
  end
end
]]
