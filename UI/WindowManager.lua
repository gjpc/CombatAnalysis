
-- declare some global UI variables
_G.mouseDown = false;
_G.openComboBox = nil;

--[[

A series of Static Window Helper Functions.

Note this file includes many functions that are applied to
a "set" of windows. These sets should be ordered such that
the first element if the highest (most recently activated)
window.

]]--

_G.WindowManager = {}

WindowManager.linkRange = 5; -- number of pixels away to snap into range

-- return x,y co-ordinates that will ensure the window is in the display (on screen)
function WindowManager.ValidatePosition(x,y,w,h,topExtra,rightExtra,bottomExtra,leftExtra)
	if (topExtra == nil) then topExtra = 0 end
	if (rightExtra == nil) then rightExtra = topExtra end
	if (bottomExtra == nil) then bottomExtra = rightExtra end
	if (leftExtra == nil) then leftExtra = bottomExtra end
	
  x = math.min(math.max(x,-leftExtra),Turbine.UI.Display:GetWidth()+rightExtra-w);
  y = math.min(math.max(y,-topExtra),Turbine.UI.Display:GetHeight()+bottomExtra-h);
	
	return x,y;
end

-- convenience method to constrain a window to the display
function WindowManager.ConstrainWindowToScreen(window,topExtra,rightExtra,bottomExtra,leftExtra)
	window:SetPosition(WindowManager.ValidatePosition(window:GetLeft(),window:GetTop(),window:GetWidth(),window:GetHeight(),topExtra,rightExtra,bottomExtra,leftExtra));
end

-- centers a window in the middle of the screen
function WindowManager.CenterOnScreen(window,topExtra,rightExtra,bottomExtra,leftExtra)
  local w,h = window:GetSize();
  local totalW,totalH = Turbine.UI.Display:GetSize();
  
	window:SetPosition(WindowManager.ValidatePosition((totalW-w)/2,(totalH-h)/2,w,h,topExtra,rightExtra,bottomExtra,leftExtra));
  if (window:IsVisible()) then
    window:Activate();
  end
end

