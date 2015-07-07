
--[[

This file loads the global data storage info file on start up and
includes functions to save/load individual data storage files.

]]--

function _G.LoadDataList()
	-- 1) Load the Data Files List
	local dataFileListState = Turbine.PluginData.Load(Turbine.DataScope.Account,"CombatAnalysisData");
	-- apply number formatting restoration
	dataFileListState = DecodeNumbers(dataFileListState);
	
	if (type(dataFileListState) ~= "table") then
		_G.dataFileList = OrderedFileList();
	else
		_G.dataFileList = OrderedFileList.RestoreState(dataFileListState);
	end
end

_G.DataStorage = {}

-- provides some error checking for file saves
function DataStorage.SaveWrapper(dataScope, key, data, callback, dontPrintErrors)
	local success, errorMsg = pcall(Turbine.PluginData.Save, dataScope, key, data, callback);
	if (not success and not dontPrintErrors) then
		if (errorMsg == "The key contains invalid characters!") then
			dialog:ShowInfoDialog(L.InvalidCharactersMessage);
		elseif (errorMsg == "The key must be less than 64 characters long!") then
			dialog:ShowInfoDialog(L.TooManyCharactersMessage);
		else
			dialog:ShowInfoDialog(L.SaveFailedMessage..errorMsg);
		end
	end
	return success;
end

-- provides some error checking for file loads
function DataStorage.LoadWrapper(dataScope, key, callback, dontPrintErrors)
	local success, errorMsg = pcall(Turbine.PluginData.Load, dataScope, key, callback);
	if (not success and not dontPrintErrors) then
		if (errorMsg == "The key contains invalid characters!") then
			dialog:ShowInfoDialog(L.InvalidCharactersMessage);
		elseif (errorMsg == "The key must be less than 64 characters long!") then
			dialog:ShowInfoDialog(L.TooManyCharactersMessage);
		else
			dialog:ShowInfoDialog(L.LoadFailedMessage..errorMsg);
		end
	end
	return success;
end

function DataStorage.SaveDataFile(fileName,dataToSave,callback)
	return DataStorage.SaveWrapper(Turbine.DataScope.Account,string.gsub("CombatAnalysisDataFile_"..fileName," ","_"),dataToSave,callback);
end

function DataStorage.LoadDataFile(fileName,callback)
	return DataStorage.LoadWrapper(Turbine.DataScope.Account,string.gsub("CombatAnalysisDataFile_"..fileName," ","_"),callback);
end




-- Specific Load/Save functions (NB: unfortunately tightly coupled to the fileSelectDialog atm)

