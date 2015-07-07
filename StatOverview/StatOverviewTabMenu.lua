
--[[

A Stat Overview Menu specifies the stat overview 
specific options that should appear in the context
menu when a Stat Overview Tab is right clicked.

Options are available to show or hide various
aspects of the tab's current Stat Overview window.
An additional option allows the player's information
to be automatically selected, and an option is
provided that allows the totals encounter to be
reset.

]]--

_G.StatOverviewTabMenu = class(CombatAnalysisTabMenu);

function StatOverviewTabMenu:Constructor()
	CombatAnalysisTabMenu.Constructor(self);
	
	self.configureTab = Turbine.UI.MenuItem("Configure Tab");
	self.configureWindow = Turbine.UI.MenuItem("Configure Window");
	
	self.resetTotals = Turbine.UI.MenuItem(L.ResetTotals);
	self.resetTotals.Click = function(sender,args)
		if (confirmOnReset) then
			dialog:ShowConfirmDialog(L.ResetTotalsMessage,combatData.ResetTotals,combatData);
		else
			combatData:ResetTotals(true);
		end
	end
	
	self.items:Add(self.configureTab);
	self.items:Add(self.configureWindow);
	self.items:Add(self.resetTotals);
end

function StatOverviewTabMenu:PopulateMenu(tab)
	CombatAnalysisTabMenu.PopulateMenu(self,tab);
	
  self.configureTab.Click = function(sender,args)
    uiMenuPanel.tabsSubMenuPanel:SelectTab(tab);
    menuPane:SelectTab(2);
    Turbine.PluginManager.ShowOptions(Plugins["CombatAnalysis"]);
	end
  
  self.configureWindow.Click = function(sender,args)
    uiMenuPanel.windowsSubMenuPanel:SelectWindow(tab.window);
    menuPane:SelectTab(2);
    Turbine.PluginManager.ShowOptions(Plugins["CombatAnalysis"]);
	end
  
end
