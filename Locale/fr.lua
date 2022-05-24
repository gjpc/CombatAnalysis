-- Database for Combat Analysis (Français)
-- Encodage: UTF-8 (sans BOM) afin de conserver les accents
-- Version du 06 mai 2022

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
L["largeFont"] = "Agrandir le texte des stats (redémarrage requis)";

L["ShowLogo"] = "Afficher le logo de Combat Analysis";

L["MaxStandardEncounters"] = "Nombre max de rencontres";
L["MaxLoadedEncounters"] = "Nombre max de rencontres importées";

L["TimerConfigurationsTitle"] = "Réglages temporels";
L["CombatTimeout"] = "Délai d'expiration du combat";
L["TargetTimeout"] = "Délai d'expiration de la cible";
L["LogDelay"] = "Délai d'enregistrement";
L["EffectDelay"] = "Délai pour les effets";

L["SaveLoadTitle"] = "Sauvegarde/Importation";
L["AutoSaveData"] = "Enregistrement auto. des données";
L["Off"] = "Pas d'enregistrement";
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
L["ShowExtraButtons"] = "Afficher bouton *envoi dans canal* et *i*";

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
L["RestoreSettings"] = "Restaurer la config.";
L["RestoreSettingsConfirmation"] = "Êtes vous sûr de vouloir restaurer tous les paramètres par défaut, à l'exclusion des traits ?";
L["RestoreTraits"] = "Restaurer les traits";
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
L["CenterWindowOnScreenTooltip"] = "Centrer cette fenêtre sur votre écran. Cela maximisera également la fenêtre, assurant ainsi que les onglets et arrière-plans soient visibles";
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
L["CenterStatsWindowOnScreenTooltip"] = "Centrer cette fenêtre de statistiques sur votre écran. Cela assurera également que la fenêtre de statistiques est affichée (Toujours montrer).";
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
L["Green"] = {"Vert", "V"};
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
L["ResetCommand"] = "réinitialiser";
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

L["ResetTotalsMessage"] = "Êtes vous sûr de vouloir réinitialiser le cumulatif ?";
L["Yes"] = "Oui";
L["No"] = "Non";
L["OK"] = "Compris";

-- Classes

L["Burglar"] = {"Cambrioleur","CAM"};
L["Captain"] = {"Capitaine","CAP"};
L["Champion"] = {"Champion","CHP"};
L["Guardian"] = {"Gardien","GRD"};
L["Hunter"] = {"Chasseur","CHS"};
L["LoreMaster"] = {"Maitre du Savoir","MDS"};
L["Minstrel"] = {"Ménestrel","MEN"};
L["RuneKeeper"] = {"Gardien des Runes","GDR"};
L["Warden"] = {"Sentinelle","SEN"};
L["Beorning"] = {"Béornide","BEO"};
L["Brawler"] = {"Bagarreur", "BAG"};

L["BlackArrow"] = {"Flèche noire","FN"};
L["Defiler"] = {"Profanateur","PRO"};
L["Reaver"] = {"Faucheur","FAU"};
L["Stalker"] = {"Ouargue","WAR"};
L["WarLeader"] = {"Chef de guerre","CDG"};
L["Weaver"] = {"Araignée","GNE"};

L["Racial"] = {"Race","RAC"};
L["Item"] = {"Objet","OBJ"};
L["OtherClass"] = {"Autre","INC"};

-- Select File Dialog

L["Select"] = "Sélectionner";
L["Save"] = "Sauvegarder";
L["Saves"] = "Sauvegardes";
L["Load"] = "Charger";
L["Loads"] = "Chargés"; -- A vérifier
L["Cancel"] = "Annuler";

L["FileName"] = "Nom du ficher ";

L["SelectAll"] = "Tout sélec.";
L["ClearAll"] = "Tout dé-sélec. ";

L["Delete"] = "Effacer";

L["AreYouSureYouWantToDeleteMessage"] = "Êtes-vous sûr de vouloir supprimer\nle(s) fichier(s) sélectionné(s)?";

L["Encounters"] = "Rencontres";
L["Items"] = "Objets";
L["CombineWith"] = "Combiner Avec";
L["CombineInto"] = "Combiner Dans";

L["SelectCurrentDataToCombineWith"] = "Combiner les données chargées avec les données actuelles ";
L["LoadDataAsTotalsEncounter"] = "Remplacer le cumulatif avec les données chargées";

L["SelectSaveFile"] = "Choisir une sauvegarde";
L["SelectFileToLoad"] = "Choisir le fichier à charger";
L["SelectDataToSave"] = "Choisir le fichier à sauvegarder";
L["SelectDataToCombineWith"] = "Combiner avec";

L["TooLong"] = "Vous ne pouvez entrer qu'un maximum de 64 caractères.";
L["IllegalCharacters"] = "Vous ne pouvez entrer que des lettres, des chiffres, des espaces et des soulignés.";

