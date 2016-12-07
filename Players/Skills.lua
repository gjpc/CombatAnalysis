
function _G.TraitConfigTextToColor(text)
  return (text == "Red" and Turbine.UI.Color(1,0.2,0.2) or (text == "Yellow" and Turbine.UI.Color(1,1,0.2) or Turbine.UI.Color(0.4,0.4,1)));
end

-- initialize a couple of special case skills
_G.benefits = {L.EbbingIre, L.RisingIre}

local shutDownAll = function ()
  while (true) do
    local name, config = next(traits.configurations);
    if (name == nil) then break end
    Traits.RemoveTraitConfiguration(name,true,true);
  end
end

local restoreV420Traits = function()
  
  traits.configurations = {}
  
  -- Shared Bubbles (Temporary Morale)
  
  traits.tempMorale = (player.isCreep and {} or
  {
    {class = "Minstrel", skillName = L.GiftOfTheHammerhandEffect, logName = L.GiftOfTheHammerhandLog},
    
    {class = "RuneKeeper", skillName = L.WordOfExaltationEffect, logName = L.WordOfExaltationLog},
    {class = "RuneKeeper", skillName = L.EssayOfExaltationEffect, logName = L.EssayOfExaltationLog},
    
    {class = "Item", skillName = L.MartyrsFortitudeEffect, logName = L.MartyrsFortitudeLog},
    {class = "Item", skillName = L.FrostRingEffect, logName = L.FrostRingLog}
  });
  
  -- Self Bubbles
  
  if (player.class == "Champion") then
    table.insert(traits.tempMorale, {class = "Champion", skillName = L.TrueHeroicsEffect, logName = L.TrueHeroicsLog});
    table.insert(traits.tempMorale, {class = "Champion", skillName = L.SuddenDefenceEffect, logName = L.SuddenDefenceLog});
  elseif (player.class == "Minstrel") then
    table.insert(traits.tempMorale, {class = "Minstrel", skillName = L.StoryOfTheHammerhandEffect, logName = L.StoryOfTheHammerhandLog});
    table.insert(traits.tempMorale, {class = "Minstrel", skillName = L.SongOfTheHammerhandEffect, logName = L.SongOfTheHammerhandLog});
  end
  
  -- Shared Buffs
  
  traits.buffs = (player.isCreep and {} or
  {
    {class = "Captain", skillName = L.MusterCourage, appliedBy = {L.MusterCourage}},
    {class = "Captain", skillName = L.InHarmsWay, appliedBy = {L.InHarmsWay}},
    {class = "Captain", skillName = L.WarCry, appliedBy = {L.WarCry}},
    {class = "Captain", skillName = L.BladeOfElendil, appliedBy = {L.BladeOfElendil}},
    {class = "Captain", skillName = L.Motivated, appliedBy = {L.Motivated}},
    {class = "Captain", skillName = L.OnGuard, appliedBy = {L.OnGuard}},
    {class = "Captain", skillName = L.RelentlessAttack, appliedBy = {L.RelentlessAttack}},
    {class = "Captain", skillName = L.Focus, appliedBy = {L.Focus}},
    {class = "Captain", skillName = L.ShieldBrother, appliedBy = {L.ShieldBrother}},
    {class = "Captain", skillName = L.WatchfulShieldBrother, appliedBy = {L.WatchfulShieldBrother}},
    {class = "Captain", skillName = L.SongBrother, appliedBy = {L.SongBrother}},
    {class = "Captain", skillName = L.BladeBrother, appliedBy = {L.BladeBrother}},
    {class = "Captain", skillName = L.ShieldOfTheDunedain, appliedBy = {L.ShieldOfTheDunedain}},
    {class = "Captain", skillName = L.ToArmsShieldBrother, appliedBy = {L.ToArmsShieldBrother}},
    {class = "Captain", skillName = L.ToArmsFellowshipShieldBrother, appliedBy = {L.ToArmsFellowshipShieldBrother}},
    {class = "Captain", skillName = L.ToArmsSongBrother, appliedBy = {L.ToArmsSongBrother}},
    {class = "Captain", skillName = L.ToArmsFellowshipSongBrother, appliedBy = {L.ToArmsFellowshipSongBrother}},
    {class = "Captain", skillName = L.ToArmsBladeBrother, appliedBy = {L.ToArmsBladeBrother}},
    {class = "Captain", skillName = L.ToArmsFellowshipBladeBrother, appliedBy = {L.ToArmsFellowshipBladeBrother}},
    {class = "Captain", skillName = L.StrengthOfWillShieldBrother, appliedBy = {L.StrengthOfWillShieldBrother}},
    {class = "Captain", skillName = L.StrengthOfWillFellowshipShieldBrother, appliedBy = {L.StrengthOfWillFellowshipShieldBrother}},
    {class = "Captain", skillName = L.StrengthOfWillSongBrother, appliedBy = {L.StrengthOfWillSongBrother}},
    {class = "Captain", skillName = L.StrengthOfWillFellowshipSongBrother, appliedBy = {L.StrengthOfWillFellowshipSongBrother}},
    {class = "Captain", skillName = L.StrengthOfWillBladeBrother, appliedBy = {L.StrengthOfWillBladeBrother}},
    {class = "Captain", skillName = L.StrengthOfWillFellowshipBladeBrother, appliedBy = {L.StrengthOfWillFellowshipBladeBrother}},
    {class = "Captain", skillName = L.RallyingCry, appliedBy = {L.RallyingCry}},
    {class = "Captain", skillName = L.InDefenceOfMiddleEarth, appliedBy = {L.InDefenceOfMiddleEarth}},
    
    {class = "Guardian", skillName = L.Protection, appliedBy = {L.Protection}},
    {class = "Guardian", skillName = L.ProtectionByTheSword, appliedBy = {L.ProtectionByTheSword}},
    {class = "Guardian", skillName = L.ShieldWall, appliedBy = {L.ShieldWall}},
    
    {class = "LoreMaster", skillName = L.AirLore, appliedBy = {L.AirLore}},
    {class = "LoreMaster", skillName = L.ContinualAirLore, appliedBy = {L.ContinualAirLore}},
    {class = "LoreMaster", skillName = L.SignOfPowerRighteousness, appliedBy = {L.SignOfPowerRighteousness}},
    {class = "LoreMaster", skillName = L.SignOfPowerVigilance, appliedBy = {L.SignOfPowerVigilance}},
    
    {class = "Minstrel", skillName = L.AnthemOfWar, appliedBy = {L.AnthemOfWar}},
    {class = "Minstrel", skillName = L.AnthemOfTheFreePeoples, appliedBy = {L.AnthemOfTheFreePeoples}},
    {class = "Minstrel", skillName = L.AnthemOfProwess, appliedBy = {L.AnthemOfProwess}},
    {class = "Minstrel", skillName = L.AnthemOfComposure, appliedBy = {L.AnthemOfComposure}},
    {class = "Minstrel", skillName = L.TheMelodyOfBattle, appliedBy = {L.TheMelodyOfBattle}},
    {class = "Minstrel", skillName = L.InspireFellows, appliedBy = {L.InspireFellows}},
    {class = "Minstrel", skillName = L.SoliloquyOfSpirit, appliedBy = {L.SoliloquyOfSpirit}},
    {class = "Minstrel", skillName = L.ImprovedChordOfSalvation, appliedBy = {L.ImprovedChordOfSalvation}},
    {class = "Minstrel", skillName = L.TaleOfHeroism, appliedBy = {L.TaleOfHeroism}},
    {class = "Minstrel", skillName = L.TaleOfBattle, appliedBy = {L.TaleOfBattle}},
    {class = "Minstrel", skillName = L.TaleOfWarding, appliedBy = {L.TaleOfWarding}},
    {class = "Minstrel", skillName = L.TaleOfWardingAndHope, appliedBy = {L.TaleOfWardingAndHope}},
    {class = "Minstrel", skillName = L.TaleOfFrostAndFlame, appliedBy = {L.TaleOfFrostAndFlame}},
    {class = "Minstrel", skillName = L.SymphonyOfTheHopefulHeart, appliedBy = {L.SymphonyOfTheHopefulHeart}},
    
    {class = "RuneKeeper", skillName = L.DoNotFallToStorm, appliedBy = {L.DoNotFallToStorm}},
    {class = "RuneKeeper", skillName = L.DoNotFallToFlame, appliedBy = {L.DoNotFallToFlame}},
    {class = "RuneKeeper", skillName = L.DoNotFallToWinter, appliedBy = {L.DoNotFallToWinter}},
    {class = "RuneKeeper", skillName = L.DoNotFallThisDay, appliedBy = {L.DoNotFallThisDay}},
    {class = "RuneKeeper", skillName = L.ShallNotFallThisDay, appliedBy = {L.ShallNotFallThisDay}},
    {class = "RuneKeeper", skillName = L.PreludeToHope, appliedBy = {L.PreludeToHope}},
    {class = "RuneKeeper", skillName = L.RuneOfRestoration, appliedBy = {L.RuneOfRestoration}},
    {class = "RuneKeeper", skillName = L.WritOfHealthTier1, appliedBy = {L.WritOfHealthTier1}},
    {class = "RuneKeeper", skillName = L.WritOfHealthTier2, appliedBy = {L.WritOfHealthTier2}},
    {class = "RuneKeeper", skillName = L.WritOfHealthTier3, appliedBy = {L.WritOfHealthTier3}},
    {class = "RuneKeeper", skillName = L.GloriousForeshadowing, appliedBy = {L.GloriousForeshadowing}},
    {class = "RuneKeeper", skillName = L.WondrousForeshadowing, appliedBy = {L.WondrousForeshadowing}},
    {class = "RuneKeeper", skillName = L.AllFatesEntwined, appliedBy = {L.AllFatesEntwined}},
    {class = "RuneKeeper", skillName = L.OurFatesEntwined, appliedBy = {L.OurFatesEntwined}},
    
    {class = "Warden", skillName = L.EncouragingRoar, appliedBy = {L.EncouragingRoar}},
    
    {class = "Beorning", skillName = L.Conviction, appliedBy = {L.Conviction}},    
    {class = "Beorning", skillName = L.RejuvenatingBellow, appliedBy = {L.RejuvenatingBellow}},    
    
    {class = "Racial", skillName = L.DutyBound, appliedBy = {L.DutyBound}},
    {class = "Racial", skillName = L.DwarfEndurance, appliedBy = {L.DwarfEndurance}}
  });
  
  -- Self Buffs
  
  if (player.class == "Burglar") then
    table.insert(traits.buffs, {class = "Burglar", skillName = L.Mischievous, isStance = true, appliedBy = {L.Mischievous}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.QuietKnife, isStance = true, appliedBy = {L.QuietKnife}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.Gambler, isStance = true, appliedBy = {L.Gambler}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.TouchAndGo, appliedBy = {L.TouchAndGo}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.KnivesOut, appliedBy = {L.KnivesOut}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.TheMischiefMaker, appliedBy = {L.TheMischiefMaker}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.TheQuietKnife, appliedBy = {L.TheQuietKnife}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.TheGambler, appliedBy = {L.TheGambler}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.Feint, appliedBy = {L.Feint}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.ImprovedFeint, appliedBy = {L.ImprovedFeint}});
    table.insert(traits.buffs, {class = "Burglar", skillName = L.ArmourOfTheUnseen, stacking = {L.ArmourOfTheUnseen.." (5%)", L.ArmourOfTheUnseen.." (10%)", L.ArmourOfTheUnseen.." (15%)", L.ArmourOfTheUnseen.." (20%)"}, appliedBy = {L.ArmourOfTheUnseen}});
    table.insert(traits.buffs, {class = "Item", skillName = L.VagabondsCraft, appliedBy = {L.VagabondsCraft}});
    
  elseif (player.class == "Captain") then
    table.insert(traits.buffs, {class = "Captain", skillName = L.DefensiveStrike, appliedBy = {L.DefensiveStrike}});
    table.insert(traits.buffs, {class = "Captain", skillName = L.ImprovedDefensiveStrike, appliedBy = {L.ImprovedDefensiveStrike}});
    table.insert(traits.buffs, {class = "Captain", skillName = L.LastStand, appliedBy = {L.LastStand}});
    
  elseif (player.class == "Champion") then
    table.insert(traits.buffs, {class = "Champion", skillName = L.Fervour, isStance = true, appliedBy = {L.Fervour}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.Glory, isStance = true, appliedBy = {L.Glory}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.Ardour, isStance = true, appliedBy = {L.Ardour}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.ControlledBurn, appliedBy = {L.ControlledBurn}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.Flurry, appliedBy = {L.Flurry}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.SuddenDefence, appliedBy = {L.SuddenDefence}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.SeekingBlades, appliedBy = {L.SeekingBlades}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.Adamant, appliedBy = {L.Adamant}});
    table.insert(traits.buffs, {class = "Champion", skillName = L.Invincible, appliedBy = {L.Invincible}});
    
  elseif (player.class == "Guardian") then
    table.insert(traits.buffs, {class = "Guardian", skillName = L.GuardiansBlockStance, isStance = true, appliedBy = {L.GuardiansBlockStance}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.GuardiansParryStance, isStance = true, appliedBy = {L.GuardiansParryStance}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.Overpower, isStance = true, appliedBy = {L.Overpower}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.GuardiansThreatStance, isStance = true, appliedBy = {L.GuardiansThreatStance}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.GuardiansPledge, appliedBy = {L.GuardiansPledge}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.GuardiansWard, appliedBy = {L.GuardiansWard}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.ImprovedGuardiansWard, appliedBy = {L.ImprovedGuardiansWard}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.GuardiansWardTactics, appliedBy = {L.GuardiansWardTactics}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.ImprovedGuardiansWardTactics, appliedBy = {L.ImprovedGuardiansWardTactics}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.WarriorsBlock, appliedBy = {L.WarriorsBlock}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.WarriorsParry, appliedBy = {L.WarriorsParry}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.WarriorsPower, appliedBy = {L.WarriorsPower}});
    table.insert(traits.buffs, {class = "Guardian", skillName = L.WarriorsThreat, appliedBy = {L.WarriorsThreat}});
    
  elseif (player.class == "Hunter") then
    table.insert(traits.buffs, {class = "Hunter", skillName = L.StanceStrength, isStance = true, appliedBy = {L.StanceStrength}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.StancePrecision, isStance = true, appliedBy = {L.StancePrecision}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.StanceEndurance, isStance = true, appliedBy = {L.StanceEndurance}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.BurnHot, appliedBy = {L.BurnHot}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.CoolBurn, appliedBy = {L.CoolBurn}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.Fleetness, appliedBy = {L.Fleetness}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.ImprovedFleetness, appliedBy = {L.ImprovedFleetness}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.SwiftStroke, appliedBy = {L.SwiftStroke}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.NeedfulHaste, appliedBy = {L.NeedfulHaste}});
    table.insert(traits.buffs, {class = "Hunter", skillName = L.HuntersArt, appliedBy = {L.HuntersArt}});
    table.insert(traits.buffs, {class = "Item", skillName = L.VagabondsCraft, appliedBy = {L.VagabondsCraft}});
    
  elseif (player.class == "Minstrel") then
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.Harmony, isStance = true, appliedBy = {L.Harmony}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.WarSpeech, isStance = true, appliedBy = {L.WarSpeech}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.AnthemOfCompassion, appliedBy = {L.AnthemOfCompassion}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.AnthemOfTheThirdAge, appliedBy = {L.AnthemOfTheThirdAge}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.AnthemOfTheThirdAgeWarSpeech, appliedBy = {L.AnthemOfTheThirdAgeWarSpeech}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.AnthemOfTheThirdAgeHarmony, appliedBy = {L.AnthemOfTheThirdAgeHarmony}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.MinorBallad, appliedBy = {L.MinorBallad}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.MajorBallad, appliedBy = {L.MajorBallad}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.PerfectBallad, appliedBy = {L.PerfectBallad}});
    table.insert(traits.buffs, {class = "Minstrel", skillName = L.StillAsDeath, appliedBy = {L.StillAsDeath}});
    
  elseif (player.class == "Warden") then
    table.insert(traits.buffs, {class = "Warden", skillName = L.DeterminationStance, isStance = true, appliedBy = {L.DeterminationStance}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.Conservation, isStance = true, appliedBy = {L.Conservation}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.Recklessness, isStance = true, appliedBy = {L.Recklessness}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.WayOfTheWarden, appliedBy = {L.WayOfTheWarden}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.ShieldBashBlock, appliedBy = {L.ShieldBashBlock}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.WallOfSteelParry, appliedBy = {L.WallOfSteelParry}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.AdroitManoeuvre, appliedBy = {L.AdroitManoeuvre}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.WardensTriumph, appliedBy = {L.WardensTriumph}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.DefensiveStrikeBlock, appliedBy = {L.DefensiveStrikeBlock}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.Persevere, appliedBy = {L.Persevere}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.ShieldDefence, appliedBy = {L.ShieldDefence}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.ShieldMastery, appliedBy = {L.ShieldMastery}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.ShieldTactics, appliedBy = {L.ShieldTactics}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.DanceOfBattleEvade, appliedBy = {L.DanceOfBattleEvade}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.TacticallySound, appliedBy = {L.TacticallySound}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.T1HealOverTime, appliedBy = {L.T1HealOverTime}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.T2HealOverTime, appliedBy = {L.T2HealOverTime}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.T3HealOverTime, appliedBy = {L.T3HealOverTime}});
    table.insert(traits.buffs, {class = "Warden", skillName = L.T4HealOverTime, appliedBy = {L.T4HealOverTime}});
  
  elseif (player.class == "Beorning") then
    table.insert(traits.buffs, {class = "Beorning", skillName = L.BracingRoar, appliedBy = {L.BracingRoar}});
    table.insert(traits.buffs, {class = "Beorning", skillName = L.ThickenedHide, appliedBy = {L.ThickenedHide}});
    table.insert(traits.buffs, {class = "Beorning", skillName = L.Counter, appliedBy = {L.Counter}});
    table.insert(traits.buffs, {class = "Beorning", skillName = L.CallToWild, appliedBy = {L.CallToWild}});
    
  end
  
  -- Debuffs
  
  if (player.class == "Burglar") then
    traits.configurations[L.TheQuietKnife] = { color = "Red" }
    traits.configurations[L.TheMischiefMaker] = { color = "Yellow" }
    traits.configurations[L.TheGambler] = { color = "Blue" }
    traits.selected = L.TheQuietKnife;
    
    traits.configurations[L.TheQuietKnife].debuffs = {}
    traits.configurations[L.TheMischiefMaker].debuffs = {}
    traits.configurations[L.TheGambler].debuffs = {}
    
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.RevealWeakness, iconName = "reveal_weakness.tga", toggleSkill = true, overwrites = {L.RevealWeakness}, appliedBy = {{skillName = L.RevealWeakness}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Addle, iconName = "addle.tga", overwrites = {L.Addle}, appliedBy = {{skillName = L.Addle, duration = 30}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickDisable, iconName = "disable.tga", overwrites = {L.TrickDisable,L.TrickCounterDefence,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.TrickDisable, duration = 30}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickCounterDefence, iconName = "counter_defence.tga", overwrites = {L.TrickCounterDefence,L.TrickDustInTheEyes,L.TrickEnrage}, conflicts = {L.TrickDisable}, appliedBy = {{skillName = L.TrickCounterDefence, duration = 30}, {skillName = L.TrickImprovedCounterDefence, duration = 30}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickDustInTheEyes, iconName = "dust_in_the_eyes.tga", overwrites = {L.TrickDustInTheEyes,L.TrickCounterDefence,L.TrickEnrage}, conflicts = {L.TrickDisable}, appliedBy = {{skillName = L.TrickDustInTheEyes, duration = 30}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Slowed, iconName = "slowed.tga", overwrites = {L.Slowed}, appliedBy = {{skillName = L.TrickDustInTheEyes, duration = 30}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickEnrage, iconName = "enrage.tga", overwrites = {L.TrickEnrage,L.TrickCounterDefence,L.TrickDustInTheEyes}, conflicts = {L.TrickDisable}, appliedBy = {{skillName = L.TrickEnrage, duration = 30}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.ASmallSnag, iconName = "small_snag.tga", overwrites = {L.ASmallSnag}, appliedBy = {{skillName = L.ASmallSnag, duration = 15}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Confound, iconName = "confound.tga", overwrites = {L.Confound}, appliedBy = {{skillName = L.Confound, duration = 15}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.MischievousDelight, removalOnly = true, iconName = "default.tga", overwrites = {L.MischievousDelight,L.TrickCounterDefence,L.TrickDisable,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.MischievousDelight}, {skillName = L.MischievousGlee}}});
    table.insert(traits.configurations[L.TheQuietKnife].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.StartlingTwist, removalOnly = true, iconName = "default.tga", overwrites = {L.StartlingTwist,L.TrickCounterDefence,L.TrickDisable,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.StartlingTwist}, {skillName = L.ImprovedStartlingTwist}, {skillName = L.AdvancedStartlingTwist}}});
    
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.RevealWeakness, iconName = "reveal_weakness.tga", toggleSkill = true, overwrites = {L.RevealWeakness}, appliedBy = {{skillName = L.RevealWeakness}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Addle, iconName = "addle.tga", overwrites = {L.Addle}, appliedBy = {{skillName = L.Addle, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickDisable, iconName = "disable.tga", overwrites = {L.TrickDisable,L.TrickCounterDefence,L.TrickDustInTheEyes,L.TrickEnrage}, buffEffects = {{skillName = L.Mischievous, duration = 10}}, appliedBy = {{skillName = L.TrickDisable, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickCounterDefence, iconName = "counter_defence.tga", overwrites = {L.TrickCounterDefence,L.TrickDustInTheEyes,L.TrickEnrage}, conflicts = {L.TrickDisable}, buffEffects = {{skillName = L.Mischievous, duration = 10}}, appliedBy = {{skillName = L.TrickCounterDefence, duration = 30}, {skillName = L.TrickImprovedCounterDefence, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickDustInTheEyes, iconName = "dust_in_the_eyes.tga", overwrites = {L.TrickDustInTheEyes,L.TrickCounterDefence,L.TrickEnrage}, conflicts = {L.TrickDisable}, buffEffects = {{skillName = L.Mischievous, duration = 10}}, appliedBy = {{skillName = L.TrickDustInTheEyes, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Slowed, iconName = "slowed.tga", overwrites = {L.Slowed}, buffEffects = {{skillName = L.Mischievous, duration = 10}}, appliedBy = {{skillName = L.TrickDustInTheEyes, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickEnrage, iconName = "enrage.tga", overwrites = {L.TrickEnrage,L.TrickCounterDefence,L.TrickDustInTheEyes}, conflicts = {L.TrickDisable}, buffEffects = {{skillName = L.Mischievous, duration = 10}}, appliedBy = {{skillName = L.TrickEnrage, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.ASmallSnag, iconName = "small_snag.tga", overwrites = {L.ASmallSnag}, appliedBy = {{skillName = L.ASmallSnag, duration = 15}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.QuiteASnag, iconName = "quite_a_snag.tga", overwrites = {L.QuiteASnag}, appliedBy = {{skillName = L.QuiteASnag, duration = 30}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Confound, iconName = "confound.tga", overwrites = {L.Confound}, appliedBy = {{skillName = L.Confound, duration = 15}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.MischievousDelight, removalOnly = true, iconName = "default.tga", overwrites = {L.MischievousDelight,L.TrickCounterDefence,L.TrickDisable,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.MischievousDelight}, {skillName = L.MischievousGlee}}});
    table.insert(traits.configurations[L.TheMischiefMaker].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.StartlingTwist, removalOnly = true, iconName = "default.tga", overwrites = {L.StartlingTwist,L.TrickCounterDefence,L.TrickDisable,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.StartlingTwist}, {skillName = L.ImprovedStartlingTwist}, {skillName = L.AdvancedStartlingTwist}}});
    
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.RevealWeakness, iconName = "reveal_weakness.tga", toggleSkill = true, overwrites = {L.RevealWeakness}, appliedBy = {{skillName = L.RevealWeakness}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Addle, iconName = "addle.tga", overwrites = {L.Addle}, appliedBy = {{skillName = L.Addle, duration = 30}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickDisable, iconName = "disable.tga", overwrites = {L.TrickDisable,L.TrickCounterDefence,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.TrickDisable, duration = 30}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickCounterDefence, iconName = "counter_defence.tga", overwrites = {L.TrickCounterDefence,L.TrickDustInTheEyes,L.TrickEnrage}, conflicts = {L.TrickDisable}, appliedBy = {{skillName = L.TrickCounterDefence, duration = 30}, {skillName = L.TrickImprovedCounterDefence, duration = 30}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickDustInTheEyes, iconName = "dust_in_the_eyes.tga", overwrites = {L.TrickDustInTheEyes,L.TrickCounterDefence,L.TrickEnrage}, conflicts = {L.TrickDisable}, appliedBy = {{skillName = L.TrickDustInTheEyes, duration = 30}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Slowed, iconName = "slowed.tga", overwrites = {L.Slowed}, appliedBy = {{skillName = L.TrickDustInTheEyes, duration = 30}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.TrickEnrage, iconName = "enrage.tga", overwrites = {L.TrickEnrage,L.TrickCounterDefence,L.TrickDustInTheEyes}, conflicts = {L.TrickDisable}, appliedBy = {{skillName = L.TrickEnrage, duration = 30}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.ASmallSnag, iconName = "small_snag.tga", overwrites = {L.ASmallSnag}, appliedBy = {{skillName = L.ASmallSnag, duration = 15}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.Confound, iconName = "confound.tga", overwrites = {L.Confound}, appliedBy = {{skillName = L.Confound, duration = 15}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.MischievousDelight, removalOnly = true, iconName = "default.tga", overwrites = {L.MischievousDelight,L.TrickCounterDefence,L.TrickDisable,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.MischievousDelight}, {skillName = L.MischievousGlee}}});
    table.insert(traits.configurations[L.TheGambler].debuffs, {ca = true, bb = true, class = "Burglar", skillName = L.StartlingTwist, removalOnly = true, iconName = "default.tga", overwrites = {L.StartlingTwist,L.TrickCounterDefence,L.TrickDisable,L.TrickDustInTheEyes,L.TrickEnrage}, appliedBy = {{skillName = L.StartlingTwist}, {skillName = L.ImprovedStartlingTwist}, {skillName = L.AdvancedStartlingTwist}}});
    
  elseif (player.class == "Captain") then
    traits.configurations[L.LeadTheCharge] = { color = "Red" }
    traits.configurations[L.LeaderOfMen] = { color = "Yellow" }
    traits.configurations[L.HandsOfHealing] = { color = "Blue" }
    traits.selected = L.LeaderOfMen;
    
    traits.configurations[L.LeadTheCharge].debuffs = {}
    traits.configurations[L.LeaderOfMen].debuffs = {}
    traits.configurations[L.HandsOfHealing].debuffs = {}
    
    table.insert(traits.configurations[L.LeadTheCharge].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.NobleMark, iconName = "noble_mark.tga", toggleSkill = true, overwrites = {L.NobleMark,L.RevealingMark,L.TellingMark}, appliedBy = {{skillName = L.NobleMark}}});
    table.insert(traits.configurations[L.LeadTheCharge].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.TellingMark, iconName = "telling_mark.tga", toggleSkill = true, overwrites = {L.TellingMark,L.NobleMark,L.RevealingMark}, appliedBy = {{skillName = L.TellingMark}}});
    table.insert(traits.configurations[L.LeadTheCharge].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.RevealingMark, iconName = "revealing_mark.tga", toggleSkill = true, overwrites = {L.RevealingMark,L.NobleMark,L.TellingMark}, appliedBy = {{skillName = L.RevealingMark}}});
    
    table.insert(traits.configurations[L.LeaderOfMen].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.NobleMark, iconName = "noble_mark.tga", toggleSkill = true, overwrites = {L.NobleMark,L.RevealingMark,L.TellingMark}, appliedBy = {{skillName = L.NobleMark}}});
    table.insert(traits.configurations[L.LeaderOfMen].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.TellingMark, iconName = "telling_mark.tga", toggleSkill = true, overwrites = {L.TellingMark,L.NobleMark,L.RevealingMark}, appliedBy = {{skillName = L.TellingMark}}});
    table.insert(traits.configurations[L.LeaderOfMen].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.RevealingMark, iconName = "revealing_mark.tga", toggleSkill = true, overwrites = {L.RevealingMark,L.NobleMark,L.TellingMark}, appliedBy = {{skillName = L.RevealingMark}}});
    
    table.insert(traits.configurations[L.HandsOfHealing].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.NobleMark, iconName = "noble_mark.tga", toggleSkill = true, overwrites = {L.NobleMark,L.RevealingMark,L.TellingMark}, appliedBy = {{skillName = L.NobleMark}}});
    table.insert(traits.configurations[L.HandsOfHealing].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.TellingMark, iconName = "telling_mark.tga", toggleSkill = true, overwrites = {L.TellingMark,L.NobleMark,L.RevealingMark}, appliedBy = {{skillName = L.TellingMark}}});
    table.insert(traits.configurations[L.HandsOfHealing].debuffs, {ca = true, bb = true, class = "Captain", skillName = L.RevealingMark, iconName = "revealing_mark.tga", toggleSkill = true, overwrites = {L.RevealingMark,L.NobleMark,L.TellingMark}, appliedBy = {{skillName = L.RevealingMark}}});
    
  elseif (player.class == "Champion") then
    traits.configurations[L.TheBerserker] = { color = "Red" }
    traits.configurations[L.TheDeadlyStorm] = { color = "Yellow" }
    traits.configurations[L.TheMartialChampion] = { color = "Blue" }
    traits.selected = L.TheBerserker;
    
    traits.configurations[L.TheBerserker].debuffs = {}
    traits.configurations[L.TheDeadlyStorm].debuffs = {}
    traits.configurations[L.TheMartialChampion].debuffs = {}
    
    table.insert(traits.configurations[L.TheBerserker].debuffs, {ca = true, bb = true, class = "Champion", skillName = L.Hamstring, iconName = "hamstring.tga", overwrites = {L.Hamstring}, appliedBy = {{skillName = L.Hamstring, duration = 20}}});
    
    table.insert(traits.configurations[L.TheDeadlyStorm].debuffs, {ca = true, bb = true, class = "Champion", skillName = L.Hamstring, iconName = "hamstring.tga", overwrites = {L.Hamstring}, appliedBy = {{skillName = L.Hamstring, duration = 20}}});
    
    table.insert(traits.configurations[L.TheMartialChampion].debuffs, {ca = true, bb = true, class = "Champion", skillName = L.Hamstring, iconName = "hamstring.tga", overwrites = {L.Hamstring}, appliedBy = {{skillName = L.Hamstring, duration = 20}}});
    
  elseif (player.class == "Guardian") then
    traits.configurations[L.TheKeenBlade] = { color = "Red" }
    traits.configurations[L.TheFighterOfShadow] = { color = "Yellow" }
    traits.configurations[L.TheDefenderOfTheFree] = { color = "Blue" }
    traits.selected = L.TheFighterOfShadow;
    
    traits.configurations[L.TheKeenBlade].debuffs = {}
    traits.configurations[L.TheFighterOfShadow].debuffs = {}
    traits.configurations[L.TheDefenderOfTheFree].debuffs = {}
    
    table.insert(traits.configurations[L.TheKeenBlade].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.Challenge, iconName = "challenge.tga", overwrites = {L.Challenge}, appliedBy = {{skillName = L.Challenge, duration = 10}, {skillName = L.ImprovedChallenge, duration = 10}, {skillName = L.ChallengeTheDarkness, duration = 10}}});
    table.insert(traits.configurations[L.TheKeenBlade].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.ImprovedOverwhelm, iconName = "overwhelm.tga", overwrites = {L.ImprovedOverwhelm}, appliedBy = {{skillName = L.ImprovedOverwhelm, duration = 10}}});
    table.insert(traits.configurations[L.TheKeenBlade].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.ImminentCleansing, iconName = "imminent_cleansing.tga", conflicts = {L.ImminentCleansing}, appliedBy = {{skillName = L.ImprovedSting, duration = 10}}});
    
    table.insert(traits.configurations[L.TheFighterOfShadow].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.Challenge, iconName = "challenge.tga", overwrites = {L.Challenge}, appliedBy = {{skillName = L.Challenge, duration = 10}, {skillName = L.ImprovedChallenge, duration = 10}, {skillName = L.ChallengeTheDarkness, duration = 10}}});
    table.insert(traits.configurations[L.TheFighterOfShadow].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.ImprovedOverwhelm, iconName = "overwhelm.tga", overwrites = {L.ImprovedOverwhelm}, appliedBy = {{skillName = L.ImprovedOverwhelm, duration = 10}}});
    table.insert(traits.configurations[L.TheFighterOfShadow].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.ImminentCleansing, iconName = "imminent_cleansing.tga", conflicts = {L.ImminentCleansing}, appliedBy = {{skillName = L.ImprovedSting, duration = 10}}});
    
    table.insert(traits.configurations[L.TheDefenderOfTheFree].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.Challenge, iconName = "challenge.tga", overwrites = {L.Challenge}, appliedBy = {{skillName = L.Challenge, duration = 13}, {skillName = L.ImprovedChallenge, duration = 13}, {skillName = L.ChallengeTheDarkness, duration = 10}}});
    table.insert(traits.configurations[L.TheDefenderOfTheFree].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.ImprovedOverwhelm, iconName = "overwhelm.tga", overwrites = {L.ImprovedOverwhelm}, appliedBy = {{skillName = L.ImprovedOverwhelm, duration = 10}}});
    table.insert(traits.configurations[L.TheDefenderOfTheFree].debuffs, {ca = true, bb = true, class = "Guardian", skillName = L.ImminentCleansing, iconName = "imminent_cleansing.tga", conflicts = {L.ImminentCleansing}, appliedBy = {{skillName = L.ImprovedSting, duration = 10}}});
    
  elseif (player.class == "Hunter") then
    traits.configurations[L.TheBowmaster] = { color = "Red" }
    traits.configurations[L.TheTrapperOfFoes] = { color = "Yellow" }
    traits.configurations[L.TheHuntsman] = { color = "Blue" }
    traits.selected = L.TheHuntsman;
    
    traits.configurations[L.TheBowmaster].debuffs = {}
    traits.configurations[L.TheTrapperOfFoes].debuffs = {}
    traits.configurations[L.TheHuntsman].debuffs = {}
    
    table.insert(traits.configurations[L.TheBowmaster].debuffs, {ca = true, bb = true, class = "Hunter", skillName = L.CripplingShot, iconName = "crippling_shot.tga", overwrites = {L.CripplingShot,L.SlowingCut}, appliedBy = {{skillName = L.LowCut, duration = 10}}});
    table.insert(traits.configurations[L.TheBowmaster].debuffs, {ca = true, bb = true, class = "Hunter", skillName = L.SlowingCut, iconName = "crippling_shot.tga", overwrites = {L.SlowingCut,L.CripplingShot}, buffEffects = {{skillName = L.StanceStrength, duration = 8}}, appliedBy = {{skillName = L.QuickShot, duration = 0}}});
    
    table.insert(traits.configurations[L.TheTrapperOfFoes].debuffs, {ca = true, bb = true, class = "Hunter", skillName = L.CripplingShot, iconName = "crippling_shot.tga", overwrites = {L.CripplingShot,L.SlowingCut}, appliedBy = {{skillName = L.LowCut, duration = 10}}});
    table.insert(traits.configurations[L.TheTrapperOfFoes].debuffs, {ca = true, bb = true, class = "Hunter", skillName = L.SlowingCut, iconName = "crippling_shot.tga", overwrites = {L.SlowingCut,L.CripplingShot}, buffEffects = {{skillName = L.StanceStrength, duration = 8}}, appliedBy = {{skillName = L.QuickShot, duration = 0}}});
    
    table.insert(traits.configurations[L.TheHuntsman].debuffs, {ca = true, bb = true, class = "Hunter", skillName = L.CripplingShot, iconName = "crippling_shot.tga", overwrites = {L.CripplingShot,L.SlowingCut}, appliedBy = {{skillName = L.LowCut, duration = 10}}});
    table.insert(traits.configurations[L.TheHuntsman].debuffs, {ca = true, bb = true, class = "Hunter", skillName = L.SlowingCut, iconName = "crippling_shot.tga", overwrites = {L.SlowingCut,L.CripplingShot}, buffEffects = {{skillName = L.StanceStrength, duration = 8}}, appliedBy = {{skillName = L.QuickShot, duration = 0}}});
    
  elseif (player.class == "LoreMaster") then
    traits.configurations[L.MasterOfNaturesFury] = { color = "Red" }
    traits.configurations[L.TheAncientMaster] = { color = "Yellow" }
    traits.configurations[L.TheKeeperOfAnimals] = { color = "Blue" }
    traits.selected = L.TheAncientMaster;
    
    traits.configurations[L.MasterOfNaturesFury].debuffs = {}
    traits.configurations[L.TheAncientMaster].debuffs = {}
    traits.configurations[L.TheKeeperOfAnimals].debuffs = {}
    
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.GustOfWind, iconName = "gust_of_wind.tga", overwrites = {L.GustOfWind}, appliedBy = {{skillName = L.GustOfWind, duration = 120}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.FireLore, iconName = "fire_lore.tga", overwrites = {L.FireLore}, appliedBy = {{skillName = L.FireLore, duration = 30}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.WindLore, iconName = "wind_lore.tga", overwrites = {L.WindLore}, appliedBy = {{skillName = L.WindLore, duration = 30}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.FrostLore, iconName = "frost_lore.tga", overwrites = {L.FrostLore}, appliedBy = {{skillName = L.FrostLore, duration = 30}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.AncientCraft, iconName = "ancient_craft.tga", overwrites = {L.AncientCraft}, appliedBy = {{skillName = L.AncientCraft, duration = 30}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.SignOfPowerCommand, iconName = "sign_of_power_command.tga", overwrites = {L.SignOfPowerCommand}, appliedBy = {{skillName = L.SignOfPowerCommand, duration = 30}, {skillName = L.ImprovedSignOfPowerCommand, duration = 30}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.SignOfPowerSeeAllEnds, iconName = "sign_of_power_see_all_ends.tga", overwrites = {L.SignOfPowerSeeAllEnds}, appliedBy = {{skillName = L.SignOfPowerSeeAllEnds, duration = 15}}});
    table.insert(traits.configurations[L.MasterOfNaturesFury].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.CrackedEarth, iconName = "cracked_earth.tga", overwrites = {L.CrackedEarth}, appliedBy = {{skillName = L.CrackedEarth, duration = 10}}});
    
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.GustOfWind, iconName = "gust_of_wind.tga", overwrites = {L.GustOfWind}, appliedBy = {{skillName = L.GustOfWind, duration = 120}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.FireLore, iconName = "fire_lore.tga", conflicts = {L.FireLore}, appliedBy = {{skillName = L.FireLore, duration = 45}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.WindLore, iconName = "wind_lore.tga", overwrites = {L.WindLore}, appliedBy = {{skillName = L.WindLore, duration = 30}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.FrostLore, iconName = "frost_lore.tga", conflicts = {L.FrostLore}, appliedBy = {{skillName = L.FrostLore, duration = 45}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.AncientCraft, iconName = "ancient_craft.tga", overwrites = {L.AncientCraft}, appliedBy = {{skillName = L.AncientCraft, duration = 60}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.SignOfPowerCommand, iconName = "sign_of_power_command.tga", overwrites = {L.SignOfPowerCommand}, appliedBy = {{skillName = L.SignOfPowerCommand, duration = 60}, {skillName = L.ImprovedSignOfPowerCommand, duration = 60}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.SignOfPowerSeeAllEnds, iconName = "sign_of_power_see_all_ends.tga", overwrites = {L.SignOfPowerSeeAllEnds}, appliedBy = {{skillName = L.SignOfPowerSeeAllEnds, duration = 45}}});
    table.insert(traits.configurations[L.TheAncientMaster].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.CrackedEarth, iconName = "cracked_earth.tga", overwrites = {L.CrackedEarth}, appliedBy = {{skillName = L.CrackedEarth, duration = 5}}});
    
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.GustOfWind, iconName = "gust_of_wind.tga", overwrites = {L.GustOfWind}, appliedBy = {{skillName = L.GustOfWind, duration = 120}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.FireLore, iconName = "fire_lore.tga", overwrites = {L.FireLore}, appliedBy = {{skillName = L.FireLore, duration = 30}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.WindLore, iconName = "wind_lore.tga", overwrites = {L.WindLore}, appliedBy = {{skillName = L.WindLore, duration = 30}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.FrostLore, iconName = "frost_lore.tga", overwrites = {L.FrostLore}, appliedBy = {{skillName = L.FrostLore, duration = 30}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.AncientCraft, iconName = "ancient_craft.tga", overwrites = {L.AncientCraft}, appliedBy = {{skillName = L.AncientCraft, duration = 30}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.SignOfPowerCommand, iconName = "sign_of_power_command.tga", overwrites = {L.SignOfPowerCommand}, appliedBy = {{skillName = L.SignOfPowerCommand, duration = 30}, {skillName = L.ImprovedSignOfPowerCommand, duration = 30}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.SignOfPowerSeeAllEnds, iconName = "sign_of_power_see_all_ends.tga", overwrites = {L.SignOfPowerSeeAllEnds}, appliedBy = {{skillName = L.SignOfPowerSeeAllEnds, duration = 15}}});
    table.insert(traits.configurations[L.TheKeeperOfAnimals].debuffs, {ca = true, bb = true, class = "LoreMaster", skillName = L.CrackedEarth, iconName = "cracked_earth.tga", overwrites = {L.CrackedEarth}, appliedBy = {{skillName = L.CrackedEarth, duration = 10}}});
    
  elseif (player.class == "Minstrel") then
    traits.configurations[L.TheWarriorSkald] = { color = "Red" }
    traits.configurations[L.TheProtectorOfSong] = { color = "Yellow" }
    traits.configurations[L.TheWatcherOfResolve] = { color = "Blue" }
    traits.selected = L.TheWatcherOfResolve;
    
    traits.configurations[L.TheWarriorSkald].debuffs = {}
    traits.configurations[L.TheProtectorOfSong].debuffs = {}
    traits.configurations[L.TheWatcherOfResolve].debuffs = {}
    
    table.insert(traits.configurations[L.TheWarriorSkald].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.CallOfOrome, iconName = "call_of_orome.tga", overwrites = {L.CallOfOrome}, appliedBy = {{skillName = L.CallOfOrome, duration = 10}}});
    table.insert(traits.configurations[L.TheWarriorSkald].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.CryOfTheWizards, iconName = "cry_of_the_wizards.tga", overwrites = {L.CryOfTheWizards}, appliedBy = {{skillName = L.CryOfTheWizards, duration = 15}}});
    table.insert(traits.configurations[L.TheWarriorSkald].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.TimelessEchoesOfBattle, iconName = "echoes_of_battle.tga", toggleSkill = true, overwrites = {L.TimelessEchoesOfBattle}, appliedBy = {{skillName = L.TimelessEchoesOfBattle}}});
    
    table.insert(traits.configurations[L.TheProtectorOfSong].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.CallOfOrome, iconName = "call_of_orome.tga", overwrites = {L.CallOfOrome}, appliedBy = {{skillName = L.CallOfOrome, duration = 10}}});
    table.insert(traits.configurations[L.TheProtectorOfSong].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.TimelessEchoesOfBattle, iconName = "echoes_of_battle.tga", toggleSkill = true, overwrites = {L.EchoesOfBattle,L.TimelessEchoesOfBattle}, appliedBy = {{skillName = L.TimelessEchoesOfBattle}}});
    table.insert(traits.configurations[L.TheProtectorOfSong].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.EchoesOfBattle, iconName = "echoes_of_battle.tga", toggleSkill = true, overwrites = {L.EchoesOfBattle,L.TimelessEchoesOfBattle}, appliedBy = {{skillName = L.EchoesOfBattle}}});
    
    table.insert(traits.configurations[L.TheWatcherOfResolve].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.CallOfOrome, iconName = "call_of_orome.tga", overwrites = {L.CallOfOrome}, appliedBy = {{skillName = L.CallOfOrome, duration = 10}}});
    table.insert(traits.configurations[L.TheWatcherOfResolve].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.TimelessEchoesOfBattle, iconName = "echoes_of_battle.tga", toggleSkill = true, overwrites = {L.EchoesOfBattle,L.TimelessEchoesOfBattle}, appliedBy = {{skillName = L.TimelessEchoesOfBattle}}});
    table.insert(traits.configurations[L.TheWatcherOfResolve].debuffs, {ca = true, bb = true, class = "Minstrel", skillName = L.EchoesOfBattle, iconName = "echoes_of_battle.tga", toggleSkill = true, overwrites = {L.EchoesOfBattle,L.TimelessEchoesOfBattle}, appliedBy = {{skillName = L.EchoesOfBattle}}});
    
  elseif (player.class == "RuneKeeper") then
    traits.configurations[L.CleansingFires] = { color = "Red" }
    traits.configurations[L.SolitaryThunder] = { color = "Yellow" }
    traits.configurations[L.BenedictionsOfPeace] = { color = "Blue" }
    traits.selected = L.SolitaryThunder;
    
    traits.configurations[L.CleansingFires].debuffs = {}
    traits.configurations[L.SolitaryThunder].debuffs = {}
    traits.configurations[L.BenedictionsOfPeace].debuffs = {}
    
  elseif (player.class == "Warden") then
    traits.configurations[L.WayOfTheSpear] = { color = "Red" }
    traits.configurations[L.WayOfTheFist] = { color = "Yellow" }
    traits.configurations[L.WayOfTheShield] = { color = "Blue" }
    traits.selected = L.WayOfTheShield;
    
    traits.configurations[L.WayOfTheSpear].debuffs = {}
    traits.configurations[L.WayOfTheFist].debuffs = {}
    traits.configurations[L.WayOfTheShield].debuffs = {}
    
  elseif (player.class == "Beorning") then
    traits.configurations[L.WayofTheClaw] = { color = "Red" }
    traits.configurations[L.WayofTheRoar] = { color = "Yellow" }
    traits.configurations[L.WayofTheHide] = { color = "Blue" }
    traits.selected = L.WayofTheClaw;
    
    traits.configurations[L.WayofTheClaw].debuffs = {}
    traits.configurations[L.WayofTheRoar].debuffs = {}
    traits.configurations[L.WayofTheHide].debuffs = {}
    
    table.insert(traits.configurations[L.WayofTheHide].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.VigilantRoar, iconName = "vigilant_roar.tga", overwrites = {L.VigilantRoar}, appliedBy = {{skillName = L.VigilantRoar, duration = 10}}});
    table.insert(traits.configurations[L.WayofTheHide].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.AssertiveRoar, iconName = "assertive_roar.tga", overwrites = {L.AssertiveRoar}, appliedBy = {{skillName = L.AssertiveRoar, duration = 10}}});
    table.insert(traits.configurations[L.WayofTheHide].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.SluggishStings, iconName = "sluggish_stings.tga", overwrites = {L.SluggishStings}, appliedBy = {{skillName = L.SluggishStings, duration = 12}}});

    table.insert(traits.configurations[L.WayofTheClaw].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.EnragingSacrifice, iconName = "enraging_sacrifice.tga", overwrites = {L.EnragingSacrifice}, appliedBy = {{skillName = L.EnragingSacrifice, duration = 12}}});
    table.insert(traits.configurations[L.WayofTheClaw].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.DebilitatingBees, iconName = "debilitating_bees.tga", overwrites = {L.DebilitatingBees}, appliedBy = {{skillName = L.DebilitatingBees, duration = 12}}});

    table.insert(traits.configurations[L.WayofTheRoar].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.EncouragingStrike, iconName = "encouraging_strike.tga", overwrites = {L.EncouragingStrike}, appliedBy = {{skillName = L.EncouragingStrike, duration = 20}}});
    table.insert(traits.configurations[L.WayofTheRoar].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.CripplingStings, iconName = "crippling_stings.tga", overwrites = {L.CripplingStings}, appliedBy = {{skillName = L.CripplingStings, duration = 8}}});
    table.insert(traits.configurations[L.WayofTheRoar].debuffs, {ca = true, bb = true, class = "Beorning", skillName = L.CripplingRoar, iconName = "crippling_roar.tga", overwrites = {L.CripplingRoar}, appliedBy = {{skillName = L.CripplingRoar, duration = 20}}});

  else
    traits.configurations[L.Default] = { color = "Red" }
    traits.selected = L.Default;
    traits.configurations[L.Default].debuffs = {}
    
  end
  
  -- Crowd Control
  
  local baseDaze = {class = "OtherClass", skillName = L.Daze, iconName = "cc_daze.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun}, appliedBy = {}};
  local baseFear = {class = "OtherClass", skillName = L.Fear, iconName = "cc_fear.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun}, appliedBy = {}};
  local baseRoot = {class = "OtherClass", skillName = L.Root, iconName = "cc_root.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun}, appliedBy = {}};
  local baseStun = {class = "OtherClass", skillName = L.Stun, iconName = "cc_stun.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun, L.StunImmunity}, appliedBy = {}};
  local baseKnockdown = {class = "OtherClass", skillName = L.Knockdown, iconName = "cc_knockdown.tga", overwrites = {L.Stun, L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.StunImmunity}, appliedBy = {}};
  local baseStunImmunity = {class = "OtherClass", skillName = L.StunImmunity, iconName = "cc_stun_immunity.tga", appliedBy = {}};
  
  if (player.class == "Burglar") then
    traits.configurations[L.TheQuietKnife].crowdControl = {}
    traits.configurations[L.TheMischiefMaker].crowdControl = {}
    traits.configurations[L.TheGambler].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl,daze);
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl,fear);
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl,root);
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl,stun);
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl,stunImmunity);
  
    table.insert(daze.appliedBy, {skillName = L.Confound, delay = 15, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.Riddle, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.ImprovedRiddle, duration = 30});
    table.insert(root.appliedBy, {skillName = L.ASmallSnag, duration = 15});
    table.insert(stun.appliedBy, {skillName = L.StartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.ImprovedStartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.AdvancedStartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier1, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier2, duration = 4});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier3, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.ExploitOpening, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.Trip, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier1, duration = 4});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier2, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier3, duration = 6});
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl, {class = "Burglar", skillName = L.TrickDustInTheEyes, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.TrickDustInTheEyes}}});
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl, {class = "Burglar", skillName = L.TrickEnrage, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.TrickEnrage}}});
    table.insert(traits.configurations[L.TheQuietKnife].crowdControl, {class = "Burglar", skillName = L.MischievousDelight, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.MischievousDelight}, {skillName = L.MischievousGlee}}});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl,daze);
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl,fear);
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl,root);
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl,stun);
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.Confound, delay = 15, duration = 35});
    table.insert(daze.appliedBy, {skillName = L.Riddle, duration = 35});
    table.insert(daze.appliedBy, {skillName = L.ImprovedRiddle, duration = 35});
    table.insert(root.appliedBy, {skillName = L.ASmallSnag, duration = 15});
    table.insert(root.appliedBy, {skillName = L.QuiteASnag, duration = 30});
    table.insert(stun.appliedBy, {skillName = L.StartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.ImprovedStartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.AdvancedStartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier1, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier2, duration = 4});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier3, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.ExploitOpening, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.Trip, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier1, duration = 4});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier2, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier3, duration = 6});
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl, {class = "Burglar", skillName = L.TrickDustInTheEyes, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.TrickDustInTheEyes}}});
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl, {class = "Burglar", skillName = L.TrickEnrage, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.TrickEnrage}}});
    table.insert(traits.configurations[L.TheMischiefMaker].crowdControl, {class = "Burglar", skillName = L.MischievousDelight, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.MischievousDelight}, {skillName = L.MischievousGlee}}});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheGambler].crowdControl,daze);
    table.insert(traits.configurations[L.TheGambler].crowdControl,fear);
    table.insert(traits.configurations[L.TheGambler].crowdControl,root);
    table.insert(traits.configurations[L.TheGambler].crowdControl,stun);
    table.insert(traits.configurations[L.TheGambler].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheGambler].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.Confound, delay = 15, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.Riddle, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.ImprovedRiddle, duration = 30});
    table.insert(root.appliedBy, {skillName = L.ASmallSnag, duration = 15});
    table.insert(stun.appliedBy, {skillName = L.StartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.ImprovedStartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.AdvancedStartlingTwist, duration = 8});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier1, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier2, duration = 4});
    table.insert(stun.appliedBy, {skillName = L.StunDustTier3, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.ExploitOpening, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.Trip, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier1, duration = 4});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier2, duration = 5});
    table.insert(knockdown.appliedBy, {skillName = L.MarblesTier3, duration = 6});
    table.insert(traits.configurations[L.TheGambler].crowdControl, {class = "Burglar", skillName = L.TrickDustInTheEyes, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.TrickDustInTheEyes}}});
    table.insert(traits.configurations[L.TheGambler].crowdControl, {class = "Burglar", skillName = L.TrickEnrage, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.TrickEnrage}}});
    table.insert(traits.configurations[L.TheGambler].crowdControl, {class = "Burglar", skillName = L.MischievousDelight, removalOnly = true, overwrites = {L.Daze, L.Fear}, appliedBy = {{skillName = L.MischievousDelight}, {skillName = L.MischievousGlee}}});
    
  elseif (player.class == "Captain") then
    traits.configurations[L.LeadTheCharge].crowdControl = {}
    traits.configurations[L.LeaderOfMen].crowdControl = {}
    traits.configurations[L.HandsOfHealing].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.LeadTheCharge].crowdControl,daze);
    table.insert(traits.configurations[L.LeadTheCharge].crowdControl,fear);
    table.insert(traits.configurations[L.LeadTheCharge].crowdControl,root);
    table.insert(traits.configurations[L.LeadTheCharge].crowdControl,stun);
    table.insert(traits.configurations[L.LeadTheCharge].crowdControl,knockdown);
    table.insert(traits.configurations[L.LeadTheCharge].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.RoutingCry, duration = 3});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.LeaderOfMen].crowdControl,daze);
    table.insert(traits.configurations[L.LeaderOfMen].crowdControl,fear);
    table.insert(traits.configurations[L.LeaderOfMen].crowdControl,root);
    table.insert(traits.configurations[L.LeaderOfMen].crowdControl,stun);
    table.insert(traits.configurations[L.LeaderOfMen].crowdControl,knockdown);
    table.insert(traits.configurations[L.LeaderOfMen].crowdControl,stunImmunity);
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.HandsOfHealing].crowdControl,daze);
    table.insert(traits.configurations[L.HandsOfHealing].crowdControl,fear);
    table.insert(traits.configurations[L.HandsOfHealing].crowdControl,root);
    table.insert(traits.configurations[L.HandsOfHealing].crowdControl,stun);
    table.insert(traits.configurations[L.HandsOfHealing].crowdControl,knockdown);
    table.insert(traits.configurations[L.HandsOfHealing].crowdControl,stunImmunity);
    
  elseif (player.class == "Champion") then
    traits.configurations[L.TheBerserker].crowdControl = {}
    traits.configurations[L.TheDeadlyStorm].crowdControl = {}
    traits.configurations[L.TheMartialChampion].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheBerserker].crowdControl,daze);
    table.insert(traits.configurations[L.TheBerserker].crowdControl,fear);
    table.insert(traits.configurations[L.TheBerserker].crowdControl,root);
    table.insert(traits.configurations[L.TheBerserker].crowdControl,stun);
    table.insert(traits.configurations[L.TheBerserker].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheBerserker].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.HornOfGondor, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.Horn, duration = 5});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheDeadlyStorm].crowdControl,daze);
    table.insert(traits.configurations[L.TheDeadlyStorm].crowdControl,fear);
    table.insert(traits.configurations[L.TheDeadlyStorm].crowdControl,root);
    table.insert(traits.configurations[L.TheDeadlyStorm].crowdControl,stun);
    table.insert(traits.configurations[L.TheDeadlyStorm].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheDeadlyStorm].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.HornOfGondor, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.Horn, duration = 5});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheMartialChampion].crowdControl,daze);
    table.insert(traits.configurations[L.TheMartialChampion].crowdControl,fear);
    table.insert(traits.configurations[L.TheMartialChampion].crowdControl,root);
    table.insert(traits.configurations[L.TheMartialChampion].crowdControl,stun);
    table.insert(traits.configurations[L.TheMartialChampion].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheMartialChampion].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.HornOfGondor, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.Horn, duration = 5});
    
  elseif (player.class == "Guardian") then
    traits.configurations[L.TheKeenBlade].crowdControl = {}
    traits.configurations[L.TheFighterOfShadow].crowdControl = {}
    traits.configurations[L.TheDefenderOfTheFree].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheKeenBlade].crowdControl,daze);
    table.insert(traits.configurations[L.TheKeenBlade].crowdControl,fear);
    table.insert(traits.configurations[L.TheKeenBlade].crowdControl,root);
    table.insert(traits.configurations[L.TheKeenBlade].crowdControl,stun);
    table.insert(traits.configurations[L.TheKeenBlade].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheKeenBlade].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.Bash, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.ShieldSmash, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.ImprovedOverwhelm, critsOnly = true, duration = 3});
    table.insert(knockdown.appliedBy, {skillName = L.ToTheKing, critsOnly = true, duration = 5});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheFighterOfShadow].crowdControl,daze);
    table.insert(traits.configurations[L.TheFighterOfShadow].crowdControl,fear);
    table.insert(traits.configurations[L.TheFighterOfShadow].crowdControl,root);
    table.insert(traits.configurations[L.TheFighterOfShadow].crowdControl,stun);
    table.insert(traits.configurations[L.TheFighterOfShadow].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheFighterOfShadow].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.Bash, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.ShieldSmash, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.ImprovedOverwhelm, critsOnly = true, duration = 3});
    table.insert(knockdown.appliedBy, {skillName = L.ToTheKing, critsOnly = true, duration = 5});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheDefenderOfTheFree].crowdControl,daze);
    table.insert(traits.configurations[L.TheDefenderOfTheFree].crowdControl,fear);
    table.insert(traits.configurations[L.TheDefenderOfTheFree].crowdControl,root);
    table.insert(traits.configurations[L.TheDefenderOfTheFree].crowdControl,stun);
    table.insert(traits.configurations[L.TheDefenderOfTheFree].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheDefenderOfTheFree].crowdControl,stunImmunity);
    
    table.insert(stun.appliedBy, {skillName = L.Bash, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.ShieldSmash, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.ImprovedOverwhelm, critsOnly = true, duration = 3});
    table.insert(knockdown.appliedBy, {skillName = L.ToTheKing, critsOnly = true, duration = 5});
    
  elseif (player.class == "Hunter") then
    traits.configurations[L.TheBowmaster].crowdControl = {}
    traits.configurations[L.TheTrapperOfFoes].crowdControl = {}
    traits.configurations[L.TheHuntsman].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheBowmaster].crowdControl,daze);
    table.insert(traits.configurations[L.TheBowmaster].crowdControl,fear);
    table.insert(traits.configurations[L.TheBowmaster].crowdControl,root);
    table.insert(traits.configurations[L.TheBowmaster].crowdControl,stun);
    table.insert(traits.configurations[L.TheBowmaster].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheBowmaster].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.DazingBlow, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.ImprovedDazingBlow, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.DistractingShot, duration = 10});
    table.insert(fear.appliedBy, {skillName = L.CryOfThePredator, duration = 10});
    table.insert(fear.appliedBy, {skillName = L.BardsArrow, duration = 15});
    table.insert(root.appliedBy, {skillName = L.RainOfThorns, duration = 30});
    table.insert(root.appliedBy, {skillName = L.TrapDamage, duration = 30});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheTrapperOfFoes].crowdControl,daze);
    table.insert(traits.configurations[L.TheTrapperOfFoes].crowdControl,fear);
    table.insert(traits.configurations[L.TheTrapperOfFoes].crowdControl,root);
    table.insert(traits.configurations[L.TheTrapperOfFoes].crowdControl,stun);
    table.insert(traits.configurations[L.TheTrapperOfFoes].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheTrapperOfFoes].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.DazingBlow, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.ImprovedDazingBlow, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.DistractingShot, duration = 30});
    table.insert(fear.appliedBy, {skillName = L.CryOfThePredator, duration = 10});
    table.insert(fear.appliedBy, {skillName = L.BardsArrow, duration = 15});
    table.insert(root.appliedBy, {skillName = L.RainOfThorns, duration = 30});
    table.insert(root.appliedBy, {skillName = L.TrapDamage, duration = 30});    
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheHuntsman].crowdControl,daze);
    table.insert(traits.configurations[L.TheHuntsman].crowdControl,fear);
    table.insert(traits.configurations[L.TheHuntsman].crowdControl,root);
    table.insert(traits.configurations[L.TheHuntsman].crowdControl,stun);
    table.insert(traits.configurations[L.TheHuntsman].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheHuntsman].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.DazingBlow, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.ImprovedDazingBlow, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.DistractingShot, duration = 10});
    table.insert(fear.appliedBy, {skillName = L.CryOfThePredator, duration = 10});
    table.insert(fear.appliedBy, {skillName = L.BardsArrow, duration = 15});
    table.insert(root.appliedBy, {skillName = L.RainOfThorns, duration = 30});
    table.insert(root.appliedBy, {skillName = L.TrapDamage, duration = 30});
    
  elseif (player.class == "LoreMaster") then
    traits.configurations[L.MasterOfNaturesFury].crowdControl = {}
    traits.configurations[L.TheAncientMaster].crowdControl = {}
    traits.configurations[L.TheKeeperOfAnimals].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.MasterOfNaturesFury].crowdControl,daze);
    table.insert(traits.configurations[L.MasterOfNaturesFury].crowdControl,fear);
    table.insert(traits.configurations[L.MasterOfNaturesFury].crowdControl,root);
    table.insert(traits.configurations[L.MasterOfNaturesFury].crowdControl,stun);
    table.insert(traits.configurations[L.MasterOfNaturesFury].crowdControl,knockdown);
    table.insert(traits.configurations[L.MasterOfNaturesFury].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.BlindingFlash, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.ImprovedBlindingFlash, duration = 5});
    table.insert(daze.appliedBy, {skillName = L.BaneFlare, duration = 15});
    table.insert(root.appliedBy, {skillName = L.CrackedEarth, delay = 10, duration = 30});
    table.insert(root.appliedBy, {skillName = L.HerbLore, duration = 30});
    table.insert(stun.appliedBy, {skillName = L.StormLore, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.LightOfTheRisingDawn, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.TestOfWill, duration = 5});
    table.insert(stun.appliedBy, {skillName = L.EntsGoToWar, duration = 6});
    table.insert(stun.appliedBy, {skillName = L.ImprovedStaffStrike, critsOnly = true, duration = 5});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheAncientMaster].crowdControl,daze);
    table.insert(traits.configurations[L.TheAncientMaster].crowdControl,fear);
    table.insert(traits.configurations[L.TheAncientMaster].crowdControl,root);
    table.insert(traits.configurations[L.TheAncientMaster].crowdControl,stun);
    table.insert(traits.configurations[L.TheAncientMaster].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheAncientMaster].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.BlindingFlash, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.ImprovedBlindingFlash, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.BaneFlare, duration = 15});
    table.insert(root.appliedBy, {skillName = L.CrackedEarth, delay = 5, duration = 30});
    table.insert(root.appliedBy, {skillName = L.HerbLore, duration = 30});
    table.insert(stun.appliedBy, {skillName = L.StormLore, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.LightOfTheRisingDawn, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.TestOfWill, duration = 5});
    table.insert(stun.appliedBy, {skillName = L.EntsGoToWar, duration = 6});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheKeeperOfAnimals].crowdControl,daze);
    table.insert(traits.configurations[L.TheKeeperOfAnimals].crowdControl,fear);
    table.insert(traits.configurations[L.TheKeeperOfAnimals].crowdControl,root);
    table.insert(traits.configurations[L.TheKeeperOfAnimals].crowdControl,stun);
    table.insert(traits.configurations[L.TheKeeperOfAnimals].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheKeeperOfAnimals].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.BlindingFlash, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.ImprovedBlindingFlash, duration = 30});
    table.insert(daze.appliedBy, {skillName = L.BaneFlare, duration = 15});
    table.insert(root.appliedBy, {skillName = L.CrackedEarth, delay = 10, duration = 30});
    table.insert(root.appliedBy, {skillName = L.HerbLore, duration = 30});
    table.insert(stun.appliedBy, {skillName = L.StormLore, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.LightOfTheRisingDawn, duration = 3});
    table.insert(stun.appliedBy, {skillName = L.TestOfWill, duration = 5});
    table.insert(stun.appliedBy, {skillName = L.EntsGoToWar, duration = 6});
    
  elseif (player.class == "Minstrel") then
    traits.configurations[L.TheWarriorSkald].crowdControl = {}
    traits.configurations[L.TheProtectorOfSong].crowdControl = {}
    traits.configurations[L.TheWatcherOfResolve].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheWarriorSkald].crowdControl,daze);
    table.insert(traits.configurations[L.TheWarriorSkald].crowdControl,fear);
    table.insert(traits.configurations[L.TheWarriorSkald].crowdControl,root);
    table.insert(traits.configurations[L.TheWarriorSkald].crowdControl,stun);
    table.insert(traits.configurations[L.TheWarriorSkald].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheWarriorSkald].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.SongOfTheDead, duration = 30});
    table.insert(fear.appliedBy, {skillName = L.InvocationOfElbereth, duration = 15});
    table.insert(stun.appliedBy, {skillName = L.PiercingCry, duration = 5});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheProtectorOfSong].crowdControl,daze);
    table.insert(traits.configurations[L.TheProtectorOfSong].crowdControl,fear);
    table.insert(traits.configurations[L.TheProtectorOfSong].crowdControl,root);
    table.insert(traits.configurations[L.TheProtectorOfSong].crowdControl,stun);
    table.insert(traits.configurations[L.TheProtectorOfSong].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheProtectorOfSong].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.SongOfTheDead, duration = 30});
    table.insert(fear.appliedBy, {skillName = L.InvocationOfElbereth, duration = 15});
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.TheWatcherOfResolve].crowdControl,daze);
    table.insert(traits.configurations[L.TheWatcherOfResolve].crowdControl,fear);
    table.insert(traits.configurations[L.TheWatcherOfResolve].crowdControl,root);
    table.insert(traits.configurations[L.TheWatcherOfResolve].crowdControl,stun);
    table.insert(traits.configurations[L.TheWatcherOfResolve].crowdControl,knockdown);
    table.insert(traits.configurations[L.TheWatcherOfResolve].crowdControl,stunImmunity);
    
    table.insert(daze.appliedBy, {skillName = L.SongOfTheDead, duration = 30});
    table.insert(fear.appliedBy, {skillName = L.InvocationOfElbereth, duration = 15});
    
  elseif (player.class == "RuneKeeper") then
    traits.configurations[L.CleansingFires].crowdControl = {}
    traits.configurations[L.SolitaryThunder].crowdControl = {}
    traits.configurations[L.BenedictionsOfPeace].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.CleansingFires].crowdControl,daze);
    table.insert(traits.configurations[L.CleansingFires].crowdControl,fear);
    table.insert(traits.configurations[L.CleansingFires].crowdControl,root);
    table.insert(traits.configurations[L.CleansingFires].crowdControl,stun);
    table.insert(traits.configurations[L.CleansingFires].crowdControl,knockdown);
    table.insert(traits.configurations[L.CleansingFires].crowdControl,stunImmunity);
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.SolitaryThunder].crowdControl,daze);
    table.insert(traits.configurations[L.SolitaryThunder].crowdControl,fear);
    table.insert(traits.configurations[L.SolitaryThunder].crowdControl,root);
    table.insert(traits.configurations[L.SolitaryThunder].crowdControl,stun);
    table.insert(traits.configurations[L.SolitaryThunder].crowdControl,knockdown);
    table.insert(traits.configurations[L.SolitaryThunder].crowdControl,stunImmunity);
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.BenedictionsOfPeace].crowdControl,daze);
    table.insert(traits.configurations[L.BenedictionsOfPeace].crowdControl,fear);
    table.insert(traits.configurations[L.BenedictionsOfPeace].crowdControl,root);
    table.insert(traits.configurations[L.BenedictionsOfPeace].crowdControl,stun);
    table.insert(traits.configurations[L.BenedictionsOfPeace].crowdControl,knockdown);
    table.insert(traits.configurations[L.BenedictionsOfPeace].crowdControl,stunImmunity);
    
  elseif (player.class == "Warden") then
    traits.configurations[L.WayOfTheSpear].crowdControl = {}
    traits.configurations[L.WayOfTheFist].crowdControl = {}
    traits.configurations[L.WayOfTheShield].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.WayOfTheSpear].crowdControl,daze);
    table.insert(traits.configurations[L.WayOfTheSpear].crowdControl,fear);
    table.insert(traits.configurations[L.WayOfTheSpear].crowdControl,root);
    table.insert(traits.configurations[L.WayOfTheSpear].crowdControl,stun);
    table.insert(traits.configurations[L.WayOfTheSpear].crowdControl,knockdown);
    table.insert(traits.configurations[L.WayOfTheSpear].crowdControl,stunImmunity);
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.WayOfTheFist].crowdControl,daze);
    table.insert(traits.configurations[L.WayOfTheFist].crowdControl,fear);
    table.insert(traits.configurations[L.WayOfTheFist].crowdControl,root);
    table.insert(traits.configurations[L.WayOfTheFist].crowdControl,stun);
    table.insert(traits.configurations[L.WayOfTheFist].crowdControl,knockdown);
    table.insert(traits.configurations[L.WayOfTheFist].crowdControl,stunImmunity);
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.WayOfTheShield].crowdControl,daze);
    table.insert(traits.configurations[L.WayOfTheShield].crowdControl,fear);
    table.insert(traits.configurations[L.WayOfTheShield].crowdControl,root);
    table.insert(traits.configurations[L.WayOfTheShield].crowdControl,stun);
    table.insert(traits.configurations[L.WayOfTheShield].crowdControl,knockdown);
    table.insert(traits.configurations[L.WayOfTheShield].crowdControl,stunImmunity);

  elseif (player.class == "Beorning") then
    traits.configurations[L.WayofTheHide].crowdControl = {}
    traits.configurations[L.WayofTheClaw].crowdControl = {}
    traits.configurations[L.WayofTheRoar].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    
    table.insert(fear.appliedBy, {skillName = L.GrislyCry, duration = 8});
    
        
  else
    traits.configurations[L.Default].crowdControl = {}
    
    daze = Misc.TableCopy(baseDaze);
    fear = Misc.TableCopy(baseFear);
    root = Misc.TableCopy(baseRoot);
    stun = Misc.TableCopy(baseStun);
    knockdown = Misc.TableCopy(baseKnockdown);
    stunImmunity = Misc.TableCopy(baseStunImmunity);
    
    table.insert(traits.configurations[L.Default].crowdControl,daze);
    table.insert(traits.configurations[L.Default].crowdControl,fear);
    table.insert(traits.configurations[L.Default].crowdControl,root);
    table.insert(traits.configurations[L.Default].crowdControl,stun);
    table.insert(traits.configurations[L.Default].crowdControl,knockdown);
    table.insert(traits.configurations[L.Default].crowdControl,stunImmunity);
    
  end
