-- Database for Combat Analysis (Français)
-- Encodage: utf-8 '
-- Version 0.4 du 23 juin 2015

L["DevelopedBy"] = "Developed by Evendale enhanced by Landal";
L["TranslatedBy"] = "Français Mayara(Sirannon), Ardi(Estel)";

L["FailedToLoadTraitsResetConfirmation"] = "Failed to load traits. Reset and continue?".."\n".."Warning: You will lose all your customized buff & debuff configurations.";-- pas de trad
L["FailedToLoadTraitsMessage"] = "It is recommended you unload the plugin now. You can attempt to check your traits file for errors:\n\"Documents\\The_Lord_of_the_Rings_Online\\PluginData\\<UserName>\\<Server>\\<CharacterName>\\CombatAnalysisTraits.plugindata\"";-- pas de trad
L["FailedToLoadSettingsResetConfirmation"] = "Failed to load settings. Reset and continue?".."\n".."Warning: You will lose all your customized options (excluding buff & debuff configurations).";-- pas de trad
L["FailedToLoadSettingsMessage"] = "It is recommended you unload the plugin now. You can attempt to check your settings file for errors:\n\"Documents\\The_Lord_of_the_Rings_Online\\PluginData\\<UserName>\\<Server>\\<CharacterName>\\CombatAnalysis.plugindata\"";-- pas de trad

-- Icon Menu

L["Logo"] = "Logo";
L["LockWindows"] = "Verrouillage de la fenêtre";
L["UnlockWindows"] = "Déverrouillage de la fenêtre";
L["SaveData"] = "Sauvegader";
L["LoadData"] = "Charger";
L["OpenTheMenu"] = "Ouvrir le menu";

-- Menu Headings

L["MenuTitle"] = "Combat Analysis";

L["General"] = "Général";
L["Stats"] = "Stats";
L["Buffs"] = "Buffs";
L["About"] = "A Propos";

-- General Menu

L["GeneralSettingsTitle"] = "Réglages Généraux";
L["AutoSelectNewEncounters"] = "Sélection d'une nouvelle rencontre";
L["ConfirmDialogOnReset"] = "Afficher le dialogue de confirmation pour un Reset";

L["ShowLogo"] = "Afficher le logo de Combat Analysis";

L["MaxStandardEncounters"] = "Nombre max de rencontres";
L["MaxLoadedEncounters"] = "Nombre max de rencontres chargées";

L["TimerConfigurationsTitle"] = "Timer Configurations";-- pas de trad
L["CombatTimeout"] = "Combat Timeout";-- pas de trad
L["TargetTimeout"] = "Target Timeout";-- pas de trad
L["LogDelay"] = "Delais d'enregistrement";
L["EffectDelay"] = "Delais pour les effets";

L["SaveLoadTitle"] = "Sauvegarde/Restauration";
L["AutoSaveData"] = "Sauvegarde automatique des données";
L["Off"] = "Off";
L["SaveOnExit"] = "Sauvegarde en quittant";
L["SaveEncounters"] = "Sauvegarde des rencontres";

-- UI Menu

L["UI"] = "UI";
L["Tabs"] = "Onglets";
L["Windows"] = "Fenêtres";
L["Tab"] = "Onglet";
L["Window"] = "Fenêtre";

L["TabsAndWindowsConfigurationTitle"] = "Configuration des onglets et fenêtres";
L["TabsAndWindowsDescription"] = "> Déplacez l'onglet pour reconfigurer votre UI\n> Déplacez les onglets non utiles dans le buffer sur la droite";

L["TabSettingsTitle"] = "Paramétrage de l'onglet";
L["SelectedTab"] = "Onglet sélectionné";
L["ColorScheme"] = "Palette de couleur";
L["TempMorale"] = "Moral temporaire";
L["AutoSelectPlayer"] = "Sélection automatique du joueur";

L["WindowSettingsTitle"] = "Paramétrage de la fenêtre";
L["SelectedWindow"] = "fenêtre sélectionnée";
L["Background"] = "arrière-plan";
L["XPos"] = "x-pos";
L["YPos"] = "y-pos";
L["Width"] = "Largeur";
L["Height"] = "Hauteur";
L["Minimized"] = "Réduite";
L["CenterOnScreen"] = "Centrer sur l'écran";
L["AutoHideTabs"] = "Cacher au départ de la souris";
L["ShowBackground"] = "Afficher l'arrière-plan et les bords";
L["ShowMiniTitleBar"] = "Afficher les mini-titres";
L["ShowTitleAndDuration"] = "Afficher titre et durée";
L["ShowEncountersList"] = "Afficher la liste des rencontres";
L["ShowTargetsList"] = "Afficher la liste des cibles";
L["ShowExtraButtons"] = "Afficher envoyer vers le Chat et autres boutons";

L["StatsWindowsConfigurationTitle"] = "Configuration des statistiques";
L["StatsWindowsDescription"] = "> Déplacez les panneaux de statistiques pour reconfigurer votre UI\n> Déplacez les panneaux inutiles à droite";

L["StatsWindowSettingsTitle"] = "Paramètres de la fenêtre de statistiques";
L["Visibility"] = "Visibilité";
L["AlwaysShow"] = "Toujours visible";
L["ShowOnHover"] = "Afficher au passage de la souris";
L["ShowOnLock"] = "afficher au verrouillage";

L["ReOrder"] = "réorganiser";
L["InsertTab"] = "Insertion d'un volet";
L["NewWindow"] = "Nouvelle fenêtre";
L["CloseWindow"] = "Fermer fenêtre";

-- Buffs Menu

L["Debuffs"] = "Debuffs";
L["CC"] = "CC";
L["CrowdControl"] = "CC";
L["Bubbles"] = "Bulles";

L["TraitConfigurationsTitle"] = "Configurations des Traits";
L["SelectedConfiguration"] = "Configuration sélectionné";
L["RemoveTraitConfigurationConfirmation"] = "Êtes vous sûr de supprimer cette configuration ?";

L["AddConfiguration"] = "Ajout de Configuration";
L["ConfigurationName"] = "Nom de la Configuration";
L["CopyDebuffsFrom"] = "Copier Debuffs de";
L["None"] = "Aucun";
L["Add"] = "Ajouter";
L["Remove"] = "Supprimer";

L["ConfigurationNameRequired"] = "Un nom de Configuration est obligatoire";
L["ConfigurationNameAlreadyExists"] = "Ce Nom de Configuration existe déjà";
L["ColorSchemeRequired"] = "Une palette de couleur est obligatoire";

L["AddBuff"] = "Ajout des Buff";
L["AddDebuff"] = "Ajout des Debuff";
L["RemoveBuff"] = "Suppression des Buff";
L["RemoveDebuff"] = "Suppression des Debuff";
L["FilterList"] = "Filtres";
L["Remov"] = "Suppression"; -- lowercase (for filtering by removal only debuffs/CC)
L["Class"] = "Classe";

-- { Full Name, Full Name with no spaces, Two Letter Abbreviation}
L["BuffBars"] = {"BuffBars", "BuffBars", "BB"}
L["CombatAnalysis"] = {"Combat Analysis", "CombatAnalysis", "CA"}
L["ConfigureInBuffBars"] = "Configure dans BuffBars";
L["BuffBarsNotLoadedMessage"] = "BuffBars N'est pas charger ou vous utilisez une version non compatible avec Combat Analysis.";

L["RemoverPrefix"] = "Remover";-- pas de trad
L["NameRequiredPrefix"] = "Nom Obligatoire";

L["EffectName"] = "Nom de l'Effet";
L["BuffName"] = "Nom du Buff";
L["DebuffName"] = "Nom du Debuff";
L["IconFileName"] = "Nom de l'icône";
L["RemovalOnly"] = "Suppression seulement";
L["ToggleSkill"] = "Toggle Skill";-- pas de trad
L["Removes"] = "Removes";-- pas de trad
L["ConflictsWith"] = "Conflicts With";-- pas de trad
L["EffectModifiers"] = "Effect Modifiers";-- pas de trad
L["IsStance"] = "Is Stance";-- pas de trad
L["StackingBuffs"] = "Stacking Buffs";-- pas de trad
L["LogName"] = "Nom du Log";
L["AppliedBy"] = "Appliqué Par";
L["CritsOnlyAbbreviation"] = "Crit";
L["DelayAbbreviation"] = "Del";
L["DurationAbbreviation"] = "Dur";

