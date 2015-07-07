
_G.TabsAndWindowsBox = class(Turbine.UI.Control);

function TabsAndWindowsBox:Constructor(statsMode)
  Turbine.UI.Control.Constructor(self);
  
  self.statsMode = statsMode;
  
  self.width = 380;
  self.height = 144;
  
  self.selected = nil;
  
  self:SetTop(90);
  self:SetSize(self.width,self.height);
  
  self:SetBackColor(blueBorderColor);
  
  self.background = Turbine.UI.Control();
  self.background:SetParent(self);
  self.background:SetPosition(1,1);
  self.background:SetSize(self.width-108,self.height-2,142);
  self.background:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self.background:SetMouseVisible(false);
  
  self.buffer = Turbine.UI.Control();
  self.buffer:SetParent(self);
  self.buffer:SetPosition(self.width-106,1);
  self.buffer:SetSize(105,142);
  self.buffer:SetBackColor(Turbine.UI.Color(0.95,0.05,0.05,0.1));
  self.buffer:SetMouseVisible(false);
  
  self.tabIcons = {}
  self.unusedTabs = {}
  self.windowIcons = {}
  
end

function TabsAndWindowsBox:SetParent(parent)
  Turbine.UI.Control.SetParent(self,parent);
  
  for _,tabIcon in ipairs(self.tabIcons) do
    tabIcon:SetVisible(parent ~= nil);
  end
  
  for _,windowIcon in ipairs(self.windowIcons) do
    windowIcon:SetVisible(parent ~= nil);
  end
end

function TabsAndWindowsBox:SetWindowSet(windowsSet)
  Misc.AddListener(windowsSet, "windowOpened", function(sender,window)
    self:AddWindow(window);
  end, self, self);
  
  Misc.AddListener(windowsSet, "windowClosed", function(sender,window)
    self:RemoveWindow(window);
  end, self, self);
end

function TabsAndWindowsBox:CreateTabIcon(tab)
  local icon = TabIcon(tab,self,self.statsMode);
  icon:SetParent(self);
  icon:SetPosition(x,y);
  self.tabIcons[tab] = icon;
  self:AddTabToBuffer(icon);
end

function TabsAndWindowsBox:AddTabToBuffer(tabIcon)
  tabIcon.parentIcon = self;
  
  table.insert(self.unusedTabs,tabIcon);
  self:LayoutBuffer();
end

function TabsAndWindowsBox:RemoveTabIcon(tabIcon)
  for index,icon in ipairs(self.unusedTabs) do
    if (icon == tabIcon) then
      table.remove(self.unusedTabs,index);
      self:LayoutBuffer();
      return;
    end
  end
end

function TabsAndWindowsBox:LayoutBuffer()
  -- order according to global ordering
	table.sort(self.unusedTabs,
		function(a,b)
    
			if (a.tab == dmgTab)    then return (b.tab ~= dmgTab) end
			if (b.tab == dmgTab)    then return false end
			if (a.tab == takenTab)  then return (b.tab ~= takenTab)  end
			if (b.tab == takenTab)  then return false end
			if (a.tab == healTab)   then return (b.tab ~= healTab)  end
			if (b.tab == healTab)   then return false end
			if (a.tab == powerTab)  then return (b.tab ~= powerTab)  end
      if (b.tab == powerTab)  then return false end
			if (a.tab == buffTab)   then return (b.tab ~= buffTab)  end
      
      return (b.tab == debuffTab);
		end
	);
  
  for index,icon in ipairs(self.unusedTabs) do
    icon:SetPosition(self.buffer:GetLeft()+(index%2 == 1 and 15 or 57), self.buffer:GetTop()+13+(Misc.Round(index/2)-1)*43);
  end
end

