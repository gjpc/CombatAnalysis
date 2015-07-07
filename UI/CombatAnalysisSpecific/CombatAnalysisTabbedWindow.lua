
--[[

A Combat Analysis Tabbed Window extends the standard Combat
Analysis Window by adding a series of tabs, similar to the
chat box tabs.

The tab area can be scrolled using the mouse wheel or the
provided arrows if there are more tabs that can fit in the
screen. An auto scroll option is also available.

Also note any extra tabs can be dragged away from the window
to create additional tabbed windows.

]]--

_G.CombatAnalysisTabbedWindow = class(CombatAnalysisWindow);

-- some configurable properties
CombatAnalysisTabbedWindow.tabWidth = (locale == "de" and 71 or 65); -- the width of the selected tab
CombatAnalysisTabbedWindow.tabGap = 3;                -- the gap between tabs
CombatAnalysisTabbedWindow.tabSensitivity = 4;        -- the number of pixels a tab can be dragged before activing tab drag features
CombatAnalysisTabbedWindow.scrollWidth = 0.18;        -- the % distance from either edge of the tabs pane to perform auto scrolling if enabled
CombatAnalysisTabbedWindow.scrollSpeedRanges = {5,2}; -- the number of pixels to move each frame (capped at 1/60th of a second) when hovering in equally sized regions inside the scroll width
CombatAnalysisTabbedWindow.defaultMinWidth = 138;     -- the default window minimum width (NB:includes overhang, and will usually be overriden)

CombatAnalysisTabbedWindow.defaultWidth = 270;
CombatAnalysisTabbedWindow.defaultHeight = 221;