L["NoDataMessage"] = "Il n'y a actuellement aucune donnée à enregistrer.";
L["NoFileMessage"] = "Pas de fichier spécifié.";
L["NoDataSelectedMessage"] = "Aucune donnée n'a été sélectionnée.";
L["OverwriteFileMessage"] = "Le fichier existe déjà. Voulez-vous combiner les données enregistrées avec ce fichier ou les remplacer ?";
L["CombineOrSeparateMessage"] = "Vous avez sélectionné plusieurs fichiers. Voulez-vous combiner les données ou les charger séparément ?";
L["TooManyCharactersMessage"] = "Le nom de fichier spécifié est trop long (longueur maximale = 64 caractères)";
L["InvalidCharactersMessage"] = "Le nom de fichier spécifié contient des caractères non valides..";
L["FileNotFoundMessage"] = "L'un des fichiers spécifiés n'a pu être trouvé.";
L["SaveFailedMessage"] = "Échec de la sauvegarde: ";
L["LoadFailedMessage"] = "Échec du chargement: ";
L["CombineMessage"] = "Êtes-vous sûr de vouloir combiner les fichiers sélectionnés ?";
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
L["CleanUp"] = "Vider la poubelle";

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
L["SendToChat"] = "Envoi dans canal";
L["CombatAnalysisSummary"] = "Résumé de Combat Analysis";

L["DirectDamage"] = "Dégât direct";

L["MinutesAbbr"] = "m";
L["SecondsAbbr"] = "s";

L["Daze"] = "Hébété";
L["Root"] = "Enraciné";
L["Fear"] = "Peur";
L["Stun"] = "Assommé";
L["Knockdown"] = "Renversé";

-- Statistics Headings

L["AllData"] = "Toutes les infos";
L["NonCrits"] = "Non-critiques";
L["CritsAndDevs"] = "Crit & Dévast";
L["Partials"] = "Évitements partiels";

L["Total"] = "Total";
L["Average"] = "Montant moy.";
L["Maximum"] = "Montant max.";
L["Minimum"] = "Montant min.";

--- Added in v4.4.7 to support Normal Hits
L["NormalHits"] = "Coups non-critiques";
L["NormalHitChance"] = "Fréquence";
L["NormalHitAvg"] = "Montant moy.";
L["NormalHitMax"] = "Montant max."
L["NormalHitMin"] = "Montant min."

--- Added in v4.4.7 to support Critical Hits
L["CriticalHits"] = "Coups critiques";
L["CriticalHitChance"] = "Fréquence";
L["CriticalHitAvg"] = "Montant moy.";
L["CriticalHitMax"] = "Montant max."
L["CriticalHitMin"] = "Montant min."

--- Added in v4.4.7 to support Devastate Hits
L["DevastateHits"] = "Coups crit. dévastateurs";    
L["DevastateHitChance"] = "Fréquence";
L["DevastateHitAvg"] = "Montant moy.";
L["DevastateHitMax"] = "Montant max."       
L["DevastateHitMin"] = "Montant min."

L["Avoidance"] = "Évitements";
L["Attacks"] = "Actions";
L["AttacksPS"] = "Actions/s";
L["Hits"] = "Coups réussis";
L["Absorbs"] = "Coups absorbés";
L["Misses"] = "Coups ratés";
L["Deflects"] = "Coups reflétés";  -- ou bien "déviés" ?
L["Immune"] = "Immunisés";
L["Resists"] = "Résistés";
L["PhysicalAvoids"] = "Évitements physiques";
L["FullAvoids"] = "Évitements complets";
L["PartialAvoids"] = "Évitements partiels";
L["Avoids"] = "Évitements complets";
L["Blocks"] = "Bloqués";
L["Parrys"] = "Parrés";
L["Evades"] = "Esquivés";
L["PartialBlocks"] = "Blocages Partiels";
L["PartialParrys"] = "Parades Partielles";
L["PartialEvades"] = "Esquives Partielles";

L["Other"] = "Autre";
L["Interrupts"] = "Interruptions";
L["CorruptionsRemoved"] = "Corruptions";

L["DmgTypes"] = "Types de dégâts";

L["TempMorale"] = "Moral temporaire";
L["RegularHeals"] = "Soins normaux";
L["TempHeals"] = "Soins temporaires";
L["WastedTempHeals"] = "Soins perdus";

-- Note the following elements are indexed by: {Short Name, Full Name, Per Second Abbreviation, Tab Title, Tab Tooltip}

L["Dmg"] = {"Infligé ","Dégâts infligés ","Infligé/s ","Dégâts Infligés","Onglet dégâts infligés"}
L["Taken"] = {"Subi ","Dégâts subis","Subi/s ","Dégâts subis","Onglet dégâts subis"}
L["Heal"] = {"Soigné ","Soins reçus et prodigués","Soin/s ","Soins","Onglet soins reçus et prodigués"}
L["Power"] = {"Puiss ","Puissance reçue et envoyée","Puiss/s ","Puissance","Onglet puissance reçue et absorbée"}

