
--[[
	
	The file select area where users can select items for loading/saving.
	
	This implementation enforces single file select in save mode, and allows
	for multi-select, etc, in load mode. Additionally, when the file dialog
	is not in file mode, this box can be used to store a list of data that
	is available to be saved (encounters).
	
]]

local FileSelectBox = class(Turbine.UI.Control);

FileSelectBox.padding = 2;
FileSelectBox.dragScrollSpeed = 0.07;
FileSelectBox.slowScrollSpeed = 0.21;

function FileSelectBox:Constructor(text)
	Turbine.UI.Control.Constructor(self);
	
	self.selectedNames = {}
	
	self.selected = {}
	self.selectedCount = 0;
	self.firstSelected = nil;
	
	self.dragSelected = {}
	self.dragFirstSelected = nil;
	
	self.items = {}
	self.rows = 0;
	self.columns = 0;
	
	self:SetBackColor(blueBorderColor);
	self:SetMouseVisible(false);
	
	self.viewport = Turbine.UI.Control();
	self.viewport:SetParent(self);
	self.viewport:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.viewport:SetPosition(1,1);
	
	self.viewport.MouseDown = function(sender,args)
		self:MouseDown(args);
	end
	self.viewport.MouseMove = function(sender,args)
		self:MouseMove(args);
	end
	self.viewport.MouseUp = function(sender,args)
		self:MouseUp(args);
	end
	self.viewport.MouseClick = function(sender,args)
		self:MouseClick(args);
	end
	self.viewport.MouseWheel = function(sender,args)
		self:MouseWheel(args);
	end
	
	self.fileListBox = Turbine.UI.ListBox();
	self.fileListBox:SetParent(self.viewport);
	self.fileListBox:SetMouseVisible(false);
	
	self.fileListBoxBackground = Turbine.UI.Control();
	self.fileListBoxBackground:SetParent(self.fileListBox);
	self.fileListBoxBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.fileListBoxBackground:SetZOrder(-1);
	
	self.fileListBoxBackground.MouseDown = function(sender,args)
		self:MouseDown(args);
	end
	self.fileListBoxBackground.MouseMove = function(sender,args)
		self:MouseMove(args);
	end
	self.fileListBoxBackground.MouseUp = function(sender,args)
		self:MouseUp(args);
	end
	self.fileListBoxBackground.MouseClick = function(sender,args)
		self:MouseClick(args);
	end
	self.fileListBoxBackground.MouseWheel = function(sender,args)
		self:MouseWheel(args);
	end
	
	self.hScrollBackground = Turbine.UI.Control();
	self.hScrollBackground:SetParent(self);
	self.hScrollBackground:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.hScrollBackground:SetHeight(15);
	self.hScrollBackground:SetLeft(1);
	self.hScrollBackground:SetMouseVisible(false);
	
	self.hScroll = Turbine.UI.Lotro.ScrollBar();
	self.hScroll:SetParent(self.hScrollBackground);
	self.hScroll:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.hScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.hScroll:SetMinimum(0);
	self.hScroll:SetHeight(10);
	self.hScroll:SetLeft(5);
	
	self.hScroll.dragged = false;
	self.hScroll.value = 0;
	
	self.hScroll.ValueChanged = function(sender,args)
		local value = self.hScroll:GetValue();
		local diff = value%(self.scrollValue*100);
		
		-- round to nearest column
		if (diff ~= 0) then
			if (diff == (self.scrollValue*100)/2) then
				value = (self.hScroll.value < value and value+diff or value-diff);
			elseif (diff < (self.scrollValue*100)/2) then
				value = value-diff;
			else
				value = value+((self.scrollValue*100)-diff);
			end
			self.hScroll:SetValue(value);
			
		-- update view
		else
			self.hScroll.value = value;
			self.fileListBox:SetLeft(-252*(value/(self.scrollValue*100)));
		end
	end
	
	self.dragArea = Turbine.UI.Window();
	self.dragArea:SetBackColor(blueBorderColor);
	self.dragArea:SetMouseVisible(false);
	self.dragArea:SetZOrder(99);
	
	self.dragAreaBackground = Turbine.UI.Control();
	self.dragAreaBackground:SetParent(self.dragArea);
	self.dragAreaBackground:SetPosition(1,1);
	self.dragAreaBackground:SetBackColor(Turbine.UI.Color(0.15,0.56,0.56,0.85));
	self.dragAreaBackground:SetMouseVisible(false);
	self.dragAreaBackground:SetSize(0,0);
end

