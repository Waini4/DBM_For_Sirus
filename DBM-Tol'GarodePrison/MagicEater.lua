local mod	= DBM:NewMod("MagicEater", "DBM-Tol'GarodePrison")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210501000000") -- fxpw check 20220609123000
mod:SetCreatureID(84017)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON",
	"UNIT_HEALTH"
)

-- смешно что он умер @Стекло