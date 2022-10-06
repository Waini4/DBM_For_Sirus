local mod = DBM:NewMod("Rage", "DBM-Hyjal")
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision("20220813183528")
mod:SetCreatureID(17767)
--mod:SetModelID("creature/lich/lich.m2")
mod:SetUsedIcons(7)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 317788 317801 317784 317807",
	--"SPELL_CAST_SUCCESS 317799 317793 317796",
	"SPELL_AURA_APPLIED 317807 317785 317799 317793 317796 317788",
	"SPELL_AURA_APPLIED_DOSE 317807 317785 317799 317793 317796 317788",
	"UNIT_HEALTH"
--"SPELL_AURA_REMOVED"
)



mod:AddTimerLine(L.name)
local warnOskvCast         = mod:NewCastAnnounce(317788, nil, 2)
local warnFingerofPain     = mod:NewTargetAnnounce(317801) --перст боли 317801
local warnCursingBlowStack = mod:NewStackAnnounce(317807, 5, nil, "Tank|Healer") -- 317807 Проклинающий удар
local warn2plaseSoon	   = mod:NewPrePhaseAnnounce(2, nil, nil, nil, nil, nil, 2)
local warnPhase			   = mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)

local warnOskvSoon              = mod:NewSpecialWarningMoveAway(317788, nil, nil, nil, 4, 5)
local specwarnCurseofDeception  = mod:NewSpecialWarning("|cff71d5ff|Hspell:317799|hПроклятие обмана|h|r НЕ ДИСПЕЛИТЬ!", "RemoveCurse")
local specWarnOscv              = mod:NewSpecialWarningGTFO(317788, nil, nil, nil, 1, 5)
local specWarnCurseofImpotence  = mod:NewSpecialWarningDispel(317793, "RemoveCurse", nil, nil, 1, 5) -- бессилие
local specWarnCurseofFever      = mod:NewSpecialWarningDispel(317796, "RemoveCurse", nil, nil, 1, 5) -- лихорадка
local specWarnVoltageofCircuits = mod:NewSpecialWarningStack(317785, nil, 18, nil, nil, 1, 6)

local timerOskvCast          = mod:NewCastTimer(10, 317788, nil, nil, nil, 3)
--local timerOskvCast2         = mod:NewCDTimer(10, 317788, nil, nil, nil, 3)
local timerCursingBlowBuff   = mod:NewBuffActiveTimer(60, 317807, nil, "Tank|Healer", nil, 6, nil, CL.TANK_ICON)
local timerCursingBlowCD     = mod:NewCDTimer(14, 317807, nil, "Tank|Healer", nil, 3, nil, CL.TANK_ICON) --317807 Проклинающий удар
local timerCurce             = mod:NewCDTimer(25, 301332, nil, nil, nil, 5, nil, CL.CURSE_ICON)
local timerCurce2            = mod:NewCDTimer(53.5, 317806, nil, nil, nil, 5, nil, CL.CURSE_ICON)
local timerFingerofPainCD    = mod:NewCDTimer(9, 317801, nil, nil, nil, 4, nil, CL.IMPORTANT_ICON) --перст боли кд 317801
local timerChainsofDestinies = mod:NewCDTimer(10, 317784, nil, nil, nil, 4, nil, CL.IMPORTANT_ICON) --цепи
local timerOskvCD            = mod:NewNextTimer(72, 317788, nil, nil, nil, 3, nil, CL.DEADLY_ICON) --оскв
local timerVipe		         = mod:NewNextTimer(90, 317805, nil, nil, nil, 3, nil, CL.DEADLY_ICON)

mod:AddInfoFrameOption(317785, true)
local RangeBuff = DBM:GetSpellInfoNew(317785)
mod:AddRangeFrameOption(6, nil, true)
--mod:AddBoolOption("RangeFrame", true)
mod:AddSetIconOption("SetIconOnFinger", 317801, true, false, { 7 })
--mod:AddSetIconOption("IceBoltIcon", 31249, false, false, { 7 })
local warned_p2 = false