L["Debuff"] = {"Debuff","Debuff","Debuff","Onglet des Debuffs","Onglet sur la durée des Debuffs"}
L["Buff"] = {"Buff","Buff","Buff","Onglet des Buffs","Onglet sur la durée des Buffs"}

L["Death"] = {"Mort","Mort"}
L["Corruption"] = {"Corruption","Corruption Retirée"}
L["Interrupt"] = {"Interruption","Interruption"}
L["CombatEntered"] = {"Début combat","Début du combat"}
L["CombatExited"] = {"Fin combat","Fin du combat"}


L["AvoidanceEnum"] = {{"Aucun","Aucun"},{"Raté","Raté"},{"Immunisé","Immunisé"},{"Résisté","Résisté"},
                      {"Bloqué","Bloqué"},{"Paré","Paré"},{"Esquivé","Esquivé"},
                      {"Bloqué-P","Bloqué partiellement"},{"Paré-P","Paré partiellement"},{"Esquivé-P","Esquivé partiellement"},
                      {"Reflété", "Reflété"}}

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
local function TrimArticles(name)
	if (name == nil) then
		return nil;
	end

	-- Articles possibles: Mayara, LeMayara, Le Mayara, LaMayara, La Mayara, L' Mayara, La Mayara, et peut être d'autres ?
	return string.gsub(name, "^[Ll].-(%u)", "%1");
end


L["Parse"] = function(line)

	-- 1) ligne de dégâts, incluant les attaque partiellement évitées ---
	-- La Cible DPS factice a infligé un coup partiellement esquivé avec Attaque à distance sur Adragor pour 6,538 points de type Commun à l'entité Moral.
	-- Adragor a infligé un coup critique avec Rhétorique glaciale sur la Cible DPS factice pour 51,642 points de type Froid à l'entité Moral.
	
	local initiatorName,avoidAndCrit,skillName,targetName,amount,dmgType,moralePower = string.match(line,"^(.*) a infligé un coup (.*)avec (.*) sur (.*) pour ([%d,]*) points de type (.*) à l'entité ?(.*)%.$"); -- (updated in v4.1.0)
		
	if (initiatorName ~= nil) then
	
		local avoidType =
			string.match(avoidAndCrit,"partiellement bloqué") and 8 or
			string.match(avoidAndCrit,"partiellement paré") and 9 or
			string.match(avoidAndCrit,"partiellement esquivé ") and 10 or 1;			
		local critType =
			string.match(avoidAndCrit,"critique") and 2 or
			string.match(avoidAndCrit,"dévastateur") and 3 or 1;
			
--		skillName = string.match(skillName,"^ avec (.*)$") or L.DirectDamage; -- (as of v4.1.0)

-- 		variables déja incluses plus haut 
--		local targetName,amount,dmgType,moralePower = string.match(targetNameAmountAndType,"^(.*) pour ([%d,]*) (.*)points de type \"(.*)\" à (.*)$");

