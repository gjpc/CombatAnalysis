
_G.AddRemove = class(Turbine.UI.Control);

function AddRemove:Constructor(addText, removeText, addGap, removeGap, removeEnabled)
  Turbine.UI.Control.Constructor(self);
  
  addText = addText or L.Add;
  removeText = removeText or L.Remove;
  addGap = addGap or 20;
  removeGap = removeGap or 40;
  
  self:SetSize(80+addGap+removeGap,15);
  self:SetMouseVisible(false);
  
  self.addControl = Turbine.UI.Control();
  self.addControl:SetParent(self);
  self.addControl:SetPosition(0,0);
  self.addControl:SetSize(40+addGap-5,15);
  
  self.addControl.MouseEnter = function(sender,args)
    self.addLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.addLabel:SetText(self.addLabel:GetText());
  end
  self.addControl.MouseLeave = function(sender,args)
    self.addLabel:SetFontStyle(Turbine.UI.FontStyle.None);
    self.addLabel:SetText(self.addLabel:GetText());
  end
  
  self.addIcon = Turbine.UI.Control();
  self.addIcon:SetParent(self.addControl);
  self.addIcon:SetPosition(0,0);
  self.addIcon:SetSize(15,15);
  self.addIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.addIcon:SetBackground("CombatAnalysis/Resources/add_icon.tga");
  self.addIcon:SetMouseVisible(false);
  
  self.addLabel = MenuLabel(self.addControl,0,20+addGap-5,15);
  self.addLabel:SetLeft(20);
  self.addLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.addLabel:SetText(addText);
  self.addLabel:SetOutlineColor(controlColor);
  self.addLabel:SetMouseVisible(false);
  
  self.removeControl = Turbine.UI.Control();
  self.removeControl:SetParent(self);
  self.removeControl:SetPosition(40+addGap,0);
  self.removeControl:SetSize(40+removeGap-5,15);
  self.removeControl.disabled = (not removeEnabled);
  
  self.removeControl.SetEnabled = function(sender,enabled)
    self.removeControl.disabled = not enabled;
    
    if (self.removeControl.disabled) then self.removeLabel:SetFontStyle(Turbine.UI.FontStyle.None) end
    self.removeLabel:SetForeColor(self.removeControl.disabled and LabelledComboBox.DisabledColor or control2LightColor);
    self.removeIcon:SetBackground("CombatAnalysis/Resources/remove_icon"..(self.removeControl.disabled and "_disabled" or "")..".tga");
  end
  
  self.removeControl.MouseEnter = function(sender,args)
    if (self.removeControl.disabled) then return end
    
    self.removeLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.removeLabel:SetText(self.removeLabel:GetText());
  end
  self.removeControl.MouseLeave = function(sender,args)
    if (self.removeControl.disabled) then return end
    
    self.removeLabel:SetFontStyle(Turbine.UI.FontStyle.None);
    self.removeLabel:SetText(self.removeLabel:GetText());
  end
  
  self.removeIcon = Turbine.UI.Control();
  self.removeIcon:SetParent(self.removeControl);
  self.removeIcon:SetPosition(0,1);
  self.removeIcon:SetSize(15,15);
  self.removeIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.removeIcon:SetBackground("CombatAnalysis/Resources/remove_icon"..(self.removeControl.disabled and "_disabled" or "")..".tga");
  self.removeIcon:SetMouseVisible(false);
  
  self.removeLabel = MenuLabel(self.removeControl,0,20+removeGap-5,15);
  self.removeLabel:SetLeft(20);
  self.removeLabel:SetForeColor(self.removeControl.disabled and LabelledComboBox.DisabledColor or control2LightColor);
  self.removeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
  self.removeLabel:SetOutlineColor(controlColor);
  self.removeLabel:SetText(removeText);
  self.removeLabel:SetMouseVisible(false);
end

