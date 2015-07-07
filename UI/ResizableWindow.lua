
--[[

A Silver LOTRO Window that can be Resized in all directions. 

All content should be added to the "self.content" pane,
whose Layout() method, which should be overridden,
will determine how internal elements are displayed.

]]--

_G.ResizableWindow = class(Window);

function ResizableWindow:Constructor()
	Window.Constructor(self);
	
	self.mouseDown = false;
	self.minimumWidth = 400;
	self.minimumHeight = 300;
	
	-- content pane
	self.content = Turbine.UI.Control();
	self.content:SetParent(self);
	self.content:SetZOrder(1);
	self.content:SetMouseVisible(false);
	
	-- filler to hide resize issues with the title bar
	self.filler = Turbine.UI.Control();
	self.filler:SetParent(self);
	self.filler:SetZOrder(-2);
	self.filler:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.filler:SetMouseVisible(false);
	
	-- resize icon (lower right)
	self.resizeIcon = Turbine.UI.Control();
	self.resizeIcon:SetParent(self);
	self.resizeIcon:SetSize(45,45);
	self.resizeIcon:SetZOrder(2);
	self.resizeIcon:SetMouseVisible(false);
	self.resizeIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.resizeIcon:SetBackground("CombatAnalysis/Resources/panel_resize_icon.tga");
	
	-- top left resize arrow
	self.topLeftResize = Turbine.UI.Control();
	self.topLeftResize:SetParent(self);
	self.topLeftResize:SetSize(30,30);
	self.topLeftResize:SetZOrder(3);
	self.topLeftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(newX,newY,newW,newH,self.minimumWidth,self.minimumHeight,true,true);
			self.changeX = self.changeX-(x-oldX);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.topLeftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > 30 or args.Y < 0 or args.Y > 30) then
				cursorDiagonalDownward:SetVisible(false);
				cursorDiagonalDownward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topLeftResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorDiagonalDownward:SetWantsUpdates(true);
			cursorDiagonalDownward:Update();
			cursorDiagonalDownward:SetVisible(true);
		end
	end
	self.topLeftResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorDiagonalDownward:SetVisible(false);
			cursorDiagonalDownward:SetWantsUpdates(false);
		end
	end
	
	-- top right resize arrow
	self.topRightResize = Turbine.UI.Control();
	self.topRightResize:SetParent(self);
	self.topRightResize:SetSize(30,30);
	self.topRightResize:SetZOrder(3);
	self.topRightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,newY,newW,newH,self.minimumWidth,self.minimumHeight,true,false);
			self.changeX = self.changeX+(w-oldW);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.topRightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			-- NB: also check for if the mouse is over the X button
			if (args.X < 0 or args.X > 30 or args.Y < 0 or args.Y > 30 or (args.X >= 7 and args.X < 23 and args.Y >= 8 and args.Y < 24)) then
				cursorDiagonalUpward:SetVisible(false);
				cursorDiagonalUpward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topRightResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorDiagonalUpward:SetWantsUpdates(true);
			cursorDiagonalUpward:Update();
			cursorDiagonalUpward:SetVisible(true);
		end
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
	self.bottomLeftResize:SetSize(30,30);
	self.bottomLeftResize:SetZOrder(3);
	self.bottomLeftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(newX,oldY,newW,newH,self.minimumWidth,self.minimumHeight,false,true);
			self.changeX = self.changeX-(x-oldX);
			self.changeY = self.changeY+(h-oldH);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.bottomLeftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > 30 or args.Y < 0 or args.Y > 30) then
				cursorDiagonalUpward:SetVisible(false);
				cursorDiagonalUpward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.bottomLeftResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorDiagonalUpward:SetWantsUpdates(true);
			cursorDiagonalUpward:Update();
			cursorDiagonalUpward:SetVisible(true);
		end
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
	self.bottomRightResize:SetSize(36,36);
	self.bottomRightResize:SetZOrder(3);
	self.bottomRightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,oldY,newW,newH,self.minimumWidth,self.minimumHeight,false,false);
			self.changeX = self.changeX+(w-oldW);
			self.changeY = self.changeY+(h-oldH);
			
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.bottomRightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > 36 or args.Y < 0 or args.Y > 36) then
				cursorDiagonalDownward:SetVisible(false);
				cursorDiagonalDownward:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.bottomRightResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorDiagonalDownward:SetWantsUpdates(true);
			cursorDiagonalDownward:Update();
			cursorDiagonalDownward:SetVisible(true);
		end
	end
	self.bottomRightResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorDiagonalDownward:SetVisible(false);
			cursorDiagonalDownward:SetWantsUpdates(false);
		end
	end
	
	-- top center left filler to hide movement arrows
	self.topCenterLeftFiller = Turbine.UI.Control();
	self.topCenterLeftFiller:SetParent(self);
	self.topCenterLeftFiller:SetHeight(18);
	self.topCenterLeftFiller:SetZOrder(2);
	
	-- top center right filler to hide movement arrows
	self.topCenterRightFiller = Turbine.UI.Control();
	self.topCenterRightFiller:SetParent(self);
	self.topCenterRightFiller:SetHeight(18);
	self.topCenterRightFiller:SetZOrder(2);
	
	-- top center left resize arrow
	self.topCenterLeftResize = Turbine.UI.Control();
	self.topCenterLeftResize:SetParent(self);
	self.topCenterLeftResize:SetHeight(15);
	self.topCenterLeftResize:SetZOrder(2);
	self.topCenterLeftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,newY,oldW,newH,self.minimumWidth,self.minimumHeight,true,false);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.topCenterLeftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > self.topCenterLeftResize:GetWidth() or args.Y < 0 or args.Y > 15) then
				cursorVertical:SetVisible(false);
				cursorVertical:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topCenterLeftResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorVertical:SetWantsUpdates(true);
			cursorVertical:Update();
			cursorVertical:SetVisible(true);
		end
	end
	self.topCenterLeftResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorVertical:SetVisible(false);
			cursorVertical:SetWantsUpdates(false);
		end
	end
	
	-- top center right resize arrow
	self.topCenterRightResize = Turbine.UI.Control();
	self.topCenterRightResize:SetParent(self);
	self.topCenterRightResize:SetHeight(15);
	self.topCenterRightResize:SetZOrder(2);
	self.topCenterRightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,newY,oldW,newH,self.minimumWidth,self.minimumHeight,true,false);
			self.changeY = self.changeY-(y-oldY);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.topCenterRightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > self.topCenterRightResize:GetWidth() or args.Y < 0 or args.Y > 15) then
				cursorVertical:SetVisible(false);
				cursorVertical:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.topCenterRightResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorVertical:SetWantsUpdates(true);
			cursorVertical:Update();
			cursorVertical:SetVisible(true);
		end
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
	self.leftResize:SetWidth(15);
	self.leftResize:SetZOrder(2);
	self.leftResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(newX,oldY,newW,oldH,self.minimumWidth,self.minimumHeight,false,true);
			self.changeX = self.changeX-(x-oldX);
			
			self:SetPosition(x,y);
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.leftResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > 15 or args.Y < 0 or args.Y > self.leftResize:GetHeight()) then
				cursorHorizontal:SetVisible(false);
				cursorHorizontal:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.leftResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorHorizontal:SetWantsUpdates(true);
			cursorHorizontal:Update();
			cursorHorizontal:SetVisible(true);
		end
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
	self.rightResize:SetWidth(15);
	self.rightResize:SetZOrder(2);
	self.rightResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,oldY,newW,oldH,self.minimumWidth,self.minimumHeight,false,false);
			self.changeX = self.changeX+(w-oldW);
			
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);      
		end
	end
	self.rightResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > 15 or args.Y < 0 or args.Y > self.rightResize:GetHeight()) then
				cursorHorizontal:SetVisible(false);
				cursorHorizontal:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.rightResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorHorizontal:SetWantsUpdates(true);
			cursorHorizontal:Update();
			cursorHorizontal:SetVisible(true);
		end
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
	self.bottomResize:SetHeight(15);
	self.bottomResize:SetZOrder(2);
	self.bottomResize.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
    KeyManager.TakeFocus();
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
			
			local x,y,w,h = WindowManager.ValidateSize(oldX,oldY,oldW,newH,self.minimumWidth,self.minimumHeight,false,false);
			self.changeY = self.changeY+(h-oldH);
			
			self:SetSize(w,h);
			-- hack to sometimes prevent resize bug
			self:SetVisible(false);
			self:SetVisible(true,true);
		end
	end
	self.bottomResize.MouseUp = function(sender,args)
		if self.mouseDown then
			_G.mouseDown = false;
			self.mouseDown = false;
			if (args.X < 0 or args.X > self.bottomResize:GetWidth() or args.Y < 0 or args.Y > 15) then
				cursorVertical:SetVisible(false);
				cursorVertical:SetWantsUpdates(false);
			end
			self:SaveState();
		end
	end
	self.bottomResize.MouseEnter = function(sender,args)
		if not _G.mouseDown then
			cursorVertical:SetWantsUpdates(true);
			cursorVertical:Update();
			cursorVertical:SetVisible(true);
		end
	end
	self.bottomResize.MouseLeave = function(sender,args)
		if not self.mouseDown then
			cursorVertical:SetVisible(false);
			cursorVertical:SetWantsUpdates(false);
		end
	end
