
local RemoveIcon = class(Turbine.UI.Control);

function RemoveIcon:Constructor()
  Turbine.UI.Control.Constructor(self);
  
  self:SetSize(70,29);
  self:SetZOrder(1);
  
  self.icon = Turbine.UI.Control();
  self.icon:SetParent(self);
  self.icon:SetPosition(55,7);
  self.icon:SetSize(15,15);
  self.icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.icon:SetBackground("CombatAnalysis/Resources/remove_icon.tga");
  
  self.text = Turbine.UI.Label();
  self.text:SetParent(self);
  self.text:SetPosition(0,0);
  self.text:SetSize(50,29);
  self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
  self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	self.text:SetForeColor(Turbine.UI.Color(1,1,1));
end

_G.removeIcon = RemoveIcon();
