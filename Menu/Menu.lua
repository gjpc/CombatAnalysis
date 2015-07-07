
--[[ Creates the Main Menu Window ]]--

-- build the tabbed pane to sit in the plugin manager window (also create a global reference to the UI & Buffs Panel for convenience)
_G.menuPane = TabbedPane(nil);
menuPane:AddTab(L.General,GeneralMenuPanel(nil));
_G.uiMenuPanel = UIMenuPanel(nil,menuPane); 
menuPane:AddTab(L.UI,uiMenuPanel);
_G.buffsMenuPanel = BuffsMenuPanel(nil);
menuPane:AddTab(L.Buffs,buffsMenuPanel);
menuPane:AddTab(L.About,AboutMenuPanel(nil));

menuPane.AddStatOverviewTab = function(sender,tab)
  tabsAndWindowsBox:CreateTabIcon(tab);
  if (not tab.isBuffTab) then statsWindowsBox:CreateTabIcon(tab) end
  uiMenuPanel.tabsSubMenuPanel:AddTab(tab);
end

menuPane.SetWindowSet = function(sender,windowSet)
  tabsAndWindowsBox:SetWindowSet(windowSet);
  uiMenuPanel.windowsSubMenuPanel:SetWindowSet(windowSet);
end

menuPane.SetStatsWindowSet = function(sender,windowSet)
  statsWindowsBox:SetWindowSet(windowSet);
  uiMenuPanel.statsWindowsSubMenuPanel:SetStatsWindowSet(windowSet);
end

menuPane.SetTraits = function(sender,traits,reset)
  buffsMenuPanel:SetTraits(traits,reset);
end

menuPane.Destroy = function(sender)
  while (#menuPane.tabs > 0) do menuPane:RemoveTab(1) end
  menuPane.border:SetParent(nil);
  menuPane.SizeChanged = nil;
  
  menuPane:SetParent(nil);
	menuPane:SetVisible(false);
  menuPane = nil;
end

-- global functions for use from BuffBars

_G.SelectDebuffsTabInCombatAnalysisMenu = function()
  buffsMenuPanel.subMenuPane:SelectTab(2);
  menuPane:SelectTab(3);
end

_G.SelectCrowdControlTabInCombatAnalysisMenu = function()
  buffsMenuPanel.subMenuPane:SelectTab(3);
  menuPane:SelectTab(3);
end

-- set as plugin manager menu

plugin.GetOptionsPanel = function(self)
  return menuPane;
end
