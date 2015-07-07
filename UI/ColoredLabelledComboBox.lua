import "Turbine.UI";

_G.ColoredLabelledComboBox = class(LabelledComboBox);

function ColoredLabelledComboBox:Constructor(window,text,width,textOrientation,textAlignment,itemHeight,fontSize,dropDownWidth,dropDownColor,alignment,boxWidth)
  LabelledComboBox.Constructor(self,window,text,width,textOrientation,textAlignment,itemHeight,fontSize,dropDownWidth,dropDownColor,alignment,boxWidth);
end

function ColoredLabelledComboBox:ItemSelected(index)
  local old;
  
  if (self.selection ~= -1) then
    old = self.listBox:GetItem(self.selection);
    old.label:SetForeColor(old.itemColor);
  end
  
  self.selection = index;
  local item;
  if (index ~= -1) then
    item = self.listBox:GetItem(index);
    item.label:SetForeColor(item.selectionColor);
    self.label:SetText(item.label:GetText());
    
    self.labelColor = item.itemColor;
    self.labelSelectedColor = item.selectionColor;
    
    self.text:SetForeColor(item.textLabelColor);
    self.label:SetForeColor(item.itemColor);
    self.label:SetOutlineColor(item.highlightColor);
    self.dropDownBox:SetBackColor(item.dropDownColor);
    self.dropDownWindow:SetBackColor(item.dropDownColor);
  else
    self.label:SetText("");
  end
  
  self.listBox:SetSelectedIndex(index);
  self:CloseDropDown();
  
  if (index ~= -1 and self.SelectionChanged ~= nil) then
    self:SelectionChanged(item.value, old ~= nil and old.value);
  end
end

function ColoredLabelledComboBox:AddItem(text,value,position,textLabelColor,dropDownColor,itemColor,selectionColor,highlightColor,tooltipText)
  local listItem = Turbine.UI.Control();
  listItem:SetSize(self.text and self.boxWidth or self.width, self.itemHeight);
  listItem.value = value;
  
  listItem.textLabelColor = (textLabelColor or control2LightColor);
  listItem.dropDownColor = (dropDownColor or self.dropDownColor);
  listItem.itemColor = (itemColor or LabelledComboBox.ItemColor);
  listItem.selectionColor = (selectionColor or LabelledComboBox.SelectionColor);
  listItem.highlightColor = (highlightColor or LabelledComboBox.HighlightColor);
  
  listItem.label = Turbine.UI.Label();
  listItem.label:SetParent(listItem);
  listItem.label:SetPosition(3,0);
  listItem.label:SetSize(self.text and self.boxWidth or self.width, self.itemHeight);
  listItem.label:SetTextAlignment(self.alignment);
  listItem.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  listItem.label:SetForeColor(listItem.itemColor);
  listItem.label:SetOutlineColor(listItem.highlightColor);
  listItem.label:SetText(text);
  listItem.label:SetMultiline(false);
  listItem.label:SetMouseVisible(false);
  
  listItem.MouseEnter = function(sender, args)
    sender.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
    sender.label:SetForeColor(listItem.itemColor);
    sender.label:SetText(sender.label:GetText());
  end
  listItem.MouseLeave = function(sender, args)
    sender.label:SetFontStyle(Turbine.UI.FontStyle.None);
    if (self.listBox:IndexOfItem(sender) == self.selection) then
      sender.label:SetForeColor(listItem.selectionColor);
    end
    sender.label:SetText(sender.label:GetText());
  end
  listItem.MouseClick = function(sender, args)
    if (args.Button == Turbine.UI.MouseButton.Left) then
      self:ItemSelected(self.listBox:IndexOfItem(sender));
    end
  end
  
  if (tooltipText ~= nil) then
    listItem.tooltipText = tooltipText;
    TooltipManager.SetTooltip(listItem,listItem.tooltipText,TooltipStyle.LOTRO,500);
  end
  
  if (position ~= nil) then
    self.listBox:InsertItem(position,listItem);
    if (self.selection >= position) then self.selection = self.selection+1 end
  else
    self.listBox:AddItem(listItem);
  end
end

function ColoredLabelledComboBox:UpdateItem(value,textLabelColor,dropDownColor,itemColor,selectionColor,highlightColor)
  for i = 1, self.listBox:GetItemCount() do
    local item = self.listBox:GetItem(i);
    if (item.value == value) then
      
      item.textLabelColor = (textLabelColor or control2LightColor);
      item.dropDownColor = (dropDownColor or LabelledComboBox.DisabledColor);
      item.itemColor = (itemColor or LabelledComboBox.ItemColor);
      item.selectionColor = (selectionColor or LabelledComboBox.SelectionColor);
      item.highlightColor = (highlightColor or LabelledComboBox.HighlightColor);
      
      item.label:SetForeColor(item.itemColor);
      item.label:SetOutlineColor(item.highlightColor);
      
      item.MouseEnter = function(sender, args)
        sender.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
        sender.label:SetForeColor(item.itemColor);
        sender.label:SetText(sender.label:GetText());
      end
      item.MouseLeave = function(sender, args)
        sender.label:SetFontStyle(Turbine.UI.FontStyle.None);
        if (self.listBox:IndexOfItem(sender) == self.selection) then
          sender.label:SetForeColor(item.selectionColor);
        end
        sender.label:SetText(sender.label:GetText());
      end
      -- clear the mouseup function since we may be resetting the tooltip
      item.MouseUp = function(sender,args) end
      
      if (item.tooltipText ~= nil) then
        TooltipManager.SetTooltip(item,item.tooltipText,TooltipStyle.LOTRO,500);
      end
      
      if (self.selection == i) then
        self.labelColor = item.itemColor;
        self.labelSelectedColor = item.selectionColor;
        
        self.text:SetForeColor(item.textLabelColor);
        self.label:SetForeColor(item.itemColor);
        self.label:SetOutlineColor(item.highlightColor);
        self.dropDownBox:SetBackColor(item.dropDownColor);
        self.dropDownWindow:SetBackColor(item.dropDownColor);
      end
      
      return;
    end
  end
end
