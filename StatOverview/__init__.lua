
--[[

Constructs the UI elements necessary to display the stat
overview information.

Note many of the elements declared here are updated directly
by the combat data class when new info is parsed.

]]--


-- declare global variables (a window set and tab set)
_G.statOverviewEnabled = true;

_G.statOverviewWindows = {}
_G.statOverviewTabs = {}
_G.statOverviewStatsWindows = {}
_G.autoSelectNewEncounters = true;
_G.confirmOnReset = true;

menuPane:SetWindowSet(statOverviewWindows);
menuPane:SetStatsWindowSet(statOverviewStatsWindows);


-- import relevant classes
import "CombatAnalysis.StatOverview.StatOverviewWindow";

import "CombatAnalysis.StatOverview.StatOverviewTabMenu";
import "CombatAnalysis.StatOverview.StatOverviewStatsMenu";
import "CombatAnalysis.StatOverview.StatOverviewChatMenu";
import "CombatAnalysis.StatOverview.StatOverviewTraitConfigMenu";

import "CombatAnalysis.StatOverview.StatOverviewTab";
import "CombatAnalysis.StatOverview.StatOverviewPanel";

import "CombatAnalysis.StatOverview.StatOverviewBarsPanel";
import "CombatAnalysis.StatOverview.StatOverviewBar";

import "CombatAnalysis.StatOverview.StatOverviewStatsWindow";

import "CombatAnalysis.StatOverview.StatOverviewStatsPanel";
import "CombatAnalysis.StatOverview.StatOverviewTreeNode";


-- construct the encounters combo box and the two target combo boxes (mobs and restores)
_G.encountersComboBox = CombatAnalysisComboBox(6,backgroundColor,controlColor,combatData,combatData.maxEncounters,combatData.maxLoadedEncounters);
_G.mobsComboBox = CombatAnalysisComboBox(3,backgroundColor,Turbine.UI.Color(0.9,0.45,0.3),combatData);
_G.restoresComboBox = CombatAnalysisComboBox(3,backgroundColor,Turbine.UI.Color(0.2,0.85,0.65),combatData);

Misc.AddListener(combatData,"maxEncounters",function(sender)
  encountersComboBox:SetMaxElements(combatData.maxEncounters);
end, encountersComboBox, encountersComboBox);

Misc.AddListener(combatData,"maxLoadedEncounters",function(sender)
  encountersComboBox:SetMaxTopElements(combatData.maxLoadedEncounters);
end, encountersComboBox, encountersComboBox);

-- construct a shared stat menu and chat send menu
local tabMenu = StatOverviewTabMenu();
_G.statsMenu = StatOverviewStatsMenu();
_G.chatMenu = StatOverviewChatMenu();

-- construct all the main stats tabs that always exist (and their corresponding panels/stat panels)
_G.dmgTab = StatOverviewTab("dmgTab",L.Dmg,tabMenu,chatMenu,encountersComboBox:GetInstance(1),mobsComboBox:GetInstance(1),nil,false,Turbine.UI.Color(0.4,1,0,0));                                              -- red
_G.takenTab = StatOverviewTab("takenTab",L.Taken,tabMenu,chatMenu,encountersComboBox:GetInstance(2),mobsComboBox:GetInstance(2),nil,false,Turbine.UI.Color(0.4,1,0.446154,0));                                 -- orange
_G.healTab = StatOverviewTab("healTab",L.Heal,tabMenu,chatMenu,encountersComboBox:GetInstance(3),restoresComboBox:GetInstance(1),Turbine.UI.Color(0.4,0.625,0,1),false,Turbine.UI.Color(0.4,0,1,0));           -- green
_G.powerTab = StatOverviewTab("powerTab",L.Power,tabMenu,chatMenu,encountersComboBox:GetInstance(4),restoresComboBox:GetInstance(2),nil,false,Turbine.UI.Color(0.4,0,0,1));                                    -- blue
_G.buffTab = StatOverviewTab("buffTab",L.Buff,tabMenu,chatMenu,encountersComboBox:GetInstance(6),restoresComboBox:GetInstance(3),nil,true,Turbine.UI.Color(0.75,1,1,1),Turbine.UI.Color(0.75,0.78,0.78,0.78)); -- white (as of v4.2.0)
_G.debuffTab = StatOverviewTab("debuffTab",L.Debuff,tabMenu,chatMenu,encountersComboBox:GetInstance(5),mobsComboBox:GetInstance(3),nil,true,Turbine.UI.Color(0.75,0,0,0),Turbine.UI.Color(0.7,0.5,0.5,0.5));   -- black (as of v4.2.0)

-- add the tabs to the menu
menuPane:AddStatOverviewTab(dmgTab);
menuPane:AddStatOverviewTab(takenTab);
menuPane:AddStatOverviewTab(healTab);
menuPane:AddStatOverviewTab(powerTab);
menuPane:AddStatOverviewTab(buffTab);
menuPane:AddStatOverviewTab(debuffTab);

-- additionally, override each tab's GetData methods to ensure they correct the relevant summary data

function _G.dmgTab:GetData(category) return combatData.selectedMob:GetAllPlayerData("dmg"..(category or "")) end
function _G.takenTab:GetData(category) return combatData.selectedMob:GetAllPlayerData("taken"..(category or "")) end
function _G.healTab:GetData(category) return combatData.selectedRestore:GetAllPlayerData("heal"..(category or "")) end
function _G.powerTab:GetData(category) return combatData.selectedRestore:GetAllPlayerData("power"..(category or "")) end
function _G.debuffTab:GetData() return combatData.selectedMob:GetPlayerData(player.name,"debuff",false) end
function _G.buffTab:GetData() return combatData.selectedRestore:GetPlayerData(player.name,"buff",false) end

function _G.dmgTab:GetDataForPlayer(player,includeTotals,category) return combatData.selectedMob:GetPlayerData(player,"dmg"..(category or ""),includeTotals) end
function _G.takenTab:GetDataForPlayer(player,includeTotals,category) return combatData.selectedMob:GetPlayerData(player,"taken"..(category or ""),includeTotals) end
function _G.healTab:GetDataForPlayer(player,includeTotals,category) return combatData.selectedRestore:GetPlayerData(player,"heal"..(category or ""),includeTotals) end
function _G.powerTab:GetDataForPlayer(player,includeTotals,category) return combatData.selectedRestore:GetPlayerData(player,"power"..(category or ""),includeTotals) end