end

local function pruneIncompleteBuffs(buffSet)
  for i,skillInfo in ipairs(buffSet) do
    if (skillInfo.skillName == "") then
      table.remove(buffSet,i);
      return;
    end
  end
end

local function interpretTraits(reset,restoreFromError)
  -- a) On reload, we prune any incomplete buffs/debuffs
  if (not reset) then
    pruneIncompleteBuffs(traits.tempMorale);
    pruneIncompleteBuffs(traits.buffs);
    for _,configuration in pairs(traits.configurations) do
      pruneIncompleteBuffs(configuration.debuffs);
      pruneIncompleteBuffs(configuration.crowdControl);
    end
  end
  
  -- b) Update the menu
  menuPane:SetTraits(traits,reset and not restoreFromError);
  buffsMenu:SetConfigurationList(traits.configurations);
end

function _G.RestoreDefaultTraits(confirm,restoreFromError)
  if (not confirm) then return end
  
  shutDownAll();
  
  Misc.TableClear(_G.traits);
  restoreV420Traits();
  traits.versionNo = versionNo;
  
  local success = pcall(interpretTraits, true, restoreFromError);
  SaveTraits(true);
  if (not success) then Turbine.Shell.WriteLine("An unexpected error occured while restoring the default trait configurations. Please re-load the plugin before continuing.") end
