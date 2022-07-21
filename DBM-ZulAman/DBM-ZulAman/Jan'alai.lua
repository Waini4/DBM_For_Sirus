local mod = DBM:NewMod("Janalai", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(23578)
mod:RegisterCombat("combat", 23578)

mod:RegisterEvents(
	"SPELL_CAST_START 43140",
	"CHAT_MSG_MONSTER_YELL"
)

local timerHatchers   = mod:NewTimer(145, "Hatchers", 26297)
local timerBombs      = mod:NewTimer(50, "Bombs", 31961)
local timerExplosion  = mod:NewTimer(11, "Explosion", 66313)
local timerNextBreath = mod:NewCDTimer(12, 43140)

mod:AddBoolOption("Hatchers", true)
mod:AddBoolOption("Bombs", true)
mod:AddBoolOption("Explosion", true)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23578, "Jan'alai")
	timerHatchers:Start(15)
	timerBombs:Start(40)
	timerNextBreath:Start()
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23578, "Jan'alai", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43140) then
		timerNextBreath:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellBombs then
		timerExplosion:Start()
		timerBombs:Start()
	elseif msg == L.YellHatcher then
		timerHatchers:Start()
	end
end