function FileSelectBox:Layout()
	local w,h = self:GetSize();
	
	self.viewport:SetSize(w-2,h-17);
	self.hScrollBackground:SetTop(h-16);
	self.hScrollBackground:SetWidth(w-2);
	self.hScroll:SetWidth(w-11);
	
	self.rows = math.max(1,math.floor((h-22-2*FileSelectBox.padding)/24));
	local columns = math.max(1,math.ceil(#self.items/self.rows));
	local columnsShrunk = (columns < self.columns and self.hScroll:GetValue() > (columns-1)*columns*100);
	self.columns = columns;
	
	self.colsWidth = math.floor((w-2-2*FileSelectBox.padding)/252);
	
	self.fileListBox:SetSize(math.max((self.columns-self.colsWidth)*252+(w-2),w-2),h-17);
	self.fileListBoxBackground:SetSize(math.max((self.columns-self.colsWidth)*252+(w-2),w-2),h-17);
	
	if (self.columns > 1 and (w-2-2*FileSelectBox.padding) < (self.columns)*252) then
		-- set the scroll values to a large unique number that we don't ever use (ie: not multiple of 100) to avoid scroll size bug
		self.hScroll:SetSmallChange(9999999999999999);
		self.hScroll:SetLargeChange(9999999999999999);
		self.hScroll:SetMaximum(9999999999999999);
		
		self.hScroll:SetSmallChange((self.columns-self.colsWidth)*100);
		self.hScroll:SetLargeChange((self.columns-self.colsWidth)*100);
		
		self.scrollValue = self.columns-self.colsWidth+1;
		self.hScroll:SetMaximum(self.scrollValue*(self.columns-self.colsWidth)*100);
		if (columnsShrunk) then self.hScroll:SetValue(self.hScroll:GetMaximum()) end
		
		self.hScroll:SetVisible(true);
		
	else
		self.hScroll:SetValue(0);
		self.hScroll:SetVisible(false);
	end
	
	for index,item in ipairs(self.items) do
		local r = (index%self.rows);
		if (r == 0) then r = self.rows end
		local c = math.ceil(index/self.rows);
		
		item:SetPosition(
			FileSelectBox.padding+((c-1)*252),
			FileSelectBox.padding+((r-1)*24)
		);
	end
end

function FileSelectBox:Reset(dontLayout,dontUpdateTextBox)
	-- 1) store a list of selected names so it can be retrieved even if data has changed
	if (self.fileMode) then
		self.selectedNames = {}
		for index,_ in pairs(self.selected) do
			if (self.items[index] ~= nil) then
				self.selectedNames[self.items[index].name] = true;
			end
		end
		
		self.firstSelectedName = (self.items[self.firstSelected] ~= nil and self.items[self.firstSelected].name or nil);
	end
	
	self:ClearItems();
	self.fileMode = fileSelectDialog.fileMode;
	
	-- generate file info
	if (fileSelectDialog.fileMode) then
		-- 2) convert old indexes into new ones
		self.selected = {};
		self.selectedCount = 0;
		for index,fileName in ipairs(dataFileList.list) do
			if (self.selectedNames[fileName[2]]) then
				self.selected[index] = true;
				self.selectedCount = self.selectedCount + 1;
			end
			
			if (self.firstSelectedName == fileName[2]) then
				self.firstSelected = index;
			end
		end
		
		for index,fileName in ipairs(dataFileList.list) do
			self:AddFileItem(fileName[2],self.selected[index]);
		end
		
		-- update file name text box if selection changed
		if (not dontUpdateTextBox) then
			local fileNames = "";
			if (self.selectedCount == 1) then
				fileNames = fileNames .. self.items[next(self.selected)].fileName:GetText();
			else
				for index,_ in pairs(self.selected) do
					fileNames = fileNames .. "'"..self.items[index].fileName:GetText().."' ";
				end
			end
			fileSelectDialog.fileNameTextBox.text = fileNames;
			fileSelectDialog.fileNameTextBox:SetText(fileNames);
		end
	else
		-- generate encounter info
		for index,encounterName in ipairs(encountersComboBox:GetLowerListTitles()) do
			self:AddFileItem(encounterName,fileSelectDialog.deselectedEncounters[index]);
		end
	end
	
	if (not dontLayout) then self:Layout() end
end

function FileSelectBox:AddFileItem(name,selected)
	local index = #self.items+1;
	
	local item = (fileSelectDialog.fileMode and FileSelectItem(name,index,selected,nil) or FileSelectEncounterItem(name,index,selected));
	item:SetParent(self.fileListBox);
	
	table.insert(self.items,item);
