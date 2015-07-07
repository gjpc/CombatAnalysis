
_G.Slider = class(Turbine.UI.Control);

-- colors
Slider.ItemColor = Turbine.UI.Color(245/255, 222/255, 147/255);
Slider.DisabledColor = Turbine.UI.Color(162/255, 162/255, 162/255);

function Slider:Constructor()
  Turbine.UI.Control.Constructor(self);
  
  self.step = 0.1;
  self.min = 0.5;
  self.max = 3;
  self.value = 0;
  self.format = "%1.1f";

  -- text label
  self.label = Turbine.UI.Label();
  self.label:SetParent(self);
  self.label:SetPosition(0, 0);
  self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.label:SetForeColor(Slider.ItemColor);
  self.label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
  self.label.MouseDown = function(sender,args)
    KeyManager.TakeFocus();
  end

  -- value label
  self.valueLabel = Turbine.UI.Label();
  self.valueLabel:SetParent(self);
  self.valueLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.valueLabel:SetForeColor(Slider.ItemColor);
  self.valueLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopRight);
  self.valueLabel:SetMouseVisible(false);

  -- left arrow
  self.leftArrow = Turbine.UI.Control();
  self.leftArrow:SetParent(self);
  self.leftArrow:SetBackground("CombatAnalysis/Resources/slider_leftarrow.tga");
  self.leftArrow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.leftArrow:SetSize(16,16);
  
  self.leftArrow.MouseDown = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      self.leftArrow:SetWantsUpdates(true);
      self.leftArrow:SetBackground("CombatAnalysis/Resources/slider_leftarrow_pressed.tga");
      self.leftArrow.tick = Turbine.Engine.GetGameTime();
      self.leftArrow.wait = true;
    end
  end
  self.leftArrow.MouseUp = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      self.leftArrow:SetWantsUpdates(false);
      self.leftArrow:SetBackground("CombatAnalysis/Resources/slider_leftarrow.tga");
      self:Decrement();
    end
  end
  self.leftArrow.Update = function(sender, args)
    local gameTime = Turbine.Engine.GetGameTime();
    if (self.leftArrow.wait) then
      if ((gameTime - self.leftArrow.tick) > .5) then
        self.leftArrow.wait = false;
      end        
    else
      if ((gameTime - self.leftArrow.tick) > .05) then
        self:Decrement();
        self.leftArrow.tick = gameTime;
      end
    end
  end

  -- right arrow
  self.rightArrow = Turbine.UI.Control();
  self.rightArrow:SetParent(self);
  self.rightArrow:SetBackground("CombatAnalysis/Resources/slider_rightarrow.tga");
  self.rightArrow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.rightArrow:SetSize(16,16);
  
  self.rightArrow.MouseDown = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      self.rightArrow:SetWantsUpdates(true);
      self.rightArrow:SetBackground("CombatAnalysis/Resources/slider_rightarrow_pressed.tga");
      self.rightArrow.tick = Turbine.Engine.GetGameTime();
      self.rightArrow.wait = true;
    end
  end
  self.rightArrow.MouseUp = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      self.rightArrow:SetWantsUpdates(false);
      self.rightArrow:SetBackground("CombatAnalysis/Resources/slider_rightarrow.tga");
      self:Increment();
    end
  end
  self.rightArrow.Update = function(sender, args)
    local gameTime = Turbine.Engine.GetGameTime();
    if (self.rightArrow.wait) then
      if ((gameTime - self.rightArrow.tick) > .5) then
        self.rightArrow.wait = false;
      end        
    else
      if ((gameTime - self.rightArrow.tick) > .05) then
        self:Increment();
        self.rightArrow.tick = gameTime;
      end
    end
  end

  -- slider area
  self.sliderBox = Turbine.UI.Control();
  self.sliderBox:SetParent(self);
  self.sliderBox:SetBackground("CombatAnalysis/Resources/slider_background.tga");
  self.sliderBox:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.sliderBox.MouseClick = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      local width = self.sliderBox:GetWidth() - 16;
      local x = args.X - 8;
      if (x < 0) then
        x = 0;
      end
      if(x > width) then
        x = width;
      end
      self.slider:SetPosition(x, 0);
      self:UpdateValueFromPosition();
    end
  end

  -- slider widget
  self.slider = Turbine.UI.Control();
  self.slider:SetParent(self.sliderBox);
  self.slider:SetBackground("CombatAnalysis/Resources/slider_widget.tga");
  self.slider:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.slider:SetSize(16,16)
  self.slider.MouseDown = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      self.slider.dragStartX = args.X;
      self.slider.dragging = true;
    end
  end
  self.slider.MouseUp = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (args.Button == Turbine.UI.MouseButton.Left) then
      self.slider.dragging = false;
    end
  end
  self.slider.MouseMove = function(sender, args)
    if (not self:IsEnabled()) then
      return;
    end

    if (self.slider.dragging) then
      local left, top = self.slider:GetPosition();
      local width = self.sliderBox:GetWidth() - 16;
      
      local x = left - self.slider.dragStartX + args.X;
      if (x < 0) then
        x = 0;
      end
      if(x > width) then
        x = width;
      end
      self.slider:SetPosition(x, 0);
      self:UpdateValueFromPosition();
    end
  end    
