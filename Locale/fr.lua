-- Database for Combat Analysis (Français)
-- Encodage: UTF8
-- Version du 11 mars 2016

L["DevelopedBy"] = "Developpé par Evendale, amélioré par Landal.";
L["TranslatedBy"] = "Traduction : Mayara@Sirannon Ardi@Estel Adra@Sirannon";

L["FailedToLoadTraitsResetConfirmation"] = "Échec du chargement des traits. Réinitialiser et continuer ?".."\n".."Attention : Vous perdrez toutes vos configurations personnelles de buffs et débuffs.";
L["FailedToLoadTraitsMessage"] = "Il est recommandé que vous déchargiez le plugin maintenant. Vous pouvez tenter de rechercher les erreurs dans votre fichier de traits :\n\"Documents\\The_Lord_of_the_Rings_Online\\PluginData\\<NomDuCompte>\\<NomDuServeur>\\<NomDuPerso>\\CombatAnalysisTraits.plugindata\"";
L["FailedToLoadSettingsResetConfirmation"] = "Échec du chargement de vos paramètres de configuration. Réinitialiser et continuer ?".."\n".."Attention : Vous perdrez tous vos paramètres personnels (excepté les configurations de buffs et débuffs).";
L["FailedToLoadSettingsMessage"] = "Il est recommandé que vous déchargiez le plugin maintenant. Vous pouvez tenter de rechercher les erreurs dans votre fichier de configuration :\n\"Documents\\The_Lord_of_the_Rings_Online\\PluginData\\<NomDuCompte>\\<NomDuServeur>\\<NomDuPerso>\\CombatAnalysis.plugindata\"";

-- Icon Menu

L["Logo"] = "Logo";
L["LockWindows"] = "Verrouiller les fenêtres";
L["UnlockWindows"] = "Déverrouiller fenêtres";
L["SaveData"] = "Sauveg. données";
L["LoadData"] = "Import. données";
L["OpenTheMenu"] = "Ouvrir menu principal";

-- Menu Headings

L["MenuTitle"] = "Combat Analysis";

L["General"] = "Général";
L["Stats"] = "Statistiques";
L["Buffs"] = "Buffs";
L["About"] = "À propos";

-- General Menu

L["GeneralSettingsTitle"] = "Réglages généraux";
L["AutoSelectNewEncounters"] = "Sélection automatique des nouvelles rencontres";
L["ConfirmDialogOnReset"] = "Dialogue de confirmation pour la remise à zéro";
L["largeFont"] = "Agrandir texte des stats (redémarrage requis)";

L["ShowLogo"] = "Afficher le logo de Combat Analysis";

L["MaxStandardEncounters"] = "Nombre max de rencontres";
L["MaxLoadedEncounters"] = "Nombre max de rencontres importées";

L["TimerConfigurationsTitle"] = "Calibrages temporels";
L["CombatTimeout"] = "Délai d'expiration du combat";
L["TargetTimeout"] = "Délai d'expiration de la cible";
L["LogDelay"] = "Délais d'enregistrement";
L["EffectDelay"] = "Délais pour les effets";

L["SaveLoadTitle"] = "Sauvegarde/Importation";
L["AutoSaveData"] = "Sauvegarde auto. des données";
L["Off"] = "Désactivée";
L["SaveOnExit"] = "Enregistre en quittant";
L["SaveEncounters"] = "Enreg. les rencontres";

-- UI Menu

L["UI"] = "Interface";
L["Tabs"] = "Onglets";
L["Windows"] = "Panneaux";
L["Tab"] = "Onglets";
L["Window"] = "Panneau";

L["TabsAndWindowsConfigurationTitle"] = "Configuration des onglets et des panneaux";
L["TabsAndWindowsDescription"] = "Déplacez les onglets pour reconfigurer votre interface.\nDéplacez les onglets inutilisés dans le rangement sur la droite";

L["TabSettingsTitle"] = "Paramétrage de l'onglet";
L["SelectedTab"] = "Onglet sélectionné";
L["ColorScheme"] = "Palette de couleurs ";
L["TempMorale"] = "Moral temporaire";
L["AutoSelectPlayer"] = "Sélection automatique des détails du joueur";

L["WindowSettingsTitle"] = "Paramétrage de ce panneau";
L["SelectedWindow"] = "panneau sélectionné";
L["Background"] = "arrière-plan";
L["XPos"] = "x-pos";
L["YPos"] = "y-pos";
L["Width"] = "Largeur";
L["Height"] = "Hauteur";
L["Minimized"] = "Réduite";
L["CenterOnScreen"] = "Centrer à l'écran";
L["AutoHideTabs"] = "Masquer les onglets en l'absence de la souris";
L["ShowBackground"] = "Afficher l'arrière-plan et les bords";
L["ShowMiniTitleBar"] = "Afficher la mini barre fermer/réduire";
L["ShowTitleAndDuration"] = "Afficher titre et durée";
L["ShowEncountersList"] = "Afficher la liste des rencontres";
L["ShowTargetsList"] = "Afficher la liste des cibles";
L["ShowExtraButtons"] = "Afficher bouton *envoi dans chat* et *i*";

