local mod = DBM:NewMod("Halazzi", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(23577)
mod:RegisterCombat("combat", 23577)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED 41254 43303",
	"CHAT_MSG_MONSTER_YELL"
)

local isDispeller = select(2, UnitClass("player")) == "PRIEST" or select(2, UnitClass("player")) == "PALADIN"

local specWarnFrenzy      = mod:NewSpecialWarningDispel(41254, select(2, UnitClass("player")) == "HUNTER")
local specWarnDispelShock = mod:NewSpecialWarningDispel(43303, isDispeller)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23577, "Halazzi")
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23577, "Halazzi", wipe)
end

function mod:SPELL_CAST_START(args)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(41254) then
		specWarnFrenzy:Show()
	elseif args:IsSpellID(43303) then
		specWarnDispelShock:Show(args.destName)
	end
end
