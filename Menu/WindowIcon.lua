
_G.WindowIcon = class(Turbine.UI.Control);

WindowIcon.baseWidth = 82;
WindowIcon.height = 59;

WindowIcon.hoverColor = Turbine.UI.Color(0.925,0.3,0.3,0);

function WindowIcon:Constructor(window,panel,index,statsMode)
  Turbine.UI.Control.Constructor(self);
  
  self.statsMode = statsMode;
  
  self.window = window;
  self.panel = panel;
  
  self.width = WindowIcon.baseWidth;
  
  local borderColor = Turbine.UI.Color(0.5,0.5,0.5);
  
  self:SetSize(self.width,WindowIcon.height);
  
  self.border = Turbine.UI.Control();
  self.border:SetParent(self);
  self.border:SetPosition(Menu.selectionBorder,Menu.selectionBorder);
  self.border:SetSize(self.width-2-2*Menu.selectionBorder,WindowIcon.height-2*Menu.selectionBorder);
  self.border:SetBackColor(borderColor);
  self.border:SetMouseVisible(false);
  
  self.titleBackground = Turbine.UI.Control();
  self.titleBackground:SetParent(self.border);
  self.titleBackground:SetPosition(2,2);
  self.titleBackground:SetSize(self.width-6-2*Menu.selectionBorder,11);
  self.titleBackground:SetBackColor(Turbine.UI.Color(0.925,backgroundColor.R,backgroundColor.G,backgroundColor.B));
  self.titleBackground:SetMouseVisible(false);
  
  self.titleText = MenuLabel(self,1+Menu.selectionBorder,self.width-12-2*Menu.selectionBorder,10);
  self.titleText:SetLeft(5+Menu.selectionBorder);
  self.titleText:SetForeColor(CombatAnalysisComboBox.selectionColor);
  self.titleText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
  self.titleText:SetText(L.Window.." "..index);
  self.titleText:SetMouseVisible(false);
  
  self.background = Turbine.UI.Control();
  self.background:SetParent(self.border);
  self.background:SetPosition(2,15);
  self.background:SetSize(self.width-6-2*Menu.selectionBorder,WindowIcon.height-17-2*Menu.selectionBorder);
  self.background:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  self.background:SetMouseVisible(false);
  
  self.backgroundOverlay = Turbine.UI.Control();
  self.backgroundOverlay:SetParent(self.background);
  self.backgroundOverlay:SetSize(self.width-6-2*Menu.selectionBorder,WindowIcon.height-17-2*Menu.selectionBorder);
  self.backgroundOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
  self.backgroundOverlay:SetMouseVisible(false);
  
  self.tabIcons = {}
  
  self.selectionControls = {}
  
  table.insert(self.selectionControls,self:BuildSelectionControl(0,0,Menu.selectionBorder,Menu.selectionBorder,"top_left"));
  table.insert(self.selectionControls,self:BuildSelectionControl(0,Menu.selectionBorder,Menu.selectionBorder,WindowIcon.height-2*Menu.selectionBorder,"left"));
  table.insert(self.selectionControls,self:BuildSelectionControl(0,WindowIcon.height-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,"bottom_left"));
  
  self.top = self:BuildSelectionControl(Menu.selectionBorder,0,self.width-2*Menu.selectionBorder,Menu.selectionBorder,"top");
  self.bottom = self:BuildSelectionControl(Menu.selectionBorder,WindowIcon.height-Menu.selectionBorder,self.width-2*Menu.selectionBorder,Menu.selectionBorder,"bottom");
  self.topRight = self:BuildSelectionControl(self.width-Menu.selectionBorder,0,Menu.selectionBorder,Menu.selectionBorder,"top_right");
  self.right = self:BuildSelectionControl(self.width-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,WindowIcon.height-2*Menu.selectionBorder,"right");
  self.bottomRight = self:BuildSelectionControl(self.width-Menu.selectionBorder,WindowIcon.height-Menu.selectionBorder,Menu.selectionBorder,Menu.selectionBorder,"bottom_right");
  
  table.insert(self.selectionControls,self.top);
  table.insert(self.selectionControls,self.bottom);
  table.insert(self.selectionControls,self.topRight);
  table.insert(self.selectionControls,self.right);
  table.insert(self.selectionControls,self.bottomRight);
  
  self.titleBorder1 = Turbine.UI.Control();
  self.titleBorder1:SetParent(self);
  self.titleBorder1:SetPosition(1+Menu.selectionBorder,Menu.selectionBorder);
  self.titleBorder1:SetSize(self.width-2*Menu.selectionBorder,2);
  self.titleBorder1:SetBackColor(borderColor);
  self.titleBorder1:SetMouseVisible(false);
  
  self.titleBorder2 = Turbine.UI.Control();
  self.titleBorder2:SetParent(self);
  self.titleBorder2:SetPosition(1+Menu.selectionBorder,13+Menu.selectionBorder);
  self.titleBorder2:SetSize(self.width-2*Menu.selectionBorder,2);
  self.titleBorder2:SetBackColor(borderColor);
  self.titleBorder2:SetMouseVisible(false);
  
  Misc.AddListener(self.window,"color",function()
    self.backgroundOverlay:SetBackColor(window.color);
  end,self,self);
