import "Turbine.UI";

_G.LabelledComboBox = class(Turbine.UI.Control);

-- configurable properties
LabelledComboBox.height = 25;

LabelledComboBox.HighlightColor = Turbine.UI.Color(232/255, 175/255, 72/255);
LabelledComboBox.SelectionColor = Turbine.UI.Color(203/255, 195/255, 52/255);
LabelledComboBox.ItemColor = Turbine.UI.Color(245/255, 222/255, 147/255);
LabelledComboBox.DisabledColor = Turbine.UI.Color(162/255, 162/255, 162/255);
LabelledComboBox.BlackColor = Turbine.UI.Color(1, 0, 0, 0);

LabelledComboBox.TextOnLeft = 1;
LabelledComboBox.TextOnRight = 2;

function LabelledComboBox:Constructor(window,text,width,textOrientation,textAlignment,itemHeight,fontSize,dropDownBorderSize,dropDownColor,alignment,boxWidth)
    Turbine.UI.Control.Constructor(self);
    
    self.window = window;
    self.alignment = alignment or Turbine.UI.ContentAlignment.MiddleCenter;
    
    self.width = (width or 160);
    self.boxWidth = (boxWidth or 160);
    self.itemHeight = (itemHeight or 20);
    self.font = (fontSize == "13" and Turbine.UI.Lotro.Font.TrajanPro13 or Turbine.UI.Lotro.Font.TrajanPro14);
    
    self.dropDownBorderSize = (dropDownBorderSize or 2);
    self.dropDownColor = (dropDownColor or LabelledComboBox.DisabledColor);
    
    self:SetSize(width,self.itemHeight);
    
    -- state
    self.open = false;
    self.mouse = false;
    self.selection = -1;
    self.dropDownHeight = 0;
    
    self.textOrientation = (textOrientation or LabelledComboBox.TextOnRight);
    
    self.labelColor = LabelledComboBox.ItemColor;
    self.labelSelectedColor = LabelledComboBox.SelectionColor;
    
    self:SetMouseVisible(false);
    
    -- text label
    if (text ~= nil) then
      self.text = Turbine.UI.Label();
      self.text:SetParent(self);
      self.text:SetSize(width - 170, 16);
      self.text:SetText(text);
      self.text:SetFont(self.font);
      self.text:SetForeColor(control2LightColor);
      self.text:SetTextAlignment(textAlignment or Turbine.UI.ContentAlignment.MiddleCenter);
      self.text:SetMultiline(false);
      self.text.MouseDown = function(sender,args)
        KeyManager.TakeFocus();
      end
    end
    
    self.dropDownBox = Turbine.UI.Control();
    self.dropDownBox:SetParent(self);
    self.dropDownBox:SetSize((self.text and self.boxWidth or self.width),self.itemHeight);
    self.dropDownBox:SetBackColor(self.dropDownColor);
    
    -- label background
    self.labelBackground = Turbine.UI.Control();
    self.labelBackground:SetParent(self.dropDownBox);
    self.labelBackground:SetPosition(self.dropDownBorderSize,self.dropDownBorderSize);
    self.labelBackground:SetSize((self.text and self.boxWidth or self.width) - 2*self.dropDownBorderSize,self.itemHeight - 2*self.dropDownBorderSize);
    self.labelBackground:SetBackColor(LabelledComboBox.BlackColor);
    self.labelBackground:SetMouseVisible(false);
    
    -- drop down label
    self.label = Turbine.UI.Label();
    self.label:SetParent(self.dropDownBox);
    self.label:SetPosition(self.dropDownBorderSize + 3,self.dropDownBorderSize);
    self.label:SetSize((self.text and self.boxWidth or self.width) - 2*self.dropDownBorderSize - 6,self.itemHeight - 2*self.dropDownBorderSize);
    self.label:SetFont(self.font);
    self.label:SetForeColor(LabelledComboBox.ItemColor);
    self.label:SetBackColor(LabelledComboBox.BlackColor);
    self.label:SetOutlineColor(LabelledComboBox.HighlightColor);
    self.label:SetTextAlignment(self.alignment);
    self.label:SetMultiline(false);
    self.label:SetMouseVisible(false);
    
    -- arrow
    self.arrow = Turbine.UI.Control();
    self.arrow:SetParent(self.dropDownBox);
    self.arrow:SetPosition((self.text and self.boxWidth or self.width) - self.dropDownBorderSize - 16, self.dropDownBorderSize + ((self.itemHeight - 2*self.dropDownBorderSize - 16) / 2));
    self.arrow:SetSize(16,16);
    self.arrow:SetZOrder(20);
    self.arrow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);    
    self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed.tga");
    self.arrow:SetMouseVisible(false);
    
    -- drop down window
    self.dropDownWindow = Turbine.UI.Window();
    self.dropDownWindow:SetBackColor(self.dropDownColor);
    self.dropDownWindow:SetZOrder(8);
    self.dropDownWindow:SetVisible(false);
    self.dropDownWindow.Deactivated = function(sender, args)
    	if (not self.mouse) then
        self:CloseDropDown();
      end
    end
    
    -- list scroll bar        
    self.scrollBar = Turbine.UI.Lotro.ScrollBar();
    self.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.scrollBar:SetParent(self.dropDownWindow);
    self.scrollBar:SetBackColor(LabelledComboBox.BlackColor);

    -- list to contain the drop down items
    self.listBox = Turbine.UI.ListBox();
    self.listBox:SetParent(self.dropDownWindow);
    self.listBox:SetOrientation(Turbine.UI.Orientation.Horizontal);
    self.listBox:SetVerticalScrollBar(self.scrollBar);
    self.listBox:SetMaxItemsPerLine(1);
    self.listBox:SetMouseVisible(false);
    self.listBox:SetPosition(2, 2);
    self.listBox:SetBackColor(LabelledComboBox.BlackColor);
    
    -- mouse events
    
    self.dropDownBox.MouseEnter = function(sender,args)
      self.mouse = true;
      
      if (not self:IsEnabled()) then return end
      
      self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
      self.label:SetForeColor(self.labelColor);
      self.label:SetText(self.label:GetText());

      self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_"..(self.open and "open_rollover" or "closed_rollover")..".tga");
    end

    self.dropDownBox.MouseLeave = function(sender,args)
      self.mouse = false;
      
      if (not self:IsEnabled()) then return end
      
      self.label:SetFontStyle(Turbine.UI.FontStyle.None);
      if (self.open) then self.label:SetForeColor(self.labelSelectedColor) end
      self.label:SetText(self.label:GetText());
      
      self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_"..(self.open and "open" or "closed")..".tga");
    end
    
    self.dropDownBox.MouseDown = function(sender,args)
      WindowManager.MouseWasPressed(self.window,self.open);
      KeyManager.TakeFocus();
      
      if (self.open) then
        self.dropDownWindow:Activate();
      end
    end

    self.dropDownBox.MouseClick = function(sender,args)
      if (not self:IsEnabled() or args.Button ~= Turbine.UI.MouseButton.Left) then return end
      
      if (self.open) then
        self:CloseDropDown();
      else
        if openComboBox ~= nil then
          openComboBox:CloseDropDown();
        end
        
        self:OpenDropDown();
      end
    end
    
    self:Layout();
