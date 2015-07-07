
--[[

A Bombat Analysis Window is a simple window with a cut off
title bar in the top right, and can be moved and resized.

It also includes a chat box style resize icon in the lower
right corner.

All content should be added to the "self.content" pane,
whose Layout() method, which should be overridden,
will determine how internal elements are displayed. There
is also a "self.titleContent" pane for adding content
to the title bar.

The "self.content" pane is located directly inside of the
window border. The "self.titleContent" pane is located
directly inside the title border, and excludes the cut
off area.

]]--

_G.CombatAnalysisTitleBar = class(Turbine.UI.Control);

function CombatAnalysisTitleBar:Constructor(window,backgroundColor,closable)
	Turbine.UI.Control.Constructor(self);
	
	self.window = window;
	self.gapSize = Misc.Round((CombatAnalysisWindow.titleBarHeight-16)/2);
	
	self:SetParent(self.window);
	self:SetBackColor(backgroundColor);
	self:SetMouseVisible(true);
	
	self.MouseDown = function(sender,args) self.window:MouseDown(args) end
	self.MouseUp = function(sender,args) self.window:MouseUp(args) end
	self.MouseMove = function(sender,args) self.window:MouseMove(args) end
	
	-- close button
	self.close = Turbine.UI.Control();
	self.close:SetParent(self);
	self.close:SetTop(self.gapSize);
	self.close:SetSize(16,16);
	self.close:SetZOrder(4);
	self.close:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2"..(closable and "" or "_sepia")..".tga");
	self.close.enabled = closable;
	self.close.pressed = false;
	self.close.MouseEnter = function(sender, args)
		if (self.close.enabled) then
			self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2_"..(self.close.pressed and "pressed" or "mouseover")..".tga");
		end
	end
	self.close.MouseLeave = function(sender, args)
		if (self.close.enabled) then
			self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2"..(self.close.pressed and "_mouseover" or "")..".tga");
		end
	end
	self.close.MouseDown = function(sender, args)
		WindowManager.MouseWasPressed(self.window);
		if (self.close.enabled) then
			self.close.pressed = true;
			self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2_pressed.tga");
		end
	end
	self.close.MouseUp = function(sender, args)
		if (self.close.enabled) then
			self.close.pressed = false;
			self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2.tga");
		end
	end
	self.close.MouseClick = function(sender, args)
		if (self.close.enabled) then
			self.window:Close();
		end
	end
  
  Misc.AddListener(nil,"windowsLocked",function(sender,args)
    self.close.enabled = not windowsLocked;
    self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2"..(windowsLocked and "_sepia" or "")..".tga");
  end, self, self);
	
	-- minimize button
	self.minimize = Turbine.UI.Control();
	self.minimize:SetParent(self);
	self.minimize:SetTop(self.gapSize);
	self.minimize:SetSize(16,16);
	self.minimize:SetZOrder(4);
	self.minimize:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_min.tga");
	self.minimize.pressed = false;
	self.minimize.MouseEnter = function(sender, args)
		if (self.window.minimized) then
			self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_max_"..(self.minimize.pressed and "pressed" or "mouseover")..".tga");
		else
			self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_min_"..(self.minimize.pressed and "pressed" or "mouseover")..".tga");
		end
	end
	self.minimize.MouseLeave = function(sender, args)
		if (self.window.minimized) then
			self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_max"..(self.minimize.pressed and "_mouseover" or "")..".tga");
		else
			self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_min"..(self.minimize.pressed and "_mouseover" or "")..".tga");
		end
	end
	self.minimize.MouseDown = function(sender, args)
		WindowManager.MouseWasPressed(self.window);
		self.minimize.pressed = true;
		self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_"..(self.window.minimized and "max" or "min").."_pressed.tga");
	end
	self.minimize.MouseUp = function(sender, args)
		self.minimize.pressed = false;
		self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_"..(self.window.minimized and "max" or "min")..".tga");
	end
	self.minimize.MouseClick = function(sender, args)
		self.window:Minimize();
		self.minimize:SetBackground("CombatAnalysis/Resources/titlebar_"..(self.window.minimized and "max" or "min").."_mouseover.tga");
	end
	self.minimize.MouseDoubleClick = function(sender, args)
		self.minimize:MouseClick(args);
	end
	
	-- menu button
	self.menu = Turbine.UI.Control();
	self.menu:SetParent(self);
	self.menu:SetTop(self.gapSize-1);
	self.menu:SetSize(17,17);
	self.menu:SetZOrder(4);
	self.menu:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.menu:SetBackground("CombatAnalysis/Resources/gears.tga");
	
	self.menu.pressed = false;
	
	self.menu.MouseEnter = function(sender, args)
    self.menu:SetBackground("CombatAnalysis/Resources/gears_mouseover.tga");
	end
	self.menu.MouseLeave = function(sender, args)
    self.menu:SetBackground("CombatAnalysis/Resources/gears"..(self.menu.pressed and "_mouseover" or "")..".tga");
	end
	self.menu.MouseDown = function(sender, args)
		WindowManager.MouseWasPressed(self.window);
		self.menu.pressed = true;
	end
	self.menu.MouseUp = function(sender, args)
		self.menu.pressed = false;
		self.menu:SetBackground("CombatAnalysis/Resources/gears.tga");
	end
	self.menu.MouseClick = function(sender, args)
    menuPane:SelectTab(1);
    Turbine.PluginManager.ShowOptions(Plugins["CombatAnalysis"]);
	end
	
	self:Layout();
end

function CombatAnalysisTitleBar:Layout()
	local w,h = self:GetSize();
	
	self.close:SetLeft(w-16-self.gapSize);
	self.minimize:SetLeft(w-2*(16+self.gapSize));
	self.menu:SetLeft(w-3*(16+self.gapSize)-self.gapSize);
end

function CombatAnalysisTitleBar:EnableClose(enable)
	self.close.enabled = enable;
	
	if (self.close.enabled) then
		self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2.tga");
	else
		self.close:SetBackground("CombatAnalysis/Resources/titlebar_X_2_sepia.tga");
	end
end
