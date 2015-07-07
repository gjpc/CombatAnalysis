
--[[

A Tabbed Pane with standardd LOTRO tabs. The pane 
area is resized during the Layout() function.

]]--

_G.TabbedPane = class(Turbine.UI.Control);

function TabbedPane:Constructor(window,parent)
	Turbine.UI.Control.Constructor(self);
	
	-- reference to the containing window for focus grabbing
	self.window = window;
  self.parent = parent;
	
	self:SetMouseVisible(false);
	
	self.tabs = {};
	self.selected = 0;
	
	-- thin blue border
	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetPosition(1,23);
	self.border:SetZOrder(-1);
	self.border:SetMouseVisible(false);
	self.border:SetBackColor(blueBorderColor);
end

function TabbedPane:AddTab(tabName,content)
	local tabIndex = #self.tabs+1;
	
	-- create new tab
	local newTab = Tab(self,tabIndex,tabName,content);
	-- add to tabs table
	table.insert(self.tabs,newTab);
	
	-- if this is the first added tab, select it
	if (tabIndex == 1) then
		self:SelectTab(tabIndex);
	end
end

function TabbedPane:SelectTab(tabIndex,reselect)
	if ((tabIndex == self.selected and not reselect) or tabIndex > #self.tabs) then return end
	
	if (self.selected ~= 0) then
		self.tabs[self.selected]:SetSelected(false);
	end
  
	self.selected = tabIndex;
  
  local tab = (self.selected ~= 0 and self.tabs[self.selected] or nil);
  if (tab ~= nil) then
    tab:SetSelected(true);
    self:SetHeight(self.tabs[self.selected].content.height+31);
  end
  
  self:Layout();
  
  if (tab == nil) then return end
  
  local i = 1;
  local tabbedPane = self;
  while (tabbedPane.parent ~= nil) do
    local parentPanel = tabbedPane.parent;
    parentPanel.height = tab.content.height+(31*i)+parentPanel.baseHeight;
    parentPanel:SetHeight(parentPanel.height);
    
    tabbedPane = parentPanel.parent;
    if (tabbedPane == nil) then break end
    
    if (tabbedPane.tabs[tabbedPane.selected].content == parentPanel) then
      tabbedPane:SetHeight(parentPanel.height+31);
      tabbedPane:Layout();
    end
    
    i = i+1;
  end
end

function TabbedPane:RemoveTab(tabIndex)
  local tab = self.tabs[tabIndex];
  tab:SetParent(nil);
  
  local moveSelectedDown = (self.selected > tabIndex);
  
  if (self.selected == tabIndex) then
    if (#self.tabs >= self.selected+1) then
      moveSelectedDown = true;
      self:SelectTab(self.selected+1,true);
    else
      self:SelectTab(self.selected-1,true);
    end
  end
  
  table.remove(self.tabs,tabIndex);
  
  if (moveSelectedDown) then
    self.selected = self.selected-1;
  end
end

function TabbedPane:SizeChanged(args)
	self:Layout();
end

function TabbedPane:Layout()
  local w,h = self:GetSize();
  self.border:SetSize(w-5,h-29);
  
  if (self.selected == 0) then return end
  
  self.tabs[self.selected].content:SetWidth(w-7);
  self.tabs[self.selected].content:Layout();
end