-- About Menu

L["AboutTitle"] = "A propos";
L["VersionNo"] = "Version N°";
L["RestoreSettings"] = "Restauration de la configuration";
L["RestoreSettingsConfirmation"] = "Êtes vous sur de mettre tous les paramètres (A l'exclusion des traits) par défaut?";
L["RestoreTraits"] = "Restauration des Traits";
L["RestoreTraitsConfirmation"] = "Êtes vous sur de mettre tous la configuration des traits par défaut?";-- pas de trad
L["PluginUsageMessage"] = "Pour plus d'information sur l'utilisation de ce plugin, visitez:";
L["FoundABugMessage"] = "Un Bug? Signalez le en laissant un commentaire a l'adresse ci-dessus.";

-- Tooltips

L["AutoSelectTooltip"] = "When Combat Begins, immediately select the new encounter.";
L["ConfirmOnResetTooltip"] = "Show a confirmation dialog when resetting the totals encounter.";
L["ShowLogoTooltip"] = "Show or hide the Combat Analysis Logo that is used to Show/Hide all the other windows or to access the menu.";
L["LockWindowsTooltip"] = "Locks all windows in place so that they cannot be moved, resized, or closed, except through the tab menu or main menu.";
L["MaxEncountersTooltip"] = "Set the number of encounters that can be stored in history.";
L["MaxLoadedEncountersTooltip"] = "Set the number of loaded encounters that can be stored in history.";
L["CombatTimeoutTooltip"] = "Set the grace period after combat ends in which damage is still counted towards this encounter.";
L["TargetTimeoutTooltip"] = "Set the grace period after a mob or player dies in which damage is still counted towards the target. Note this value must be lower than the combat timeout.";
L["LogDelayTooltip"] = "Set the maximum period between when a combat log entry is detected and a matching effect application is detected.";
L["EffectDelayTooltip"] = "Set the maximum period between when an effect application is detected and a matching combat log entry is detected.";
L["AutoSaveTooltip"] = "Configure how data is automatically saved:\na) Data is not saved automatically\nb) All the data (the Totals Encounter) is saved when you log off (or unload the plugin)\nc) Each Encounter is saved as soon as combat ends";

L["SelectedTabTooltip"] = "Select a tab to configure.";
L["ColorSchemeTooltip"] = "Set the color scheme used by this tab.";
L["TempMoraleTooltip"] = "Set the color scheme used by the temp morale details.";
L["AutoSelectPlayerTooltip"] = "For this tab, immediately select the players details when a new encounter is selected.";
L["SelectWindowTooltip"] = "Select a window to configure.";
L["BackgroundTooltip"] = "Set the background color for this window.";
L["WindowTabsTooltip"] = "A list of tabs currently contained in this window.";
L["CenterWindowOnScreenTooltip"] = "Center this window on your screen. This will also maximize the window, and ensure the tabs and background are showing.";
L["AutoHideTabsTooltip"] = "For this window, only show the tabs when the mouse hovers over the window.";
L["ShowBackgroundTooltip"] = "For this window, show or hide the background and borders over the main display area.";
L["ShowMiniTitleBarTooltip"] = "For this window, show or hide the mini title bar (with the menu, minimize, and close icons).";
L["ShowTitleAndDurationTooltip"] = "For this window, show or hide the colored title that shows the selected target and duration.";
L["ShowEncountersListTooltip"] = "For this window, show or hide the encounters drop down list.";
L["ShowTargetsListTooltip"] = "For this window, show or hide the targets drop down list.";
L["ShowExtraButtonsTooltip"] = "For this window, show or hide the Send to Chat and Info buttons.";
L["SelectedWindowTooltip"] = "Select a stats window to configure.";
L["StatsBackgroundTooltip"] = "Set the background color for this stats window.";
L["StatsWindowTabsTooltip"] = "A list of tabs currently contained in this window.";
L["CenterStatsWindowOnScreenTooltip"] = "Center this stats window on your screen. This will also ensure the stats window is showing (Always Show).";
L["VisibilityTooltip"] = "For this stats window, specify whether:\na) the window should always be visible\nb) the window should show when a bar is hovered over or locked in one of the tabs\nc) the window should only show when a bar's details are locked in";

L["SelectedConfigurationTooltip"] = "Select which trait configuration to use and edit below. This only affects the Debuff and Crowd Control information.";
L["AddConfigurationTooltip"] = "Add a new trait Configuration.";
L["RemoveConfigurationTooltip"] = "Remove the selected trait Configuration.";
L["ConfigurationNameTooltip"] = "Specify a name for the trait configuration. This cannot be changed later.";
L["CopyDebuffsFromTooltip"] = "Select an existing trait configuration to copy the initial set of debuffs from.";
L["ConfigurationColorSchemeTooltip"] = "Select a color scheme for the new configuration.";
L["AddNewBuffTooltip"] = "Add a new Buff.";
L["AddNewDebuffTooltip"] = "Add a new Debuff.";
L["RemoveBuffTooltip"] = "Remove this buff/debuff.";
L["BuffsActiveInCombatAnalysisTooltip"] = "Track Buffs in Combat Analysis.";
L["DebuffsActiveInCombatAnalysisTooltip"] = "Track Debuffs in Combat Analysis.";
L["DebuffsActiveInBuffBarsTooltip"] = "Track Debuffs in BuffBars.";
L["MakeDebuffActiveInCombatAnalysisTooltip"] = "Tick to track this debuff in Combat Analysis.";
L["MakeDebuffActiveInBuffBarsTooltip"] = "Tick to track this debuff in BuffBars.";
L["ConfigureInBuffBarsLinkTooltip"] = "Click to go to the BuffBars Menu where you can configure Effect Windows that show debuffs and/or Crowd Control effects that are triggered based on the settings below. Note these correspond to the \"Mob Debuffs\" & \"Mob CC\" trigger types in BuffBars.";
L["ClassTooltip"] = "Specify the class this buff/debuff belongs to.";
L["TempMoraleEffectNameTooltip"] = "Specify the effect name for this temporary morale skill. The name must exactly match the name of the effect.";
L["SkillNameTooltip"] = "Specify a unique name for this buff/debuff. This will appear on the Buff/Debuff tab, and in the effect window in Buffbars if applicable.";
L["IconFileNameTooltip"] = "Specify the file name (including extension) of the icon to be used by this debuff. The icon must be located in the 'CombatAnalysis/Resources/DebuffIcons' folder and should be 16x16 pixels.";
L["RemovalOnlyTooltip"] = "A 'Removal Only' debuff is not tracked, and instead is used just to remove other debuffs.";
L["ToggleSkillTooltip"] = "A 'Toggle Skill' is a skill that is toggled on and lasts indefinitely. These debuffs are assumed to last until the target is killed, combat ends, or a overwriting toggle is reapplied.";
L["RemovesTooltip"] = "A list of debuffs or crowd control skills that will be removed when this debuff is applied.";
L["AddRemoveTooltip"] = "Add a new debuff that will be removed when this debuff is applied.";
L["RemoveRemoveTooltip"] = "Remove the selected debuff from the list of debuffs to be removed when this debuff is applied.";
L["ConflictsWithTooltip"] = "A list of debuffs or crowd control skills that prevent this debuff from being applied if they are active.";
L["AddConflictTooltip"] = "Add a new debuff that conflicts with this debuff.";
L["RemoveConflictTooltip"] = "Remove the selected debuff from the list of conflicting debuffs.";
L["EffectModifiersTooltip"] = "A list of effects that, if active on the player when the debuff itself is activated, extend (or shorten) the debuff's duration.";
L["AddEffectModifierTooltip"] = "Add a new effect that alters this debuff's duration.";
L["RemoveEffectModifierTooltip"] = "Remove the selected effect from the list of effect modifiers.";
L["EffectModifierDurationTooltip"] = "Set the positive or negative increase/decrease in the duration of the debuff if this effect is active when the debuff is activated.";
L["IsStanceTooltip"] = "For skills that are stances, the number of applications are not tracked.";
L["StackingBuffsTooltip"] = "A list of names that will be shown for the buff on successive applications if the buff is still active when reapplied.";
L["AddStackingBuffTooltip"] = "Add a new stacking effect name.";
L["RemoveStackingBuffTooltip"] = "Remove the selected name from the list of stacked effect names.";
L["LogNameTooltip"] = "Specify the name of the combat log entry corresponding to this temporary morale skill that will be used to match a bubble effect with the initiating player. The name must exactly match the name of the skill as it appears in the combat log.";
L["BuffAppliedByTooltip"] = "A list of effect names that trigger the application of this buff. The names must exactly match the names of the effects.";
L["DebuffAppliedByTooltip"] = "A list of combat log skill names that trigger the application of this debuff, and the associated details. The names must exactly match the names of the skills as they appear in the combat log.";
L["AddAppliedByTooltip"] = "Add a new application.";
L["RemoveAppliedByTooltip"] = "Remove the selected application from the list of applications.";
L["CritsOnlyTooltip"] = "When checked, the debuff will only be applied if the skill achieves a Critical or Devastating hit.";
L["DelayTooltip"] = "Set the delay after the application occurs until the skill activates. Note this can be a small negative value to offset a delay before the combat log entry occurs.";
L["DurationTooltip"] = "Set the duration for which the debuff lasts.";

