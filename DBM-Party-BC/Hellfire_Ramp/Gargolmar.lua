local mod	= DBM:NewMod("Galgolmar", "DBM-Party-BC", 1, 248)

mod:SetRevision("20220518110528")
mod:SetCreatureID(17306)

mod:SetModelID(18236)
mod:SetModelOffset(-0.2, 0, -0.3)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
    "SPELL_CAST_SUCCESS 34645 22857",
	"SPELL_AURA_APPLIED_DOSE 36814",
	"SPELL_AURA_APPLIED 36814"
)

local timerWound			= mod:NewCDTimer(10, 36814, nil, nil, nil, 1)
local timerChargeCD			= mod:NewCDTimer(7, 34645, nil, nil, nil, 2)
local timerRetribution		= mod:NewBuffFadesTimer(17, 22857, nil, "Melee", nil, nil, nil, 5) -- время дейстия обратки, сколько он длится не знаю =)
local warnRetirbution		= mod:NewSpellAnnounce(22857, nil, nil, "Melee", 4, 2)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(36814) then
		timerWound:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(36814) then
		timerWound:Start(args.amount*5 .. "%")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(34645) then
		timerChargeCD:Start()
	elseif args:IsSpellID(22857) then
		timerRetribution:Start(args.sourceName)
		warnRetirbution:Show()
	end
end
