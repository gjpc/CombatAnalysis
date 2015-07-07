
_G.ColorPicker = class(Turbine.UI.Control);

function ColorPicker:Constructor(parent)
  Turbine.UI.Control.Constructor(self);
  
  self.minAlpha = 40/255;
  
  self.enabled = true;
  
  self.r = 0;
  self.g = 0;
  self.b = 0;
  self.a = 0;
  
  self:SetSize(140,140);
  
  self.redLabel = self:CreateLabel(4,L.Red[2]);
  self.greenLabel = self:CreateLabel(29,L.Green[2]);
  self.blueLabel = self:CreateLabel(54,L.Blue[2]);
  self.alphaLabel = self:CreateLabel(79,L.Alpha[2]);
  
  self.redBorder = self:CreateBorder("red",5);
  self.greenBorder = self:CreateBorder("green",30);
  self.blueBorder = self:CreateBorder("blue",55);
  self.alphaBorder = self:CreateBorder("alpha",80);
  
  self.alphaBackground = self:CreateAlphaBackground(81);
  
  self.reds = {}
  self.greens = {}
  self.blues = {}
  self.alphas = {}
  
  for x=19,85 do
    table.insert(self.reds,self:CreatePickerControl(x,6));
    table.insert(self.greens,self:CreatePickerControl(x,31));
    table.insert(self.blues,self:CreatePickerControl(x,56));
    table.insert(self.alphas,self:CreatePickerControl(x,81,true));
  end
  
  self.redArrow = self:CreateArrow(self.redBorder,"red",14);
  self.redTextBox = self:CreateTextBox(self.redBorder,"red",3);
  self.redBorder.arrow = self.redArrow;
  
  self.greenArrow = self:CreateArrow(self.greenBorder,"green",39);
  self.greenTextBox = self:CreateTextBox(self.greenBorder,"green",28);
  self.greenBorder.arrow = self.greenArrow;
  
  self.blueArrow = self:CreateArrow(self.blueBorder,"blue",64);
  self.blueTextBox = self:CreateTextBox(self.blueBorder,"blue",53);
  self.blueBorder.arrow = self.blueArrow;
  
  self.alphaArrow = self:CreateArrow(self.alphaBorder,"alpha",89);
  self.alphaTextBox = self:CreateTextBox(self.alphaBorder,"alpha",78);
  self.alphaBorder.arrow = self.alphaArrow;
  
  self.displayBorder = self:CreateDisplayBorder(107);
  
  self.displays = {}
  
  for y=1,18 do
    table.insert(self.displays,self:CreateDisplay(y));
  end
  
  self.defaultButton = Turbine.UI.Lotro.Button();
  self.defaultButton:SetParent(self);
  self.defaultButton:SetPosition(53,107);
  self.defaultButton:SetSize(75,20);
  self.defaultButton:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.defaultButton:SetForeColor(control2LightColor);
  self.defaultButton:SetText(L.Default);
  
  self.defaultButton.MouseClick = function(sender,args)
    self:SetAllColors(self.defaultColor,true);
  end
end

function ColorPicker:CreateLabel(top,text)
  local label = MenuLabel(self,top,15,13,"14");
  label:SetText(text..":");
  return label;
end

function ColorPicker:CreateBorder(color,top)
  local border = Turbine.UI.Control();
  border:SetParent(self);
  border:SetSize(69,13);
  border:SetPosition(18,top);
  border:SetBackColor(Turbine.UI.Color(1,1,1));
  
  border.MouseEnter = function(sender,args)
    if (not self.enabled) then return end
    
    sender.arrow:SetBackground("CombatAnalysis/Resources/color_picker_arrow_mouseover.tga");
  end
  
  border.MouseLeave = function(sender,args)
    if (not self.enabled) then return end
    
    if (not sender.pressed and not sender.arrow.pressed) then
      sender.arrow:SetBackground("CombatAnalysis/Resources/color_picker_arrow.tga");
    end
  end
  
  border.MouseDown = function(sender,args)
    if (not self.enabled) then return end
    
    sender.pressed = true;
    
    sender.argsX = args.X;
    self:SetColor(color,math.max((color == "alpha" and (self.minAlpha*65) or 0),math.min(65,args.X))/65);
    
    sender:Focus();
  end
  
  border.MouseMove = function(sender,args)
    if (sender.pressed) then
      self:SetColor(color,math.max((color == "alpha" and (self.minAlpha*65) or 0),math.min(65,args.X))/65);
    end
  end
  
  border.MouseUp = function(sender,args)
    sender.pressed = false;
    sender.arrow:SetBackground("CombatAnalysis/Resources/color_picker_arrow.tga");
  end
  
  return border;
end

