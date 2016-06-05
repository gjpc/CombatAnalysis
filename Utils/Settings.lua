
--[[

This file loads the global settings file on start up and
includes an global functions to deal with loading and saving
of numbers in the different formats (euro/non-euro).

]]--

local restoreV400Settings = function()
  -- a list of the stat overview tabs (key = tab type, where (1 = dmgTab, 2 = takenTab, 3 = healTab, 4 = powerTab))
  settings.tabStates = {
    -- tab index in window, selected, tab window id, stats panel window id,
    --   showStats state (1->3), auto select player, show title, show encounters, show targets, show extra buttons,
    --   expanded stats tree headings (main, crits, avoids, fulls, partials, other, dmg types)
    [1] = {1,true,1,2,3,false,true,true,true,true,{true,true,true,true,true,true,true}},
    [2] = {2,false,1,2,3,false,true,true,true,true,{true,true,true,true,true,true,true}},
    [3] = {3,false,1,2,3,false,true,true,true,true,{true,true}},
    [4] = {4,false,1,2,3,false,true,true,true,true,{true,true}}
  };
  
  -- a list of all std stat overview windows (key = window id)
  settings.statOverviewWindowStates = {
    -- class type, xpos (nil = default), ypos (nil = default), width, height, show background, title bar width (0 or 42), auto hide tabs, minimized, unminimized width, unminimized height
    [1] = {nil,nil,270,221,true,42,false,false,270,221}
  };
  
  -- a list of all stat overview stats (details) windows (key = window id)
  settings.statOverviewStatsWindowStates = {
    -- class type, xpos (nil = default), ypos (nil = default), width, height, window id
    [2] = {nil,nil,270,221}
  };
  
  -- global settings (just the one in v4.0.0)
  settings.autoSelectNewEncounters = true;
end


local restoreV404Settings = function()
  settings.chatChannel = 1;
end