end

function FileSelectBox:ClearItems()
	for _,item in pairs(self.items) do
		item:SetParent(nil);
	end
	
	self.items = {}
end

function FileSelectBox:DeleteSelected()
	dialog:ShowConfirmDialog(L.AreYouSureYouWantToDeleteMessage,FileSelectBox.PerformDelete,self);
end

function FileSelectBox:PerformDelete(confirm)
	if (not confirm) then return end
	
	for index,_ in pairs(self.selected) do
		if (self.items[index] ~= nil) then
			dataFileList:Remove(string.lower(self.items[index].name),self.items[index].name);
		end
	end
	
	if (not DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState())) then
		for index,_ in pairs(self.selected) do
			if (self.items[index] ~= nil) then
				dataFileList:Add(string.lower(self.items[index].name),self.items[index].name);
			end
		end
		return;
	end
	
	self:Reset();
end

function FileSelectBox:AddItemToSelected(item,removeIfPresent)
	if (removeIfPresent and self.selected[item.index]) then
		self.selected[item.index] = nil;
		self.selectedCount = self.selectedCount - 1;
		item:SetSelected(false);
		
		self.firstSelected = item.index;
	else
		self.selected[item.index] = true;
		self.selectedCount = self.selectedCount + 1;
		item:SetSelected(true);
		
		if (self.firstSelected == nil or removeIfPresent) then self.firstSelected = item.index end
	end
	
	if (self.selectedCount > 0) then
		local fileNames = "";
		if (self.selectedCount == 1) then
			fileNames = fileNames .. self.items[next(self.selected)].fileName:GetText();
		else
			for index,_ in pairs(self.selected) do
				fileNames = fileNames .. "'"..self.items[index].fileName:GetText().."' ";
			end
		end
		fileSelectDialog.fileNameTextBox.text = fileNames;
		fileSelectDialog.fileNameTextBox:SetText(fileNames);
	end
	
	fileSelectDialog.forwardButton:CheckEnabled();
end

function FileSelectBox:AddIndexesToSelected(startIndex,endIndex)
	for index = math.min(startIndex,endIndex),math.max(startIndex,endIndex) do
		local item = self.items[index];
		
		self.selected[index] = true;
		self.selectedCount = self.selectedCount + 1;
		item:SetSelected(true);
	end
	
	if (self.firstSelected == nil) then
		self.firstSelected = startIndex;
	end
	
	if (self.selectedCount > 0) then
		local fileNames = "";
		if (self.selectedCount == 1) then
			fileNames = fileNames .. self.items[next(self.selected)].fileName:GetText();
		else
			for index,_ in pairs(self.selected) do
				fileNames = fileNames .. "'"..self.items[index].fileName:GetText().."' ";
			end
		end
		fileSelectDialog.fileNameTextBox.text = fileNames;
		fileSelectDialog.fileNameTextBox:SetText(fileNames);
	end
	
	fileSelectDialog.forwardButton:CheckEnabled();
end

