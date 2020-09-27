--[[

This file is used to provide enums to the entire codebase.

Any number of enums can be put here to make other code more readable.

]]--

_G.event_type = {
	DMG_DEALT = 1,
	DMG_TAKEN = 2,
	HEAL = 3,
	POWER_RESTORE = 4,
	DEBUFF_APPLIED = 5,
	BUFF_APPLIED = 6,
	INTERRUPT = 7,
	CORRUPTION = 8,
	DEATH = 9,
	REVIVE = 10,
	COMBAT_START = 11,
	COMBAT_END = 12,
	MOB_INTERRUPT = 13,
	TEMP_MORALE_LOST = 14,
	TEMP_MORALE_NOT_WASTED = 15,
	CC_BROKEN = 16,
	BENEFIT = 17,
}
