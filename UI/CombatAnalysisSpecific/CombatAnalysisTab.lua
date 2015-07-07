
--[[

A Combat Analysis Tab is a simple tab that mimics the standard
chat window tab style, but allows for a colored overlay.

The tab holds a reference back to the containing window, so that
it can inform the containing window of selection events, etc.

The tab also holds a reference to the panel that should
display when it is selected.

]]--

_G.CombatAnalysisTab = class(Turbine.UI.Control);

function CombatAnalysisTab:Constructor(tabSet,text,menu,panel)
	Turbine.UI.Control.Constructor(self);
	
	self:SetSize(CombatAnalysisTabbedWindow.tabWidth,28);
	self:SetMouseVisible(true);
	
	self.window = nil;
	
	self.selected = false;
	self.dragging = false;
	self.prevHover = nil;
	
	self.tabSet = tabSet;
	self.text = text;
	self.panel = panel;
	
	-- west edge of tab
	self.w = Turbine.UI.Control();
	self.w:SetParent(self);
	self.w:SetSize(13,28);
	self.w:SetMouseVisible(false);
	self.w:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_w.tga");
	self.w:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- north (center) of tab
	self.n = Turbine.UI.Control();
	self.n:SetParent(self);
	self.n:SetSize(CombatAnalysisTabbedWindow.tabWidth-26,28);
	self.n:SetPosition(13,0);
	self.n:SetMouseVisible(false);
	self.n:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_n.tga");
	self.n:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- east edge of tab
	self.e = Turbine.UI.Control();
	self.e:SetParent(self);
	self.e:SetSize(13,28);
	self.e:SetPosition(CombatAnalysisTabbedWindow.tabWidth-13,0);
	self.e:SetMouseVisible(false);
	self.e:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_e.tga");
	self.e:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- tab label
	self.label = Turbine.UI.Label();
	self.label:SetParent(self);
	self.label:SetZOrder(1);
	self.label:SetSize(CombatAnalysisTabbedWindow.tabWidth,28);
	self.label:SetMouseVisible(false);
	self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	self.label:SetForeColor(controlColor);
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.label:SetText(string.lower(self.text));
	
	-- tab color overlay
	self.colorOverlay = Turbine.UI.Control();
	self.colorOverlay:SetParent(self);
	self.colorOverlay:SetSize(CombatAnalysisTabbedWindow.tabWidth,26);
	self.colorOverlay:SetMouseVisible(false);
	self.colorOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	
	-- drag window, used when dragging the tab
	self.dragWindow = Turbine.UI.Window();
	self.dragWindow:SetZOrder(1);
	self.dragWindow:SetSize(204,28);
	self.dragWindow:SetMouseVisible(false);
	self.dragWindow:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_w.tga");
	
	-- drag window label
	local label = Turbine.UI.Label();
	label:SetParent(self.dragWindow);
	label:SetZOrder(1);
	label:SetSize(204,28);
	label:SetMouseVisible(false);
	label:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	label:SetForeColor(controlSelectedColor);
	label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	label:SetText(text);
	
	-- drag window color overlay
	self.dragWindowOverlay = Turbine.UI.Control();
	self.dragWindowOverlay:SetParent(self.dragWindow);
	self.dragWindowOverlay:SetSize(204,28);
	self.dragWindowOverlay:SetMouseVisible(false);
	self.dragWindowOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
  
	-- tab menu
	self.tabMenu = menu;
end

-- SetParent override to learn which (should be a tabbed) window owns this tab
function CombatAnalysisTab:SetParent(parent,window)
	Turbine.UI.Control.SetParent(self,parent);
	self.window = window;
end

function CombatAnalysisTab:UpdateColor(color)
  Misc.SetValue(self,"color",color);
  
  self.colorOverlay:SetBackColor(Turbine.UI.Color(math.min(0.6,color.A),color.R,color.G,color.B));
  self.dragWindowOverlay:SetBackColor(color);
end

-- Mouse Events

function CombatAnalysisTab:MouseDown(args)
	-- only perform actions on left mouse down
	if (args.Button ~= Turbine.UI.MouseButton.Left) then return end
	
	-- notify window to select this tab
	self.window:SetSelectedTab(self);
	
	-- manually notify the window manager of the mouse press
	WindowManager.MouseWasPressed(self.window);
	
	-- set mouse down parameters
	_G.mouseDown = true;
	self.mouseDown = true;
	self.startX = args.X;
	self.startY = args.Y;
