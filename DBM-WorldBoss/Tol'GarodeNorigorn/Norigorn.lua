local mod	= DBM:NewMod("Norigorn", "DBM-WorldBoss", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("20210501000000"):sub(12, -3))
mod:SetCreatureID(70010)

mod:RegisterCombat("combat", 70010)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON",
	"UNIT_HEALTH"
)


local warnseti 							= mod:NewCastAnnounce(317274, 2)
local warnPhase1	   					= mod:NewPhaseAnnounce(1, 2)
local warnPhase2Soon   					= mod:NewPrePhaseAnnounce(2, 2)
local warnPhase2     					= mod:NewPhaseAnnounce(2, 2)
local warnzemlea						= mod:NewCastAnnounce(317624, 1.5)


local specWarnCrushingEarthquake		= mod:NewSpecialWarningMove(317624, nil, nil, nil, 1, 2)
local timerShpili						= mod:NewCDTimer(60, 317267, nil, nil, nil, 3)
local timerzemio						= mod:NewCDTimer(90, 317624, nil, nil, nil, 4)
local timerseti 						= mod:NewCastTimer(2, 317274)



function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 70010, "Norigorn")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 70010, "Norigorn", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 317274 then
		warnseti:Show()
		timerseti:Start()
	elseif spellId == 317624 then
		warnzemlea:Show()
		timerzemio:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 317624 then
		if args:IsPlayer() then
			specWarnCrushingEarthquake:Show()
		end
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 317267 then
		timerShpili:Start()
	end

end
