
--[[

A Combat Analysis Tree Panel contains a Tree View which
includes a list viewable statistics.

]]--


_G.StatOverviewStatsPanel = class(Turbine.UI.Control);

StatOverviewStatsPanel.dataTitleHeight = 17;
StatOverviewStatsPanel.skillBulletWidth = 22;

function StatOverviewStatsPanel:Constructor(tab,mainTitle,psTitle,showAvoids,showCorruptions,showTempMorale)
	Turbine.UI.Control.Constructor(self);
	
	self.category = "";
	
	self.tab = tab;
	self.showAvoids = showAvoids;
	self.showTempMorale = showTempMorale;
	self.showCorruptions = showCorruptions;
	
	self.selectedPlayer = player.name;
	self.selectedSkill = nil;
	
	self.totalAmount = 0;
	self.totalAttacks = 0;
  
	self:SetMouseVisible(false);
	
	-- title & duration bar
	self.durationBar = Turbine.UI.Control();
	self.durationBar:SetParent(self);
	self.durationBar:SetPosition(0,0);
	self.durationBar:SetHeight(CombatAnalysisWindow.titleBarHeight);
	self.durationBar:SetMouseVisible(true);
	-- pass on mouse events to window
	self.durationBar.MouseDown = function(sender,args)
		WindowManager.GetWindow(self):MouseDown(args);
	end
	self.durationBar.MouseMove = function(sender,args)
		WindowManager.GetWindow(self):MouseMove(args);
	end
	self.durationBar.MouseUp = function(sender,args)
		WindowManager.GetWindow(self):MouseUp(args);
	end
	
	-- title
	self.title = Turbine.UI.Label();
	self.title:SetParent(self.durationBar);
	self.title:SetZOrder(1);
	self.title:SetPosition(2*CombatAnalysisWindow.border,0);
	self.title:SetHeight(CombatAnalysisWindow.titleBarHeight);
	self.title:SetText(player.name);
	self.title:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.title:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.title:SetMultiline(false);
	self.title:SetMouseVisible(false);
	self.title:SetForeColor(controlLightColor);
	
	-- lock icon
	self.lockIcon = Turbine.UI.Control();
	self.lockIcon:SetSize(20,19);
	self.lockIcon:SetTop(math.max(0,math.ceil((CombatAnalysisWindow.titleBarHeight-19)/2)));
	self.lockIcon:SetZOrder(2);
	self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight_normal.tga");
	self.lockIcon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.lockIcon:SetMouseVisible(true);
	
	self.lockIcon.MouseEnter = function(sender, args)
		self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight_rollover.tga");
	end
	self.lockIcon.MouseLeave = function(sender, args)
		self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight"..(self.lockIcon.pressed and "_rollover" or "_normal")..".tga");
	end
	self.lockIcon.MouseDown = function(sender, args)
		WindowManager.MouseWasPressed(self.window);
		self.lockIcon.pressed = true;
		self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight_rollover.tga");
	end
	self.lockIcon.MouseUp = function(sender, args)
		self.lockIcon.pressed = false;
		self.lockIcon:SetBackground("CombatAnalysis/Resources/button_lock_highlight_normal.tga");
	end
	self.lockIcon.MouseClick = function(sender, args)
		self.window:SetLocked(nil,nil,false);
		self:FullUpdate(nil,true,false,self.tab.panel.barsPanel.selectedPlayer,nil);
	end
	self.lockIcon.MouseDoubleClick = function(sender, args)
		self.lockIcon:MouseClick(args);
	end
	
	-- icons denoting which panels are in the same window
	self.panelIcons = {};
	
	-- first panel icon (this panel)
	local iconBorder = Turbine.UI.Control();
	self:AddIcon(self,true);
	
	-- duration
	self.durationLabel = Turbine.UI.Label();
	self.durationLabel:SetParent(self.durationBar);
	self.durationLabel:SetZOrder(2);
	self.durationLabel:SetSize(StatOverviewPanel.durationWidth,CombatAnalysisWindow.titleBarHeight);
	self.durationLabel:SetText("0m 00s");
	self.durationLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.durationLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.durationLabel:SetMultiline(false);
	self.durationLabel:SetMouseVisible(false);
	self.durationLabel:SetForeColor(controlLightColor);
	
	-- first border
	self.upperBorder = Turbine.UI.Control();
	self.upperBorder:SetParent(self);
	self.upperBorder:SetBackColor(borderColor);
	self.upperBorder:SetPosition(0,CombatAnalysisWindow.titleBarHeight);
	self.upperBorder:SetHeight(CombatAnalysisWindow.border);
	self.upperBorder:SetMouseVisible(false);
	
	-- data title/select bar
	self.dataBar = Turbine.UI.Control();
	self.dataBar:SetParent(self);
	self.dataBar:SetPosition(0,CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border);
	self.dataBar:SetHeight(StatOverviewStatsPanel.dataTitleHeight);
	self.dataBar:SetMouseVisible(false);
	
	-- skill title border
	self.skillTitleBorder = Turbine.UI.Control();
	self.skillTitleBorder:SetParent(self.dataBar);
	self.skillTitleBorder:SetBackColor(borderColor);
	self.skillTitleBorder:SetSize(CombatAnalysisWindow.border,StatOverviewStatsPanel.dataTitleHeight);
	self.skillTitleBorder:SetMouseVisible(false);
	
	-- skill title background
	self.skillTitleBackground = Turbine.UI.Control();
	self.skillTitleBackground:SetParent(self.dataBar);
	self.skillTitleBackground:SetHeight(StatOverviewStatsPanel.dataTitleHeight);
	self.skillTitleBackground:SetMouseVisible(false);
	
	-- skill title bullet
	self.skillTitleBullet = Turbine.UI.Label();
	self.skillTitleBullet:SetParent(self.dataBar);
	self.skillTitleBullet:SetZOrder(1);
	self.skillTitleBullet:SetPosition(5*CombatAnalysisWindow.border,-1);
	self.skillTitleBullet:SetSize(StatOverviewStatsPanel.skillBulletWidth,StatOverviewStatsPanel.dataTitleHeight);
	self.skillTitleBullet:SetText("> ");
	self.skillTitleBullet:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.skillTitleBullet:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.skillTitleBullet:SetForeColor(controlLightColor);
	self.skillTitleBullet:SetMultiline(false);
	self.skillTitleBullet:SetMouseVisible(false);
	
	-- skill title
	self.skillTitle = Turbine.UI.Label();
	self.skillTitle:SetParent(self.dataBar);
	self.skillTitle:SetZOrder(1);
	self.skillTitle:SetPosition(StatOverviewStatsPanel.skillBulletWidth+2*CombatAnalysisWindow.border,0);
	self.skillTitle:SetHeight(StatOverviewStatsPanel.dataTitleHeight);
	self.skillTitle:SetText(L.AllSkills);
	self.skillTitle:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	self.skillTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.skillTitle:SetForeColor(controlLightColor);
	self.skillTitle:SetMultiline(false);
	self.skillTitle:SetMouseVisible(false);
	
	-- data title background
	self.dataTitleBackground = Turbine.UI.Control();
	self.dataTitleBackground:SetParent(self.dataBar);
	self.dataTitleBackground:SetSize(108,StatOverviewStatsPanel.dataTitleHeight);
	self.dataTitleBackground:SetMouseVisible(true);
	
	-- data title
	self.dataTitle = Turbine.UI.Label();
	self.dataTitle:SetParent(self.dataTitleBackground);
	self.dataTitle:SetZOrder(1);
	self.dataTitle:SetPosition(0,1);
	self.dataTitle:SetSize(88,StatOverviewStatsPanel.dataTitleHeight);
	self.dataTitle:SetText(L.AllData);
	self.dataTitle:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	self.dataTitle:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.dataTitle:SetMultiline(false);
	self.dataTitle:SetMouseVisible(false);
	self.dataTitle:SetForeColor(Turbine.UI.Color(0.95,0.9,0.3));
	self.dataTitle:SetFontStyle(Turbine.UI.FontStyle.Outline);
  self.dataTitle:SetOutlineColor(Turbine.UI.Color(0.1,0.1,0.1));
	
	-- arrow
	self.arrow = Turbine.UI.Control();
	self.arrow:SetParent(self.dataTitleBackground);
	self.arrow:SetPosition(108-9-13,(StatOverviewStatsPanel.dataTitleHeight-13)/2);
	self.arrow:SetSize(13,13);
	self.arrow:SetZOrder(1);
	self.arrow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_normal.tga");
	self.arrow:SetMouseVisible(false);
	self.arrow.pressed = false;
	
	self.dataTitleBackground.MouseEnter = function(sender,args)
    statsMenu.mouse = true;
		
		self.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_"..(self.arrow.pressed or statsMenu.open and "pressed" or "rollover")..".tga");
		self.dataTitle:SetForeColor(Turbine.UI.Color(1,0.97,0.6));
		self.dataTitle:SetOutlineColor(Turbine.UI.Color(0.2,0.12,0.03));
	end
	
	self.dataTitleBackground.MouseLeave = function(sender,args)
    statsMenu.mouse = false;
		
		self.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_"..(statsMenu.open and "pressed" or "normal")..".tga");
		self.dataTitle:SetForeColor(Turbine.UI.Color(0.95,0.9,0.3));
		self.dataTitle:SetOutlineColor(Turbine.UI.Color(0.1,0.1,0.1));
	end
	
	self.dataTitleBackground.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self,true);
		if (statsMenu.open) then
			statsMenu:Activate();
      statsMenu:Focus();
		end
		
		self.arrow.pressed = true;
		self.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_pressed.tga");
	end
	
	self.dataTitleBackground.MouseUp = function(sender,args)
		self.arrow.pressed = false;
		self.arrow:SetBackground("CombatAnalysis/Resources/arrowdown_normal.tga");
	end
	
	self.dataTitleBackground.MouseClick = function(sender,args)
		if (args.Button ~= Turbine.UI.MouseButton.Left) then return end
		
		-- this combo box is open, so close it
		if (statsMenu.open) then
			statsMenu:CloseDropDown();
		-- this combo box is closed, so open it
		else
			if openComboBox ~= nil then
				openComboBox:CloseDropDown();
			end
			
			local x,y = WindowManager.GetPositionOnScreen(self.dataTitleBackground);
			statsMenu:OpenDropDown(x,y+self.dataTitleBackground:GetHeight(),self.dataTitleBackground:GetWidth(),self);
		end
	end
	
	self.dataTitleBackground.MouseDoubleClick = function(sender,args)
		self.dataTitleBackground:MouseClick(args);
	end
	
	-- second border
	self.lowerBorder = Turbine.UI.Control();
	self.lowerBorder:SetParent(self);
	self.lowerBorder:SetBackColor(borderColor);
	self.lowerBorder:SetPosition(0,CombatAnalysisWindow.titleBarHeight+StatOverviewStatsPanel.dataTitleHeight+CombatAnalysisWindow.border);
	self.lowerBorder:SetHeight(CombatAnalysisWindow.border);
	self.lowerBorder:SetMouseVisible(false);
	
	-- tree panel
	self.treePanel = CombatAnalysisTreePanel();
	self.treePanel:SetParent(self);
	self.treePanel:SetPosition(CombatAnalysisWindow.border,CombatAnalysisWindow.titleBarHeight+StatOverviewStatsPanel.dataTitleHeight+3*CombatAnalysisWindow.border);
	self.treePanel:SetMouseVisible(false);
	
	-- Populate the tree
	local rootNode = self.treePanel.treeView:GetNodes();
	
	-- main
	self.mainNode = StatOverviewTreeNode(self,1,mainTitle,true);
	rootNode:Add(self.mainNode);
	local dmgChildren = self.mainNode:GetChildNodes();
	
	self.totalNode = StatOverviewTreeNode(self,2,L.Total,false);
	dmgChildren:Add(self.totalNode);
	self.psNode = StatOverviewTreeNode(self,2,psTitle,false);
	dmgChildren:Add(self.psNode);
	self.attacksNode = StatOverviewTreeNode(self,2,L.Attacks,false);
	dmgChildren:Add(self.attacksNode);
	
	--- Added in v4.4.7 to support AttacksPerSecond (APS)
	self.attackpsNode = StatOverviewTreeNode(self,2,L.AttacksPS,false); 
  dmgChildren:Add(self.attackpsNode);                                    
  
	self.aveNode = StatOverviewTreeNode(self,2,L.Average,false);
	dmgChildren:Add(self.aveNode);
	self.maxNode = StatOverviewTreeNode(self,2,L.Maximum,false);
	dmgChildren:Add(self.maxNode);
	self.minNode = StatOverviewTreeNode(self,2,L.Minimum,false);
	dmgChildren:Add(self.minNode);
	
	--- Added in v4.4.7 to support Normal Hits
  self.normalHitsNode = StatOverviewTreeNode(self,1,L.NormalHits,true,overlayColor);          
  rootNode:Add(self.normalHitsNode);                                                          
  local normalHitChildren = self.normalHitsNode:GetChildNodes();                              
  
  self.normalHitChanceNode = StatOverviewTreeNode(self,2,L.NormalHitChance,false);            
  normalHitChildren:Add(self.normalHitChanceNode);                                            
  self.normalHitAvgNode = StatOverviewTreeNode(self,2,L.NormalHitAvg,false);                  
  normalHitChildren:Add(self.normalHitAvgNode);                                               
  self.normalHitMaxNode = StatOverviewTreeNode(self,2,L.NormalHitMax,false);                  
  normalHitChildren:Add(self.normalHitMaxNode);                                               
  self.normalHitMinNode = StatOverviewTreeNode(self,2,L.NormalHitMin,false);                  
  normalHitChildren:Add(self.normalHitMinNode);                                               
  
  --- Added in v4.4.7 to support Critical Hits
  self.criticalHitsNode = StatOverviewTreeNode(self,1,L.CriticalHits,true,overlayColor);      
  rootNode:Add(self.criticalHitsNode);                                                        
  local criticalHitChildren = self.criticalHitsNode:GetChildNodes();                          
  
  self.criticalHitChanceNode = StatOverviewTreeNode(self,2,L.CriticalHitChance,false);        
  criticalHitChildren:Add(self.criticalHitChanceNode);                                        
  self.criticalHitAvgNode = StatOverviewTreeNode(self,2,L.CriticalHitAvg,false);              
  criticalHitChildren:Add(self.criticalHitAvgNode);                                           
  self.criticalHitMaxNode = StatOverviewTreeNode(self,2,L.CriticalHitMax,false);              
  criticalHitChildren:Add(self.criticalHitMaxNode);                                             
  self.criticalHitMinNode = StatOverviewTreeNode(self,2,L.CriticalHitMin,false);              
  criticalHitChildren:Add(self.criticalHitMinNode);                                            
  
  --- Added in v4.4.7 to support Devastate Hits
  self.devastateHitsNode = StatOverviewTreeNode(self,1,L.DevastateHits,true,overlayColor);    
  rootNode:Add(self.devastateHitsNode);                                                       
  local devastateHitChildren = self.devastateHitsNode:GetChildNodes();                        
  
  self.devastateHitChanceNode = StatOverviewTreeNode(self,2,L.DevastateHitChance,false);      
  devastateHitChildren:Add(self.devastateHitChanceNode);                                      
  self.devastateHitAvgNode = StatOverviewTreeNode(self,2,L.DevastateHitAvg,false);            
  devastateHitChildren:Add(self.devastateHitAvgNode);                                         
  self.devastateHitMaxNode = StatOverviewTreeNode(self,2,L.DevastateHitMax,false);            
  devastateHitChildren:Add(self.devastateHitMaxNode);                                         
  self.devastateHitMinNode = StatOverviewTreeNode(self,2,L.DevastateHitMin,false);            
  devastateHitChildren:Add(self.devastateHitMinNode);                                         
	
	-- temp morale
	if (self.showTempMorale) then
		self.tempMoraleNode = StatOverviewTreeNode(self,1,L.TempMorale,true,self.tempMoraleOverlayColor);
		rootNode:Add(self.tempMoraleNode);
		local tempMoraleChildren = self.tempMoraleNode:GetChildNodes();
		
		self.regularHealsNode = StatOverviewTreeNode(self,2,L.RegularHeals,false);
		tempMoraleChildren:Add(self.regularHealsNode);
		self.tempHealsNode = StatOverviewTreeNode(self,2,L.TempHeals,false);
		tempMoraleChildren:Add(self.tempHealsNode);
		self.wastedTempHealsNode = StatOverviewTreeNode(self,2,L.WastedTempHeals,false);
		tempMoraleChildren:Add(self.wastedTempHealsNode);
	end
	
	-- avoids
	if (self.showAvoids) then
		self.avoidanceNode = StatOverviewTreeNode(self,1,L.Avoidance,true,overlayColor);
		rootNode:Add(self.avoidanceNode);
		local avoidanceChildren = self.avoidanceNode:GetChildNodes();
		
		self.hitsNode = StatOverviewTreeNode(self,2,L.Hits,false);
		avoidanceChildren:Add(self.hitsNode);
		self.absorbsNode = StatOverviewTreeNode(self,2,L.Absorbs,false);
		avoidanceChildren:Add(self.absorbsNode);
		self.immuneNode = StatOverviewTreeNode(self,2,L.Immune,false);
		avoidanceChildren:Add(self.immuneNode);
		self.missesNode = StatOverviewTreeNode(self,2,L.Misses,false);
		avoidanceChildren:Add(self.missesNode);
    self.deflectsNode = StatOverviewTreeNode(self,2,L.Deflects,false);
		avoidanceChildren:Add(self.deflectsNode);
		self.resistsNode = StatOverviewTreeNode(self,2,L.Resists,false);
		avoidanceChildren:Add(self.resistsNode);
		self.physicalNode = StatOverviewTreeNode(self,2,L.PhysicalAvoids,false);
		avoidanceChildren:Add(self.physicalNode);
		self.fullAvoidsNode = StatOverviewTreeNode(self,2,L.FullAvoids,false);
		avoidanceChildren:Add(self.fullAvoidsNode);
		self.partialAvoidsNode = StatOverviewTreeNode(self,2,L.PartialAvoids,false);
		avoidanceChildren:Add(self.partialAvoidsNode);
		
		self.avoidsNode = StatOverviewTreeNode(self,2,L.Avoids,true);
		avoidanceChildren:Add(self.avoidsNode);
		local avoidsChildren = self.avoidsNode:GetChildNodes();
		
		self.blocksNode = StatOverviewTreeNode(self,3,L.Blocks,false);
		avoidsChildren:Add(self.blocksNode);
		self.parrysNode = StatOverviewTreeNode(self,3,L.Parrys,false);
		avoidsChildren:Add(self.parrysNode);
		self.evadesNode = StatOverviewTreeNode(self,3,L.Evades,false);
		avoidsChildren:Add(self.evadesNode);
		
		self.partialsNode = StatOverviewTreeNode(self,2,L.PartialAvoids,true);
		avoidanceChildren:Add(self.partialsNode);
		local partialAvoidsChildren = self.partialsNode:GetChildNodes();
		
		self.partialBlocksNode = StatOverviewTreeNode(self,3,L.PartialBlocks,false);
		partialAvoidsChildren:Add(self.partialBlocksNode);
		self.partialParrysNode = StatOverviewTreeNode(self,3,L.PartialParrys,false);
		partialAvoidsChildren:Add(self.partialParrysNode);
		self.partialEvadesNode = StatOverviewTreeNode(self,3,L.PartialEvades,false);
		partialAvoidsChildren:Add(self.partialEvadesNode);
	
		-- other
		self.otherNode = StatOverviewTreeNode(self,1,L.Other,true,overlayColor);
		rootNode:Add(self.otherNode);
		local otherChildren = self.otherNode:GetChildNodes();
		
		self.interruptsNode = StatOverviewTreeNode(self,2,L.Interrupts,false);
		otherChildren:Add(self.interruptsNode);
		
		if (self.showCorruptions) then
			self.corruptionsNode = StatOverviewTreeNode(self,2,L.CorruptionsRemoved,false);
			otherChildren:Add(self.corruptionsNode);
		end
		
		-- dmg types
		self.dmgTypeNode = StatOverviewTreeNode(self,1,L.DmgTypes,true,overlayColor);
		rootNode:Add(self.dmgTypeNode);
		local dmgTypeChildren = self.dmgTypeNode:GetChildNodes();
		
		self.dmgTypeNodes = {}
		for i=1,#L.DmgTypeEnum do
			local newNode = StatOverviewTreeNode(self,2,L.DmgTypeEnum[i][2],false);
			dmgTypeChildren:Add(newNode);
			table.insert(self.dmgTypeNodes,newNode);
		end
	end
	
	-- estimates
	--  (the big problem with doing estimates is working out which attacks
	--  are melee/ranged vs tactical vs bleeds. also many attacks cannot
	--  miss or always crit, etc. additionally many debuffs interfere
	--  with estimates)
	
	--[[
	self.estimatesNode = StatOverviewTreeNode(1,L.Estimates,true);
	rootNode:Add(self.estimatesNode);
	local estimatesChildren = self.estimatesNode:GetChildNodes();
	
	self.mobCritNode = StatOverviewTreeNode(2,L.MobCriticalChance,false);
	estimatesChildren:Add(self.mobCritNode);
	self.mobFinesseNode = StatOverviewTreeNode(2,L.MobFinesse,false);
	estimatesChildren:Add(self.mobFinesseNode);
	self.mobCritDefNode = StatOverviewTreeNode(2,L.MobCriticalDefence,false);
	estimatesChildren:Add(self.mobCritDefNode);
	self.mobMitigationNode = StatOverviewTreeNode(2,L.MobMitigation,false);
	estimatesChildren:Add(self.mobMitigationNode);
	]]--