end

function CombatAnalysisTab:MouseMove(args)
	-- notify the window of mouse move event
	self.window:MouseMove(args);
	
	-- if dragging mode has not yet been activated, check to see if the mouse has been moved more than 5 pixels
	--  in either direction, in which case gragging mode will be activated
	if (not windowsLocked and not self.dragging and (self.mouseDown and (math.abs(self.startX-args.X) > CombatAnalysisTabbedWindow.tabSensitivity or (math.abs(self.startY-args.Y) > CombatAnalysisTabbedWindow.tabSensitivity)))) then
		self.dragging = true;
		
    WindowManager.ShowAllTabs(true,self.window.windowSet);
    self.window.prevAutoHideTabs = self.window.autoHideTabs;
    self.window.autoHideTabs = false;
    
		-- if this is not the first tab in the window, create a drag window
		if (self.window.tabs[1] ~= self) then
			self.dragWindow:SetVisible(true);
			local x,y = WindowManager.GetPositionOnScreen(self);
			self.startX = x-self.startX;
			self.startY = y-self.startY;
			self.startOffset = self.window.offset;
			
			WindowManager.ActivateAutoScrollMode(true,self.window.windowSet);
		
		-- otherwise, pass on a mouse down event to the window for dragging
		else
			-- (reset args)
			args.Button = Turbine.UI.MouseButton.Left;
			args.X = self.startX;
			args.Y = self.startY;
			self.window:MouseDown(args);
			
			WindowManager.ActivateAutoScrollMode(true,self.window.windowSet,self.window);
		end
	end
	
	-- if we are in dragging mode, update the position of the drag window (if applicable), and determine if the
	--  mouse is hovering over a tab pane (of any window in the relevant window set)
	if self.dragging then
		if (self.window.tabs[1] ~= self) then
			self.dragWindow:SetPosition(self.startX+args.X+(self.startOffset-self.window.offset),self.startY+args.Y);
		end
		
		local window = WindowManager.GetMouseInsideTabbedPane(self.window.windowSet,(self.window.tabs[1] == self and self.window));
		-- remove hover effect from previous window
		if (self.prevHover ~= nil and self.prevHover ~= window) then
			self.prevHover.tabPaneHighlight:SetVisible(false);
			self.prevHover:SetTabsBackColorShowing(true);
			
			-- pass on the mouse move argument to the tab list pane so it stops autoscrolling
			args.X,args.Y = self.prevHover.tabListPane:GetMousePosition();
			self.prevHover.tabListPane:MouseMove(args);
			
			self.prevHover = nil;
		end
		-- apply hover effect to new window
		if (window ~= nil) then
			window.tabPaneHighlight:SetVisible(true);
			window:SetTabsBackColorShowing(false);
			self.prevHover = window;
			
			-- pass on the mouse move argument to the tab list pane so it can conduct auto scrolling if necessary
			args.X,args.Y = window.tabListPane:GetMousePosition();
			window.tabListPane:MouseMove(args);
		end
	end
end

function CombatAnalysisTab:MouseUp(args)
	-- notify the window of mouse up event
	self.window:MouseUp(args);
	
	-- only perform further actions on left mouse down
	if (args.Button ~= Turbine.UI.MouseButton.Left) then return end
	
	self.mouseDown = false;
	
	self.window.autoHideTabs = self.window.prevAutoHideTabs;
	self.window.prevAutoHideTabs = false;
	WindowManager.ShowAllTabs(false,self.window.windowSet);
	
	-- if we had been dragging a tab, we now need to determine what action to take
	if self.dragging then
		local currentWindow = self.window;
		
		-- deactivate the drag hover effect if showing
		if (self.prevHover ~= nil) then
			self.prevHover.tabPaneHighlight:SetVisible(false);
			self.prevHover:SetTabsBackColorShowing(true);
		end
		
		-- determine which window the mouse is hovering inside the tab pane of (if any)
		local window = WindowManager.GetMouseInsideTabbedPane(currentWindow.windowSet,(self.window.tabs[1] == self and currentWindow));
		
		-- if the first tab in a window was dragged, we only need to do anything if the tab (in this case, the whole window)
		--  was dragged into another window
		if (currentWindow.tabs[1] == self) then
			WindowManager.ActivateAutoScrollMode(false,self.window.windowSet,self.window);
		
			if (window ~= nil) then
				-- deselect this tab
				self:SetSelected(false);
				
				local newIndex = window:GetMouseTabIndex();
				-- move all tabs into the new window (which will cause this window to be destroyed)
				for i=#self.window.tabs,1,-1 do
					local currentTab = self.window.tabs[i];
					-- remove tab
					currentWindow:RemoveTab(currentTab);
					-- add tab at determined index in new window
					window:AddTab(currentTab,false,newIndex);
					
					currentTab:SaveState();
				end
			end
		
		-- if any other tab was dragged, there are various actions that may need to be performed
		else
			WindowManager.ActivateAutoScrollMode(false,self.window.windowSet);
		
			-- 1) the tab was dragged to open space, so we create a new tab window containing just this tab
			if (window == nil) then
				local x,y = Turbine.UI.Display.GetMousePosition();
        self:MoveTabToNewWindow(x,y);
				
			-- 2) the tab was dragged around within the current window, so we simply change the tab order in the current window (may be no change at all)
			elseif (window == currentWindow) then
        self:ReOrderTab(currentWindow:GetMouseTabIndex());
				
			-- 3) the tab was dragged to another window, so we remove tab from this window and add it to new window
			else
        self:MoveTabToExistingWindow(window,window:GetMouseTabIndex())
        
			end
		end
	end
	
	-- termination of the dragging process, ensure the drag window is no longer showing
	self.dragging = false;
	self.dragWindow:SetVisible(false);