-- Tutorials

L["DoNotShowHintInFuture"] = " Do not show this\n  hint in the future"; -- be sure to include line break and spaces
L["LogoTitle"] = "Utilisation du Logo Combat Analysis";
L["LogoMessage"] = " Clic Gauche sur le logo pour Afficher/Masquer les fenêtres de Combat Analysis. Clic droit pour faire apparaitre l'option de sauvegarde/restauration ou le menu principal.\n\nDéplacez le Logo en pressant 'Control-\\', ou vous pouvez le dévalider a partir du menu.";

-- Colors by { FullName, Single Letter Abbreviation }
L["Yellow"] = {"Jaune", "J"};
L["Red"] = {"Rouge", "R"};
L["Green"] = {"Vert", "v"};
L["Blue"] = {"Bleu", "B"};
L["Alpha"] = {"Alpha", "A"};

-- Commands

L["Options"] = "options";
L["Settings"] = "paramètres";
L["Setup"] = "configuration";
L["ShowCommand"] = "afficher";
L["HideCommand"] = "cacher";
L["ToggleCommand"] = "basculer";
L["SaveCommand"] = "sauver";
L["LoadCommand"] = "charger";
L["LockCommand"] = "verrouiller";
L["UnlockCommand"] = "déverrouiller";
L["ResetCommand"] = "RAZ";
L["LockToggleCommand"] = "lock toggle";

L["CommandUsage"] = "utilisation: /ca "..L.Options.." | "..L.SaveCommand.." | "..L.LoadCommand.." | "..L.ToggleCommand.." | "..L.ShowCommand.." | "..L.HideCommand.." | "..L.LockToggleCommand.." | "..L.LockCommand.." | "..L.UnlockCommand.." | "..L.ResetCommand;

-- Value/Date Formatting

L["Thousand"] = "K";
L["Million"] = "M";
L["Billion"] = "G";
L["Trillion"] = "T";

L["Jan"] = {"Jan","Janvier"};
L["Feb"] = {"Fév","Février"};
L["Mar"] = {"Mar","Mars"};
L["Apr"] = {"Avr","Avril"};
L["May"] = {"Mai","Mai"};
L["Jun"] = {"Jun","Juin"};
L["Jul"] = {"Jul","Juillet"};
L["Aug"] = {"Aou","Aout"};
L["Sep"] = {"Sep","Septembre"};
L["Oct"] = {"Oct","Octobre"};
L["Nov"] = {"Nov","Novembre"};
L["Dec"] = {"Déc","Décembre"};

-- Options

L["ResetTotalsMessage"] = "Êtes vous sûr de vouloir réinitialiser le cumulatif?";
L["Yes"] = "Oui";
L["No"] = "Non";
L["OK"] = "OK";

-- Classes

L["Burglar"] = {"Cambrioleur","CAM"};
L["Captain"] = {"Capitaine","CAP"};
L["Champion"] = {"Champion","CHN"};
L["Guardian"] = {"Gardien","GRD"};
L["Hunter"] = {"Chasseur","CHS"};
L["LoreMaster"] = {"Maitre de Savoir","MDS"};
L["Minstrel"] = {"Ménestrel","MNS"};
L["RuneKeeper"] = {"Gardien des Runes","GDR"};
L["Warden"] = {"Sentinelle","SEN"};
L["Beorning"] = {"Béornide","BRN"};

L["BlackArrow"] = {"Black Arrow","BLA"};
L["Defiler"] = {"Defiler","DEF"};
L["Reaver"] = {"Reaver","RVR"};
L["Stalker"] = {"Stalker","STK"};
L["WarLeader"] = {"WarLeader","WAR"};
L["Weaver"] = {"Weaver","WVR"};

L["Racial"] = {"Race","RCL"};
L["Item"] = {"Objet","OBJ"};
L["OtherClass"] = {"Autre","UNK"};

-- Select File Dialog

L["Select"] = "Sélectionner";
L["Save"] = "Sauvegarder";
L["Saves"] = "Sauvegardes";
L["Load"] = "Charger";
L["Loads"] = "Loads"; -- ?
L["Cancel"] = "Annuler";

L["FileName"] = "Nom du ficher";

L["SelectAll"] = "Sélectionner tout";
L["ClearAll"] = "Dé-sélectionner tout";

L["Delete"] = "Effacer";

L["AreYouSureYouWantToDeleteMessage"] = "Êtes-vous sûr de vouloir supprimer\nle(s) fichier(s) sélectionné(s)?";

L["Encounters"] = "Rencontres";
L["Items"] = "Objets";
L["CombineWith"] = "Combiner Avec";
L["CombineInto"] = "Combiner Dans";

L["SelectCurrentDataToCombineWith"] = "Combiner les données chargées avec les données actuelles";
L["LoadDataAsTotalsEncounter"] = "Remplacer le cumulatif avec les données chargées";

L["SelectSaveFile"] = "Choisir une sauvegarde";
L["SelectFileToLoad"] = "Choisir le fichier à charger";
L["SelectDataToSave"] = "Choisir le fichier à sauvegarder";
L["SelectDataToCombineWith"] = "Combiner avec";

L["TooLong"] = "Vous ne pouvez entrer qu'un maximum de 64 caractères.";
L["IllegalCharacters"] = "Vous ne pouvez entrer que des lettres, des chiffres, des espaces et des soulignés.";

L["NoDataMessage"] = "Il n\'y a actuellement aucune données à enregistrer.";
L["NoFileMessage"] = "Pas de fichier spécifié.";
L["NoDataSelectedMessage"] = "Aucune donnée n'a été sélectionnée.";
L["OverwriteFileMessage"] = "Le fichier existe déjà. Voulez-vous combiner les données enregistrées avec ce fichier ou les remplacer?";
L["CombineOrSeparateMessage"] = "Vous avez sélectionné plusieurs fichiers. Voulez-vous combiner les données ou les charger séparément?";
L["TooManyCharactersMessage"] = "Le nom de fichier spécifié est trop long(longueur maximale = 64 caractères)";
L["InvalidCharactersMessage"] = "Le nom de fichier spécifié contient des caractères non valides..";
L["FileNotFoundMessage"] = "L'un des fichiers spécifié n'a pu être trouvée.";
L["SaveFailedMessage"] = "Échec de la sauvegarde: ";
L["LoadFailedMessage"] = "Échec du chargement: ";
L["CombineMessage"] = "Êtes-vous sûr de vouloir combiner les fichiers sélectionnés?";
L["LoadBeforeSaveMessage"] = "L'un des fichiers sélectionné est actuellement utilisé et ne peut donc pas être encore chargé. Essayez à nouveau dans environ 10-15 secondes."

L["Combine"] = "Combiner";
L["Combines"] = "Combines";
L["Overwrite"] = "Remplacer";
L["Combined"] = "Combiné";
L["Separate"] = "Séparer";

-- Encounter Default Names

