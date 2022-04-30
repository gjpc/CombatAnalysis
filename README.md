# CombatAnalysis
A Lord of the Rings Online Lua Plugin in the public domain

Contributors 
Evendale - Creator
Landal/gjpc - Successor 
hdflux,Ravdor/Bamor/Drono/argonui - Engineers

Non coder type people can easily download this plugin at http://www.lotrointerface.com/downloads/fileinfo.php?id=881&so=

All coders, LUA enthusists and LoTRO Peeps are encouraged to fork this repository and particiapte!

Update 4.8.5 (28 Sep 2020)
argonui Add ability for Benefits to be sent to BuffBars & added internal enhancements
Thanks!

Thanks!

Update 4.8.7 Adra's complete french translation update, Merci Adra

Update 4.8.6 Simple; update the french chat to kin command

Update 4.8.4 (7 Aug 2020)
Revert to the 4.8.0 French language module

Update 4.8.3 (1 Aug 2020)
Adopt Jullie Charrier's mods to the French language module

Update 4.8.2 (28 Nov 2019)
Temporary fix to really allow French client communications

Update 4.8.1 (28 Nov 2019)
Temporary fix to allow French client communications

Update 4.8.0 (26 Nov 2019)
Added Fell Wrought damage, reset stats on encountes and Dromo removed ghost button 

Update 4.7.1  Landal/gjpc (10 June 2016)
Fix crash for first time users caused by larger font feature

Update 4.7.0 Landal/gjpc (5 June 2016)
added larger fonts option for the stat panels

Update 4.6.0 hdflux (4 June 2016)
added the **/ca cleanup** command. Clears the stats and cleans the cache

Update 4.5.0 by Ravdor/Bamor (8 Feb 2016)
Separated hits into Normal, Critical, and Devastates
Added APS (Attacks Per Second)

Update 4.4.6 by Landal/gjpc (6 July 2015)
Backed out badness 
Placed the code on GitHub for collaboration

Update 4.4.5 by Landal/gjpc (17 May 2015)
Added hdflux's "/ca reset totals" command
increased the size of the file names for Dave & hdflux
Adjusted some mounted combat stat acquisition

Update 4.4.3 by Landal/gjpc (17 May 2015)
Corrected data type handling of debuff timers that generated unsightly error messages

Update 4.4.2 by Landal/gjpc and Ischabux (12 Apr 2015)
Ischabux provided German translations and extensive clean up the de.lua file
added code to perhaps start counting interrupts, Artoo, can you check?

Update 4.4.1 by Landal/gjpc (4 Apr 2015)
restricted /ca reset to work only when not in combat
fixed the German client version, it runs, but looking forward to Beoring translations
added orc-craft and fell-wrought damgae types

Update 4.4.0 by Landal/gjpc (29 Mar 2015)
added a /ca reset command
added the Beoring buffs and skills
corrected Dorf damage to Dwarf damage

Update 4.3.4 by Landal/gjpc ( 8 July 2014 )
restored the plugincompendium file for management tools

Update 4.3.3 by Landal/gjpc ( 7 July 2014 )
New Features
*Averages in the stat overview panel
*Removed Evendale's naughty bits

Hotfix 4.2.3(b) (1 Jan 2013 04:10 EST):
- Properly fixed the generation of save names when autosaving so there should no longer be any errors
- The CA logo now stays hidden after toggling F12, and the dragbar only shows when applicable
- The correct damage type is now displayed for damage done in mounted combat (English only)
- Added some missing Hunter skills to the German translation file to prevent errors when playing as a Hunter

Hotfix 4.2.2 (23 Dec 2012 19:15 EST):
- Added 'deflect' as an avoidance type (only tracked in the English version for now)
- Fixed a bug where you would sometimes receive an error when autosaving encounters if the generated file name was too long

Hotfix 4.2.1 (22 Dec 2012 20:00 EST):
- Added some missing lines to the locale file that was causing the plugin to fail to load for Lore Masters
- Added a couple of missing German translations

Update 4.2.0(b) (21 Dec 2012 20:30 EST):
New Features
* Added a complete menu
* Many new configuration options (including combat timers, and UI color schemes)
* Added a logo icon that can be used to show/hide/lock all windows
* Auto Saving options
* You can manually configure which buff/debuff/CC/temp morale skills are tracked, and their associated details
* You can also now set up multiple trait configuration settings (for debuffs & CC) to track
Minor changes
- Added a tutorial window
- Many minor UI improvements
Bug Fixes/Other
- Numerous minor bug fixes
- Fixed a bug where a debuff/CC could occasionally not appear in the Buffbars effect bars
- Fixed the RoR bug that caused spurious error messages on load

Update 4.2.0(b) (21 Dec 2012 20:30 EST):
New Features
* Added a complete menu
* Many new configuration options (including combat timers, and UI color schemes)
* Added a logo icon that can be used to show/hide/lock all windows
* Auto Saving options
* You can manually configure which buff/debuff/CC/temp morale skills are tracked, and their associated details
* You can also now set up multiple trait configuration settings (for debuffs & CC) to track
Minor changes
- Added a tutorial window
- Many minor UI improvements
Bug Fixes/Other
- Numerous minor bug fixes
- Fixed a bug where a debuff/CC could occasionally not appear in the Buffbars effect bars
- Fixed the RoR bug that caused spurious error messages on load

