
--[[

A Stat Overview Panel contains several (optional)
elements, including:

- An encounters combo box
- A target combo box
- A title bar with the selection title and duration
- A bar panel that will display the stats overview
- A tree panel that will display the more detailed stats

]]--

_G.StatOverviewPanel = class(Turbine.UI.Control);

-- configurable UI parameters
StatOverviewPanel.durationWidth = 64;
StatOverviewPanel.titleAnimationDuration = 0.2;
StatOverviewPanel.titleAnimationDistance = 100;

function StatOverviewPanel:Constructor(tab,chatMenu,encounters,targets,hasTwoParts,isBuffTab)
	Turbine.UI.Control.Constructor(self);
	
	self.tab = tab;
	self.chatMenu = chatMenu;
	self.selectedTarget = (targets.comboBoxGroup == mobsComboBox and "selectedMob" or "selectedRestore");
	self.hasTwoParts = hasTwoParts;
  self.isBuffTab = isBuffTab;
  
	self.selectedInfo = nil;
	
	self:SetMouseVisible(false);
	
	-- title & duration bar
	self.durationBar = Turbine.UI.Control();
	self.durationBar:SetParent(self);
	self.durationBar:SetPosition(0,0);
	self.durationBar:SetHeight(CombatAnalysisWindow.titleBarHeight);
	self.durationBar:SetMouseVisible(true);
	-- pass on mouse events to window
	self.durationBar.MouseDown = function(sender,args)
		self.tab.window:MouseDown(args);
	end
	self.durationBar.MouseMove = function(sender,args)
		self.tab.window:MouseMove(args);
	end
	self.durationBar.MouseUp = function(sender,args)
		self.tab.window:MouseUp(args);
	end
	-- sliding title text animation
	self.durationBar.Update = function(sender)
		local perc = math.min(1,(Turbine.Engine.GetGameTime()-self.startTime)/StatOverviewPanel.titleAnimationDuration);
		self.title:SetLeft(self.leftToRightAnimation and
		  -StatOverviewPanel.titleAnimationDistance+2*CombatAnalysisWindow.border+StatOverviewPanel.titleAnimationDistance*perc or
			StatOverviewPanel.titleAnimationDistance+2*CombatAnalysisWindow.border-StatOverviewPanel.titleAnimationDistance*perc);
		
		if (perc == 1) then self:SetWantsUpdates(false) end
	end
	
	-- title
	self.title = Turbine.UI.Label();
	self.title:SetParent(self.durationBar);
	self.title:SetZOrder(1);
	self.title:SetPosition(2*CombatAnalysisWindow.border,0);
	self.title:SetHeight(CombatAnalysisWindow.titleBarHeight);
	self.title:SetText(L.AllPlayers);
	self.title:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
	self.title:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.title:SetMultiline(false);
	self.title:SetMouseVisible(false);
	self.title:SetForeColor(controlLightColor);
	
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
	
	-- encounters combo box
	self.encounters = encounters;
	self.encounters:SetParent(self);
	self.encounters:SetPosition(0,CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border);
	self.encounters:SetHeight(CombatAnalysisWindow.titleBarHeight);

	-- second border
	self.middleBorder = Turbine.UI.Control();
	self.middleBorder:SetParent(self);
	self.middleBorder:SetBackColor(borderColor);
	self.middleBorder:SetPosition(0,2*CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border);
	self.middleBorder:SetHeight(CombatAnalysisWindow.border);
	self.middleBorder:SetMouseVisible(false);
	
	-- targets combo box
	self.targets = targets;
	self.targets:SetParent(self);
	self.targets:SetPosition(0,2*CombatAnalysisWindow.titleBarHeight+2*CombatAnalysisWindow.border);
	self.targets:SetHeight(CombatAnalysisWindow.titleBarHeight);
	
	-- third border
	self.lowerBorder = Turbine.UI.Control();
	self.lowerBorder:SetParent(self);
	self.lowerBorder:SetBackColor(borderColor);
	self.lowerBorder:SetPosition(0,3*CombatAnalysisWindow.titleBarHeight+2*CombatAnalysisWindow.border);
	self.lowerBorder:SetHeight(CombatAnalysisWindow.border);
	self.lowerBorder:SetMouseVisible(false);
	
	-- bars panel
	self.barsPanel = StatOverviewBarsPanel(tab,hasTwoParts);
	self.barsPanel:SetParent(self);
	self.barsPanel:SetPosition(0,3*CombatAnalysisWindow.titleBarHeight+3*CombatAnalysisWindow.border);
	
	-- speech button window
	self.speechButtonWindow = Turbine.UI.Window();
	self.speechButtonWindow:SetParent(self);
	self.speechButtonWindow:SetSize(16,16);
	self.speechButtonWindow:SetVisible(true);
	self.speechButtonWindow:SetMouseVisible(false);
	self.speechButtonWindow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- speech button
	self.speechButton = Turbine.UI.Control();
	self.speechButton:SetParent(self.speechButtonWindow);
	self.speechButton:SetSize(17,17);
	self.speechButton:SetBackground(0x41007E1E);
	self.speechButton:SetMouseVisible(true);
	self.speechButton.pressed = false;
	self.speechButton.MouseEnter = function(sender, args)
		self.speechButton:SetBackground(self.speechButton.pressed and 0x41007E1D or 0x41007E1F);
	end
	self.speechButton.MouseLeave = function(sender, args)
		self.speechButton:SetBackground(self.speechButton.pressed and 0x41007E1F or 0x41007E1E);
	end
	self.speechButton.MouseDown = function(sender, args)
		WindowManager.MouseWasPressed(self.tab.window);
		
		self.speechButton.pressed = true;
		self.speechButton:SetBackground(0x41007E1D);
	end
	self.speechButton.MouseUp = function(sender, args)
		self.speechButton.pressed = false;
		self.speechButton:SetBackground(0x41007E1E);
	end
	self.speechButton.MouseClick = function(sender, args)
		if (args.Button == Turbine.UI.MouseButton.Left) then
			self.chatMenu:PopulateMenu(self);
			self.chatMenu:ShowMenu();
		end
	end
	self.speechButton.MouseDoubleClick = function(sender, args)
		self.speechButton:MouseClick(args);
	end
	
	-- speech button overlay
	self.speechButtonOverlay = Turbine.UI.Control();
	self.speechButtonOverlay:SetParent(self.speechButton);
	self.speechButtonOverlay:SetSize(17,17);
	self.speechButtonOverlay:SetZOrder(1);
	self.speechButtonOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.speechButtonOverlay:SetMouseVisible(false);
	
	-- chat button window
	self.chatButtonWindow = Turbine.UI.Window();
	self.chatButtonWindow:SetParent(self);
	self.chatButtonWindow:SetSize(100,19);
	self.chatButtonWindow:SetVisible(true);
	self.chatButtonWindow:SetMouseVisible(false);
	self.chatButtonWindow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- chat send box button
	self.chatButton = Turbine.UI.Control();
	self.chatButton:SetParent(self.chatButtonWindow);
	self.chatButton:SetSize(100,19);
	self.chatButton:SetBackground("CombatAnalysis/Resources/im_button_gray_normal.tga");
	self.chatButton:SetMouseVisible(false);
	
	-- chat send box button overlay
	self.chatButtonOverlay = Turbine.UI.Control();
	self.chatButtonOverlay:SetParent(self.chatButtonWindow);
	self.chatButtonOverlay:SetSize(100,19);
	self.chatButtonOverlay:SetZOrder(1);
	self.chatButtonOverlay:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.chatButtonOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
	self.chatButtonOverlay:SetMouseVisible(false);
	
	-- chat send box label
	self.chatLabel = Turbine.UI.Label();
	self.chatLabel:SetParent(self.chatButtonWindow);
	self.chatLabel:SetSize(100,19);
	self.chatLabel:SetZOrder(2);
	self.chatLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.chatLabel:SetMultiline(false);
	self.chatLabel:SetMouseVisible(false);
	self.chatLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
	self.chatLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.chatLabel:SetForeColor(Turbine.UI.Color(0.5,0.5,0.5));
	self.chatLabel:SetText(L.SendToChat);
	
	-- chat send invisible quickslot hack (a quickslot inside an opaque window - thanks to the ChatEdit plugin for the idea!)
	self.chatSendWindow = Turbine.UI.Window();
	self.chatSendWindow:SetSize(0,0);
	self.chatSendWindow:SetOpacity(0);
	self.chatSendWindow:SetMouseVisible(true);
	self.chatSendWindow:SetVisible(true);
	
	-- chat send box quickslot
	self.chatSend = Turbine.UI.Lotro.Quickslot();
	self.chatSend:SetParent(self.chatSendWindow);
	self.chatSend:SetSize(100,19);
	self.chatSend:SetZOrder(2);
	self.chatSend:SetMouseVisible(true);
	self.chatSend.pressed = false;
	self.chatSend.MouseEnter = function(sender, args)
		self.chatButton:SetBackground("CombatAnalysis/Resources/im_button_gray_"..(self.chatSend.pressed and "pressed" or "rollover")..".tga");
	end
	self.chatSend.MouseLeave = function(sender, args)
		self.chatButton:SetBackground("CombatAnalysis/Resources/im_button_gray_"..(self.chatSend.pressed and "rollover" or "normal")..".tga");
	end
	self.chatSend.MouseDown = function(sender, args)
		WindowManager.MouseWasPressed(self.tab.window);
		self.chatSend.pressed = true;
		self.chatButton:SetBackground("CombatAnalysis/Resources/im_button_gray_pressed.tga");
	end
	self.chatSend.MouseUp = function(sender, args)
		self.chatSend.pressed = false;
		self.chatButton:SetBackground("CombatAnalysis/Resources/im_button_gray_normal.tga");
	end
	
	self.chatSendShortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias,nil);
    self.chatSend.DragDrop=function()
        self.chatSend:SetShortcut(self.chatSendShortcut)
    end
	
	-- show stats (info) button window
  self.infoButtonWindow = Turbine.UI.Window();
  self.infoButtonWindow:SetParent(self);
  self.infoButtonWindow:SetSize(17,17);
  self.infoButtonWindow:SetVisible(true);
  self.infoButtonWindow:SetMouseVisible(false);
  self.infoButtonWindow:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
  
  -- show stats (info) button
  self.infoButton = Turbine.UI.Control();
  self.infoButton:SetParent(self.infoButtonWindow);
  self.infoButton:SetSize(17,17);
  self.infoButton:SetBackground("CombatAnalysis/Resources/spanner.tga");
  self.infoButton:SetMouseVisible(true);
  self.infoButton.pressed = false;
  self.infoButton.MouseEnter = function(sender, args)
    self.infoButton.mouseIn = true;
    
    if (self.isBuffTab) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/spanner_mouseover.tga");
    elseif (self.tab.statsPanel.window == nil) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/gears_mouseover.tga");
    elseif (self.tab.showStats == 3) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_border_"..(self.infoButton.pressed and "pressed" or "rollover")..".tga");
    elseif (self.tab.showStats == 2) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_quarter_border_"..(self.infoButton.pressed and "pressed" or "rollover")..".tga");
    else
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_"..(self.infoButton.pressed and "pressed" or "rollover")..".tga");
    end
  end
  self.infoButton.MouseLeave = function(sender, args)
    self.infoButton.mouseIn = false;
    
    if (self.isBuffTab) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/spanner"..(self.infoButton.pressed and "_mouseover" or "")..".tga");
    elseif (self.tab.statsPanel.window == nil) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/gears"..(self.infoButton.pressed and "_mouseover" or "")..".tga");
    elseif (self.tab.showStats == 3) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_border"..(self.infoButton.pressed and "_rollover" or "")..".tga");
    elseif (self.tab.showStats == 2) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_quarter_border"..(self.infoButton.pressed and "_rollover" or "")..".tga");
    else
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button"..(self.infoButton.pressed and "_rollover" or "")..".tga");
    end
  end
  self.infoButton.MouseDown = function(sender, args)
    WindowManager.MouseWasPressed(self.tab.window);
    self.infoButton.pressed = true;
    
    if (self.isBuffTab or self.tab.statsPanel.window == nil) then
      -- no mouse down image
    elseif (self.tab.showStats == 3) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_border_pressed.tga");
    elseif (self.tab.showStats == 2) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_quarter_border_pressed.tga");
    else
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_pressed.tga");
    end
  end
  self.infoButton.MouseUp = function(sender, args)
    self.infoButton.pressed = false;
    
    if (self.isBuffTab) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/spanner"..(self.infoButton.mouseIn and "_mouseover" or "")..".tga");
    elseif (self.tab.statsPanel.window == nil) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/gears"..(self.infoButton.mouseIn and "_mouseover" or "")..".tga");
    elseif (self.tab.showStats == 3) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_border"..(self.infoButton.mouseIn and "_rollover" or "")..".tga");
    elseif (self.tab.showStats == 2) then
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button_quarter_border"..(self.infoButton.mouseIn and "_rollover" or "")..".tga");
    else
      self.infoButton:SetBackground("CombatAnalysis/Resources/info_button"..(self.infoButton.mouseIn and "_rollover" or "")..".tga");
    end
  end
  self.infoButton.MouseClick = function(sender, args)
    if (self.isBuffTab) then
      if (args.Button == Turbine.UI.MouseButton.Left) then
        buffsMenu:ShowMenu();
      end
    elseif (self.tab.statsPanel.window == nil) then
      uiMenuPanel.subMenuPane:SelectTab(3);
      menuPane:SelectTab(2);
      Turbine.PluginManager.ShowOptions(Plugins["CombatAnalysis"]);
    elseif (args.Button == Turbine.UI.MouseButton.Left) then
      self.tab:SetShowStats(math.min(self.tab.showStats+1,3));
    elseif (args.Button == Turbine.UI.MouseButton.Right) then
      self.tab:SetShowStats(math.max(self.tab.showStats-1,1));
    end
  end
  self.infoButton.MouseDoubleClick = function(sender, args)
    self.infoButton:MouseClick(args);
  end
  
  -- show stats (info) button overlay
  self.infoButtonOverlay = Turbine.UI.Control();
  self.infoButtonOverlay:SetParent(self.infoButton);
  self.infoButtonOverlay:SetSize(17,17);
  self.infoButtonOverlay:SetZOrder(1);
  self.infoButtonOverlay:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
  self.infoButtonOverlay:SetMouseVisible(false);
