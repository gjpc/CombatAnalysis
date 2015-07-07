
--[[

A Combat Analysis Combo Box is a standard combo box that
animates downwards on selection, and follows the Combat
Analysis look and feel.

The first item in the list ("totals") is always fixed
at the top.

A combo box consists of one or more instances so that
multiple "linked" combo boxes can be constructed
(ie: this is a more explicit/limited alternative to
using the observer pattern).

A combo box can take a max size parameter which will result
in further calls to AddItem replacing old elements once the
max number of elements have been added.

]]--

_G.CombatAnalysisComboBox = class();

-- some configurable properties
CombatAnalysisComboBox.height = CombatAnalysisWindow.titleBarHeight;
CombatAnalysisComboBox.maxListSize = 9;
CombatAnalysisComboBox.animationDuration = 0.1;

CombatAnalysisComboBox.topColor = Turbine.UI.Color(0.6,0.6,0.85);
CombatAnalysisComboBox.selectionColor = Turbine.UI.Color(0.9,0.85,0.6);
CombatAnalysisComboBox.topItemColor = Turbine.UI.Color(0.5,0.25,0.6);
CombatAnalysisComboBox.itemColor = Turbine.UI.Color(0.5,0.5,0.2);
CombatAnalysisComboBox.topBackColor = Turbine.UI.Color(0.9,0.15,0.15,0.21);
CombatAnalysisComboBox.topHighlightColor = Turbine.UI.Color(0.55,0.35,0.65);

function CombatAnalysisComboBox:Constructor(noInstances,backColor,highlightColor,listener,maxElements,maxTopElements)
	self.instances = {}
	
	self.listener = listener;
	self.maxElements = maxElements;
	self.maxTopElements = maxTopElements;
	
	for i=1,noInstances do
		table.insert(self.instances,CombatAnalysisComboBoxInstance(self,backColor,highlightColor));
	end
end

-- acquire a particular instance of the drop down box (eg: for adding to UI)
function CombatAnalysisComboBox:GetInstance(index)
	return self.instances[index];
end



