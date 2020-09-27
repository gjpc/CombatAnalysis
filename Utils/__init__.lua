
-- automatically extract plugin version number

local function GetVersionNo()
	for _,plugin in ipairs(Turbine.PluginManager.GetAvailablePlugins()) do
		if (plugin.Name == "CombatAnalysis") then
			return plugin.Version;
		end
	end
	return "";
end
local err,versionNo = pcall(GetVersionNo);
_G.versionNo = (err and versionNo or "");


-- imports

import "CombatAnalysis.Utils.Class"
import "CombatAnalysis.Utils.Type"

import "CombatAnalysis.Utils.HashSet"
import "CombatAnalysis.Utils.OrderedList"
import "CombatAnalysis.Utils.OrderedFileList"

import "CombatAnalysis.Utils.Settings"
import "CombatAnalysis.Utils.DataStorage"
import "CombatAnalysis.Utils.Misc"
import "CombatAnalysis.Utils.Enums"

import "CombatAnalysis.Utils.Commands"
import "CombatAnalysis.Utils.KeyManager"
