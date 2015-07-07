
--[[

A Combat Analysis Window is a simple window with a cut off
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

_G.CombatAnalysisWindow = class(Turbine.UI.Window);

-- some configurable properties
CombatAnalysisWindow.border = 3;                 -- the thickness of the window border
CombatAnalysisWindow.resizeHangover = 3;         -- how far outside the window the mouse can be to resize it
CombatAnalysisWindow.resizeWidth = 9;            -- the total width (not including hangover) of the resize zone
CombatAnalysisWindow.resizeCornerWidth = 13;     -- the total width of the resize zone in corners
CombatAnalysisWindow.lowerRightResizeWidth = 17; -- the total width of the resize zone in the lower right corner (where the resize icon is located)
CombatAnalysisWindow.defaultTitleBarWidth = 39;  -- the default width of the title bar (not including borders or cutoff)
CombatAnalysisWindow.smallTitleBarWidth = 37;    -- the width of the minimized title bar
CombatAnalysisWindow.titleBarHeight = 20;        -- the height of the title bar (not including borders)
CombatAnalysisWindow.defaultMinWidth = 84;       -- the default window minimum width (NB:includes overhang, and will usually be overriden)
CombatAnalysisWindow.defaultMinHeight = 55;      -- the default window minimum height (NB:includes overhang, and will usually be overriden)
CombatAnalysisWindow.minimizeDuration = 0.1;     -- the time in seconds of the minimize animation

function CombatAnalysisWindow:Constructor(windowSet,showBackground,backgroundOpacity,showBottomRightIcon,includeTopLeftResize,hasTitleBar,titleBarWidth,closable,id)
	Turbine.UI.Window.Constructor(self);
	
	table.insert(allWindows,self);
	if (windowSet ~= nil) then
		table.insert(windowSet,self);
	end
	
	if (id == nil) then
		self.id = idCounter;
		idCounter = idCounter + 1;
	else
		self.id = id;
	end
	
	self:SetMouseVisible(false);
	
	self.mouseDown = false;
	self.minimumWidth = CombatAnalysisWindow.defaultMinWidth;
	self.minimumHeight = CombatAnalysisWindow.defaultMinHeight;
	self.minimumBorderHeight = 0;
	
	self.hasTitleBar = hasTitleBar;
  Misc.SetValue(self,"titleBarWidth",(titleBarWidth == nil and CombatAnalysisWindow.defaultTitleBarWidth or titleBarWidth));
	
	self.minimized = false;
	self.resizable = true;
	
	self.windowSet = windowSet; -- the set of windows that this window belongs to (ie: all stat overview windows are in the same set)
	Misc.SetValue(self,"showBackground",showBackground);
	self.backgroundOpacity = backgroundOpacity;
	self.showBottomRightIcon = showBottomRightIcon;
	self.includeTopLeftResize = includeTopLeftResize;	
	
	-- filler to hide resize issues with the title bar
	self.filler = Turbine.UI.Control();
	self.filler:SetParent(self);
	self.filler:SetZOrder(-2);
	self.filler:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.filler:SetMouseVisible(true);
	self.filler.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
	end
	
	-- title border pane
	self.titleBorder = Turbine.UI.Control();
	self.titleBorder:SetParent(self);
	self.titleBorder:SetZOrder(0);
	self.titleBorder:SetMouseVisible(false);
	self.titleBorder:SetBackColor(borderColor);
	
	-- title content pane
	self.titleContent = CombatAnalysisTitleBar(self,backgroundColor,closable);
	
	-- cut off pane
	self.cutOff = Turbine.UI.Control();
	self.cutOff:SetParent(self);
	self.cutOff:SetZOrder(-1);
	self.cutOff:SetSize(15,26);
	self.cutOff:SetMouseVisible(true);
	self.cutOff:SetBackground("CombatAnalysis/Resources/cutoff.tga");
	self.cutOff:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.cutOff.MouseDown = function(sender,args) self:MouseDown(args) end
	self.cutOff.MouseUp = function(sender,args) self:MouseUp(args) end
	self.cutOff.MouseMove = function(sender,args) self:MouseMove(args) end
	
	-- border pane
	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetZOrder(0);
	self.border:SetMouseVisible(false);
	self.border:SetBackColor(borderColor);
	if (not showBackground) then self.border:SetHeight(self.minimumBorderHeight) end
	
	-- content pane
	self.content = Turbine.UI.Control();
	self.content:SetParent(self);
	self.content:SetZOrder(1);
	self.content:SetMouseVisible(false);
	if (showBackground) then
		self.content:SetBackColor(Turbine.UI.Color(backgroundOpacity,darkBackgroundColor.R,darkBackgroundColor.G,darkBackgroundColor.B));
	else
		self.content:SetBackColor(Turbine.UI.Color(0,0,0,0));
	end
	
	-- resize icon (lower right)
	self.resizeIcon = Turbine.UI.Control();
	self.resizeIcon:SetParent(self);
	self.resizeIcon:SetSize(16,16);
	self.resizeIcon:SetZOrder(2);
	self.resizeIcon:SetMouseVisible(false);
	self.resizeIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.resizeIcon:SetBackground("CombatAnalysis/Resources/chat_resize_widget.tga");
	if not showBottomRightIcon then self.resizeIcon:SetVisible(false) end
	
	-- top left resize arrow
	self.topLeftResize = Turbine.UI.Control();
	self.topLeftResize:SetParent(self);
	self.topLeftResize:SetSize(CombatAnalysisWindow.resizeCornerWidth,CombatAnalysisWindow.resizeCornerWidth);
	self.topLeftResize:SetZOrder(3);
	self.topLeftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.topLeftResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local newX = oldX+(args.X-self.startX);
			local newY = oldY+(args.Y-self.startY);
			local newW = self.startW+self.changeX-(args.X-self.startX);
			local newH = self.startH+self.changeY-(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(newX,newY,newW,newH,self.minimumWidth,self.minimumHeight,true,true,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeX = self.changeX-(x-oldX);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.topLeftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > CombatAnalysisWindow.resizeCornerWidth or args.Y < 0 or args.Y > CombatAnalysisWindow.resizeCornerWidth) then
				cursorDiagonalDownward:SetVisible(false);
				cursorDiagonalDownward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topLeftResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorDiagonalDownward:SetWantsUpdates(true);
    cursorDiagonalDownward:Update();
    cursorDiagonalDownward:SetVisible(true);
	end
	self.topLeftResize.MouseLeave = function(sender,args)
		if (not self.mouseDown) then
			cursorDiagonalDownward:SetVisible(false);
			cursorDiagonalDownward:SetWantsUpdates(false);
		end
	end
	
	if (not includeTopLeftResize) then
		self.topLeftResize:SetMouseVisible(false);
	end
	
	-- top right resize arrow
	self.topRightResize = Turbine.UI.Control();
	self.topRightResize:SetParent(self);
	self.topRightResize:SetSize(CombatAnalysisWindow.resizeCornerWidth,CombatAnalysisWindow.resizeCornerWidth);
	self.topRightResize:SetZOrder(3);
	self.topRightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.topRightResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local newY = oldY+(args.Y-self.startY);
			local oldW,oldH = self:GetSize();
			local newW = self.startW+self.changeX+(args.X-self.startX);
			local newH = self.startH+self.changeY-(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,newY,newW,newH,self.minimumWidth,self.minimumHeight,true,false,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeX = self.changeX+(w-oldW);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.topRightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > CombatAnalysisWindow.resizeCornerWidth or args.Y < 0 or args.Y > CombatAnalysisWindow.resizeCornerWidth) then
				cursorDiagonalUpward:SetVisible(false);
				cursorDiagonalUpward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topRightResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorDiagonalUpward:SetWantsUpdates(true);
    cursorDiagonalUpward:Update();
    cursorDiagonalUpward:SetVisible(true);
	end
	self.topRightResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorDiagonalUpward:SetVisible(false);
			cursorDiagonalUpward:SetWantsUpdates(false);
		end
	end
	
	-- bottom left resize arrow
	self.bottomLeftResize = Turbine.UI.Control();
	self.bottomLeftResize:SetParent(self);
	self.bottomLeftResize:SetSize(CombatAnalysisWindow.resizeCornerWidth,CombatAnalysisWindow.resizeCornerWidth);
	self.bottomLeftResize:SetZOrder(3);
	self.bottomLeftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.bottomLeftResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local newX = oldX+(args.X-self.startX);
			local oldW,oldH = self:GetSize();
			local newW = self.startW+self.changeX-(args.X-self.startX);
			local newH = self.startH+self.changeY+(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(newX,oldY,newW,newH,self.minimumWidth,self.minimumHeight,false,true,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeX = self.changeX-(x-oldX);
			self.changeY = self.changeY+(h-oldH);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.bottomLeftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > CombatAnalysisWindow.resizeCornerWidth or args.Y < 0 or args.Y > CombatAnalysisWindow.resizeCornerWidth) then
				cursorDiagonalUpward:SetVisible(false);
				cursorDiagonalUpward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.bottomLeftResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorDiagonalUpward:SetWantsUpdates(true);
    cursorDiagonalUpward:Update();
    cursorDiagonalUpward:SetVisible(true);
	end
	self.bottomLeftResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorDiagonalUpward:SetVisible(false);
			cursorDiagonalUpward:SetWantsUpdates(false);
		end
	end
	
	-- bottom right resize arrow
	self.bottomRightResize = Turbine.UI.Control();
	self.bottomRightResize:SetParent(self);
	self.bottomRightResize:SetSize(CombatAnalysisWindow.lowerRightResizeWidth,CombatAnalysisWindow.lowerRightResizeWidth);
	self.bottomRightResize:SetZOrder(3);
	self.bottomRightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.bottomRightResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local oldW,oldH = self:GetSize();
			local newW = self.startW+self.changeX+(args.X-self.startX);
			local newH = self.startH+self.changeY+(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,oldY,newW,newH,self.minimumWidth,self.minimumHeight,false,false,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeX = self.changeX+(w-oldW);
			self.changeY = self.changeY+(h-oldH);
			
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.bottomRightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > CombatAnalysisWindow.lowerRightResizeWidth or args.Y < 0 or args.Y > CombatAnalysisWindow.lowerRightResizeWidth) then
				cursorDiagonalDownward:SetVisible(false);
				cursorDiagonalDownward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.bottomRightResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorDiagonalDownward:SetWantsUpdates(true);
    cursorDiagonalDownward:Update();
    cursorDiagonalDownward:SetVisible(true);
	end
	self.bottomRightResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorDiagonalDownward:SetVisible(false);
			cursorDiagonalDownward:SetWantsUpdates(false);
		end
	end
	
	-- top center left resize arrow
	self.topCenterLeftResize = Turbine.UI.Control();
	self.topCenterLeftResize:SetParent(self);
	self.topCenterLeftResize:SetHeight(CombatAnalysisWindow.resizeWidth);
	self.topCenterLeftResize:SetZOrder(2);
	self.topCenterLeftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.topCenterLeftResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local newY = oldY+(args.Y-self.startY);
			local oldW,oldH = self:GetSize();
			local newH = self.startH+self.changeY-(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,newY,oldW,newH,self.minimumWidth,self.minimumHeight,true,false,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.topCenterLeftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > self.topCenterLeftResize:GetWidth() or args.Y < 0 or args.Y > CombatAnalysisWindow.resizeWidth) then
				cursorVertical:SetVisible(false);
				cursorVertical:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topCenterLeftResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorVertical:SetWantsUpdates(true);
    cursorVertical:Update();
    cursorVertical:SetVisible(true);
	end
	self.topCenterLeftResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorVertical:SetVisible(false);
			cursorVertical:SetWantsUpdates(false);
		end
	end
	
	if (not includeTopLeftResize) then
		self.topCenterLeftResize:SetMouseVisible(false);
	end
	
	-- top center right resize arrow
	self.topCenterRightResize = Turbine.UI.Control();
	self.topCenterRightResize:SetParent(self);
	self.topCenterRightResize:SetHeight(CombatAnalysisWindow.resizeWidth);
	self.topCenterRightResize:SetZOrder(2);
	self.topCenterRightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.topCenterRightResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local newY = oldY+(args.Y-self.startY);
			local oldW,oldH = self:GetSize();
			local newH = self.startH+self.changeY-(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,newY,oldW,newH,self.minimumWidth,self.minimumHeight,true,false,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.topCenterRightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > self.topCenterRightResize:GetWidth() or args.Y < 0 or args.Y > CombatAnalysisWindow.resizeWidth) then
				cursorVertical:SetVisible(false);
				cursorVertical:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topCenterRightResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorVertical:SetWantsUpdates(true);
    cursorVertical:Update();
    cursorVertical:SetVisible(true);
	end
	self.topCenterRightResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorVertical:SetVisible(false);
			cursorVertical:SetWantsUpdates(false);
		end
	end
	
	-- left resize arrow
	self.leftResize = Turbine.UI.Control();
	self.leftResize:SetParent(self);
	self.leftResize:SetWidth(CombatAnalysisWindow.resizeWidth);
	self.leftResize:SetZOrder(2);
	self.leftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.leftResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local newX = oldX+(args.X-self.startX);
			local oldW,oldH = self:GetSize();
			local newW = self.startW+self.changeX-(args.X-self.startX);
			
			local x,y,w,h = WindowManager.ValidateSize(newX,oldY,newW,oldH,self.minimumWidth,self.minimumHeight,false,true,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeX = self.changeX-(x-oldX);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.leftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > CombatAnalysisWindow.resizeWidth or args.Y < 0 or args.Y > self.leftResize:GetHeight()) then
				cursorHorizontal:SetVisible(false);
				cursorHorizontal:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.leftResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorHorizontal:SetWantsUpdates(true);
    cursorHorizontal:Update();
    cursorHorizontal:SetVisible(true);
	end
	self.leftResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorHorizontal:SetVisible(false);
			cursorHorizontal:SetWantsUpdates(false);
		end
	end
	
	-- right resize arrow
	self.rightResize = Turbine.UI.Control();
	self.rightResize:SetParent(self);
	self.rightResize:SetWidth(CombatAnalysisWindow.resizeWidth);
	self.rightResize:SetZOrder(2);
	self.rightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.rightResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local oldW,oldH = self:GetSize();
			local newW = self.startW+self.changeX+(args.X-self.startX);
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,oldY,newW,oldH,self.minimumWidth,self.minimumHeight,false,false,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeX = self.changeX+(w-oldW);
			
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.rightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > CombatAnalysisWindow.resizeWidth or args.Y < 0 or args.Y > self.rightResize:GetHeight()) then
				cursorHorizontal:SetVisible(false);
				cursorHorizontal:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.rightResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorHorizontal:SetWantsUpdates(true);
    cursorHorizontal:Update();
    cursorHorizontal:SetVisible(true);
	end
	self.rightResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorHorizontal:SetVisible(false);
			cursorHorizontal:SetWantsUpdates(false);
		end
	end
	
	-- bottom resize arrow
	self.bottomResize = Turbine.UI.Control();
	self.bottomResize:SetParent(self);
	self.bottomResize:SetHeight(CombatAnalysisWindow.resizeWidth);
	self.bottomResize:SetZOrder(2);
	self.bottomResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    if (windowsLocked) then return end
    
		_G.mouseDown = true;
		self.mouseDown = true;
		self.startX,self.startY = args.X,args.Y;
		self.startW,self.startH = self:GetSize();
		self.changeX,self.changeY = 0,0;
	end
	self.bottomResize.MouseMove = function(sender,args)
		if self.mouseDown then
			local oldX,oldY = self:GetPosition();
			local oldW,oldH = self:GetSize();
			local newH = self.startH+self.changeY+(args.Y-self.startY);
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,oldY,oldW,newH,self.minimumWidth,self.minimumHeight,false,false,
																									self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																									CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
			self.changeY = self.changeY+(h-oldH);
			
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true);
		end
	end
	self.bottomResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > self.bottomResize:GetWidth() or args.Y < 0 or args.Y > CombatAnalysisWindow.resizeWidth) then
				cursorVertical:SetVisible(false);
				cursorVertical:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.bottomResize.MouseEnter = function(sender,args)
		if (_G.mouseDown or windowsLocked) then return end
    
    cursorVertical:SetWantsUpdates(true);
    cursorVertical:Update();
    cursorVertical:SetVisible(true);
	end
	self.bottomResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorVertical:SetVisible(false);
			cursorVertical:SetWantsUpdates(false);
		end
	end
	
	if (not showBackground) then self:SetResizable(false) end
end

function CombatAnalysisWindow:Layout()
	self:LayoutTitle();
	
	local w,h = self:GetSize();
	
	self.resizeIcon:SetPosition(w - CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.border - 17, h - CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.border - 17);
	
	self.bottomLeftResize:SetPosition(0, h - CombatAnalysisWindow.resizeCornerWidth);
	self.bottomRightResize:SetPosition(w - CombatAnalysisWindow.lowerRightResizeWidth, h - CombatAnalysisWindow.lowerRightResizeWidth);
	self.bottomResize:SetPosition(0 , h - CombatAnalysisWindow.resizeWidth);
	self.bottomResize:SetWidth(w - 2*CombatAnalysisWindow.resizeCornerWidth);
	
	-- layout the window with a title bar
	if (self.hasTitleBar) then
		self.topLeftResize:SetPosition(0, CombatAnalysisWindow.border + CombatAnalysisWindow.titleBarHeight);
		self.leftResize:SetPosition(0, CombatAnalysisWindow.border + CombatAnalysisWindow.titleBarHeight + CombatAnalysisWindow.resizeCornerWidth);
		self.leftResize:SetHeight(h - CombatAnalysisWindow.border - CombatAnalysisWindow.titleBarHeight - 2*CombatAnalysisWindow.resizeCornerWidth);
		
		self.border:SetPosition(CombatAnalysisWindow.resizeHangover,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight);
		if (self.showBackground) then
			self.border:SetSize(w - 2*CombatAnalysisWindow.resizeHangover,h - CombatAnalysisWindow.border - CombatAnalysisWindow.titleBarHeight - 2*CombatAnalysisWindow.resizeHangover);
		else
			self.border:SetSize(w - 2*CombatAnalysisWindow.resizeHangover,math.min(self.minimumBorderHeight,h - CombatAnalysisWindow.border - CombatAnalysisWindow.titleBarHeight - 2*CombatAnalysisWindow.resizeHangover));
		end
		
		self.content:SetPosition(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border,CombatAnalysisWindow.resizeHangover+2*CombatAnalysisWindow.border+CombatAnalysisWindow.titleBarHeight);
		self.content:SetSize(w - 2*CombatAnalysisWindow.resizeHangover - 2*CombatAnalysisWindow.border,h - 2*CombatAnalysisWindow.resizeHangover - 3*CombatAnalysisWindow.border - CombatAnalysisWindow.titleBarHeight);
	
	-- layout the window with no title bar
	else
		self.topLeftResize:SetPosition(0, 0);
		self.leftResize:SetPosition(0, CombatAnalysisWindow.resizeCornerWidth);
		self.leftResize:SetHeight(h - 2*CombatAnalysisWindow.resizeCornerWidth);
		
		self.border:SetPosition(CombatAnalysisWindow.resizeHangover,CombatAnalysisWindow.resizeHangover);
		if (self.showBackground) then
			self.border:SetSize(w - 2*CombatAnalysisWindow.resizeHangover,h - 2*CombatAnalysisWindow.resizeHangover);
		else
			self.border:SetSize(w - 2*CombatAnalysisWindow.resizeHangover,self.minimumBorderHeight);
		end
		
		self.content:SetPosition(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border);
		self.content:SetSize(w - 2*CombatAnalysisWindow.resizeHangover - 2*CombatAnalysisWindow.border,h - 2*CombatAnalysisWindow.resizeHangover - 2*CombatAnalysisWindow.border);
	end
	
	self.filler:SetSize(w,h);
	
	if (self.content.Layout ~= nil) then
		self.content:Layout();
	end
end

function CombatAnalysisWindow:LayoutTitle()
	local w,h = self:GetSize();
	
	-- if the window has no title bar, or the title bar w is zero, ensure its not visible, and adjust the resize arrows accordingly
	if (self.hasTitleBar and self.titleBarWidth > 0) then
		self.topCenterRightResize:SetMouseVisible(self.resizable);
		self.topRightResize:SetMouseVisible(self.resizable);
		
		self.topRightResize:SetPosition(w - CombatAnalysisWindow.resizeCornerWidth, 0);
		self.topCenterLeftResize:SetPosition(CombatAnalysisWindow.resizeCornerWidth, CombatAnalysisWindow.border + CombatAnalysisWindow.titleBarHeight);
		self.topCenterLeftResize:SetWidth(w - 2*CombatAnalysisWindow.resizeCornerWidth - (self.titleBarWidth + 2*CombatAnalysisWindow.border + CombatAnalysisWindow.resizeHangover));
		self.topCenterRightResize:SetPosition(w - self.titleBarWidth - 2*CombatAnalysisWindow.border - CombatAnalysisWindow.resizeHangover, 0);
		self.topCenterRightResize:SetWidth(self.titleBarWidth + 2*CombatAnalysisWindow.border + CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.resizeCornerWidth);
		self.rightResize:SetPosition(w - CombatAnalysisWindow.resizeWidth, CombatAnalysisWindow.resizeCornerWidth);
		self.rightResize:SetHeight(h - 2*CombatAnalysisWindow.resizeCornerWidth);
		
		local titleBarWidth = math.min(self.titleBarWidth,w - CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.border - 15);
		
		self.titleBorder:SetPosition(w - CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.border - titleBarWidth, CombatAnalysisWindow.resizeHangover);
		self.titleBorder:SetSize(titleBarWidth + CombatAnalysisWindow.border, 2*CombatAnalysisWindow.border + CombatAnalysisWindow.titleBarHeight);
		self.titleContent:SetPosition(w - CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.border - titleBarWidth, CombatAnalysisWindow.resizeHangover + CombatAnalysisWindow.border);
		self.titleContent:SetSize(titleBarWidth, CombatAnalysisWindow.titleBarHeight);
		
		self.cutOff:SetPosition(w - CombatAnalysisWindow.resizeHangover - CombatAnalysisWindow.border - titleBarWidth - 15, CombatAnalysisWindow.resizeHangover);
		
		self.titleBorder:SetVisible(true);
		self.titleContent:SetVisible(true);
		self.cutOff:SetVisible(true);
		
	-- otherwise, layout the title bar
	else
		self.topCenterRightResize:SetMouseVisible(false);
		self.topRightResize:SetMouseVisible(self.includeTopLeftResize);
		
		self.topRightResize:SetPosition(w - CombatAnalysisWindow.resizeCornerWidth, 0);
		
		self.topCenterLeftResize:SetPosition(CombatAnalysisWindow.resizeCornerWidth, 0);
		self.topCenterLeftResize:SetWidth(w - 2*CombatAnalysisWindow.resizeCornerWidth);
		self.rightResize:SetPosition(w - CombatAnalysisWindow.resizeWidth, CombatAnalysisWindow.resizeCornerWidth);
		self.rightResize:SetHeight(h - 2*CombatAnalysisWindow.resizeCornerWidth);
		
		self.titleBorder:SetVisible(false);
		self.titleContent:SetVisible(false);
		self.cutOff:SetVisible(false);
	end
	
	if (self.titleContent.Layout ~= nil) then
		self.titleContent:Layout();
	end
end

function CombatAnalysisWindow:Activate()
	Turbine.UI.Window.Activate(self);
	
	-- reorder window set such that this window is at position one
	if (self.windowSet ~= nil and self.windowSet[1] ~= self) then
		for index,window in ipairs(self.windowSet) do
			if (window == self) then
				table.remove(self.windowSet,index);
				break;
			end
		end
		table.insert(self.windowSet,1,self);
	end
end

function CombatAnalysisWindow:SetPosition(x,y)
  Turbine.UI.Window.SetPosition(self,x,y);
  
  Misc.SetValue(self,"x",self:GetLeft());
  Misc.SetValue(self,"y",self:GetTop());
end

function CombatAnalysisWindow:SetSize(w,h,minimized)
	Turbine.UI.Window.SetSize(self,w,h);
  
  if (not minimized) then
    Misc.SetValue(self,"w",self:GetWidth());
    Misc.SetValue(self,"h",self:GetHeight());
  end
  
	self:Layout();
end

function CombatAnalysisWindow:SetWidth(w,minimized)
	Turbine.UI.Window.SetWidth(self,w);
  
  if (not minimized) then
    Misc.SetValue(self,"w",self:GetWidth());    
  end
  
	self:Layout();
end

function CombatAnalysisWindow:SetHeight(h,minimized)
	Turbine.UI.Window.SetHeight(self,h);
  
  if (not minimized) then
    Misc.SetValue(self,"h",self:GetHeight());
  end
  
	self:Layout();
end

function CombatAnalysisWindow:SetVisible(visible,dontActivate)
	Turbine.UI.Window.SetVisible(self,visible);
	if (visible and not dontActivate) then self:Activate() end
end

function CombatAnalysisWindow:SetTitleBarWidth(titleBarWidth)
  Misc.SetValue(self,"titleBarWidth",titleBarWidth);
	self:LayoutTitle();
end

function CombatAnalysisWindow:SetBackgroundColor(color,loadFromSettings)
  Misc.SetValue(self,"color",color);
  
  if (self.showBackground) then
    self.content:SetBackColor(self.color);
  end
  
  if (not loadFromSettings) then
    self:SaveState();
  end
end

function CombatAnalysisWindow:SetBorderColor(color)
	self.border:SetBackColor(color);
end

function CombatAnalysisWindow:SetShowBackground(show)
  Misc.SetValue(self,"showBackground",show);
	
  self.content:SetBackColor(self.showBackground and self.color or Turbine.UI.Color(0,0,0,0));
  if (self.minimized) then return end
  
	if (self.showBackground) then
		self.border:SetHeight(self:GetHeight() - CombatAnalysisWindow.border - CombatAnalysisWindow.titleBarHeight - 2*CombatAnalysisWindow.resizeHangover);
		self:SetResizable(true);
	else
		self.border:SetHeight(self.minimumBorderHeight);
		self:SetResizable(false);
	end
end

function CombatAnalysisWindow:SetResizable(resizable)
	self.resizable = resizable;

	self.topLeftResize:SetMouseVisible(resizable and self.includeTopLeftResize);
	self.topRightResize:SetMouseVisible(resizable);
	self.bottomLeftResize:SetMouseVisible(resizable);
	self.bottomRightResize:SetMouseVisible(resizable);
	
	self.topCenterRightResize:SetMouseVisible(resizable);
	self.leftResize:SetMouseVisible(resizable);
	self.rightResize:SetMouseVisible(resizable);
	self.bottomResize:SetMouseVisible(resizable);
	
	self:ShowBottomRightIcon(resizable);
end

-- minimize a window to showing the title bar only

function CombatAnalysisWindow:Minimize()
  Misc.SetValue(self,"minimized",not self.minimized);
	
	-- minmize the window
	if (self.minimized) then
		self:SetResizable(false);
		
		self.startX,self.startY = self:GetPosition();
		
		self.targetX = self.startX+(self.w-(self.smallTitleBarWidth+2*CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover+15));
		self.targetY = self.startY;
		self.startW = self.w;
		self.startH = self.h;
		self.targetW = CombatAnalysisWindow.smallTitleBarWidth+2*CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover+15;
		self.targetH = CombatAnalysisWindow.titleBarHeight+2*CombatAnalysisWindow.border+2*CombatAnalysisWindow.resizeHangover;
		self.startTime = Turbine.Engine.GetGameTime();
		
		self:SetWantsUpdates(true);
	
	-- restore the window
	else
		self:SetResizable(self.showBackground);
		
		self.startX,self.startY = self:GetPosition();
		self.startW,self.startH = self:GetSize();
		local maximizedX = self.startX-(self.w-self.startW);
    
    self.targetW = math.max(self.w,self.minimumWidth);
    self.targetH = math.max(self.h,self.minimumHeight);
		
    self.targetX,self.targetY = WindowManager.ValidatePosition(maximizedX,self.startY,self.targetW,self.targetH,
                                      self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
                                      CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
		
		self.startTime = Turbine.Engine.GetGameTime();
		
		self:SetWantsUpdates(true);
	end
end

function CombatAnalysisWindow:Update()
	local proportion = math.min(1,(Turbine.Engine.GetGameTime()-self.startTime)/CombatAnalysisWindow.minimizeDuration);
	
	self:SetPosition(self.startX+Misc.Round(proportion*(self.targetX-self.startX)),self.startY+Misc.Round(proportion*(self.targetY-self.startY)));
	self:SetSize(self.startW+Misc.Round(proportion*(self.targetW-self.startW)),self.startH+Misc.Round(proportion*(self.targetH-self.startH)),true);
	
	-- reset visibility to avoid odd resize bug (this will grab focus, but ok in this case as we should have it anyway when minimizing/maximizing)
	self:SetVisible(false,true);
	self:SetVisible(true,true);
	
	if proportion == 1 then
		self:SetWantsUpdates(false);
		if not self.minimized then
			self:ShowBottomRightIcon(self.showBottomRightIcon);
		end
		self:SaveState();
	end
end

-- close the window by setting it to not visible and destroying all known references
function CombatAnalysisWindow:Close(dontSave)
	Turbine.UI.Window.Close(self);
	
	if (self.windowSet ~= nil) then
		for i,window in ipairs(self.windowSet) do
			if (window == self) then
				table.remove(self.windowSet,i);
				break;
			end
		end
	end
	
	for i,window in ipairs(allWindows) do
		if (window == self) then
			table.remove(allWindows,i);			
			break;
		end
	end
	
	-- add save the new window state (special case)
	self.windowClosed = true;
  if (not dontSave) then self:SaveState() end
end

-- mouse events for moving the window
function CombatAnalysisWindow:MouseDown(args)
	WindowManager.MouseWasPressed(self);
	
	if (args.Button == Turbine.UI.MouseButton.Left and not windowsLocked) then
		_G.mouseDown = true;
		self.startX = args.X;
		self.startY = args.Y;
		self.dragging = true;
	end
end

function CombatAnalysisWindow:MouseUp(args)
	_G.mouseDown = false;
	
	if (args.Button == Turbine.UI.MouseButton.Left and self.dragging) then
		self.dragging = false;
		
		local x,y = self:GetPosition();
		x = x+(args.X-self.startX);
		y = y+(args.Y-self.startY);
		x,y = WindowManager.SnapTo({statOverviewWindows,statOverviewStatsWindows},x,y,self:GetWidth(),self:GetHeight());
		x,y = WindowManager.ValidatePosition(x,y,self:GetWidth(),self:GetHeight(),
																						self.hasTitleBar and 0 or (CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover),
																						CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover);
		self:SetPosition(x,y);
		self:SaveState();
	end
end

function CombatAnalysisWindow:MouseMove(args)
	if self.dragging then
		local x,y = self:GetPosition();
		x = x+(args.X-self.startX);
		y = y+(args.Y-self.startY);
		x,y = WindowManager.SnapTo({statOverviewWindows,statOverviewStatsWindows},x,y,self:GetWidth(),self:GetHeight());
		self:SetPosition(x,y);
	end
end

-- UI customization options

function CombatAnalysisWindow:WindowsLocked()
  self.resizeIcon:SetVisible(self.showBottomRightIcon and not windowsLocked);
end

function CombatAnalysisWindow:ShowBottomRightIcon(showBottomRightIcon)
	self.showBottomRightIcon = showBottomRightIcon;
	self.resizeIcon:SetVisible(self.showBottomRightIcon and not windowsLocked);
end

function CombatAnalysisWindow:SaveState()
	-- does nothing (override in subclass if desired)
	
end
