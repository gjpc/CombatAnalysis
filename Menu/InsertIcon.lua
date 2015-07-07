
local InsertIcon = class(Turbine.UI.Control);

function InsertIcon:Constructor()
  Turbine.UI.Control.Constructor(self);
  
  self:SetSize(70,29);
  self:SetZOrder(2);
  
  self.icon = Turbine.UI.Control();
  self.icon:SetParent(self);
  self.icon:SetPosition(0,7);
  self.icon:SetSize(12,11);
  self.icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.icon:SetBackground("CombatAnalysis/Resources/insert_icon.tga");
  
  self.text = Turbine.UI.Label();
  self.text:SetParent(self);
  self.text:SetPosition(20,0);
  self.text:SetSize(50,29);
  self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	self.text:SetForeColor(Turbine.UI.Color(1,1,1));
end

_G.insertIcon = InsertIcon();