end

function StatOverviewStatsPanel:Layout()
	local w,h = self:GetSize();
	
	self.durationBar:SetWidth(w);
	self.title:SetWidth(math.max(0,w-StatOverviewPanel.durationWidth-6*CombatAnalysisWindow.border-(#self.panelIcons)*(CombatAnalysisWindow.border+14)-(self.lockIcon:GetParent() ~= nil and 12+CombatAnalysisWindow.border or 0)));
	self.durationLabel:SetLeft(w-StatOverviewPanel.durationWidth-2*CombatAnalysisWindow.border);
	self.lockIcon:SetLeft(w-StatOverviewPanel.durationWidth-2*CombatAnalysisWindow.border-(#self.panelIcons)*(CombatAnalysisWindow.border+14)-17);
	self.upperBorder:SetWidth(w);
	self.dataBar:SetWidth(w);
	self.skillTitleBorder:SetLeft(w-120+3*CombatAnalysisWindow.border);
	self.skillTitleBackground:SetWidth(math.max(0,w-120+3*CombatAnalysisWindow.border));
	self.skillTitle:SetWidth(math.max(0,w-120-StatOverviewStatsPanel.skillBulletWidth-2*CombatAnalysisWindow.border));
	self.skillTitleBullet:SetWidth(w-120-2*CombatAnalysisWindow.border < StatOverviewStatsPanel.skillBulletWidth and 0 or StatOverviewStatsPanel.skillBulletWidth);
	self.lowerBorder:SetWidth(w-120+4*CombatAnalysisWindow.border);
	self.dataTitleBackground:SetLeft(w-120+4*CombatAnalysisWindow.border);
	
	for i,icon in ipairs(self.panelIcons) do
		icon[2]:SetLeft(w-StatOverviewPanel.durationWidth-CombatAnalysisWindow.border-(#self.panelIcons-i+1)*(CombatAnalysisWindow.border+14));
		icon[3]:SetLeft(w-StatOverviewPanel.durationWidth-CombatAnalysisWindow.border-(#self.panelIcons-i+1)*(CombatAnalysisWindow.border+14)+2);
	end
	
	self.treePanel:SetSize(w-2*CombatAnalysisWindow.border,h-CombatAnalysisWindow.titleBarHeight-StatOverviewStatsPanel.dataTitleHeight-4*CombatAnalysisWindow.border);
	self.treePanel:Layout();
end

function StatOverviewStatsPanel:UpdateColor(color)
  local titleColor = Turbine.UI.Color(color.A*0.875,color.R*0.4,color.G*0.4,color.B*0.4);
  self.durationBar:SetBackColor(titleColor);
  self.skillTitleBackground:SetBackColor(Misc.Shade(Misc.ToGray(math.min(1,color.A*1.625),0.8,titleColor,1.1),9));
  
  self.color = Turbine.UI.Color(math.min(0.51,color.A*1.25),color.R*0.5,color.G*0.5,color.B*0.5);
  
  self.mainNode:UpdateColor(self.color);
  
  --- Added in v4.4.7 to support Normal Hits
  self.normalHitsNode:UpdateColor(self.color);   
  
  --- Added in v4.4.7 to support Critical Hits
  self.criticalHitsNode:UpdateColor(self.color);   
  
  --- Added in v4.4.7 to support Devastate Hits
  self.devastateHitsNode:UpdateColor(self.color); 
  
  if (self.showAvoids) then
    self.avoidanceNode:UpdateColor(self.color);
    self.otherNode:UpdateColor(self.color);
    self.dmgTypeNode:UpdateColor(self.color);
  end
  
  for _,icon in ipairs(self.panelIcons) do
    icon[1]:UpdateIconColor(self,self.color);
  end
end

function StatOverviewStatsPanel:UpdateColor2(color)
  if (self.showTempMorale) then
    self.tempMoraleNode:UpdateColor(color);
  end
end


function StatOverviewStatsPanel:EnsureShowing(show,dontUpdate)
	if (self.window ~= nil) then
		self.window:SetShowingPanel(self,dontUpdate);
		
		if (self.tab.showStats == 2) then
			if (show) then
				if (not self.window.visible) then
					self.window:SetVisible(true);
				end
			else
				if (self.window.visible) then
					self.window:SetVisible(false);
				end
			end
		end
	end
end

function StatOverviewStatsPanel:AddIcon(panel,dontLayout)
	-- ensure we don't add the same icon twice
	for _,icon in ipairs(self.panelIcons) do
		if (icon[1] == panel) then
			return;
		end
	end
	
	-- create new icon
	local icon = {}
	table.insert(icon,panel);
	
	local iconBorder = Turbine.UI.Control();
	iconBorder:SetParent(self.durationBar);
	iconBorder:SetZOrder(3);
	iconBorder:SetTop((CombatAnalysisWindow.titleBarHeight-14)/2);
	iconBorder:SetSize(14,14);
	iconBorder:SetMouseVisible(false);
	iconBorder:SetBackColor(Turbine.UI.Color(0.1,0.1,0.1));
	table.insert(icon,iconBorder);
	
	local iconColor = Turbine.UI.Control();
	iconColor:SetParent(self.durationBar);
	iconColor:SetZOrder(3);
	iconColor:SetTop(((CombatAnalysisWindow.titleBarHeight-14)/2)+2);
	iconColor:SetSize(10,10);
	iconColor:SetMouseVisible(true);
  if (panel.color ~= nil) then iconColor:SetBackColor(Misc.SetAlpha(panel.color,0.8)) end
	table.insert(icon,iconColor);
	
	-- set up mouse events
	iconColor.MouseEnter = function(sender,args)
		if (iconColor.pressed) then
			iconColor:SetBackColor(Turbine.UI.Color(0.8,0.6,0.45,0));
		else
			iconColor:SetBackColor(Turbine.UI.Color(0.8,0.72,0.54,0));
		end
	end
	iconColor.MouseLeave = function(sender,args)
		if (iconColor.pressed) then
			iconColor:SetBackColor(Turbine.UI.Color(0.8,0.72,0.54,0));
		else
			iconColor:SetBackColor(Misc.SetAlpha(icon[1].color,0.8));
		end
	end
	iconColor.MouseDown = function(sender,args)
		WindowManager.MouseWasPressed(self.window);
		
		iconColor.pressed = true;
		iconColor:SetBackColor(Turbine.UI.Color(0.8,0.6,0.45,0));
	end
	iconColor.MouseUp = function(sender,args)
		iconColor.pressed = false;
		local x,y = iconColor:GetMousePosition();
		if (x >= 0 and x < 10 and y >= 0 and y < 10) then
			iconColor:SetBackColor(Turbine.UI.Color(0.8,0.72,0.54,0));
		else
			iconColor:SetBackColor(Misc.SetAlpha(icon[1].color,0.8));
		end
	end
	
	iconColor.MouseClick = function(sender,args)
		-- on left click, switch to the selected panel
		if (args.Button == Turbine.UI.MouseButton.Left) then
			if (not self.window.isLocked) then
				self.window:SetShowingPanel(icon[1]);
			end
			
		-- on right click, create a new window and move the panel to that window
		elseif (args.Button == Turbine.UI.MouseButton.Right) then
			if (#self.window.panels == 1) then return end
			
      local statsPanelWindow = icon[1]:GenerateNewWindowAndMovePanel(self.window);
      
			icon[1].tab:SaveState();
      statsPanelWindow:SaveState();
		end
	end
	
	-- add to list of icons
	table.insert(self.panelIcons,icon);
	
	-- order according to global ordering (red > orange > green > blue), just for some consistency
	table.sort(self.panelIcons,
		function(a,b)
		
			if (a[1].tab == dmgTab)   then return (b[1].tab ~= dmgTab) end
			if (b[1].tab == dmgTab)   then return false end
			if (a[1].tab == takenTab) then return (b[1].tab ~= takenTab)  end
			if (b[1].tab == takenTab) then return false end
			if (a[1].tab == healTab)  then return (b[1].tab ~= healTab)  end
			
			return (b[1].tab == powerTab);
		end
	);
	
	-- layout
	if (not dontLayout) then self:Layout() end
end

function StatOverviewStatsPanel:RemoveIcon(panel)
	for index,icon in ipairs(self.panelIcons) do
		if (icon[1] == panel) then
			icon[2]:SetParent(nil);
			icon[3]:SetParent(nil);
			table.remove(self.panelIcons,index);
			self:Layout();
			return;
		end
	end
end

function StatOverviewStatsPanel:GenerateNewWindowAndMovePanel(currentWindow,dontActivate)
  -- if a tab was dragged from an existing window, copy the same settings
  local window = currentWindow;
  -- otherwise, copy the settings of the newest window
  if (window == nil and #statOverviewStatsWindows > 0) then
    local windows = {}
    for _,window in ipairs(statOverviewStatsWindows) do
      table.insert(windows,{window.id,window});
    end
    table.sort(windows,function(a,b) return a[1] > b[1] end);
    window = windows[1][2];
  end
  -- finally, if there are no windows active, use the old window state saved in settings
  local windowState = (window or settings.oldStatOverviewStatsWindowState);

  local statsPanelWindow = StatOverviewStatsWindow();
  local w = DecodeNumbers(windowState.w);
  local h = DecodeNumbers(windowState.h);
  statsPanelWindow:SetSize(w,h);
  
  statsPanelWindow:SetPosition(WindowManager.ValidatePosition((Turbine.UI.Display:GetWidth()-w)/2,(Turbine.UI.Display:GetHeight()-h)/2,
                                                                w,h,0,CombatAnalysisWindow.resizeHangover+CombatAnalysisWindow.border));
                                                                
  statsPanelWindow:SetBackgroundColor(Turbine.UI.Color(DecodeNumbers(windowState.color.A),DecodeNumbers(windowState.color.R),DecodeNumbers(windowState.color.G),DecodeNumbers(windowState.color.B)));
  
  self.tab:SetShowStats(window and window.panels[1].tab.showStats or (windowState.statsWindowVisibility == "Hide" and 1 or (windowState.statsWindowVisibility == "Hover" and 2 or 3)));
  
  statsPanelWindow:SetVisible(self.tab.showStats == 3,dontActivate,dontActivate);
  
  -- add/remove panels to relevant windows
  if (currentWindow ~= nil) then currentWindow:RemovePanel(self) end
  
  statsPanelWindow:AddPanel(self);
  
  -- update panel in new window and set relevant lock statuses
  if (currentWindow == nil or currentWindow.lockedPanel ~= self) then
    self:FullUpdate(nil,true,false,nil,nil);
  end
  
  if (currentWindow ~= nil and currentWindow.isLocked) then
    if (currentWindow.lockedPanel == self) then
      local lockedBar = currentWindow.locked;
      currentWindow:SetLocked(nil,nil,false);
      statsPanelWindow:SetLocked(lockedBar,self,true);
      currentWindow.showingPanel:FullUpdate(nil,true,false,currentWindow.showingPanel.tab.panel.barsPanel.selectedPlayer,nil);
    end
  end
  
  return statsPanelWindow;
end

function StatOverviewStatsPanel:UpdateIconColor(panel,color)
  for _,icon in ipairs(self.panelIcons) do
    if (icon[1] == panel) then    
			icon[3]:SetBackColor(Misc.SetAlpha(color,0.8));
      return;
		end
  end
end

function StatOverviewStatsPanel:MovePanelToNewWindow(dontActivate)
  -- generate new window
  local window = self:GenerateNewWindowAndMovePanel(self.window,dontActivate);
  self.tab:SaveState();
  window:SaveState();
end

function StatOverviewStatsPanel:MovePanelToExistingWindow(window)
  local currentWindow = self.window;
  
  if (currentWindow ~= nil) then currentWindow:RemovePanel(self) end
  window:AddPanel(self);
  self.tab:SaveState();
  
  if (currentWindow ~= nil and currentWindow.lockedPanel == self) then
    local locked = currentWindow.locked;
    local lockedPanel = currentWindow.lockedPanel;
    
    currentWindow:SetLocked(nil,nil,false);
    if (not window.isLocked) then
      window:SetLocked(locked,lockedPanel,true);
    end
  end
end

function StatOverviewStatsPanel:RemovePanelFromWindow()
  local currentWindow = self.window;
  
  if (currentWindow == nil) then return end
  currentWindow:RemovePanel(self);
  self.tab.panel.infoButton:SetBackground("CombatAnalysis/Resources/gears.tga");
  self.tab:SaveState();
  
  if (currentWindow.lockedPanel == self) then
    currentWindow:SetLocked(nil,nil,false);
  end
end

function StatOverviewStatsPanel:SetCategory(label,category)
	if (self.category == category) then return end
	
	self.category = category;
	self.dataTitle:SetText(label);
	self:FullUpdate(nil,false,false);
end

-- A full update requires recomputing all values
function StatOverviewStatsPanel:FullUpdate(duration,newSelection,forceNewSelection,selectedPlayer,selectedSkill)
	-- update duration
	if (duration ~= nil) then
		self.duration = duration;
		self.durationLabel:SetText(Misc.FormatDuration(self.duration));
	end
	
	-- determine if new selection work actually needs to be performed
	selectedPlayer = (selectedPlayer == nil and player.name or selectedPlayer);
	if (newSelection and not forceNewSelection and self.selectedPlayer == selectedPlayer and self.selectedSkill == selectedSkill) then
		newSelection = false;
	end
	
	-- update selections
	if (newSelection) then
		if (statsMenu.open) then
			statsMenu:CloseDropDown();
		end
		self:SetCategory(L.AllData,"");
		self.selectedPlayer = selectedPlayer;
		self.selectedSkill = selectedSkill;
		self.title:SetText(self.selectedPlayer);
		self.skillTitle:SetText(self.selectedSkill == nil and L.AllSkills or self.selectedSkill);
	end
	
	-- extract data
	local dataSummary;
	if (self.selectedSkill == nil) then
		dataSummary = self.tab:GetData(self.category);
		if (self.category ~= nil and self.category ~= "") then
			local totals = self.tab:GetData()[self.selectedPlayer];
			self.totalAmount = (totals == nil and 0 or totals:TotalAmount());
			self.totalAttacks = (totals == nil and 0 or totals.attacks);
		else
			self.totalAmount = dataSummary[1]:TotalAmount();
			self.totalAttacks = dataSummary[1].attacks;
		end
		dataSummary = dataSummary[self.selectedPlayer];
    
	else
		dataSummary = self.tab:GetDataForPlayer(self.selectedPlayer,true,self.category);
		if (self.category ~= nil and self.category ~= "") then
			local totals = self.tab:GetDataForPlayer(self.selectedPlayer,true)[self.selectedSkill];
			self.totalAmount = totals:TotalAmount();
			self.totalAttacks = totals.attacks;
		else
			self.totalAmount = dataSummary[1]:TotalAmount();
			self.totalAttacks = dataSummary[1].attacks;
		end
		dataSummary = dataSummary[self.selectedSkill];
    
	end
  
  if (dataSummary == nil) then
    dataSummary = StatOverviewStatsPanel.emptyDataSummary;
  end
	
	-- update all fields
	self.amount = dataSummary:TotalAmount();
	--- Added in v4.4.7 to support AttacksPerSecond (APS)
	self.attacks = dataSummary.attacks;
	
	self.totalNode:UpdateData(Misc.FormatValue(self.amount),Misc.FormatPerc(self.amount/(self.totalAmount == 0 and 1 or self.totalAmount),true));
	self.psNode:UpdateData(Misc.FormatPs(self.amount/(self.duration == 0 and 1 or self.duration)));
	self.attacksNode:UpdateData(Misc.FormatValue(dataSummary.attacks),Misc.FormatPerc(dataSummary.attacks/(self.totalAttacks == 0 and 1 or self.totalAttacks),true));
	
	--- Added in v4.4.7 to support AttackPerSecond (APS) Hits
	self.attackpsNode:UpdateData(Misc.FormatPs(dataSummary.attacks/(self.duration == 0 and 1 or self.duration)));
	
	self.aveNode:UpdateData(Misc.FormatValue(dataSummary:Average()));
	self.maxNode:UpdateData(Misc.FormatValue(dataSummary.max));
	self.minNode:UpdateData(Misc.FormatValue(dataSummary.min));
	
	--- Added in v4.4.7 to support Normal Hits
	self.normalHitChanceNode:UpdateData(Misc.FormatValue(dataSummary.normals),Misc.FormatPerc(dataSummary:NormalChance(),true));         
	self.normalHitAvgNode:UpdateData(Misc.FormatValue(dataSummary:NormalAverage()));                                                     
	self.normalHitMaxNode:UpdateData(Misc.FormatValue(dataSummary.normalMax));                                                           
	self.normalHitMinNode:UpdateData(Misc.FormatValue(dataSummary.normalMin));                                                           
	
	--- Added in v4.4.7 to support Critical Hits
	self.criticalHitChanceNode:UpdateData(Misc.FormatValue(dataSummary.crits),Misc.FormatPerc(dataSummary:CriticalChance(),true));       
	self.criticalHitAvgNode:UpdateData(Misc.FormatValue(dataSummary:CriticalAverage()));                                                 
	self.criticalHitMaxNode:UpdateData(Misc.FormatValue(dataSummary.critMax));                                                           
  self.criticalHitMinNode:UpdateData(Misc.FormatValue(dataSummary.critMin));                                                           
	
	--- Added in v4.4.7 to support Devastate Hits
	self.devastateHitChanceNode:UpdateData(Misc.FormatValue(dataSummary.devs),Misc.FormatPerc(dataSummary:DevastateChance(),true));      
	self.devastateHitAvgNode:UpdateData(Misc.FormatValue(dataSummary:DevastateAverage()));                                               
	self.devastateHitMaxNode:UpdateData(Misc.FormatValue(dataSummary.devMax));                                                           
  self.devastateHitMinNode:UpdateData(Misc.FormatValue(dataSummary.devMin));                                                           
	
	if (self.showTempMorale) then
		self.regularHealsNode:UpdateData(Misc.FormatValue(dataSummary.amount),Misc.FormatPerc(dataSummary.amount/(self.amount == 0 and 1 or self.amount),true));
		self.tempHealsNode:UpdateData(Misc.FormatValue(dataSummary.temporaryMoraleAmount),Misc.FormatPerc(dataSummary.temporaryMoraleAmount/(self.amount == 0 and 1 or self.amount),true));
		self.wastedTempHealsNode:UpdateData(Misc.FormatValue(dataSummary.wastedTemporaryMoraleAmount),Misc.FormatPerc(dataSummary.wastedTemporaryMoraleAmount/(dataSummary.temporaryMoraleAmount == 0 and 1 or dataSummary.temporaryMoraleAmount),true));
	end
	
	if (self.showAvoids) then
		self.hitsNode:UpdateData(Misc.FormatValue(dataSummary.hits),Misc.FormatPerc(dataSummary.hits/math.max(1,dataSummary.attacks),true));
		self.absorbsNode:UpdateData(Misc.FormatValue(dataSummary.absorbs),Misc.FormatPerc(dataSummary.absorbs/math.max(1,dataSummary.hits),true));
		self.immuneNode:UpdateData(Misc.FormatValue(dataSummary.immunes),Misc.FormatPerc(dataSummary.immunes/math.max(1,dataSummary.attacks),true));
		self.missesNode:UpdateData(Misc.FormatValue(dataSummary.misses),Misc.FormatPerc(dataSummary.misses/math.max(1,dataSummary.attacks),true));
    self.deflectsNode:UpdateData(Misc.FormatValue(dataSummary.deflects),Misc.FormatPerc(dataSummary.deflects/math.max(1,dataSummary.attacks),true));
		self.resistsNode:UpdateData(Misc.FormatValue(dataSummary.resists),Misc.FormatPerc(dataSummary.resists/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.physicalNode:UpdateData(Misc.FormatValue(dataSummary:PhysicalAvoids()),Misc.FormatPerc(dataSummary:PhysicalAvoids()/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.fullAvoidsNode:UpdateData(Misc.FormatValue(dataSummary:FullPhysicalAvoids()),Misc.FormatPerc(dataSummary:FullPhysicalAvoids()/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.partialAvoidsNode:UpdateData(Misc.FormatValue(dataSummary:PartialAvoids()),Misc.FormatPerc(dataSummary:PartialAvoids()/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		
		self.blocksNode:UpdateData(Misc.FormatValue(dataSummary.blocks),Misc.FormatPerc(dataSummary.blocks/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.parrysNode:UpdateData(Misc.FormatValue(dataSummary.parrys),Misc.FormatPerc(dataSummary.parrys/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.evadesNode:UpdateData(Misc.FormatValue(dataSummary.evades),Misc.FormatPerc(dataSummary.evades/(math.max(1,dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		
		self.partialBlocksNode:UpdateData(Misc.FormatValue(dataSummary.pblocks),Misc.FormatPerc(dataSummary.pblocks/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.partialParrysNode:UpdateData(Misc.FormatValue(dataSummary.pparrys),Misc.FormatPerc(dataSummary.pparrys/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		self.partialEvadesNode:UpdateData(Misc.FormatValue(dataSummary.pevades),Misc.FormatPerc(dataSummary.pevades/math.max(1,(dataSummary.attacks-dataSummary.misses-dataSummary.deflects)),true));
		
		self.interruptsNode:UpdateData(Misc.FormatValue(dataSummary.interrupts));
		
		if (self.showCorruptions) then
			self.corruptionsNode:UpdateData(Misc.FormatValue(dataSummary.corruptions));
		end
		
		for i=1,#L.DmgTypeEnum do
			self.dmgTypeNodes[i]:UpdateData(Misc.FormatValue(dataSummary.dmgTypes[i] == nil and "0" or dataSummary.dmgTypes[i]),Misc.FormatPerc(((dataSummary.dmgTypes[i] == nil and "0" or dataSummary.dmgTypes[i])/math.max(1,self.amount)),true));
		end
	end
end

-- The Update method is used to signify that durations need updating. An update
-- to durations can be significantly more efficient than a full update as it only
-- affects labels (not bar sizes).
function StatOverviewStatsPanel:Update(duration)
	self.duration = duration;

	self.durationLabel:SetText(Misc.FormatDuration(self.duration));
	if (self.amount ~= nil) then
		self.psNode:UpdateData(Misc.FormatPs(self.amount/(self.duration == 0 and 1 or self.duration)));
	end
	if (self.attacks ~= nil) then
	  self.attackpsNode:UpdateData(Misc.FormatPs(self.attacks/(self.duration == 0 and 1 or self.duration)));  --- Added in v4.4.7 to support AttackPerSecond (APS)
  end
end

-- stored empty data summary (used for quick updates of no data)
--- Added in v4.4.7 to support AttackPerSecond (APS), Normal, Critical, and Devastate Hits
StatOverviewStatsPanel.emptyDataSummary = 
	{amount = 0, 
	wastedTemporaryMoraleAmount = 0, 
	temporaryMoraleAmount = 0, 
	TotalAmount = function() return 0 end, 
	attacks = 0, 
	Average = function() return 0 end, 
	max = 0, 
	min = 0,
	normals = 0,                                    
  NormalChance = function() return 0 end,         
  NormalAverage = function() return 0 end,
  normalMin = 0,
  normalMax = 0,        
	crits = 0,                                      
	CriticalChance = function() return 0 end,       
	CriticalAverage = function() return 0 end,
	critMin = 0,
	critMax = 0,      
	devs = 0,                                       
	DevastateChance = function() return 0 end,      
	DevastateAverage = function() return 0 end,     
	devMin = 0,
	devMax = 0,
	hits = 0, 
	absorbs = 0, 
	immunes = 0, 
	misses = 0, 
	deflects = 0, 
	resists = 0, 
	PhysicalAvoids = function() return 0 end,
	FullPhysicalAvoids = function() return 0 end, 
	PartialAvoids = function() return 0 end,
	blocks = 0, 
	parrys = 0, 
	evades = 0, 
	pblocks = 0, 
	pparrys = 0, 
	pevades = 0, 
	interrupts = 0, 
	corruptions = 0,
	dmgTypes = {}};
  
-- Get state method
function StatOverviewStatsPanel:GetState()
	local state = {}
	
	state["totals"] = self.mainNode.expanded;
	
	--- Added in v4.4.7 to support Normal Hits
	state["normals"] = self.normalHitsNode.expanded;
	
	--- Added in v4.4.7 to support Critical Hits
	state["crits"] = self.criticalHitsNode.expanded;
		
	--- Added in v4.4.7 to support Devastate Hits
	state["devs"] = self.devastateHitsNode.expanded;
	
	if (self.showAvoids) then
		state["avoidance"] = self.avoidanceNode.expanded;
		state["fullAvoids"] = self.avoidsNode.expanded;
		state["partials"] = self.partialsNode.expanded;
		
		state["other"] = self.otherNode.expanded;
		state["dmgTypes"] = self.dmgTypeNode.expanded;
		
	elseif (self.showTempMorale) then
		state["tempMorale"] = self.tempMoraleNode.expanded;
		
	end
	
	return state;
end

-- Restore state method (NB: not static like the other restore state methods)
function StatOverviewStatsPanel:Restore(savedState)
	self.mainNode:SetExpanded(savedState["totals"]);
	
	--- Added in v4.4.7 to support Normal Hits
	self.normalHitsNode:SetExpanded(savedState["normals"]); 
	
	--- Added in v4.4.7 to support Critical Hits
	self.criticalHitsNode:SetExpanded(savedState["crits"]); 
	
	--- Added in v4.4.7 to support Devastate Hits
	self.devastateHitsNode:SetExpanded(savedState["devs"]); 
	
	if (self.showAvoids) then
		-- hack to ensure nodes correctly expanded
		if (savedState["fullAvoids"] or savedState["partials"]) then self.avoidanceNode:SetExpanded(true) end
		self.avoidsNode:SetExpanded(savedState["fullAvoids"]);
		self.partialsNode:SetExpanded(savedState["partials"]);
		self.avoidanceNode:SetExpanded(savedState["avoidance"]);
		
		self.otherNode:SetExpanded(savedState["other"]);
		self.dmgTypeNode:SetExpanded(savedState["dmgTypes"]);
		
	elseif (self.showTempMorale) then
		self.tempMoraleNode:SetExpanded(savedState["tempMorale"]);
		
	end
end
