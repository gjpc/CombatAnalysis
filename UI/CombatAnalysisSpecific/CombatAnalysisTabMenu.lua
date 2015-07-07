
--[[

A Combat Analysis Tab Menu specifies what should appear
in the context menu when a Combat Analysis Tab is right
clicked.

Standard options include a "Close Tab" item and an
"Add Tab" option, where the tabs that are available
to add are determined by the tab's tabSet field.

]]--

_G.CombatAnalysisTabMenu = class(Turbine.UI.ContextMenu);

function CombatAnalysisTabMenu:Constructor()
	Turbine.UI.ContextMenu.Constructor(self);
	
	self.items = self:GetItems();
	
	self.title = Turbine.UI.MenuItem("",false);
	
	self.addTab = Turbine.UI.MenuItem(L.RestoreTab);
	self.addTabItems = self.addTab:GetItems();
	self.closeTab = Turbine.UI.MenuItem(L.CloseTab);
	
	self.items:Add(self.title);
	self.items:Add(self.addTab);
	self.items:Add(self.closeTab);
end

function CombatAnalysisTabMenu:PopulateMenu(tab)
	self.title:SetText(tab.text);
	
	self.addTabItems:Clear();
	
	for _,restorableTab in pairs(tab.tabSet) do
		if (restorableTab.window == nil) then
			local add = Turbine.UI.MenuItem(restorableTab.text);
			add.Click = function(sender,args)
				tab.window:AddTab(restorableTab,false);
				restorableTab:SaveState();
			end
			self.addTabItems:Add(add);
		end
	end
	
	if (self.addTabItems:GetCount() > 0) then
		self.addTab:SetEnabled(true);
	else
		self.addTab:SetEnabled(false);
	end
  
	self.closeTab.Click = function(sender,args)
		tab.window:RemoveTab(tab);
		tab:SaveState();
	end
end