function TabsAndWindowsBox:AddWindow(window)
  local icon = WindowIcon(window,self,#self.windowIcons+1,self.statsMode);
  icon:SetParent(self);
  icon:SetPosition((#self.windowIcons < 2 and 11-Menu.selectionBorder or (self.windowIcons[#self.windowIcons-1]:GetLeft()+self.windowIcons[#self.windowIcons-1]:GetWidth()+6)),((#self.windowIcons%2 == 0 and 12 or 78)-Menu.selectionBorder));
  table.insert(self.windowIcons,icon);
  
  for _,tab in ipairs(self.statsMode and window.panels or window.tabs) do
    tab = (self.statsMode and tab.tab or tab);
    if (self.tabIcons[tab].parentIcon ~= nil) then self.tabIcons[tab].parentIcon:RemoveTabIcon(self.tabIcons[tab]) end
    icon:AddTabIcon(self.tabIcons[tab]);
  end
  
  Misc.AddListener(window, (self.statsMode and "panels" or "tabs"), function(sender)
    while (#icon.tabIcons > 0) do
      local tabIcon = icon.tabIcons[1];
      icon:RemoveTabIcon(tabIcon);
      self:AddTabToBuffer(tabIcon);
    end
    
    for _,tab in ipairs(self.statsMode and window.panels or window.tabs) do
      tab = (self.statsMode and tab.tab or tab);
      if (self.tabIcons[tab].parentIcon ~= nil) then self.tabIcons[tab].parentIcon:RemoveTabIcon(self.tabIcons[tab]) end
      icon:AddTabIcon(self.tabIcons[tab]);
    end
  end, self, self);
  
  return icon;
end

function TabsAndWindowsBox:RemoveWindow(window)
  Misc.RemoveListener(window, (self.statsMode and "panels" or "tabs") ,self);
  
  local windowIndex = nil;
  for index,icon in ipairs(self.windowIcons) do
    if (icon.window == window) then
      windowIndex = index;
      icon:SetParent(nil);
      Misc.RemoveListener(icon.window,"color",icon);
      
      while (#icon.tabIcons > 0) do
        local tabIcon = icon.tabIcons[1];
        icon:RemoveTabIcon(tabIcon);
        self:AddTabToBuffer(tabIcon);
      end
      
      table.remove(self.windowIcons,windowIndex);
      break;
    end
  end
  
  for index=windowIndex,#self.windowIcons do
    self.windowIcons[index]:SetPosition((index < 3 and 11-Menu.selectionBorder or (self.windowIcons[index-2]:GetLeft()+self.windowIcons[index-2]:GetWidth()+6)),((index%2 == 1 and 12 or 78)-Menu.selectionBorder));
    self.windowIcons[index].titleText:SetText(L.Window.." "..index);
  end
end

function TabsAndWindowsBox:UpdateWindowWidth(windowIcon)
  local windowIndex = nil;
  for index,icon in ipairs(self.windowIcons) do
    if (icon == windowIcon) then
      windowIndex = index;
      break;
    end
  end
  
  local index = windowIndex + 2;
  while (self.windowIcons[index] ~= nil) do
    self.windowIcons[index]:SetLeft(self.windowIcons[index-2]:GetLeft()+self.windowIcons[index-2]:GetWidth()+6);
    index = index + 2;
  end
end

function TabsAndWindowsBox:TabMovedTo(icon,x,y,newX,newY)
  local mouseUp = (newX == nil and newY == nil);
  
  addIcon:SetParent(nil);
  insertIcon:SetParent(nil);
  insertIcon.icon:SetVisible(not self.statsMode);
  removeIcon:SetParent(nil);
  if (self.hoverWindow ~= nil) then self.hoverWindow.titleBackground:SetBackColor(Turbine.UI.Color(0.925,backgroundColor.R,backgroundColor.G,backgroundColor.B)) end
  if (mouseUp and self.selected ~= nil and self.selected.window ~= nil) then self.selected.titleBackground:SetBackColor(WindowIcon.hoverColor) end
  
  -- 1) Move to existing window
  
  for _,newWindow in ipairs(self.windowIcons) do
    local iconX, iconY = newWindow:GetPosition();
    local iconW, iconH = newWindow:GetSize();
    
    if (x >= iconX and x <= iconX+iconW and y >= iconY and y <= iconY+iconH) then
      self.hoverWindow = newWindow;
      
      local newIndex;
      if (not self.statsMode) then newIndex = math.min(#newWindow.window.tabs+1,newWindow:GetIndexAt(x-newWindow:GetLeft())) end
      
      -- 1a) Re-order within current window
      if (newWindow == icon.parentIcon) then
        if (self.statsMode) then
          if (not mouseUp) then
            self.hoverWindow.titleBackground:SetBackColor(WindowIcon.hoverColor);
          end
          return false;
        end
        
        local currentIndex = newWindow.window:TabIndex(icon.tab);
        if (#newWindow.window.tabs == 1 or newIndex == currentIndex or newIndex == currentIndex+1) then
          if (not mouseUp) then
            self.hoverWindow.titleBackground:SetBackColor(WindowIcon.hoverColor);
          end
          return false;
        end
        
        if (mouseUp) then
          icon.tab:ReOrderTab(newWindow:GetIndexAt(x-newWindow:GetLeft(),y-newWindow:GetTop()),true);
        else
          self.hoverWindow.titleBackground:SetBackColor(WindowIcon.hoverColor);
          insertIcon:SetParent(self);
          insertIcon.text:SetText(L.ReOrder);
          insertIcon:SetPosition(newWindow:GetLeft()+(newIndex-1)*(TabIcon.width-2*Menu.selectionBorder+2),newWindow:GetTop()+newWindow:GetHeight()-2*Menu.selectionBorder-15);
        end
        
        return true;
      end
      
      if (mouseUp) then
        if (self.statsMode) then
          icon.tab.statsPanel:MovePanelToExistingWindow(newWindow.window,icon.tab.statsPanel);
        else
          icon.tab:MoveTabToExistingWindow(newWindow.window,newIndex,true);
        end
      else
        self.hoverWindow.titleBackground:SetBackColor(WindowIcon.hoverColor);
        insertIcon:SetParent(self);
        insertIcon.text:SetText(L.InsertTab);
        if (not self.statsMode) then
          insertIcon:SetPosition(newWindow:GetLeft()+(newIndex-1)*(TabIcon.width-2*Menu.selectionBorder+2),newWindow:GetTop()+newWindow:GetHeight()-2*Menu.selectionBorder-15);
        else
          insertIcon:SetPosition(newX+20,newY+5);
        end
      end
      
      return true;
    end
  end
  
  x = x + Menu.selectionBorder;
  y = y + Menu.selectionBorder;
  
  if (y < -6 or y > self.height + 24) then return false end
  
  -- 2) Move to new window
  
  if (x >= -6 and x <= self.width-108+Menu.selectionBorder) then
    if (icon.parentIcon ~= nil and #icon.parentIcon.tabIcons == 1) then return false end
    
    if (mouseUp) then
      if (self.statsMode) then
        icon.tab.statsPanel:MovePanelToNewWindow(true);
      else
        icon.tab:MoveTabToNewWindow(nil,nil,true);
      end
    else
      addIcon:SetParent(self);
      addIcon:SetPosition(newX+45,newY-5);
    end
    
    return true;
  end
  
  -- 3) Move to buffer (ie: Close Tab)
  
  if (x >= self.width-106+Menu.selectionBorder and x <= self.width+24) then
    if (icon.parentIcon == self) then return false end
    
    if (mouseUp) then
      if (self.statsMode) then
        icon.tab.statsPanel:RemovePanelFromWindow(icon.tab.statsPanel);
      else
        icon.tab.window:RemoveTab(icon.tab);
        icon.tab:SaveState();
      end
    else
      removeIcon:SetParent(self);
      removeIcon.text:SetText(#(self.statsMode and icon.tab.statsPanel.window.panels or icon.tab.window.tabs) > 1 and L.CloseTab or L.CloseWindow);
      removeIcon:SetPosition(newX-78,newY-5);
    end
    
    return true;
  end
end

function TabsAndWindowsBox:SelectWindow(window)
  if (self.selected ~= nil) then self.selected:SetSelected(false) end
  
  for _,windowIcon in pairs(self.windowIcons) do
    if (windowIcon.window == window) then
      self.selected = windowIcon;
      self.selected:SetSelected(true);
      break;
    end
  end
end

function TabsAndWindowsBox:SelectTab(tab)
  if (self.selected ~= nil) then self.selected:SetSelected(false) end
  
  self.selected = self.tabIcons[tab];
  self.selected:SetSelected(true);
end

function TabsAndWindowsBox:WindowSelected(windowIcon)
  self.windowsMenu:SelectWindow(windowIcon.window);
end

function TabsAndWindowsBox:TabSelected(tabIcon)
  if (not self.statsMode) then self.tabsMenu:SelectTab(tabIcon.tab) end
end
