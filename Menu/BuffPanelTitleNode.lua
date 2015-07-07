
_G.BuffPanelTitleNode = class(Turbine.UI.TreeNode);

function BuffPanelTitleNode:Constructor(parent,padding,buffType)
	Turbine.UI.TreeNode.Constructor(self);
  
  self.errors = 0;
  
  self.parent = parent;
  self.listeners = {}
  
  self.buffType = buffType;
  
  self.height = 29;
  self.padding = padding;
  
	self:SetHeight(self.height);
  self:SetBackColor(Turbine.UI.Color(0.925,0,0,0));
  
  self.tl = Turbine.UI.Control();
  self.tl:SetParent(self);
  self.tl:SetPosition(0,0);
  self.tl:SetSize(3,3);
  self.tl:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.tl:SetMouseVisible(false);
  
  self.t = Turbine.UI.Control();
  self.t:SetParent(self);
  self.t:SetPosition(3,0);
  self.t:SetHeight(3);
  self.t:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.t:SetMouseVisible(false);
  
  self.tr = Turbine.UI.Control();
  self.tr:SetParent(self);
  self.tr:SetTop(0);
  self.tr:SetSize(3,3);
  self.tr:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.tr:SetMouseVisible(false);
  
  self.l = Turbine.UI.Control();
  self.l:SetParent(self);
  self.l:SetPosition(0,3);
  self.l:SetSize(3,self.height-6-padding);
  self.l:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.l:SetMouseVisible(false);
  
  self.c = Turbine.UI.Control();
  self.c:SetParent(self);
  self.c:SetPosition(3,3);
  self.c:SetHeight(self.height-6-padding);
  self.c:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.c:SetMouseVisible(false);
  self.c:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
  self.r = Turbine.UI.Control();
  self.r:SetParent(self);
  self.r:SetTop(3);
  self.r:SetSize(3,self.height-6-padding);
  self.r:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.r:SetMouseVisible(false);
  
  self.bl = Turbine.UI.Control();
  self.bl:SetParent(self);
  self.bl:SetPosition(0,self.height-3-padding);
  self.bl:SetSize(3,3);
  self.bl:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.bl:SetMouseVisible(false);
  
  self.b = Turbine.UI.Control();
  self.b:SetParent(self);
  self.b:SetPosition(3,self.height-3-padding);
  self.b:SetHeight(3);
  self.b:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.b:SetMouseVisible(false);
  
  self.br = Turbine.UI.Control();
  self.br:SetParent(self);
  self.br:SetTop(self.height-3-padding);
  self.br:SetSize(3,3);
  self.br:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.br:SetMouseVisible(false);
  
  self.classIcon = Turbine.UI.Control();
  self.classIcon:SetParent(self);
  self.classIcon:SetPosition(10,3+(self.height-6-padding-20+1)/2);
  self.classIcon:SetSize(20,20);
  self.classIcon:SetMouseVisible(false);
  self.classIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.classIcon:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
	self.classLabel = Turbine.UI.Label();
	self.classLabel:SetParent(self);
	self.classLabel:SetMouseVisible(false);
	self.classLabel:SetMultiline(false);
  self.classLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.classLabel:SetForeColor(Turbine.UI.Color(1,1,1));
  self.classLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
  
  self.skillIcon = Turbine.UI.Control();
  self.skillIcon:SetParent(self);
  self.skillIcon:SetPosition(90,3+(self.height-6-padding-16+1)/2);
  self.skillIcon:SetSize(16,16);
  self.skillIcon:SetMouseVisible(false);
  self.skillIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.skillIcon:SetBackColorBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
	self.skillLabel = Turbine.UI.Label();
	self.skillLabel:SetParent(self);
	self.skillLabel:SetMouseVisible(false);
	self.skillLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.skillLabel:SetMultiline(false);
  self.skillLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
  self.skillLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);  
  
  self.plus = Turbine.UI.Control();
  self.plus:SetParent(self);
  self.plus:SetTop(3+(self.height-padding-15-6)/2);
  self.plus:SetSize(15,15);
  self.plus:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  self.plus:SetBackground(0x41007E27);
  self.plus:SetMouseVisible(false);
  
  if (self.buffType == "Debuff") then
    self.mouseEventTheft = Turbine.UI.Control();
    self.mouseEventTheft:SetParent(self);
    self.mouseEventTheft:SetTop(0);
    self.mouseEventTheft:SetSize(65,self.height);
    
    self.mouseEventTheft.MouseDown = function(sender,args)
      self.clicked = true;
      self:MouseDown();
    end
    
    self.mouseEventTheft.MouseDoubleClick = function(sender,args)
      self.clicked = false;
    end
  
    self.tick1 = Turbine.UI.Control();
    self.tick1:SetParent(self);
    self.tick1:SetTop(3+(self.height-padding-18-6)/2);
    self.tick1:SetSize(24,18);
    self.tick1:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    TooltipManager.SetTooltip(self.tick1,L.MakeDebuffActiveInCombatAnalysisTooltip,TooltipStyle.LOTRO,500);
    
    self.tick1.MouseDown = function(sender,args)
      self.clicked = true;
      Traits.UpdateCA(self.buffInfo, not self.buffInfo.ca);
      self.tick1:SetBackground(self.buffInfo.ca and 0x410e3f4a or "CombatAnalysis/Resources/cross.tga");
      self:MouseDown();
      self.parent:UpdateChecked(true,self.buffInfo.ca or self.buffInfo.removalOnly);
    end
    
    self.tick2 = Turbine.UI.Control();
    self.tick2:SetParent(self);
    self.tick2:SetTop(3+(self.height-padding-18-6)/2+1);
    self.tick2:SetSize(24,18);
    self.tick2:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
    TooltipManager.SetTooltip(self.tick2,L.MakeDebuffActiveInBuffBarsTooltip,TooltipStyle.LOTRO,500);
    
    self.tick2.MouseDown = function(sender,args)
      self.clicked = true;
      Traits.UpdateBB(self.buffInfo, not self.buffInfo.bb);
      self.tick2:SetBackground(self.buffInfo.bb and 0x410e3f4a or "CombatAnalysis/Resources/cross.tga");
      self:MouseDown();
      self.parent:UpdateChecked(false,self.buffInfo.bb or self.buffInfo.removalOnly);
    end
  end
  
  self:SetSelected(false);