function DataStorage.Save(combine,encounterToSave)
	local timestamp = Turbine.Engine.GetGameTime();
  
	local saveState;
	-- combine
  if (encounterToSave) then
    saveState = encounterToSave:GetState(timestamp);
  else
    for i,item in ipairs(fileSelectBox.items) do
      if (item.encounter:IsChecked()) then
        local encounter = encountersComboBox:GetValueAtLowerIndex(i);
        if (saveState == nil) then
          saveState = encounter:GetState(timestamp);
        else
          Encounter.CombineStates(saveState,encounter:GetState(timestamp));
        end
      end
    end
  end
	if (saveState == nil) then
		dialog:ShowInfoDialog(L.NoDataSelectedMessage);
		return;
	end
	
	if (combine) then
		-- check if there is a pending save for this file (if so give error and return)
		for index=1,math.max(#fileSelectDialog.pendingSaves,#fileSelectDialog.queuedSaves,#fileSelectDialog.pendingCombines) do
			if ((index <= #fileSelectDialog.pendingSaves and fileSelectDialog.pendingSaves[index] == fileSelectDialog.fileName) or
					(index <= #fileSelectDialog.queuedSaves and fileSelectDialog.queuedSaves[index].fileName == fileSelectDialog.fileName) or
					(index <= #fileSelectDialog.pendingCombines and fileSelectDialog.pendingCombines[index].fileName == fileSelectDialog.fileName)) then
				dialog:ShowInfoDialog(L.LoadBeforeSaveMessage);
				return;
			end
		end
	end
	
	dataFileList:Add(string.lower(fileSelectDialog.fileName),fileSelectDialog.fileName,true);
	if (not DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState())) then
		dataFileList:Remove(string.lower(fileSelectDialog.fileName),fileSelectDialog.fileName);
		return;
	end
	
	if (combine) then
		if (not DataStorage.LoadDataFile(fileSelectDialog.fileName,DataStorage.CombinedSave)) then return end
		table.insert(fileSelectDialog.queuedSaves,{ ["fileName"] = fileSelectDialog.fileName, ["state"] = saveState });
		combatAnalysisIcon:SaveStart();
	else
		table.insert(fileSelectDialog.queuedSaves,1,{ ["fileName"] = fileSelectDialog.fileName, ["state"] = saveState });
		if (not DataStorage.CombinedSave(nil,true)) then return end
		combatAnalysisIcon:SaveStart();
	end
	
	-- mark encounters as saved
  if (encounterToSave) then
    encounterToSave.saved = true;
  else
    for i,item in ipairs(fileSelectBox.items) do
      if (item.encounter:IsChecked()) then encountersComboBox:GetValueAtLowerIndex(i).saved = true end
    end
  end
	
  if (not encounterToSave) then fileSelectDialog:Close() end
end

function DataStorage.Load(combine)
	local timestamp = Turbine.Engine.GetGameTime();
	
	local load = {["pending"] = {}, ["loadAsTotals"] = fileSelectDialog.loadAsTotalsCheckBox:IsChecked(), ["fromTextBox"] = (fileSelectBox.selectedCount == 0)}
	
	-- combine with current states if applicable
	load.data = nil;
	if (fileSelectDialog.fileMode == false) then
		for i,item in ipairs(fileSelectBox.items) do
			if (item.encounter:IsChecked()) then
				if (load.data == nil) then
					load.data = encountersComboBox:GetValueAtLowerIndex(i):GetState(timestamp);
				else
					Encounter.CombineStates(load.data,encountersComboBox:GetValueAtLowerIndex(i):GetState(timestamp));
				end
			end
		end
	end
	
	if (combine and fileSelectBox.selectedCount > 1) then
		load.fileName = fileSelectBox.selectedCount.." "..L.Encounters;
	end
	
	-- load/combine selected encounter(s)
	for i,_ in pairs(fileSelectBox.selectedCount == 0 and {[0] = true} or fileSelectBox.selected) do
		local itemName = (i == 0 and fileSelectDialog.fileName or dataFileList.list[i][2]);
		
		if (not combine) then
			load = {["pending"] = {}, ["data"] = load.data, ["loadAsTotals"] = fileSelectDialog.loadAsTotalsCheckBox:IsChecked(), ["fromTextBox"] = (fileSelectBox.selectedCount == 0)}
		end
		if (not combine or fileSelectBox.selectedCount <= 1) then
			load.fileName = itemName;
		end
		
		-- check if there is a pending save for this file (if so give error and return)
		for index=1,math.max(#fileSelectDialog.pendingSaves,#fileSelectDialog.queuedSaves,#fileSelectDialog.pendingCombines) do
			if ((index <= #fileSelectDialog.pendingSaves and fileSelectDialog.pendingSaves[index] == itemName) or
					(index <= #fileSelectDialog.queuedSaves and fileSelectDialog.queuedSaves[index].fileName == itemName) or
					(index <= #fileSelectDialog.pendingCombines and fileSelectDialog.pendingCombines[index].fileName == itemName)) then
				dialog:ShowInfoDialog(L.LoadBeforeSaveMessage);
				load.failed = true;
				if (#load.pending > 0) then table.insert(fileSelectDialog.pendingLoads,load) end
				return;
			end
		end
		
		if (not DataStorage.LoadDataFile(itemName,DataStorage.CombineEncounters)) then
			load.failed = true;
			if (#load.pending > 0) then table.insert(fileSelectDialog.pendingLoads,load) end
			return;
		end
		
		table.insert(load.pending,itemName);
		
		if (not combine) then
			table.insert(fileSelectDialog.pendingLoads,load);
			combatAnalysisIcon:LoadStart();
		end
	end
	
	if (combine) then
		table.insert(fileSelectDialog.pendingLoads,load);
		combatAnalysisIcon:LoadStart();
	end
	
	fileSelectDialog:Close();
end

function DataStorage.CombinedSave(loadedData,noData)
	local save = table.remove(fileSelectDialog.queuedSaves,1);
	
	if (loadedData == nil and not noData) then
		dialog:ShowInfoDialog(L.FileNotFoundMessage);
		dataFileList:Remove(string.lower(save.fileName),save.fileName);
		DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState(),nil,true);
		fileSelectBox:Reset();
		return;
	end
	
	if (not noData) then Encounter.CombineStates(DecodeNumbers(loadedData),save.state) end
	
	-- save all the selected data
	if (not DataStorage.SaveDataFile(save.fileName,EncodeNumbers(save.state),DataStorage.SaveCompleted)) then
		dataFileList:Remove(string.lower(save.fileName),save.fileName);
		DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState(),nil,true);
		fileSelectBox:Reset();
		return false;
	end
	table.insert(fileSelectDialog.pendingSaves,save.fileName);
	return true;
end

function DataStorage.SaveCompleted()
	table.remove(fileSelectDialog.pendingSaves,1);
	combatAnalysisIcon:SaveEnd();
end

function DataStorage.CombineCompleted()
	table.remove(fileSelectDialog.pendingSaves,1);
	combatAnalysisIcon:CombineEnd();
end

function DataStorage.CombineEncounters(loadedData)
	local load = fileSelectDialog.pendingLoads[1];
	
	if (loadedData == nil) then
		load.failed = true;
		load.noData = true;
		-- attempt to remove the not found file name from the file list if it was present
		if (dataFileList:Remove(string.lower(load.pending[1]),load.pending[1])) then
			DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState(),nil,true);
			fileSelectBox:Reset();
		end
	elseif (not load.failed) then
		if (load.data == nil) then
			load.data = DecodeNumbers(loadedData);
		else
			Encounter.CombineStates(load.data,DecodeNumbers(loadedData));
		end
	end
	
	table.remove(load.pending,1);
	if (#load.pending == 0) then
		combatAnalysisIcon:LoadEnd();
		
		-- load the data
		if (not load.failed) then
			-- attempt to add the file name to the file list if it wasnt already present
			if (load.fromTextBox and dataFileList:Add(string.lower(load.fileName),load.fileName)) then
				DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState(),nil,true);
				fileSelectBox:Reset();
			end
			
			DataStorage.LoadEncounter(load.data);
		else
			if (load.noData) then dialog:ShowInfoDialog(L.FileNotFoundMessage) end
			table.remove(fileSelectDialog.pendingLoads,1);
		end
	end
end

function DataStorage.CombineBeforeSave(loadedData)
	local combine = fileSelectDialog.pendingCombines[1];
	
	if (loadedData == nil) then
		combine.failed = true;
		combine.noData = true;
		table.remove(combine.pending,1);
		
	else
		if (not combine.failed) then
			if (combine.data == nil) then
				combine.data = DecodeNumbers(loadedData);
			else
				Encounter.CombineStates(combine.data,DecodeNumbers(loadedData));
			end
		end
		
		table.insert(fileSelectDialog.currentCombine,table.remove(combine.pending,1));
	end
	
	if (#combine.pending == 0) then
		table.remove(fileSelectDialog.pendingCombines,1);
		
		if (not combine.failed) then
			-- save all the selected data
			combine.failed = (not DataStorage.SaveDataFile(combine.fileName,EncodeNumbers(combine.data),DataStorage.CombineCompleted));
		elseif (combine.noData) then
			dialog:ShowInfoDialog(L.FileNotFoundMessage);
		end
		
		-- restore file list on failure
		if (combine.failed) then
			for _,combineFileName in ipairs(fileSelectDialog.currentCombine) do
				dataFileList:Add(string.lower(combineFileName),combineFileName);
			end
			DataStorage.SaveWrapper(Turbine.DataScope.Account,"CombatAnalysisData",dataFileList:GetState(),nil,true);
			fileSelectBox:Reset();
		else
			table.insert(fileSelectDialog.pendingSaves,combine.fileName);
		end
		
		fileSelectDialog.currentCombine = {}
	end
end

function DataStorage.LoadEncounter(loadedData)
	local load = table.remove(fileSelectDialog.pendingLoads,1);
	local fileName = load.fileName;
	
	if (loadedData == nil) then
		dialog:ShowInfoDialog(L.FileNotFoundMessage);
		return false;
	end
	
	-- create loaded encounter from the data
	local gameStartTime = Turbine.Engine.GetGameTime();
	local loadedEncounter = Encounter.RestoreState(DecodeNumbers(loadedData),gameStartTime);
	loadedEncounter.name = (load.loadAsTotals and L.Totals or fileName);
	
  local hour = nil;
  local minute;
  local second;
  loadedEncounter.name = string.gsub(loadedEncounter.name, "%d%d%d%d %d%d %d%d (%d%d) (%d%d) (%d%d) ",function(h,m,s)
    hour = tonumber(h); minute = tonumber(m); second = tonumber(s);
    return "";
  end);
	local now = Turbine.Engine.GetDate();
	loadedEncounter.longName = loadedEncounter.name .. " ("..
		((loadedEncounter.startTime.Year < now.Year or loadedEncounter.startTime.Month < now.Month or loadedEncounter.startTime.Day < now.Day) and
			Misc.FormatDate(loadedEncounter.startTime)..(hour ~= nil and " "..Misc.FormatTime({Hour = hour, Minute = minute, Second = second}) or "") or
			Misc.FormatTime(loadedEncounter.startTime))..
		")";
	
	if (load.loadAsTotals) then
		combatData.totalsEncounter = loadedEncounter;
		if (combatData.inCombat) then
			combatData.totalsEncounter:Continue(gameStartTime);
			combatData.totalsEncounter:CombatStarted(false,gameStartTime);
		end
		
		encountersComboBox:SetTotals(loadedEncounter.longName,combatData.totalsEncounter);
		encountersComboBox:SelectTotals();
		
	else
		encountersComboBox:AddItem(loadedEncounter.longName,loadedEncounter,true);
		encountersComboBox:SelectLastTopItem();
		
	end
	
	return true;
end
