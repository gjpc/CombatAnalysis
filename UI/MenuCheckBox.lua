
_G.MenuCheckBox = class(Turbine.UI.Lotro.CheckBox);

function MenuCheckBox:Constructor(parent,left,top,width,height,text)
	Turbine.UI.Lotro.CheckBox.Constructor(self);
	
  self:SetParent(parent);
	self:SetPosition(left,top);
  self:SetSize(width,height);
	self:SetMultiline(false);
	self:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self:SetForeColor(control2LightColor);
	self:SetText(" " .. text);
  
	self.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
	end
	self.MouseDoubleClick = function(sender,args)
    if (self:IsEnabled()) then self:SetChecked(not self:IsChecked()) end
	end
  
  self.SetEnabled = function(sender,enabled,keepValue)
    Turbine.UI.Lotro.CheckBox.SetEnabled(sender,enabled);
    
    if (enabled == false and not keepValue) then self:SetChecked(false) end
		self:SetForeColor(enabled and control2LightColor or controlDisabledColor);
	end
end