L["Totals"] = "Cumulatif";
L["Encounter"] = "Rencontre";
L["CurrentEncounter"] = "Rencontre actuelle";
L["CompletedEncounter"] = "Rencontre terminée";

-- Right Click Menu

L["RestoreTab"] = "Restaurer l'onglet";
L["CloseTab"] = "Fermer l'onglet";

L["ResetTotals"] = "Réinitialiser le cumulatif";

-- Chat Menu (indexed by {command, channel name})

L["Say"] = {"parler","Parler"};
-- L["Fellowship"] = {"comm","Communauté"};
L["Fellowship"] = {"f","CommunautÃ©"};
L["Raid"] = {"ra","Raid"};
-- L["Kinship"] = {"conf","Confrérie"};
L["Kinship"] = {"k","ConfrÃ©rie"};
-- L["Tribe"] = {"conf","Tribu"};
L["Tribe"] = {"k","Tribu"};
L["Gap"] = "------------------";

-- Other

L["AllPlayers"] = "Tous les joueurs";
L["AllSkills"] = "Compétences (tous)";
L["Duration"] = "Durée";
L["SendToChat"] = "Envoi vers le Chat";
L["CombatAnalysisSummary"] = "Résumé de Combat Analysis";

L["DirectDamage"] = "Dégât direct";

L["MinutesAbbr"] = "m";
L["SecondsAbbr"] = "s";

L["Daze"] = "Hébété";
L["Root"] = "Enraciné";
L["Fear"] = "Peur";
L["Stun"] = "Assommé";
L["Knockdown"] = "renversé";

-- Statistics Headings

L["AllData"] = "Données (Tous)";
L["NonCrits"] = "on critique";
L["Criticals"] = "Critique";
L["Devastates"] = "Dévastateur";
L["CritsAndDevs"] = "Crit & Dévast";
L["Partials"] = "Evite partiel";

L["Total"] = "Total";
L["Average"] = "Moyenne";
L["Maximum"] = "Maximum";
L["Minimum"] = "Minimum";

--- Added in v4.4.7 to support Normal Hits
L["NormalHits"] = "Coup Ordinaire";
L["NormalHitChance"] = "Coup de Chance";
L["NormalHitAvg"] = "Coup Moyenne";
L["NormalHitMax"] = "Max Hit"
L["NormalHitMin"] = "Min Hit"

--- Added in v4.4.7 to support Critical Hits
L["CriticalHits"] = "Coup Critique";
L["CriticalHitChance"] = "Coup de Chance";
L["CriticalHitAvg"] = "Coup Moyenne";
L["CriticalHitMax"] = "Max Hit"
L["CriticalHitMin"] = "Min Hit"

--- Added in v4.4.7 to support Devastate Hits
L["DevastateHits"] = "Coup D�vaster";    
L["DevastateHitChance"] = "Coup de Chance";
L["DevastateHitAvg"] = "Coup Moyenne";
L["DevastateHitMax"] = "Max Hit"       
L["DevastateHitMin"] = "Min Hit"

L["Avoidance"] = "Évitement";
L["Attacks"] = "Attaque";
L["Hits"] = "Coups Réussis";
L["Absorbs"] = "Coups Absorbés";
L["Misses"] = "Coups Ratés";
L["Deflects"] = "Coups Reflétés";
L["Immune"] = "Immunisé";
L["Resists"] = "Résisté";
L["PhysicalAvoids"] = "Évitement Physique";
L["FullAvoids"] = "Évitement Complet";
L["PartialAvoids"] = "Évitement Partiel";
L["Avoids"] = "Évité";
L["Blocks"] = "Bloqué";
L["Parrys"] = "Parré";
L["Evades"] = "Esquivé";
L["PartialBlocks"] = "Blocage Partiel";
L["PartialParrys"] = "Parade Partielle";
L["PartialEvades"] = "Esquive Partielle";

L["Other"] = "Autre";
L["Interrupts"] = "Interruption";
L["CorruptionsRemoved"] = "Corruptions";

L["DmgTypes"] = "Type des dégâts";

L["TempMorale"] = "Moral temporaire";
L["RegularHeals"] = "Soins normaux";
L["TempHeals"] = "Soins temporaires";
L["WastedTempHeals"] = "Soins perdus";

-- Note the following elements are indexed by: {Short Name, Full Name, Per Second Abbreviation, Tab Title, Tab Tooltip}

L["Dmg"] = {"Off","Dégâts Infligés","DPS","Dégâts Infligés","Onglet des Dégâts Infligés"}
L["Taken"] = {"Def","Dégâts Reçus","TPS","Dégâts Reçus","Onglet des Dégâts Reçus"}
L["Heal"] = {"Soin","Soin","HPS","Soins","Onglet des Soins Reçus et Prodigués"}
L["Power"] = {"Puis","Puissance","PPS","Puissance","Onglet sur la Puissance Reçue et Absorbée"}

L["Debuff"] = {"Debuff","Debuff","Debuff","Onglet des Debuffs","Onglet sur la durée des Debuffs"}
L["Buff"] = {"Buff","Buff","Buff","Onglet des Buffs","Onglet sur la durée des Buffs"}

L["Death"] = {"Mort","Mort"}
L["Corruption"] = {"Corruption","Corruption Retirée"}
L["Interrupt"] = {"Interruption","Interruption"}
L["CombatEntered"] = {"Début Combat","Début du Combat"}
L["CombatExited"] = {"Fin Combat","Fin du Combat"}


L["AvoidanceEnum"] = {{"Aucun","Aucun"},{"Raté","Raté"},{"Immunisé","Immunisé"},{"Résiste","Résiste"},
                      {"Bloqué","Bloqué"},{"Paré","Paré"},{"Esquivé","Esquivé"},
                      {"Bloqué-P","Bloqué partiellement"},{"Paré-P","Paré partiellement"},{"Esquivé-P","Esquivé partiellement"},
                      {"Deflect", "Deflect"}}

L["CriticalEnum"] = {{"Aucun","Aucun"},{"Critique","Coups Critique"},{"Dévastateur","Coups Dévastateur"}}

L["DmgTypeEnum"] = {
	{"Commun", "Commun"},
	{"Feu", "Feu"},
	{"Foudre", "Foudre"},
	{"Froid", "Froid"},
	{"Acide", "Acide"},
	{"Ombre", "Ombre"},
	{"Lumiére", "Lumiére"},
	{"Bele", "Beleriand"},
	{"Ouist", "Ouistrenesse"},
	{"Nain", "Nain d\'antan"},
	{"FW","Fell-wrought"},
	{"Aucun", "Aucun"}
};
					
L["MoralePower"] = {{"Moral","Moral"},{"Puissance","Puissance"},{"Aucun","Aucun"}}




--[[

The complete parsing function. Since the order of text in the combat log is likely to differ in
different languages, this entire function is included  in the localization class.

The function is given an input line from the combat log, and parses that line to determine its meaning.
The final step in each section is to return the extracted values. These lines need not be updated, but
the correct info must be extracted into the relevant fields.

Note the use of numeric values for avoids, critical hits, dmg types, and morale/power. These numbers
correspond to the orderings in the four lists directly above this comment block.

You will need to know something about lua pattern matching and/or regex's to attempt to translate this
section. See http://www.lua.org/pil/20.2.html for more details.

]]--

-- Renvoie un nom sans les articles
local function trim_articles(name)
	if (name == nil) then
		return nil;
	end

	-- Articles possibles: Mayara, LeMayara, Le Mayara, LaMayara, La Mayara, L' Mayara, L’Mayara, et peut être d'autres?
	return string.gsub(name, "^[Ll].-(%u)", "%1");
end


