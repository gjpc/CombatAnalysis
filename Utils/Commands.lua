
-- commands
UpdateCommand = Turbine.ShellCommand();
Turbine.Shell.AddCommand("ca", UpdateCommand);
Turbine.Shell.AddCommand("combatanalysis", UpdateCommand);

local sc = 1;

-- command
function UpdateCommand:Execute(cmd, args)
	if string.len(args) > 0 then
		args = string.lower(args);
		
		-- show menu
		if (string.find(args,L.Options) == 1 or string.find(args,L.Settings) == 1 or string.find(args,L.Setup) == 1 or string.find(args,"menu") == 1) then
      menuPane:SelectTab(1);
			Turbine.PluginManager.ShowOptions(Plugins["CombatAnalysis"]);
			return;
		end
		
		-- save
		if (string.find(args,L.SaveCommand) == 1) then
			fileSelectDialog:Show(true);
			return;
		end
		
		-- load
		if (string.find(args,L.LoadCommand) == 1) then
			fileSelectDialog:Show(false);
			return;
		end
    
    -- toggle window visibility
    if (string.find(args,L.ToggleCommand) == 1) then
      combatAnalysisIcon:ShowHideWindows(not windowsHidden);
      return;
    end
    
    -- show windows
    if (string.find(args,L.ShowCommand) == 1) then
      combatAnalysisIcon:ShowHideWindows(false);
      return;
    end
    
    -- hide windows
    if (string.find(args,L.HideCommand) == 1) then
      combatAnalysisIcon:ShowHideWindows(true);
      return;
    end
    
    -- toggle lock/unlock windows
    if (string.find(args,L.LockToggleCommand) == 1) then
      combatAnalysisIcon:LockWindows(not windowsLocked);
      return;
    end
    
    -- lock windows
    if (string.find(args,L.LockCommand) == 1) then
      combatAnalysisIcon:LockWindows(true);
      return;
    end
    
    -- unlock windows
    if (string.find(args,L.UnlockCommand) == 1) then
      combatAnalysisIcon:LockWindows(false);
      return;
    end
    
    if ( string.find( args, L.ResetTotalsCommand ) == 1 ) then
      combatData:ResetTotals(true);
      return;
    end
	
	if ( string.find( args, L.CleanUpCommand ) == 1 ) then
      combatData:ResetTotals(true);
	  collectgarbage();
      return;
    end
    
    if ( string.find( args, L.ResetCommand ) == 1 ) then
      if (not player:IsInCombat()) then
        combatData:Initialize();
      else
        Turbine.Shell.WriteLine("  Whoa! Slow down cowboy, stop punching them cows first");
      end
      return;
    end
	end
	
	Turbine.Shell.WriteLine(L.CommandUsage);
end

-- set up Plugin unload event
Plugins["CombatAnalysis"].Unload = function()
  -- remove the command
	Turbine.Shell.RemoveCommand(UpdateCommand);
	
  -- resave settings and traits if necessary
  if (settingsNeedResaving) then
    Turbine.PluginData.Save(Turbine.DataScope.Character, "CombatAnalysis", settings);
  end
  if (traitsNeedResaving) then
    Turbine.PluginData.Save(Turbine.DataScope.Character, "CombatAnalysisTraits", EncodeNumbers(Misc.TableCopy(traits)));
  end
  
  -- apply the auto save feature
  local timestamp = Turbine.Engine.GetGameTime();
  
  -- save the totals encounter if there is any data
  if (autoSave == "SaveTotals" and combatData.totalsEncounter.orderedMobs[1]:Duration(timestamp) > 0) then
    -- generate a unique name to save the encounter as
    local saveName = Misc.FormatDateTime(combatData.totalsEncounter.startTime).." "..string.gsub(combatData.totalsEncounter.name,"[^%w ]"," ");
    fileSelectDialog.fileName = string.sub(saveName, 1, math.max(63, string.len(saveName)));
    local index,strExists = dataFileList:BinarySearch(saveName);
    for count = 1,9 do
      if (not strExists) then break end
      fileSelectDialog.fileName = string.sub(saveName, 1, math.max(61, string.len(saveName))).." "..tostring(count);
      index,strExists = dataFileList:BinarySearch(fileSelectDialog.fileName);
    end
    
    -- save the totals encounter
    DataStorage.Save(nil,combatData.totalsEncounter);
    
  -- save the current encounter if in combat
  elseif (autoSave == "SaveEncounters" and combatData.inCombat) then
    -- generate a unique name to save the encounter as
    local saveName = Misc.FormatDateTime(combatData.currentEncounter.startTime).." "..string.gsub(combatData.currentEncounter.name,"[^%w ]"," ");
    fileSelectDialog.fileName = string.sub(saveName, 1, math.max(63, string.len(saveName)));
    local index,strExists = dataFileList:BinarySearch(fileSelectDialog.fileName);
    for count = 1,9 do
      if (not strExists) then break end
      fileSelectDialog.fileName = string.sub(saveName, 1, math.max(61, string.len(saveName))).." "..tostring(count);
      index,strExists = dataFileList:BinarySearch(fileSelectDialog.fileName);
    end
    
    -- save the current encounter
    DataStorage.Save(nil,combatData.currentEncounter);
  end
  
  -- attempt to remove the menu
  menuPane:Destroy();
  collectgarbage();
end