local restoreV410Settings = function()
  -- 1) update tab state data
  local dmgTabData = settings.tabStates[1];
  local takenTabData = settings.tabStates[2];
  local healTabData = settings.tabStates[3];
  local powerTabData = settings.tabStates[4];
  
  settings.tabStates = {
    ["dmgTab"] = {
      ["indexInWindow"] = dmgTabData[1], ["selected"] = dmgTabData[2], ["windowID"] = dmgTabData[3], ["statsWindowID"] = dmgTabData[4],
      ["statsWindowVisibility"] = (dmgTabData[5] == 1 and "Hide" or (dmgTabData[5] == 2 and "Hover" or "Show")), ["autoSelectPlayer"] = dmgTabData[6],
      ["showTitle"] = dmgTabData[7], ["showEncounters"] = dmgTabData[8], ["showTargets"] = dmgTabData[9], ["showExtraButtons"] = dmgTabData[10],
      ["expandedStatHeadings"] = {
        ["totals"] = dmgTabData[11][1], ["crits"] = dmgTabData[11][2],
        ["avoidance"] = dmgTabData[11][3], ["fullAvoids"] = dmgTabData[11][4], ["partials"] = dmgTabData[11][5],
        ["other"] = dmgTabData[11][6], ["dmgTypes"] = dmgTabData[11][7]
      }
    },
    
    ["takenTab"] = {
      ["indexInWindow"] = takenTabData[1], ["selected"] = takenTabData[2], ["windowID"] = takenTabData[3], ["statsWindowID"] = takenTabData[4],
      ["statsWindowVisibility"] = (takenTabData[5] == 1 and "Hide" or (takenTabData[5] == 2 and "Hover" or "Show")), ["autoSelectPlayer"] = takenTabData[6],
      ["showTitle"] = takenTabData[7], ["showEncounters"] = takenTabData[8], ["showTargets"] = takenTabData[9], ["showExtraButtons"] = takenTabData[10],
      ["expandedStatHeadings"] = {
        ["totals"] = takenTabData[11][1], ["crits"] = takenTabData[11][2],
        ["avoidance"] = takenTabData[11][3], ["fullAvoids"] = takenTabData[11][4], ["partials"] = takenTabData[11][5],
        ["other"] = takenTabData[11][6], ["dmgTypes"] = takenTabData[11][7]
      }
    },
    
    ["healTab"] = {
      ["indexInWindow"] = healTabData[1], ["selected"] = healTabData[2], ["windowID"] = healTabData[3], ["statsWindowID"] = healTabData[4],
      ["statsWindowVisibility"] = (healTabData[5] == 1 and "Hide" or (healTabData[5] == 2 and "Hover" or "Show")), ["autoSelectPlayer"] = healTabData[6],
      ["showTitle"] = healTabData[7], ["showEncounters"] = healTabData[8], ["showTargets"] = healTabData[9], ["showExtraButtons"] = healTabData[10],
      ["expandedStatHeadings"] = {
        ["totals"] = healTabData[11][1], ["crits"] = healTabData[11][2], ["tempMorale"] = true -- new temp morale heading is expanded by default
      }
    },
    
    ["powerTab"] = {
      ["indexInWindow"] = powerTabData[1], ["selected"] = powerTabData[2], ["windowID"] = powerTabData[3], ["statsWindowID"] = powerTabData[4],
      ["statsWindowVisibility"] = (powerTabData[5] == 1 and "Hide" or (powerTabData[5] == 2 and "Hover" or "Show")), ["autoSelectPlayer"] = powerTabData[6],
      ["showTitle"] = powerTabData[7], ["showEncounters"] = powerTabData[8], ["showTargets"] = powerTabData[9], ["showExtraButtons"] = powerTabData[10],
      ["expandedStatHeadings"] = {
        ["totals"] = powerTabData[11][1], ["crits"] = powerTabData[11][2]
      }
    },
    
    -- new buff and debuff tabs (not in any windows by default)
    ["debuffTab"] = {},
    ["buffTab"] = {}
  }
  
  -- 2) update window state data
  settings.windowStates = {}
  for windowId,windowState in pairs(settings.statOverviewWindowStates) do
    settings.windowStates[windowId] = {
      ["x"] = windowState[1], ["y"] = windowState[2], ["w"] = windowState[9], ["h"] = windowState[10], -- only the unminimized window width is stored now
      ["showBackground"] = windowState[5],
      ["showTitleBar"] = (windowState[6] == true or (windowState[6] ~= false and windowState[6] > 0)), -- new method used to save title bar status
      ["autoHideTabs"] = windowState[7], ["minimized"] = windowState[8]
    };
  end
  settings.statOverviewWindowStates = nil;
  
  -- 3) update stat window state data
  settings.statsWindowStates = {}
  for windowId,windowState in pairs(settings.statOverviewStatsWindowStates) do
    settings.statsWindowStates[windowId] = {
      ["x"] = windowState[1], ["y"] = windowState[2], ["w"] = windowState[3], ["h"] = windowState[4]
    };
  end
  settings.statOverviewStatsWindowStates = nil;
  
  -- show confirm dialog when reset is clicked by default
  settings.confirmOnReset = true;
  
  -- use a larger font
  settings.largeFont = true;
  settings.statFont = 2.0;
  -- default file dialog settings
  settings["fileDialog"] = {}
end