-- Pas sûr que les 3 lignes en dessous soit utiles
--   if (printDebug) then
--      Turbine.Shell.WriteLine( "damage by "..initiatorName.." skill "..skillName );
--  end	
	
		-- damage was absorbed
		if targetName == nil then
			amount = 0;
			dmgType = 13;
			moralePower = 3;
		-- some damage was dealt
		else
			amount = string.gsub(amount,",","")+0;
      
			dmgType = string.match(dmgType, "^%(.*%) (.*)$") or dmgType; -- 4.2.3 adjust for mounted combat
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
		return event_type.DMG_DEALT,TrimArticles(initiatorName),TrimArticles(targetName),skillName,amount,avoidType,critType,dmgType;
	end

	-- 2) Ligne de soins --
	--     (note the distinction with which self heals are now handled)
	--     (note we consider the case of heals of zero magnitude, even though they presumably never occur)

	--	[slfHeal] Arc du Juste a appliqué un soin critique à Ardichas, redonnant 52 points à l'entité Puissance.
	--  [slfHeal] Esprit de soliloque a appliqué un soin critique à Yogimen, redonnant 228 points à l'entité Moral.
	--  [Heal]    Eleria a appliqué un soin avec Paroles de guérison Ardicapde, redonnant 227 points à Moral.
	
	local initiatorName, match = string.match(line, '^(.*) a appliqué un soin (.*)%.$');

	if (initiatorName ~= nil) then
		local critType =
				string.match(match, 'critique') and 2 or
				string.match(match, 'dévastateur') and 3 or 1;
				
			match = string.gsub(match, '^critique ', '');
			match = string.gsub(match, '^dévastateur ', '');

		local self_heal = (string.match(match, '^à ') and true or false);

		-- Soins personnels (Self heal)
		-- Guérison d'Attaque fortifiante a appliqué un soin à Adra, redonnant 314,802 points à l'entité Moral.
		if (self_heal) then
			skillName = initiatorName;
			targetName, dmg_amount, moralePower = string.match(match, '^à (.*), redonnant ([%d,]*) points? à l\'entité ?(.*)$');
			initiatorName = targetName;

		-- Soins sur une cible (Heal applied)
		else
			skillName, targetName, dmg_amount, moralePower = string.match(match, '^avec (.*) ([^%s]+), redonnant ([%d,]*) points? à ?(.*)$');
		end

		moralePower = (moralePower == 'Moral' and 1 or (moralePower == 'Puissance' and 2 or 3));
		dmg_amount = (moralePower == 3 and 0 or string.gsub(dmg_amount, ',', '') + 0);

		return (moralePower == 2 and event_type.POWER_RESTORE or event_type.HEAL), TrimArticles(initiatorName), TrimArticles(targetName), skillName, dmg_amount, critType;
	end
	
	-- 3) Ligne de buff --
	-- MarieChantal a appliqué un bénéfice avec Paroles de guérison Eleria.
	-- Osred a appliqué un bénéfice critique avec Cri de ralliement Osred.

	local initiatorName,skillName,targetName = string.match(line,"^(.*) a appliqué un bénéfice (.*)avec (.*) (.*)%.$");
	
	if (initiatorName ~= nil) then

		-- Update
		return event_type.BENEFIT,TrimArticles(initiatorName),TrimArticles(targetName),skillName;
	end
	
	-- 4) Ligne d'évitements --
	-- L' Profanateur ghâshfra vigoureux a essayé d'utiliser une attaque de lancer faible sur MarieChantal mais a esquivé la tentative.
	-- L' Cible DPS factice a essayé d'utiliser Attaque à distance sur Adragor mais il a esquivé la tentative.
	-- L' Berserker hante-jours a essayé d'utiliser une double attaque au corps à corps sur Eleria mais elle a paré la tentative.

	-- Évitements standards (complets)
	-- L' Eau sinistre redoutable a essayé d'utiliser Maladie sur Osred mais il a résisté la tentative.
	-- L' Eau sinistre redoutable a essayé d'utiliser une attaque au corps à corps modérée sur Osred mais il a esquivé la tentative.
	
	local initiatorName, skillName, targetName, avoidType = string.match(line, "^(.*) a essayé d'utiliser (.*) sur (.*) mais (.*) la tentative%.$");

	if (initiatorName ~= nil) then
		avoid_Type =
			string.match(avoidType,"bloqué") and 5 or
			string.match(avoidType,"paré") and 6 or
			string.match(avoidType,"esquivé") and 7 or
			string.match(avoidType,"résisté") and 4 or
			string.match(avoidType,"immunisé contre") and 3 or 1;

		if (avoid_type == 1) then
			return nil;
		end
		return event_type.DMG_DEALT, TrimArticles(initiatorName), TrimArticles(targetName), skillName, 0, avoid_Type, 1, 10;
	end
			
	-- 4b miss or deflect (deflect added in v4.2.2)

	-- La Eau sinistre misérable n'a pas réussi à utiliser une double attaque au corps à corps sur le Osred.
	local initiatorName, skillName, targetName = string.match(line, "^(.*) n'a pas réussi à utiliser (.*) sur (.*)%.$");

	-- il manque le deflect
	
	if (initiatorName ~= nil) then
		local avoidType = 2;
	
		-- Sanity check: must have avoided in some manner
		if (avoidType == 1) then return nil end
		
		-- Update
		return event_type.DMG_DEALT,initiatorName,targetName,skillName,0,avoidType,1,13;
	end
	
	-- 5) Reflect line 

	-- reflet de dégâts
	-- Le Beorgal a renvoyé 1,106 Commun de dégâts au Moral de le Gobelin porteur de bombes.
	
	-- reflet soins
	-- Le Sangsue gardienne a renvoyé 339 points redonnés au Moral de Eleria.

	local initiatorName,amount,reflectType,targetName = string.match(line,"^(.*) a renvoyé ([%d,]*) (.*) au Moral de (.*)%.$");
	
	if (initiatorName ~= nil) then
		local skillName = "Reflect";
		amount = string.gsub(amount,",","")+0;
		
		local dmgType = string.match(reflectType,"^(.*)de dégâts$");
		-- a damage reflect
		if (dmgType ~= nil) then
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
				dmgType == "Orc" and 11 or
				dmgType == "Maléfique" and 12 or 13;						
			-- Update
			return event_type.DMG_DEALT,TrimArticles(initiatorName),TrimArticles(targetName),skillName,amount,1,1,dmgType;
		-- a heal reflect
		else
			-- Update
			return event_type.HEAL,TrimArticles(initiatorName),TrimArticles(targetName),skillName,amount,1;
		end
	end
	
	-- 6) Temporary Morale bubble line (as of 4.1.0)
	-- Vous avez perdu 11 points de Moral temporaire !
  local amount = string.match(line,"^Vous avez perdu ([%d,]*) points de Moral temporaire !$");
	if (amount ~= nil) then
		amount = string.gsub(amount,",","")+0;
		
		-- the only information we can extract directly is the target and amount
		return event_type.TEMP_MORALE_LOST,nil,TrimArticles(player.name),nil,amount;
	end
	
	-- 7) Combat State Break notice (as of 4.1.0)
	
	-- 7a) Root broken
	-- Racine invoquée vous a délivré de l'immobilisation !
	initiatorName, targetName = string.match(line, "^(.*) délivré (.*) de l'immobilisation !$");  -- à vérifier

	if (initiatorName ~= nil) then
		-- the only information we can extract directly is the target name
		initiatorName =
			string.match(initiatorName, "^Vous avez") and player.name or
			string.match(initiatorName, " vous a$") and string.gsub(initiatorName, " vous a$", "") or
			string.gsub(initiatorName, " a$", "");
		targetName = (targetName == "" and player.name or targetName);

		if (printDebug) then
  			Turbine.Shell.WriteLine("root_broken", line, "ini_name: " .. initiatorName .. " tgt_name: " .. targetName);
		end

		return event_type.CC_BROKEN, nil, TrimArticles(targetName), nil;
	end
	
	-- 7b) Daze broken
	-- 	Vous avez délivré Gobelin manipulé de l'hébétement !	
	initiatorName, targetName = string.match(line, "^(.*) délivré (.*) de l'hébétement !$"); -- à vérifier

	if (initiatorName ~= nil) then
		initiatorName =
			string.match(initiatorName, "^Vous avez") and player.name or
			string.match(initiatorName, " vous a$") and string.gsub(initiatorName, " vous a$", "") or
			string.gsub(initiatorName, " a$", "");
		targetName = (targetName == "" and player.name or targetName);

		if (printDebug) then
		  Turbine.Shell.WriteLine("daze_broken", line, "ini_name: " .. initiatorName .. " tgt_name: " .. targetName);
		end  
		  
	end

	-- 7c) Fear broken
	-- Votre attaque a dissipé la peur qui étreignait Gobelin porteur de bombes !
	local targetName = string.match(line,"^.* a dissipé la peur qui étreignait (.*) !$");   -- à vérifier
	if (targetName ~= nil) then
		
		-- the only information we can extract directly is the target name
		return event_type.CC_BROKEN,nil,targetName,nil;
	end


	-- 8) Interrupt line --
	
	local targetName, initiatorName = string.match(line, "^(.*) a été interrompu par (.*) !$");

	if (targetName ~= nil) then
		return event_type.INTERRUPT, TrimArticles(initiatorName), TrimArticles(targetName);
	end
	
	-- 9) Dispell line (corruption removal) --
	
	local corruption, targetName = string.match(line, "Vous avez dissipé l'effet (.*) affectant (.*)%.$");

	if (corruption ~= nil) then
		initiatorName = player.name;
		-- NB: Currently ignore corruption name
		
		-- Update
		return event_type.CORRUPTION, TrimArticles(initiatorName), TrimArticles(targetName);
	end
	
	-- 10) Defeat lines ---
	
	-- 10a) Defeat line 1 (mob or played was killed)
	-- Hellokitting a vaincu la Racine invoquée.
	initiatorName = string.match(line, "^.* a vaincu (.*)%.$");

	if (initiatorName ~= nil) then

	-- Update
		return event_type.DEATH, TrimArticles(initiatorName);
	end

	-- 10b) Defeat line 2 (mob died)
	initiatorName = string.match(line, "^(.*) meurt%.$");

	if (initiatorName ~= nil) then
		
		-- Update
		return event_type.DEATH, TrimArticles(initiatorName);
	end

	-- 10c) Defeat line 3 (a player was killed or died)
	initiatorName = string.match(line, "^(.*) a péri%.$");

	if (initiatorName ~= nil) then
		
		-- Update
		return event_type.DEATH, TrimArticles(initiatorName);
	end

	-- 10d) Defeat line 4 (you were killed)
	match = string.match(line, "^.* a réussi à vous mettre hors de combat%.$");

	if (match ~= nil) then
		initiatorName = player.name;
		
		-- Update
		return event_type.DEATH, TrimArticles(player.name);
	end

	-- 10e) Defeat line 5 (you died)
	match = string.match(line, "^Un incident vous a réduit à l'impuissance%.$");

	if (match ~= nil) then
