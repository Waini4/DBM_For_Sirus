local mod	= DBM:NewMod("Kelidan", "DBM-Party-BC", 2, 256)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17377)--17377 is boss, 17653 are channelers that just pull with him.

mod:SetModelID(17153)
mod:SetModelOffset(0, 0, -0.1)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
    "SPELL_AURA_REMOVED 30935",
	"SPELL_AURA_APPLIED 30940"
)

local timerCircleCD		= mod:NewCDTimer(28, 30940)
local timerExplosion	= mod:NewTimer(5, "Explosion", 37371)

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(30935) then
		timerCircleCD:Start(15)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30940) then
		timerCircleCD:Start()
		timerExplosion:Start()
	end
end
