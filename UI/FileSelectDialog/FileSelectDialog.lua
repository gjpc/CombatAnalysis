
--[[
	
	A Resizable Window that gives options to select files. Like
	the Confirm Dialog, showing the File Select Dialog will slightly
	darken the rest of the screen.
	
	Due to the specialized manner in which data is saved,
	the functionality of this window is actually pretty
	specific to CombatAnalysis.
	
	Note this class is forced to be a singleton, to ensure there
	can only be one file select dialog open at once.
	
]]--

local FileSelectDialog = class(ResizableWindow);

function FileSelectDialog:Constructor(text)
	ResizableWindow.Constructor(self);
	
	self.queuedSaves = {}
	self.pendingLoads = {}
	self.pendingSaves = {}
	self.pendingCombines = {}
	self.currentCombine = {}
  self.deselectedEncounters = {}
	
	self.minimumWidth = 480;
	self.minimumHeight = 350;
	
	self.background = Turbine.UI.Control();
	self.background:SetParent(self);
	self.background:SetPosition(5,25);
	self.background:SetBackColor(Turbine.UI.Color(0.06,0.4,0.4,0.7));
	self.background:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.background:SetZOrder(-1);
  self.background:SetMouseVisible(false);
	
	-- back button
	self.backButton = Turbine.UI.Control();
	self.backButton:SetParent(self);
	self.backButton:SetTop(53);
	self.backButton:SetSize(19,16);
	self.backButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.backButton:SetBackground("CombatAnalysis/Resources/back_button.tga");
	
	self.backButton.enabled = true;
	self.backButton.SetEnabled = function(sender,enable)
		self.backButton.enabled = enable;
		self.backButton:SetBackground("CombatAnalysis/Resources/back_button"..(self.backButton.enabled and "" or "_disabled")..".tga");
	end
	
	self.backButton.pressed = false;
	self.backButton.MouseEnter = function(sender,args)
		if (self.backButton.enabled) then
			self.backButton:SetBackground("CombatAnalysis/Resources/back_button_"..(self.backButton.pressed and "pressed" or "mouseover")..".tga");
		end
	end
	self.backButton.MouseLeave = function(sender,args)
		if (self.backButton.enabled) then
			self.backButton:SetBackground("CombatAnalysis/Resources/back_button"..(self.backButton.pressed and "_mouseover" or "")..".tga");
		end
	end
	self.backButton.MouseDown = function(sender,args)
		if (self.backButton.enabled) then
			self.backButton.pressed = true;
			self.backButton:SetBackground("CombatAnalysis/Resources/back_button_pressed.tga");
		end
	end
	self.backButton.MouseUp = function(sender,args)
		if (self.backButton.enabled) then
			self.backButton.pressed = false;
			self.backButton:SetBackground("CombatAnalysis/Resources/back_button.tga");
		end
	end
	
	self.backButton.MouseClick = function(sender,args)
		if (self.backButton.enabled) then
			self:SetFileMode(true);
		end
	end
	
	-- forward button
	self.forwardButton = Turbine.UI.Control();
	self.forwardButton:SetParent(self);
	self.forwardButton:SetTop(53);
	self.forwardButton:SetSize(19,15);
	self.forwardButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.forwardButton:SetBackground("CombatAnalysis/Resources/forward_button.tga");
	
	self.forwardButton.enabled = true;
	self.forwardButton.SetEnabled = function(sender,enable)
		self.forwardButton.enabled = enable;
		self.forwardButton:SetBackground("CombatAnalysis/Resources/forward_button"..(self.forwardButton.enabled and "" or "_disabled")..".tga");
	end
	self.forwardButton.CheckEnabled = function(sender)
		self.forwardButton:SetEnabled(self.fileMode and (self.saveMode or (self.selectDataCheckBox:IsChecked() and self.fileNameTextBox:GetText() ~= "")));
	end
	
	self.forwardButton.pressed = false;
	self.forwardButton.MouseEnter = function(sender,args)
		if (self.forwardButton.enabled) then
			self.forwardButton:SetBackground("CombatAnalysis/Resources/forward_button_"..(self.forwardButton.pressed and "pressed" or "mouseover")..".tga");
		end
	end
	self.forwardButton.MouseLeave = function(sender,args)
		if (self.forwardButton.enabled) then
			self.forwardButton:SetBackground("CombatAnalysis/Resources/forward_button"..(self.forwardButton.pressed and "_mouseover" or "")..".tga");
		end
	end
	self.forwardButton.MouseDown = function(sender,args)
		if (self.forwardButton.enabled) then
			self.forwardButton.pressed = true;
			self.forwardButton:SetBackground("CombatAnalysis/Resources/forward_button_pressed.tga");
		end
	end
	self.forwardButton.MouseUp = function(sender,args)
		if (self.forwardButton.enabled) then
			self.forwardButton.pressed = false;
			self.forwardButton:SetBackground("CombatAnalysis/Resources/forward_button.tga");
		end
	end
	
	self.forwardButton.MouseClick = function(sender,args)
		if (self.forwardButton.enabled) then
			self:SetFileMode(false);
		end
	end
	
	-- select all button
	self.selectAllButton = Turbine.UI.Lotro.Button();
	self.selectAllButton:SetParent(self);
	self.selectAllButton:SetSize(110,25);
	self.selectAllButton:SetPosition(55,50);
	self.selectAllButton:SetText(L.SelectAll);
	self.selectAllButton.MouseClick = function(sender,args)
		fileSelectBox:SetCheckedAll(true);
	end
	
	-- clear all button
	self.clearAllButton = Turbine.UI.Lotro.Button();
	self.clearAllButton:SetParent(self);
	self.clearAllButton:SetSize(110,25);
	self.clearAllButton:SetPosition(172,50);
	self.clearAllButton:SetText(L.ClearAll);
	self.clearAllButton.MouseClick = function(sender,args)
		fileSelectBox:SetCheckedAll(false);
	end
	
	-- files list
	fileSelectBox:SetParent(self);
	fileSelectBox:SetPosition(30,80);
	
	-- file name label
	self.fileNameLabel = Turbine.UI.Label();
	self.fileNameLabel:SetParent(self);
	self.fileNameLabel:SetLeft(30);
	self.fileNameLabel:SetHeight(28);
	self.fileNameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.fileNameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.fileNameLabel:SetForeColor(control2LightColor);
	self.fileNameLabel:SetMultiline(false);
	self.fileNameLabel:SetText(L.FileName .. ":");
	self.fileNameLabel:SetZOrder(1);
	self.fileNameLabel:SetMouseVisible(false);
	Misc.DetermineLength(L.FileName .. ":",Turbine.UI.Lotro.Font.TrajanPro14);
	
	-- file name textbox
	self.fileNameTextBox = SuggestionsTextBox();
	self.fileNameTextBox:SetParent(self);
	
	-- select data checkbox option
	self.selectDataCheckBox = Turbine.UI.Lotro.CheckBox();
	self.selectDataCheckBox:SetParent(self);
	self.selectDataCheckBox:SetSize(401,23);
	self.selectDataCheckBox:SetMultiline(false);
	self.selectDataCheckBox:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.selectDataCheckBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.selectDataCheckBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.selectDataCheckBox:SetForeColor(control2LightColor);
	self.selectDataCheckBox:SetText(L.SelectCurrentDataToCombineWith.."  ");
	
	self.selectDataCheckBox.checked = false;
	
	self.selectDataCheckBox.CheckedChanged = function(sender,args)
		if (self.fileMode and combatData.currentEncounter ~= nil) then
			self.selectDataCheckBox.checked = self.selectDataCheckBox:IsChecked();
			self:SaveState();
		end
		
		self.forwardButton:CheckEnabled();
	end
	
	self.selectDataCheckBox.EnabledChanged = function(sender,args)
		self.selectDataCheckBox:SetForeColor(self.selectDataCheckBox:IsEnabled() and control2LightColor or Turbine.UI.Color(0.35,0.35,0.35));
	end
	
	-- select data checkbox option
	self.loadAsTotalsCheckBox = Turbine.UI.Lotro.CheckBox();
	self.loadAsTotalsCheckBox:SetParent(self);
	self.loadAsTotalsCheckBox:SetSize(401,23);
	self.loadAsTotalsCheckBox:SetMultiline(false);
	self.loadAsTotalsCheckBox:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.loadAsTotalsCheckBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.loadAsTotalsCheckBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.loadAsTotalsCheckBox:SetForeColor(control2LightColor);
	self.loadAsTotalsCheckBox:SetText(L.LoadDataAsTotalsEncounter.."  ");
	
	self.loadAsTotalsCheckBox.CheckedChanged = function(sender,args)
		self:SaveState();
	end
	
	-- save/load button
	self.saveLoadButton = Turbine.UI.Lotro.Button();
	self.saveLoadButton:SetParent(self);
	self.saveLoadButton:SetSize(106,26);
	self.saveLoadButton.MouseClick = function(sender,args)
		self.fileName = string.gsub(self.fileNameTextBox:GetText(),"_"," ");
    
    -- reverse format dates
    self.fileName = string.gsub(self.fileName,"(%d%d) (%a%a%a) (%d%d%d%d) (%d%d):(%d%d):(%d%d) %- ",function(day,month,year,hour,minute,second)
      return (day.." "..Misc.MonthToNumber(month,true).." "..year.." "..hour.." "..minute.." "..second.." ");
    end);
    
		-- ensure a file name has been specified
		if ((self.saveMode and self.fileName == "") or (not self.saveMode and self.fileName == "" and fileSelectBox.selectedCount == 0)) then
			dialog:ShowInfoDialog(L.NoFileMessage);
			return;
		end
		
		local timestamp = Turbine.Engine.GetGameTime();
		
		-- save or load the selected data
		if (self.saveMode) then
			-- if in file mode, go down a level
			if (self.fileMode) then
				self:SetFileMode(false);
				return;
			end
			
			-- ensure some data is selected for saving
			local itemChecked = false;
			for i,item in ipairs(fileSelectBox.items) do
				if (item.encounter:IsChecked()) then itemChecked = true end
			end
			if (not itemChecked) then
				dialog:ShowInfoDialog(L.NoDataSelectedMessage);
				return;
			end
			
			-- ensure the user is aware if overwriting a file
			local index,strExists = dataFileList:BinarySearch(string.lower(self.fileName));
			if (strExists) then
				dialog:ShowOptionDialog(L.OverwriteFileMessage,L.Combine,L.Overwrite,DataStorage.Save);
			else
				DataStorage.Save();
			end
			
		else
			-- if in file mode, and select data is checked, then go down a level
			if (self.fileMode and self.selectDataCheckBox:IsChecked()) then
				self:SetFileMode(false);
				
			-- otherwise, load the selected file(s)
			else
				
				-- ensure the user is aware if overwriting a file
				if (fileSelectBox.selectedCount > 1) then
					dialog:ShowOptionDialog(L.CombineOrSeparateMessage,L.Combined,L.Separate,DataStorage.Load);
				else
					DataStorage.Load();
				end
			end
			
		end
	end
	
	-- cancel button
	self.cancelButton = Turbine.UI.Lotro.Button();
	self.cancelButton:SetParent(self);
	self.cancelButton:SetSize(106,25);
	self.cancelButton:SetText(L.Cancel);
	self.cancelButton.MouseClick = function(sender,args)
		self:Close();
	end
