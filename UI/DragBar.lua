
_G.DragBar = class(Turbine.UI.Window);

Misc.DetermineLength("Click and drag to move panel",Turbine.UI.Lotro.Font.TrajanPro16);

-- attach a rotator to the control directly, so it can be scaled
function DragBar.PrepForRotation(control)  
  control.rotator = Turbine.UI.Control();
  control.rotator:SetParent(control);
  control.rotator:SetPosition(5, 5);
  control.rotator:SetSize(20, 20);
  control.rotator:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  control.rotator:SetBackground("CombatAnalysis/Resources/rotate_button_normal.tga");
  control.rotator:SetZOrder(99);
  control.rotator:SetVisible(false);
  control.rotator.mouseIn = false;
  control.rotator.pressed = false;
  
  control.rotator.MouseEnter = function(sender, args)
    control.rotator.mouseIn = true;
    control.rotator:SetBackground("CombatAnalysis/Resources/rotate_button_"..(control.rotator.pressed and "pressed" or "rollover")..".tga");
  end
  control.rotator.MouseLeave = function(sender, args)
    control.rotator.mouseIn = false;
    control.rotator:SetBackground("CombatAnalysis/Resources/rotate_button_"..(control.rotator.pressed and "rollover" or "normal")..".tga");
  end
  control.rotator.MouseDown = function(sender, args)
    if (args.Button == Turbine.UI.MouseButton.Left) then
      control.rotator.pressed = true;
      control.rotator:SetBackground("CombatAnalysis/Resources/rotate_button_pressed.tga");
    end
  end
  control.rotator.MouseUp = function(sender, args)
    if (args.Button == Turbine.UI.MouseButton.Left) then
      control.rotator.pressed = false;
      control.rotator:SetBackground("CombatAnalysis/Resources/rotate_button_"..(control.rotator.mouseIn and "rollover" or "normal")..".tga");
    end
  end
  control.rotator.MouseClick = function(sender, args)
    if (args.Button == Turbine.UI.MouseButton.Left) then
      if (control.Rotate) then control:Rotate() end
    end
  end
  control.rotator.MouseDoubleClick = function(sender, args)
    control.rotator:MouseClick(args);
  end
end