end

function StatOverviewPanel:Layout()
	local w,h = self:GetSize();
	
	self.durationBar:SetWidth(w);
	self.title:SetWidth(math.max(0,w-StatOverviewPanel.durationWidth-4*CombatAnalysisWindow.border));
	self.durationLabel:SetLeft(w-StatOverviewPanel.durationWidth-2*CombatAnalysisWindow.border);
	
	self.upperBorder:SetWidth(w);
	
	self.encounters:SetTop(self.tab.showTitle and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0);
	self.encounters:SetWidth(w);
	self.middleBorder:SetTop((self.tab.showTitle and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+CombatAnalysisWindow.titleBarHeight);
	self.middleBorder:SetWidth(w);
	
	self.targets:SetTop((self.tab.showTitle and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showEncounters and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0));
	self.targets:SetWidth(w);
	self.lowerBorder:SetTop((self.tab.showTitle and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showEncounters and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+CombatAnalysisWindow.titleBarHeight);
	self.lowerBorder:SetWidth(w);
	
	self.barsPanel:SetTop((self.tab.showTitle and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showEncounters and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showTargets and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0));
	self.barsPanel:SetSize(w,math.max(0,h-((self.tab.showTitle and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showEncounters and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showTargets and CombatAnalysisWindow.titleBarHeight+CombatAnalysisWindow.border or 0)+(self.tab.showSendChat and 19+CombatAnalysisWindow.border or 0))));
	
	self.speechButtonWindow:SetPosition(((w-5-16-3-100-5-17-3-17)/2)+5,(h-CombatAnalysisWindow.border-18));
	self.chatButtonWindow:SetPosition(((w-5-16-3-100-5-17-3-17)/2)+5+16+3,(h-CombatAnalysisWindow.border-19));
	self.infoButtonWindow:SetPosition(((w-5-16-3-100-5-17-3-17)/2)+5+16+3+100+5,(h-CombatAnalysisWindow.border-18));
	
	local x,y = WindowManager.GetPositionOnScreen(self);
	self.chatSendWindow:SetPosition((x+(w-5-16-3-100-5-17-3-17)/2)+5+16+3,(y+(h-CombatAnalysisWindow.border-19)));
	
	self.encounters:Layout();
	self.targets:Layout();
	self.barsPanel:Layout();
end

function StatOverviewPanel:UpdateColor(color)
  self.color = Turbine.UI.Color(color.A*0.875,color.R*0.4,color.G*0.4,color.B*0.4);
  self.durationBar:SetBackColor(self.color);
  
  local overlayColor = Misc.ToGray(0.2,0.8,color,1.5);  
  self.speechButtonOverlay:SetBackColor(overlayColor);
  self.chatButtonOverlay:SetBackColor(overlayColor);
  self.infoButtonOverlay:SetBackColor(overlayColor);
  
  self.barsPanel:UpdateColor(self.color);
end

function StatOverviewPanel:UpdateColor2(color)
  if (self.hasTwoParts) then
    self.barsPanel:UpdateColor2(Turbine.UI.Color(color.A*0.875,color.R*0.4,color.G*0.4,color.B*0.4));
  end
end

function StatOverviewPanel:FullUpdate(duration,newSelection,newSelectedPlayer)
	-- determine the selected target duration
	if (duration ~= nil) then
		self:UpdateDuration(duration);
	end
	-- reset the bars panel when the selection changes (either the target or the view level)
	if (newSelection) then
		local prevSelected = self.barsPanel.selectedPlayer;
		self.barsPanel.selectedPlayer = newSelectedPlayer;
		self.barsPanel:Clear();
		self:SetTitle((self.barsPanel.selectedPlayer == nil and L.AllPlayers or self.barsPanel.selectedPlayer),
			((self.barsPanel.selectedPlayer ~= nil and prevSelected == nil) and 1 or ((self.barsPanel.selectedPlayer == nil and prevSelected ~= nil) and -1 or 0)));
			
		if (not combatData.inCombat) then
			self.selectedInfo = nil;
			self.tab:UpdateChatSendButton();
		end
	end
	-- update the bars panel
	self.barsPanel:FullUpdate(self.duration);
end

function StatOverviewPanel:Update(duration)
	self:UpdateDuration(duration);
	self.barsPanel:Update(self.duration);
end

function StatOverviewPanel:UpdateDuration(duration)
	self.duration = duration;
	self.durationLabel:SetText(Misc.FormatDuration(duration));
end

function StatOverviewPanel:SetTitle(text,animationDirection)
	self.title:SetText(text);
	
	if (animationDirection ~= 0) then
		self.leftToRightAnimation = animationDirection > 0;
		
		self.title:SetLeft(self.leftToRightAnimation and
			-StatOverviewPanel.titleAnimationDistance+2*CombatAnalysisWindow.border or
			StatOverviewPanel.titleAnimationDistance+2*CombatAnalysisWindow.border);
		
		self.startTime = Turbine.Engine.GetGameTime();
		self.durationBar:SetWantsUpdates(true);
	end
end