L["StatsWindowsConfigurationTitle"] = "Configuration des statistiques";
L["StatsWindowsDescription"] = "> Déplacez les cases pour reconfigurer votre interface\n> Déplacez les éléments inutiles dans le rangement à droite";

L["StatsWindowSettingsTitle"] = "Paramètres du panneau de statistiques";
L["Visibility"] = "Visibilité";
L["AlwaysShow"] = "Toujours visible";
L["ShowOnHover"] = "Montrer au survol";
L["ShowOnLock"] = "Sur verrouillage";

L["ReOrder"] = "Déplacement";
L["InsertTab"] = "Insérer l'onglet";
L["NewWindow"] = "Nouveau panneau";
L["CloseWindow"] = "Fermer panneau";

-- Buffs Menu

L["Debuffs"] = "Débuffs";
L["CC"] = "Contrôles";
L["CrowdControl"] = "Contrôles de foules";
L["Bubbles"] = "Bulles";

L["TraitConfigurationsTitle"] = "Configurations des Traits";
L["SelectedConfiguration"] = "Configuration sélectionnée";
L["RemoveTraitConfigurationConfirmation"] = "Êtes vous sûr de vouloir supprimer cette configuration ?";

L["AddConfiguration"] = "Ajout de Configuration";
L["ConfigurationName"] = "Nom de cette config. ";
L["CopyDebuffsFrom"] = "Copier les débuffs de ";
L["None"] = "Aucun";
L["Add"] = "Ajout";
L["Remove"] = "Retrait";

L["ConfigurationNameRequired"] = "Un nom de Configuration est obligatoire";
L["ConfigurationNameAlreadyExists"] = "Ce nom de configuration existe déjà";
L["ColorSchemeRequired"] = "Une palette de couleurs est obligatoire";

L["AddBuff"] = "Ajout des buffs";
L["AddDebuff"] = "Ajout des débuffs";
L["RemoveBuff"] = "Suppr. buff";
L["RemoveDebuff"] = "Suppr. débuff";
L["FilterList"] = "Filtres";
L["Remov"] = "Suppression"; -- lowercase (for filtering by removal only debuffs/CC)
L["Class"] = "Classe ";

-- { Full Name, Full Name with no spaces, Two Letter Abbreviation}
L["BuffBars"] = {"BuffBars", "BuffBars", "BB"}
L["CombatAnalysis"] = {"Combat Analysis", "CombatAnalysis", "CA"}
L["ConfigureInBuffBars"] = "Config. dans BuffBars";
L["BuffBarsNotLoadedMessage"] = "BuffBars n'est pas chargé ou vous utilisez une version non compatible avec Combat Analysis.";

L["RemoverPrefix"] = "Préfixe de suppresseur";-- pas de trad
L["NameRequiredPrefix"] = "Nom Obligatoire";

L["EffectName"] = "Nom de l'Effet";
L["BuffName"] = "Nom du buff ";
L["DebuffName"] = "Nom du débuff ";
L["IconFileName"] = "Nom de l'icône ";
L["RemovalOnly"] = "Suppresseur ";
L["ToggleSkill"] = "comp. permutable ";
L["Removes"] = "Suppression ";
L["ConflictsWith"] = "Prémunit contre ";
L["EffectModifiers"] = "Modificateurs d'effets ";
L["IsStance"] = "Posture ";
L["StackingBuffs"] = "Buffs empilables ";
L["LogName"] = "Nom du Log";
L["AppliedBy"] = "Appliqué Par ";
L["CritsOnlyAbbreviation"] = "Crit";
L["DelayAbbreviation"] = "Delai";
L["DurationAbbreviation"] = "Durée";

-- About Menu

L["AboutTitle"] = "A propos";
L["VersionNo"] = "Version N°";
L["RestoreSettings"] = "Restauration de la configuration";
L["RestoreSettingsConfirmation"] = "Êtes vous sûr de vouloir restaurer tous les paramètres par défaut, à l'exclusion des traits ?";
L["RestoreTraits"] = "Restauration des Traits";
L["RestoreTraitsConfirmation"] = "Êtes vous sûr de vouloir restaurer les paramètres de configuration des traits à leur valeur par défaut ?";
L["PluginUsageMessage"] = "Pour plus d'informations sur l'utilisation de ce plugin, visitez :";
L["FoundABugMessage"] = "Un Bug ? Signalez le en laissant un commentaire à l'adresse ci-dessus, ou bien sur sa page Github.";

-- Tooltips