end

function FileSelectDialog:PositionChanged(args)
	self.fileNameTextBox:Layout();
end

function FileSelectDialog:KeyDown(args)
	-- do not respond to the key event that was potentially used to show this dialog
	if (DialogManager.timestamp == Turbine.Engine.GetGameTime()) then
    self:SetWantsUpdates(true); -- additional hack to avoid hotkey appearing in textbox
		return;
	end
	
	-- delete
	if (args.Action == 268435633) then
		if (self.fileMode and fileSelectBox.selectedCount > 0) then
			fileSelectBox:DeleteSelected();
		end
	-- save/load on enter
	elseif (args.Action == 162) then
		if (not self.fileNameTextBox.textBox:HasFocus() or not self.fileNameTextBox.suggestionsPopup:IsVisible() or not self.fileNameTextBox:FirstSuggestion()) then
			self.saveLoadButton:MouseClick();
      KeyManager.TakeFocus();
		end
	-- cancel on escape
	elseif (args.Action == 145) then
		self.cancelButton:MouseClick();
	end
end

function FileSelectDialog:Update()
  self.fileNameTextBox:SetText("");
  self:SetWantsUpdates(false);
end

function FileSelectDialog:MouseDown(args)
  KeyManager.TakeFocus();
end

function FileSelectDialog:SetVisible(visible,dontActivate)
	Window.SetVisible(self,visible,dontActivate);
  if (visible and not dontActivate and self.fileNameTextBox ~= nil) then
    self.fileNameTextBox:Focus();
  end