local restoreV420Settings = function()
  -- for each tab, display mode can be "Totals" or "Percentages" (NB: not yet implemented)
  for name,_ in pairs(settings.tabStates) do
    settings.tabStates[name]["display"] = "Totals";
  end
  
  -- for each tab, set the default color scheme
  settings.tabStates["dmgTab"]["colorScheme"] = Turbine.UI.Color(0.4,1,0,0);
  settings.tabStates["takenTab"]["colorScheme"] = Turbine.UI.Color(0.4,1,0.446154,0);
  settings.tabStates["healTab"]["colorScheme"] = Turbine.UI.Color(0.4,0,1,0);
  settings.tabStates["powerTab"]["colorScheme"] = Turbine.UI.Color(0.4,0,0,1);
  settings.tabStates["buffTab"]["colorScheme"] = Turbine.UI.Color(0.75,1,1,1);
  settings.tabStates["debuffTab"]["colorScheme"] = Turbine.UI.Color(0.75,0,0,0);
  
  -- in addition, set the temp morale color (applies to the heal tab only)
  settings.tabStates["healTab"]["tempMoraleColor"] = Turbine.UI.Color(0.4,0.625,0,1);
  
  -- for each window, set the default background color
  for id,windowState in pairs(settings.windowStates) do
    windowState["backgroundColor"] = Turbine.UI.Color(0.046154,0.4,0.4,0.4);
  end
  
  -- for each stats window, set the default background color
  for id,windowState in pairs(settings.statsWindowStates) do
    windowState["backgroundColor"] = Turbine.UI.Color(0.5,darkBackgroundColor.R,darkBackgroundColor.G,darkBackgroundColor.B);
  end
  
  -- default logo position & visibility settings
  settings["logo"] = {}
  settings.showCombatAnalysisIcon = true;
  
  -- global window state
  settings.windowsLocked = false;
  settings.windowsHidden = false;
  
  -- auto save encounters (Off, SaveTotals, SaveEncounters)
  settings.autoSave = "Off";
  
  -- max no of encounters
  settings.maxEncounters = 50;
  settings.maxLoadedEncounters = 5;
  
  -- combat grace periods
  settings.combatTimeout = (player.class == "Burglar" and 2.8 or 1.5); -- give Burglars significantly more default time due to HIPS
  settings.targetTimeout = 1.2;
  
  -- log to effect delays
  settings.logDelay = 1.5;
  settings.effectDelay = 1.0;
  
  -- other new global settings
  settings.showTooltips = true;
  settings.allMinized = false;
  settings.allHidden = false;
  
  -- the first of potentially more tutorial hints
  settings.combatAnalysisLogoTutorialViewed = false;
 
end

