local mod	= DBM:NewMod("Stalker", "DBM-Party-BC", 5, 262)

mod:SetRevision("20220518110528")
mod:SetCreatureID(17882)

mod:SetModelID(18194)
mod:SetModelOffset(-0.4, 1.5, -0.3)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 31704 31715"
)

local warnStaticCharge		= mod:NewTargetAnnounce(31715, 3)

local timerSummon 			= mod:NewCDTimer(58.8, 38755, nil, nil, nil, 1, 2)
local warnLevitate			= mod:NewTargetNoFilterAnnounce(31704, 2, nil, "RemoveMagic|Healer")
local specWarnStaticCharge	= mod:NewSpecialWarningMoveAway(31715, nil, nil, nil, 1, 2)


function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17882, "Stalker")
	timerSummon:Start()	--скорее всего по хп это всё,но не может же он начать сумонить на 7 % хп ?
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17882, "Stalker", wipe)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 31704 then
		warnLevitate:Show(args.destName)
	elseif args.spellId == 31715 then
		if args:IsPlayer() then
			specWarnStaticCharge:Show()
			specWarnStaticCharge:Play("runout")
		else
			warnStaticCharge:Show(args.destName)
		end
	end
end