local mod = DBM:NewMod("Zluker", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000")
mod:SetCreatureID(10055, 100552, 100555)
mod:RegisterCombat("yell", L.YellZluker)

mod:RegisterEvents(
	"SPELL_CAST_START 305535",
	"CHAT_MSG_MONSTER_YELL"
)

local timerMagicCD     = mod:NewCDTimer(79, 305535)
local timerCombatStart = mod:NewCombatTimer(42)
-- local warnSound						= mod:NewSoundAnnounce()

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPull or msg:find(L.YellPull) then
		timerCombatStart:Start()
	end
end

function mod:OnCombatStart()
	timerMagicCD:Start(66)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305535) then
		timerMagicCD:Start()
	end
end