-- returns the xy co-ordinates that snap the window to any neighboring windows
--  (note when snapping windows we always assume a combat analysis border and resize overhang)
--  (also note we go through the window sets in the order specified)
function WindowManager.SnapTo(windowSets,x,y,w,h)
	local x1 = x+CombatAnalysisWindow.resizeHangover;
	local y1 = y+CombatAnalysisWindow.resizeHangover;
	local x2 = x1+w-2*CombatAnalysisWindow.resizeHangover;
	local y2 = y1+h-2*CombatAnalysisWindow.resizeHangover;
	
	local newX = x;
	local newY = y;
	
	for _,windowSet in ipairs(windowSets) do
		for _,window in ipairs(windowSet) do
			-- determine other window position and size
			local ox,oy = window:GetPosition();
			local ow,oh = window:GetSize();
			local ox1 = ox+CombatAnalysisWindow.resizeHangover;
			local oy1 = oy+CombatAnalysisWindow.resizeHangover;
			local ox2 = ox1+ow-2*CombatAnalysisWindow.resizeHangover;
			local oy2 = oy1+oh-2*CombatAnalysisWindow.resizeHangover;
			
			-- 1) check if in vertical range for horizontal linking
			if (y2-WindowManager.linkRange > oy1 and y1+WindowManager.linkRange < oy2) then
				-- a) check if the other window is within the bounds of the right side of this window
				if (ox1-WindowManager.linkRange < x2 and ox1+WindowManager.linkRange+CombatAnalysisWindow.border+1 > x2) then
					newX = ox1-w+CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover;
					-- now check if we should vertically snap as well
					local rangeY1 = math.abs(oy1-y1);
					local rangeY2 = math.abs(oy2-y2);
					if (rangeY2<rangeY1 and rangeY2<WindowManager.linkRange) then
						newY = oy2-h+CombatAnalysisWindow.resizeHangover;
					elseif (rangeY1<=rangeY2 and rangeY1<WindowManager.linkRange) then
						newY = oy1-CombatAnalysisWindow.resizeHangover;
					end
					return newX,newY;
				end
				
				-- b) check if the other window is within the bounds of the left side of this window
				if (ox2-WindowManager.linkRange-CombatAnalysisWindow.border-1 < x1 and ox2+WindowManager.linkRange > x1) then
					newX = ox2-CombatAnalysisWindow.border-CombatAnalysisWindow.resizeHangover;
					-- now check if we should vertically snap as well
					local rangeY1 = math.abs(oy1-y1);
					local rangeY2 = math.abs(oy2-y2);
					if (rangeY2<rangeY1 and rangeY2<WindowManager.linkRange) then
						newY = oy2-h+CombatAnalysisWindow.resizeHangover;
					elseif (rangeY1<=rangeY2 and rangeY1<WindowManager.linkRange) then
						newY = oy1-CombatAnalysisWindow.resizeHangover;
					end
					return newX,newY;
				end
				
			end
			
			-- 2) check if in horizontal range for vertical linking
			if (x2-WindowManager.linkRange > ox1 and x1+WindowManager.linkRange < ox2) then
				-- c) check if the other window is within the bounds of the bottom of this window
				if (oy1-WindowManager.linkRange < y2 and oy1+WindowManager.linkRange+CombatAnalysisWindow.border+1 > y2) then
					newY = oy1-h+CombatAnalysisWindow.border+CombatAnalysisWindow.resizeHangover;
					-- now check if we should horizontally snap as well
					local rangeX1 = math.abs(ox1-x1);
					local rangeX2 = math.abs(ox2-x2);
					if (rangeX2<rangeX1 and rangeX2<WindowManager.linkRange) then
						newX = ox2-w+CombatAnalysisWindow.resizeHangover;
					elseif (rangeX1<=rangeX2 and rangeX1<WindowManager.linkRange) then
						newX = ox1-CombatAnalysisWindow.resizeHangover;
					end
					return newX,newY;
				end
				
				-- Check if the other window is within the bounds of the top of this window
				if (oy2-WindowManager.linkRange-CombatAnalysisWindow.border-1 < y1 and oy2+WindowManager.linkRange > y1) then
					newY = oy2-CombatAnalysisWindow.border-CombatAnalysisWindow.resizeHangover;
					-- now check if we should horizontally snap as well
					local rangeX1 = math.abs(ox1-x1);
					local rangeX2 = math.abs(ox2-x2);
					if (rangeX2<rangeX1 and rangeX2<WindowManager.linkRange) then
						newX = ox2-w+CombatAnalysisWindow.resizeHangover;
					elseif (rangeX1<=rangeX2 and rangeX1<WindowManager.linkRange) then
						newX = ox1-CombatAnalysisWindow.resizeHangover;
					end
					return newX,newY;
				end
			end
		end
	end
	
	-- no window to snap to
	return x,y;
end

-- ensure a window remains above a minimum size, and is in the display
function WindowManager.ValidateSize(x,y,w,h,minW,minH,anchorBottom,anchorRight,topExtra,rightExtra,bottomExtra,leftExtra)
	if (topExtra == nil) then topExtra = 0 end
	if (rightExtra == nil) then rightExtra = topExtra end
	if (bottomExtra == nil) then bottomExtra = rightExtra end
	if (leftExtra == nil) then leftExtra = bottomExtra end

	xShift = math.max(-x-leftExtra,0) + math.max(x+w-rightExtra-Turbine.UI.Display:GetWidth(),0);
	yShift = math.max(-y-topExtra,0) + math.max(y+h-bottomExtra-Turbine.UI.Display:GetHeight(),0);
	
	wShift = math.max(0,minW-w);
	hShift = math.max(0,minH-h);
	
	if (anchorBottom == nil and anchorRight == nil) then
		x = x-Misc.Round(wShift/2)+math.max(-x-leftExtra,0);
		y = y-Misc.Round(hShift/2)+math.max(-y-topExtra,0);
	end
	
	x = x-(anchorRight and wShift or 0)+(anchorRight and xShift or 0);
	y = y-(anchorBottom and hShift or 0)+(anchorBottom and yShift or 0);
	w = math.max(w,minW)-xShift;
  h = math.max(h,minH)-yShift;
	
  return x,y,w,h;
