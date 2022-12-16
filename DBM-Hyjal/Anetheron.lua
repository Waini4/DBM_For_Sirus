local mod = DBM:NewMod("Anetheron", "DBM-Hyjal")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17808)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 317870 317872 317873 317884",
	--"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 317876 317872",
	"SPELL_AURA_REFRESH 317876 317872",
	--"SPELL_AURA_REMOVED",
	"SPELL_SUMMON 317870",
	"UNIT_HEALTH"
)

local warnInferno            = mod:NewTargetNoFilterAnnounce(317870, 4)
local warnFingerofDeath      = mod:NewTargetNoFilterAnnounce(317876, 4)
local warnManaAbsorptionCast = mod:NewCastAnnounce(317884, 5, 1.5)
local warnWaveHorrorSoon     = mod:NewSoonAnnounce(317873, 3)

local specWarnTimerMoved 	 = mod:NewSpecialWarning("|cff71d5ff|Hspell:317873|hФир|h|r СМЕСТИЛСЯ НА 3 СЕК!")
local warnwarnInfernoSoon    = mod:NewSpecialWarningSoon(317870, "Melee", nil, nil, 4, 2)
local specWarnInfernoDeff    = mod:NewSpecialWarningDefensive(317870, "Tank", nil, nil, 1, 2)
local specWarnInferno        = mod:NewSpecialWarningMoveAway(317870, nil, nil, nil, 4, 2)
local specWarnCrimsonBarrier = mod:NewSpecialWarningDispel(317872, "MagicDispeller", nil, nil, 1, 2)
local specWarnManaAbsorption = mod:NewSpecialWarningInterrupt(317884, "HasInterrupt", nil, nil, 1, 2)

local timerCrimsonBarrierNext = mod:NewNextTimer(30, 317872, nil, nil, nil, 4)
local timerManaAbsorptionNext = mod:NewNextTimer(20, 317884, nil, nil, nil, 4)
local timerWaveHorror         = mod:NewCDTimer(20, 317873, nil, nil, nil, 5, nil, nil, nil, 1)
local timerFingerofDeathCD    = mod:NewCDTimer(7, 317876, nil, nil, nil, 4)
local timerInfernoCast        = mod:NewCastTimer(3, 317870, nil, nil, nil, 3)
local berserkTimer		      = mod:NewBerserkTimer(600)

local warned_F1 = false
local warned_F2 = false
local warned_F3 = false
local warned_F4 = false
local warned_F5 = false
local warned_F6 = false
local warned_F7 = false
local warned_F8 = false
local warned_F9 = false

function mod:InfernoTarget(targetname)
	if not targetname then return end
	warnInferno:Show(targetname)
	if targetname == UnitName("player") then
		specWarnInfernoDeff:Show()
	elseif self:CheckNearby(20, targetname) then
		specWarnInferno:Show()
	end
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17808, "Anetheron")
	self:SetStage(1)
	timerWaveHorror:Start()
	timerCrimsonBarrierNext:Start(60)
	berserkTimer:Start()
	warned_F1 = false
	warned_F2 = false
	warned_F3 = false
	warned_F4 = false
	warned_F5 = false
	warned_F6 = false
	warned_F7 = false
	warned_F8 = false
	warned_F9 = false
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17808, "Anetheron", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(317870) then
		if timerWaveHorror:GetRemaining() < 2 then
			specWarnTimerMoved:Show()
			timerWaveHorror:Start(3)
		end
		timerInfernoCast:Start()
		self:BossTargetScanner(17808, "InfernoTarget", 0.05, 10)
	elseif args:IsSpellID(317872) then
		specWarnCrimsonBarrier:Show()
		timerCrimsonBarrierNext:Start()
	elseif args:IsSpellID(317873) then
		warnWaveHorrorSoon:Schedule(17)
		timerWaveHorror:Start()
	elseif args:IsSpellID(317884) then
		warnManaAbsorptionCast:Show()
		specWarnManaAbsorption:Show()
		timerManaAbsorptionNext:Start()
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
end]]

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(317876) then
		warnFingerofDeath:Show(args.destName)
		timerFingerofDeathCD:Start()
	elseif args:IsSpellID(317872) then
		specWarnCrimsonBarrier:Show()
	end
end

mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED
--[[
function mod:SPELL_AURA_REMOVED(args)
end]]

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(317870) then
		timerManaAbsorptionNext:Start()
	end
end

function mod:UNIT_HEALTH(uId)
	--local hp = self:GetUnitCreatureId(uId) == 17808
	local hp = self:GetUnitCreatureId(uId) == 17808 and DBM:GetBossHP(17808) or nil
	if hp then -- or hp < 82 or hp < 72 or hp < 62 or hp < 52 or hp < 42 or hp < 32 or hp < 22 or hp < 12 then
		if not warned_F1 and hp < 92 then
			warned_F1 = true
			warnwarnInfernoSoon:Show()
		elseif not warned_F2 and hp < 82 then
			warned_F2 = true
			warnwarnInfernoSoon:Show()
		elseif	not warned_F3 and hp < 72 then
			warned_F3 = true
			warnwarnInfernoSoon:Show()
		elseif	not warned_F4 and hp < 62 then
			warned_F4 = true
			warnwarnInfernoSoon:Show()
		elseif not warned_F5 and hp < 52 then
			warned_F5 = true
			warnwarnInfernoSoon:Show()
		elseif not warned_F6 and hp < 42 then
			warned_F6 = true
			warnwarnInfernoSoon:Show()
		elseif not warned_F7 and hp < 32 then
			warned_F7 = true
			warnwarnInfernoSoon:Show()
		elseif	not warned_F8 and hp < 22 then
			warned_F8 = true
			warnwarnInfernoSoon:Show()
		elseif	not warned_F9 and hp < 12 then
			warned_F9 = true
			warnwarnInfernoSoon:Show()
		end
	end
end
