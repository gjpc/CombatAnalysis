
--[[

	A popup list of suggestions corresponding to the textual data in
	an ordered list that matches a specified value.
	
	This class matches the LOTRO look & feel as closely as possible
	(cf: mail recipient suggestions popup)
	
]]

_G.SuggestionsPopup = class(Turbine.UI.Window);

SuggestionsPopup.maxItems = 10;
SuggestionsPopup.selectedColor = Turbine.UI.Color(0.21,0.06,0.02);

function SuggestionsPopup:Constructor(textBox)
	Turbine.UI.Window.Constructor(self);
	
	self.textBox = textBox;
	
	self:SetZOrder(3); -- sit on top of all windows & the file select dialog
	self:SetBackColor(Turbine.UI.Color(0.7,0.7,0.75));
	
	self.background = Turbine.UI.Control();
	self.background:SetParent(self);
	self.background:SetPosition(2,2);
	self.background:SetMouseVisible(false);
	self.background:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self.background);
	self.listBox:SetPosition(2,2);
	
	self.vScroll = Turbine.UI.Lotro.ScrollBar();
	self.vScroll:SetParent(self.background);
	self.vScroll:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.vScroll:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.vScroll:SetTop(3);
	self.vScroll:SetWidth(10);
	self.listBox:SetVerticalScrollBar(self.vScroll);
end

function SuggestionsPopup:Layout()
	local w = self:GetWidth();
	
	self.background:SetWidth(w-4);
	self.listBox:SetWidth(w-10-6-10);
	self.vScroll:SetLeft(w-10-5);
end

function SuggestionsPopup:SizeChanged()
	local x,y = WindowManager.GetPositionOnScreen(self.textBox);

	if (y+28+4+self:GetHeight() > Turbine.UI.Display.GetHeight()) then
		self:SetPosition(x+5,y-4-self:GetHeight());
	else
		self:SetPosition(x+5,y+28+4);
	end
end
		
function SuggestionsPopup:SetData(data)
	self.listBox:ClearItems();
	
	for index,text in ipairs(data) do
		local firstLabel = (index == 1);
		
		local label = Turbine.UI.Label();
		label:SetParent(self.listBox);
		label:SetSize(Turbine.UI.Display.GetWidth(),20);
		label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		label:SetOutlineColor(control2Color);
		label:SetMultiline(false);
		label:SetText(text[2]);
		
		if (firstLabel) then
			label:SetBackColor(SuggestionsPopup.selectedColor);
			label:SetForeColor(control2YellowColor);
		else
			label:SetForeColor(control2LightColor);
		end
		
		label.MouseEnter = function(sender,args)
			label:SetBackColor(SuggestionsPopup.selectedColor);
			label:SetForeColor(Turbine.UI.Color(1,1,1));
			label:SetFontStyle(Turbine.UI.FontStyle.Outline);
		end
		
		label.MouseLeave = function(sender,args)
			if (firstLabel) then
				label:SetForeColor(control2YellowColor);
			else
				label:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
				label:SetForeColor(control2LightColor);
			end
			label:SetFontStyle(Turbine.UI.FontStyle.Normal);
		end
		
		label.MouseDown = function(sender,args)
			self.listBox:ClearItems();
			self:SetVisible(false);
			self.textBox.text = label:GetText();
			self.textBox:SetText(label:GetText());
			self.textBox:Focus();
		end
		
		self.listBox:AddItem(label);
	end
	
	self:SetHeight(math.min(SuggestionsPopup.maxItems,#data)*20+8);
	self.background:SetHeight(math.min(SuggestionsPopup.maxItems,#data)*20+4);
	self.listBox:SetHeight(math.min(SuggestionsPopup.maxItems,#data)*20);
	self.vScroll:SetHeight(math.min(SuggestionsPopup.maxItems,#data)*20-3);
end

