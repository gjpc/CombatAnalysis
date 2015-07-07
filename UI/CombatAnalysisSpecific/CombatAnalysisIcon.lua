
-- 1) Context Menu Items

local MenuItem = class(Turbine.UI.Control);

MenuItem.GradiantBlue = 0x41101B27;
MenuItem.GradiantBlueReversed = 0x41101D9B;

function MenuItem:Constructor(text,icon,clickFunction)
	Turbine.UI.Control.Constructor(self);
  
	self.clickFunction = clickFunction;
	self.mouseInside = false;
	
	self:SetSize(240,33);
	self:SetBackColor(Turbine.UI.Color(1,0,0,0));
	
  self.background = Turbine.UI.Control();
	self.background:SetParent(self);
	self.background:SetSize(240,33);
	self.background:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.background:SetBackground(MenuItem.GradiantBlue);
  self.background:SetMouseVisible(false);
  
	self.labelBackground = Turbine.UI.Control();
	self.labelBackground:SetParent(self);
	self.labelBackground:SetSize(240,32);
	self.labelBackground:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.labelBackground:SetBackColor(Turbine.UI.Color(0,0,0));
	self.labelBackground:SetMouseVisible(false);
	
	self.label = Turbine.UI.Label();
	self.label:SetParent(self.labelBackground);
	self.label:SetSize(190,32);
  self.label:SetPosition(40,0);
	self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.label:SetForeColor(Turbine.UI.Color(1,1,1));
	self.label:SetMouseVisible(false);
	self.label:SetText(text);
  
  self.icon = Turbine.UI.Control();
  self.icon:SetParent(self);
	self.icon:SetMouseVisible(false);
  self.icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.icon:SetBackground(icon);
  self.icon:SetStretchMode(2);
  local width,height = self.icon:GetSize();
  self.icon:SetStretchMode(0);
  self.icon:SetSize(width,height);
  self.icon:SetPosition(10+(20-width)/2,6+(20-height)/2);
  
	self.MouseEnter = function(sender,args)
		self.mouseInside = true;
		self.labelBackground:SetBackColor(Turbine.UI.Color(0,0,0,0));
	end
	
	self.MouseLeave = function(sender,args) 
		self.labelBackground:SetBackColor(Turbine.UI.Color(0,0,0));
		self.mouseInside = false;
	end
	
	self.MouseDown = function(sender,args)
		self:SetBackground(MenuItem.GradiantBlueReversed);
	end
	
	self.MouseUp = function(sender,args)
		self:SetBackground(GradiantBlue);
	end
  
  self.MouseClick = function(sender,args)
    clickFunction(self,args);
  end
  
  self.MouseDoubleClick = function(sender,args)
    clickFunction(self,args);
  end
end

-- 2) Main Context Menu

