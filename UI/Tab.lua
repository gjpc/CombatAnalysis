
--[[

A Standard LOTRO Tab.

]]--

_G.Tab = class(Turbine.UI.Control);

function Tab:Constructor(tabbedPane,tabIndex,tabName,content)
	Turbine.UI.Control.Constructor(self);
  
	self.enabled = (content ~= nil);
	self.tabIndex = tabIndex;
	self.tabbedPane = tabbedPane;
	self.content = content;
  
  self.color = "";
	
	if (self.enabled) then
		self.content:SetPosition(2,24);
	end
	
	self:SetMouseVisible(true);
	self:SetParent(self.tabbedPane);
	self:SetPosition((tabIndex-1)*95,2);	
	self:SetSize(95,21);
	self:SetZOrder(-2);
	
	-- tab left
	self.left = Turbine.UI.Control();
	self.left:SetParent(self);
	self.left:SetSize(77,21);
	self.left:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.left:SetMouseVisible(false);
	self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_back_w"..self.color..".tga");
	
	-- tab right
	self.right = Turbine.UI.Control();
	self.right:SetParent(self);
	self.right:SetPosition(77,0);
	self.right:SetSize(18,21);
	self.right:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.right:SetMouseVisible(false);
	self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_back_e"..self.color..".tga");
	
	-- tab text
	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetText(tabName);
  self.text:SetTop(1);
	self.text:SetSize(95,20);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	self.text:SetForeColor(self.enabled and controlColor or controlDisabledColor);
	self.text:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.text:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.text:SetMouseVisible(false);	
end

function Tab:SetColor(color)
  self.color = ((color == "Red" or color == "Yellow") and ("_"..color:lower()) or "");
  
  self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_" .. (self.selected and "front" or "back") .. "_w"..self.color..".tga");
	self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_" .. (self.selected and "front" or "back") .. "_e"..self.color..".tga");
end

function Tab:SetSelected(selected)
	if (self.selected == selected) then return end
  
	self.selected = selected;
	
	self.text:SetForeColor(self.selected and (self.pressed and controlSelectedColor or Turbine.UI.Color(1,1,1)) or controlColor);
	self.text:SetFont(self.selected and Turbine.UI.Lotro.Font.TrajanPro16 or Turbine.UI.Lotro.Font.TrajanPro15);
	self.text:SetText(self.text:GetText());
	self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_" .. (self.selected and "front" or "back") .. "_w"..self.color..".tga");
	self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_" .. (self.selected and "front" or "back") .. "_e"..self.color..".tga");
	self.content:SetParent(self.selected and self.tabbedPane or nil);
  
  if (self.content.ContentSelected ~= nil) then
    if (selected) then
      self.content:ContentSelected();
    else
      self.content:ContentDeselected();
    end
  end
end

-- tab highlight events
function Tab:MouseEnter(args)
	if (self.enabled) then
		self.text:SetForeColor(self.selected and controlSelectedColor or control2Color);
		self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..((self.pressed and self.selected) and "back" or "front").."_w"..self.color..".tga");
		self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..((self.pressed and self.selected) and "back" or "front").."_e"..self.color..".tga");
	end
end

function Tab:MouseLeave(args)
	if (self.enabled) then
		self.text:SetForeColor(self.pressed and (self.selected and controlSelectedColor or control2Color) or (self.selected and Turbine.UI.Color(1,1,1) or controlColor));
		self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..((self.pressed or self.selected) and "front" or "back").."_w"..self.color..".tga");
		self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..((self.pressed or self.selected) and "front" or "back").."_e"..self.color..".tga");
	end
end

function Tab:MouseDown(args)
	if (self.tabbedPane.window ~= nil) then WindowManager.MouseWasPressed(self.tabbedPane.window) end
	
	if (self.enabled) then
		self.pressed = true;
		self.text:SetForeColor(self.selected and controlSelectedColor or Turbine.UI.Color(1,1,1));
		self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..(self.selected and "front" or "back").."_w"..self.color..".tga");
		self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..(self.selected and "front" or "back").."_e"..self.color..".tga");
	end
end

function Tab:MouseUp(args)
	if (self.enabled) then
		self.pressed = false;
		self.text:SetForeColor(self.selected and Turbine.UI.Color(1,1,1) or controlColor);
		self.left:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..(self.selected and "front" or "back").."_w"..self.color..".tga");
		self.right:SetBackground("CombatAnalysis/Resources/tab_tier1_middle_"..(self.selected and "front" or "back").."_e"..self.color..".tga");
	end
end

function Tab:MouseClick(args)
	if (self.enabled) then
		self.tabbedPane:SelectTab(self.tabIndex);
	end
end