L["AutoSelectTooltip"] = "Sélectionner immédiatement la nouvelle rencontre lorsque le combat débute.";
L["ConfirmOnResetTooltip"] = "Afficher une demande de confirmation lors de la réinitialisation de toutes les rencontres.";
L["ShowLogoTooltip"] = "Afficher ou masquer le logo de Combat Analysis. \nCelui-ci permet d'afficher/masquer les fenêtres et d'accéder au menu.";
L["LockWindowsTooltip"] = "Vérrouiller toutes les fenêtres en l'état, de sorte qu'elles ne puissent pas être déplacées, redimensionnées ou fermées, excepté via le menu de l'onglet ou par le menu principal.";
L["LargeFontTooltip"] = "Agrandit la taille du texte sur les fenêtres de vue d'esemble et de stats. Une fois ceci coché, vous devez fermer puis relancer C A pour voir les textes agrandis. Sinon les changements prendront effet au prochain lancement.";
L["MaxEncountersTooltip"] = "Définir le nombre de rencontres à conserver dans l'historique.";
L["MaxLoadedEncountersTooltip"] = "Définir le nombre de rencontres importées à conserver dans l'historique.";
L["CombatTimeoutTooltip"] = "Définir la période de grace après la fin du combat durant laquelle les dégâts sont encore pris en compte.";
L["TargetTimeoutTooltip"] = "Définir la période de grace après la mort du joueur ou d'un monstre durant laquelle les dégâts vers la cible demeurent pris en compte. Remarque : Cette valeur doit être inférieure à celle définissant le delai d'expiration du combat.";
L["LogDelayTooltip"] = "Définir la période maximum entre la détection d'un évènement de combat et la détection qu'un effet correspondant a été appliqué";
L["EffectDelayTooltip"] = "Définir la période maximum entre la détection qu'un effet a été appliqué et la détection d'un évènement de combat correspondant.";
L["AutoSaveTooltip"] = "Définir comment les données sont automatiquement sauvegardées:\na) Les données ne sont pas sauvergardées automatiquement\nb) Toutes les données (l'ensemble des rencontres) sont sauvegardées lorsque vous vous déconnectez (ou lorsque vous déchargez le plugin)\nc) Chaque rencontre est sauvegardée aussitôt que le combat prend fin";

L["SelectedTabTooltip"] = "Selectionnez un onglet à configurer.";
L["ColorSchemeTooltip"] = "Définissez le profil de couleur utilisé par cet onglet.";
L["TempMoraleTooltip"] = "Définissez le profil de couleur utilisé pour les détails se rapportant au moral temporaire.";
L["AutoSelectPlayerTooltip"] = "Pour cet onglet : Immédiatement sélectionner les détails du joueur lorsque qu'une nouvelle rencontre est sélectionnée.";
L["SelectWindowTooltip"] = "Selectionner une fenêtre à configurer.";
L["BackgroundTooltip"] = "Définir la couleur d'arrière-plan pour cette fenêtre.";
L["WindowTabsTooltip"] = "Une liste des onglets figurant actuellement dans cette fenêtre.";
L["CenterWindowOnScreenTooltip"] = "Centrer cette fenêtre sur votre écran. Celà maximisera également la fenêtre, assurant ainsi que les onglets et arrière-plans soient visibles";
L["AutoHideTabsTooltip"] = "Pour cette fenêtre : Afficher les onglets seulement lorque la souris survole la fenêtre.";
L["ShowBackgroundTooltip"] = "Pour cette fenêtre : Afficher ou masquer l'arrière-plan et les bordures par dessus la surface d'affichage principal.";
L["ShowMiniTitleBarTooltip"] = "Pour cette fenêtre : Afficher ou masquer la mini barre de titre (avec le menu et les icônes minimiser et fermer).";
L["ShowTitleAndDurationTooltip"] = "Pour cette fenêtre : Afficher ou masquer le titre coloré qui montre la cible sélectionnée et la durée.";
L["ShowEncountersListTooltip"] = "Pour cette fenêtre : Afficher ou masquer la liste déroulante des rencontres.";
L["ShowTargetsListTooltip"] = "Pour cette fenêtre : Afficher ou masquer la liste déroulante des cibles.";
L["ShowExtraButtonsTooltip"] = "Afficher ou masquer les boutons *Info* et *Envoi dans chat*.";
L["SelectedWindowTooltip"] = "Sélectionner une fenêtre de statistiques à configurer.";
L["StatsBackgroundTooltip"] = "Définir la couleur d'arrière-plan pour cette fenêtre de statistiques.";
L["StatsWindowTabsTooltip"] = "Une liste des onglets figurant actuellement dans cette fenêtre.";
L["CenterStatsWindowOnScreenTooltip"] = "Centrer cette fenêtre de statistiques sur votre écran. Celà assurera également que la fenêtre de statistiques est affichée(Toujours montrer).";
L["VisibilityTooltip"] = "Pour cette fenêtre de statistiques, veuillez spécifiez si:\na) la fenêtre sera toujours visible\nb) la fenêtre deviendra visible lorsque qu'une barre est survolée ou bien vérouillée dans l'un des onglets\nc) la fenêtre ne deviendra visible que lorsque les détails d'une barre sont vérouillés";