--	initiatorName = player.name;	-- à activer ?
		-- Update
		return event_type.DEATH, TrimArticles(player.name);
	end	
	-- 10f) Defeat line 6 (you killed a mob)
	-- Votre coup puissant a vaincu la Racine invoquée.
	local initiatorName = string.match(line,"^Votre coup puissant a vaincu (.*)%.$");
	
	if (initiatorName ~= nil) then
		
		-- Update
		return event_type.DEATH,TrimArticles(initiatorName);
	end
	
	-- 11) Revive lines --
	
	-- 11a) Revive line 1 (player revived)
	local initiatorName = string.match(line,"^(.*) revient à la vie%.$");
	
	if (initiatorName ~= nil) then
	  
		-- Update
	  return event_type.REVIVE,TrimArticles(initiatorName);
	end
	
	-- 11b) Revive line 2 (player succumbed)
	local initiatorName = string.match(line,"^(.*) a succombé à ses blessures%.$");
	
	if (initiatorName ~= nil) then
	  
		-- Update
	  return event_type.REVIVE,TrimArticles(initiatorName);
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
L["TrueHeroicsEffect"] = "Grands actes d'héroïsme";
L["TrueHeroicsLog"] = "Grands actes d'héroïsme";  
L["SuddenDefenceEffect"] = "Défense soudaine";
L["SuddenDefenceLog"] = "Défense soudaine";
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
L["EssayOfExaltationEffect"] = "Mot d'exaltation";  -- ou "Essai d'exaltation"
L["EssayOfExaltationLog"] = "Essai d'exaltation";  -- ou "Mot d'exaltation"
  -- Other