end

function BuffPanelTitleNode:SetBuff(buffInfo)
  -- clear listeners to the old buff
  for _,listener in ipairs(self.listeners) do
    Misc.RemoveListener(listener[1],listener[2],listener[3]);
  end
  self.listeners = {}
  
  self.buffInfo = buffInfo;
  self.class = self.buffInfo.class;
  self.skillName = self.buffInfo.skillName;
  self.remover = self.buffInfo.removalOnly;
  self.iconName = self.buffInfo.iconName;
  self.bb = self.buffInfo.bb;
  
  self.c:SetBackColor(self.errors > 0 and Turbine.UI.Color(0.95,0.15,0.05,0.05) or Turbine.UI.Color(0,0,0,0));
  
  local icon = Misc.ClassToIcon(self.class);
  self.classIcon:SetVisible(icon ~= nil);
  if (icon ~= nil) then self.classIcon:SetBackground(icon) end
  
  self.classLabel:SetTextAlignment((icon == nil and Turbine.UI.ContentAlignment.MiddleCenter or Turbine.UI.ContentAlignment.MiddleLeft));
	self.classLabel:SetText(icon == nil and (self.class == nil and "" or L[self.class][1]) or L[self.class][2]);  
  self.classLabel:SetPosition((icon == nil and 10 or 35),3);
	self.classLabel:SetSize((icon == nil and 60 or 35),self.height-self.padding-6);
  
  table.insert(self.listeners,{self.buffInfo,"class",self});
  Misc.AddListener(self.buffInfo, "class", function(sender)    
		if (self.buffInfo.class ~= self.class) then
      self.class = self.buffInfo.class;
			local icon = Misc.ClassToIcon(self.buffInfo.class);
      self.classIcon:SetVisible(icon ~= nil);
      if (icon ~= nil) then self.classIcon:SetBackground(icon) end
      self.classLabel:SetText(icon == nil and (self.class == nil and "" or L[self.class][1]) or L[self.class][2]);
      self.classLabel:SetPosition((icon == nil and 10 or 35),3);
      self.classLabel:SetSize((icon == nil and 60 or 35),self.height-self.padding-6);
      self.classLabel:SetTextAlignment((icon == nil and Turbine.UI.ContentAlignment.MiddleCenter or Turbine.UI.ContentAlignment.MiddleLeft));
		end
	end, self, self);
  
  self.skillIcon:SetVisible(((self.buffType == "Debuff" and self.buffInfo.bb) or self.buffType == "CrowdControl") and not self.remover);
  self.skillIcon:SetBackground("CombatAnalysis/Resources/DebuffIcons/"..((self.buffInfo.invalidIcon or self.iconName == nil) and "default.tga" or self.iconName));
  
  table.insert(self.listeners,{self.buffInfo,"iconName",self});
  Misc.AddListener(self.buffInfo, "iconName", function(sender)    
		if (self.buffInfo.iconName ~= self.iconName) then
      self.iconName = self.buffInfo.iconName;
      self.skillIcon:SetVisible(((self.buffType == "Debuff" and self.buffInfo.bb) or self.buffType == "CrowdControl") and not self.remover);
			self.skillIcon:SetBackground("CombatAnalysis/Resources/DebuffIcons/"..((self.buffInfo.invalidIcon or self.iconName == nil) and "default.tga" or self.iconName));
      self.skillLabel:SetPosition(((((self.buffType ~= "Debuff" or not self.buffInfo.bb) and self.buffType ~= "CrowdControl") or self.remover) and 90 or 111),3);
      self.skillLabel:SetSize(((self.iconName == nil or self.remover) and 175 or 154)+(self.remover and 60 or 0),self.height-self.padding-6);
		end
	end, self, self);
  
  self.skillLabel:SetPosition(((((self.buffType ~= "Debuff" or not self.buffInfo.bb) and self.buffType ~= "CrowdControl") or self.remover) and 90 or 111),3);
	self.skillLabel:SetSize(((self.iconName == nil or self.remover) and 175 or 154)+(self.remover and 60 or 0),self.height-self.padding-6);
  self.skillLabel:SetForeColor(self.skillName == "" and Turbine.UI.Color(0.75,0.7,0.6) or Turbine.UI.Color(1,1,1));
	self.skillLabel:SetText((self.remover and "("..L.RemoverPrefix..") " or "")..(self.skillName == "" and " < "..L.NameRequiredPrefix.." >" or self.skillName));
  
  table.insert(self.listeners,{self.buffInfo,"skillName",self});
  Misc.AddListener(self.buffInfo, "skillName", function(sender) 
		if (self.buffInfo.skillName ~= self.skillName) then
      self.skillName = self.buffInfo.skillName;
      self.skillLabel:SetForeColor(Turbine.UI.Color(1,1,1));
			self.skillLabel:SetText((self.remover and "("..L.RemoverPrefix..") " or "")..(self.skillName == "" and " < "..L.NameRequiredPrefix.." >" or self.skillName));
		end
	end, self, self);
  
  table.insert(self.listeners,{self.buffInfo,"removalOnly",self});
  Misc.AddListener(self.buffInfo, "removalOnly", function(sender)
    if (self.buffInfo.removalOnly ~= self.remover) then
      self.remover = self.buffInfo.removalOnly;
      self.skillIcon:SetVisible(((self.buffType == "Debuff" and self.buffInfo.bb) or self.buffType == "CrowdControl") and not self.remover);
			self.skillIcon:SetBackground("CombatAnalysis/Resources/DebuffIcons/"..((self.buffInfo.invalidIcon or self.iconName == nil) and "default.tga" or self.iconName));
      self.skillLabel:SetPosition(((((self.buffType ~= "Debuff" or not self.buffInfo.bb) and self.buffType ~= "CrowdControl") or self.remover)  and 90 or 111),3);
      self.skillLabel:SetSize(((self.iconName == nil or self.remover) and 175 or 154)+(self.remover and 60 or 0),self.height-self.padding-6);
      self.skillLabel:SetText((self.remover and "("..L.RemoverPrefix..") " or "")..(self.skillName == "" and " < "..L.NameRequiredPrefix.." >" or self.skillName));
      self.mouseEventTheft:SetVisible(not self.buffInfo.removalOnly);
      self.tick1:SetVisible(not self.buffInfo.removalOnly);
      self.tick2:SetVisible(not self.buffInfo.removalOnly);
      
      if (not self.buffInfo.ca) then
        self.parent:UpdateChecked(true,self.buffInfo.removalOnly);
      end
      
      if (not self.buffInfo.bb) then
        self.parent:UpdateChecked(false,self.buffInfo.removalOnly);
      end
    end
	end, self, self);
  
  table.insert(self.listeners,{self.buffInfo,"bb",self});
  Misc.AddListener(self.buffInfo, "bb", function(sender)
    if (self.buffInfo.bb ~= self.bb) then
      self.bb = self.buffInfo.bb;
      self.skillIcon:SetVisible(((self.buffType == "Debuff" and self.buffInfo.bb) or self.buffType == "CrowdControl") and not self.remover);
      self.skillLabel:SetPosition(((((self.buffType ~= "Debuff" or not self.buffInfo.bb) and self.buffType ~= "CrowdControl") or self.remover)  and 90 or 111),3);
    end
	end, self, self);
  
  if (self.buffType == "Debuff") then
    self.tick1:SetBackground(self.buffInfo.ca and 0x410e3f4a or "CombatAnalysis/Resources/cross.tga");
    self.tick2:SetBackground(self.buffInfo.bb and 0x410e3f4a or "CombatAnalysis/Resources/cross.tga");
    
    self.mouseEventTheft:SetVisible(not self.buffInfo.removalOnly);
    self.tick1:SetVisible(not self.buffInfo.removalOnly);
    self.tick2:SetVisible(not self.buffInfo.removalOnly);
  end