local Menu = class(Turbine.UI.Window);
function Menu:Constructor(commands)
	Turbine.UI.Window.Constructor(self);
	
	self:SetSize(250,33);
  
  self.borders = Turbine.UI.Control();
	self.borders:SetParent(self);
  self.borders:SetMouseVisible(false);
	self.borders:SetZOrder(100);
	self.borders:SetSize(250,33);
  
  self.topLeft = Turbine.UI.Control();
  self.topLeft:SetParent(self.borders);
  self.topLeft:SetMouseVisible(false);
  self.topLeft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.topLeft:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.topLeft:SetBackground(0x41108A8A);
  self.topLeft:SetStretchMode(2);
  self.topLeftWidth = self.topLeft:GetWidth();
  self.topLeftHeight = self.topLeft:GetHeight();
  self.topLeft:SetStretchMode(0);
  
  self.top = Turbine.UI.Control();
  self.top:SetParent(self.borders);
  self.top:SetMouseVisible(false);
  self.top:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.top:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.top:SetBackground(0x41108A8B);
  self.top:SetStretchMode(2);
  self.top:SetStretchMode(0);
  
  self.topRight = Turbine.UI.Control();
  self.topRight:SetParent(self.borders);
  self.topRight:SetMouseVisible(false);
  self.topRight:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.topRight:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.topRight:SetBackground(0x41108A89);
  self.topRight:SetStretchMode(2);
  self.topRightWidth = self.topRight:GetWidth();
  self.topRightHeight = self.topRight:GetHeight();
  self.topRight:SetStretchMode(0);
  
  self.right = Turbine.UI.Control();
  self.right:SetParent(self.borders);
  self.right:SetMouseVisible(false);
  self.right:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.right:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.right:SetBackground(0x41108A90);
  self.right:SetStretchMode(2);
  self.rightWidth = self.right:GetWidth();
  self.right:SetStretchMode(0);
  
  self.bottomRight = Turbine.UI.Control();
  self.bottomRight:SetParent(self.borders);
  self.bottomRight:SetMouseVisible(false);
  self.bottomRight:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.bottomRight:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.bottomRight:SetBackground(0x41108A8F);
  self.bottomRight:SetStretchMode(2);
  self.bottomRightWidth = self.bottomRight:GetWidth();
  self.bottomRightHeight = self.bottomRight:GetHeight();
  self.bottomRight:SetStretchMode(0);
  
  self.bottom = Turbine.UI.Control();
  self.bottom:SetParent(self.borders);
  self.bottom:SetMouseVisible(false);
  self.bottom:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.bottom:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.bottom:SetBackground(0x41108A8E);
  self.bottom:SetStretchMode(2);
  self.bottomHeight = self.bottom:GetHeight();
  self.bottom:SetStretchMode(0);
  
  self.bottomLeft = Turbine.UI.Control();
  self.bottomLeft:SetParent(self.borders);
  self.bottomLeft:SetMouseVisible(false);
  self.bottomLeft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.bottomLeft:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.bottomLeft:SetBackground(0x41108A8D);
  self.bottomLeft:SetStretchMode(2);
  self.bottomLeftWidth = self.bottomLeft:GetWidth();
  self.bottomLeftHeight = self.bottomLeft:GetHeight();
  self.bottomLeft:SetStretchMode(0);
  
  self.left = Turbine.UI.Control();
  self.left:SetParent(self.borders);
  self.left:SetMouseVisible(false);
  self.left:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.left:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.left:SetBackground(0x41108A8C);
  self.left:SetStretchMode(2);
  self.left:SetStretchMode(0);
  
  local topItem = 5;
  local offset = 33;
  
  if self:GetTop() > Turbine.UI.Display.GetHeight() / 2 then 
		offset = -33;
		topItem = height - 5 - 33;
		self:SetTop(self:GetTop() - height);
	end
  
  self.menuItems = {}
  
	for i,command in ipairs(commands) do
		local menuItem = MenuItem(command[1],command[2],command[3]);
		menuItem:SetParent(self);
		menuItem:SetLeft(5);
    menuItem:SetTop(topItem);
    
    table.insert(self.menuItems, menuItem);
    topItem = topItem + offset;
	end
  
	self:SetHeight(10 + 33 * #commands);
  self:Layout();
end

function Menu:Layout()
  self.borders:SetHeight(self:GetHeight());
  
  self.topLeft:SetPosition(0,0);
  self.topRight:SetPosition(self:GetWidth() - self.topRightWidth,0);
  self.bottomRight:SetPosition(self:GetWidth() - self.bottomRightWidth,self:GetHeight() - self.bottomRightHeight);	
  self.bottomLeft:SetPosition(0,self:GetHeight() - self.bottomLeftHeight);
  
  self.top:SetWidth(self:GetWidth() - self.topLeftWidth - self.topRightWidth);
  self.top:SetPosition(self.topLeftWidth,0);
  self.right:SetPosition(self:GetWidth() - self.rightWidth,self.topRightHeight);
  self.right:SetHeight(self:GetHeight() - self.topRightHeight - self.bottomRightHeight);
  self.bottom:SetPosition(self.bottomLeftWidth,self:GetHeight() - self.bottomHeight);
  self.bottom:SetWidth(self:GetWidth() - self.bottomLeftWidth - self.bottomRightWidth);
  self.left:SetPosition(0,self.topLeftHeight);
  self.left:SetHeight(self:GetHeight() - self.topLeftHeight - self.bottomLeftHeight);
end

-- 3) The Combat Analysis Icon itself

local CombatAnalysisIcon = class(Turbine.UI.Window);

