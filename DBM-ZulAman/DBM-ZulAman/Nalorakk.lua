local mod = DBM:NewMod("Nalorakk", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(23576)
mod:RegisterCombat("combat", 23576)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 42389",
	"CHAT_MSG_MONSTER_YELL"
)

local timerNextBearForm  = mod:NewTimer(30, "BearForm", 9634)
local timerNextTrollForm = mod:NewTimer(23.5, "TrollForm", 26297)
local timerNextSilence   = mod:NewCDTimer(9, 42398)
local timerMangle        = mod:NewTargetTimer(60, 42389)
local berserkTimer       = mod:NewBerserkTimer(420)

mod:AddBoolOption("BearForm", true)
mod:AddBoolOption("TrollForm", true)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23576, "Nalorakk")
	timerNextBearForm:Start(42)
	berserkTimer:Start()
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23576, "Nalorakk", wipe)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(42389) then
		timerMangle:Start(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellBear then
		timerNextSilence:Start()
		timerNextTrollForm:Start()
		timerNextBearForm:Schedule(23.5)
	end
end
