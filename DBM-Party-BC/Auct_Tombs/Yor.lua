local mod	= DBM:NewMod("Yor", "DBM-Party-BC", 8, 250)

mod:SetRevision("20220518110528")
mod:SetCreatureID(22930)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START"
)

local warnStomp				= mod:NewSpellAnnounce(36405, 2)	-- Топот(но его вроде нет на сирусе)
local timerBreathCD 		= mod:NewCDTimer(7.5, 38361)	-- Двойное  дыхание

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38361) then
		timerBreathCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 36405 then
		warnStomp:Show()
	end
end