end

function _G.SetTraitConfiguration(configuration,decoded)
  
  -- Build indexes into the skill list for quick access to skill info
  _G.debuffs = {}
  _G.debuffApplications = {}
  
  _G.cc = {}
  _G.ccApplications = {}
  
  if (configuration == nil) then return end
  
  if (not decoded) then
    configuration = DecodeNumbers(configuration);
  end
  
  -- debuffs
  for _,skillInfo in ipairs(configuration.debuffs) do
    AddSkillInfo("Debuff", skillInfo);
  end
  
  -- crowd control
  for _,skillInfo in ipairs(configuration.crowdControl) do
    AddSkillInfo("CrowdControl", skillInfo);
  end
end

function _G.AddSkillInfo(skillType, skillInfo)
  -- Temp Morale
  if (skillType == "TempMorale") then
    if (tempMoraleSkills[skillInfo.skillName] == nil) then tempMoraleSkills[skillInfo.skillName] = {} end
    if (tempMoraleSkills[skillInfo.logName] == nil) then tempMoraleSkills[skillInfo.logName] = {} end
    
    tempMoraleSkills[skillInfo.skillName][skillInfo.logName] = true;
    tempMoraleSkills[skillInfo.logName][skillInfo.skillName] = true;
    
  -- Buffs
  elseif (skillType == "Buff") then
    buffs[skillInfo.skillName] = {isStance = skillInfo.isStance, stacking = Misc.TableCopy(skillInfo.stacking)};
    for _,applicationName in ipairs(skillInfo.appliedBy) do
      AddOrUpdateBuff(skillInfo.skillName, applicationName);
    end
    
  -- Debuffs
  elseif (skillType == "Debuff") then
    debuffs[skillInfo.skillName] = {ca = skillInfo.ca, bb = skillInfo.bb, removalOnly = skillInfo.removalOnly,
        icon = "CombatAnalysis/Resources/DebuffIcons/"..(skillInfo.iconName ~= nil and skillInfo.iconName or "default.tga"), toggleSkill = skillInfo.toggleSkill,
        overwrites = Misc.TableCopy(skillInfo.overwrites), conflicts = Misc.TableCopy(skillInfo.conflicts), buffEffects = Misc.TableCopy(skillInfo.buffEffects)};
    
    for _,applicationInfo in ipairs(skillInfo.appliedBy) do
      AddOrUpdateDebuff(skillInfo.skillName, applicationInfo);
    end
    
  -- CC
  else
    cc[skillInfo.skillName] = {removalOnly = skillInfo.removalOnly,
        icon = "CombatAnalysis/Resources/DebuffIcons/"..(skillInfo.iconName ~= nil and skillInfo.iconName or "default.tga"), toggleSkill = skillInfo.toggleSkill,
        overwrites = Misc.TableCopy(skillInfo.overwrites), conflicts = Misc.TableCopy(skillInfo.conflicts), buffEffects = Misc.TableCopy(skillInfo.buffEffects)};
    
    for _,applicationInfo in ipairs(skillInfo.appliedBy) do
      AddOrUpdateCC(skillInfo.skillName, applicationInfo);
    end
    
  end