function DragBar:Constructor(target, name)
  Turbine.UI.Window.Constructor(self);
  
  self.target = nil;
  self.barOnTop = true;
  self.visible = false;
  self.draggable = false;
  
  self:SetMouseVisible(false);
  self:SetZOrder(1);
  
  -- grabber
  self.grabber = Turbine.UI.Control();
  self.grabber:SetParent(self);
  self.grabber:SetPosition(0, 0);
  self.grabber.mouseIn = false;
  self.grabber.dragging = false;
  
  self.grabber.MouseEnter = function(sender, args)
    self.grabber.mouseIn = true;
    
    self.shadowBox:SetVisible(true);
    cursorMove:SetWantsUpdates(true);
    cursorMove:Update();
    cursorMove:SetVisible(true);
  end
  self.grabber.MouseLeave = function(sender, args)
    self.grabber.mouseIn = false;
    
    if (not self.grabber.dragging) then
      self.shadowBox:SetVisible(false);
      cursorMove:SetVisible(false);
      cursorMove:SetWantsUpdates(false);
    end
  end
  self.grabber.MouseDown = function(sender, args)
    if (args.Button == Turbine.UI.MouseButton.Left and self.target ~= nil) then
      self.gem:SetBackground("CombatAnalysis/Resources/drag_gem_click.tga");
      self.label:SetBackground("CombatAnalysis/Resources/drag_bar_click.tga");
      self.dragStartX = args.X;
      self.dragStartY = args.Y;
      self.grabber.dragging = true;
      if (self.target.DragStart) then self.target:DragStart() end
    end
  end
  self.grabber.MouseMove = function(sender, args)
    if (self.grabber.dragging and self.target ~= nil) then
      local left, top = self.target:GetPosition();
      local width, height = self:GetSize();
      local x = left + (args.X - self.dragStartX);
      local y = top + (args.Y - self.dragStartY);
      x, y = WindowManager.ValidatePosition(x, y-20, width, height);
      
      self.target:SetPosition(x, y+20);
      self:Layout();
    end
  end
  self.grabber.MouseUp = function(sender, args)
    if (args.Button == Turbine.UI.MouseButton.Left and self.target ~= nil) then
      self.gem:SetBackground("CombatAnalysis/Resources/drag_gem.tga");
      self.label:SetBackground("CombatAnalysis/Resources/drag_bar.tga");
      self.grabber.dragging = false;
      if (self.target.DragEnd) then self.target:DragEnd() end
      
      if (not self.grabber.mouseIn) then
        self.shadowBox:SetVisible(false);
        cursorMove:SetVisible(false);
        cursorMove:SetWantsUpdates(false);
      end
    end
  end
  self.grabber.SizeChanged = function(sender, args)
    local width, height = sender:GetSize();
    self.label:SetSize(width - 21, 20);
  end
  
  TooltipManager.SetTooltip(self.grabber,name.."\nClick and drag to move panel",TooltipStyle.LOTRO,(Misc.texts[name] == nil and 250 or math.max(Misc.texts[name],Misc.texts["Click and drag to move panel"])),32);
  
  -- gem
  self.gem = Turbine.UI.Control();
  self.gem:SetParent(self.grabber);
  self.gem:SetSize(21, 20);
  self.gem:SetPosition(0, 0);
  self.gem:SetMouseVisible(false);
  self.gem:SetBackground("CombatAnalysis/Resources/drag_gem.tga");
  
  -- label
  self.label = Turbine.UI.Label();
  self.label:SetParent(self.grabber);
  self.label:SetPosition(21, 0);
  self.label:SetMultiline(false);
  self.label:SetFont(Turbine.UI.Lotro.Font.Verdana12);
  self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
  self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
  self.label:SetText(name);
  self.label:SetMouseVisible(false);
  self.label:SetBackground("CombatAnalysis/Resources/drag_bar.tga");
  
  -- shadow box
  self.shadowBox = Turbine.UI.Window();
  self.shadowBox:SetParent(self);
  self.shadowBox:SetPosition(0, 20);
  self.shadowBox:SetMouseVisible(false);
  self.shadowBox:SetVisible(false);
  self.shadowBox.SizeChanged = function(sender, args)
    local width, height = sender:GetSize();
    self.topLeft:SetPosition(0, 0);
    self.top:SetPosition(10, 0);
    self.topRight:SetPosition(width - 10, 0);
    self.bottomLeft:SetPosition(0, height - 10);
    self.bottom:SetPosition(10, height - 10);
    self.bottomRight:SetPosition(width - 10, height - 10);
    self.left:SetPosition(0, 10);
    self.right:SetPosition(width - 10, 10);
    
    self.top:SetWidth(width - 20);
    self.bottom:SetWidth(width - 20);
    self.left:SetHeight(height - 20);
    self.right:SetHeight(height - 20);
  end
  
  -- top left corner
  self.topLeft = Turbine.UI.Control();
  self.topLeft:SetParent(self.shadowBox);
  self.topLeft:SetSize(10, 10);
  self.topLeft:SetMouseVisible(false);
  self.topLeft:SetBackground("CombatAnalysis/Resources/drag_topleft.tga");

  -- topRight
  self.topRight = Turbine.UI.Control();
  self.topRight:SetParent(self.shadowBox);
  self.topRight:SetSize(10, 10);
  self.topRight:SetMouseVisible(false);
  self.topRight:SetBackground("CombatAnalysis/Resources/drag_topright.tga");
  
  -- bottomLeft
  self.bottomLeft = Turbine.UI.Control();
  self.bottomLeft:SetParent(self.shadowBox);
  self.bottomLeft:SetSize(10, 10);
  self.bottomLeft:SetMouseVisible(false);
  self.bottomLeft:SetBackground("CombatAnalysis/Resources/drag_bottomleft.tga");

  -- bottomRight
  self.bottomRight = Turbine.UI.Control();
  self.bottomRight:SetParent(self.shadowBox);
  self.bottomRight:SetSize(10, 10);
  self.bottomRight:SetMouseVisible(false);
  self.bottomRight:SetBackground("CombatAnalysis/Resources/drag_bottomright.tga");

  -- top side
  self.top = Turbine.UI.Control();
  self.top:SetParent(self.shadowBox);
  self.top:SetSize(0, 10);
  self.top:SetMouseVisible(false);
  self.top:SetBackground("CombatAnalysis/Resources/drag_topmid.tga");

  -- left side
  self.left = Turbine.UI.Control();
  self.left:SetParent(self.shadowBox);
  self.left:SetSize(10, 0);
  self.left:SetMouseVisible(false);
  self.left:SetBackground("CombatAnalysis/Resources/drag_midleft.tga");

  -- right side
  self.right = Turbine.UI.Control();
  self.right:SetParent(self.shadowBox);
  self.right:SetSize(10, 0);
  self.right:SetMouseVisible(false);
  self.right:SetBackground("CombatAnalysis/Resources/drag_midright.tga");
  
  -- bottom side
  self.bottom = Turbine.UI.Control();
  self.bottom:SetParent(self.shadowBox);
  self.bottom:SetSize(0, 10);
  self.bottom:SetMouseVisible(false);
  self.bottom:SetBackground("CombatAnalysis/Resources/drag_bottommid.tga");
  
  -- set the target
  self:SetTarget(target);
end

function DragBar:SetTarget(target)
  if (self.target ~= nil and self.target.rotator ~= nil) then
    self.target.rotator:SetVisible(false);
  end
  
  self.target = target;
  
  if (target ~= nil) then
    if (self.target.rotator ~= nil) then
      self.target.rotator:SetVisible(true);
    end
    self:Layout();
  end
end

function DragBar:SetBarOnTop(top)
  self.barOnTop = top;
  self:Layout();
end

function DragBar:SetVisible(visible)
  Turbine.UI.Window.SetVisible(self,visible);
  if (self.target ~= nil and self.target.rotator) then
    self.target.rotator:SetVisible(visible);
  end
end

function DragBar:SetBarVisible(visible)
  self.visible = visible;
  self.target:SetVisible(visible);
  self:SetVisible(visible and self.draggable or false);
end

function DragBar:SetDraggable(draggable)
  self.draggable = draggable;
  self:SetVisible(draggable and self.visible or false);
end

function DragBar:Layout()
  local width, height = self.target:GetSize();
  local x, y = self.target:GetPosition();
  
  self:SetSize(width, height + 20);
  self.grabber:SetSize(width, 20);
  self.shadowBox:SetSize(width, height);
  
  if (self.barOnTop) then
    self:SetPosition(x, math.max(y - 20, 0));
    self.grabber:SetPosition(0, 0);
    self.shadowBox:SetPosition(0, 20);
  else
    self:SetPosition(x, math.min(y, Turbine.UI.Display:GetHeight() - (20 + height)));
    self.grabber:SetPosition(0, height);
    self.shadowBox:SetPosition(0, 0);
  end
end
