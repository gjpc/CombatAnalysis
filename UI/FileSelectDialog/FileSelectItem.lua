
--[[
	
	A standard file select item, representing a file that is
	(hopefully) in the file system.
	
	Files are added by saving data. Files can be deleted and/or
	combined.
	
	This class includes a mini-drop down list (singleton) for
	right-click delete functionality.
	
	
]]

local deleteDropDown = Turbine.UI.ContextMenu();
deleteDropDown.items = deleteDropDown:GetItems();
deleteDropDown.delete = Turbine.UI.MenuItem(L.Delete);
deleteDropDown.items:Add(deleteDropDown.delete);

deleteDropDown.delete.Click = function(sender)
	fileSelectBox:DeleteSelected();
end


_G.FileSelectItem = class(Turbine.UI.Control);

FileSelectItem.itemWidth = 250;

function FileSelectItem:Constructor(name,index,selected,drag)
	Turbine.UI.Control.Constructor(self);
	
	self.name = name;
	self.index = index;
	
	self:SetSize(FileSelectItem.itemWidth+(drag and 0 or 2),(drag and 22 or 24));
	self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	
	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetPosition((drag and 0 or 1),(drag and 0 or 1));
	self.border:SetSize(FileSelectItem.itemWidth,22);
	self.border:SetBackColor(drag and Turbine.UI.Color(0.925,0.6,0.6,0) or Turbine.UI.Color(0.925,0,0,0));
	self.border:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.border:SetMouseVisible(false);
	self.border:SetVisible(true);
	
	self.background = Turbine.UI.Control();
	self.background:SetParent(self.border);
	self.background:SetPosition(1,1);
	self.background:SetSize(FileSelectItem.itemWidth-2,20);
	if (drag) then self.background:SetBackColor(Turbine.UI.Color(0.33,0.4,0.4,0.12)) end
	self.background:SetMouseVisible(false);
	
	if (drag) then self:SetBackColorBlendMode(Turbine.UI.BlendMode.None) end
	if (drag) then self.border:SetBackColorBlendMode(Turbine.UI.BlendMode.None) end
	if (drag) then self.background:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend) end
	
	self.icon = Turbine.UI.Control();
	self.icon:SetParent(self.background);
	self.icon:SetPosition(2,2);
	self.icon:SetSize(16,16);
	self.icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.icon:SetBackground("CombatAnalysis/Resources/file"..(drag and "_drag" or "")..".tga");
	self.icon:SetMouseVisible(false);
	
	self.fileName = Turbine.UI.Label();
	self.fileName:SetParent(self.background);
	self.fileName:SetPosition(22,2);
	self.fileName:SetSize((drag and FileSelectItem.itemWidth-193 or FileSelectItem.itemWidth-25),18);
	self.fileName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.fileName:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.fileName:SetForeColor(controlLightColor);
	self.fileName:SetMultiline(false);
	self.fileName:SetMouseVisible(false);
	self.fileName:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  -- format dates nicely
	self.fileName:SetText(string.gsub(self.name,"(%d%d%d%d) (%d%d) (%d%d) (%d%d) (%d%d) (%d%d) ",function(year,month,day,hour,minute,second)
    return (day.." "..Misc.NumberToMonth(tonumber(month),true).." "..year.." "..hour..":"..minute..":"..second.." - ");
  end));
	
	if (drag) then
		self.info = Turbine.UI.Label();
		self.info:SetParent(self.background);
		self.info:SetPosition(FileSelectItem.itemWidth-156,2);
		self.info:SetSize(150,17);
		self.info:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		self.info:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
		self.info:SetForeColor(Turbine.UI.Color(1,0.7,0.65));
		self.info:SetMultiline(false);
		self.info:SetMouseVisible(false);
		self.info:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	end
	
	if (selected) then
		self:SetSelected(true);
	end
end

function FileSelectItem:SetName(name)
	self.name = name;
	self.fileName:SetText(self.name);