L["SelectedConfigurationTooltip"] = "Sélectionner quelle configuration de traits utiliser et éditer ci-dessous. Ceci n'affecte que les informations relatives aux debuff et aux contrôles de foules.";
L["AddConfigurationTooltip"] = "Ajouter une nouvelle configuration de traits.";
L["RemoveConfigurationTooltip"] = "Supprimer la configuration de traits sélectionnée.";
L["ConfigurationNameTooltip"] = "Attribuer un nom à la configuration de traits. Celui-ci ne pourra pas être modifié par la suite.";
L["CopyDebuffsFromTooltip"] = "Sélectionner une configuration de traits depuis laquelle copier le set initial de debuffs.";
L["ConfigurationColorSchemeTooltip"] = "Sélectionner un modèle de couleurs pour la nouvelle configuration.";
L["AddNewBuffTooltip"] = "Ajouter un nouveau buff.";
L["AddNewDebuffTooltip"] = "Ajouter un nouveau débuff.";
L["RemoveBuffTooltip"] = "Retirer ce buff/débuff.";
L["BuffsActiveInCombatAnalysisTooltip"] = "Observer/pister les buffs dans Combat Analysis.";
L["DebuffsActiveInCombatAnalysisTooltip"] = "Observer/pister les débuffs dans Combat Analysis.";
L["DebuffsActiveInBuffBarsTooltip"] = "Observer/pister les débuff dans BuffBars.";
L["MakeDebuffActiveInCombatAnalysisTooltip"] = "Cocher pour observer/pister ce debuff dans Combat Analysis.";
L["MakeDebuffActiveInBuffBarsTooltip"] = "Cocher pour observer/pister ce debuff dans BuffBars.";
L["ConfigureInBuffBarsLinkTooltip"] = "Cliquer pour aller dans le menu de BuffBars où se configurent les fenêtre d'effets qui montrent les debuffs et les contrôles de foules qui sont déclenchés en fonction des paramètres ci-dessous. Notez que ceux-ci correspndent aux types de déclencheurs \"Mob Debuffs\" & \"Mob CC\" dans BuffBars.";
L["ClassTooltip"] = "Spécifier à quelle classe ce buff/débuff appartient.";
L["TempMoraleEffectNameTooltip"] = "Spécifier le nom de l'effet correspondant à cette compétence de moral temporaire. Ce nom doit être parfaitement similaire au nom de l'effet.";
L["SkillNameTooltip"] = "Spécifier un nom unique pour ce buff/debuff. Celui-ci apparaitra sur l'onglet Buffs/Débuffs, ainsi que dans la fenêtre de'effets de Buffbars si applicable.";
L["IconFileNameTooltip"] = "Spécifier le mon de fichier (y compris son extension) de l'icône à associer à ce debuff. L'icône doit être placée dans le dossier 'CombatAnalysis/Resources/DebuffIcons' et doit mesurer 16x16 pixels.";
L["RemovalOnlyTooltip"] = "Un debuff 'Suppresseur' n'est pas observé/pisté, à la place il est utilisé pour retirer d'autres débuffs.";
L["ToggleSkillTooltip"] = "Une 'compétence permutable' est une compétence désactivable/activable qui dure indéfiniment. Ces debuffs predurent jusqu'à la mort de la cible, la fin du combat, ou leur désactivation manuelle.";
L["RemovesTooltip"] = "Une liste de debuffs ou de contrôles de foules qui seront supprimés quand ce debuff est appliqué.";
L["AddRemoveTooltip"] = "Ajouter un nouveau débuff qui sera supprimé quand ce débuff est appliqué.";
L["RemoveRemoveTooltip"] = "Retirer le débuff sélectionné de liste des debuffs à supprimer quand ce débuff est appliqué.";
L["ConflictsWithTooltip"] = "Une liste de compétences de débuff et de contrôle de foules qui prémunissent contre ce débuff si elles sont actives.";
L["AddConflictTooltip"] = "Ajouter un nouveau débuff qui prémunit contre ce débuff.";
L["RemoveConflictTooltip"] = "Supprimer le débuff sélectionné de la liste des débuffs qui prémunissent contre cet effet.";
L["EffectModifiersTooltip"] = "Une liste d'effets, qui, s'ils sont actifs sur le joueur lorsque le débuff est lui est lancé, allongent ou raccourcicent la durée de l'effet.";
L["AddEffectModifierTooltip"] = "Ajouter un nouvel effet qui modifie la durée de ce débuff.";
L["RemoveEffectModifierTooltip"] = "Supprimer l'effet sélectionné de la liste des modificateurs d'effets..";
L["EffectModifierDurationTooltip"] = "Définissez, en posifif ou négatif, le rallongement ou le raccourcissement de la durée du débuff si cet effet est actif quand le debuff est activé.";
L["IsStanceTooltip"] = "For skills that are stances, the number of applications are not tracked."; -- need trad
L["StackingBuffsTooltip"] = "Une liste de noms qui seront affichés pour le buff lors des applications succéssives lorsque celui-ci est encore actif au moment de sa réactivation.";
L["AddStackingBuffTooltip"] = "Ajouter un nouvau nom d'effet empilable.";
L["RemoveStackingBuffTooltip"] = "Supprimer le nom sélectionné de la liste des noms d'effets empilables.";
L["LogNameTooltip"] = "Specify the name of the combat log entry corresponding to this temporary morale skill that will be used to match a bubble effect with the initiating player. The name must exactly match the name of the skill as it appears in the combat log."; -- need trad
L["BuffAppliedByTooltip"] = "Une liste de noms d'effets qui déclenchent l'application de ce buff. Les noms doivent être parfaitement similaires aux noms des effets.";
L["DebuffAppliedByTooltip"] = "Une liste de noms de compétence du log combat qui déclenchent l'application de ce débuff, et les détails associés. Les noms doivent être parfaitement similaires aux noms des compétences telles qu'elles apparaissent dans le log combat.";
L["AddAppliedByTooltip"] = "Add a new application."; -- need trad
L["RemoveAppliedByTooltip"] = "Remove the selected application from the list of applications."; -- need trad
L["CritsOnlyTooltip"] = "When checked, the debuff will only be applied if the skill achieves a Critical or Devastating hit.";
L["DelayTooltip"] = "Set the delay after the application occurs until the skill activates. Note this can be a small negative value to offset a delay before the combat log entry occurs.";
L["DurationTooltip"] = "Définir la durée du débuff.";

