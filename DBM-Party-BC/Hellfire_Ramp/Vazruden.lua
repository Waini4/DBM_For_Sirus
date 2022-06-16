local mod	= DBM:NewMod(529, "DBM-Party-BC", 1, 248)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17537, 17307)

mod:SetModelID(18407)
mod:SetModelOffset(-0.2, 0, -0.3)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 22686",
	"SPELL_CAST_SUCCESS 36921"
)
mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local timerScreamCD		= mod:NewCDTimer(21, 22686, nil, nil, nil, 3)
local timerFireCD		= mod:NewCDTimer(12, 36921, nil, nil, nil, 3)
local warnScreamKick	= mod:NewSpecialWarningInterrupt(22686)

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(22686) then
		timerScreamCD:Start()
		warnScreamKick:Show(args.sourceName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(36921) then
		timerFireCD:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteNazan then	-- [CHAT_MSG_RAID_BOSS_EMOTE] Назан спускается с небес.:Назан::::
		timerFireCD:Start()
		timerScreamCD:Start(5)
	end
end