L["Parse"] = function(line)

	-- 1) Damage line ---
	
	local initiatorName,avoidAndCrit,skillName,targetName,amount,dmgType,moralePower = string.match(line,"^(.*) a infligé un coup (.*)avec (.*) sur (.*) pour ([%d,]*) points de type (.*) à l'entité ?(.*)%.$"); -- (updated in v4.1.0)
	
	if (initiatorName ~= nil) then
		
		local avoidType =
			string.match(avoidAndCrit,"partiellement bloqué") and 8 or
			string.match(avoidAndCrit,"partiellement paré") and 9 or
			string.match(avoidAndCrit,"partiellement esquivé ") and 10 or 
			1;
		local critType =
			string.match(avoidAndCrit,"critique") and 2 or
			string.match(avoidAndCrit,"dévastateur") and 3 or 1;
			
		-- skillName = string.match(skillName,"^ avec (.*)$") or L.DirectDamage; -- (as of v4.1.0)

    if (printDebug) then
       Turbine.Shell.WriteLine( "damage by "..initiatorName.." skill "..skillName );
    end		
		-- damage was absorbed
		if targetName == nil then
			targetName = string.gsub(targetNameAmountAndType,"^[Tt]he ","");
			amount = 0;
			dmgType = 12;
			moralePower = 3;
		-- some damage was dealt
		else
			amount = string.gsub(amount,",","")+0;
      
---			dmgType = string.match(dmgType, "^%(.*%) (.*)$") or dmgType; -- 4.2.3 adjust for mounted combat
			-- note there may be no damage type
			dmgType = 
				dmgType == "Commun" and 1 or
				dmgType == "Feu" and 2 or
				dmgType == "Foudre" and 3 or
				dmgType == "Froid" and 4 or
				dmgType == "Acide" and 5 or
				dmgType == "Ombre" and 6 or
				dmgType == "Lumière" and 7 or
				dmgType == "Beleriand" and 8 or
				dmgType == "Ouistrenesse" and 9 or
				dmgType == "de nain d'antan" and 10 or 
				dmgType == "Orc" and 11 or
				dmgType == "Fell-wrought" and 12 or 13;
			moralePower = (moralePower == "Morale" and 1 or moralePower == "Puissance" and 2 or 3);
		end
		
		-- Currently ignores damage to power
		if (moralePower == 2) then return nil end
		
		-- Update
		return 1,trim_articles(initiatorName),trim_articles(targetName),skillName,amount,avoidType,critType,dmgType;
	end
	
	-- 2) Heal line --
	--     (note the distinction with which self heals are now handled)
	--     (note we consider the case of heals of zero magnitude, even though they presumably never occur)
	
	--	[slfHeal] Arc du Juste a appliqué un soin critique à Ardichas, redonnant 52 points à l'entité Puissance.
	--  [slfHeal] Esprit de soliloque a appliqué un soin critique à Yogimen, redonnant 228 points à l'entité Moral.
	--  [Heal]    Eleria a appliqué un soin avec Paroles de guérison Ardicapde, redonnant 227 points à Moral.
	initiator_name, match = string.match(line, '^(.*) a appliqu\195\169 un soin (.*)%.$');

	if (initiator_name ~= nil) then
			crit_type =
				string.match(match, 'critique') and 2 or
				string.match(match, 'dévastateur') and 3 or
				1;
			match = string.gsub(match, '^critique ', '');
			match = string.gsub(match, '^dévastateur ', '');

		local self_heal = (string.match(match, '^\195\160 ') and true or false);

		-- Soins personnels (Self heal)
		if (self_heal) then
			skill_name = initiator_name;
			target_name, dmg_amount, morale_power = string.match(match, '^\195\160 (.*), redonnant ([%d,]*) points? \195\160 l\'entit\195\169 ?(.*)$');
			initiator_name = target_name;

		-- Soins sur une cible (Heal applied)
		else
			skill_name, target_name, dmg_amount, morale_power = string.match(match, '^avec (.*) ([^%s]+), redonnant ([%d,]*) points? \195\160 ?(.*)$');
		end

		morale_power = (morale_power == 'Moral' and 1 or (morale_power == 'Puissance' and 2 or 3));
		dmg_amount = (morale_power == 3 and 0 or string.gsub(dmg_amount, ',', '') + 0);

		return (morale_power == 2 and 4 or 3), trim_articles(initiator_name), trim_articles(target_name), skill_name, dmg_amount, crit_type;
	end
	
	-- 3) Buff line --
	-- MarieChantal a appliqué un bénéfice avec Paroles de guérison Eleria.

	local initiatorName,skillName,targetName = string.match(line,"^(.*) a appliqué un bénéfice avec (.*) (.*)%.$");
	
	if (initiatorName ~= nil) then
		
		-- Update
		return 17,trim_articles(initiatorName),trim_articles(targetName),skillName;
	end
	
	-- 4) Avoid line --
	-- L' Profanateur ghâshfra vigoureux a essayé d'utiliser une attaque de lancer faible sur MarieChantal mais a esquivé la tentative.
	-- L' Berserker hante-jours a essayé d'utiliser une double attaque au corps à corps sur Eleria mais elle a paré la tentative.
	-- L' Archer corsaire a essayé d'utiliser une attaque au corps à corps faible sur Cashel mais il a paré la tentative.
	-- Ardichas a essayé d'utiliser Tir pénétrant amélioré : Brûlure sur le Trompeur immonde vigoureux mais il a esquivé la tentative.

	-- 4a) Évitements complets (Full avoids)
	local initiator_name, skill_name, target_name, avoidType = string.match(line, "^(.*) a essayé d'utiliser (.*) sur (.*) mais (.*) la tentative%.$");

	if (initiator_name ~= nil) then
		avoid_Type =
			string.match(avoidType,"bloqué") and 5 or
			string.match(avoidType,"paré") and 6 or
			string.match(avoidType,"esquivé") and 7 or
			string.match(avoidType,"résisté") and 4 or
			string.match(avoidType,"immunisé contre") and 3 or 1;

		if (avoid_type == 1) then
			return nil;
		end
		return 1, trim_articles(initiator_name), trim_articles(target_name), skill_name, 0, avoid_Type, 1, 10;
	end
	
	-- 4b) miss or deflect (deflect added in v4.2.2)
	-- La Berserker hante-jours n'a pas réussi à utiliser une frappe de taille faible sur la Eleria.
	local initiator_name, skill_name, target_name = string.match(line, "^(.*) n'a pas réussi à utiliser (.*) sur (.*)%.$");

	if (initiator_name ~= nil) then
		avoid_type = 2;

		return 1, trim_articles(initiator_name), trim_articles(target_name), skill_name, 0, avoid_type, 1, 10;
	end
	
	-- 5) Reflect line --
	-- Norchador a renvoyé 210 Ombre de dégâts au Moral de la Eleria.
	-- Le Sangsue gardienne a renvoyé 339 points redonnés au Moral de Eleria.
	local initiatorName,amount,dmgType,targetName = string.match(line,"^(.*) a renvoyé ([%d,]*) (.*) au Moral de (.*)%.$");
	
	if (initiatorName ~= nil) then
		local skillName = "Reflect";
		amount = string.gsub(amount,",","")+0;
		
		local dmgType = string.match(dmgType,"^(.*)de dégâts$");
		-- a damage reflect
		if (dmgType ~= nil) then
			dmgType = 
				dmgType == "Commun" and 1 or
				dmgType == "Feu" and 2 or
				dmgType == "Foudre" and 3 or
				dmgType == "Froid" and 4 or
				dmgType == "Acide" and 5 or
				dmgType == "Ombre" and 6 or
				dmgType == "Lumière" and 7 or
				dmgType == "Beleriand" and 8 or
				dmgType == "Ouistrenesse" and 9 or
				dmgType == "Nain d'antan" and 10 or 11;
						
			-- Update
			return 1,trim_articles(initiatorName),trim_articles(targetName),skillName,amount,1,1,dmgType;
		-- a heal reflect
		else
			-- Update
			return 3,trim_articles(initiatorName),trim_articles(targetName),skillName,amount,1;
		end
	end
	
	-- 6) Temporary Morale bubble line (as of 4.1.0)
  local amount = string.match(line,"^Vous avez perdu ([%d,]*) points de Moral temporaire !$");
	if (amount ~= nil) then
		amount = string.gsub(amount,",","")+0;
		
		-- the only information we can extract directly is the target and amount
		return 14,nil,trim_articles(player.name),nil,amount;
	end
	
	-- 7) Combat State Break notice (as of 4.1.0)
	
	-- 7a) Root broken
	initiator_name, target_name = string.match(line, "^(.*) délivrée? ?(.*) de l'immobilisation\194\160!$");

	if (initiator_name ~= nil) then
		initiator_name =
			string.match(initiator_name, "^Vous avez") and player.name or
			string.match(initiator_name, " vous a$") and string.gsub(initiator_name, " vous a$", "") or
			string.gsub(initiator_name, " a$", "");
		target_name = (target_name == "" and player.name or target_name);

		if (printDebug) then
  		Turbine.Shell.WriteLine("root_broken", line, "ini_name: " .. initiator_name .. " tgt_name: " .. target_name);
		end

		return 16, nil, trim_articles(target_name), nil;
	end
	
	-- 7b) Daze broken
	initiator_name, target_name = string.match(line, "^(.*) délivrée? ?(.*) de l'hébétement\194\160!$");

	if (initiator_name ~= nil) then
		initiator_name =
			string.match(initiator_name, "^Vous avez") and player.name or
			string.match(initiator_name, " vous a$") and string.gsub(initiator_name, " vous a$", "") or
			string.gsub(initiator_name, " a$", "");
		target_name = (target_name == "" and player.name or target_name);

		if (printDebug) then
		  Turbine.Shell.WriteLine("daze_broken", line, "ini_name: " .. initiator_name .. " tgt_name: " .. target_name);
		end

		return 16, nil, target_name, nil;
	end
	
	-- 8) Interrupt line --
	
	local target_name, initiator_name = string.match(line, "^(.*) a été interrompu par (.*)!$");

	if (target_name ~= nil) then
		return 7, trim_articles(initiator_name), trim_articles(target_name);
	end
	
	-- 9) Dispell line (corruption removal) --
	
	local corruption, target_name = string.match(line, "Vous avez dissipé l'effet (.*) affectant (.*)%.$");

	if (corruption ~= nil) then
		initiator_name = player.name;
		-- NB: Currently ignore corruption name
		
		-- Update
		return 8, trim_articles(initiator_name), trim_articles(target_name);
	end
	
	-- 10) Defeat lines ---
	
	-- 10a) Defeat line 1 (mob or played was killed)
	initiator_name = string.match(line, "^.* a vaincu (.*)%.$");

	if (initiator_name ~= nil) then

	-- Update
		return 9, trim_articles(initiator_name);
	end

	-- 10b) Defeat line 2 (mob died)
	initiator_name = string.match(line, "^(.*) meurt%.$");

	if (initiator_name ~= nil) then
		
		-- Update
		return 9, trim_articles(initiator_name);
	end

	-- 10c) Defeat line 3 (a player was killed or died)
	initiator_name = string.match(line, "^(.*) a péri%.$");

	if (initiator_name ~= nil) then
		
		-- Update
		return 9, trim_articles(initiator_name);
	end

	-- 10d) Defeat line 4 (you were killed)
	match = string.match(line, "^.* a réussi à vous mettre hors de combat%.$");

	if (match ~= nil) then
		
		-- Update
		return 9, trim_articles(player.name);
	end

	-- 10e) Defeat line 5 (you died)
	match = string.match(line, "^Un incident vous a réduit à l'impuissance%.$");

	if (match ~= nil) then
		
		-- Update
		return 9, trim_articles(player.name);
	end	
	-- 10f) Defeat line 6 (you killed a mob)
	local initiatorName = string.match(line,"^Votre coup puissant a vaincu (.*)%.$");
	
	if (initiatorName ~= nil) then
		
		-- Update
		return 9,trim_articles(initiatorName);
	end
	
	-- 11) Revive lines --
	
	-- 11a) Revive line 1 (player revived)
	local initiatorName = string.match(line,"^(.*) revient à la vie%.$");
	
	if (initiatorName ~= nil) then
	  
		-- Update
	  return 10,trim_articles(initiatorName);
	end
	
	-- 11b) Revive line 2 (player succumbed)
	local initiatorName = string.match(line,"^(.*) a succombé à ses blessures%.$");
	
	if (initiatorName ~= nil) then
	  
		-- Update
	  return 10,trim_articles(initiatorName);
	end
	
	-- 11c) Revive line 3 (you were revived)
	local match = string.match(line,"^Vous revenez à la vie%.$");
	
	if (match ~= nil) then
	  initiatorName = player.name;
	  
		-- Update
	  return 10,initiatorName;
	end
	
	-- 11d) Revive line 4 (you succumbed)
	local match = string.match(line,"^You succumb to your wounds%.$");
	
	if (match ~= nil) then
	  initiatorName = player.name;
	  
		-- Update
	  return 10,initiatorName;
	end
	
	-- if we reach here, we were unable to parse the line
	--  (note there is very little that isn't parsed)
end



--[[
	
	Skill Names (for Temporary Morale & Buff/Debuff tracking)
	
	> Temporary Morale Skill Names need specify both how the skill name appears in the combat log, as
	    well as how it appears on the effect tooltip.
	
	> Buff Names must match exactly how the name of a skill appears in the effect tooltip.
	> Benefit/Debuff/Crowd-Control Names must match exactly how the name of a skill appears in the combat log.
	
--]]

L["Default"] = "Default";

-- 0) Temporary Morale Skills {combat log name, effect name}