-- Tutorials

L["DoNotShowHintInFuture"] = " Ne plus afficher cette\n  astuce à l'avenir"; -- be sure to include line break and spaces
L["LogoTitle"] = "Utiliser le Logo Combat Analysis";
L["LogoMessage"] = "Clic Gauche sur le logo pour Afficher/Masquer l'ensemble des fenêtres de Combat Analysis.\n\Clic droit quand le logo est activé (orange) pour faire apparaitre l'option de sauvegarde/importation ou le menu principal.\n\nDéplacez le Logo en appuyant simultanément sur 'Control' et '*'. Vous pouvez également le désactiver à partir du menu principal.";

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
L["ResetCommand"] = "Réinitialiser";
L["LockToggleCommand"] = "verrou";
L["CleanUpCommand"] = "nettoyer";

L["CommandUsage"] = "usage: /ca "..L.Options.." | "..L.SaveCommand.." | "..L.LoadCommand.." | "..L.ToggleCommand.." | "..L.ShowCommand.." | "..L.HideCommand.." | "..L.LockToggleCommand.." | "..L.LockCommand.." | "..L.UnlockCommand.." | "..L.ResetCommand.." | "..L.ResetTotalsCommand.." | "..L.CleanUpCommand;

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
L["Brawler"] = {"Brawler", "BRW"};

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
L["CleanUp"] = "Vider les poubelles";

-- Chat Menu (indexed by {command, channel name})

L["Say"] = {"parler","Parler"};
L["Fellowship"] = {"f","Communauté"};
L["Raid"] = {"ra","Raid"};
L["Kinship"] = {"k","Confrérie"};
L["Tribe"] = {"k","Tribu"};
L["Gap"] = "------------------";

-- Other

L["AllPlayers"] = "Tous les joueurs";
L["AllSkills"] = "Compétences (tous)";
L["Duration"] = "Durée";
L["SendToChat"] = "Envoi dans chat";
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

L["AllData"] = "Toutes les infos";
L["NonCrits"] = "Non critiques";
L["Criticals"] = "Critiques";
L["Devastates"] = "Dévastateurs";
L["CritsAndDevs"] = "Crit & Dévast";
L["Partials"] = "Evitements partiels";

L["Total"] = "Total";
L["Average"] = "Moyenne";
L["Maximum"] = "Maximum";
L["Minimum"] = "Minimum";

--- Added in v4.4.7 to support Normal Hits
L["NormalHits"] = "Coups non critiques";
L["NormalHitChance"] = "fréquence";
L["NormalHitAvg"] = "Montant moyen";
L["NormalHitMax"] = "Montant maximal"
L["NormalHitMin"] = "Montant minimmal"

--- Added in v4.4.7 to support Critical Hits
L["CriticalHits"] = "Coups Critiques";
L["CriticalHitChance"] = "fréquence";
L["CriticalHitAvg"] = "Montant moyen";
L["CriticalHitMax"] = "Montant maximal"
L["CriticalHitMin"] = "Montant minimmal"

--- Added in v4.4.7 to support Devastate Hits
L["DevastateHits"] = "Coups crit. dévastateurs";    
L["DevastateHitChance"] = "fréquence";
L["DevastateHitAvg"] = "Montant moyen";
L["DevastateHitMax"] = "Montant maximal"       
L["DevastateHitMin"] = "Montant minimmal"

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