end

function CombatAnalysisTab:ReOrderTab(newIndex,dontEnsureShowing)
  local currentWindow = self.window;
	currentWindow:MoveTab(self,newIndex,dontEnsureShowing);
  
  for _,tab in ipairs(currentWindow.tabs) do
    tab:SaveState();
  end
end

function CombatAnalysisTab:MoveTabToNewWindow(x,y,dontActivate)
  local currentWindow = self.window;
  -- remove tab from current window
  if (currentWindow ~= nil) then currentWindow:RemoveTab(self) end
  -- clone the current window (with new x,y co-ords); this function must be overridden
  local new = self:GenerateNewWindow(currentWindow,x,y,dontActivate);
  
  self:SaveState();
  new:SaveState();
end

function CombatAnalysisTab:MoveTabToExistingWindow(window,index,dontEnsureShowing)
	-- remove tab
  if (self.window ~= nil) then self.window:RemoveTab(self) end
  -- add tab at determined index in new window
  window:AddTab(self,false,index,dontEnsureShowing);
  
  self:SaveState();
end

-- notify tabbed window to scroll on mouse wheel movement
function CombatAnalysisTab:MouseWheel(args)
	self.window.tabListPane:MouseWheel(args);
end

-- activate hover effect
function CombatAnalysisTab:MouseEnter(args)
	self:SetHover(true);
end

-- deactivate hover effects
function CombatAnalysisTab:MouseLeave(args)
	self:SetHover(false);
end

-- show context menu on right click
function CombatAnalysisTab:MouseClick(args)
	if (args.Button == Turbine.UI.MouseButton.Right) then
		WindowManager.MouseWasPressed(self.window);
		
		self.tabMenu:PopulateMenu(self);
		self.tabMenu:ShowMenu();
	end
end

-- UI effects

function CombatAnalysisTab:SetBackColorShowing(showBackColor)
	if (showBackColor) then
		self.colorOverlay:SetVisible(true);
	else
		self.colorOverlay:SetVisible(false);
	end
end

function CombatAnalysisTab:SetHover(hover)
	if (self.selected) then return end

	if (hover) then
		self.w:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_w.tga");
		self.n:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_n.tga");
		self.e:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_e.tga");
		self.label:SetForeColor(controlSelectedColor);
	else
		self.w:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_w.tga");
		self.n:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_n.tga");
		self.e:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_e.tga");
		self.label:SetForeColor(controlColor);
	end
end

function CombatAnalysisTab:SetSelected(selected)
	if (selected) then
		self.w:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_w.tga");
		self.n:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_n.tga");
		self.e:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_front_e.tga");
		self.label:SetText(self.text);
		self.label:SetForeColor(controlSelectedColor);
	else
		self.w:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_w.tga");
		self.n:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_n.tga");
		self.e:SetBackground("CombatAnalysis/Resources/chat_tab_tier1_middle_back_e.tga");
		self.label:SetText(string.lower(self.text));
		self.label:SetForeColor(controlColor);
	end
	
	self.selected = selected;
end


function CombatAnalysisTab:SaveState()
	-- does nothing (override in subclass if desired)
	
end
