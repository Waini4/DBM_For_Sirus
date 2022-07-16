local mod = DBM:NewMod("Trash", "DBM-TheEye", 1)
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20201012213000")

mod:SetCreatureID(20045)
mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.YellPull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_REMOVED",
	"SPELL_AURA_APPLIED 37135",
	"SPELL_CAST_START"
)

mod:RegisterEventsInCombat("SPELL_AURA_APPLIED 37135")
local warnKontr = mod:NewTargetAnnounce(37135, 4)

local KontrTargets = {}


local function Kontr()
	warnKontr:Show(table.concat(KontrTargets, "<, >"))
	table.wipe(KontrTargets)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(37135) then
		KontrTargets[#KontrTargets + 1] = args.destName
		self:Unschedule(Kontr)
		self:Schedule(0.1, Kontr, self)
	end
end