end

function ResizableWindow:Layout()
	CombatAnalysis.UI.Window.Layout(self);
	width,height = self:GetSize();
	
	self.resizeIcon:SetPosition(width - 45, height - 45);
	
	self.topLeftResize:SetPosition(0, 18);
	self.topRightResize:SetPosition(width - 30, 18);
	self.bottomLeftResize:SetPosition(0, height - 30);
	self.bottomRightResize:SetPosition(width - 36, height - 36);
	
	self.topCenterLeftFiller:SetPosition(0, 0);
	self.topCenterLeftFiller:SetWidth(self.titleLeft:GetLeft());
	self.topCenterRightFiller:SetPosition(self.titleRight:GetLeft() + 35, 0);
	self.topCenterRightFiller:SetWidth(width - (self.titleRight:GetLeft() + 35));
	self.topCenterLeftResize:SetPosition(30, 18);
	self.topCenterLeftResize:SetWidth(self.titleLeft:GetLeft() - 30);
	self.topCenterRightResize:SetPosition(self.titleRight:GetLeft() + 35, 18);
	self.topCenterRightResize:SetWidth(width - (self.titleRight:GetLeft() + 35) - 30);
	
	self.leftResize:SetPosition(0, 48);
	self.leftResize:SetHeight(height - 78);
	self.rightResize:SetPosition(width - 15, 48);
	self.rightResize:SetHeight(height - 84);
	self.bottomResize:SetPosition(30 , height - 15);
	self.bottomResize:SetWidth(width - 66);
	
	self.filler:SetSize(width,height);
	self.content:SetSize(width,height);
	pcall(self.content.Layout,self.content);
end