end

-- scale a window and all the elements inside it, using stretch mode
WindowManager.BaseScaleInfos = {}

function WindowManager.GetControlScaleInfo(control,scaleInfo)
  local tw,th = control:GetSize();
  local children = control:GetControls();
  for i=1,children:GetCount() do
    local child = children:Get(i);
    local x,y = child:GetPosition();
    local w,h = child:GetSize();
    
    if (child:GetStretchMode() == 1) then
      w,h = child:GetStretchSize();
    else
      child:SetStretchMode(1);
    end
    
    scaleInfo[child] = {}
    scaleInfo[child]["Info"] = { x = (x/tw), y = (y/th), w = (w/tw), h = (h/th) }
    WindowManager.GetControlScaleInfo(child,scaleInfo[child]);
  end
end

function WindowManager.ScaleControl(control,scaleInfo)
  local tw,th = control:GetSize();
  local children = control:GetControls();
  for i=1,children:GetCount() do
    local child = children:Get(i);
    local childScaleInfo = scaleInfo[child]["Info"];
    child:SetPosition(childScaleInfo.x*tw,childScaleInfo.y*th);
    child:SetSize(childScaleInfo.w*tw,childScaleInfo.h*th);
    if (child.Layout) then child:Layout() end
    WindowManager.ScaleControl(child,scaleInfo[child]);
  end
end

function WindowManager.ScaleWindow(window,width,height)
  Turbine.UI.Window.SetSize(window,width,height);
  
  -- 1) On first call, get/calculate the position/scale info of all elements within the window
  local scaleInfo = WindowManager.BaseScaleInfos[window];
  if (scaleInfo == nil) then
    scaleInfo = {}
    WindowManager.GetControlScaleInfo(window,scaleInfo);
    WindowManager.BaseScaleInfos[window] = scaleInfo;
    return;
  end
  
  -- 2) On subsequent calls, rescale the window based on the original calculated info
  WindowManager.ScaleControl(window,scaleInfo);
end

-- determine if the mouse is inside any window in the provided window set
function WindowManager.GetMouseInsideWindow(windowSet,ignoreWindow)
	for i,window in ipairs(windowSet) do
		local x,y = window:GetMousePosition();
		local w,h = window:GetSize();
		
		if (x > CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border and x < w-2*(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border) and
				y > CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border and y < h-2*(CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border)) then
			
			if (window ~= ignoreWindow) then
					return window;
			end
		end
	end
	-- return nil if the mouse is not inside any tabbed panes
	return nil;
end

-- determine if the mouse is inside the tabbed pane of any window in the provided window set
function WindowManager.GetMouseInsideTabbedPane(tabbedWindowSet,ignoreWindow)
	for i,tabbedWindow in ipairs(tabbedWindowSet) do
		if (tabbedWindow:IsMouseInsideTabbedPane() and tabbedWindow ~= ignoreWindow) then
			return tabbedWindow;
		end
	end
	-- return nil if the mouse is not inside any tabbed panes
	return nil;
end

-- activates (or deactivates) auto scroll mode for each window in the provided window set
function WindowManager.ActivateAutoScrollMode(activate,tabbedWindowSet,ignoreWindow)
	for i,tabbedWindow in ipairs(tabbedWindowSet) do
		if (tabbedWindow ~= ignoreWindow) then
			tabbedWindow:SetAutoScrollEnabled(activate);
		end
	end
end