L["MartyrsFortitudeEffect"] = "Force d'âme du martyr";  -- A vérifier - Effet déclenchable par un set de bijoux niveau 75
L["MartyrsFortitudeLog"] = "Force d'âme du martyr"; -- A vérifier
L["FrostRingEffect"] = "Anneau du froid"; -- A vérifier -- L'effet de l'anneau de froid lors du combat contre Saroumane ?
L["FrostRingLog"] = "Shield of the Blizzard";

-- 1) Burglar Skills
  -- Trait Lines : Il s'agit à priori du nom des chacun des 3 arbres de traits, tel qu'ils s'affichent dans le chat suite à leur chargement.
L["TheMischiefMaker"] = "L'espiègle";
L["TheQuietKnife"] = "Le poignard silencieux";
L["TheGambler"] = "Le parieur";
  -- Buffs (effect name)
L["TouchAndGo"] = "Touch and Go";
L["KnivesOut"] = "Knives Out";
L["Mischievous"] = "Mischievous";
L["QuietKnife"] = "Quiet Knife";
L["Gambler"] = "Gambler";
  -- Skills
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
L["LeadTheCharge"] = "A la charge";
L["LeaderOfMen"] = "Meneur d'hommes";
L["HandsOfHealing"] = "Mains guérisseuses";
  -- Buffs (effect name)
L["MusterCourage"] = "Rassemblement de courage";
L["InHarmsWay"] = "Au cœur du danger";
L["WarCry"] = "Cri de guerre"; -- Obsolete
L["BladeOfElendil"] = "Lame d'Elendil";
L["Motivated"] = "Discours motivant amélioré"; -- or "motivation" ?
L["OnGuard"] = "En garde";
L["RelentlessAttack"] = "Attaque acharnée";
L["Focus"] = "Concentration";
L["ShieldBrother"] = "Frère de bouclier";
L["WatchfulShieldBrother"] = "Frère de bouclier vigilant";
L["SongBrother"] = "Frère de chants";
L["BladeBrother"] = "Frère d'armes";
L["ShieldOfTheDunedain"] = "Bouclier des Dúnedain";
L["ToArmsShieldBrother"] = "Aux-armes";
L["ToArmsFellowshipShieldBrother"] = "Aux armes! (Frère de bouclier communauté)"; -- obsolete ?
L["ToArmsSongBrother"] = "Aux armes ! (Frère de chants)";
L["ToArmsFellowshipSongBrother"] = "Aux armes! (Frère de chants communauté)"; -- obsolete ?
L["ToArmsBladeBrother"] = "Aux armes ! (Frère d'armes)";
L["ToArmsFellowshipBladeBrother"] = "Aux armes! (Frère d'armes communauté)"; -- obsolete ?
L["StrengthOfWillShieldBrother"] = "Inspiration (Frère de bouclier)"; -- obsolete ?
L["StrengthOfWillFellowshipShieldBrother"] = "Inspiration (Frère de bouclier communauté)"; -- obsolete ?
L["StrengthOfWillSongBrother"] = "Inspiration (Frère de chants)"; -- obsolete ?
L["StrengthOfWillFellowshipSongBrother"] = "Inspiration (Frère de chants communauté)"; -- obsolete ?
L["StrengthOfWillBladeBrother"] = "Inspiration (Frère d'armes)"; -- obsolete ?
L["StrengthOfWillFellowshipBladeBrother"] = "Inspiration (Frère d'armes communauté)"; -- obsolete ?
L["RallyingCry"] = "Cri de ralliement";
L["InDefenceOfMiddleEarth"] = "A la défense de la Terre du Milieu"; -- Obsolete ?
L["DefensiveStrike"] = "Attaque retenue"; -- Obsolete
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
L["Fervour"] = "Ferveur"; -- obsolete
L["Glory"] = "Gloire"; -- obsolete
L["Ardour"] = "Ardeur"; -- obsolete
L["ControlledBurn"] = "Brûlure contrôlée";
L["Flurry"] = "Déluge de coups";
L["SuddenDefence"] = "Défense soudaine";
L["SeekingBlades"] = "Lame chercheuse"; -- obsolete
L["Adamant"] = "Adamantite";
L["Invincible"] = "Invincibilité"; -- or "Invincible"
  -- Hamstring (log name)