function mod:FingerTarget(targetname)
	if not targetname then return end
	if self.Options.SetIconOnFinger then
		self:SetIcon(targetname, 7, 2)
	end
	warnFingerofPain:Show(targetname)
end



function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17767, "Rage Winterchill")
	self:SetStage(1)
	warned_p2 = false
	timerChainsofDestinies:Start()
	timerOskvCD:Start(60)
	timerFingerofPainCD:Start(20)
	timerCursingBlowCD:Start(15)
	warnOskvSoon:Schedule(55)
	timerCurce:Start()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(6)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17767, "Rage Winterchill", wipe)
	timerChainsofDestinies:Stop()
	timerOskvCD:Stop()
	timerFingerofPainCD:Stop()
	timerCursingBlowCD:Stop()
	timerCurce:Stop()
	--timerCursingBlowBuff:Stop()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local stage = mod:GetStage()
	if args:IsSpellID(317788) then
		warnOskvCast:Show()
		timerOskvCD:Start(stage == 2 and 40 or 72)
		timerOskvCast:Start(2)
		timerOskvCast:Schedule(2)
		warnOskvSoon:Schedule(65)
	elseif args:IsSpellID(317801) then
		self:BossTargetScanner(17767, "FingerTarget", 0.05, 3)
		--warnFingerofPain:Show()
		timerFingerofPainCD:Start(stage == 2 and 5 or 9)
	elseif args:IsSpellID(317784) then
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(RangeBuff)
			DBM.InfoFrame:Show(30, "playerdebuffstacks", RangeBuff, 2)
		end
	elseif args:IsSpellID(317807) then
		timerCursingBlowCD:Start(stage == 2 and 9 or 15)
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(317799) then
		specwarnCurseofDeception:Show()
		timerCurce:Start()
	elseif args:IsSpellID(317793) then
		specWarnCurseofImpotence:Show()
		timerCurce:Start()
	elseif args:IsSpellID(317796) then
		specWarnCurseofFever:Show()
		timerCurce:Start()
	elseif args:IsSpellID(317801) then
		warnFingerofPain:Show(args.destName)
	end
end]]

function mod:SPELL_AURA_APPLIED(args)
	local amount = args.amount or 1
	local stage = mod:GetStage()
	if args:IsSpellID(317788) then
		if args:IsPlayer() then
			specWarnOscv:Show(args.spellName)
		end
	elseif args:IsSpellID(317807) then
		--warnCursingBlowStack:Show(args.destName, amount)
		--	timerCursingBlowBuff:Start(args.destName)
	elseif args:IsSpellID(317785) then
		if args:IsPlayer() and amount >= 18 then
			specWarnVoltageofCircuits:Show(args.amount)
		end
	elseif args:IsSpellID(317799) and self:AntiSpam(2) then
		specwarnCurseofDeception:Show()
		timerCurce:Start()
	elseif args:IsSpellID(317793) and self:AntiSpam(2) then
		specWarnCurseofImpotence:Show(args.destName)
		timerCurce:Start()
	elseif args:IsSpellID(317796) and self:AntiSpam(2) then
		specWarnCurseofFever:Show(args.destName)
		timerCurce:Start()
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED


function mod:UNIT_HEALTH(uId)
	local stage = mod:GetStage()
	local hp = DBM:GetBossHPByUnitID("boss1")
	if not hp then
		if self:GetUnitCreatureId(uId) == 17767 then
				hp = DBM:GetBossHPByUnitID(uId)
		end
	end
	if hp and hp <= 37 and not warned_p2 then
		warned_p2 = true
		warn2plaseSoon:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.prestage:format(2))
	end
	if hp and hp <= 35 and stage == 1 then
		self:SetStage(2)
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
		warnPhase:Play("ptwo")
		timerVipe:Start()
		timerCurce:Stop()
		timerCurce2:Start()
		timerOskvCD:Start(30)
		timerCursingBlowCD:Start(10)
		timerFingerofPainCD:Start(20)
		warnOskvSoon:Cancel()
		warnOskvSoon:Schedule(25)
	end

end