function CombatAnalysisComboBox:SetTotals(text,value)
	local selectionChanged = false;
	for _,instance in ipairs(self.instances) do
		selectionChanged = instance:SetTotals(text,value);
	end
	
	if (selectionChanged and self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:AddItem(text,value,top)
	local selectionChanged = false;
	for _,instance in ipairs(self.instances) do
		selectionChanged = instance:AddItem(text,value,top);
	end
	
	if (selectionChanged and self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:RemoveItem(value)
	local selectionChanged = false;
	for _,instance in ipairs(self.instances) do
		selectionChanged = instance:RemoveItem(value);
	end
	
	if (selectionChanged and self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:SetMaxElements(maxElements)
  if (maxElements <= 1) then return end
  
	self.maxElements = maxElements;
  
  for _,instance in ipairs(self.instances) do
    local removeIndex = instance.topElements+1;
    
    while ((instance.listBox:GetItemCount()-instance.topElements) > self.maxElements) do
      if (instance.selected == instance.listBox:GetItem(removeIndex)) then
        instance:SetSelected(instance.firstElement);
      end
      
      instance.listBox:RemoveItemAt(removeIndex);
    end
  end
end

function CombatAnalysisComboBox:SetMaxTopElements(maxTopElements)
  if (maxTopElements <= 1) then return end
  
	self.maxTopElements = maxTopElements;
  
  for _,instance in ipairs(self.instances) do
    local removeIndex = 1;
    
    while (instance.topElements > self.maxTopElements) do
      if (instance.selected == instance.listBox:GetItem(removeIndex)) then
        instance:SetSelected(instance.firstElement);
      end
      
      instance.listBox:RemoveItemAt(removeIndex);
    end
  end
end

function CombatAnalysisComboBox:Clear()
	for _,instance in ipairs(self.instances) do
		instance:Clear();
	end
end

function CombatAnalysisComboBox:SetLastItemName(name)
	for _,instance in ipairs(self.instances) do
		instance:SetLastItemName(name);
	end
end

function CombatAnalysisComboBox:SetSelectedIndex(index,close)
	for _,instance in ipairs(self.instances) do
		instance:SetSelectedIndex(index,close);
	end
	
	if (self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:SelectTotals()
	for _,instance in ipairs(self.instances) do
		instance:SelectTotals();
	end
	
	if (self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:SelectLastTopItem()
	for _,instance in ipairs(self.instances) do
		instance:SelectLastTopItem();
	end
	
	if (self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:SelectLastItem()
	for _,instance in ipairs(self.instances) do
		instance:SelectLastItem();
	end
	
	if (self.listener ~= nil) then
		self.listener:ComboBoxChanged(self.instances[1].selected.value);
	end
end

function CombatAnalysisComboBox:GetLowerListTitles()
	return self.instances[1]:GetLowerListTitles();
end

function CombatAnalysisComboBox:GetValueAtLowerIndex(index)
	return self.instances[1]:GetValueAtLowerIndex(index);
end

function CombatAnalysisComboBox:GetSelectedText()
	return self.instances[1]:GetSelectedText();
end

function CombatAnalysisComboBox:GetSelectedValue()
	return self.instances[1]:GetSelectedValue();
end






-- instance class

_G.CombatAnalysisComboBoxInstance = class(Turbine.UI.Control);

function CombatAnalysisComboBoxInstance:Constructor(comboBoxGroup,backColor,highlightColor)
	Turbine.UI.Control.Constructor(self);
	
	self.open = false;
  self.mouse = false;
	self.selected = nil;
	
	self.topElements = 0;
	
	self.comboBoxGroup = comboBoxGroup;
	self.highlightColor = highlightColor;
	
	self.backColor = backColor;
	
	self:SetBackColor(backColor);
	
	-- text label
	self.labelBackground = Turbine.UI.Control();
	self.labelBackground:SetParent(self);
	self.labelBackground:SetHeight(CombatAnalysisWindow.titleBarHeight);
	self.labelBackground:SetMouseVisible(false);
	
	-- text label
	self.label = Turbine.UI.Label();
	self.label:SetParent(self);
	self.label:SetLeft(2*CombatAnalysisWindow.border);
	self.label:SetHeight(CombatAnalysisWindow.titleBarHeight);
	self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.label:SetMultiline(false);
	self.label:SetMouseVisible(false);
	self.label:SetForeColor(CombatAnalysisComboBox.selectionColor);
	self.label:SetOutlineColor(highlightColor);
	
	-- arrow
	self.arrow = Turbine.UI.Control();
	self.arrow:SetParent(self);
	self.arrow:SetSize(16,16);
	self.arrow:SetZOrder(1);
	self.arrow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed_Ghosted.tga");
	self.arrow:SetMouseVisible(false);
	
	-- drop down window
	self.dropDownWindow = Turbine.UI.Window();
	self.dropDownWindow:SetBackColor(borderColor);
	self.dropDownWindow.SetVisible = function(sender,visible)
		Turbine.UI.Window.SetVisible(self.dropDownWindow,visible);
    
    if (visible) then
      self.dropDownWindow:Activate();
      self.dropDownWindow:Focus();
    end
	end
	self.dropDownWindow.Update = function()
		-- animate combo box drop down
		local diff = Turbine.Engine.GetGameTime()-self.dropDownWindow.start;
		if diff >= CombatAnalysisComboBox.animationDuration then
			diff = CombatAnalysisComboBox.animationDuration;
			self.dropDownWindow:SetWantsUpdates(false);
		end
		
		local currentH = self.dropDownWindow.targetH*(diff/CombatAnalysisComboBox.animationDuration);
		if (not self.dropDownWindow.animateDown) then
			self.dropDownWindow:SetTop(self.dropDownWindow.targetY+(self.dropDownWindow.targetH-currentH));
		end
		self.dropDownWindow:SetHeight(currentH);
	end
  self.dropDownWindow.Deactivated = function(sender,args)
    if (not self.mouse) then
      self:CloseDropDown();
    end
  end
	
	-- drop down window background
	self.dropDownBackground = Turbine.UI.Control();
	self.dropDownBackground:SetParent(self.dropDownWindow);
	self.dropDownBackground:SetPosition(CombatAnalysisWindow.border,CombatAnalysisWindow.border);
	self.dropDownBackground:SetBackColor(Turbine.UI.Color(0.87,backColor.R,backColor.G,backColor.B));
	
	-- dotted line separating the first element from the rest of the drop down list
	self.dottedBorder = Turbine.UI.Control();
	self.dottedBorder:SetParent(self.dropDownWindow);
	self.dottedBorder:SetZOrder(2);
	self.dottedBorder:SetPosition(CombatAnalysisWindow.border,CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight);
	self.dottedBorder:SetHeight(2);
	self.dottedBorder:SetBackground("CombatAnalysis/Resources/dotted_line.tga");
	self.dottedBorder:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- dotted line separating the top elements from the rest of the drop down list
	self.dottedBorderTop = Turbine.UI.Control();
	self.dottedBorderTop:SetZOrder(2);
	self.dottedBorderTop:SetHeight(2);
	self.dottedBorderTop:SetBackground("CombatAnalysis/Resources/dotted_line.tga");
	self.dottedBorderTop:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- list vertical scroll bar        
	self.scrollBar = Turbine.UI.Lotro.ScrollBar();
	self.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.scrollBar:SetParent(self.dropDownWindow);
	self.scrollBar:SetZOrder(2);
	
	-- list box to contain the drop down items
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self.dropDownBackground);
	self.listBox:SetPosition(0,CombatAnalysisWindow.titleBarHeight+2);
	self.listBox:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.listBox:SetVerticalScrollBar(self.scrollBar);
	self.listBox:SetMaxItemsPerLine(1);
	self.listBox:SetMouseVisible(false);
end

function CombatAnalysisComboBoxInstance:Layout()
	local w,h = self:GetSize();
	
	self.labelBackground:SetWidth(w);
	self.label:SetWidth(w-3*CombatAnalysisWindow.border-16);
	self.arrow:SetPosition(w-16,((h-16)/2));
end

-- mouse events

function CombatAnalysisComboBoxInstance:MouseEnter(args)
  self.mouse = true;
  
	if (self.listBox:GetItemCount() == 0) then return end
	
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	--hack to ensure text UI update
	local text = self.label:GetText();
	self.label:SetText(text or "");
	
	self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_"..(self.open and "open_rollover" or "closed_rollover")..".tga");
end

function CombatAnalysisComboBoxInstance:MouseLeave(args)
  self.mouse = false;
  
	if (self.listBox:GetItemCount() == 0) then return end
	
	self.label:SetFontStyle(Turbine.UI.FontStyle.None);
	--hack to ensure text UI update
	local text = self.label:GetText();
	self.label:SetText(text or "");
	
	self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_"..(self.open and "open" or "closed")..".tga");
end

function CombatAnalysisComboBoxInstance:MouseDown(args)
	WindowManager.MouseWasPressed(self,self.open);
	if (self.open) then
		self.dropDownWindow:Activate();
	end
end

function CombatAnalysisComboBoxInstance:MouseClick(args)
	if (args.Button ~= Turbine.UI.MouseButton.Left) then return end
	
	-- this combo box is open, so close it
	if (self.open) then
		self:CloseDropDown();
	-- this combo box is closed, so open it
	else
		if openComboBox ~= nil then
			openComboBox:CloseDropDown();
		end
		
		if self:GetItemCount() > 0 then
			self:OpenDropDown();
		end
	end
end

function CombatAnalysisComboBoxInstance:MouseDoubleClick(args)
	self:MouseClick(args);
end

-- open/close drop down menu

function CombatAnalysisComboBoxInstance:OpenDropDown()
	local itemCount = self.listBox:GetItemCount();
	if ((itemCount == 0) or self.open) then return end
	
	self.open = true;
	self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_open_rollover.tga");
	
	local x,y = WindowManager.GetPositionOnScreen(self);
	local w = self:GetWidth();
	w = w + 2*CombatAnalysisWindow.border+12;
	
	-- determine no items, and if scrollbar is necessary
	local maxItems = itemCount-((self.topElements > 0 and itemCount-self.topElements > 0) and 1 or 0);
	local scrollSize = 0;
	if (maxItems > CombatAnalysisComboBox.maxListSize) then
		maxItems = CombatAnalysisComboBox.maxListSize;
		scrollSize = 12;
	end

	-- update the width of each list item
	self.firstElement:SetWidth(w-2*CombatAnalysisWindow.border);
	self.firstElement.label:SetWidth(w-6*CombatAnalysisWindow.border);
	local listHeight = self.firstElement:GetHeight()+2;
	for i=1,self.listBox:GetItemCount() do
		local item = self.listBox:GetItem(i);
		item:SetWidth(w-2*CombatAnalysisWindow.border);
		
		if (item.label ~= nil) then
			item.label:SetWidth(w-6*CombatAnalysisWindow.border);
		else
			maxItems = maxItems + 1;
		end
		
		if (i <= maxItems) then listHeight = listHeight + item:GetHeight() end
	end
	
	-- window position and size
	self.dropDownWindow.targetH = listHeight+2*CombatAnalysisWindow.border;
	self.dropDownWindow.animateDown = true;
	
	self.dropDownWindow.targetY = y+CombatAnalysisWindow.titleBarHeight+2*CombatAnalysisWindow.border;
	if (self.dropDownWindow.targetY+self.dropDownWindow.targetH-CombatAnalysisWindow.border > Turbine.UI.Display.GetHeight()) then
		self.dropDownWindow.targetY = self.dropDownWindow.targetY-CombatAnalysisWindow.titleBarHeight-4*CombatAnalysisWindow.border-self.dropDownWindow.targetH;
		self.dropDownWindow.animateDown = false;
	end
	
	self.dropDownWindow:SetPosition(WindowManager.ValidatePosition(x-CombatAnalysisWindow.border-6,self.dropDownWindow.targetY,w,self.dropDownWindow.targetH,CombatAnalysisWindow.border));
	self.dropDownWindow:SetWidth(w);
	self.dropDownBackground:SetSize(w-2*CombatAnalysisWindow.border,self.dropDownWindow.targetH-2*CombatAnalysisWindow.border);
	self.dottedBorder:SetWidth(w-2*CombatAnalysisWindow.border);
	self.dottedBorderTop:SetWidth(w-2*CombatAnalysisWindow.border);
	self.listBox:SetSize(w-2*CombatAnalysisWindow.border,listHeight-2-self.firstElement:GetHeight());
	
	self.dropDownWindow.start = Turbine.Engine.GetGameTime();
	self.dropDownWindow:SetWantsUpdates(true);
	
	-- scrollbar
	self.scrollBar:SetSize(10,listHeight-2-CombatAnalysisWindow.titleBarHeight-CombatAnalysisWindow.border-1);
	self.scrollBar:SetPosition(w-scrollSize-4,2*CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight+2);
	
	self.dropDownWindow:SetVisible(true);
end

function CombatAnalysisComboBoxInstance:LayoutDropDown()
	if (not self.open) then return end
	
	local itemCount = self.listBox:GetItemCount();
	
	local x,y = WindowManager.GetPositionOnScreen(self);
	local w = self:GetWidth();
	w = w + 2*CombatAnalysisWindow.border+12;
	
	local maxItems = itemCount-((self.topElements > 0 and itemCount-self.topElements > 0) and 1 or 0);
	local scrollSize = 0;
	
	local listHeight = self.firstElement:GetHeight()+2;
	if (maxItems > CombatAnalysisComboBox.maxListSize) then
		maxItems = CombatAnalysisComboBox.maxListSize;
		scrollSize = 12;
	end
	
	for i=1,self.listBox:GetItemCount() do
		local item = self.listBox:GetItem(i);
		if (item.label == nil) then maxItems = maxItems + 1 end
		if (i <= maxItems) then listHeight = listHeight + item:GetHeight() end
	end
	
	self.dropDownWindow.targetH = listHeight+2*CombatAnalysisWindow.border;
	self.dropDownWindow.animateDown = true;
	
	self.dropDownWindow.targetY = y+CombatAnalysisWindow.titleBarHeight+2*CombatAnalysisWindow.border;
	if (self.dropDownWindow.targetY+self.dropDownWindow.targetH-CombatAnalysisWindow.border > Turbine.UI.Display.GetHeight()) then
		self.dropDownWindow.targetY = self.dropDownWindow.targetY-CombatAnalysisWindow.titleBarHeight-4*CombatAnalysisWindow.border-self.dropDownWindow.targetH;
		self.dropDownWindow.animateDown = false;
	end
	
	self.dropDownWindow:SetPosition(WindowManager.ValidatePosition(x-CombatAnalysisWindow.border-6,self.dropDownWindow.targetY,w,self.dropDownWindow.targetH,CombatAnalysisWindow.border));
	if (not self:GetWantsUpdates()) then
		self.dropDownWindow:SetHeight(self.dropDownWindow.targetH);
	end
	
	self.dropDownBackground:SetHeight(self.dropDownWindow.targetH-2*CombatAnalysisWindow.border);
	self.listBox:SetHeight(listHeight-2-self.firstElement:GetHeight());
	
	-- scrollbar
	self.scrollBar:SetHeight(listHeight-2-CombatAnalysisWindow.titleBarHeight-CombatAnalysisWindow.border-1);
	self.scrollBar:SetLeft(w-scrollSize-4);
end

function CombatAnalysisComboBoxInstance:CloseDropDown()
	if (not self.open) then return end
	
	openComboBox = nil;
	self.open = false;
	
	self.dropDownWindow:SetVisible(false);
	self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed_rollover.tga");
end

-- add/remove items

function CombatAnalysisComboBoxInstance:CreateItem(text,value,top)
	local listItem = Turbine.UI.Control();
	listItem:SetZOrder(1);
	listItem:SetSize(self:GetWidth()+4*CombatAnalysisWindow.border,CombatAnalysisWindow.titleBarHeight);
	if (top) then listItem:SetBackColor(CombatAnalysisComboBox.topBackColor) end
	
	listItem.label = Turbine.UI.Label();
	listItem.label:SetParent(listItem);
	listItem.label:SetLeft(2*CombatAnalysisWindow.border);
	listItem.label:SetSize(self:GetWidth(),CombatAnalysisWindow.titleBarHeight);
	listItem.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	listItem.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	listItem.label:SetForeColor((top and CombatAnalysisComboBox.topColor or CombatAnalysisComboBox.selectionColor));
	listItem.label:SetOutlineColor((top and CombatAnalysisComboBox.topHighlightColor or self.highlightColor));
	listItem.label:SetMultiline(false);
	listItem.label:SetMouseVisible(false);
	listItem.label:SetText(text);
	
	listItem.MouseEnter = function(sender, args)
		if (sender ~= self.selected) then
			sender.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
		end
		-- hack to ensure text UI update
		local text = sender.label:GetText();
		sender.label:SetText(text or "");
	end
	listItem.MouseLeave = function(sender, args)
		sender.label:SetFontStyle(Turbine.UI.FontStyle.None);
		-- hack to ensure text UI update
		local text = sender.label:GetText();
		sender.label:SetText(text or "");
	end
	listItem.MouseClick = function(sender, args)
		if (args.Button == Turbine.UI.MouseButton.Left) then
			self.comboBoxGroup:SetSelectedIndex(self:GetIndex(listItem),true);
		end
	end
	
	listItem.top = top;
	listItem.value = value;
	
	return listItem;
end

function CombatAnalysisComboBoxInstance:SetTotals(text,value)
	-- create first element if it doesn't yet exist
	if (self.firstElement == nil) then
		self.firstElement = self:CreateItem(text,value);
		self.firstElement:SetParent(self.dropDownBackground);
	-- otherwise just update the text and value
	else
		self.firstElement.label:SetText(text);
		self.firstElement.value = value;
	end
	
	self:SetSelected(self.firstElement);
	return true;
end

function CombatAnalysisComboBoxInstance:AddItem(text,value,top)
	-- if the list was previously empty, update the arrow icon
	if self.listBox:GetItemCount() == 0 then
		self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed.tga");
	end
	
	local listItem = self:CreateItem(text,value,top);
	
	-- if the list is full, replace the item in the first slot
	local removeIndex = nil;
	if (top) then
		if (self.comboBoxGroup.maxTopElements ~= nil and self.topElements >= self.comboBoxGroup.maxTopElements) then
			removeIndex = 1;
		end
	else
		if (self.comboBoxGroup.maxElements ~= nil and (self.listBox:GetItemCount()-self.topElements) >= self.comboBoxGroup.maxElements) then
			removeIndex = self.topElements+1;
		end
	end
	
	local selectionChanged = false;
	if (removeIndex ~= nil) then
		if (self.selected == self.listBox:GetItem(removeIndex)) then
			self:SetSelected(self.firstElement);
			selectionChanged = true;
		end
		
		self.listBox:RemoveItemAt(removeIndex);
	end
	
	-- add the item to the listbox
	if (top) then
		self.listBox:InsertItem(self.topElements+(removeIndex and 0 or 1),listItem);
		if (not removeIndex) then self.topElements = self.topElements+1 end
		-- insert dotted border
		if (self.topElements == 1 and self.listBox:GetItemCount() > 1) then self.listBox:InsertItem(self.topElements+1,self.dottedBorderTop) end
	else
		self.listBox:AddItem(listItem);
		if (self.listBox:GetItemCount()-self.topElements == 1 and self.topElements > 0) then self.listBox:InsertItem(self.topElements+1,self.dottedBorderTop) end
	end
	
	self:LayoutDropDown();
	return selectionChanged;
end

function CombatAnalysisComboBoxInstance:RemoveItem(value)
	-- if we are removing the selected item, then select "totals"
	local selectionChanged = false;
	if (self.selected.value == value) then
		self:SetSelected(self.firstElement);
		selectionChanged = true;
	end
	
	for i=1,self.listBox:GetItemCount() do
		local item = self.listBox:GetItem(i);
		
		if (item.value == value) then
			self.listBox:RemoveItemAt(i);
			if (i <= self.topElements) then
				self.topElements = self.topElements - 1;
				-- remove dotted border
				if (self.topElements == 0 and self.listBox:GetItemCount() > 0) then self.listBox:RemoveItemAt(1) end
				-- remove dotted border
			elseif (self.listBox:GetItemCount()-self.topElements == 0 and self.topElements > 0) then
				self.listBox:RemoveItemAt(self.topElements+1);
			end
			break;
		end
	end
	
	-- if the list is now empty, update the arrow icon
	if self.listBox:GetItemCount() == 0 then
		self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed_Ghosted.tga");
	end
	
	self:LayoutDropDown();
	return selectionChanged;
end

function CombatAnalysisComboBoxInstance:Clear()
	self.selection = 0;
	self.topElements = 0;
	-- remove all items
	while self.listBox:GetItemCount() > 0 do
		self.listBox:RemoveItemAt(1);
	end
	-- reset arrow icon
	self.arrow:SetBackground("CombatAnalysis/Resources/dropdown_arrow_closed_Ghosted.tga");
	
	self:CloseDropDown();
	-- NB: A selection change event is not fired on a Clear
end

function CombatAnalysisComboBoxInstance:SetLastItemName(name)
	local lastItem = self.listBox:GetItem(self.listBox:GetItemCount());
	lastItem.label:SetText(name);
	-- update label if the last item was selected
	if self.selected == lastItem then
		self.label:SetText(name);
	end
end

-- selection

function CombatAnalysisComboBoxInstance:SetSelectedIndex(index,close)
	self:SetSelected((index == 0 and self.firstElement or self.listBox:GetItem(index)),close);
end

function CombatAnalysisComboBoxInstance:SetSelected(listItem,close)
	if (self.selected ~= nil) then
		self.selected.label:SetForeColor(self.selected.top and CombatAnalysisComboBox.topColor or CombatAnalysisComboBox.selectionColor);
	end
	
	self.selected = listItem;
	self.selected.label:SetForeColor(self.selected.top and CombatAnalysisComboBox.topItemColor or CombatAnalysisComboBox.itemColor);
	self.label:SetText(self.selected.label:GetText());
	self.label:SetForeColor(self.selected.top and CombatAnalysisComboBox.topColor or CombatAnalysisComboBox.selectionColor);
	self.label:SetOutlineColor(self.selected.top and CombatAnalysisComboBox.topHighlightColor or self.highlightColor);
	self.labelBackground:SetBackColor(self.selected.top and CombatAnalysisComboBox.topBackColor or self.backColor);
	
	if (close) then self:CloseDropDown() end
end

function CombatAnalysisComboBoxInstance:SelectTotals()
	self:SetSelected(self.firstElement);
end

function CombatAnalysisComboBoxInstance:SelectLastTopItem()
	self:SetSelected(self.listBox:GetItem(self.topElements));
end

function CombatAnalysisComboBoxInstance:SelectLastItem()
	self:SetSelected(self.listBox:GetItem(self.listBox:GetItemCount()));
end

function CombatAnalysisComboBoxInstance:GetIndex(listItem)
	if (self.firstElement == listItem) then return 0 end
	
	for i=1,self.listBox:GetItemCount() do
		if (self.listBox:GetItem(i) == listItem) then
			return i;
		end
	end
end

-- get info

function CombatAnalysisComboBoxInstance:GetLowerListTitles()
	local values = {}
	for index=self.topElements+1+(self.topElements > 0 and 1 or 0),self:GetItemCount() do
		local item = self.listBox:GetItem(index);
		table.insert(values,item.label:GetText());
	end
	return values;
end

function CombatAnalysisComboBoxInstance:GetValueAtLowerIndex(index)
	return self.listBox:GetItem(self.topElements+(self.topElements > 0 and 1 or 0)+index).value;
end

function CombatAnalysisComboBoxInstance:GetItemCount()
  return self.listBox:GetItemCount();
end

function CombatAnalysisComboBoxInstance:GetSelectedText()
	return ((self.selected == nil) and "N/A" or self.selected.label:GetText());
end

function CombatAnalysisComboBoxInstance:GetSelectedValue()
	return ((self.selected ~= nil) and self.selected.value or nil);
end