L["DmgTypeEnum"] = {{"Commun","Commun"},{"Feu","Feu"},{"Foudre","Foudre"},{"Froid","Froid"},{"Acide","Acide"},{"Ombre","Ombre"},{"Lumière","Lumière"},
					{"Bele","Beleriand"},{"Ouist","Ouistrenesse"},{"Nain","Nain d'antan"},{"Orque","Orque"},{"Mal","Maléfique"},{"Aucun", "Aucun"}}

					
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

	-- Articles possibles: Mayara, LeMayara, Le Mayara, LaMayara, La Mayara, L' Mayara, La Mayara, et peut être d'autres ?
	return string.gsub(name, "^[Ll].-(%u)", "%1");
end


L["Parse"] = function(line)

	-- 1) ligne de dégâts ---
	
	local initiatorName,avoidAndCrit,skillName,targetName,amount,dmgType,moralePower = string.match(line,"^(.*) a infligé un coup (.*)avec (.*) sur (.*) pour ([%d,]*) points de type (.*) à l'entité ?(.*)%.$"); -- (updated in v4.1.0)
	
	if (initiatorName ~= nil) then
	
  
--		initiatorName = string.gsub(initiatorName,"^[Ll]e ","");
		
		local avoidType =
			string.match(avoidAndCrit,"partiellement bloqué") and 8 or
			string.match(avoidAndCrit,"partiellement paré") and 9 or
			string.match(avoidAndCrit,"partiellement esquivé ") and 10 or 
			1;
		local critType =
			string.match(avoidAndCrit,"critique") and 2 or
			string.match(avoidAndCrit,"dévastateur") and 3 or 1;
			
--		skillName = string.match(skillName,"^ avec (.*)$") or L.DirectDamage; -- (as of v4.1.0)

--		local targetName,amount,dmgType,moralePower = string.match(targetNameAmountAndType,"^(.*) for ([%d,]*) (.*)damage to (.*)$");
	
    if (printDebug) then
       Turbine.Shell.WriteLine( "damage by "..initiatorName.." skill "..skillName );
    end	

		-- damage was absorbed
		if targetName == nil then
			targetName = string.gsub(targetNameAmountAndType,"^[Ll]e ","");
			amount = 0;
			dmgType = 12;
			moralePower = 3;
		-- some damage was dealt
		else
--			targetName = string.gsub(targetName,"^[Ll]e ","");
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
				dmgType == "Légère" and 7 or
				dmgType == "Beleriand" and 8 or
				dmgType == "Ouistrenesse" and 9 or
				dmgType == "de nain d'antan" and 10 or 
				dmgType == "Orque" and 11 or
				dmgType == "Maléfique" and 12 or 13;
			moralePower = (moralePower == "Moral" and 1 or moralePower == "Puissance" and 2 or 3);
		end
		
		-- Currently ignores damage to power
		if (moralePower == 2) then return nil end
		
		-- Update
		return event_type.DMG_DEALT,trim_articles(initiatorName),trim_articles(targetName),skillName,amount,avoidType,critType,dmgType;
	end
	
	-- 2) Line de soins --
	--     (note the distinction with which self heals are now handled)
	--     (note we consider the case of heals of zero magnitude, even though they presumably never occur)
	
	--	[slfHeal] Arc du Juste a appliqué un soin critique à Ardichas, redonnant 52 points à l'entité Puissance.
	--  [slfHeal] Esprit de soliloque a appliqué un soin critique à Yogimen, redonnant 228 points à l'entité Moral.
	--  [Heal]    Eleria a appliqué un soin avec Paroles de guérison Ardicapde, redonnant 227 points à Moral.
	initiator_name, match = string.match(line, '^(.*) a appliqué un soin (.*)%.$');

	if (initiator_name ~= nil) then
			crit_type =
				string.match(match, 'critique') and 2 or
				string.match(match, 'dévastateur') and 3 or 
				1;
			match = string.gsub(match, '^critique ', '');
			match = string.gsub(match, '^dévastateur ', '');

		local self_heal = (string.match(match, '^à ') and true or false);

		-- Soins personnels (Self heal)
		if (self_heal) then
			skill_name = initiator_name;
			target_name, dmg_amount, morale_power = string.match(match, '^à (.*), redonnant ([%d,]*) points? à l\'entité ?(.*)$');
			initiator_name = target_name;

		-- Soins sur une cible (Heal applied)
		else
			skill_name, target_name, dmg_amount, morale_power = string.match(match, '^avec (.*) ([^%s]+), redonnant ([%d,]*) points? à ?(.*)$');
		end

		morale_power = (morale_power == 'Moral' and 1 or (morale_power == 'Puissance' and 2 or 3));
		dmg_amount = (morale_power == 3 and 0 or string.gsub(dmg_amount, ',', '') + 0);

		return (morale_power == 2 and 4 or 3), trim_articles(initiator_name), trim_articles(target_name), skill_name, dmg_amount, crit_type;
	end
	
	-- 3) Ligne de buff --
	-- MarieChantal a appliqué un bénéfice avec Paroles de guérison Eleria.

	local initiatorName,skillName,targetName = string.match(line,"^(.*) a appliqué un bénéfice avec (.*) (.*)%.$");
	
	if (initiatorName ~= nil) then