function FileSelectBox:TempAddGridToSelected(startRow,endRow,startCol,endCol,removeIfPresent,nearestRow,nearestCol)
	for index,_ in pairs(self.dragSelected) do
		local item = self.items[index];
		
		if (self.selected[index]) then
			self.selected[index] = nil;
			self.selectedCount = self.selectedCount - 1;
			item:SetSelected(false);
		else
			self.selected[index] = true;
			self.selectedCount = self.selectedCount + 1;
			item:SetSelected(true);
		end
	end
	self.dragSelected = {}
	
	if (self.dragFirstSelected ~= nil) then self.firstSelected = nil end
	self.dragFirstSelected = nil;
	
	for c = startCol,endCol do
		for r = startRow,endRow do
			local index = (c-1)*self.rows+r;
			if (index > #self.items) then break end
			
			local item = self.items[index];
			
			if (removeIfPresent and self.selected[index]) then
				self.dragSelected[index] = true;
				self.selected[index] = nil;
				self.selectedCount = self.selectedCount - 1;
				item:SetSelected(false);
				
			elseif (not self.selected[index]) then
				self.dragSelected[index] = true;
				self.selected[index] = true;
				self.selectedCount = self.selectedCount + 1;
				item:SetSelected(true);
				
			end
		end
	end
	
	if (self.firstSelected == nil and endCol-startCol >= 0 and endRow-startRow >= 0) then
		local index = 0;
		for col=nearestCol,math.max(1,nearestCol-1),-1 do
			for row=nearestRow,1,-1 do
				index = (col-1)*self.rows+row;
				if (index >= 1 and index <= #self.items) then
					if (self.selected[index]) then
						self.dragFirstSelected = index;
						self.firstSelected = index;
					end
					break;
				end
			end
			if (self.firstSelected) then break end
		end
	end
	
	local fileNames = "";
	if (self.selectedCount == 1) then
		fileNames = fileNames .. self.items[next(self.selected)].fileName:GetText();
	else
		for index,_ in pairs(self.selected) do
			fileNames = fileNames .. "'"..self.items[index].fileName:GetText().."' ";
		end
	end
	fileSelectDialog.fileNameTextBox.text = fileNames;
	fileSelectDialog.fileNameTextBox:SetText(fileNames);
	
	fileSelectDialog.forwardButton:CheckEnabled();
end

function FileSelectBox:ClearSelected()
	local count = 0;
	if (self.fileMode) then
		for index,_ in pairs(self.selected) do
			if (self.items[index] ~= nil) then
				self.items[index]:SetSelected(false);
			end
			count = count+1;
		end
	end
	
	self.selected = {};
	self.selectedCount = 0;
	self.firstSelected = nil;
	
	if (count > 1) then
		fileSelectDialog.fileNameTextBox.text = "";
		fileSelectDialog.fileNameTextBox:SetText("");
	end
	
	fileSelectDialog.forwardButton:CheckEnabled();
end

function FileSelectBox:MouseDown(args)
	fileSelectDialog.fileNameTextBox.suggestionsPopup:SetVisible(false);
	self:Focus();
	
	if (not fileSelectDialog.fileMode) then return end
	
	if (fileSelectDialog.saveMode) then
		self:ClearSelected();
		return;
	end
	
	if (not self:IsControlKeyDown() and not self:IsShiftKeyDown()) then
		self:ClearSelected();
	end
	
	self.mouseDown = true;
	
	local x,y = WindowManager.GetPositionOnScreen(self.fileListBox);
	self.startX = x+args.X;
	self.startY = y+args.Y;
	
	self.minX = 1-self.fileListBox:GetLeft();
	self.maxX = self:GetWidth()-3-self.fileListBox:GetLeft();
	
	self.minY = 1;
	self.maxY = self:GetHeight()-(self.hScroll:IsVisible() and 23 or 3);
end

function FileSelectBox:MouseMove(args)
	if (self.mouseDown) then
		local x,y = WindowManager.GetPositionOnScreen(self.fileListBox);
		local screenX = args.X+x;
		local screenY = args.Y+y;
		
		if (not self.boxDragging and (math.abs(screenX-self.startX) > 5 or math.abs(screenY-self.startY) > 5)) then
			self.dragArea:SetVisible(true);
			if (not self:IsControlKeyDown() and not self:IsShiftKeyDown()) then self:ClearSelected() end
			self.boxDragging = true;
		end
		
		if (self.boxDragging) then
			-- drag the view around
			if (args.X < self.minX) then
				if (self.hScroll:IsVisible() and self.hScroll:GetValue() > 0) then
					self.scrollLeft = true;
					self:SetWantsUpdates(true);
				end
				args.X = self.minX;
				
			elseif (args.X > self.maxX) then
				if (self.hScroll:IsVisible() and self.hScroll:GetValue() < self.hScroll:GetMaximum()) then
					self.scrollLeft = false;
					self:SetWantsUpdates(true);
				end
				args.X = self.maxX;
				
			else
				self:SetWantsUpdates(false);
			end
			
			-- constrain Y to bounds
			args.Y = math.min(self.maxY,math.max(self.minY,args.Y));
			
			screenX = args.X+x;
			screenY = args.Y+y;
			
			-- draw the drag area box
			local newX = math.min(screenX,self.startX);
			local newY = math.min(screenY,self.startY);
			local newW = math.abs(screenX-self.startX);
			local newH = math.abs(screenY-self.startY);
			
			self.dragArea:SetPosition(newX,newY);
			self.dragArea:SetSize(newW,newH);
			self.dragAreaBackground:SetLeft(self.dragOffLeft and 0 or 1);
			self.dragAreaBackground:SetSize(newW-((self.dragOffLeft or self.dragOffRight) and 1 or 2),newH-2);
			
			-- determine which items are selected
			local boundsX = newX-x;
			local boundsY = newY-y;
			local boundsX2 = newX+newW-x;
			local boundsY2 = newY+newH-y;
			
			self.startRow = math.max(1,math.ceil((boundsY-FileSelectBox.padding+1)/24));
			self.endRow = math.min(self.rows,math.ceil((boundsY2-FileSelectBox.padding+1)/24));
			
			self.startCol = math.max(1,math.ceil((boundsX-FileSelectBox.padding+1)/(FileSelectItem.itemWidth+2)));
			self.endCol = math.min(self.columns,math.ceil((boundsX2-FileSelectBox.padding+1)/(FileSelectItem.itemWidth+2)));
			
			local nearestRow = math.max(1,math.min(self.rows,math.ceil(((self.startY-y)-FileSelectBox.padding+1)/24)));
			local nearestCol = math.max(1,math.min(self.columns,math.ceil(((self.startX-x)-FileSelectBox.padding+1)/(FileSelectItem.itemWidth+2))));
			
			self:TempAddGridToSelected(self.startRow,self.endRow,self.startCol,self.endCol,self:IsControlKeyDown(),nearestRow,nearestCol);
			
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
end

function FileSelectBox:Update(args)
	local timestamp = Turbine.Engine.GetGameTime();
	
	local scrollSpeed = (self.scrollSlow and FileSelectBox.slowScrollSpeed or FileSelectBox.dragScrollSpeed);
	
	if (self.scrollTime == nil or ((timestamp - self.scrollTime) >= scrollSpeed)) then
		local selfX = WindowManager.GetPositionOnScreen(self);
		
		-- scroll left
		if (self.scrollLeft) then
			if (self.hScroll:GetValue() == 0) then
				self:SetWantsUpdates(false);
				return;
			end
			self:Scroll(1);
			
			if (not self.scrollSlow) then
				self.startX = self.startX+252;
				if (self.startX > selfX+self:GetWidth()-1) then
					self.dragOffRight = true;
					self.startX = selfX+self:GetWidth()-1;
				end
				self.dragOffLeft = self.startX < selfX+1;
			end
			
		-- scroll right
		else
			if (self.hScroll:GetValue() == self.hScroll:GetMaximum()) then
				self:SetWantsUpdates(false);
				return;
			end
			self:Scroll(-1);
			
			if (not self.scrollSlow) then
				self.startX = self.startX-252;
				if (self.startX < selfX+1) then
					self.dragOffLeft = true;
					self.startX = selfX+1;
				end
				self.dragOffRight = self.startX > selfX+self:GetWidth()-1;
			end
		end
		
		self.scrollTime = timestamp;
		
		if (not self.scrollSlow) then
			self.minX = 1-self.fileListBox:GetLeft();
			self.maxX = self:GetWidth()-3-self.fileListBox:GetLeft();
			
			x,y = self.fileListBox:GetMousePosition();
			self:MouseMove({ ["X"] = x, ["Y"] = y });
		end
	end
end

function FileSelectBox:MouseUp(args)
	self.mouseDown = false;
	
	if (self.boxDragging) then
		self:SetWantsUpdates(false);
		self.dragArea:SetVisible(false);
		self.dragOffLeft = false;
		self.dragOffRight = false;
		
		self.dragSelected = {}
		self.dragFirstSelected = nil;
		
		self.boxDragging = false;
	end
end

function FileSelectBox:MouseClick(args)
	if (args.Button == Turbine.UI.MouseButton.Right) then
		fileSelectDialog:SetFileMode(true);
	end
end

function FileSelectBox:MouseWheel(args)
	self:Scroll(args.Direction);
end

function FileSelectBox:Scroll(direction)
	if (not self.hScroll:IsVisible()) then return end
	
	if (direction < 0) then
		self.hScroll:SetValue(math.min(self.hScroll:GetMaximum(),self.hScroll:GetValue()+self.scrollValue*100));
	else
		self.hScroll:SetValue(math.max(0,self.hScroll:GetValue()-self.scrollValue*100));
	end
end

function FileSelectBox:GetNearestItem(x,y)
	local row = math.ceil((y-FileSelectBox.padding+1)/24);
	local col = math.ceil((x-FileSelectBox.padding+1)/(FileSelectItem.itemWidth+2));
	
	if (row >= 1 and row <= self.rows and col >= 1 and col <= self.columns) then
		local index = (col-1)*self.rows+row;
		if (index <= #self.items) then
			return self.items[index];
		end
	end
end

function FileSelectBox:SetCheckedAll(check)
	for _,item in ipairs(self.items) do
		item.encounter:SetChecked(check);
	end
end

_G.fileSelectBox = FileSelectBox();