-- if show is true, ensure tabs in all windows in the provided window set are showing,
-- otherwise, hide tabs in windows that have auto hide activated (we do this by calling
-- the mouse enter and leave functions (note this is only okay since they ignore the
-- args functions)
function WindowManager.ShowAllTabs(show,tabbedWindowSet)
	for _,tabbedWindow in ipairs(tabbedWindowSet) do
		if (show) then
			tabbedWindow:MouseEnter();
		else
			tabbedWindow:MouseLeave();
		end
	end
end

local windowStates = {}
-- on successive calls, shows/hides all windows in a set (or just all windows) and then restores all windows in the set to their previous state
function WindowManager.ShowHideWindows(windowSet,show,set,id)
	-- if no window set provided, apply the method to all windows (ie: F12 was pressed)
	windowSet = (windowSet == nil and allWindows or windowSet);
	
	-- show or hide all windows in the set
	if (set) then
		-- (preserve the window ordering by stepping through list in reverse)
		for i=#windowSet,1,-1 do
			local window = windowSet[i];
      if (window.hiddenTriggers == nil) then window.hiddenTriggers = {} end
      if (window.visibleTriggers == nil) then window.visibleTriggers = {} end
      
      if (next(window.visibleTriggers) == nil and next(window.hiddenTriggers) == nil) then
        windowStates[window] = window:IsVisible();
      end
      
      if (next(show and window.visibleTriggers or window.hiddenTriggers) == nil) then
        show = (next(window.hiddenTriggers) == nil and show);
        -- show or hide the windows
        if (show) then
          if (not window:IsVisible()) then
            window:SetOpacity(0.5);
            window:SetVisible(true,true,true);
          end
        else
          window:SetVisible(false,true,true);
        end
      end
      
      (show and window.visibleTriggers or window.hiddenTriggers)[id] = true;
		end
	
	-- return windows to their previous state
	else
		for i=#windowSet,1,-1 do
			local window = windowSet[i];
      if (window.hiddenTriggers == nil) then window.hiddenTriggers = {} end
      if (window.visibleTriggers == nil) then window.visibleTriggers = {} end
      (show and window.visibleTriggers or window.hiddenTriggers)[id] = nil;
      
      if (next(show and window.visibleTriggers or window.hiddenTriggers) == nil) then
        -- show or hide the windows
        local newState;
        if (next(show and window.hiddenTriggers or window.visibleTriggers) ~= nil) then
          newState = (not show);
        else
          newState = windowStates[window];
        end
        
        if (newState) then
          if (not window:IsVisible()) then
            window:SetVisible(true,true,true);
          end
        else
          window:SetVisible(false,true,true);
          window:SetOpacity(1);
        end
      end
		end
	end
	
end

-- any time a mouse down event is triggered, this method should be called to ensure the
-- window is activated, and any open combo boxes are closed (this method runs slightly
-- more efficiently if the window is passed in directly instead of a component in the
-- window)
function WindowManager.MouseWasPressed(component)
	if (component ~= nil) then
		-- if this component has a parent, activate its owner instead (which should eventually be a window)
		if (component:GetParent() ~= nil) then
			WindowManager.MouseWasPressed(component:GetParent());
			return;
		end
		-- activate the window
    if (component.Activate ~= nil) then
      component:Activate();
    end
	end
end

-- returns the the owning window of this control
function WindowManager.GetWindow(control)
	local parent = control:GetParent();
	
	if (parent == nil) then
		return control;
	else
		return  WindowManager.GetWindow(parent);
	end
end

-- returns the x,y screen position of a control
function WindowManager.GetPositionOnScreen(control)
	local parent = control:GetParent();
	
	if (parent == nil) then
		return control:GetPosition();
	else
		local parentX,parentY = WindowManager.GetPositionOnScreen(parent);
		local controlX,controlY = control:GetPosition();
		return (parentX+controlX),(parentY+controlY);
	end
end