end

function LabelledComboBox:Layout()
  local w = self:GetWidth();
  
  if (self.textOrientation == LabelledComboBox.TextOnRight) then
    if (self.text) then self.text:SetPosition(self.boxWidth+10,2) end
  else
    if (self.text) then self.text:SetPosition(0,2) end
    self.dropDownBox:SetLeft(w - (self.text and self.boxWidth or self.width));
  end
end

function LabelledComboBox:ItemSelected(index)
    local old;
    
    if (self.selection ~= -1) then
        old = self.listBox:GetItem(self.selection);
        old.label:SetForeColor(LabelledComboBox.ItemColor);
    end
    
    self.selection = index;
    local item;
    if (index ~= -1) then
      item = self.listBox:GetItem(index);
      item.label:SetForeColor(LabelledComboBox.SelectionColor);
      self.label:SetText(item.label:GetText());
    else
      self.label:SetText("");
    end
    
    self.listBox:SetSelectedIndex(index);
    self:CloseDropDown();
    
    if (index ~= -1 and self.SelectionChanged ~= nil) then
      self:SelectionChanged(item.value,(old ~= nil and old.value or nil));
    end
end

function LabelledComboBox:AddItem(text, value, position)
    local listItem = Turbine.UI.Control();
    listItem:SetSize(self.text and self.boxWidth or self.width, self.itemHeight);
    
    listItem.label = Turbine.UI.Label();
    listItem.label:SetParent(listItem);
    listItem.label:SetPosition(3,0);
    listItem.label:SetSize(self.text and self.boxWidth or self.width, self.itemHeight);
    listItem.label:SetTextAlignment(self.alignment);
    listItem.label:SetForeColor(LabelledComboBox.ItemColor);
    listItem.label:SetFont(self.font);
    listItem.label:SetOutlineColor(LabelledComboBox.HighlightColor);
    listItem.label:SetText(text);
    listItem.label:SetMultiline(false);
    listItem.label:SetMouseVisible(false);
    
    listItem.MouseEnter = function(sender, args)
        sender.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
        sender.label:SetForeColor(LabelledComboBox.ItemColor);
        sender.label:SetText(sender.label:GetText());
    end
    listItem.MouseLeave = function(sender, args)
        sender.label:SetFontStyle(Turbine.UI.FontStyle.None);
        if (self.listBox:IndexOfItem(sender) == self.selection) then
            sender.label:SetForeColor(LabelledComboBox.SelectionColor);
        end
        sender.label:SetText(sender.label:GetText());
    end
    listItem.MouseClick = function(sender, args)
        if (args.Button == Turbine.UI.MouseButton.Left) then
            self:ItemSelected(self.listBox:IndexOfItem(sender));
        end
    end
    listItem.value = value;
    
    if (position ~= nil) then
      self.listBox:InsertItem(position,listItem);
      if (self.selection >= position) then self.selection = self.selection+1 end
    else
      self.listBox:AddItem(listItem);
    end