end

function FileSelectDialog:Close()
	DialogManager.HideDialog(self);
	self.deselectedEncounters = {}
end

function FileSelectDialog:Layout()
	ResizableWindow.Layout(self);
	local textWidth = Misc.texts[L.FileName .. ":"];
	
	local w,h = self:GetSize();
	self.background:SetSize(w-10,h-30);
	
	local additionalHeight;
	
	if (self.saveMode) then
		self.selectDataCheckBox:SetVisible(false);
		self.loadAsTotalsCheckBox:SetVisible(false);
		additionalHeight = 0;
	else
		self.selectDataCheckBox:SetVisible(true);
		self.selectDataCheckBox:SetPosition(w-453,h-100);
		self.loadAsTotalsCheckBox:SetVisible(true);
		self.loadAsTotalsCheckBox:SetPosition(w-453,h-76);
		additionalHeight = 54+2;
	end
	
	fileSelectBox:SetSize(w-59,h-187-additionalHeight);
	fileSelectBox:Layout();
	
	self.fileNameLabel:SetTop(h-92-additionalHeight);
	self.fileNameLabel:SetWidth(textWidth);
	self.fileNameTextBox:SetPosition(40+textWidth,h-92-additionalHeight);
	self.fileNameTextBox:SetWidth(w-69-textWidth);
	self.fileNameTextBox:Layout();
	
	self.backButton:SetLeft(w-105);
	self.forwardButton:SetLeft(w-81);
	
	self.saveLoadButton:SetPosition(w-275,h-40);
	self.cancelButton:SetPosition(w-155,h-40);
	
	