end

function FileSelectItem:SetSelected(selected)
	self.border:SetBackColor(selected and
		(self.mouseIn and Turbine.UI.Color(0.15,0.165,0.2) or Turbine.UI.Color(0.15,0.1725,0.225)) or
		(self.mouseIn and Turbine.UI.Color(0.44,0.15,0.1575,0.175) or Turbine.UI.Color(0.925,0,0,0))
	);
	self.background:SetBackground(selected and 
		("CombatAnalysis/Resources/file_item_selected"..(self.mouseIn and "_mouseover" or "")..".tga") or
		(self.mouseIn and "CombatAnalysis/Resources/file_item_mouseover.tga" or nil)
	);
	
	self.selected = selected;
end

function FileSelectItem:SetDragTarget(target)
	if (target) then
		self.border:SetBackColor(Turbine.UI.Color(0.15,0.275,0.18));
		self.background:SetBackground("CombatAnalysis/Resources/file_item_drag_target.tga")
	else
		self:SetSelected(fileSelectBox.selected[self.index]);
	end
end

function FileSelectItem:MouseEnter(args)
	self.mouseIn = true;
	self:SetSelected(self.selected);
end

function FileSelectItem:MouseLeave(args)
	self.mouseIn = false;
	self:SetSelected(self.selected);
end

function FileSelectItem:MouseDown(args)
	fileSelectDialog.fileNameTextBox.suggestionsPopup:SetVisible(false);
	self:Focus();
	
	if (args.Button == Turbine.UI.MouseButton.Right) then
		if (not self:IsControlKeyDown() and not self:IsShiftKeyDown() and not fileSelectBox.selected[self.index]) then
			fileSelectBox:ClearSelected();
			fileSelectBox:AddItemToSelected(self,false);
		end
		return;
	end
	
	if (not fileSelectDialog.saveMode and args.X > 2*252/5 and not fileSelectBox.selected[self.index]) then
		self.boxMouseDown = true;
		self.selectedMouseDown = true;
		
		local x,y = fileSelectBox.fileListBox:GetMousePosition();
		fileSelectBox:MouseDown({ ["X"] = x, ["Y"] = y });
		
		return;
	end
	
	self.mouseDown = true;
	self.startX = args.X;
	self.startY = args.Y;
	
	if (not self:IsControlKeyDown() and not self:IsShiftKeyDown() and fileSelectBox.selected[self.index]) then
		self.selectedMouseDown = true;
		return;
	end
	
	-- update selection
	if (self:IsShiftKeyDown() and not fileSelectDialog.saveMode) then
		local startIndex = (fileSelectBox.firstSelected == nil and self.index or fileSelectBox.firstSelected);
		fileSelectBox:ClearSelected();
		fileSelectBox:AddIndexesToSelected(startIndex,self.index);
	elseif (self:IsControlKeyDown() and not fileSelectDialog.saveMode) then
		fileSelectBox:AddItemToSelected(self,true);
	else
		fileSelectBox:ClearSelected();
		fileSelectBox:AddItemToSelected(self,false);
	end
end