L["Hamstring"] = "Coup aux jarrets";
  -- Crowd Control (log name)
L["HornOfGondor"] = "Cor du Gondor";
L["Horn"] = "Cor";
  -- Benefits (log name)
L["EbbingIre"] = "Colère atténuée";
L["RisingIre"] = "Colère grandissante"; -- obsolete

-- 4) Guardian Skills
  -- Trait lines
L["TheKeenBlade"] = "Lame acérée";
L["TheFighterOfShadow"] = "Adversaire de l'Ombre";
L["TheDefenderOfTheFree"] = "Défenseur des Peuples Libres";
  -- Buffs (effect name)
L["Protection"] = "Protection";
L["ProtectionByTheSword"] = "Protection par l'épée";
L["ShieldWall"] = "Mur de boucliers";
L["GuardiansBlockStance"] = "Guardian's Block Stance";  -- obsolete
L["GuardiansParryStance"] = "Guardian's Parry Stance";  -- obsolete
L["Overpower"] = "Surpuissance";  -- obsolete
L["GuardiansThreatStance"] = "Guardian's Threat Stance"; -- obsolete
L["GuardiansPledge"] = "Serment de gardien";
L["GuardiansWard"] = "Guardian's Ward";
L["ImprovedGuardiansWard"] = "Improved Guardian's Ward";
L["GuardiansWardTactics"] = "Tactiques de Protection de gardien";
L["ImprovedGuardiansWardTactics"] = "Improved Guardian's Ward Tactics";
L["WarriorsBlock"] = "Warrior's Block";
L["WarriorsParry"] = "Warrior's Parry";
L["WarriorsPower"] = "Warrior's Power";
L["WarriorsThreat"] = "Warrior's Threat";
  -- Debuffs (log name)
L["Bash"] = "Bash";
L["ShieldSmash"] = "Écrasement au bouclier";
L["ToTheKing"] = "Au roi";
L["Challenge"] = "Défi";
L["ImprovedChallenge"] = "Improved Challenge";
L["ChallengeTheDarkness"] = "Challenge the Darkness";   -- obsolete
L["ImprovedOverwhelm"] = "Improved Overwhelm";
L["ImprovedSting"] = "Improved Sting";
L["ImminentCleansing"] = "Imminent Cleansing";

-- 5) Hunter Skills
  -- Trait lines
L["TheBowmaster"] = "Maître archer";
L["TheTrapperOfFoes"] = "Piégeur d'ennemis";
L["TheHuntsman"] = "Flèche sylvaine";
  -- Buffs (effect name)
L["StanceStrength"] = "Posture : force";
L["StancePrecision"] = "Posture : précision";
L["StanceEndurance"] = "Posture : endurance";
L["BurnHot"] = "Vive flamme";
L["CoolBurn"] = "Cool Burn";  -- obsolete
L["Fleetness"] = "Célérité";
L["ImprovedFleetness"] = "Célérité améliorée";
L["SwiftStroke"] = "Décochage rapide";
L["NeedfulHaste"] = "Hâte nécessaire";
L["HuntersArt"] = "Art du chasseur"; -- Obsolete
  -- Debuffs (log name)
L["QuickShot"] = "Tir rapide";
L["LowCut"] = "Coups au jambes";
L["CripplingShot"] = "Crippling Shot";
L["SlowingCut"] = "Coupure ralentissante";
  -- Crowd Control (log name)
L["DazingBlow"] = "Coups d'hébétement";
L["ImprovedDazingBlow"] = "Coups d'hébètement amélioré";
L["DistractingShot"] = "Tir de distraction";
L["RainOfThorns"] = "Pluie d'épines";
L["CryOfThePredator"] = "Cri du prédateur";
L["BardsArrow"] = "Flèche de Bard";
L["TrapDamage"] = "Dégâts de piège";

-- 6) Lore-Master 
  -- Trait lines
