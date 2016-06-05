--[[ THIS CODE AND ALL OF ITS RESOURCES ARE IN THE PUBLIC DOMAIN ]]--
--[[ Plugin entry point ]]--

_G.printDebug = false;

-- Import Turbine Classes

import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

-- Determine Locale and load locale specific text information

-- convert from a Turbine language object to a supported locale value
local language = Turbine.Engine.GetLanguage();
_G.locale = (language == Turbine.Language.German and "de" or (language == Turbine.Language.French and "fr" or (language == Turbine.Language.Russian and "ru" or "en" )));
_G.L = {}

-- since English & German are supported at release, load their locale files directly
if (locale == "en" or locale == "de") then
  import ("CombatAnalysis.Locale."..locale);
-- for all other languages, we now load the English locale file first, then load the language specific file (which may only override some values) only if it exists
else
  import ("CombatAnalysis.Locale.en");
  pcall(import, ("CombatAnalysis.Locale."..locale));
end

-- Import Utils & UI
import "CombatAnalysis.Utils";
import "CombatAnalysis.UI";

-- Import Other Helper Classes
import "CombatAnalysis.Data";
import "CombatAnalysis.Players";
import "CombatAnalysis.Parser";

-- Import the Main Menu (and Help Menu)
import "CombatAnalysis.Menu"; --- v4.1/4.2
import "CombatAnalysis.Help"; --- v4.2+

-- Import each individual Plugin package
import "CombatAnalysis.StatOverview";     --- v4.0
import "CombatAnalysis.Effects";          --- v4.1 (for BuffBars Debuff/CC tracking)
-- import "CombatAnalysis.StatAnalysis";  --- v4.3+
-- import "CombatAnalysis.FloatyInfo";    --- v4.3/4+
-- import "CombatAnalysis.ChatFiltering"; --- ? (possible future feature)
-- import "CombatAnalysis.HealingBars";   --- ? (possible future feature)
-- import "CombatAnalysis.GearScore";     --- ? (possible future feature)

--[[ Start up ]]--

-- Print the Welcome Message (the version number is extracted automatically)
Turbine.Shell.WriteLine("Combat Analysis by Evendale enhanced by Landal"..(locale ~= "en" and L.TranslatedBy ~= nil and L.TranslatedBy ~= "" and " ("..L.TranslatedBy..")" or ""));
Turbine.Shell.WriteLine("Combat Analysis v"..versionNo.." by Landal"..(locale ~= "en" and L.TranslatedBy ~= nil and L.TranslatedBy ~= "" and " ("..L.TranslatedBy..")" or ""));

-- Load the Data Files List to assist with loading/saving
LoadDataList();

-- Initialize the global combat data object (create "Totals" encounter with timestamp)
combatData:Initialize();

-- Set up a callback to load the user Settings which will create all relevant windows
local function LoadSettingsCallback()
  if (not pcall(LoadSettings)) then
    -- if there is an error loading the settings file, give the user the option to reset immediately
    dialog:ShowConfirmDialog(L.FailedToLoadSettingsResetConfirmation,function(confirm)
      if (confirm) then
        RestoreDefaultSettings(true);
        _G.combatAnalysisLoaded = true;
      else
        Turbine.Shell.WriteLine(L.FailedToLoadSettingsMessage);
        menuPane:Destroy();
        collectgarbage();
      end
    end);
  else
    _G.combatAnalysisLoaded = true;
  end
end

-- Load Trait Configurations
if (not pcall(LoadTraits)) then
  -- if there is an error loading the traits file, give the user the option to reset immediately
  dialog:ShowConfirmDialog(L.FailedToLoadTraitsResetConfirmation,function(confirm)
    if (confirm) then
      RestoreDefaultTraits(true,true);
      InitializeRunningBuffs();
      LoadSettingsCallback();
    else
      Turbine.Shell.WriteLine(L.FailedToLoadTraitsMessage);
      menuPane:Destroy();
      collectgarbage();
    end
  end);
else
  InitializeRunningBuffs();
  LoadSettingsCallback();
end