function ColorPicker:CreateAlphaBackground(top)
  local alphaBackground = Turbine.UI.Control();
  alphaBackground:SetParent(self);
  alphaBackground:SetSize(67,11);
  alphaBackground:SetPosition(19,top);
  alphaBackground:SetBackground("CombatAnalysis/Resources/transparent_background.tga");
  alphaBackground:SetMouseVisible(false);
  return alphaBackground;
end

function ColorPicker:CreatePickerControl(x,top,alpha)
  local pickerControl = Turbine.UI.Control();
  pickerControl:SetParent(self);
  pickerControl:SetSize(1,11);
  pickerControl:SetPosition(x,top);
  pickerControl:SetMouseVisible(false);
  if (alpha) then
    pickerControl:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  end
  return pickerControl;
end

function ColorPicker:CreateArrow(border,color,top)
  local arrow = Turbine.UI.Control();
  arrow:SetParent(self);
  arrow:SetZOrder(1);
  arrow:SetSize(8,8);
  arrow:SetPosition(16,top);
  arrow:SetBackground("CombatAnalysis/Resources/color_picker_arrow.tga");
  arrow:SetBlendMode(4);
  
  arrow.MouseEnter = function(sender,args)
    if (not self.enabled) then return end
    border.MouseEnter(border,args);
  end
  
  arrow.MouseLeave = function(sender,args)
    if (not self.enabled) then return end
    border.MouseLeave(border,args);
  end
  
  arrow.MouseDown = function(sender,args)
    if (not self.enabled) then return end
    
    sender.pressed = true;
    
    sender.argsX = args.X;
    sender.startX = sender:GetLeft();
    
    sender:Focus();
  end
  
  arrow.MouseMove = function(sender,args)
    if (sender.pressed) then
      local newX = math.max(16+(color == "alpha" and (self.minAlpha*65) or 0),math.min(16+65,sender.startX+(args.X-sender.argsX)+(sender:GetLeft() - sender.startX)));
      self:SetColor(color,(newX-16)/65);
    end
  end
  
  arrow.MouseUp = function(sender,args)
    sender.pressed = false;
  end
  
  return arrow;
end

function ColorPicker:CreateTextBox(border,color,top)
  local textBox = Turbine.UI.Lotro.TextBox();
  textBox:SetParent(self);
  textBox:SetPosition(92,top);
  textBox:SetSize(40,17);
  textBox:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
  textBox:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
  textBox:SetMultiline(false);
  
  textBox.border = border;
  
	textBox.FocusGained = function(sender,args)
    sender.startText = sender:GetText();
		sender.text = sender:GetText();
		sender:SetWantsUpdates(true);
	end
	
	textBox.FocusLost = function(sender,args)
		sender:SetWantsUpdates(false);
    
    if (not textBox.border.pressed) then
      local value = tonumber(sender.text);
      if (value ~= nil) then
        local roundedValue = tonumber(string.format("%.0f",value));
        roundedValue = math.max((color == "alpha" and self.minAlpha or 0),math.min(255,roundedValue));
        self:SetColor(color,roundedValue/255);
      else
        sender:SetText(sender.startText);
      end
    end
    
    sender.startText = nil;
    sender.text = nil;
	end
  
  textBox.Update = function(sender,args)
    -- determine if the text has changed (as there is no event that does this for us)
    local text = sender:GetText();
    if (text == sender.text) then return end
    sender.text = text;
    
    local value = tonumber(sender.text);
    if (value ~= nil) then
      local roundedValue = string.format("%.0f",value);
      if (roundedValue == sender.text and value >= 0 and value <= 255) then
        self:SetColor(color,value/255,true);
      end
    end
  end
  
  return textBox;
end

function ColorPicker:CreateDisplayBorder(top)
  local displayBorder = Turbine.UI.Control();
  displayBorder:SetParent(self);
  displayBorder:SetPosition(23,top);
  displayBorder:SetSize(20,20);
  displayBorder:SetBackColor(Turbine.UI.Color(1,1,1));
  
  local displayBackground = Turbine.UI.Control();
  displayBackground:SetParent(displayBorder);
  displayBackground:SetPosition(1,1);
  displayBackground:SetSize(18,18);
  displayBackground:SetBackground("CombatAnalysis/Resources/transparent_background.tga");
  
  return displayBorder;
end

function ColorPicker:CreateDisplay(y)
  local display = Turbine.UI.Control();
  display:SetParent(self.displayBorder);
  display:SetPosition(1,y);
  display:SetSize(18,1);
  display:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  return display;
end

