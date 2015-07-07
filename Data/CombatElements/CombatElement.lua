
--[[

The Abstract Base Class for all Combat Elements.

This includes attacks, restores, and other
kind of events such as deaths, interrupts,
and corruption removals, etc, as well as
entering and exit combat events.

All Combat Elements must be timestamped (as a
"game time" offset from when combat began), and
include a (usually initiating) player.

]]--

_G.CombatElement = abstract_class();

function CombatElement:Constructor(timestamp,initiatorName)
	self.timestamp = timestamp;
	self.initiatorName = initiatorName;
end
