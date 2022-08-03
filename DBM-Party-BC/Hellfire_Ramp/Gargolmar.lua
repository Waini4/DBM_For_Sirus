local mod	= DBM:NewMod("Galgolmar", "DBM-Party-BC", 1, 248)

mod:SetRevision("20220518110528")
mod:SetCreatureID(17306)

mod:SetModelID(18236)
mod:SetModelOffset(-0.2, 0, -0.3)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
    "SPELL_CAST_SUCCESS  34645 22857",
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

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(36814) then
		local amount = args.amount or 1
		if amount >= 4 then
			specWarnMarkOnPlayer:Show(args.spellName, amount)
			specWarnMarkOnPlayer:Play("stackhigh")
		end
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

-- Message: Interface\AddOns\DBM-Core\DBM-Core.lua:841: table index is nil
-- Time: 08/03/22 21:33:52
-- Count: 1
-- Stack: [C]: ?
-- Interface\AddOns\DBM-Core\DBM-Core.lua:841: in function <Interface\AddOns\DBM-Core\DBM-Core.lua:829>
-- Interface\AddOns\DBM-Core\DBM-Core.lua:866: in function <Interface\AddOns\DBM-Core\DBM-Core.lua:860>
-- Interface\AddOns\DBM-Core\DBM-Core.lua:929: in function `RegisterEvents'
-- Interface\AddOns\DBM-Core\DBM-Core.lua:5137: in function `StartCombat'
-- Interface\AddOns\DBM-Core\DBM-Core.lua:4725: in function `func'
-- Interface\AddOns\DBM-Core\modules\Scheduler.lua:171: in function <Interface\AddOns\DBM-Core\modules\Scheduler.lua:162>

-- Locals: 