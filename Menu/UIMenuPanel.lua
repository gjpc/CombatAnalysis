
_G.UIMenuPanel = class(Turbine.UI.Control);

function UIMenuPanel:Constructor(window,parent)
	Turbine.UI.Control.Constructor(self);
	
	self.window = window;
	self.width = 420;
	self.height = 11;
  self.baseHeight = self.height;
  self.parent = parent;
	
  self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self:SetHeight(self.height);
  
	self.listBox = Turbine.UI.ListBox();
	self.listBox:SetParent(self);
	self.listBox:SetPosition(5,5);
	
	self.content = Turbine.UI.Control();
	self.content:SetParent(self.listBox);
	self.content:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.subMenuPane = TabbedPane(nil,self);
  self.tabsSubMenuPanel = TabsSubMenuPanel(nil,self.width-24,self);
  self.windowsSubMenuPanel = WindowsSubMenuPanel(nil,self.width-24,self);
  self.statsWindowsSubMenuPanel = StatsWindowsSubMenuPanel(nil,self.width-24,self);
  
  self.subMenuPane:AddTab(L.Tabs,self.tabsSubMenuPanel);
  self.subMenuPane:AddTab(L.Windows,self.windowsSubMenuPanel);
  self.subMenuPane:AddTab(L.Stats,self.statsWindowsSubMenuPanel);
  
  self.subMenuPane:SetParent(self.content);
  
	self.listBox:AddItem(self.content);
	
	self.hScroll = Turbine.UI.Lotro.ScrollBar();
	self.hScroll:SetParent(self);
	self.hScroll:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
	self.hScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.hScroll:SetHeight(10);
	self.listBox:SetHorizontalScrollBar(self.hScroll);
end

function UIMenuPanel:Layout()
	local w,h = self:GetSize();
	
	self.listBox:SetSize(w-10,h-12);
	self.content:SetSize(math.max(self.width,w-10),math.max(self.height,h-12));
  
  self.subMenuPane:SetWidth(math.max(self.width-4,w-6));
  
	self.hScroll:SetTop(h-10);
	self.hScroll:SetWidth(w);
end

function UIMenuPanel:ContentSelected()
  local content = self.subMenuPane.tabs[self.subMenuPane.selected].content;
  if (content.ContentSelected) then content:ContentSelected() end
end

function UIMenuPanel:ContentDeselected()
  local content = self.subMenuPane.tabs[self.subMenuPane.selected].content;
  if (content.ContentDeselected) then content:ContentDeselected() end
end

function UIMenuPanel:MouseDown()
	if (self.window ~= nil) then WindowManager.MouseWasPressed(self.window) end
end