end

function _G.AddOrUpdateBuff(skillName, applicationName)
  if (buffApplications[applicationName] == nil) then
    buffApplications[applicationName] = {}
  end
  
  buffApplications[applicationName][skillName] = true;
end

function _G.AddOrUpdateDebuff(skillName, applicationInfo)
  if (debuffApplications[applicationInfo.skillName] == nil) then
    debuffApplications[applicationInfo.skillName] = {}
  end
  
  debuffApplications[applicationInfo.skillName][skillName] = {critsOnly = applicationInfo.critsOnly, delay = applicationInfo.delay, duration = applicationInfo.duration};
end

function _G.AddOrUpdateCC(skillName, applicationInfo)
  if (ccApplications[applicationInfo.skillName] == nil) then
    ccApplications[applicationInfo.skillName] = {}
  end
  
  ccApplications[applicationInfo.skillName][skillName] = {critsOnly = applicationInfo.critsOnly, delay = applicationInfo.delay, duration = applicationInfo.duration};
end

_G.traits = Turbine.PluginData.Load(Turbine.DataScope.Character,"CombatAnalysisTraits");

-- load the trait configuration settings (will be done once on startup)
function _G.LoadTraits()

	-- 1) Load Traits Settings file
  
	traits = DecodeNumbers(traits);
	local upToDate = true;
	
	-- if no traits file exists (or it is outdated), use the following defaults
	if type(traits) ~= "table" or traits.versionNo == nil or string.gsub(traits.versionNo,"%.","") < string.gsub(versionNo,"%.","") then
		upToDate = false;
		
		if type(traits) ~= "table" then
			_G.traits = {};
		end
		
		-- v4.2.0 traits
		if (traits.versionNo == nil or string.gsub(traits.versionNo,"%.","") < "420") then
      restoreV420Traits();
		end
    
		-- now that all the default traits have been loaded, update the traits versionNo to match the current plugin versionNo
		traits.versionNo = versionNo;
	end
  
  -- 2) Interpret Traits
  interpretTraits();
  
  -- if the traits file has had defaults added, store these values
	if (not upToDate) then SaveTraits() end