end

function LabelledComboBox:RemoveItem(value)
    for i = 1, self.listBox:GetItemCount() do
        local item = self.listBox:GetItem(i);
        if (item.value == value) then
            item:SetVisible(false);
            self.listBox:RemoveItemAt(i);

            -- if the removed item is the selection update it
            if (self.selection == i) then
                self.selection = -1;
                if (self.listBox:GetItemCount() > 0) then
                    self:ItemSelected(math.min(self.listBox:GetItemCount(),i));
                else
                    self:ItemSelected(-1);
                end
            elseif (self.selection > i) then
              self.selection = self.selection - 1;
            end
            
            return i;
        end
    end
end

function LabelledComboBox:Clear()
  while (self.listBox:GetItemCount() > 0) do
    self:RemoveItem(self.listBox:GetItem(1).value);
  end
end

function LabelledComboBox:SetSelection(value)
    for i = 1, self.listBox:GetItemCount() do
        local item = self.listBox:GetItem(i);
        if (item.value == value) then
            self:ItemSelected(i);
            return;
        end
    end
    
    self:ItemSelected(-1);
end

function LabelledComboBox:GetSelection()
    if (self.selection == -1) then
        return nil;
    else
        local item = self.listBox:GetItem(self.selection);
        return item.value;
    end
end

function LabelledComboBox:UpdateSelectionText(text)
    if (self.selection ~= -1) then
        local item = self.listBox:GetItem(self.selection);
        item.label:SetText(text);
        self.label:SetText(text);
    end
end

function LabelledComboBox:GetItemCount()
    return self.listBox:GetItemCount();
end

function LabelledComboBox:GetItem(index)
    local item = self.listBox:GetItem(index);
    return item.value;
end

function LabelledComboBox:GetItemWithValue(value)
    for i = 1, self.listBox:GetItemCount() do
        local item = self.listBox:GetItem(i);
        if (item.value == value) then
            return item;
        end
    end
end

function LabelledComboBox:SetDropDownHeight(height)
    self.dropDownHeight = height;
end

function LabelledComboBox:SetEnabled(enabled)
    Turbine.UI.Control.SetEnabled(self, enabled);
    if (enabled) then
        self.label:SetForeColor(self.labelColor);
        self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed.tga");
    else
        self:CloseDropDown();
        self.label:SetForeColor(LabelledComboBox.DisabledColor);
        self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed_ghosted.tga");
    end
end

function LabelledComboBox:OpenDropDown()
    local itemCount = self.listBox:GetItemCount();
    if ((itemCount > 0) and not (self.open)) then
        self.open = true;
        self.label:SetForeColor(self.labelSelectedColor);
        self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_open_rollover.tga");
        local width,height = self:GetSize();
        
        -- max size
        local maxItems = itemCount;
        local scrollSize = 0;
        if (maxItems > 10) then
            maxItems = 10;
            scrollSize = 10;
        end

        -- list item sizes
        local listHeight = 0;
        for i = 1, self.listBox:GetItemCount() do
            local item = self.listBox:GetItem(i);
            item:SetWidth((self.text and self.boxWidth or self.width) + 10 - 14);
            item.label:SetWidth((self.text and self.boxWidth or self.width) + 10 - 14 - 6);
            if (i <= maxItems) then
                listHeight = listHeight + item:GetHeight();
            end
        end
        
        -- check for a set drop down size
        if (self.dropDownHeight > 0) then
            listHeight = self.dropDownHeight;
        end
        
        -- window size
        self.listBox:SetSize((self.text and self.boxWidth or self.width) + 10 - 4 - scrollSize, listHeight);
        self.dropDownWindow:SetSize((self.text and self.boxWidth or self.width) + 10, listHeight + 4);
        
        -- scrollbar
        self.scrollBar:SetSize(10, listHeight);
        self.scrollBar:SetPosition((self.text and self.boxWidth or self.width) + 10 - 12, 2);

        -- position
        local x,y = self:GetParent():PointToScreen(self:GetPosition());
        x,y = WindowManager.ValidatePosition(x+(self.textOrientation == LabelledComboBox.TextOnRight and 0 or width-(self.text and self.boxWidth or self.width)),y+height+3,self.dropDownWindow:GetWidth(),self.dropDownWindow:GetHeight());
        self.dropDownWindow:SetPosition(x,y);
        
        self.dropDownWindow:SetVisible(true);
        self.dropDownWindow:Activate();
        self.dropDownWindow:Focus();
        
        if (self.DropDownOpened) then
          self:DropDownOpened();
        end
    end
end

function LabelledComboBox:CloseDropDown()
    if (self.open) then
        self.open = false;
        self.dropDownWindow:SetVisible(false);
        self.label:SetForeColor(self.labelColor);
        self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed_rollover.tga");
    end
end