--		initiatorName = string.gsub(initiatorName,"^[Ll]e ","");
--		targetName = string.gsub(targetName,"^[Ll]e ","");		
		-- Update
		return event_type.BENEFIT,trim_articles(initiatorName),trim_articles(targetName),skillName;
	end
	
	-- 4) Avoid line --
	-- L' Profanateur ghâshfra vigoureux a essayé d'utiliser une attaque de lancer faible sur MarieChantal mais a esquivé la tentative.
	-- L' Berserker hante-jours a essayé d'utiliser une double attaque au corps à corps sur Eleria mais elle a paré la tentative.
	-- L' Archer corsaire a essayé d'utiliser une attaque au corps à corps faible sur Cashel mais il a paré la tentative.
	-- Ardichas a essayé d'utiliser Tir pénétrant amélioré : Brûlure sur le Trompeur immonde vigoureux mais il a esquivé la tentative.

	-- Évitements standards (complets)
	local initiator_name, skill_name, target_name, avoidType = string.match(line, "^(.*) a essayé d'utiliser (.*) sur (.*) mais (.*) la tentative%.$");

	if (initiator_name ~= nil) then
		avoid_Type =
			string.match(avoidType,"bloqué") and 5 or
			string.match(avoidType,"paré") and 6 or
			string.match(avoidType,"esquivé") and 7 or
			string.match(avoidType,"résisté") and 4 or
			string.match(avoidType,"immunisé contre") and 3 or 1;
			
	-- miss or deflect (deflect added in v4.2.2)
	-- La Berserker hante-jours n'a pas réussi à utiliser une frappe de taille faible sur la Eleria.

		if (avoid_type == 1) then
			return nil;
		end
		return 1, trim_articles(initiator_name), trim_articles(target_name), skill_name, 0, avoid_Type, 1, 10;
	end
	
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
				dmgType == "de nain d'antan" and 10 or
				dmgType == "Orc" and 11 or
				dmgType == "Maléfique" and 12 or 13;						
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

		return event_type.CC_BROKEN, nil, trim_articles(target_name), nil;
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

		return event_type.CC_BROKEN, nil, target_name, nil;
	end
	
	-- 8) Interrupt line --
	
	local target_name, initiator_name = string.match(line, "^(.*) a été interrompu par (.*)!$");

	if (target_name ~= nil) then
		return event_type.INTERRUPT, trim_articles(initiator_name), trim_articles(target_name);
	end
	
	-- 9) Dispell line (corruption removal) --
	
	local corruption, target_name = string.match(line, "Vous avez dissipé l'effet (.*) affectant (.*)%.$");

	if (corruption ~= nil) then
		initiator_name = player.name;
		-- NB: Currently ignore corruption name
		
		-- Update
		return event_type.CORRUPTION, trim_articles(initiator_name), trim_articles(target_name);
	end
	
	-- 10) Defeat lines ---
	
	-- 10a) Defeat line 1 (mob or played was killed)
	initiator_name = string.match(line, "^.* a vaincu (.*)%.$");

	if (initiator_name ~= nil) then

	-- Update
		return event_type.DEATH, trim_articles(initiator_name);
	end

	-- 10b) Defeat line 2 (mob died)
	initiator_name = string.match(line, "^(.*) meurt%.$");

	if (initiator_name ~= nil) then
		
		-- Update
		return event_type.DEATH, trim_articles(initiator_name);
	end

	-- 10c) Defeat line 3 (a player was killed or died)
	initiator_name = string.match(line, "^(.*) a péri%.$");

	if (initiator_name ~= nil) then
		
		-- Update
		return event_type.DEATH, trim_articles(initiator_name);
	end

	-- 10d) Defeat line 4 (you were killed)
	match = string.match(line, "^.* a réussi à vous mettre hors de combat%.$");

	if (match ~= nil) then
		
		-- Update
		return event_type.DEATH, trim_articles(player.name);
	end

	-- 10e) Defeat line 5 (you died)
	match = string.match(line, "^Un incident vous a réduit à l'impuissance%.$");

	if (match ~= nil) then
		
		-- Update
		return event_type.DEATH, trim_articles(player.name);
	end	
	-- 10f) Defeat line 6 (you killed a mob)
	local initiatorName = string.match(line,"^Votre coup puissant a vaincu (.*)%.$");
	
	if (initiatorName ~= nil) then
		
		-- Update
		return event_type.DEATH,trim_articles(initiatorName);
	end
	
	-- 11) Revive lines --
	
	-- 11a) Revive line 1 (player revived)
	local initiatorName = string.match(line,"^(.*) revient à la vie%.$");
	
	if (initiatorName ~= nil) then
	  
		-- Update
	  return event_type.REVIVE,trim_articles(initiatorName);
	end
	
	-- 11b) Revive line 2 (player succumbed)
	local initiatorName = string.match(line,"^(.*) a succombé à ses blessures%.$");
	
	if (initiatorName ~= nil) then
	  
		-- Update
	  return event_type.REVIVE,trim_articles(initiatorName);
	end
	
	-- 11c) Revive line 3 (you were revived)
	local match = string.match(line,"^Vous revenez à la vie%.$");
	
	if (match ~= nil) then
	  initiatorName = player.name;
	  
		-- Update
	  return event_type.REVIVE,initiatorName;
	end
	
	-- 11d) Revive line 4 (you succumbed)
	local match = string.match(line,"^Vous avez succombé à vos blessures%.$");
	
	if (match ~= nil) then
	  initiatorName = player.name;
	  
		-- Update
	  return event_type.REVIVE,initiatorName;
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