-- Champion
L["TrueHeroicsEffect"] = "True Heroics";
L["TrueHeroicsLog"] = "True Heroics";
L["SuddenDefenceEffect"] = "Sudden Defence";
L["SuddenDefenceLog"] = "Sudden Defence";
-- Minstrel
L["StoryOfTheHammerhandEffect"] = "Histoire du Poing de Marteau";
L["StoryOfTheHammerhandLog"] = "Histoire of the Hammerhand";
L["SongOfTheHammerhandEffect"] = "Chant du Poing de Marteau";
L["SongOfTheHammerhandLog"] = "Chant du Poing de Marteau";
L["GiftOfTheHammerhandEffect"] = "Don du Poing de Marteau";
L["GiftOfTheHammerhandLog"] = "Don du Poing de Marteau";
-- Rune-Keeper
L["WordOfExaltationEffect"] = "Word of Exaltation";
L["WordOfExaltationLog"] = "Word of Exaltation";
L["EssayOfExaltationEffect"] = "Essay of Exaltation";
L["EssayOfExaltationLog"] = "Word of Exaltation";
-- Other
L["MartyrsFortitudeEffect"] = "Martyr's Fortitude";
L["MartyrsFortitudeLog"] = "Martyr's Fortitude";
L["FrostRingEffect"] = "Ring of Frost";
L["FrostRingLog"] = "Shield of the Blizzard";

-- 1) Burglar Skills

-- Buffs (effect name)
L["TouchAndGo"] = "Touch and Go";
L["KnivesOut"] = "Knives Out";
L["Mischievous"] = "Mischievous";
L["QuietKnife"] = "Quiet Knife";
L["Gambler"] = "Gambler";
L["TheMischiefMaker"] = "The Mischief-maker"; -- same as stance name
L["TheQuietKnife"] = "The Quiet Knife"; -- same as stance name
L["TheGambler"] = "The Gambler"; -- same as stance name
L["Feint"] = "Feint";
L["ImprovedFeint"] = "Improved Feint";
L["ArmourOfTheUnseen"] = "Armour of the Unseen";
-- Debuffs (log name)
L["RevealWeakness"] = "Reveal Weakness";
L["Addle"] = "Addle";
L["TrickDisable"] = "Trick: Disable";
L["TrickCounterDefence"] = "Trick: Counter Defence";
L["TrickImprovedCounterDefence"] = "Trick: Improved Counter Defence";
L["TrickDustInTheEyes"] = "Trick: Dust in the Eyes";
L["Slowed"] = "Slowed";
L["TrickEnrage"] = "Trick: Enrage";
L["ASmallSnag"] = "A Small Snag";
L["QuiteASnag"] = "Quite a Snag";
-- Removals (log name)
L["MischievousDelight"] = "Mischievous Delight";
L["MischievousGlee"] = "Mischievous Glee";
-- Crowd Control (log name)
L["Riddle"] = "Riddle";
L["ImprovedRiddle"] = "Improved Riddle";
L["Confound"] = "Confound";
L["StartlingTwist"] = "Startling Twist";
L["ImprovedStartlingTwist"] = "Improved Startling Twist";
L["AdvancedStartlingTwist"] = "Advanced Startling Twist";
L["StunDustTier1"] = "Stun Dust Tier 1";
L["StunDustTier2"] = "Stun Dust Tier 2";
L["StunDustTier3"] = "Stun Dust Tier 3";
L["ExploitOpening"] = "Exploit Opening";
L["Trip"] = "Trip";
L["MarblesTier1"] = "Marbles Tier 1";
L["MarblesTier2"] = "Marbles Tier 2";
L["MarblesTier3"] = "Marbles Tier 3";

