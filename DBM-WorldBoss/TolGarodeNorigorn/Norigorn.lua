local mod = DBM:NewMod("Norigorn", "DBM-WorldBoss", 1)
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision(("20210501000000"):sub(12, -3))
mod:SetCreatureID(70010)
mod:SetMinCombatTime(10)

mod:RegisterCombat("combat", 70010)

mod:RegisterEvents(
	"SPELL_CAST_START 317274 317624 317275",
	"SPELL_CAST_SUCCESS 317266 317278 317279",
	"SPELL_AURA_APPLIED 317624 317273",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON 317267",
	"UNIT_HEALTH"
)

mod:AddTimerLine(L.name)
local timerCDseti    = mod:NewCDTimer(10, 317274, nil, nil, nil, 3)
local timerseti      = mod:NewCastTimer(2, 317274)
local timerStaktimer = mod:NewBuffActiveTimer(30, 317273, nil, "Healer|Tank", nil, 5, nil, CL.TANK_ICON)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(1))
local warnseti    = mod:NewCastAnnounce(317274, 2)
-- local warnPhase1     = mod:NewPhaseAnnounce(1, 2)
-- local warnPhase2Soon = mod:NewPrePhaseAnnounce(2, 2)
-- local warnPhase2     = mod:NewPhaseAnnounce(2, 2)
local warnzemlea  = mod:NewCastAnnounce(317624, 1.5)

local timerShpili = mod:NewCDTimer(60, 317267, nil, nil, nil, 3)


mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(2))

local warnEarthSoon              = mod:NewSoonAnnounce(317266, 2)
local warnCreatSoon              = mod:NewSoonAnnounce(317278, 2)
local warnDistruptSoon           = mod:NewSoonAnnounce(317279, 2)

local specWarnCrushingEarthquake = mod:NewSpecialWarningMove(317624, nil, nil, nil, 1, 2)
local specWarnEarth              = mod:NewSpecialWarningSwitch(317266, "-Healer", nil, nil, 1, 2)
local specWarnCreat              = mod:NewSpecialWarningSwitch(317278, "-Healer", nil, nil, 1, 2)
local specWarnDistrupt           = mod:NewSpecialWarningSwitch(317279, "-Healer", nil, nil, 1, 2)

local timerCDEarth               = mod:NewCDTimer(90, 317266, nil, nil, nil, 2)
local timerCDCreat               = mod:NewCDTimer(90, 317278, nil, nil, nil, 5)
local timerCDDistrupt            = mod:NewCDTimer(90, 317279, nil, nil, nil, 3)
local timerzemio                 = mod:NewCDTimer(100, 317624, nil, nil, nil, 4)

mod:AddTimerLine(DBM_COMMON_L.INTERMISSION)

local timerAcceptanceNature = mod:NewCastTimer(62, 317275)

function mod:OnCombatStart(_)
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
	warnEarthSoon:Cancel()
	timerCDEarth:Stop()
	warnCreatSoon:Cancel()
	timerCDCreat:Stop()
	warnDistruptSoon:Cancel()
	timerCDDistrupt:Stop()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(317274) then
		warnseti:Show()
		timerseti:Start()
		timerCDseti:Start()
	elseif args:IsSpellID(317624) then
		warnzemlea:Show()
		timerzemio:Start()
	elseif args:IsSpellID(317275) then
		timerAcceptanceNature:Start()
		warnEarthSoon:Cancel()
		timerCDEarth:Stop()
		warnCreatSoon:Cancel()
		timerCDCreat:Stop()
		warnDistruptSoon:Cancel()
		timerCDDistrupt:Stop()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(317266) then
		specWarnEarth:Show()
		warnEarthSoon:Schedule(55)
		timerCDEarth:Start()
	elseif args:IsSpellID(317278) then
		specWarnCreat:Show()
		warnCreatSoon:Schedule(55)
		timerCDCreat:Start()
	elseif args:IsSpellID(317279) then
		specWarnDistrupt:Show()
		warnDistruptSoon:Schedule(55)
		timerCDDistrupt:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(317624) then
		if args:IsPlayer() then
			specWarnCrushingEarthquake:Show()
		end
	elseif args:IsSpellID(317273) then
		timerStaktimer:Start(args.destName)
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 317267 then
		timerShpili:Start()
	end
end