end

function FileSelectDialog:SetFileMode(fileMode,updateIfUnchanged)
	if (self.fileMode == fileMode and not updateIfUnchanged) then return end
	self.fileMode = fileMode;
	
	if (self.fileMode) then
		self:SetText(self.saveMode and L.SelectSaveFile or L.SelectFileToLoad);
		self.backButton:SetEnabled(false);
		self.forwardButton:CheckEnabled();
		self.selectAllButton:SetEnabled(false);
		self.clearAllButton:SetEnabled(false);
		
		self.saveLoadButton:SetText(self.saveMode and L.Select or L.Load);
		
		self.selectDataCheckBox:SetEnabled(combatData.currentEncounter ~= nil);
		self.selectDataCheckBox:SetChecked(combatData.currentEncounter ~= nil and self.selectDataCheckBox.checked or false);
		
		self.fileNameTextBox:SetReadOnly(false);
	else
		self:SetText(self.saveMode and L.SelectDataToSave or L.SelectDataToCombineWith);
		self.backButton:SetEnabled(true);
		self.forwardButton:SetEnabled(false);
		self.selectAllButton:SetEnabled(true);
		self.clearAllButton:SetEnabled(true);
		
		self.saveLoadButton:SetText(self.saveMode and L.Save or L.Load);
		
		self.selectDataCheckBox:SetEnabled(false);
		self.selectDataCheckBox:SetChecked(true);
		
		self.fileNameTextBox:SetReadOnly(not self.saveMode);		
	end
	
	fileSelectBox:Reset(true,true);
	self:Layout();
end

function FileSelectDialog:NotifyNewEncounter(name)
	if (self:IsVisible() and not self.selectDataCheckBox:IsEnabled()) then
		self.selectDataCheckBox:SetEnabled(true);
		self.selectDataCheckBox:SetChecked(self.selectDataCheckBox.checked);
	end
	
	if (self:IsVisible() and not self.fileMode) then
		fileSelectBox:AddFileItem(name);
		fileSelectBox:Layout();
	end
end

function FileSelectDialog:NotifyTotalsChanged(name)
	if (self:IsVisible() and not self.fileMode) then
		fileSelectBox.items[1]:SetName(name);
	end
end

function FileSelectDialog:NotifyLastItemChanged(name)
	if (self:IsVisible() and not self.fileMode) then
		fileSelectBox.items[#fileSelectBox.items]:SetName(name);
	end
end

-- Shows a confirm window with the specified text and listener function
function FileSelectDialog:Show(saveMode)
	if (saveMode and combatData.currentEncounter == nil) then
		dialog:ShowInfoDialog(L.NoDataMessage);
		return;
	end
	
	fileSelectBox:ClearSelected();
	fileSelectBox.selectedNames = {}
	self.deselectedEncounters = {}
	
	self.saveMode = saveMode;
	
	self.fileNameTextBox:SetText("");
	self:SetFileMode(not self.saveMode,true);
	
	self:Layout();
	
	DialogManager.ShowDialog(self);
end

function FileSelectDialog:SaveState()
	-- tab window id, stats panel window id, showStats state (1->3), auto select player, show title bar, show encounters, show targets, show extra buttons, stats panel state 
	settings["fileDialog"] = {
			["x"] = EncodeNumbers(self.hidden:GetLeft()),["y"] = EncodeNumbers(self.hidden:GetTop()),
			["w"] = EncodeNumbers(self:GetWidth()),["h"] = EncodeNumbers(self:GetHeight()),
			["selectDataOnLoad"] = self.selectDataCheckBox.checked, ["loadAsTotals"] = self.loadAsTotalsCheckBox:IsChecked()
		};
	
	SaveSettings();
end

_G.fileSelectDialog = FileSelectDialog();

function fileSelectDialog.RestoreState(state)
	if (state["x"] == nil or state["y"] == nil or state["w"] == nil or state["h"] == nil) then
		fileSelectDialog:SetSize(650,480,true);
		fileSelectDialog:SetPosition((Turbine.UI.Display.GetWidth()-650)/2,(Turbine.UI.Display.GetHeight()-480)/2);
	else
		fileSelectDialog:SetSize(state["w"],state["h"],true);
		fileSelectDialog:SetPosition(state["x"],state["y"]);
	end
	
	fileSelectDialog.selectDataCheckBox.checked = state["selectDataOnLoad"];
	fileSelectDialog.selectDataCheckBox:SetChecked(state["selectDataOnLoad"]);
	fileSelectDialog.loadAsTotalsCheckBox:SetChecked(state["loadAsTotals"]);
end

