
_G.TraitColorPicker = class(Turbine.UI.Control);

function TraitColorPicker:Constructor(parent,left,top,width,height,disabled)
  Turbine.UI.Control.Constructor(self);
  self:SetMouseVisible(false);
  
  self.disabled = disabled;
  
  if (parent ~= nil) then self:SetParent(parent) end
  if (left ~= nil) then self:SetLeft(left) end
  if (top ~= nil) then self:SetTop(top) end
  
  width = width or 80;
  height = height or 20;
  
  local gap = 20;
  local w = 14;
  local h = 14;
  local wTotal = w+2*Menu.selectionBorder;
  
  local x = (width-wTotal*3-gap*2)/2;
  local y = (height-h)/2;
  
  self.red = self:CreateIcon(x,y,w,h,L.Red[1],"Red",TraitConfigTextToColor("Red"));
  self.yellow = self:CreateIcon(x+wTotal+gap,y,w,h,L.Yellow[1],"Yellow",TraitConfigTextToColor("Yellow"));
  self.blue = self:CreateIcon(x+2*(wTotal+gap),y,w,h,L.Blue[1],"Blue",TraitConfigTextToColor("Blue"));
  
  self:SetSize(width,height);
end

function TraitColorPicker:CreateIcon(x,y,w,h,name,value,color)
  local icon = {}
	
  icon.name = name;
  icon.value = value;
  icon.baseColor = color;
  
  icon.selectionControls = {}
  table.insert(icon.selectionControls,self:BuildSelectionControl(x-Menu.selectionBorder,y-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,"top_left"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x,y-Menu.selectionBorder,w,Menu.selectionBorder,"top"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x+w,y-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,"top_right"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x-Menu.selectionBorder,y,Menu.selectionBorder,h,"left"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x+w,y,Menu.selectionBorder,h,"right"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x-Menu.selectionBorder,y+h,Menu.selectionBorder,Menu.selectionBorder,"bottom_left"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x,y+h,w,Menu.selectionBorder,"bottom"));
  table.insert(icon.selectionControls,self:BuildSelectionControl(x+w,y+h,Menu.selectionBorder,Menu.selectionBorder,"bottom_right"));
  
	icon.border = Turbine.UI.Control();
	icon.border:SetParent(self);
  icon.border:SetZOrder(1);
	icon.border:SetPosition(x,y);
	icon.border:SetSize(w,h);
	icon.border:SetMouseVisible(true);
	icon.border:SetBackColor(Turbine.UI.Color(0.35,0.5,0.4));
	
	icon.color = Turbine.UI.Control();
	icon.color:SetParent(icon.border);
  icon.color:SetZOrder(1);
	icon.color:SetPosition(1,1);
	icon.color:SetSize(w-2,h-2);
	icon.color:SetMouseVisible(false);
  icon.color:SetBackColor(self.disabled and Turbine.UI.Color(0.2,0.2,0.2) or Misc.SetShade(Misc.SimpleToGray(1,icon.baseColor,0.5),0.3,0.3));
  
  icon.border.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end
  
  icon.border.MouseClick = function(sender,args)
    if (self.disabled or icon == self.selected) then return end
    
    if (self.selected) then self:SetSelected(self.selected,false) end
    self.selected = icon;
    self:SetSelected(self.selected,true);
    
    if (self.SelectionChanged) then
      self:SelectionChanged(self.selected.name);
    end
  end
  
  icon.border.MouseEnter = function(sender,args)
    if (self.disabled) then return end
    
    for _,selectionControl in ipairs(icon.selectionControls) do
      selectionControl:SetVisible(true);
    end
  end
  
  icon.border.MouseLeave = function(sender,args)
    if (self.disabled) then return end
    
    for _,selectionControl in ipairs(icon.selectionControls) do
      selectionControl:SetVisible(self.selected == icon);
    end
  end
  
  return icon;
end

function TraitColorPicker:BuildSelectionControl(x,y,w,h,icon)
  local control = Turbine.UI.Control();
  control:SetParent(self);
  control:SetPosition(x,y);
  control:SetSize(w,h);
  control:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  control:SetBackground("CombatAnalysis/Resources/selected_control_"..icon..".tga");
  control:SetMouseVisible(false);
  control:SetVisible(false);
  return control;
end

function TraitColorPicker:SetSelected(icon,selected)
  icon.color:SetBackColor(selected and icon.baseColor or (self.disabled and Turbine.UI.Color(0.2,0.2,0.2) or Misc.SetShade(Misc.SimpleToGray(1,icon.baseColor,0.5),0.3,0.3)));
  
  for _,selectionControl in ipairs(icon.selectionControls) do
    selectionControl:SetVisible(selected);
  end
end

function TraitColorPicker:SetSelectedColor(color)
  if (self.selected) then self:SetSelected(self.selected,false) end
  self.selected = (color == "Red" and self.red or (color == "Yellow" and self.yellow or self.blue));
  self:SetSelected(self.selected,true);
end

function TraitColorPicker:SetEnabled(enabled)
  self.disabled = (not enabled);
  
  self.red.color:SetBackColor(self.selected == self.red and self.red.baseColor or (self.disabled and Turbine.UI.Color(0.2,0.2,0.2) or Misc.SetShade(Misc.SimpleToGray(1,self.red.baseColor,0.5),0.3,0.3)));
  self.yellow.color:SetBackColor(self.selected == self.yellow and self.yellow.baseColor or (self.disabled and Turbine.UI.Color(0.2,0.2,0.2) or Misc.SetShade(Misc.SimpleToGray(1,self.yellow.baseColor,0.5),0.3,0.3)));
  self.blue.color:SetBackColor(self.selected == self.blue and self.blue.baseColor or (self.disabled and Turbine.UI.Color(0.2,0.2,0.2) or Misc.SetShade(Misc.SimpleToGray(1,self.blue.baseColor,0.5),0.3,0.3)));
end

function TraitColorPicker:GetSelected()
  if (self.selected == nil) then return nil end
  
  return self.selected.name;
end