-- 2) Captain Skills

-- Trait Lines
L["LeadTheCharge"] = "A la charge!";
L["LeaderOfMen"] = "Meneur d'hommes";
L["HandsOfHealing"] = "Mains Guérisseuses";
-- Buffs (effect name)
L["MusterCourage"] = "Rassemblement du courage";
L["InHarmsWay"] = "In Harm's Way";
L["WarCry"] = "War-cry";
L["BladeOfElendil"] = "Lame d'Elendil";
L["Motivated"] = "Motivation";
L["OnGuard"] = "En garde";
L["RelentlessAttack"] = "Relentless Attack";
L["Focus"] = "Focus";
L["ShieldBrother"] = "Frère de bouclier";
L["WatchfulShieldBrother"] = "Frère de bouclier vigilant";
L["SongBrother"] = "Frère de chants";
L["BladeBrother"] = "Frère d'armes";
L["ShieldOfTheDunedain"] = "Bouclier des D\195\186nedain";
L["ToArmsShieldBrother"] = "Aux armes! (Frère de bouclier)";
L["ToArmsFellowshipShieldBrother"] = "Aux armes! (Frère de bouclier communauté)";
L["ToArmsSongBrother"] = "Aux armes! (Frère de chants)";
L["ToArmsFellowshipSongBrother"] = "Aux armes! (Frère de chants communauté)";
L["ToArmsBladeBrother"] = "Aux armes! (Frère d'armes)";
L["ToArmsFellowshipBladeBrother"] = "Aux armes! (Frère d'armes communauté)";
L["StrengthOfWillShieldBrother"] = "Inspiration (Frère de bouclier)";
L["StrengthOfWillFellowshipShieldBrother"] = "Inspiration (Frère de bouclier communauté)";
L["StrengthOfWillSongBrother"] = "Inspiration (Frère de chants)";
L["StrengthOfWillFellowshipSongBrother"] = "Inspiration (FFrère de chants communauté)";
L["StrengthOfWillBladeBrother"] = "Inspiration (Frère d'armes)";
L["StrengthOfWillFellowshipBladeBrother"] = "Inspiration (Frère d'armes communauté)";
L["RallyingCry"] = "Cri de ralliement";
L["InDefenceOfMiddleEarth"] = "A la défense de la Terre du Milieu";
L["DefensiveStrike"] = "Defensive Strike";
L["ImprovedDefensiveStrike"] = "Improved Defensive Strike";
L["LastStand"] = "Dernier combat";
-- Debuffs (log name)
L["NobleMark"] = "Marque de noblesse";
L["TellingMark"] = "Marque efficace";
L["RevealingMark"] = "Marque révélatrice";

-- 3) Champion Skills

-- Trait Lines
L["TheBerserker"] = "The Berserker";
L["TheDeadlyStorm"] = "The Deadly Storm";
L["TheMartialChampion"] = "The Martial Champion";
-- Buffs (effect name)
L["Fervour"] = "Ferveur";
L["Glory"] = "Gloire";
L["Ardour"] = "Ardeur";
L["ControlledBurn"] = "Controlled Burn";
L["Flurry"] = "Flurry";
L["SuddenDefence"] = "Sudden Defence";
L["SeekingBlades"] = "Seeking Blades";
L["Adamant"] = "Adamant";
L["Invincible"] = "Invincible";
-- Hamstring (log name)
L["Hamstring"] = "Hamstring";
-- Crowd Control (log name)
L["HornOfGondor"] = "Cor du Gondor";
L["Horn"] = "cor";
-- Benefits (log name)
L["EbbingIre"] = "Ebbing Ire";
L["RisingIre"] = "Rising Ire";

-- 4) Guardian Skills

-- Trait lines
L["TheKeenBlade"] = "The Keen Blade";
L["TheFighterOfShadow"] = "The Fighter of Shadow";
L["TheDefenderOfTheFree"] = "The Defender of the Free";
-- Buffs (effect name)
L["Protection"] = "Protection";
L["ProtectionByTheSword"] = "Protection by the Sword";
L["ShieldWall"] = "Shield Wall";
L["GuardiansBlockStance"] = "Guardian's Block Stance";
L["GuardiansParryStance"] = "Guardian's Parry Stance";
L["Overpower"] = "Overpower";
L["GuardiansThreatStance"] = "Guardian's Threat Stance";
L["GuardiansPledge"] = "Guardian's Pledge";
L["GuardiansWard"] = "Guardian's Ward";
L["ImprovedGuardiansWard"] = "Improved Guardian's Ward";
L["GuardiansWardTactics"] = "Guardian's Ward Tactics";
L["ImprovedGuardiansWardTactics"] = "Improved Guardian's Ward Tactics";
L["WarriorsBlock"] = "Warrior's Block";
L["WarriorsParry"] = "Warrior's Parry";
L["WarriorsPower"] = "Warrior's Power";
L["WarriorsThreat"] = "Warrior's Threat";
-- Debuffs (log name)
L["Bash"] = "Bash";
L["ShieldSmash"] = "Shield-smash";
L["ToTheKing"] = "To the King";
L["Challenge"] = "Challenge";
L["ImprovedChallenge"] = "Improved Challenge";
L["ChallengeTheDarkness"] = "Challenge the Darkness";
L["ImprovedOverwhelm"] = "Improved Overwhelm";
L["ImprovedSting"] = "Improved Sting";
L["ImminentCleansing"] = "Imminent Cleansing";

-- 5) Hunter Skills

-- Trait lines
L["TheBowmaster"] = "Maître archer";
L["TheTrapperOfFoes"] = "Piégeur d'ennemis";
L["TheHuntsman"] = "Flèche Sylvaine";
-- Buffs (effect name)
L["StanceStrength"] = "Posture: force";
L["StancePrecision"] = "Posture: précision";
L["StanceEndurance"] = "Posture: endurance";
L["BurnHot"] = "Vive flamme";
L["CoolBurn"] = "Cool Burn";
L["Fleetness"] = "Célérité";
L["ImprovedFleetness"] = "Célérité améliorée";
L["SwiftStroke"] = "Décochage rapide";
L["NeedfulHaste"] = "Hâte nécessaire";
L["HuntersArt"] = "Hunter's Art";-- Always exist ????
-- Debuffs (log name)
L["QuickShot"] = "Tir rapide";
L["LowCut"] = "Coups au jambes";
L["CripplingShot"] = "Crippling Shot";
L["SlowingCut"] = "Slowing Cut";
-- Crowd Control (log name)
L["DazingBlow"] = "Coups d'hébétement";
L["ImprovedDazingBlow"] = "Coups d'hébètement amélioré";
L["DistractingShot"] = "Tir de distraction";
L["RainOfThorns"] = "Pluie d'épines";
L["CryOfThePredator"] = "Cri du prédateur";
L["BardsArrow"] = "Flèche de Bard";
L["TrapDamage"] = "Dégâts de piège";

-- 6) Lore-Master Skills

