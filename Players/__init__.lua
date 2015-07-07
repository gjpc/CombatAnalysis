
--[[

Contains information about the connected players.

There is no connecting in this version of CombatAnalysis
(there may never be again), so there is only one player
added to the list of players for now.

]]--

_G.players = {}

_G.activeBubbles = {}
_G.bubblesL = {} -- pending temp morale log entries
_G.bubblesE = {} -- pending temp morale effects
_G.recentTempMorale = {} -- recent temp morale that has been lost (and may not have had an effect assigned yet) and should be checked to see if it was wasted

_G.logDelay = 1.5;
_G.effectDelay = 1.0;

import "CombatAnalysis.Players.Skills"
import "CombatAnalysis.Players.Player"