L["MasterOfNaturesFury"] = "Maître de la fureur naturelle";
L["TheAncientMaster"] = "Maître ancien";
L["TheKeeperOfAnimals"] = "Gardien des animaux";
  -- Buffs (effect name)
L["AirLore"] = "Connaissance de l'air";
L["ContinualAirLore"] = "Continual Air-lore"; -- exist ??
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

-- 7) Minstrel
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
L["CleansingFires"] = "Flammes purificatrices"; -- Au pluriel dans le log mais au singulier sur l'arbre de traits
L["SolitaryThunder"] = "Tonnerre solitaire";
L["BenedictionsOfPeace"] = "Bénédictions de la paix"; -- Au pluriel dans le log mais au singulier sur l'arbre de traits
  -- Buffs (effect name)
L["DoNotFallToStorm"] = "Do Not Fall to Storm"; -- obsolete
L["DoNotFallToFlame"] = "Do Not Fall to Flame"; -- obsolete
L["DoNotFallToWinter"] = "Do Not Fall to Winter"; -- obsolete
L["DoNotFallThisDay"] = "Tu ne succomberas pas aujourd'hui";
L["ShallNotFallThisDay"] = "Shall Not Fall This Day"; -- obsolete
L["PreludeToHope"] = "Prélude à l'espoir"; -- il manque "Prelude à la Puissance" (sans accent)
L["RuneOfRestoration"] = "Rune de restauration";
L["WritOfHealthTier1"] = "Allégorie de la santé - niveau 1"; -- il manque "Allégorie de la santé" sans suffixe en tant que "bénéfice".
L["WritOfHealthTier2"] = "Allégorie de la santé - niveau 2";
L["WritOfHealthTier3"] = "Allégorie de la santé - niveau 3";
L["OurFatesEntwined"] = "Nos destins entrelacés";
L["AllFatesEntwined"] = "Nos destins entrelacés"; -- obsolete
L["GloriousForeshadowing"] = "Présage glorieux";
L["WondrousForeshadowing"] = "Présage merveilleux"; -- obsolete

-- 9) Warden Skills
  -- Trait lines
L["WayOfTheSpear"] = "La voie de la lance";  -- obsolete
L["WayOfTheFist"] = "La voie du poing";  -- obsolete
L["WayOfTheShield"] = "La voie du bouclier";  -- obsolete
  -- Buffs (effect name)
L["Conviction"] = "Conviction";
L["DeterminationStance"] = "Détermination"; -- A vérifier
L["Conservation"] = "Conservation";
L["Recklessness"] = "Imprudence";  -- A vérifier
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
L["DutyBound"] = "Appel du devoir";
L["DwarfEndurance"] = "Endurance de nain";

-- 11) Beorning
  -- Traits
L["WayofTheHide"] = "La Peau"
L["WayofTheClaw"] = "La Griffe"
L["WayofTheRoar"] = "Le Cri"
  -- Buffs
L["EncouragingRoar"] = "Rugissement d'encouragement";
L["RejuvenatingBellow"] = "Hurlement du renouveau";
L["BracingRoar"] = "Rugissement fortifiant";
L["Sacrifice"] = "Sacrifice";
L["BearUp"] = "Tenez bon";
L["VigilantRoar"] = "Rugissement vigilant";
L["AssertiveRoar"] = "Rugissement assuré";
L["SluggishStings"] = "Abeilles lénifiantes"; -- to be checked
L["EnragingSacrifice"] = "Sacrifice rageant";
L["DebilitatingBees"] = "Abeilles affaiblissantes";
L["EncouragingStrike"] = "Frappe encourageante"; 
L["ShakeFree"] = "Arrachement";
L["Takedown"] = "Tacle";
L["CripplingStings"] = "Dards invalidants";
L["CripplingRoar"] = "Rugissement invalidant"; -- ou "Rugissement perçant" le nom de l'effet de ralentissement
L["ThickenedHide"] = "Cuir renforcé";
L["Counter"] = "Contre";
L["CallToWild"] = "Appel sauvage";
  -- Crowd control
L["GrislyCry"] = "Cri atroce";

-- 12 Brawler : bagarreur
  -- Traits
L["TheFulcrum"] = "Le Fulcrum";
L["TheMaelstrom"] = "Le Maelström";
L["TheFundament"] = "La Fondation";

L["GetSerious"] = "Choses sérieuses";
L["WeatherBlows"] = "Weather Blows";
L["SkipFree"] = "Skip Free";
L["IgnorePain"] = "Ignore Pain";
L["FollowMe"] = "Follow Me!";
L["QuickFeint"] = "Quick Feint";
L["OneforAll"] = "One for All";
L["SkipFree"] = "Skip Free";

-- Other
L["VagabondsCraft"] = "Vagabond's Craft";
L["StunImmunity"] = "Immunité contre les états temporaires";
