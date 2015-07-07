
_G.MenuLabel = class(Turbine.UI.Label);

function MenuLabel:Constructor(parent,top,width,height,size)
	Turbine.UI.Label.Constructor(self);
	
  self:SetParent(parent);
  self:SetTop(top);
  self:SetSize(width,height);
	self:SetFont(size == "15" and Turbine.UI.Lotro.Font.TrajanPro15 or
              (size == "14" and Turbine.UI.Lotro.Font.TrajanPro14 or
                                Turbine.UI.Lotro.Font.TrajanPro13));
	self:SetForeColor(control2LightColor);
  self:SetMouseVisible(false);
end