end

function Slider:SetText(text)
  self.label:SetText(text);
end

function Slider:SetSize(width, height)
  Turbine.UI.Control.SetSize(self, width, height);
  self:Layout();
end

function Slider:SetEnabled(enabled)
  Turbine.UI.Control.SetEnabled(self, enabled);
  if (enabled) then
    self.label:SetForeColor(ComboBox.ItemColor);
    self.valueLabel:SetForeColor(ComboBox.ItemColor);
    self.slider:SetBackground("CombatAnalysis/Resources/slider_widget.tga");
  else
    self.label:SetForeColor(Slider.DisabledColor);
    self.valueLabel:SetForeColor(Slider.DisabledColor);
    self.slider:SetBackground("CombatAnalysis/Resources/slider_widget_ghosted.tga");
  end
end

function Slider:Layout()
  local width, height = self:GetSize();
  
  self.label:SetSize(width * 0.8, 20);
  self.valueLabel:SetSize(width * 0.2, 20);
  self.valueLabel:SetPosition(width * 0.8, 0);

  self.sliderBox:SetSize(width - 56, 16);
  self.sliderBox:SetPosition(28, 21);
  
  self.leftArrow:SetPosition(12, 21);
  self.rightArrow:SetPosition(width - 28, 21);
  
  -- update the slider position from the value now that our size has changed
  self:UpdatePositionFromValue();
end

function Slider:UpdateValueFromPosition()
  local x, y = self.slider:GetPosition();
  local width = self.sliderBox:GetWidth() - 16;
  local ppv = width / ((self.max - self.min) / self.step);

  self.value = (math.floor(x / ppv) * self.step) + self.min;
  self.valueLabel:SetText(string.format(self.format, self.value));
  
  if (self.ValueChanged) then self:ValueChanged(self.value) end
end

function Slider:UpdatePositionFromValue()
  local width = self.sliderBox:GetWidth() - 16;
  local ppv = width / ((self.max - self.min) / self.step);

  local x = (self.value - self.min) * ppv / self.step;
  self.slider:SetPosition(x, 0);
end

function Slider:SetValue(value)
  self.value = value;
  self.valueLabel:SetText(string.format(self.format, self.value));
  self:UpdatePositionFromValue();

  if (self.ValueChanged) then self:ValueChanged(self.value) end
end

function Slider:GetValue()
  return self.value;
end

function Slider:SetStep(step)
  self.step = step;
end

function Slider:SetMin(min)
  self.min = min;
end

function Slider:SetMax(max)
  self.max = max;
end

function Slider:SetFormat(format)
  self.format = format;
end

function Slider:Increment()
  local value = self.value + self.step;
  if (value > self.max) then
    value = self.max;
  end
  self:SetValue(value);
end

function Slider:Decrement()
  local value = self.value - self.step;
  if (value < self.min) then
    value = self.min;
  end
  self:SetValue(value);
end