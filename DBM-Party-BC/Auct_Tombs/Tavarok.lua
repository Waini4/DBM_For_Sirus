local mod	= DBM:NewMod("Tavarok", "DBM-Party-BC", 8, 250)

mod:SetRevision("20220518110528")
mod:SetCreatureID(18343)

mod:SetModelScale(0.5)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 33919",
	"SPELL_AURA_APPLIED 32361 33919",
	"SPELL_AURA_REMOVED 32361"
)

local WarnPrison		= mod:NewTargetNoFilterAnnounce(32361, 3)

local specWarnQuake		= mod:NewSpecialWarningSpell(33919, nil, nil, nil, 2, 2)

local timerEarthquakeCD		= mod:NewCDTimer(22, 33919, nil, nil, nil, 2)
local timerPrisonCD		= mod:NewCDTimer(17.8, 32361, nil, nil, nil, 2)
local timerPrison		= mod:NewTargetTimer(5, 32361, nil, nil, nil, 3)

function mod:OnCombatStart()
	timerEarthquakeCD:Start(10)
	timerPrisonCD:Start(17)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 33919 then
		specWarnQuake:Show()
		specWarnQuake:Play("stunsoon")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 32361 then
		WarnPrison:Show(args.destName)
		timerPrison:Start(args.destName)
		timerPrisonCD:Start()
	elseif args:IsSpellID(33919) then
		timerEarthquakeCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 32361 then
		timerPrison:Stop(args.destName)
	end
end