local shutDownAll = function ()
  while(#statOverviewWindows > 0) do
    statOverviewWindows[1]:Close(nil,true);
  end
  
  while(#statOverviewStatsWindows > 0) do
    statOverviewStatsWindows[1]:Close(nil,true);
  end
  
  for _,tab in pairs(statOverviewTabs) do
    tab:SetSelected(false);
    tab.showStats = nil;
  end
end

local interpretSettings = function ()
  -- restore all windows (and build a temporary dictionary of window ids -> windows)
	local maxId = 1;
	local windows = {}
	local noStatOverviewWindows = 0;
  
  if ( settings.largeFont == true ) then
	_G.largeFont = true;
	_G.statFont = Turbine.UI.Lotro.Font.TrajanPro18;
  else
	_G.largeFont = false;
	_G.statFont = Turbine.UI.Lotro.Font.TrajanPro14;
  end
  
  -- sort windows by id
  local windowStates = {}
  for windowId,windowState in pairs(settings.windowStates) do
		table.insert(windowStates,{ ["windowId"] = windowId, ["state"] = windowState });
	end
  table.sort(windowStates,function(a,b)
		return (a["windowId"] < b["windowId"]);
	end);
  
	-- create std stat overview windows
	for _,windowState in pairs(windowStates) do
		windows[windowState["windowId"]] = StatOverviewWindow.RestoreState(windowState["windowId"],windowState["state"]);
		maxId = math.max(windowState["windowId"],maxId);
    local backgroundColor = windowState["state"]["backgroundColor"];
    windows[windowState["windowId"]]:SetBackgroundColor(Turbine.UI.Color(backgroundColor.A,backgroundColor.R,backgroundColor.G,backgroundColor.B),true);
    
		noStatOverviewWindows = noStatOverviewWindows + 1;
	end
  
  -- sort statwindows by id
  local statsWindowStates = {}
  for windowId,windowState in pairs(settings.statsWindowStates) do
		table.insert(statsWindowStates,{ ["windowId"] = windowId, ["state"] = windowState });
	end
  table.sort(statsWindowStates,function(a,b)
		return (a["windowId"] < b["windowId"]);
	end);
  
  -- create stat overview "stats" windows
	for windowId,windowState in pairs(statsWindowStates) do
		windows[windowState["windowId"]] = StatOverviewStatsWindow.RestoreState(windowState["windowId"],windowState["state"]);
		maxId = math.max(windowState["windowId"],maxId);
    local backgroundColor = windowState["state"]["backgroundColor"];
    windows[windowState["windowId"]]:SetBackgroundColor(Turbine.UI.Color(backgroundColor.A,backgroundColor.R,backgroundColor.G,backgroundColor.B),true);
	end
	_G.idCounter = maxId + 1; -- ensure ids are never duplicated
	
	-- sort tabs by index order so that the order of tabs in a window is maintained (note that the position/order
  -- of tabs that are not in a window is irrelevant, and likewise for tabs of the same index in different windows)
	local tabStates = {}
	for tabKey,tabState in pairs(settings.tabStates) do
		table.insert(tabStates,{ ["tabKey"] = tabKey, ["state"] = tabState });
	end
  
	table.sort(tabStates,function(a,b)
		if (a["state"]["indexInWindow"] == nil) then
			if (b["state"]["indexInWindow"] ~= nil) then
				return false;
			else
				return (a["tabKey"] < b["tabKey"]);
			end
		elseif (b["state"]["indexInWindow"] == nil) then
			return true;
		else
			return (a["state"]["indexInWindow"] < b["state"]["indexInWindow"]);
		end
	end);
	
	for tab,tabState in pairs(tabStates) do
		local statOverviewTab = statOverviewTabs[tabState["tabKey"]];
		-- configure tab settings
    Misc.SetValue(statOverviewTab,"autoSelectPlayer",tabState["state"]["autoSelectPlayer"]);
		statOverviewTab:SetShowTitle(tabState["state"]["showTitle"],true);
		statOverviewTab:SetShowEncounters(tabState["state"]["showEncounters"],true);
		statOverviewTab:SetShowTargets(tabState["state"]["showTargets"],true);
		statOverviewTab:SetShowSendChat(tabState["state"]["showExtraButtons"],true);
		if (statOverviewTab.window ~= nil) then statOverviewTab.window:Layout() end
		-- expand/collapse the stats tree views appropriately
		if (not statOverviewTab.isBuffTab) then
			statOverviewTab.statsPanel:Restore(tabState["state"]["expandedStatHeadings"]);
		end
    -- update the tab color scheme
    local colorScheme = tabState["state"]["colorScheme"];
    statOverviewTab:UpdateColor(Turbine.UI.Color(colorScheme.A,colorScheme.R,colorScheme.G,colorScheme.B),true);
    local tempMoraleColor = tabState["state"]["tempMoraleColor"];
    if (tempMoraleColor ~= nil) then statOverviewTab:UpdateColor2(Turbine.UI.Color(tempMoraleColor.A,tempMoraleColor.R,tempMoraleColor.G,tempMoraleColor.B),true) end
    -- update the stats window info
		if (not statOverviewTab.isBuffTab) then
      -- add the stats panel to its relevant windows
      if (tabState["state"]["statsWindowID"] ~= nil) then
        windows[tabState["state"]["statsWindowID"]]:AddPanel(statOverviewTab.statsPanel);
      end
      -- show stats windows if applicable (but retain previous window ordering)
      statOverviewTab:SetShowStats(
        (tabState["state"]["statsWindowVisibility"] and
          (tabState["state"]["statsWindowVisibility"] == "Hide" and 1 or (tabState["state"]["statsWindowVisibility"] == "Hover" and 2 or 3)) or
        nil),true);
    end
    -- update the info button display
    if (not statOverviewTab.panel.isBuffTab and tabState["state"]["statsWindowID"] == nil) then
      statOverviewTab.panel.infoButton:SetBackground("CombatAnalysis/Resources/gears.tga");
    end
    -- add the tab to its relevant window
		if (tabState["state"]["windowID"] ~= nil) then windows[tabState["state"]["windowID"]]:AddTab(statOverviewTab,tabState["state"]["selected"],nil,true) end
	end
	
	-- now that tabs have been added to the relevant windows, set them to visible
	for windowId,_ in pairs(settings.windowStates) do
		local window = windows[windowId];
    
    -- fire some event to ensure the menu is updated
    Misc.NotifyListeners(window,"showTitle");
    Misc.NotifyListeners(window,"showEncounters");
    Misc.NotifyListeners(window,"showTargets");
    Misc.NotifyListeners(window,"showSendChat");
		
		if (#window.tabs > 0) then
			-- check to make sure that a tab is selected (should always be true)
			if (window.selected == nil) then
				window:SetSelectedTab(window.tabs[1],true,true);
			end
			windows[windowId]:SetVisible(true);
		end
	end
	
  -- set the position of the logo
  combatAnalysisIcon:RestoreState(settings["logo"]);
  
	-- set the global variables
	chatMenu:RestoreState(settings.chatChannel);
  Misc.SetValue(combatData,"maxEncounters",settings.maxEncounters,true);
  Misc.SetValue(combatData,"maxLoadedEncounters",settings.maxLoadedEncounters,true);
  Misc.SetValue(combatData,"timer",settings.combatTimeout,true);
  Misc.SetValue(combatData,"minDuration",settings.targetTimeout,true);
  Misc.SetValue(nil,"logDelay",settings.logDelay,true);
  Misc.SetValue(nil,"effectDelay",settings.effectDelay,true);
	Misc.SetValue(nil,"autoSelectNewEncounters",settings.autoSelectNewEncounters,true);
	Misc.SetValue(nil,"confirmOnReset",settings.confirmOnReset,true);
  Misc.SetValue(nil,"autoSave",settings.autoSave,true);
  Misc.SetValue(nil,"showCombatAnalysisIcon",settings.showCombatAnalysisIcon,true);
  Misc.SetValue(nil,"windowsLocked",settings.windowsLocked,true);
  Misc.SetValue(nil,"windowsHidden",settings.windowsHidden,true);
  
  if (not showCombatAnalysisIcon) then WindowManager.ShowHideWindows({combatAnalysisIcon},false,true,"combatAnalysisIcon") end
  if (windowsLocked) then combatAnalysisIcon:LockWindows(true,true) end
  if (windowsHidden) then combatAnalysisIcon:ShowHideWindows(true,true) end
	
	-- set the file dialog settings
	fileSelectDialog.RestoreState(settings.fileDialog);
	
  -- make the dmg tab/stats window the default selection in the UI Menu
  uiMenuPanel.tabsSubMenuPanel:SelectTab(dmgTab);
  
  -- show tutorial hints
  if (not settings.combatAnalysisLogoTutorialViewed) then TutorialHint(L.LogoTitle, L.LogoMessage, "CombatAnalysis/Resources/logo.tga") end
  
	-- now that settings have been restored, encode them all for quick saving later on
	EncodeNumbers(settings);
end


function _G.RestoreDefaultSettings(confirm)
  if (not confirm) then return end
  
  shutDownAll();
  
  _G.settings = {}
  restoreV400Settings();
  restoreV404Settings();
  restoreV410Settings();
  restoreV420Settings();
  settings.versionNo = versionNo;
  
  local success = pcall(interpretSettings);
  SaveSettings(true);
  if (not success) then Turbine.Shell.WriteLine("An unexpected error occured while restoring the default settings. Please re-load the plugin before continuing.") end
end







-- global function to decode (convert from strings) stored numbers (in place)
function _G.DecodeNumbers(object)
	-- parse strings into numbers where applicable
	if (type(object) == "string") then
		local number,separator,decimal = object:match("<num>(-?%d+)([%.,])(%d+)</num>");
		if (number ~= nil) then
			local decodedNumber = tonumber(number..separator..decimal);
			if (decodedNumber ~= nil) then return decodedNumber end
			return tonumber(number..(separator == "," and "." or ",")..decimal);
		else
			return object;
		end
	-- return any other data types
	elseif (type(object) ~= "table") then
		return object;
	-- decode each element inside a table and return
	else
		local tableCopy = {};
		for index, value in pairs(object) do
			tableCopy[index] = DecodeNumbers(value);
		end
    for index, value in pairs(tableCopy) do
      object[index] = nil;
			object[DecodeNumbers(index)] = value;
		end
		return object;
	end
end

_G.settings = Turbine.PluginData.Load(Turbine.DataScope.Character,"CombatAnalysis");

-- load the plugin settings (will be done once on startup)
function _G.LoadSettings()
  
  DecodeNumbers(settings);
	local upToDate = true;
	
	-- if no settings file exists (or it is outdated), use the following defaults
	--   (note that forwards compatability is now assumed when finding old settings files and
	--    we retain the previous settings info where applicable - though any settings file
	--    before version 4.0.0 will be completely overwritten)
	if (type(settings) ~= "table" or settings.versionNo == nil or string.gsub(settings.versionNo,"%.","") < string.gsub(versionNo,"%.","")) then
		upToDate = false;
		
		if (type(settings) ~= "table" or settings.versionNo == nil or string.gsub(settings.versionNo,"%.","") < "400") then
			_G.settings = {};
		end
    
		-- v4.0.0 settings
		if (settings.versionNo == nil or string.gsub(settings.versionNo,"%.","") < "400") then
      restoreV400Settings();
		end
		
		-- v4.0.4 additional settings
		if (settings.versionNo == nil or string.gsub(settings.versionNo,"%.","") < "404") then
			restoreV404Settings();
		end
		
		-- v4.1.0 additional settings (note that we perform a complete conversion of the old settings file format to the new more readable format)
		if (settings.versionNo == nil or string.gsub(settings.versionNo,"%.","") < "410") then
			restoreV410Settings();
		end
		
    -- v4.2.0 additional settings
		if (settings.versionNo == nil or string.gsub(settings.versionNo,"%.","") < "420") then
      restoreV420Settings();
    end
    
		-- now that all the default settings have been loaded, update the settings versionNo to match the current plugin versionNo
		settings.versionNo = versionNo;
	end
  
	interpretSettings();
  
  -- if the settings file has had defaults added, store these values
	if (not upToDate) then SaveSettings() end
end

-- global function to encode numbers into a save-proof format (in place)
function _G.EncodeNumbers(object)
	if (type(object) == "number") then
		return ("<num>%f</num>"):format(object);
	elseif (type(object) ~= "table") then
		return object;
	else
		local tableCopy = {};
		for index, value in pairs(object) do
			tableCopy[index] = EncodeNumbers(value);
		end
    for index, value in pairs(tableCopy) do
      object[index] = nil;
			object[EncodeNumbers(index)] = value;
		end
		return object;
	end
end

local settingsSavePending = false;
_G.settingsNeedResaving = false;

local function SaveComplete(success,errorMessage)
  if (not settingsNeedResaving) then
    settingsSavePending = false;
    return;
  end
  
  settingsNeedResaving = false;
  Turbine.PluginData.Save(Turbine.DataScope.Character, "CombatAnalysis", settings, SaveComplete);
end

-- global function to save current settings (note that this function should be called anytime settings change)
function _G.SaveSettings(confirm)
  if (not combatAnalysisLoaded and not confirm) then return end
  if (settingsSavePending) then settingsNeedResaving = true; return end
  
  settingsSavePending = true;
	Turbine.PluginData.Save(Turbine.DataScope.Character, "CombatAnalysis", settings, SaveComplete);
end