CombatAnalysisIcon.frames = 18;
CombatAnalysisIcon.animationSpeed = 0.8;

function CombatAnalysisIcon:Constructor()
	Turbine.UI.Window.Constructor(self);
  
  table.insert(allWindows,self);
  
  self:SetZOrder(1);
  self:SetMouseVisible(false);
  
  self.hidden = false;
  self.locked = false;
  
  Misc.DetermineLength(L.CombatAnalysis[2]..": "..L.Logo,Turbine.UI.Lotro.Font.TrajanPro16);
  
  DragBar.PrepForRotation(self);
  
  Misc.AddListener(nil,"UILocked",function(sender,locked)
    self.locked = locked;
    if (self.locked) then
      self.dragBar = DragBar(self,L.CombatAnalysis[2]..": "..L.Logo);
      self.dragBar:SetBarVisible(not self.hidden and showCombatAnalysisIcon);
      self.dragBar:SetDraggable(true);
      self.SizeChanged = function(sender,args)
        self.dragBar:Layout();
      end
      
      Misc.AddCallback(self.dragBar,"MouseEnter",function(sender,args) self:MouseEnter(args) end);
      Misc.AddCallback(self.dragBar,"MouseLeave",function(sender,args) self:MouseLeave(args) end);
      
    else
      if (self.dragBar ~= nil) then
        self.dragBar:SetDraggable(false);
        self.dragBar:SetTarget(nil);
        self.dragBar = nil;
      end
      self.SizeChanged = nil;
    end
    
  end,self,self);
  
  Misc.AddListener(nil,"UIHidden",function(sender,hidden)
    self.hidden = hidden;
    if (self.dragBar ~= nil) then
      self.dragBar:SetVisible(not self.hidden and showCombatAnalysisIcon);
    end
    
  end,self,self);
  
  self.w = 70;
  self.h = 150;
  
  self.rotated = false;
  
  self.combines = 0;
	self.saves = 0;
	self.loads = 0;
	
	self.prevTimestamp = 0;
  
  self:SetOpacity(0.4);
  
  self.mainIcon = Turbine.UI.Control();
  self.mainIcon:SetParent(self);
  self.mainIcon:SetBackground("CombatAnalysis/Resources/logo.tga");
  self.mainIcon:SetPosition((self.w-40)/2,5);
  self.mainIcon:SetSize(40,40);
  
  self.mainIcon.MouseEnter = function(sender,args) self:MouseEnter(args) end
  self.mainIcon.MouseLeave = function(sender,args) self:MouseLeave(args) end
  self.mainIcon.MouseDown = function(sender,args) self:MouseDown(args) end
  self.mainIcon.MouseClick = function(sender,args) self:MouseClick(args) end
  self.mainIcon.MouseDoubleClick = function(sender,args) self:MouseDoubleClick(args) end
  
  self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetPosition(0,55);
	self.text:SetSize(self.w,self.h-55);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	self.text:SetForeColor(Turbine.UI.Color(0.6,0.55,0.55));
	self.text:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.text:SetOutlineColor(Turbine.UI.Color(0.03,0,0));
	self.text:SetMouseVisible(false);
	
	self.icon = Turbine.UI.Control();
	self.icon:SetParent(self);
	self.icon:SetPosition(0,0);
  self.icon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.icon:SetSize(50,50);
  self.icon:SetPosition((self.w-50)/2,0);
	self.icon:SetMouseVisible(false);
  self.icon:SetVisible(false);
	
	self.icon.Update = function()
		local count = Misc.Round(((Turbine.Engine.GetGameTime()-self.startTime)%CombatAnalysisIcon.animationSpeed)*(CombatAnalysisIcon.frames/CombatAnalysisIcon.animationSpeed));
		
		if (count ~= self.count) then
			self.count = count;
			self.icon:SetBackground("CombatAnalysis/Resources/load_animation_"..math.min(CombatAnalysisIcon.frames-1,self.count)..".tga");
		end
	end
  
  self.menu = Menu({
    
    {L.LockWindows,"CombatAnalysis/Resources/button_lock_normal_normal.tga",function(sender,args)
      self:LockWindows(not windowsLocked);
    end},
    
    {L.SaveData,"CombatAnalysis/Resources/save.tga",function(sender,args)
      fileSelectDialog:Show(true);
      self.menu:SetVisible(false);
    end},
    
    {L.LoadData,"CombatAnalysis/Resources/load.tga",function(sender,args)
      fileSelectDialog:Show(false);
      self.menu:SetVisible(false);
    end},
    
    {L.OpenTheMenu,"CombatAnalysis/Resources/gears.tga",function(sender,args)
      menuPane:SelectTab(1);
			Turbine.PluginManager.ShowOptions(Plugins["CombatAnalysis"]);
      self.menu:SetVisible(false);
    end}
    
  });
  
  self.lockMenuItem = self.menu.menuItems[1];
  
  self.menu:SetZOrder(30);
  
  self.menu.SetVisible = function(sender,visible)
    Turbine.UI.Window.SetVisible(sender,visible);
    if (visible) then self.menu:Activate() end
    self:SetOpacity((visible or self.mouseIn or self.dragging or self.icon:GetWantsUpdates()) and 1 or 0.4);
  end
  
  self.menu.Deactivated = function(sender,args)
    self.menu:SetVisible(false);
    self.menu.deactivatedAt = Turbine.Engine.GetGameTime();
  end
  
  self:SetSize(self.w,self.h);
  self:SetVisible(true);
