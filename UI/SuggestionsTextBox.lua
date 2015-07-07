
--[[

	A text box that popup list of suggestions corresponding to the textual data in
	an ordered list that matches a specified value.
	
	This class matches the LOTRO look & feel as closely as possible
	(cf: mail recipient suggestions popup)
	
]]

_G.SuggestionsTextBox = class(Turbine.UI.Control);

function SuggestionsTextBox:Constructor()
	Turbine.UI.Control.Constructor(self);
	
	self.text = nil;
	self.illegalCharacters = false;
	
	-- overlay
	self:SetTop(50);
	self:SetHeight(28);
	self:SetMouseVisible(false);
	
	-- textbox
	self.textBox = Turbine.UI.Lotro.TextBox();
	self.textBox:SetParent(self);
	self.textBox:SetHeight(28);
	self.textBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.textBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	self.textBox:SetForeColor(control2LightColor);
	self.textBox:SetMultiline(false);
	self.textBox:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.textBox:SetBackColor(Turbine.UI.Color(0.5,0,0,0));
	
	-- suggestions popup
	self.suggestionsPopup = SuggestionsPopup(self);
	
	-- compute suggestions while the text box has focus
	self.textBox.FocusGained = function(sender,args)
		self.text = self.textBox:GetText();
		self:SetWantsUpdates(true);
	end
	
	self.textBox.FocusLost = function(sender,args)
		self:SetWantsUpdates(false);
		self.suggestionsPopup:SetVisible(false);
		
		self.illegalCharacters = false;
		self.text = nil;
	end
end

function SuggestionsTextBox:Update()
	-- determine if the text has changed (as there is no event that does this for us)
	local text = self:GetText();
	if (text == self.text) then return end
	self.text = text;
	
	fileSelectDialog.forwardButton.CheckEnabled();
	
	-- determine if the user has entered too many characters, and if so display a warning
	local tooLong = (string.len(text) > 128 );
	local illegalCharacters = nil;
	if (tooLong ~= self.tooLong) then
		if (tooLong) then
			self.tooLong = true;
			self.illegalCharacters = false;
			-- TODO: show message including "L.TooLong"
		else
			self.tooLong = false;
		end
	end
	
	-- determine if the user has entered any illegal characters, and if so display a warning
	if (not tooLong) then
		illegalCharacters = (string.match(text,"[^%w _':%-]") and true or false);
		if (illegalCharacters ~= self.illegalCharacters) then
			if (illegalCharacters) then
				self.illegalCharacters = true;
				-- TODO: show message including "L.IllegalCharacters"
			else
				self.illegalCharacters = false;
			end
		end
	end
	
	-- show suggestions based on the typed file name
	if (not tooLong and not illegalCharacters) then
		self.suggestionsPopup:SetVisible(false);
		if (string.len(self.text) > 0) then
			local suggestions = dataFileList:Suggestions(string.lower(text),30);
			local allMatch = (#suggestions == self.suggestionsPopup.listBox:GetItemCount());
			if (allMatch) then
				for i=1,self.suggestionsPopup.listBox:GetItemCount() do
					if (suggestions[i][2] ~= self.suggestionsPopup.listBox:GetItem(i):GetText()) then
						allMatch = false;
						break;
					end
				end
			end
			if (not allMatch) then self.suggestionsPopup:SetData(suggestions) end
			self.suggestionsPopup:SetVisible(#suggestions > 0);
		end
	end
	
	if (fileSelectDialog.fileMode) then
		fileSelectBox:ClearSelected();
	else
		fileSelectBox.selectedNames = {}
		self.firstSelectedName = nil;
	end
end

function SuggestionsTextBox:Layout()
	local w = self:GetWidth();
	
	self.textBox:SetWidth(w);
	self.suggestionsPopup:SetWidth(w-20);
	self.suggestionsPopup:Layout();
	
	local x,y = WindowManager.GetPositionOnScreen(self);
	
	if (y+28+4+self.suggestionsPopup:GetHeight() > Turbine.UI.Display.GetHeight()) then
		self.suggestionsPopup:SetPosition(x+5,y-4-self.suggestionsPopup:GetHeight());
	else
		self.suggestionsPopup:SetPosition(x+5,y+28+4);
	end
end

function SuggestionsTextBox:FirstSuggestion()	
	local item = self.suggestionsPopup.listBox:GetItem(1);
	if (item == nil) then return false end
	
	self.suggestionsPopup:SetVisible(false);
	self.text = item:GetText();
	self.textBox:SetText(item:GetText());
	
	local index = dataFileList:BinarySearch(string.lower(self.text));
	fileSelectBox:ClearSelected();
	
	if (fileSelectBox.fileMode) then
		fileSelectBox.selected = { [index] = true }
		fileSelectBox.items[index]:SetSelected(true);
		fileSelectBox.selectedCount = 1;
	else
		fileSelectBox.selectedNames = {}
		fileSelectBox.selectedNames[self.text] = true;
		self.firstSelectedName = self.text;
	end
	
	return true;
end

function SuggestionsTextBox:Focus()	
	self.textBox:Focus();
end

function SuggestionsTextBox:SetReadOnly(readOnly)	
	self.textBox:SetReadOnly(readOnly);
	
	if (readOnly) then
		self.textBox:SetForeColor(Turbine.UI.Color(0.8,0.85,0.75));
	else
		self.textBox:SetForeColor(control2LightColor);
	end
end

function SuggestionsTextBox:SetText(text)	
	self.textBox:SetText(text);
end

function SuggestionsTextBox:GetText()
	return self.textBox:GetText();
end