function ColorPicker:SetEnabled(enabled)
  self.enabled = enabled;
  
  self.redArrow:SetLeft(16);
  self.greenArrow:SetLeft(16);
  self.blueArrow:SetLeft(16);
  self.alphaArrow:SetLeft(16);
  
  self.redTextBox:SetText("0");
  self.greenTextBox:SetText("0");
  self.blueTextBox:SetText("0");
  self.alphaTextBox:SetText("0");
  
  self.redTextBox:SetEnabled(enabled);
  self.greenTextBox:SetEnabled(enabled);
  self.blueTextBox:SetEnabled(enabled);
  self.alphaTextBox:SetEnabled(enabled);
  
  self.defaultButton:SetEnabled(enabled);
  
  if (enabled) then
    self:SetAllColors(Turbine.UI.Color(self.a,self.r,self.g,self.b),false,true);
    
  else
    for i=1,18 do
      self.displays[i]:SetBackColor(controlDisabledColor);
    end
  
    local colorsToChange = { self.reds, self.greens, self.blues, self.alphas }
    
    for color,controls in pairs(colorsToChange) do
      for _,control in pairs(controls) do
        control:SetBackColor(controlDisabledColor);
      end
    end
  end
end

function ColorPicker:SetAllColors(color,fireEvent,updateAnyway)
  local updateNeeded = (color.R ~= self.r or color.G ~= self.g or color.B ~= self.B);
  if (not updateNeeded and color.A == self.a and not updateAnyway) then return end
  
  self.r = color.R;
  self.redArrow:SetLeft(16+(color.R*65));    
  if (not dontUpdateTextBox) then self.redTextBox:SetText(string.format("%.0f",tostring(color.R*255))) end

  self.g = color.G;
  self.greenArrow:SetLeft(16+(color.G*65));
  if (not dontUpdateTextBox) then self.greenTextBox:SetText(string.format("%.0f",tostring(color.G*255))) end

  self.b = color.B;
  self.blueArrow:SetLeft(16+(color.B*65));
  if (not dontUpdateTextBox) then self.blueTextBox:SetText(string.format("%.0f",tostring(color.B*255))) end
  
  self.a = math.max(self.minAlpha,color.A);
  self.alphaArrow:SetLeft(16+(color.A*65));
  if (not dontUpdateTextBox) then self.alphaTextBox:SetText(string.format("%.0f",tostring(color.A*255))) end
  
  if (updateNeeded) then self:UpdateColors("",not fireEvent) end
end

function ColorPicker:SetColor(color,value,dontUpdateTextBox)
  if (color == "red") then
    self.r = value;
    self.redArrow:SetLeft(16+(value*65));
    if (not dontUpdateTextBox) then self.redTextBox:SetText(string.format("%.0f",tostring(value*255))) end
  elseif (color == "green") then
    self.g = value;
    self.greenArrow:SetLeft(16+(value*65));
    if (not dontUpdateTextBox) then self.greenTextBox:SetText(string.format("%.0f",tostring(value*255))) end
  elseif (color == "blue") then
    self.b = value;
    self.blueArrow:SetLeft(16+(value*65));
    if (not dontUpdateTextBox) then self.blueTextBox:SetText(string.format("%.0f",tostring(value*255))) end
  else
    value = math.max(self.minAlpha,value);
    
    self.a = value;
    self.alphaArrow:SetLeft(16+(value*65));
    if (not dontUpdateTextBox) then self.alphaTextBox:SetText(string.format("%.0f",tostring(value*255))) end
  end
  
  self:UpdateColors(color);
end

function ColorPicker:UpdateColors(changedColor,dontFireEvent)
  local color = self:GetColor();
  
  if (not dontFireEvent and self.ColorChanged) then
    self:ColorChanged(color);
  end
  
  for i=1,18 do
    self.displays[i]:SetBackColor(Turbine.UI.Color(1-((i-1)/18)*(1-self.a),self.r,self.g,self.b));
  end
  
  if (changedColor == "alpha") then return end
  
  local colorsToChange = {}
  
  colorsToChange["alpha"] = self.alphas;
  if (changedColor ~= "red") then colorsToChange["red"] = self.reds end
  if (changedColor ~= "green") then colorsToChange["green"] = self.greens end
  if (changedColor ~= "blue") then colorsToChange["blue"] = self.blues end
  
  for i=1,67 do
    local perc = (i-1)/66;
    
    for color,controls in pairs(colorsToChange) do
      if (color == "red") then
        controls[i]:SetBackColor(Turbine.UI.Color(perc,self.g,self.b));
      elseif (color == "green") then
        controls[i]:SetBackColor(Turbine.UI.Color(self.r,perc,self.b));
      elseif (color == "blue") then
        controls[i]:SetBackColor(Turbine.UI.Color(self.r,self.g,perc));
      else
        controls[i]:SetBackColor(Turbine.UI.Color(perc,self.r,self.g,self.b));
      end
    end
  end
end

function ColorPicker:GetColor()
  return Turbine.UI.Color(self.a,self.r,self.g,self.b);
end