function CombatAnalysisTabbedWindow:Constructor(windowSet,showBackground,backgroundOpacity,showBottomRightIcon,titleBarWidth,autoHideTabs,closable,id)
	CombatAnalysisWindow.Constructor(self,windowSet,showBackground,backgroundOpacity,showBottomRightIcon,false,true,titleBarWidth,closable,id);
	
	self.tabs = {}
	self.selected = nil;
	self.offset = 0;
	self.lastUpdate = 0;
	self.minimumWidth = CombatAnalysisTabbedWindow.defaultMinWidth;
	
	self.scrollDir = 0;
	self.scrollSpeed = 0;
	
  Misc.SetValue(self,"autoHideTabs",autoHideTabs);
	
	-- list box (scrollable) containing all tabs
	self.tabListPane = Turbine.UI.ListBox();
	self.tabListPane:SetParent(self);
	self.tabListPane:SetZOrder(1);
	self.tabListPane:SetPosition(CombatAnalysisWindow.resizeHangover,0);
	self.tabListPane:SetHeight(28);
	self.tabListPane:SetMouseVisible(true);
	
	self.tabListPane.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
		-- hack to fix a bug where mouse visible is set to false after first click
		self.click = true;
		self.tabListPane:SetWantsUpdates(true);
	end
	self.tabListPane.MouseMove = function(sender,args)
		if (args.Y >= 0 and args.Y < 28) then
			-- mouse in left sector ==> set scroll left at determined speed
			local maxX = self.tabPane:GetWidth()*CombatAnalysisTabbedWindow.scrollWidth;
			if (args.X >= 0 and args.X < maxX) then
				self.scrollDir = -1;
				self.scrollSpeed = CombatAnalysisTabbedWindow.scrollSpeedRanges[math.max(1,math.ceil(args.X/(maxX/#CombatAnalysisTabbedWindow.scrollSpeedRanges)))];
				return;
			end
			
			-- mouse in right sector ==> set scroll right at determined speed
			local minX = self.tabPane:GetWidth()*(1-CombatAnalysisTabbedWindow.scrollWidth);
			if (args.X > minX and args.X < self.tabPane:GetWidth()) then
				self.scrollDir = 1;
				self.scrollSpeed = CombatAnalysisTabbedWindow.scrollSpeedRanges[math.max(1,math.ceil((maxX-(args.X-minX))/(maxX/#CombatAnalysisTabbedWindow.scrollSpeedRanges)))];
				return;
			end
		end
		
		-- mouse in neither sector ==> set scroll speed to zero (no scrolling)
		self.scrollDir = 0;
		self.scrollSpeed = 0;
	end
	-- scroll the tab list on a mouse wheel movement
	self.tabListPane.MouseWheel = function(sender,args)
		self:IncrementOffset(-args.Direction*((CombatAnalysisTabbedWindow.tabWidth+CombatAnalysisTabbedWindow.tabGap)/2));
	end
	-- perform autoscrolling according to offset
	self.tabListPane.Update = function()
		-- hack to fix a bug where mouse visible is set to false after first click
		if (self.click) then
			self.tabListPane:SetMouseVisible(true);
			self.click = false;
			self.tabListPane:SetWantsUpdates(false);
		end
		-- autoscrolling
		local gameTime = Turbine.Engine.GetGameTime();
		if (gameTime >= ((1/60)+self.lastUpdate)) then
			self.lastUpdate = gameTime;
			self:IncrementOffset(self.scrollDir*self.scrollSpeed);
		end
	end
	
	-- left scroll arrow
	self.leftScrollButton = Turbine.UI.Control();
	self.leftScrollButton:SetParent(self.tabListPane);
	self.leftScrollButton:SetSize(10,10);
	self.leftScrollButton:SetPosition(0,15);
	self.leftScrollButton:SetZOrder(1);
	self.leftScrollButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.leftScrollButton:SetBackground("CombatAnalysis/Resources/scrollbar_10H_downarrow.tga");
	self.leftScrollButton.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
	end
	self.leftScrollButton.MouseEnter = function(sender, args)
		self.leftScrollButton:SetBackground("CombatAnalysis/Resources/scrollbar_10H_downarrow_mouseover.tga");
	end
	self.leftScrollButton.MouseLeave = function(sender, args)
		self.leftScrollButton:SetBackground("CombatAnalysis/Resources/scrollbar_10H_downarrow.tga");
	end
	self.leftScrollButton.MouseClick = function(sender, args)
		self:IncrementOffset(-(CombatAnalysisTabbedWindow.tabWidth+CombatAnalysisTabbedWindow.tabGap));
	end
	self.leftScrollButton.MouseDoubleClick = function(sender, args)
		self.leftScrollButton:MouseClick(args);
	end
	
	-- right scroll arrow
	self.rightScrollButton = Turbine.UI.Control();
	self.rightScrollButton:SetParent(self.tabListPane);
	self.rightScrollButton:SetSize(10,10);
	self.rightScrollButton:SetTop(15);
	self.rightScrollButton:SetZOrder(1);
	self.rightScrollButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.rightScrollButton:SetBackground("CombatAnalysis/Resources/scrollbar_10H_uparrow.tga");
	self.rightScrollButton.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self);
	end
	self.rightScrollButton.MouseEnter = function(sender, args)
		self.rightScrollButton:SetBackground("CombatAnalysis/Resources/scrollbar_10H_uparrow_mouseover.tga");
	end
	self.rightScrollButton.MouseLeave = function(sender, args)
		self.rightScrollButton:SetBackground("CombatAnalysis/Resources/scrollbar_10H_uparrow.tga");
	end
	self.rightScrollButton.MouseClick = function(sender, args)
		self:IncrementOffset(CombatAnalysisTabbedWindow.tabWidth+CombatAnalysisTabbedWindow.tabGap);
	end
	self.rightScrollButton.MouseDoubleClick = function(sender, args)
		self.rightScrollButton:MouseClick(args);
	end
	
	-- inner tab pane containing the tabs
	self.tabPane = Turbine.UI.Control();
	self.tabPane:SetParent(self.tabListPane);
	self.tabPane:SetPosition(CombatAnalysisWindow.border,0);
	self.tabPane:SetHeight(26);
	self.tabPane:SetMouseVisible(false);
	-- use the tab pane update function to check for mouse leave events, see the note in the MouseLeave function below
	self.tabPane.Update = function()
		local x,y = self:GetMousePosition();
		if (x < 0 or x >= self:GetWidth() or y < 0 or  y >= self:GetHeight()) then
			self.tabPane:SetWantsUpdates(false);
			self:HideTabs();
		end
	end
	
	-- inner tab pane containing the tabs
	self.tabPaneHighlight = Turbine.UI.Control();
	self.tabPaneHighlight:SetParent(self.tabListPane);
	self.tabPaneHighlight:SetZOrder(-1);
	self.tabPaneHighlight:SetPosition(CombatAnalysisWindow.border,0);
	self.tabPaneHighlight:SetHeight(26);
	self.tabPaneHighlight:SetMouseVisible(false);
	self.tabPaneHighlight:SetBackground("CombatAnalysis/Resources/chat_drag_back.tga");
	self.tabPaneHighlight:SetVisible(false);
	
	if self.autoHideTabs then self:HideTabs() end
end

function CombatAnalysisTabbedWindow:Layout()
	CombatAnalysisWindow.Layout(self);
	self:LayoutInternal();
end

function CombatAnalysisTabbedWindow:LayoutTitle()
	CombatAnalysisWindow.LayoutTitle(self);
	self:LayoutInternal();
end

-- layout the tab area
function CombatAnalysisTabbedWindow:LayoutInternal()
	width,height = self:GetSize();
	
	self.tabListPane:SetWidth(width-2*CombatAnalysisWindow.resizeHangover-CombatAnalysisWindow.border-self.titleBarWidth-(self.titleBarWidth > 0 and 12 or 0));
	self.tabPane:SetWidth(width-2*CombatAnalysisWindow.resizeHangover-2*CombatAnalysisWindow.border-self.titleBarWidth-(self.titleBarWidth > 0 and 12+2*CombatAnalysisWindow.border or 0));
	self.tabPaneHighlight:SetWidth(width-2*CombatAnalysisWindow.resizeHangover-2*CombatAnalysisWindow.border-self.titleBarWidth-(self.titleBarWidth > 0 and 12+2*CombatAnalysisWindow.border or 0));
	self.offset = math.min(math.max(self.offset,0),math.max(#self.tabs*CombatAnalysisTabbedWindow.tabWidth+(#self.tabs-1)*CombatAnalysisTabbedWindow.tabGap-self.tabPane:GetWidth(),0));
	
	self:DetermineArrowsShowing();
	self:LayoutTabs();
end

-- layout the tabs given an offset
function CombatAnalysisTabbedWindow:LayoutTabs()
	for index,tab in ipairs(self.tabs) do
		tab:SetLeft((index-1)*(CombatAnalysisTabbedWindow.tabWidth+CombatAnalysisTabbedWindow.tabGap)-self.offset);
	end
end

-- remove all tabs from the window
function CombatAnalysisTabbedWindow:Close(dontSave)
	CombatAnalysisWindow.Close(self,dontSave);
	
	for _,tab in ipairs(self.tabs) do
		tab:SetParent(nil,nil);
		if (not dontSave) then tab:SaveState() end
	end
end

-- auto hide tabs feature

function CombatAnalysisTabbedWindow:MouseEnter(args)
	self.tabPane:SetWantsUpdates(false);
	
	if (self.autoHideTabs) then
		self:ShowTabs();
	end
end

function CombatAnalysisTabbedWindow:MouseLeave(args)
	-- note that we can get mouse leave events due to right clicks, middle mouse clicks, or partially overlapping windows, etc.
	-- in these cases we do not want to hide the tabs, so if the mouse is still within the window bounds, start polling until
	-- the mouse leaves the window, or a MouseEnter event is fired (note we hijack the tabPane Update method for these purposes)
	if (self.autoHideTabs and not self.mouseDown and not self.dragging) then
		local x,y = self:GetMousePosition();
		if (x < 0 or x >= self:GetWidth() or y < 0 or  y >= self:GetHeight()) then
			self:HideTabs();
		else
			self.tabPane:SetWantsUpdates(true);
		end
	end
end

function CombatAnalysisTabbedWindow:ShowTabs()
	self.tabListPane:SetVisible(true);
end

function CombatAnalysisTabbedWindow:HideTabs()
	self.tabListPane:SetVisible(false);
end

function CombatAnalysisTabbedWindow:SetAutoHideTabs(autoHide)
	Misc.SetValue(self,"autoHideTabs",autoHide);
	
	if (self.autoHideTabs) then
		local x,y = self:GetMousePosition();
		if (x < 0 or x >= self:GetWidth() or y < 0 or  y >= self:GetHeight()) then
			self:HideTabs();
		end
	else
		self:ShowTabs();
	end
end

-- tab scrolling functions

-- determine if the move left and right arrows should be showing
function CombatAnalysisTabbedWindow:DetermineArrowsShowing()
	if (self.offset > 0) then
		self.leftScrollButton:SetVisible(true);
	else
		self.leftScrollButton:SetVisible(false);
	end
	
	if (self.offset < ((#self.tabs*CombatAnalysisTabbedWindow.tabWidth+(#self.tabs-1)*CombatAnalysisTabbedWindow.tabGap) - self.tabPane:GetWidth())) then
		self.rightScrollButton:SetVisible(true);
		self.rightScrollButton:SetLeft(self.tabListPane:GetWidth()-11);
	else
		self.rightScrollButton:SetVisible(false);
	end
end

-- increment the tab position offset (but cap at bounds)
function CombatAnalysisTabbedWindow:IncrementOffset(increment)
	local oldOffset = self.offset;
	-- update offset
	self.offset = self.offset + increment;
	-- ensure offset remains within bounds
	self.offset = math.min(math.max(self.offset,0),math.max(#self.tabs*CombatAnalysisTabbedWindow.tabWidth+(#self.tabs-1)*CombatAnalysisTabbedWindow.tabGap-self.tabPane:GetWidth(),0));
	-- re-layout tabs if necessary
	if (oldOffset ~= self.offset) then
		self:DetermineArrowsShowing();
		self:LayoutTabs();
	end
end

-- determine if the mouse is currently inside the tab list pane
function CombatAnalysisTabbedWindow:IsMouseInsideTabbedPane()
	local x,y = self.tabListPane:GetMousePosition();
	if ((x < 0 or x > self.tabListPane:GetWidth()) or (y < 0 or y > 28)) then
		return false;
	else
		return true;
	end
end

-- get the nearest tab index to the current mouse location
--  (note we assume that the mouse is in the tabbed pane)
function CombatAnalysisTabbedWindow:GetMouseTabIndex()
	local x = self.tabListPane:GetMousePosition()+self.offset; -- only interested in x value
	local boundary = CombatAnalysisWindow.border+(CombatAnalysisTabbedWindow.tabWidth/2);
	
	for i=1,#self.tabs do
		if (x < boundary) then
			return i;
		end
		boundary = boundary + (CombatAnalysisTabbedWindow.tabWidth + CombatAnalysisTabbedWindow.tabGap);
	end
	
	return #self.tabs+1;
end

-- enabled/disable the autoscrolls feature
function CombatAnalysisTabbedWindow:SetAutoScrollEnabled(autoScroll)
	self.tabListPane:SetWantsUpdates(autoScroll);
	
	if (not autoScroll) then
		self.scrollDir = 0;
		self.scrollSpeed = 0;
	end
end

-- tab manipulation functions

-- add a tab to this window, at the specified index (should be a CombatAnalysisTab)
function CombatAnalysisTabbedWindow:AddTab(tab,select,index,dontSave,dontEnsureVisible)
	tab:SetParent(self.tabPane,self);
	
	-- insert the tab
	if (index == nil) then
		table.insert(self.tabs,tab);
	else
    index = math.min(#self.tabs+1,index);
		table.insert(self.tabs,index,tab);
	end
	
	-- if no tab was selected (ie: presumably there were no tabs before), select this tab
	if (select) then
		self:SetSelectedTab(tab,true,dontSave);
	end
	
	-- if we are not restoring tabs from settings, ensure the new tab is visible
	if (not dontEnsureVisible and (select or not dontSave) and not self.minimized) then
		self:EnsureTabVisible(index == nil and #self.tabs or index);
	end
	
	-- layout the tabs
	self:DetermineArrowsShowing();
	self:LayoutTabs();
  
  Misc.NotifyListeners(self,"tabs");
end

-- remove a tab from this window
function CombatAnalysisTabbedWindow:RemoveTab(tab)
	tab:SetParent(nil,nil);
	
	for index,t in ipairs(self.tabs) do
		if (tab == t) then
			table.remove(self.tabs,index);
			
			-- if the last tab was removed, destroy the window
			if (#self.tabs == 0) then
				self:Close(tab);
        
        Misc.NotifyListeners(self,"tabs");
				return;
			end
			
			if (self.selected == t) then
				self:SetSelectedTab(self.tabs[math.max(1,index-1)],true);
			end
			
			self.offset = math.min(self.offset,math.max(#self.tabs*CombatAnalysisTabbedWindow.tabWidth+(#self.tabs-1)*CombatAnalysisTabbedWindow.tabGap-self.tabPane:GetWidth(),0));
			self:DetermineArrowsShowing();
			self:LayoutTabs();
			
      Misc.NotifyListeners(self,"tabs");
			return;
		end
	end
  
  Misc.NotifyListeners(self,"tabs");
end

-- change the index of the given tab to the specified one (tab should exist in window)
function CombatAnalysisTabbedWindow:MoveTab(tab,index,dontEnsureVisible)
  index = math.min(#self.tabs+1,index);
  
	local currentIndex = 1;
	for i,t in ipairs(self.tabs) do
		if (tab == t) then
			currentIndex = i;
			table.remove(self.tabs,i);
			break;
		end
	end
  
  -- shift the index down one if we are moving the tab to the right, so that we don't jump
	--  over a tab
  local index = (index > currentIndex and index - 1 or index);
	
	table.insert(self.tabs,index,tab);
	
  if (not dontEnsureVisible) then self:EnsureTabVisible(index) end
	self:DetermineArrowsShowing();
	self:LayoutTabs();
  
  Misc.NotifyListeners(self,"tabs");
end

-- update the selected tab, and corresponding panel
function CombatAnalysisTabbedWindow:SetSelectedTab(tab,preventUpdate,dontSave)
	if (self.selected == tab) then return end
	
	if (self.selected ~= nil) then
		self.selected:SetSelected(false);
		self.selected.panel:SetParent(nil);
		if (not dontSave) then self.selected:SaveState() end
	end
	
	self.selected = tab;
	self.selected:SetSelected(true);
	self.selected.panel:SetParent(self.content);
	
	-- update layout function to ensure the newly selected panel is laid out correctly
	self.content.Layout = function(sender)
		self.selected.panel:SetSize(self.content:GetWidth(),self.content:GetHeight());
		self.selected.panel:Layout();
	end
	self.content:Layout();
  
	if (preventUpdate == nil) then
		self:LayoutTabs();
	end
	
	if (not dontSave) then self.selected:SaveState() end
end

-- ensure the tab at the specified index is fully visible
function CombatAnalysisTabbedWindow:EnsureTabVisible(index)
	self.offset = math.min(self.offset,(index-1)*(CombatAnalysisTabbedWindow.tabWidth+CombatAnalysisTabbedWindow.tabGap)+2*CombatAnalysisTabbedWindow.tabGap+self.tabListPane:GetWidth());
	self.offset = math.max(self.offset,index*(CombatAnalysisTabbedWindow.tabWidth+CombatAnalysisTabbedWindow.tabGap)+2*CombatAnalysisTabbedWindow.tabGap-self.tabListPane:GetWidth());
	self:LayoutTabs();
end

-- UI customization options

function CombatAnalysisTabbedWindow:SetTabsBackColorShowing(showBackColor)
	for i,tab in ipairs(self.tabs) do
		tab:SetBackColorShowing(showBackColor);
	end
end

function CombatAnalysisTabbedWindow:SaveState()
	-- does nothing (override in subclass if desired)
	
end
