
--[[

A Tooltip is a very simple window to display helpful text
information.

]]--

-- enum of possible tooltip styles
_G.TooltipStyle = {}
TooltipStyle.LOTRO = 1;
TooltipStyle.Menu = 2;
TooltipStyle.CombatAnalysis = 3;

_G.tooltip = {}; -- only one tooltip of each style is ever active at once
_G.Tooltip = class(Turbine.UI.Window);

function Tooltip:Constructor(text,style,maxWidth,control,x,y,delay,duration,oldValue,override,height)
	Turbine.UI.Window.Constructor(self);
  
  self.hide = (style ~= TooltipStyle.Menu);
  
  self.text = text;
  self.style = style;
  self.control = control;
  self.x = x;
  self.y = y;
  self.oldValue = oldValue;
  self.override = override;
  self.fixedWidth = maxWidth - (style == TooltipStyle.LOTRO and 14 or (style == TooltipStyle.Menu and 12 or 0));
  
  self:SetMouseVisible(style == TooltipStyle.Menu);
  
  if (height ~= nil) then
    self:Layout({maxWidth,height});
  else
    Misc.DetermineLength(self.text,
      (style == TooltipStyle.LOTRO and Turbine.UI.Lotro.Font.TrajanPro16 or (style == TooltipStyle.Menu and Turbine.UI.Lotro.Font.TrajanPro14 or Turbine.UI.Lotro.Font.TrajanPro15)),
      Tooltip.Layout,self,self.fixedWidth);
  end
  
  self:SetZOrder(9);
  
  if (style == TooltipStyle.Menu) then
    local timestamp = Turbine.Engine.GetGameTime();
    
    if (not self.cleared) then
      self.startTime = timestamp;
      self:SetOpacity(0);
    end
    
    if (duration ~= nil) then
      self.endTime = timestamp+duration;
      self:SetWantsUpdates(true);
    end
  end
end

function Tooltip:Update()
  local timestamp = Turbine.Engine.GetGameTime();
  
  -- fade out
  if (self.ended ~= nil) then
    proportion = (1 - math.min(1,(timestamp-self.ended)/0.3));
    
    self:SetOpacity(proportion);
    if (proportion == 0) then self:Close() end
    
  -- fade in
  elseif (self.startTime ~= nil) then
    local proportion = math.min(1,(timestamp-self.startTime)/0.3);
  
    self:SetOpacity(proportion);
    if (proportion == 1) then
      self.startTime = nil;
      if (self.endTime == nil and self.ended == nil) then self:SetWantsUpdates(false) end
    end
  end
  
  -- time out
  if (self.endTime ~= nil and timestamp >= self.endTime) then
    self.endTime = nil;
    self.ended = timestamp;
  end
end

function Tooltip:SetVisible(visible,dontSetHeight)
  if (visible) then
    if (self.width == nil or self.height == nil) then return end
    
    -- close any existing tooltip
    if (self.style == TooltipStyle.Menu) then
      local t = tooltip[self.style];
      local existingTooltip = (t ~= self and t ~= nil);
      if (existingTooltip) then
        local tooltipToRemove = (self.style == TooltipStyle.Menu and dontSetHeight and self or t);
        
        if (tooltipToRemove.style == TooltipStyle.Menu) then
          tooltipToRemove:SetVisible(false);
        else
          tooltipToRemove:Close();
        end
        
        if (self.style == TooltipStyle.Menu and dontSetHeight) then return end
      end
      tooltip[self.style] = self;
    end
  
    if (self.style == TooltipStyle.Menu) then
      local dw,dh = Turbine.UI.Display.GetSize();
      
      if (not dontSetHeight and self.oldValue ~= nil and self.oldValue ~= "") then
        self:SetHeight(self.height);
        self.border1:SetHeight(self.height);
        self.border2:SetHeight(self.height-2);
        self.center:SetHeight(self.height-4);
      end
      
      local x,y = self.control:GetParent():PointToScreen(self.control:GetPosition());
      local w,h = self.control:GetSize();
      local tx = x+(w-self.width)/2;
      local ty = y+h+6;
      
      if (tx + self.width >= dw) then tx = dw-self.width end
      if (ty + self.height >= dh) then ty = y-self:GetHeight()-6 end
      
      self:SetPosition(Misc.Round(tx),ty);
      
    else
      self.x,self.y = WindowManager.ValidatePosition(self.x,self.y,self:GetWidth(),self:GetHeight())
      self:SetPosition(self.x,self.y);
      
    end
    
    if (self.style == TooltipStyle.Menu) then
      if (not dontSetHeight and not self.override) then
        self:SetOpacity(1);
        self.endTime = nil;
        self.ended = nil;
        self:SetWantsUpdates(false);
      end
      
      if (self.override and existingTooltip) then
        self:SetOpacity(1);
        self.cleared = true;
        self.startTime = nil;
        self:SetWantsUpdates(self.endTime ~= nil or self.ended ~= nil);
      end
    end
    
  else
    self.endTime = nil;
    self.ended = nil;
    if (tooltip[self.style] == self) then tooltip[self.style] = nil end
    
  end  
  
  Turbine.UI.Window.SetVisible(self,visible);