Update 4.1.6 (05 May 2012 01:00 EST):
- Fixed a bug in the german translation that caused issues with temporary morale bubbles
- Pets damage is now detected with 100% accuracy by checking against the new combat channels

Update 4.1.5 (27 Apr 2012 03:30 EST):
- Send to chat now has a Tribe option instead of Kinship option for creep players
- Fellow players should no longer occasionally appear randomly in the mob targets list with no data
- Stun Immunity no longer is occasionally removed early and cannot become stuck on the screen
- Debuff timers are now correctly recorded (even when you don't have the debuff panel showing on screen the whole time)
- Fixed a rare bug where Debuffs failed to be terminated (and could result in errors, preventing saving) when several mobs were killed within a short timeframe
- Debuffs are now loaded from save files along with all the other info
- Can now save and load in combat without getting errors
- Stances (under the Buff tab) no longer display the number of uses (as this info is erronous anyway)
- Added support for debuffs that apply with a different name
- Added support for debuffs that don't override themselves
- Added Imminent Cleansing debuff, and CtD
- Added Burglar devastating buffs, and QK stance buff
- Added Martyrs Stangard set bonus temp morale clicky
- Added the Frost Ring temp morale bubble (English version only) - I intend to prevent this from being tracked at all at some point

Update 4.1.4 (11 Apr 2012 04:00 EST):
- Fixed a bug in the German translation where it would give an error every time there was a miss in the log
- Fixed a bug where the stats window could occasionally fail to hide after being unlocked from the window title.

Update 4.1.3 (8 Apr 2012 07:30 EST):
- Added a death event for MP kills (where you got the KB)
- When saving a file with an invalid name, the "Saving..." message will no longer be stuck on screen (and the encounter data will not appear in blue indicating that it has been saved)
- When opening the save dialog after previously saving data, the encounter data for previously saved data will not always reset to unchecked when alternating between screens.
- Some German translation fixes.
- Added stun immunity as a tracked CC effect, and Challenge as a tracked debuff.
- Added Lore Master icons for all debuffs

Update 4.1.2 (25 Mar 2012 03:30 EST):
- Fixed a number of issues with the Buffbars effect tracking, and added icons for all debuffs except Lore Master ones.
- Added some better error checking when loading settings files.

Update 4.1.1 (18 Mar 2012 23:30 EST):
- German translation of file dialog added, and some other minor additions.
- Fixed a bug where the settings file could occasionally fail to load when some tabs were closed.

Update 4.1.0 (14 Mar 2012 05:15 EST):
New Features
* Stat breakdown by attack type
* Temporary Morale is now tracked
* Buffs/Debuffs are now tracked
* Data can now be saved & loaded
Minor changes
- Slightly upped the contrast of the combo boxes, and made a few other minor UI updates, including changes to the way large numbers are formatted
- The totals encounter now shows a list of mobs, showing the total damage done to mobs with the same name
- Mob timers are now more accurate when killing mobs with the same name sequentially.
- The settings file is now in a more readable format
- Save files saved in one localization can be read by clients running a different localization
Bug Fixes/Other
- Direct damage (damage that does not include a skill name) is now tracked.
- The stats panel now updates durations correctly when in "auto hide" (or always hide) mode.
- 12:00-13:00 now correctly shows as pm. de/fr clients use 24h clocks.
- Fixed several issues surrounding player timers when killed/revived
- Fixed a bug where auto hiding of tabs would often return to "off" after reloading the plugin.
- Fixed a bug where a locked stat item would be overridden by changes to the stat window visibility mode
- Fixed a bug where minimized windows would shift position (right) when the plugin was reloaded.
- The Stats Window now disappears instantly on F12 (doesn't fade)

Update 4.0.4 (02 Feb 2012 05:30 EST):
New Features
* The send to chat button finally works! You can choose which channel (say, fellowship, raid, or kinship) to send the info to, and which information to include.
* Damage taken by pets is now shown.
Bug Fixes/Other
- Players/pets whose name ends with "heal" do not get errors when they perform heals.
- Heals for less than 10 don't result in errors.
- Self-inflicted damage is now better handled (only shows as damage taken)
- Improved mob/pet detection (ie: removed several possible invalid mob detections as a result of unusual lines in the combat log).
- The timer of the last mob killed in an encounter is no longer sometimes doubled.
- 3 seconds after combat ends, CombatAnalysis no longer steals focus away from the chat window!
- It is no longer possible for bars to occasionally frantically switch order.
- Resetting the totals encounter no longer appears to start the timer while out of combat.
- An issue with localization detection was resolved, and saving data for fr/de clients is now much more efficient.

Update 4.0.3 (28 Jan 2012 08:30 EST):
- Light damage now included in stats window.
- German localization added.

Update 4.0.2 (22 Oct 2011 01:15 EST):
New Features
* The total and attacks stats now show a percentage (see stats calculations above for more details).
* You can lock a particular bar's info in the stats window by clicking the lock icon or control-clicking a bar (ie: once locked, the stats info won't change until you unlock the bar, or change the target). While a stats bar's info is locked, the "always hide" visibility option will be overriden. (More info about this will be added to the instructions above soon.)
Restored Features (from version 3)
* Windows/Tabs that aren't shown on screen consume zero processing time.
* The Stats window fades in and out (if not in "always show" mode).
Restored Features (from version 2)
* Windows snap into place while being moved when they are within a few pixels from another window.
Bug Fixes/Other
- The "Send to Chat" button now appears but is still not clickable. Hopefully I can restore the functionality soon, but I need to ensure its definitely not causing crashes anymore first.
- The saved settings no longer get out of synch if a stats window is detached and the plugin immediately unloaded.
- The name for an encounter is now correctly selected based on the mob that took the most total damage from all connected players (ie: you and your pet(s)).
- The resize button stays hidden when minimizing and then restoring a window when there is no background showing.
- Misclicking (by a few pixels) on leftmost tab doesn't immediately start dragging (moving) the window.
- The stats panel shows percentage values when slightly narrower than before.
- The ps stat in the stats window now shows 1 decimal place for ps values up to 10,000.
- Changing the order of, or moving tabs between windows, while the tab area is filled will scroll along to make the outcome of the performed action more obvious.
- You can now see which bar is being hovered over when the bar length is zero, and the window background is set to transparent.
- The stats panel now correctly updates when new data causes the bar ordering to change while the mouse is hovering over the bars (during combat).

Hotfix 4.0.1 (17 Oct 2011 21:30 EST):
- Can now back out of player details when the Auto select player details option is selected.

Update 4.0.0 (17 Oct 2011 02:30 EST):
Plugin rewritten to perform in-game parsing with considerable performance gains over previous versions.
Large UI update
* Much nicer UI in general. Matches the LOTRO look & feel considerably more than previous versions. Uses proper tabs (similar to the chat window). Uses standard LOTRO resize arrows. Improved color scheme. Less size restrictions.
* Can remove the title bar features and buttons from windows bringing them down to an extremely small size if desired. Individual windows can also be minimized/closed.
* Tabs can now be separated/combined to create as many/few windows as desired.
* The stat details window(s) can now be resized/positioned as desired on screen, and different sections can be expanded/collapsed. Also includes a few additional summary stats.
* Stats windows can separated/combined.
* Two alternative visibility modes added to stats windows.
New Features
* The ability to send output to the chat window.
* The ability to turn on automatic selection of player's details.
Restored Features (from version 2)
* Customizable windows. In particular, windows can be made fully transparent again.
* Can turn off/on automatic selection of new combat encounters
Removed Features
- There is no longer any external application, and you cannot connect directly to other players (see note above).
- The timestamped list of skill uses has been removed and will be replaced by a considerably better version in version 4.1.

Update 3.0.0 beta (14 Apr 2011 21:00 EST):
- Another major overhaul to entire system. Updated to work with new logs and complete UI update.
Some key new features are listed below
* updated to work with the new combat logs
* tabbed pane frees up screen room
* resizable UI
* dmg/heal/power info broken down per skill, and per attack
* stats info added

Update 2.0.2 (4 Feb 2011 23:00 EST):
- When displaying dmg/heal/power info in text mode, the values are now displayed correctly and no errors will be printed to the chat window.
- Partial pet avoids from mobs with long names no longer parsed as damage taken by the player.

Hotfix 2.0.1 (4 Feb 2011 08:00 EST):
- Fixed a significant issue that caused the host to frequently send invalid info to clients (when 3 or more people were connected).
- Incoming pet heals are no longer counted twice.
- Fixed an error that could print in game if certain windows were closed while udpating.

Update 2.0.0 (3 Feb 2011 23:00 EST):
- Major overhaul to entire system. Many new features and improvements.
Some key new features are listed below
* sticky windows & window links
* dmg taken breakdown by type
* dmg taken, heal and power info parsed and sent between players
* improved UI customization
* better tracking of pets
* ability to block users
* large hits BETA
* improved performance in-game
* improved performance in application
* reduced bandwidth usage
Some key bug fixes from the first version are listed below
* reflect damage now included
* non standard damage types now included
* pets with spaces in their names (default names) can now be parsed correctly
* players with "-1" at the end of their name now have their information parsed correctly
* combat no longer hangs when killing a mob quickly

Hotfix 1.0.2 (11 Jan 2011 09:00 EST):
- Fixed a crash that could occasionally occur if damage was taken while out of combat.
- Fixed a crash that occurred when someone in your fellowship retreated if your Combat Tab included the standard filter.
- Additionally, damage from an unspecified source (such as the bleed in the Watcher room) is now included.

Hotfix 1.0.1 (10 Jan 2011 23:15 EST):
- Fixed a potential crash that sometimes occurred when clients joined/left a server.

1.0.0 (10 Jan 2011):
- Initial Release