end

function WindowIcon:BuildSelectionControl(x,y,w,h,icon)
  local control = Turbine.UI.Control();
  control:SetParent(self);
  control:SetPosition(x,y);
  control:SetSize(w,h);
  control:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  control:SetBackground("CombatAnalysis/Resources/selected_control_"..icon..".tga");
  control:SetVisible(false);
  return control;
end

function WindowIcon:SetSelected(selected)
  self.titleBackground:SetBackColor(selected and WindowIcon.hoverColor or Turbine.UI.Color(0.925,backgroundColor.R,backgroundColor.G,backgroundColor.B));  
  
  for _,selectionControl in ipairs(self.selectionControls) do
    selectionControl:SetVisible(selected);
  end
end

function WindowIcon:Layout()
  self.width = self:GetWidth();
  
  self.border:SetWidth(self.width-2-2*Menu.selectionBorder);
  self.titleBackground:SetWidth(self.width-6-2*Menu.selectionBorder);
  self.titleText:SetWidth(self.width-12-2*Menu.selectionBorder);
  self.titleBorder1:SetWidth(self.width-2*Menu.selectionBorder);
  self.titleBorder2:SetWidth(self.width-2*Menu.selectionBorder);
  self.background:SetWidth(self.width-6-2*Menu.selectionBorder);
  self.backgroundOverlay:SetWidth(self.width-6-2*Menu.selectionBorder);
  
  self.top:SetWidth(self.width-2*Menu.selectionBorder-2);
  self.bottom:SetWidth(self.width-2*Menu.selectionBorder-2);
  self.topRight:SetLeft(self.width-Menu.selectionBorder-2);
  self.right:SetLeft(self.width-Menu.selectionBorder-2);
  self.bottomRight:SetLeft(self.width-Menu.selectionBorder-2);
  
  for index,tabIcon in ipairs(self.tabIcons) do
    tabIcon:SetPosition(self:GetLeft()+5+(index-1)*(TabIcon.width-2*Menu.selectionBorder+2),self:GetTop()+18);
  end
end

function WindowIcon:AddTabIcon(tabIcon)
  tabIcon.parentIcon = self;
  
  table.insert(self.tabIcons,tabIcon);
  if (self.statsMode) then
    table.sort(self.tabIcons,
      function(a,b)
        
      	if (a.tab == dmgTab)    then return (b.tab ~= dmgTab) end
        if (b.tab == dmgTab)    then return false end
        if (a.tab == takenTab)  then return (b.tab ~= takenTab)  end
        if (b.tab == takenTab)  then return false end
        if (a.tab == healTab)   then return (b.tab ~= healTab)  end
        
        return (b.tab == powerTab);
      end
    );
  end
  
  self:SetWidth(math.max(WindowIcon.baseWidth,10+2*Menu.selectionBorder+#self.tabIcons*(TabIcon.width-2*Menu.selectionBorder+2)));
  self:Layout();
  
  self.panel:UpdateWindowWidth(self);
end

function WindowIcon:RemoveTabIcon(tabIcon)
  tabIcon.parentIcon = nil;
  
  local iconIndex = nil;
  for index,icon in ipairs(self.tabIcons) do
    if (iconIndex ~= nil) then
      icon:SetLeft(self:GetLeft()+5+(index-2)*34);
    elseif (icon == tabIcon) then
      iconIndex = index;
    end
  end
  table.remove(self.tabIcons,iconIndex);
  
  self:SetWidth(math.max(WindowIcon.baseWidth,10+2*Menu.selectionBorder+#self.tabIcons*(TabIcon.width-2*Menu.selectionBorder+2)));
  self:Layout();
  
  self.panel:UpdateWindowWidth(self);
end

function WindowIcon:GetIndexAt(x)
  local index = 0;
  while (x >= (index*(TabIcon.width-2*Menu.selectionBorder+2)+(5+(TabIcon.width-2*Menu.selectionBorder+2)/2))) do
    index = index + 1;
  end
  return index+1;
end

function WindowIcon:PositionChanged()
  for index,icon in ipairs(self.tabIcons) do
    icon:SetPosition(self:GetLeft()+5+(index-1)*(TabIcon.width-2*Menu.selectionBorder+2),self:GetTop()+18);
  end
end

function WindowIcon:MouseDown(args)
  self.panel:WindowSelected(self);
end