function FileSelectItem:MouseMove(args)
	if (self.mouseDown) then
		if (not self.dragging and (math.abs(args.X-self.startX) > 5 or math.abs(args.Y-self.startY) > 5)) then
			self.dragging = true;
			fileSelectBox.dragItem = self;
			self.selectedMouseDown = false;
			self.dragItem = FileSelectItem((fileSelectBox.selectedCount == 1 and self.fileName:GetText() or fileSelectBox.selectedCount.." "..L.Items),self.index,nil,true);
			self.dragItem:SetParent(fileSelectBox.fileListBox);
			self:SetWantsUpdates(true);
		end
		
		if (self.dragging) then
			local x,y = self:GetPosition();
			
			-- drag the view around
			if (x+args.X < 12-fileSelectBox.fileListBox:GetLeft()) then
				if (fileSelectBox.hScroll:IsVisible() and fileSelectBox.hScroll:GetValue() > 0) then
					fileSelectBox.scrollSlow = true;
					fileSelectBox.scrollLeft = true;
					fileSelectBox:SetWantsUpdates(true);
				end
				
			elseif (x+args.X > ((fileSelectBox:GetWidth()-2-fileSelectBox.fileListBox:GetLeft())-12)) then
				if (fileSelectBox.hScroll:IsVisible() and fileSelectBox.hScroll:GetValue() < fileSelectBox.hScroll:GetMaximum()) then
					fileSelectBox.scrollSlow = true;
					fileSelectBox.scrollLeft = false;
					fileSelectBox:SetWantsUpdates(true);
				end
				
			else
				fileSelectBox.scrollSlow = false;
				fileSelectBox:SetWantsUpdates(false);
			end
			
			self.dragItem:SetPosition(args.X+(x-self.startX),args.Y+(y-self.startY));
		end
	
	elseif (self.boxMouseDown) then
		local x,y = fileSelectBox.fileListBox:GetMousePosition();
		fileSelectBox:MouseMove({ ["X"] = x, ["Y"] = y });
		
	end
end

function FileSelectItem:Update()
	local x,y = fileSelectBox.fileListBox:GetMousePosition();
	local target = fileSelectBox:GetNearestItem(x,y);
	
	if (self.dragTarget ~= nil and target ~= self.dragTarget) then
		self.dragTarget:SetDragTarget(false);
		self.dragTarget = nil;
		
		self.dragItem.info:SetText("");
	end
	
	if (target ~= nil and (fileSelectBox.selectedCount > 1 or target ~= self)) then
		target:SetDragTarget(true);
		self.dragTarget = target;
		
		self.dragItem.info:SetText((fileSelectBox.selected[self.dragTarget.index] and L.CombineInto or L.CombineWith)..": "..target.name);
	end
end

function FileSelectItem:MouseUp(args)
	if (self.dragging) then
		self.dragItem:SetParent(nil);
		self.dragItem = nil;
		self.dragging = false;
		self:SetWantsUpdates(false);
		fileSelectBox.scrollSlow = false;
		fileSelectBox:SetWantsUpdates(false);
		
		if (self.dragTarget ~= nil) then
			dialog:ShowConfirmDialog(L.CombineMessage,FileSelectItem.Drag,self);
		end
		
	elseif (self.selectedMouseDown) then
		self.selectedMouseDown = false;
		
		if (self.boxMouseDown) then
			self.boxMouseDown = false;
			
			local dragging = fileSelectBox.boxDragging;
			local x,y = fileSelectBox.fileListBox:GetMousePosition();
			fileSelectBox:MouseUp({ ["X"] = x, ["Y"] = y });
			if (dragging) then return end
		end
		
		if (self:IsShiftKeyDown() and not fileSelectDialog.saveMode) then
			local startIndex = (fileSelectBox.firstSelected == nil and self.index or fileSelectBox.firstSelected);
			fileSelectBox:ClearSelected();
			fileSelectBox:AddIndexesToSelected(startIndex,self.index);
		elseif (self:IsControlKeyDown() and not fileSelectDialog.saveMode) then
			fileSelectBox:AddItemToSelected(self,true);
		else
			fileSelectBox:ClearSelected();
			fileSelectBox:AddItemToSelected(self,false);
		end
		
	end
	
	self.mouseDown = false;
end

