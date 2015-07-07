
local StatOverviewTraitConfigMenu = class(Turbine.UI.ContextMenu);

function StatOverviewTraitConfigMenu:Constructor()
	Turbine.UI.ContextMenu.Constructor(self);
	
	self.items = self:GetItems();
  
  Misc.AddListener(nil, "traitConfigurationAdded", function(sender,name)
    -- local color = TraitConfigTextToColor(configuration.color);
    
    local newItem = self:CreateItem(name,(name == traits.selected))
    
    for i=1,self.items:GetCount() do
      local item = self.items:Get(i);
      if (item:GetText() > name) then
        self.items:Insert(i,newItem);
        return;
      end
    end
    
    self.items:Add(newItem);
    
	end, self, self);
  
  Misc.AddListener(nil, "traitConfigurationRemoved", function(sender,name)
    for i=1,self.items:GetCount() do
      local item = self.items:Get(i);
      if (item:GetText() == name) then
        self.items:RemoveAt(i);
        return;
      end
    end
	end, self, self);
  
  Misc.AddListener(nil, "traitConfigurationSelected", function(sender,name)
    for i=1,self.items:GetCount() do
      local item = self.items:Get(i);
      if (item:GetText() == name) then
        item:SetChecked(true);
      else
        item:SetChecked(false);
      end
    end
	end, self, self);
  
end

function StatOverviewTraitConfigMenu:SetConfigurationList(configurations)
  self.items:Clear();
  
  local sortedConfigs = {}
  for name,_ in pairs(configurations) do
    table.insert(sortedConfigs,name);
  end
  table.sort(sortedConfigs);
  for _,configName in ipairs(sortedConfigs) do
    self.items:Add(self:CreateItem(configName,(configName == traits.selected)));
  end
end

function StatOverviewTraitConfigMenu:CreateItem(name,selected)
  local menuItem = Turbine.UI.MenuItem(name,true,selected);
  
  menuItem.Click = function(sender,args)
    if (menuItem:IsChecked()) then return end
    
    traits.selected = name;
    SaveTraits();
    Misc.NotifyListeners(nil, "traitConfigurationSelected", name);
  end
  
  return menuItem;
end

_G.buffsMenu = StatOverviewTraitConfigMenu();
