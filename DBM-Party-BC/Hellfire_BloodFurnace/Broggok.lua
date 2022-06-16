local mod	= DBM:NewMod("Broggok", "DBM-Party-BC", 2, 256)

mod:SetRevision("20220518110528")
mod:SetCreatureID(17380)

mod:SetModelID(19372)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
    "SPELL_CAST_SUCCESS 30916 38459"
)

local timerPoisonCloud	= mod:NewCDTimer(20, 30916)
local timerPoisonBolt	= mod:NewCDTimer(5, 38459)

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(30916) then
		timerPoisonCloud:Start()
	elseif args:IsSpellID(38459) then
		timerPoisonBolt:Start()
	end
end
