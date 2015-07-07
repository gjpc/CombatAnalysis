
_G.TabIcon = class(Turbine.UI.Control);

TabIcon.width = 36;
TabIcon.height = 36;

function TabIcon:Constructor(tab,panel,statsTab)
  Turbine.UI.Control.Constructor(self);
  
  self.tab = tab;
  self.panel = panel;
  
  self:SetSize(TabIcon.width,TabIcon.height);
  self:SetZOrder(1);
  
  self.background = Turbine.UI.Control();
  self.background:SetParent(self);
  self.background:SetSize(TabIcon.width-2*Menu.selectionBorder,TabIcon.height-2*Menu.selectionBorder);
  self.background:SetPosition(Menu.selectionBorder,Menu.selectionBorder);
  self.background:SetBackground(statsTab and 0x410dd1b3 or 0x41000001);
  self.background:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.background:SetMouseVisible(false);
  
  self.overlay = Turbine.UI.Control();
  self.overlay:SetParent(self.background);
  self.overlay:SetSize(TabIcon.width-2*Menu.selectionBorder,TabIcon.height-2*Menu.selectionBorder);
  self.overlay:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.overlay:SetMouseVisible(false);
  
  self.label = Turbine.UI.Label();
  self.label:SetParent(self.overlay);
  self.label:SetSize(TabIcon.width-2*Menu.selectionBorder,TabIcon.height-2*Menu.selectionBorder);
  self.label:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
  self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.label:SetForeColor(control2LightColor);
  self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
  self.label:SetOutlineColor(Turbine.UI.Color(0,0,0));
  self.label:SetText(string.sub(self.tab.titleText[1],1,3));
  self.label:SetMouseVisible(false);
  
  self.selectionControls = {}
  
  table.insert(self.selectionControls,self:BuildSelectionControl(0,0,Menu.selectionBorder,Menu.selectionBorder,"top_left"));
  table.insert(self.selectionControls,self:BuildSelectionControl(Menu.selectionBorder,0,TabIcon.width-2*Menu.selectionBorder,Menu.selectionBorder,"top"));
  table.insert(self.selectionControls,self:BuildSelectionControl(TabIcon.width-Menu.selectionBorder,0,Menu.selectionBorder,Menu.selectionBorder,"top_right"));
  table.insert(self.selectionControls,self:BuildSelectionControl(0,Menu.selectionBorder,Menu.selectionBorder,TabIcon.height-2*Menu.selectionBorder,"left"));
  table.insert(self.selectionControls,self:BuildSelectionControl(TabIcon.width-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,TabIcon.height-2*Menu.selectionBorder,"right"));
  table.insert(self.selectionControls,self:BuildSelectionControl(0,TabIcon.height-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,"bottom_left"));
  table.insert(self.selectionControls,self:BuildSelectionControl(Menu.selectionBorder,TabIcon.height-Menu.selectionBorder,TabIcon.width-2*Menu.selectionBorder,Menu.selectionBorder,"bottom"));
  table.insert(self.selectionControls,self:BuildSelectionControl(TabIcon.width-Menu.selectionBorder,TabIcon.height-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,"bottom_right"));
  
  Misc.AddListener(self.tab,"color",function()
    self.overlay:SetBackColor(Turbine.UI.Color(statsTab and 0.35 or 0.35,tab.color.R,tab.color.G,tab.color.B));
  end,self,self);
end

function TabIcon:BuildSelectionControl(x,y,w,h,icon)
  local control = Turbine.UI.Control();
  control:SetParent(self);
  control:SetPosition(x,y);
  control:SetSize(w,h);
  control:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  control:SetBackground("CombatAnalysis/Resources/selected_control_"..icon..".tga");
  control:SetVisible(false);
  return control;
end

function TabIcon:SetSelected(selected)
  for _,selectionControl in ipairs(self.selectionControls) do
    selectionControl:SetVisible(selected);
  end
end

function TabIcon:MouseDown(args)
  if (self.pressed) then return end
  
  self.pressed = true;
  
  self.x = self:GetLeft();
  self.y = self:GetTop();
  
  self.startX = self.x+args.X-25;
  self.startY = self.y+args.Y-25;
  
  self:SetZOrder(2);
  self:SetPosition(self.startX,self.startY);
  self.panel:TabMovedTo(self,self.startX+25,self.startY+25,self.startX,self.startY);
  
  self.panel:TabSelected(self);
  
  if (self.parentIcon ~= nil and self.parentIcon ~= self.panel and #self.parentIcon.tabIcons == 1) then self.parentIcon:SetVisible(false) end
end

function TabIcon:MouseMove(args)
  if (self.pressed) then
    local newX = self.startX+(self:GetLeft()-self.startX)+(args.X-25);
    local newY = self.startY+(self:GetTop()-self.startY)+(args.Y-25);
    
    self:SetPosition(newX,newY);
    self.panel:TabMovedTo(self,newX+args.X,newY+args.Y,newX,newY);
  end
end

function TabIcon:MouseUp(args)
  self.pressed = false;
  
  if (not self.panel:TabMovedTo(self,self:GetLeft()+args.X,self:GetTop()+args.Y)) then
    if (self.parentIcon ~= nil and self.parentIcon ~= self.panel and #self.parentIcon.tabIcons == 1) then self.parentIcon:SetVisible(true) end
    self:SetPosition(self.x,self.y);
  end
  
  self:SetZOrder(1);
end