end

function BuffPanelTitleNode:Layout()
	local w = self:GetWidth();
  
  self.t:SetWidth(w-6);
  self.tr:SetLeft(w-3);
  self.c:SetWidth(w-6);
  self.r:SetLeft(w-3);
  self.b:SetWidth(w-6);
  self.br:SetLeft(w-3);
  
  self.plus:SetLeft(w-15-self.plus:GetTop());
  
  if (self.buffType == "Debuff") then
    self.tick1:SetLeft(w-15-self.plus:GetTop()-38);
    self.tick2:SetLeft(w-15-self.plus:GetTop()-71);
    self.mouseEventTheft:SetLeft(w-15-self.plus:GetTop()-77);
  end
end

function BuffPanelTitleNode:AddError()
  self.errors = self.errors + 1;
  self.c:SetBackColor(self.errors > 0 and Turbine.UI.Color(0.95,0.15,0.05,0.05) or Turbine.UI.Color(0,0,0,0));
end

function BuffPanelTitleNode:RemoveError()
  self.errors = self.errors - 1;
  self.c:SetBackColor(self.errors > 0 and Turbine.UI.Color(0.95,0.15,0.05,0.05) or Turbine.UI.Color(0,0,0,0));
  self.skillLabel:SetForeColor(self.skillName == "" and Turbine.UI.Color(0.75,0.7,0.6) or Turbine.UI.Color(1,1,1));
end

function BuffPanelTitleNode:SetSelected(selected)
  self.tl:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_top_left.tga");
  self.t:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_top_center.tga");
  self.tr:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_top_right.tga");
  self.l:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_middle_left.tga");
  self.r:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_middle_right.tga");
  self.bl:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_bottom_left.tga");
  self.b:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_bottom_center.tga");
  self.br:SetBackground("CombatAnalysis/Resources/social_panel_list_elements_"..(selected and "highlight" or "normal").."_lower_right.tga");
end

function BuffPanelTitleNode:MouseEnter(args)
  self:SetSelected(true);
end

function BuffPanelTitleNode:MouseLeave(args)
  self:SetSelected(false);
end

function BuffPanelTitleNode:MouseDown(args)
	KeyManager.TakeFocus(self);
end