end

function Tooltip:Activated()
  if (self.style == TooltipStyle.Menu) then
    self:SetVisible(false);
  else
    self:Close();
  end
end

function Tooltip:Close()
  if (self.style == TooltipStyle.Menu) then
    self:SetWantsUpdates(false);
    if (tooltip[self.style] == self) then tooltip[self.style] = nil end
  end
  
  Turbine.UI.Window.Close(self);
end

function Tooltip:Layout(size)
  local width = (self.style == TooltipStyle.Menu and self.fixedWidth or size[1]);
  local height = size[2];
  
	-- Mimicks the LOTRO look and feel
	if (self.style == TooltipStyle.LOTRO) then
    self.width = width + 14;
    self.height = height + 6;
    
    self:SetSize(self.width,self.height);
    
    self.center = Turbine.UI.Control();
    self.center:SetParent(self);
    self.center:SetBackColor(Turbine.UI.Color(.925,0,0,0));
    self.center:SetMouseVisible(false);
    
    self.label = Turbine.UI.Label();
    self.label:SetParent(self);
    self.label:SetMultiline(true);
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
    self.label:SetForeColor(Turbine.UI.Color(0.82,0.74,0.55));
    self.label:SetBackColor(Turbine.UI.Color(.925,0,0,0));
    self.label:SetMouseVisible(false);
    
    self.topLeft = Turbine.UI.Control();
    self.topLeft:SetParent(self);
    self.topLeft:SetSize(19, 19);
    self.topLeft:SetMouseVisible(false);
    self.topLeft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.topLeft:SetBackground("CombatAnalysis/Resources/basepanel_topleft.tga");
    
    self.topRight = Turbine.UI.Control();
    self.topRight:SetParent(self);
    self.topRight:SetSize(19, 19);
    self.topRight:SetMouseVisible(false);
    self.topRight:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.topRight:SetBackground("CombatAnalysis/Resources/basepanel_topright.tga");
    
    self.bottomLeft = Turbine.UI.Control();
    self.bottomLeft:SetParent(self);
    self.bottomLeft:SetSize(19, 19);
    self.bottomLeft:SetMouseVisible(false);
    self.bottomLeft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.bottomLeft:SetBackground("CombatAnalysis/Resources/basepanel_bottomleft.tga");
    
    self.bottomRight = Turbine.UI.Control();
    self.bottomRight:SetParent(self);
    self.bottomRight:SetSize(19, 19);
    self.bottomRight:SetMouseVisible(false);
    self.bottomRight:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.bottomRight:SetBackground("CombatAnalysis/Resources/basepanel_bottomright.tga");
    
    self.top = Turbine.UI.Control();
    self.top:SetParent(self);
    self.top:SetSize(0, 3);
    self.top:SetMouseVisible(false);
    self.top:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.top:SetBackground("CombatAnalysis/Resources/basepanel_topmid.tga");
    
    self.left = Turbine.UI.Control();
    self.left:SetParent(self);
    self.left:SetSize(3, 0);
    self.left:SetMouseVisible(false);
    self.left:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.left:SetBackground("CombatAnalysis/Resources/basepanel_midleft.tga");
    
    self.right = Turbine.UI.Control();
    self.right:SetParent(self);
    self.right:SetSize(3, 0);
    self.right:SetMouseVisible(false);
    self.right:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.right:SetBackground("CombatAnalysis/Resources/basepanel_midright.tga");
    
    self.bottom = Turbine.UI.Control();
    self.bottom:SetParent(self);
    self.bottom:SetSize(0, 3);
    self.bottom:SetMouseVisible(false);
    self.bottom:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    self.bottom:SetBackground("CombatAnalysis/Resources/basepanel_bottommid.tga");
    
    -- special case to prevent the shadows on the corners from overlapping
    if (self.height < 38) then
        self.topLeft:SetPosition(0, 0);
        self.top:SetPosition(19, 0);
        self.topRight:SetPosition(self.width - 19, 0);
        self.bottom:SetPosition(1, self.height - 3);
        self.left:SetPosition(0, 19);
        self.right:SetPosition(self.width - 3, 19);
        self.center:SetPosition(3, 3);
        self.label:SetPosition(7, 3);
        
        self.top:SetWidth(self.width - 38);
        self.bottom:SetWidth(self.width - 2);
        self.left:SetHeight(self.height - 22);
        self.right:SetHeight(self.height - 22);
        self.center:SetSize(self.width - 6, self.height - 6);
        self.label:SetSize(self.width - 14, self.height - 6);
        self.bottomLeft:SetSize(0, 0);
        self.bottomRight:SetSize(0, 0);
    else
        self.topLeft:SetPosition(0, 0);
        self.top:SetPosition(19, 0);
        self.topRight:SetPosition(self.width - 19, 0);
        self.bottomLeft:SetPosition(0, self.height - 19);
        self.bottom:SetPosition(19, self.height - 3);
        self.bottomRight:SetPosition(self.width - 19, self.height - 19);
        self.left:SetPosition(0, 19);
        self.right:SetPosition(self.width - 3, 19);
        self.center:SetPosition(3, 3);
        self.label:SetPosition(7, 3);
        
        self.top:SetWidth(self.width - 38);
        self.bottom:SetWidth(self.width - 38);
        self.left:SetHeight(self.height - 38);
        self.right:SetHeight(self.height - 38);
        self.center:SetSize(self.width - 6, self.height - 6);
        self.label:SetSize(self.width - 14, self.height - 6);
    end
    
  -- For Menu Validation
  elseif (self.style == TooltipStyle.Menu) then
    self.width = width + 12;
    self.height = height + 12;
    
    self:SetSize(self.width,self.height);
    
    self.border1 = Turbine.UI.Control();
    self.border1:SetParent(self);
    self.border1:SetBackColor(Turbine.UI.Color(200/255,50/255,0/255));
    self.border1:SetPosition(1,0);
    self.border1:SetSize(self.width-2,self.height);
    self.border1:SetMouseVisible(false);
    
    self.border2 = Turbine.UI.Control();
    self.border2:SetParent(self);
    self.border2:SetBackColor(Turbine.UI.Color(200/255,50/255,0/255));
    self.border2:SetPosition(0,1);
    self.border2:SetSize(self.width,self.height-2);
    self.border2:SetMouseVisible(false);
    
    self.center = Turbine.UI.Control();
    self.center:SetParent(self);
    self.center:SetBackColor(Turbine.UI.Color(0.9,255/255,100/255,80/255));
    self.center:SetPosition(2,2);
    self.center:SetSize(self.width-4,self.height-4);
    self.center:SetMouseVisible(false);
    
    self.label = Turbine.UI.Label();
    self.label:SetParent(self);
    self.label:SetMultiline(true);
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
    self.label:SetForeColor(Turbine.UI.Color(0.4,0.1,0.1));
    self.label:SetPosition(6,6);
    self.label:SetSize(width,height);
    self.label:SetMouseVisible(false);
    
    if (self.oldValue ~= nil and self.oldValue ~= "") then
      local oldValueFitsInLine = Misc.TextFitsIn(self.oldValue,Turbine.UI.Lotro.Font.TrajanPro13,width-100);
      self.height = height + 54 - (oldValueFitsInLine and 18 or 0);
      
      self.gap = Turbine.UI.Control();
      self.gap:SetParent(self);
      self.gap:SetBackColor(Turbine.UI.Color(200/255,50/255,0/255));
      self.gap:SetPosition(6,6+height+5);
      self.gap:SetSize(self.width-12,2);
      self.gap:SetMouseVisible(false);
      
      self.oldTitleLabel = Turbine.UI.Label();
      self.oldTitleLabel:SetParent(self);
      self.oldTitleLabel:SetMultiline(false);
      self.oldTitleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
      self.oldTitleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);
      self.oldTitleLabel:SetForeColor(Turbine.UI.Color(0.2,0.04,0.04));
      self.oldTitleLabel:SetPosition(6,6+height+12);
      self.oldTitleLabel:SetSize(width,12);
      self.oldTitleLabel:SetText("Current Value:");
      self.oldTitleLabel:SetMouseVisible(false);
      
      self.oldLabel = Turbine.UI.Label();
      self.oldLabel:SetParent(self);
      self.oldLabel:SetMultiline(false);
      self.oldLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
      self.oldLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopRight);
      self.oldLabel:SetForeColor(Turbine.UI.Color(0.4,0.1,0.1));
      self.oldLabel:SetPosition(6 + (oldValueFitsInLine and 100 or 0),6+height+12+(oldValueFitsInLine and 0 or 18));
      self.oldLabel:SetSize(width - (oldValueFitsInLine and 100 or 0),12);
      self.oldLabel:SetText(self.oldValue);
      self.oldLabel:SetMouseVisible(false);
    end
    
  -- For styled Combat Analysis Tooltips
  elseif (self.style == TooltipStyle.CombatAnalysis) then
    self.width = width + 0;
    self.height = height + 0;
    
    self:SetSize(self.width,self.height);
    
  end
  
  self.label:SetText(self.text);
  
  if (style ~= TooltipStyle.Menu or self.endTime == nil or self.endTime > Turbine.Engine.GetGameTime()) then self:SetVisible(true,not self.override) end
  if (style == TooltipStyle.Menu) then self:SetWantsUpdates(true) end
end