end

local traitsSavePending = false;
_G.traitsNeedResaving = false;

local function SaveComplete(success,errorMessage)
  if (not traitsNeedResaving) then
    traitsSavePending = false;
    return;
  end
  
  traitsNeedResaving = false;
  Turbine.PluginData.Save(Turbine.DataScope.Character, "CombatAnalysisTraits", EncodeNumbers(Misc.TableCopy(traits)), SaveComplete);
end

-- global function to save current traits
function _G.SaveTraits(confirm)
  if (not combatAnalysisLoaded and not confirm) then return end
  if (traitsSavePending) then traitsNeedResaving = true; return end
  
  traitsSavePending = true;
	Turbine.PluginData.Save(Turbine.DataScope.Character, "CombatAnalysisTraits", EncodeNumbers(Misc.TableCopy(traits)), SaveComplete);
end









-- fine grained add/update/removal of skill/buff info (only a few cases we care about fire off notify listener calls)

_G.Traits = {}

function Traits.GetBuffSet(buffType)
  return (buffType == "TempMorale" and tempMoraleSkills or (buffType == "Buff" and buffs or (buffType == "Debuff" and debuffs or cc)));
end

function Traits.AddTraitConfiguration(name,color,configurationToCopy)
  if (name == nil or name == "") then return false, L.ConfigurationNameRequired end
  if (traits.configurations[name] ~= nil) then return false, L.ConfigurationNameAlreadyExists end
  if (color == nil) then return false, L.ColorSchemeRequired end
  
  traits.configurations[name] = { color = color, deletable = true }
  
  -- Copy existing configuration
  if (configurationToCopy ~= nil and configurationToCopy ~= "") then
    
    traits.configurations[name].debuffs = Misc.TableCopy(traits.configurations[configurationToCopy].debuffs);
    traits.configurations[name].crowdControl = Misc.TableCopy(traits.configurations[configurationToCopy].crowdControl);
    
  -- Create default CC skills only
  else
    traits.configurations[name].debuffs = {}
    traits.configurations[name].crowdControl = {}
    
    table.insert(traits.configurations[name].crowdControl,{class = "OtherClass", skillName = L.Daze, iconName = "cc_daze.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun}, appliedBy = {}});
    table.insert(traits.configurations[name].crowdControl,{class = "OtherClass", skillName = L.Fear, iconName = "cc_fear.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun}, appliedBy = {}});
    table.insert(traits.configurations[name].crowdControl,{class = "OtherClass", skillName = L.Root, iconName = "cc_root.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun}, appliedBy = {}});
    table.insert(traits.configurations[name].crowdControl,{class = "OtherClass", skillName = L.Stun, iconName = "cc_stun.tga", overwrites = {L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.Stun, L.StunImmunity}, appliedBy = {}});
    table.insert(traits.configurations[name].crowdControl,{class = "OtherClass", skillName = L.Knockdown, iconName = "cc_knockdown.tga", overwrites = {L.Stun, L.Daze, L.Fear, L.Root}, conflicts = {L.Knockdown, L.StunImmunity}, appliedBy = {}});
    table.insert(traits.configurations[name].crowdControl,{class = "OtherClass", skillName = L.StunImmunity, iconName = "cc_stun_immunity.tga", appliedBy = {}});
  end
  
  Misc.NotifyListeners(nil, "traitConfigurationAdded", name);
  SaveTraits();
  return true;
end

function Traits.UpdateTraitConfigurationColor(name,color)
  traits.configurations[name].color = color;
  
  Misc.NotifyListeners(traits.configurations[name], "color", color);
  SaveTraits();
  return true;
end

function Traits.RemoveTraitConfiguration(name,confirm,overrideDeletable)
  if (not confirm) then return end
  
  if (traits.configurations[name] == nil) then return false, "Trait Configuration does not exist" end
  if (not traits.configurations[name].deletable and not overrideDeletable) then return false, "Default Trait Configurations cannot be deleted" end
  
  traits.configurations[name] = nil;
  
  Misc.NotifyListeners(nil, "traitConfigurationRemoved", name);
  SaveTraits();
  return true;
end

function Traits.CreateBuff(buffType)
  local newBuff = nil;
  
  if (buffType == "TempMorale") then
    newBuff = {skillName = "", logName = ""}
  elseif (buffType == "Buff") then
    newBuff = {skillName = "", appliedBy = {}}
  elseif (buffType == "Debuff") then
    newBuff = {ca = true, bb = true, skillName = "", iconName = "default.tga", overwrites = {""}, appliedBy = {}}
  elseif (buffType == "CrowdControl") then
    newBuff = {skillName = "", overwrites = {""}, appliedBy = {}, removalOnly = true}
  end
  
  local buffSet = (buffType == "TempMorale" and traits.tempMorale or (buffType == "Buff" and traits.buffs or (traits.configurations[traits.selected][(buffType == "Debuff" and "debuffs" or "crowdControl")])));
  table.insert(buffSet,newBuff);
  AddSkillInfo(buffType,newBuff);
  
  Misc.NotifyListeners(buffSet,"buffAdded",newBuff);
  SaveTraits();
  return newBuff;
end

function Traits.RemoveBuff(buffType,buff)
  local buffSet = (buffType == "TempMorale" and traits.tempMorale or (buffType == "Buff" and traits.buffs or (traits.configurations[traits.selected][(buffType == "Debuff" and "debuffs" or "crowdControl")])));
  
  -- remove the buff info from the relevant buffSet
  for i,buffInfo in ipairs(buffSet) do
    if (buffInfo == buff) then
      table.remove(buffSet,i);
      break;
    end
  end
  
    -- temp morale
  if (buffType == "TempMorale") then
    tempMoraleSkills[buff.skillName][buff.logName] = nil;
    if (next(tempMoraleSkills[buff.skillName]) == nil) then tempMoraleSkills[buff.skillName] = nil end
    
    if (tempMoraleSkills[buff.logName] ~= nil) then
      tempMoraleSkills[buff.logName][buff.skillName] = nil;
      if (next(tempMoraleSkills[buff.logName]) == nil) then tempMoraleSkills[buff.logName] = nil end
    end
    
  -- buffs
  elseif (buffType == "Buff") then
    buffs[buff.skillName] = nil;
    for _,applicationName in pairs(buff.appliedBy) do
      buffApplications[applicationName][buff.skillName] = nil;
      if (next(buffApplications[applicationName]) == nil) then buffApplications[applicationName] = nil end
    end
    
  -- debuffs/CC
  elseif (buffType == "Debuff") then
    debuffs[buff.skillName] = nil;
    for _,info in pairs(buff.appliedBy) do
      debuffApplications[info.skillName][buff.skillName] = nil;
      if (next(debuffApplications[info.skillName]) == nil) then debuffApplications[info.skillName] = nil end
    end
    
  else
    cc[buff.skillName] = nil;
    for _,info in pairs(buff.appliedBy) do
      ccApplications[info.skillName][buff.skillName] = nil;
      if (next(ccApplications[info.skillName]) == nil) then ccApplications[info.skillName] = nil end
    end
    
  end
  
  Misc.NotifyListeners(buffSet,"buffRemoved",buff);
  SaveTraits();
  return true;
end

function Traits.UpdateClass(buffType,buffInfo,newClass)
  buffInfo.class = newClass;
  
  SaveTraits();
  
  Misc.NotifyListeners(buffInfo,"class",newClass);
  return true;
end

function Traits.UpdateSkillName(buffType,buffInfo,newBuffName)
  if (newBuffName == "") then return false, "A name is required" end
  
  local buffSet = Traits.GetBuffSet(buffType);
  if (buffSet[newBuffName] ~= nil) then
    -- Temp Morale: we need to make sure this is actually an effectName (could be a log name)
    if (buffType == "TempMorale") then
      for _,o in pairs(traits.tempMorale) do
        if (o.skillName == newBuffName) then
          return false, "Another buff with the same name already exists";
        end
      end
    -- Otherwise: must be a duplicate
     else
      return false, "Another buff with the same name already exists";
    end
  end
  
  -- 1) update the buff info
  
  local oldBuffName = buffInfo.skillName;
  buffInfo.skillName = newBuffName;
  
  -- 2) update the indexes in real time
  
  -- temp morale
  if (buffType == "TempMorale") then
    tempMoraleSkills[oldBuffName][buffInfo.logName] = nil;
    if (tempMoraleSkills[newBuffName] == nil) then tempMoraleSkills[newBuffName] = {} end
    tempMoraleSkills[newBuffName][buffInfo.logName] = true;
    
    if (oldBuffName ~= buffInfo.logName) then
      if (next(tempMoraleSkills[oldBuffName]) == nil) then tempMoraleSkills[oldBuffName] = nil end
      tempMoraleSkills[buffInfo.logName][oldBuffName] = nil;
    end
    tempMoraleSkills[buffInfo.logName][newBuffName] = true;
    
  -- buffs
  elseif (buffType == "Buff") then
    local skillInfo = buffs[oldBuffName];
    buffs[oldBuffName] = nil;
    buffs[newBuffName] = skillInfo;
    
    for _,applicationName in pairs(buffInfo.appliedBy) do
      buffApplications[applicationName][oldBuffName] = nil;
      buffApplications[applicationName][newBuffName] = true;    
    end
    
  -- debuffs
  elseif (buffType == "Debuff") then
    local skillInfo = debuffs[oldBuffName];
    debuffs[oldBuffName] = nil;
    debuffs[newBuffName] = skillInfo;
    
    for _,info in pairs(buffInfo.appliedBy) do
      local applicationInfo = debuffApplications[info.skillName][oldBuffName];
      debuffApplications[info.skillName][oldBuffName] = nil;
      debuffApplications[info.skillName][newBuffName] = applicationInfo;
    end
    
  -- CC
  else
    local skillInfo = cc[oldBuffName];
    cc[oldBuffName] = nil;
    cc[newBuffName] = skillInfo;
    
    for _,info in pairs(buffInfo.appliedBy) do      
      local applicationInfo = ccApplications[info.skillName][oldBuffName];
      ccApplications[info.skillName][oldBuffName] = nil;
      ccApplications[info.skillName][newBuffName] = applicationInfo;
    end
    
  end
  
  SaveTraits();
  
  Misc.NotifyListeners(buffInfo,"skillName",newBuffName);
  return true;
end

function Traits.UpdateAppliedByName(buffType,buffInfo,oldSkillName,newSkillName)
  if (newSkillName == "") then return false, "A name is required" end
  
  -- first check for special cases (non-unique names)
  local buffApplicationSet = (buffType == "Buff" and buffApplications or (buffType == "Debuff" and debuffApplications or ccApplications));
  if (buffApplicationSet[newSkillName] ~= nil and buffApplicationSet[newSkillName][buffInfo.skillName] ~= nil) then
    return false, "Another application with the same name already exists for this buff";
  end
  
  for key,appliedByInfo in pairs(buffInfo.appliedBy) do
    if (buffType == "Buff") then
      if (appliedByInfo == oldSkillName) then
        buffInfo.appliedBy[key] = newSkillName;
        break;
      end
    else
      if (appliedByInfo.skillName == oldSkillName) then
        appliedByInfo.skillName = newSkillName;
        break;
      end
    end
  end
  
  -- buffs
  if (buffType == "Buff") then
    buffApplications[oldSkillName][buffInfo.skillName] = nil;
    if (next(buffApplications[oldSkillName]) == nil) then buffApplications[oldSkillName] = nil end
    if (buffApplications[newSkillName] == nil) then buffApplications[newSkillName] = {} end
    buffApplications[newSkillName][buffInfo.skillName] = true;
    
  -- debuffs
  elseif (buffType == "Debuff") then
    local applicationInfo = debuffApplications[oldSkillName][buffInfo.skillName];
    debuffApplications[oldSkillName][buffInfo.skillName] = nil;
    if (next(debuffApplications[oldSkillName]) == nil) then debuffApplications[oldSkillName] = nil end
    if (debuffApplications[newSkillName] == nil) then debuffApplications[newSkillName] = {} end
    debuffApplications[newSkillName][buffInfo.skillName] = applicationInfo;
    
  -- CC
  else
    local applicationInfo = ccApplications[oldSkillName][buffInfo.skillName];
    ccApplications[oldSkillName][buffInfo.skillName] = nil;
    if (next(ccApplications[oldSkillName]) == nil) then ccApplications[oldSkillName] = nil end
    if (ccApplications[newSkillName] == nil) then ccApplications[newSkillName] = {} end
    ccApplications[newSkillName][buffInfo.skillName] = applicationInfo;
    
  end
  
  SaveTraits();
  return true;
end

function Traits.AddAppliedBy(buffType,buffInfo,appliedByName,critsOnly,delay,duration)
  if (appliedByName == "") then return false, "A name is required" end
  
  -- first check for special cases (non-unique names)
  local buffApplicationSet = (buffType == "Buff" and buffApplications or (buffType == "Debuff" and debuffApplications or ccApplications));
  if (buffApplicationSet[appliedByName] ~= nil and buffApplicationSet[appliedByName][buffInfo.skillName] ~= nil) then
    return false, "Another application with the same name already exists for this buff";
  end
  
  -- error checking on delay/duration
  delay = tonumber(delay);
  duration = tonumber(duration);
  local delayError;
  local durationError;
  if (delay == nil) then
    delay = 0;
    delayError = "Invalid Number entered";
  end
  if (duration == nil) then
    duration = 0;
    durationError = "Invalid Number entered"
  elseif (duration  < 0) then
    duration = 0;
    durationError = "Duration must be greater than zero"
  end
  
  local newAppliedBy;
  
  -- Buffs
  if (buffType == "Buff") then
    newAppliedBy = true;
    table.insert(buffInfo.appliedBy, appliedByName);
    AddOrUpdateBuff(buffInfo.skillName, appliedByName);
    
  -- Debuffs
  elseif (buffType == "Debuff") then
    newAppliedBy = {skillName = appliedByName, critsOnly = critsOnly, delay = delay, duration = duration};
    table.insert(buffInfo.appliedBy, newAppliedBy);
    AddOrUpdateDebuff(buffInfo.skillName,newAppliedBy);
    
  else
    newAppliedBy = {skillName = appliedByName, critsOnly = critsOnly};
    table.insert(buffInfo.appliedBy, newAppliedBy);
    AddOrUpdateCC(buffInfo.skillName,newAppliedBy);
    
  end
  
  SaveTraits();
  return newAppliedBy, delayError, durationError;
end

function Traits.RemoveAppliedBy(buffType,buffInfo,appliedByName)
  local removed;
  for index,appliedByInfo in ipairs(buffInfo.appliedBy) do
    if ((buffType == "Buff" and appliedByInfo == appliedByName) or (buffType ~= "Buff" and appliedByInfo.skillName == appliedByName)) then
      removed = true;
      table.remove(buffInfo.appliedBy, index);
      break;
    end
  end
  if (not removed) then return false, "Application did not exist" end
    
  -- Buffs
  if (buffType == "Buff") then
    buffApplications[appliedByName][buffInfo.skillName] = nil;
    if (next(buffApplications[appliedByName]) == nil) then buffApplications[appliedByName] = nil end
    
  -- Debuffs
  elseif (buffType == "Debuff") then
    debuffApplications[appliedByName][buffInfo.skillName] = nil;
    if (next(debuffApplications[appliedByName]) == nil) then debuffApplications[appliedByName] = nil end
    
  -- CC
  else
    ccApplications[appliedByName][buffInfo.skillName] = nil;
    if (next(ccApplications[appliedByName]) == nil) then ccApplications[appliedByName] = nil end
    
  end
  
  SaveTraits();
  return true;
end

-- temp morale only

function Traits.UpdateLogName(buffInfo,newLogName)
  local oldLogName = buffInfo.logName;
  buffInfo.logName = newLogName;
  
  tempMoraleSkills[oldLogName][buffInfo.skillName] = nil;
  if (tempMoraleSkills[newLogName] == nil) then tempMoraleSkills[newLogName] = {} end
  tempMoraleSkills[newLogName][buffInfo.skillName] = true;
  
  if (oldLogName ~= buffInfo.skillName) then
    if (next(tempMoraleSkills[oldLogName]) == nil) then tempMoraleSkills[oldLogName] = nil end
    tempMoraleSkills[buffInfo.skillName][oldLogName] = nil;
  end
  tempMoraleSkills[buffInfo.skillName][newLogName] = true;
  
  SaveTraits();
  return true;
end

-- buffs

function Traits.UpdateStance(buffInfo,newStance)
  buffInfo.isStance = newStance;
  
  buffs[buffInfo.skillName].isStance = newStance;
  
  SaveTraits();
  return true;
end

function Traits.UpdateStackedBuffName(buffInfo,newName,oldName)
  if (newName == "") then return false, "A name is required" end
  
  if (buffInfo.stacking == nil) then buffInfo.stacking = {} end
  if (buffs[buffInfo.skillName].stacking == nil) then buffs[buffInfo.skillName].stacking = {} end
  
  for i,stackedBuffName in ipairs(buffInfo.stacking) do
    if (oldName == stackedBuffName) then
      buffInfo.stacking[i] = newName;
      break;
    end
  end
  
  for i,stackedBuffName in ipairs(buffs[buffInfo.skillName].stacking) do
    if (oldName == stackedBuffName) then
      buffs[buffInfo.skillName].stacking[i] = newName;
      break;
    end
  end
  
  SaveTraits();
  return true;
end

function Traits.AddStackingBuff(buffInfo,name)
  if (name == "") then return false, "A name is required" end
  
  if (buffInfo.stacking == nil) then buffInfo.stacking = {} end
  if (buffs[buffInfo.skillName].stacking == nil) then buffs[buffInfo.skillName].stacking = {} end
  
  table.insert(buffInfo.stacking,name);
  table.insert(buffs[buffInfo.skillName].stacking,name);
  
  SaveTraits();
  return true;
end

function Traits.RemoveStackingBuff(buffInfo,name)
  if (buffInfo.stacking == nil) then buffInfo.stacking = {} end
  if (buffs[buffInfo.skillName].stacking == nil) then buffs[buffInfo.skillName].stacking = {} end

  local removed = false;
  for i,stackedBuffName in ipairs(buffInfo.stacking) do
    if (name == stackedBuffName) then
      removed = true;
      table.remove(buffInfo.stacking,i);
      break;
    end
  end
  if (not removed) then return false, "Stacking buff did not exist" end
  
  for i,stackedBuffName in ipairs(buffs[buffInfo.skillName].stacking) do
    if (name == stackedBuffName) then
      table.remove(buffs[buffInfo.skillName].stacking,i);
      break;
    end
  end
  
  SaveTraits();
  return true;
end

-- debuffs only

function Traits.UpdateBB(buffInfo,newBB)
  buffInfo.bb = newBB;
  debuffs[buffInfo.skillName].bb = newBB;
  
  SaveTraits();
  
  Misc.NotifyListeners(buffInfo,"bb",newBB);
  return true;
end

function Traits.UpdateCA(buffInfo,newCA)
  buffInfo.ca = newCA;
  debuffs[buffInfo.skillName].ca = newCA;
  
  SaveTraits();
  return true;
end

function Traits.UpdateIcon(buffInfo,newIcon)
  -- first attempt to load in the icon
  local testControl = Turbine.UI.Control();
  local success = (newIcon ~= "" and pcall(Turbine.UI.Control.SetBackground,testControl,"CombatAnalysis/Resources/DebuffIcons/"..newIcon));
  testControl = nil;
  
  if (not success) then return false, "Unable to load icon" end
  
  buffInfo.iconName = newIcon;
  debuffs[buffInfo.skillName].icon = "CombatAnalysis/Resources/DebuffIcons/"..newIcon;
  
  SaveTraits();
  
  Misc.NotifyListeners(buffInfo,"iconName",newIcon);
  return success, "Unable to load icon";
end

function Traits.UpdateRemoval(buffInfo,newRemoval)
  buffInfo.removalOnly = newRemoval;
  debuffs[buffInfo.skillName].removalOnly = newRemoval;
  
  SaveTraits();
  
  Misc.NotifyListeners(buffInfo,"removalOnly",newRemoval);
  return true;
end

function Traits.UpdateToggle(buffType,buffInfo,newToggle)
  buffInfo.toggleSkill = newToggle;
  debuffs[buffInfo.skillName].toggleSkill = newToggle;
  
  SaveTraits();
  
  Misc.NotifyListeners(buffInfo,"toggleSkill",newRemoval);
  return true;
end

function Traits.AddConflict(buffInfo,conflict,position)
  if (buffInfo.conflicts == nil) then buffInfo.conflicts = {} end
  table.insert(buffInfo.conflicts,position,conflict);
  
  if (debuffs[buffInfo.skillName].conflicts == nil) then debuffs[buffInfo.skillName].conflicts = {} end
  table.insert(debuffs[buffInfo.skillName].conflicts,position,conflict);
  
  SaveTraits();
  return true;
end

function Traits.RemoveConflict(buffInfo,conflict)
  for i,o in ipairs(buffInfo.conflicts) do
    if (o == conflict) then
      table.remove(buffInfo.conflicts,i);
      break;
    end
  end
  if (buffInfo.conflicts == 0) then buffInfo.conflicts = nil end
  
  for i,o in ipairs(debuffs[buffInfo.skillName].conflicts) do
    if (o == conflict) then
      table.remove(debuffs[buffInfo.skillName].conflicts,i);
      break;
    end
  end
  if (#debuffs[buffInfo.skillName].conflicts == 0) then debuffs[buffInfo.skillName].conflicts = nil end
  
  SaveTraits();
  return true;
end

function Traits.AddEffectModifier(buffInfo,effect,position,duration)
  -- error checking on delay/duration
  duration = tonumber(duration);
  local durationError = nil;
  if (duration == nil) then
    duration = 0;
    durationError = "Invalid Number entered"
  end
  
  if (buffInfo.buffEffects == nil) then buffInfo.buffEffects = {} end
  table.insert(buffInfo.buffEffects,position,{skillName = effect, duration = duration});
  
  if (debuffs[buffInfo.skillName].buffEffects == nil) then debuffs[buffInfo.skillName].buffEffects = {} end
  table.insert(debuffs[buffInfo.skillName].buffEffects,position,{skillName = effect, duration = duration});
  
  SaveTraits();
  return true, durationError;
end

function Traits.RemoveEffectModifier(buffInfo,effect)
  for i,o in ipairs(buffInfo.buffEffects) do
    if (o.skillName == effect) then
      table.remove(buffInfo.buffEffects,i);
      break;
    end
  end
  if (buffInfo.buffEffects == 0) then buffInfo.buffEffects = nil end
  
  for i,o in ipairs(debuffs[buffInfo.skillName].buffEffects) do
    if (o.skillName == effect) then
      table.remove(debuffs[buffInfo.skillName].buffEffects,i);
      break;
    end
  end
  if (#debuffs[buffInfo.skillName].buffEffects == 0) then debuffs[buffInfo.skillName].buffEffects = nil end
  
  SaveTraits();
  return true;
end

function Traits.UpdateEffectModifier(buffInfo,effect,duration)
  duration = tonumber(duration);
  if (duration == nil) then return false, "Invalid Number entered" end
  
  for i,o in ipairs(buffInfo.buffEffects) do
    if (o.skillName == effect) then
      o.duration = duration;
      break;
    end
  end

  for i,o in ipairs(debuffs[buffInfo.skillName].buffEffects) do
    if (o.skillName == effect) then
      o.duration = duration;
      break;
    end
  end
  
  SaveTraits();
  return true;
end

function Traits.UpdateAppliedByDelay(buffInfo,appliedByName,delay)
  delay = tonumber(delay);
  if (delay == nil) then return false, "Invalid Number entered" end
  
  for _,appliedByInfo in pairs(buffInfo.appliedBy) do
    if (appliedByInfo.skillName == appliedByName) then
      appliedByInfo.delay = delay;
      break;
    end
  end
  
  debuffApplications[appliedByName][buffInfo.skillName].delay = delay;
  
  SaveTraits();
  return true;
end

-- debuffs and CC

function Traits.UpdateAppliedByDuration(buffType,buffInfo,appliedByName,duration)  
  duration = tonumber(duration);
  if (duration == nil) then return false, "Invalid Number entered" end
  if (duration  < 0) then return false, "Duration must be greater than zero" end
  
  for _,appliedByInfo in pairs(buffInfo.appliedBy) do
    if (appliedByInfo.skillName == appliedByName) then
      appliedByInfo.duration = duration;
      break;
    end
  end
  
  -- Debuffs
  if (buffType == "Debuff") then
    debuffApplications[appliedByName][buffInfo.skillName].duration = duration;
  -- CC
  else
    ccApplications[appliedByName][buffInfo.skillName].duration = duration;
  end
  
  SaveTraits();
  return true;
end

function Traits.AddOverwrite(buffType,buffInfo,overwrite,position)
  if (buffInfo.overwrites == nil) then buffInfo.overwrites = {} end
  table.insert(buffInfo.overwrites,position,overwrite);
  
  -- Debuffs
  if (buffType == "Debuff") then
    if (debuffs[buffInfo.skillName].overwrites == nil) then debuffs[buffInfo.skillName].overwrites = {} end
    table.insert(debuffs[buffInfo.skillName].overwrites,position,overwrite);
    
  -- CC
  else
    if (cc[buffInfo.skillName].overwrites == nil) then cc[buffInfo.skillName].overwrites = {} end
    table.insert(cc[buffInfo.skillName].overwrites,position,overwrite);
    
  end
  
  SaveTraits();
  return true;
end

function Traits.RemoveOverwrite(buffType,buffInfo,overwrite)
  for i,o in ipairs(buffInfo.overwrites) do
    if (o == overwrite) then
      table.remove(buffInfo.overwrites,i);
      break;
    end
  end
  if (buffInfo.overwrites == 0) then buffInfo.overwrites = nil end
  
  -- Debuffs
  if (buffType == "Debuff") then
    if (debuffs[buffInfo.skillName] ~= nil) then
      for i,o in ipairs(debuffs[buffInfo.skillName].overwrites) do
        if (o == overwrite) then
          table.remove(debuffs[buffInfo.skillName].overwrites,i);
          break;
        end
      end
      if (#debuffs[buffInfo.skillName].overwrites == 0) then debuffs[buffInfo.skillName].overwrites = nil end
    end
  -- CC
  else
    if (cc[buffInfo.skillName] ~= nil) then
      for i,o in ipairs(cc[buffInfo.skillName].overwrites) do
        if (o == overwrite) then
          table.remove(cc[buffInfo.skillName].overwrites,i);
          break;
        end
      end
      if (#cc[buffInfo.skillName].overwrites == 0) then cc[buffInfo.skillName].overwrites = nil end
    end
    
  end
  
  SaveTraits();
  return true;
end

function Traits.UpdateAppliedByCritsOnly(buffType,buffInfo,appliedByName,critsOnly)
  for _,appliedByInfo in pairs(buffInfo.appliedBy) do
    if (appliedByInfo.skillName == appliedByName) then
      appliedByInfo.critsOnly = critsOnly;
      break;
    end
  end
  
  -- Debuffs
  if (buffType == "Debuff") then
    debuffApplications[appliedByName][buffInfo.skillName].critsOnly = critsOnly;
  -- CC
  else
    ccApplications[appliedByName][buffInfo.skillName].critsOnly = critsOnly;
  end
  
  SaveTraits();
  return true;
end