end

function CombatAnalysisIcon:LockWindows(lock,dontSave)
  Misc.SetValue(nil, "windowsLocked", lock);
  settings.windowsLocked = windowsLocked;
  
  self.lockMenuItem.label:SetText(windowsLocked and L.UnlockWindows or L.LockWindows);
  self.lockMenuItem.icon:SetBackground("CombatAnalysis/Resources/button_lock_"..(windowsLocked and "highlight" or "normal").."_normal.tga");
  
  for _,window in ipairs(statOverviewWindows) do window:WindowsLocked() end
  for _,window in ipairs(statOverviewStatsWindows) do window:WindowsLocked() end
  
  if (not dontSave) then SaveSettings() end
end

function CombatAnalysisIcon:ShowHideWindows(hide,dontSave)
  _G.windowsHidden = hide;
  settings.windowsHidden = windowsHidden;
  self.mainIcon:SetBackground("CombatAnalysis/Resources/logo"..(windowsHidden and "_disabled" or "")..".tga");
  
  WindowManager.ShowHideWindows(statOverviewWindows, false, windowsHidden, self);
  WindowManager.ShowHideWindows(statOverviewStatsWindows, false, windowsHidden, self);
  
  if (not dontSave) then SaveSettings() end
end

function CombatAnalysisIcon:Rotate()
  self.rotated = not self.rotated;
  
  self.mainIcon:SetTop(self.rotated and self.h-45 or 5);
  self.icon:SetTop(self.rotated and self.h-50 or 0);
  self.text:SetTop(self.rotated and 0 or 55);
  self.text:SetTextAlignment(self.rotated and Turbine.UI.ContentAlignment.BottomCenter or Turbine.UI.ContentAlignment.TopCenter);
  
  self:SaveState();
end

function CombatAnalysisIcon:MouseEnter(args)
  self.mouseIn = true;
  self:SetOpacity(1);
end

function CombatAnalysisIcon:MouseLeave(args)
  self.mouseIn = false;
  self:SetOpacity((self.dragging or self.icon:GetWantsUpdates() or self.menu:IsVisible()) and 1 or 0.4);
end

function CombatAnalysisIcon:DragStart()
  self.dragging = true;
  self:SetOpacity(1);
end

function CombatAnalysisIcon:DragEnd()
  self.dragging = false;
  self:SetOpacity((self.mouseIn or self.icon:GetWantsUpdates() or self.menu:IsVisible()) and 1 or 0.4);
end

function CombatAnalysisIcon:MouseDown(args)
  self.mouseDownAt = Turbine.Engine.GetGameTime();
end