L["Default"] = "Par défaut";

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
L["WordOfExaltationEffect"] = "Mot d'exaltation";
L["WordOfExaltationLog"] = "Mot d'exaltation";
L["EssayOfExaltationEffect"] = "Essai d'exaltation";
L["EssayOfExaltationLog"] = "Mot d'exaltation";
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
L["RelentlessAttack"] = "Attaque acharnée";
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
L["StrengthOfWillFellowshipSongBrother"] = "Inspiration (Frère de chants communauté)";
L["StrengthOfWillBladeBrother"] = "Inspiration (Frère d'armes)";
L["StrengthOfWillFellowshipBladeBrother"] = "Inspiration (Frère d'armes communauté)";
L["RallyingCry"] = "Cri de ralliement";
L["InDefenceOfMiddleEarth"] = "A la défense de la Terre du Milieu";
L["DefensiveStrike"] = "Frappe certaine";
L["ImprovedDefensiveStrike"] = "Frappe certaine améliorée";
L["LastStand"] = "Dernier combat";
-- Debuffs (log name)
L["NobleMark"] = "Marque de noblesse";
L["TellingMark"] = "Marque efficace";
L["RevealingMark"] = "Marque révélatrice";

-- 3) Champion Skills

-- Trait Lines
L["TheBerserker"] = "Berserker";
L["TheDeadlyStorm"] = "Tempête mortelle";
L["TheMartialChampion"] = "Champion du combat";
-- Buffs (effect name)
L["Fervour"] = "Ferveur"; -- obsolete since U12
L["Glory"] = "Gloire"; -- obsolete since U12
L["Ardour"] = "Ardeur"; -- obsolete since U12
L["ControlledBurn"] = "Brûlure contrôlée";
L["Flurry"] = "Flurry";
L["SuddenDefence"] = "Défense soudaine";
L["SeekingBlades"] = "Seeking Blades";
L["Adamant"] = "Adamantite";
L["Invincible"] = "Invincible";
-- Hamstring (log name)
L["Hamstring"] = "Coup aux jarrets";
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
L["CleansingFires"] = "Flamme purificatrice";
L["SolitaryThunder"] = "Tonnerre solitaire";
L["BenedictionsOfPeace"] = "Bénédiction de la paix";
-- Buffs (effect name)
L["DoNotFallToStorm"] = "Do Not Fall to Storm"; -- obsolete ?
L["DoNotFallToFlame"] = "Do Not Fall to Flame"; -- obsolete ?
L["DoNotFallToWinter"] = "Do Not Fall to Winter"; -- obsolete ?
L["DoNotFallThisDay"] = "Tu ne succomberas pas aujourd'hui";
L["ShallNotFallThisDay"] = "Shall Not Fall This Day";
L["PreludeToHope"] = "Prelude à l'espoir";
L["RuneOfRestoration"] = "Rune de restauration";
L["WritOfHealthTier1"] = "Allégorie de la santé - Niveau 1";
L["WritOfHealthTier2"] = "Allégorie de la santé - Niveau 2";
L["WritOfHealthTier3"] = "Allégorie de la santé - Niveau 3";
L["OurFatesEntwined"] = "Nos destins entrelacés";
L["AllFatesEntwined"] = "Nos destins entrelacés"; -- obsolete ?
L["GloriousForeshadowing"] = "Présage glorieux";
L["WondrousForeshadowing"] = "Wondrous Foreshadowing"; -- obsolete ?

-- 9) Warden Skills

-- Trait lines
L["WayOfTheSpear"] = "La voie de la lance";
L["WayOfTheFist"] = "La voie du poing";
L["WayOfTheShield"] = "La voie du bouclier";
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

-- 12 Brawler
L["TheFulcrum"] = "The Fulcrum";
L["TheMaelstrom"] = "The Maelstrom";
L["TheFundament"] = "The Fundament";
L["GetSerious"] = "Get Serious";
L["WeatherBlows"] = "Weather Blows";
L["SkipFree"] = "Skip Free";
L["IgnorePain"] = "Ignore Pain";
L["FollowMe"] = "Follow Me!";
L["QuickFeint"] = "Quick Feint";
L["OneforAll"] = "One for All";
L["SkipFree"] = "Skip Free";

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
L["StunImmunity"] = "Immunité contre les états temporaires";