function FileSelectItem:Drag(confirm)
	self.dragTarget:SetDragTarget(false);
	
	if (not confirm) then
		self.dragTarget = nil;
		return;
	end
	
	local dragTargetIsSelected = false;
	-- 1) Load in encounters & 2) Combine encounters & 3) Once all encounters are combined, save the final output
	local combine = {["pending"] = {}, ["fileName"] = self.dragTarget.name }
	for i,_ in pairs(fileSelectBox.selected) do
		local item = fileSelectBox.items[i];
		if (item == self.dragTarget) then
			dragTargetIsSelected = true;
		end
		
		-- check if there is a pending save for this file (if so give error and return)
		for index=1,math.max(#fileSelectDialog.pendingSaves,#fileSelectDialog.queuedSaves,#fileSelectDialog.pendingCombines) do
			if ((index <= #fileSelectDialog.pendingSaves and fileSelectDialog.pendingSaves[index] == item.name) or
					(index <= #fileSelectDialog.queuedSaves and fileSelectDialog.queuedSaves[index] == item.name) or
					(index <= #fileSelectDialog.pendingCombines and fileSelectDialog.pendingCombines[index].fileName == item.name)) then
				dialog:ShowInfoDialog(L.LoadBeforeSaveMessage);
				combine.failed = true;
				if (#combine.pending > 0) then table.insert(fileSelectDialog.pendingCombines,combine) end
				self.dragTarget = nil;
				return;
			end
		end
		
		if (not DataStorage.LoadDataFile(item.name,DataStorage.CombineBeforeSave)) then
			combine.failed = true;
			if (#combine.pending > 0) then table.insert(fileSelectDialog.pendingCombines,combine) end
			self.dragTarget = nil;
			return;
		end
		
		table.insert(combine.pending,item.name);
	end
	
	if (not dragTargetIsSelected) then
		local item = self.dragTarget;
		-- check if there is a pending save for this file (if so give error and return)
		for index=1,math.max(#fileSelectDialog.pendingSaves,#fileSelectDialog.queuedSaves,#fileSelectDialog.pendingCombines) do
			if ((index <= #fileSelectDialog.pendingSaves and fileSelectDialog.pendingSaves[index] == item.name) or
					(index <= #fileSelectDialog.queuedSaves and fileSelectDialog.queuedSaves[index].fileName == item.name) or
					(index <= #fileSelectDialog.pendingCombines and fileSelectDialog.pendingCombines[index].fileName == item.name)) then
				dialog:ShowInfoDialog(L.LoadBeforeSaveMessage);
				combine.failed = true;
				if (#combine.pending > 0) then table.insert(fileSelectDialog.pendingCombines,combine) end
				self.dragTarget = nil;
				return;
			end
		end
		
		if (not DataStorage.LoadDataFile(item.name,DataStorage.CombineBeforeSave)) then
			combine.failed = true;
			if (#combine.pending > 0) then table.insert(fileSelectDialog.pendingCombines,combine) end
			self.dragTarget = nil;
			return;
		end
		
		table.insert(combine.pending,item.name);
	end
	
	table.insert(fileSelectDialog.pendingCombines,combine);
	combatAnalysisIcon:CombineStart();
	
	-- 4) Update file list
	for i,_ in pairs(fileSelectBox.selected) do
		local item = fileSelectBox.items[i];
		if (item ~= self.dragTarget) then
			dataFileList:Remove(string.lower(item.name),item.name);
		end
	end
	if (not DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState())) then
		combine.failed = true;
		self.dragTarget:SetDragTarget(false);
		self.dragTarget = nil;
		return;
	end
	
	-- select the drag target
	self.dragTarget:SetDragTarget(false);
	fileSelectBox.selected = {[self.dragTarget.index] = true}
	fileSelectBox.selectedCount = 1;
	fileSelectBox.firstSelected = self.dragTarget.index;
	self.dragTarget = nil;
	
	fileSelectBox:Reset();
end

function FileSelectItem:MouseClick(args)
	if (args.Button == Turbine.UI.MouseButton.Right) then deleteDropDown:ShowMenu() end
end

function FileSelectItem:MouseDoubleClick(args)
	fileSelectDialog.saveLoadButton:MouseClick();
end

function FileSelectItem:MouseWheel(args)
	fileSelectBox:MouseWheel(args);
end