-- Trait lines
L["MasterOfNaturesFury"] = "Maître de la fureur naturelle";
L["TheAncientMaster"] = "Maître ancien";
L["TheKeeperOfAnimals"] = "Gardien des animaux";
-- Buffs (effect name)
L["AirLore"] = "Connaissance de l'air";
L["ContinualAirLore"] = "Continual Air-lore"; --exist ??
L["SignOfPowerRighteousness"] = "Signe du pouvoir : Intégrité";
L["SignOfPowerVigilance"] = "Signe du pouvoir : Vigilance";
L["SignOfTheWildRage"] = "Signe du pouvoir : Rage"; --exist ??
L["ImprovedSignOfTheWildRage"] = "Improved Sign of the Wild: Rage"; --exist ??
L["SignOfTheWildProtection"] = "Sign of the Wild: Protection"; --exist ??
-- Debuffs (log name)
-- L["KnowledgeOfTheLoreMaster"] = "Knowledge of the Lore-master";
L["GustOfWind"] = "Bourrasque";
L["FireLore"] = "Connaissance du feu";
L["WindLore"] = "Connaissance du vent";
L["FrostLore"] = "Connaissance du froid";
L["AncientCraft"] = "Artisanat ancien";
L["SignOfPowerCommand"] = "Signe du pouvoir : Commandement";
L["ImprovedSignOfPowerCommand"] = "Signe du pouvoir : commandement amélioré";
L["SignOfPowerSeeAllEnds"] = "Signe du pouvoir : voir la fin des choses";
-- Crowd Control (log name)
L["BlindingFlash"] = "Lumière aveuglante";
L["ImprovedBlindingFlash"] = "Lumière aveuglante améliorée";
L["BaneFlare"] = "Eclat fatal";
L["HerbLore"] = "Connaissance des plantes";
L["CrackedEarth"] = "Terre craquelée";
L["StormLore"] = "Connaissance de l'orage";
L["LightOfTheRisingDawn"] = "Lumière de l'aube naissante";
L["TestOfWill"] = "Test de volonté";
L["EntsGoToWar"] = "Marche guerrière des Ents";
L["ImprovedStaffStrike"] = "Coup de bâton améliore";

-- 7) Minstrel Skills

-- Trait lines
L["TheWarriorSkald"] = "Skalde guerrier";
L["TheProtectorOfSong"] = "Protecteur des chants";
L["TheWatcherOfResolve"] = "Veilleur déterminé";
-- Buffs (effect name)
L["AnthemOfWar"] = "Hymne de guerre";
L["AnthemOfTheFreePeoples"] = "Hymne des Peuples Libres";
L["AnthemOfProwess"] = "Anthem of Prowess";
L["AnthemOfComposure"] = "Hymne de contenance";
L["TheMelodyOfBattle"] = "Mélodie de bataille";
L["InspireFellows"] = "Inspire Fellows";
L["SoliloquyOfSpirit"] = "Esprit de soliloque";
L["ImprovedChordOfSalvation"] = "Improved Chord of Salvation";
L["TaleOfHeroism"] = "Epopée héroïque";
L["TaleOfBattle"] = "Epopée de combat";
L["TaleOfWarding"] = "Epopée de répit"; -- Tale of Warding ???
L["TaleOfWardingAndHope"] = "Tale of Warding and Hope";
L["TaleOfFrostAndFlame"] = "Tale of Frost and Flame";
L["TaleOfFrostAndFlamesBattle"] = "Tale of Frost and Flame's Battle";
L["TaleOfWardingAndHeroism"] = "Tale of Warding and Heroism";
L["SymphonyOfTheHopefulHeart"] = "Symphony of the Hopeful Heart";
L["Harmony"] = "Harmonie";
L["WarSpeech"] = "Discours de guerre";
L["AnthemOfCompassion"] = "Hymne de sympathie";
L["AnthemOfTheThirdAge"] = "Hymne du Troisième Age";
L["AnthemOfTheThirdAgeWarSpeech"] = "Hymne dissonant du Troisième Age";
L["AnthemOfTheThirdAgeHarmony"] = "Hymne résonant du Troisième Age";
L["MinorBallad"] = "Ballade mineure";
L["MajorBallad"] = "Ballade majeure";
L["PerfectBallad"] = "Ballade parfaite";
L["StillAsDeath"] = "Immobilité de cadavre";
-- Debuffs (log name)
L["CallOfOrome"] = "Appel d'Orom\195\171";
L["CryOfTheWizards"] = "Cri des Magiciens";
L["EchoesOfBattle"] = "Echo de bataille";
L["TimelessEchoesOfBattle"] = "Echo de bataille intemporel";
-- Crowd Control (log name)
L["SongOfTheDead"] = "Song of the Dead";
L["InvocationOfElbereth"] = "Invocation d'Elbereth";

-- 8) Rune-Keeper Skills

-- Trait lines
L["CleansingFires"] = "Cleansing Fires";
L["SolitaryThunder"] = "Solitary Thunder";
L["BenedictionsOfPeace"] = "Benedictions of Peace";
-- Buffs (effect name)
L["DoNotFallToStorm"] = "Do Not Fall to Storm";
L["DoNotFallToFlame"] = "Do Not Fall to Flame";
L["DoNotFallToWinter"] = "Do Not Fall to Winter";
L["DoNotFallThisDay"] = "Do Not Fall This Day";
L["ShallNotFallThisDay"] = "Shall Not Fall This Day";
L["PreludeToHope"] = "Prelude to Hope";
L["RuneOfRestoration"] = "Rune of Restoration";
L["WritOfHealthTier1"] = "Writ of Health - Tier 1";
L["WritOfHealthTier2"] = "Writ of Health - Tier 2";
L["WritOfHealthTier3"] = "Writ of Health - Tier 3";
L["OurFatesEntwined"] = "Our Fates Entwined";
L["AllFatesEntwined"] = "All Fates Entwined";
L["GloriousForeshadowing"] = "Glorious Foreshadowing";
L["WondrousForeshadowing"] = "Wondrous Foreshadowing";

-- 9) Warden Skills

-- Trait lines
L["WayOfTheSpear"] = "Way of the Spear";
L["WayOfTheFist"] = "Way of the Fist";
L["WayOfTheShield"] = "Way of the Shield";
-- Buffs (effect name)
L["Conviction"] = "Conviction";
L["DeterminationStance"] = "Determination Stance";
L["Conservation"] = "Conservation";
L["Recklessness"] = "Recklessness";
L["WayOfTheWarden"] = "Way of the Warden";
L["ShieldBashBlock"] = "Shield-bash - Block";
L["WallOfSteelParry"] = "Wall of Steel - Parry";
L["AdroitManoeuvre"] = "Adroit Manoeuvre";
L["WardensTriumph"] = "Warden's Triumph";
L["DefensiveStrikeBlock"] = "Defensive Strike - Block";
L["Persevere"] = "Persevere";
L["ShieldMastery"] = "Shield Mastery";
L["ShieldDefence"] = "Shield-defence";
L["ShieldTactics"] = "Shield-tactics";
L["DanceOfBattleEvade"] = "Dance of Battle - Evade";
L["TacticallySound"] = "Tactically Sound";
L["T1HealOverTime"] = "Guérison au fil du temps de niveau 1";
L["T2HealOverTime"] = "Guérison au fil du temps de niveau 2";
L["T3HealOverTime"] = "Guérison au fil du temps de niveau 3";
L["T4HealOverTime"] = "Guérison au fil du temps de niveau 4";

-- 10) Racial Skills
L["DutyBound"] = "Duty Bound";
L["DwarfEndurance"] = "Dwarf Endurance";

-- 11) Beorning
-- Traits
L["WayofTheHide"] = "Way of the Hide"
L["WayofTheClaw"] = "Way of the Claw"
L["WayofTheRoar"] = "Way of the Roar"

-- Buffs
L["EncouragingRoar"] = "Encouraging Roar";
L["RejuvenatingBellow"] = "Rejuvenating Bellow";
L["BracingRoar"] = "Bracing Roar";
L["Sacrifice"] ="Sacrifice";
L["BearUp"] ="Bear Up";
L["VigilantRoar"] = "Vigilant Roar";
L["AssertiveRoar"] = "Assertive Roar";
L["SluggishStings"] = "Sluggish Stings";
L["EnragingSacrifice"] = "Enraging Sacrifice";
L["DebilitatingBees"] = "Debilitating Bees";
L["EncouragingStrike"] = "Encouraging Strike";
L["ShakeFree"] = "Shake Free";
L["Takedown"] = "Takedown";
L["CripplingStings"] = "Crippling Stings";
L["CripplingRoar"] = "Crippling Roar";
L["ThickenedHide"] ="Thickened Hide";
L["Counter"] = "Counter";
L["CallToWild"] = "Call To Wild";

-- Crowd control
L["GrislyCry"] = "Grisly Cry";

-- Other
L["VagabondsCraft"] = "Vagabond's Craft";
L["StunImmunity"] = "Stun Immunity";