function CombatAnalysisIcon:MouseClick(args)
  if (self.menu.deactivatedAt == self.mouseDownAt or self.menu.deactivatedAt == Turbine.Engine.GetGameTime()) then return end
  
  -- show/hide all windows
  if (args.Button == Turbine.UI.MouseButton.Left) then
    self:ShowHideWindows(not windowsHidden);
  end
  
  -- show the mini menu
  if (args.Button == Turbine.UI.MouseButton.Right and not windowsHidden) then
    self.menu:SetVisible(true);
    
    local x = self:GetLeft()+(self.w-50)/2;
    local y = self:GetTop()+self.mainIcon:GetTop()+51;
    y = (y+self.menu:GetHeight() >= Turbine.UI.Display.GetHeight() and self:GetTop()+self.mainIcon:GetTop()-6-self.menu:GetHeight() or y);
    x,y = WindowManager.ValidatePosition(x,y,self.menu:GetWidth(),self.menu:GetHeight());
    self.menu:SetPosition(x,y);
  end
end

function CombatAnalysisIcon:MouseDoubleClick(args)
  self:MouseClick(args);
end

--[[
function CombatAnalysisIcon:SetSize(width,height)
  WindowManager.ScaleWindow(self,width,height);
  if (self.dragBar) then self.dragBar:Layout() end
end
]]--

function CombatAnalysisIcon:CombineStart()
	self.combines = self.combines+1;
	self:UpdateText();
	if (self.combines == 1 and self.saves == 0 and self.loads == 0) then self:Start() end
end

function CombatAnalysisIcon:SaveStart()
	self.saves = self.saves+1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 1 and self.loads == 0) then self:Start() end
end

function CombatAnalysisIcon:LoadStart()
	self.loads = self.loads+1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 1) then self:Start() end
end

function CombatAnalysisIcon:CombineEnd()
	self.combines = self.combines-1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 0) then self:Stop() end
end

function CombatAnalysisIcon:SaveEnd()
	self.saves = self.saves-1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 0) then self:Stop() end
end

function CombatAnalysisIcon:LoadEnd()
	self.loads = self.loads-1;
	self:UpdateText();
	if (self.combines == 0 and self.saves == 0 and self.loads == 0) then self:Stop() end
end

function CombatAnalysisIcon:UpdateText()
	local text = "";
	if (self.combines > 0) then text = text .. self.combines .. "x " .. (self.combines > 1 and L.Combines or L.Combine) .. ((self.saves > 0 or self.loads > 0) and "\n" or "") end
	if (self.saves > 0) then text = text .. self.saves .. "x " .. (self.saves > 1 and L.Saves or L.Save) .. (self.loads > 0 and "\n" or "") end
	if (self.loads > 0) then text = text .. self.loads .. "x " .. (self.loads > 1 and L.Loads or L.Load) end
	
	self:SetVisible(false);
	self.text:SetText(text);
	self:SetVisible(true);
end

function CombatAnalysisIcon:Start()
	self.startTime = Turbine.Engine.GetGameTime();
	
	self.icon:SetWantsUpdates(true);
	self.icon:SetVisible(true);
  
  self:SetOpacity(1);
end

function CombatAnalysisIcon:Stop()
	self.icon:SetWantsUpdates(false);
	self.icon:SetVisible(false);
  
  self:SetOpacity((self.mouseIn or self.dragging or self.menu:IsVisible()) and 1 or 0.4);
end

function CombatAnalysisIcon:SetPosition(x,y,dontSave)
  Turbine.UI.Window.SetPosition(self,x,y);
  self.x,self.y = self:GetPosition();
  
  if (not dontSave) then self:SaveState() end
end

function CombatAnalysisIcon:SaveState()
  settings.logo = {["x"] = EncodeNumbers(self.x), ["y"] = EncodeNumbers(self.y), ["rotated"] = self.rotated}
  
  SaveSettings();
end

function CombatAnalysisIcon:RestoreState(state)
  -- default location
  if (state.x == nil) then
    state.x = ((Turbine.UI.Display.GetWidth()-self.w)/2);
  end
  if (state.y == nil) then
    state.y = ((Turbine.UI.Display.GetHeight()-self.h)/2 - 90);
  end
  
  local x,y = WindowManager.ValidatePosition(state.x,state.y,self.w,self.h);
  self:SetPosition(x,y,true);
  if (state.rotated) then self:Rotate() end
end

_G.combatAnalysisIcon = CombatAnalysisIcon();
