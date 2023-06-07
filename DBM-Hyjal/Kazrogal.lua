local mod = DBM:NewMod("Kazrogal", "DBM-Hyjal")
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision("20220901020228")
mod:SetCreatureID(17888)

mod:RegisterCombat("combat")
mod:SetUsedIcons(6, 7, 8)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 318818 318824 318823 318834 318833",
	"SPELL_CAST_SUCCESS 318828 318825 318826 318839",
	"SPELL_AURA_APPLIED 318819 318825 318845 318822 318828 318839",
	--"SPELL_AURA_REFRESH ",
	"SPELL_AURA_REMOVED 318822",
	"UNIT_TARGET",
	--"SPELL_SUMMON ",
	"UNIT_HEALTH"
)


local warn2phaseSoon = mod:NewPrePhaseAnnounce(2, nil, nil, nil, nil, nil, 2)
local warnPhase      = mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(1))
local warnMark                      = mod:NewTargetNoFilterAnnounce(318819, 3)
local warnInfernalStrike            = mod:NewCastAnnounce(318823, 4, 1.5)
local warnFatalBlowofFilth          = mod:NewCastAnnounce(318833, 4, 1.5)

local specwarnAbbasSoon             = mod:NewSpecialWarningSoon(318825, nil, nil, nil, 1, 3)
local specWarnBurningSoul           = mod:NewSpecialWarningDispel(318828, "RemoveMagic", nil, nil, 1, 3)
local specWarnHorrorflames          = mod:NewSpecialWarningInterrupt(318822, "HasInterrupt", nil, nil, 1, 2)
local specWarnUnstoppableOnslaught  = mod:NewSpecialWarning("|cff71d5ff|Hspell:318822|hНеудержимый натиск|h|r Закончился можно сбивать касты!","HasInterrupt")
local specWarnGTFO                  = mod:NewSpecialWarningGTFO(318825, nil, nil, nil, 4, 8)
local timerMarkCD                   = mod:NewNextCountTimer(24, 318818, nil, nil, nil, 2, nil, CL.IMPORTANT_ICON)
local timerBurningSoulCD            = mod:NewNextCountTimer(20, 318828, nil, "RemoveMagic", nil, 3, nil, CL.HEALER_ICON)
local timerHorrorflamesCD           = mod:NewNextCountTimer(16, 318824, nil, nil, nil, 3)
local timerUnstableAbyssalsCD    	  = mod:NewNextCountTimer(90, 318825, "Падение Абиссалов", nil, nil, 4, nil, CL.DEADLY_ICON)
local timerInfernalStrikeCD         = mod:NewNextTimer(9, 318823, nil, "Tank|Healer", nil, 4, nil, CL.TANK_ICON)
local timerunstoppableonslaughtBuff = mod:NewBuffActiveTimer(25, 318822, nil, "HasInterrupt", nil, 4, nil, CL.INTERRUPT_ICON) --ad
local timerFatalBlowofFilthCD       = mod:NewNextTimer(17, 318833, nil, "Tank|Healer", nil, 4, nil, CL.TANK_ICON)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(2))
local specwarnFallofFilthSoon = mod:NewSpecialWarningSoon(318834, nil, nil, nil, 1, 3)
local specWarnMutilation      = mod:NewSpecialWarningDispel(318839, "RemoveCurse", nil, nil, 1, 3)
local specWarnFallofFilth     = mod:NewSpecialWarningInterrupt(318834, "HasInterrupt", nil, nil, 1, 2)
local timerMutilationlCD      = mod:NewNextTimer(20, 318839, nil, "RemoveCurse", nil, 3, nil, CL.CURSE_ICON)

local timerFallofFilthCD      = mod:NewNextCountTimer(17, 318834, nil, nil, nil, 3)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(3))
local warnInfernalStrike3p = mod:NewCastAnnounce(318841, 4, 1.5)

local timerInfernalStrike3pCD = mod:NewNextTimer(6, 318841, nil, "Tank|Healer", nil, 4, nil, CL.TANK_ICON)

--local MarkBuff = DBM:GetSpellInfoNew(318819)
-- local warned_F2 = false
-- local warned_F3 = false
-- last = math.floor(UnitMana(player) / UnitManaMax(player) * 100)
local AbbGuids = {}
mod.vb.BurningCount = 0
mod.vb.MarkCount = 0
mod.vb.HorrorflamesCount = 0
mod.vb.AbyssalsCount = 0
mod.vb.FallofFilthCount = 0
local kik = false
mod:AddInfoFrameOption(318819, true)
mod:AddBoolOption("SetAbbIcon", false)
mod:AddBoolOption("AnnounceVoicePhase", true, "misc")
local MarkBuff = DBM:GetSpellInfoNew(318819)
-- mod:AddBoolOption("HpOff", true)

local function Abyssals(self)
	self.vb.AbyssalsCount = self.vb.AbyssalsCount + 1
	timerUnstableAbyssalsCD:Start((mod:GetStage() == 1 and 90) or 20, self.vb.AbyssalsCount + 1)
	specwarnAbbasSoon:Schedule(mod:GetStage() == 1 and 86 or 16)
	specwarnAbbasSoon:Schedule(mod:GetStage() == 1 and 89 or 19)
	self:Schedule((mod:GetStage() == 1 and 90) or 20, Abyssals, self)
	--warnAbbasSoon:Schedule(55)
	--warnAbbasSoon:Schedule(59)
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17888, "Kaz'rogal")
	self:SetStage(1)
	table.wipe(AbbGuids)
	self.vb.BurningCount = 0
	self.vb.MarkCount = 0
	self.vb.HorrorflamesCount = 0
	self.vb.AbyssalsCount = 0
	self.vb.FallofFilthCount = 0
	self.vb.AbbIcon = 8
	kik = false
	-- warned_F2 = false
	-- warned_F3 = false
	timerHorrorflamesCD:Start(15, self.vb.HorrorflamesCount)
	timerInfernalStrikeCD:Start(7)
	timerBurningSoulCD:Start(nil, self.vb.BurningCount)
	timerMarkCD:Start(1)
	specwarnAbbasSoon:Schedule(56)
	specwarnAbbasSoon:Schedule(59)
	timerUnstableAbyssalsCD:Start(60, self.vb.AbyssalsCount)
	self:Schedule(60, Abyssals, self)
	if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
		DBM.InfoFrame:SetHeader(MarkBuff)
		DBM.InfoFrame:Show(10, "playerpower", 50, 0, 318819)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17888, "Kaz'rogal", wipe)
	self:Unschedule(Abyssals)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(318818) then
		self.vb.MarkCount = self.vb.MarkCount + 1
		timerMarkCD:Start(nil, self.vb.MarkCount + 1)
	elseif args:IsSpellID(318824) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) and not kik then
			specWarnHorrorflames:Show(args.sourceName)
			specWarnHorrorflames:Play("kickcast")
		end
		self.vb.HorrorflamesCount = self.vb.HorrorflamesCount + 1
		timerHorrorflamesCD:Start(nil, self.vb.HorrorflamesCount + 1)
	elseif args:IsSpellID(318834) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) and not kik then
			specWarnFallofFilth:Show(args.sourceName)
			specWarnFallofFilth:Play("kickcast")
		end
		if timerFallofFilthCD:GetRemaining() < 3 and kik and self:AntiSpam(2) then
			specwarnFallofFilthSoon:Show()
		end
		self.vb.FallofFilthCount = self.vb.FallofFilthCount + 1
		timerFallofFilthCD:Start(nil, self.vb.FallofFilthCount + 1)
	elseif args:IsSpellID(318823) then
		warnInfernalStrike:Show()
		timerInfernalStrikeCD:Start()
	elseif args:IsSpellID(318841) then
		warnInfernalStrike3p:Show()
		timerInfernalStrike3pCD:Start()
	elseif args:IsSpellID(318833) then
		warnFatalBlowofFilth:Show()
		timerFatalBlowofFilthCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local stage = mod:GetStage()
	if args:IsSpellID(318828) then
		self.vb.BurningCount = self.vb.BurningCount + 1
		timerBurningSoulCD:Start(nil, self.vb.BurningCount + 1)
		--[[elseif args:IsSpellID(318826) and stage == 3 then
		self.vb.AbyssalsCount = self.vb.AbyssalsCount + 1
		timerUnstableAbyssalsCD:Start(20, self.vb.AbyssalsCount + 1)
		specwarnAbbasSoon:Schedule(16)
		specwarnAbbasSoon:Schedule(19)]]
	elseif args:IsSpellID(318839) then
		timerMutilationlCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(318819) then
		warnMark:Show(args.destName)
	elseif args:IsSpellID(318839) and self:AntiSpam(2) then
		specWarnMutilation:Show(args.destName)
		--timerMutilationlCD:Start()
	elseif args:IsSpellID(318825) and self:AntiSpam(4) then
		specWarnGTFO:Show(args.spellName)
	elseif args:IsSpellID(318822) and not kik then
		timerunstoppableonslaughtBuff:Start()
		kik = true
	elseif args:IsSpellID(318828) and self:AntiSpam(2) then
		specWarnBurningSoul:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(318822) and kik then
		specWarnUnstoppableOnslaught:Show()
		kik = false
	end
end

local hp
local stage
function mod:UNIT_HEALTH(uId)
	stage = self:GetStage()
	if self:GetUnitCreatureId(uId) == 17888 then
		hp = DBM:GetBossHPByUnitID(uId)
	end
	if stage and hp then
		if hp < 67 and stage == 1 then
			self:SetStage(2)
			self:Unschedule(Abyssals)
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
			timerUnstableAbyssalsCD:Stop()
			timerHorrorflamesCD:Stop()
			timerInfernalStrikeCD:Stop()
			timerMarkCD:Stop()
			timerBurningSoulCD:Stop()
			specwarnAbbasSoon:Cancel()
			specwarnAbbasSoon:Cancel()
			timerMutilationlCD:Start()
			timerFallofFilthCD:Start(16.5, self.vb.BurningCount)
			timerFatalBlowofFilthCD:Start(15)
		elseif hp < 33 and stage == 2 then -- -_-
			self.vb.AbyssalsCount = 0
			self:SetStage(3)
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(3))
			timerMutilationlCD:Stop()
			timerFallofFilthCD:Stop()
			timerUnstableAbyssalsCD:Start(20)
			self:Schedule(20, Abyssals, self)
			timerHorrorflamesCD:Start(10) -- ~~~~~~
			specwarnAbbasSoon:Schedule(8)
		end
	end
end

local function ScanWhitName(name)
	local target
	for i = 1, GetNumRaidMembers() do
		local unit = "raid" .. i .. "target"
		local guid = UnitGUID(unit)
		-- if name == "Некромант" then
		if guid and UnitName(unit) == name and not AbbGuids[guid] then
			target = unit
			AbbGuids[guid] = true
			return target
		end
		-- end
	end
	return nil
end

function mod:UNIT_TARGET()
	if self.Options.SetAbbIcon then
		local uid = ScanWhitName("Нестабильный абиссал")
		if uid then
			if self:GetStage() == 1 then
				self:SetIcon(uid, self.vb.AbbIcon)
				mod.vb.AbbIcon = mod.vb.AbbIcon - 1
				if mod.vb.AbbIcon < 6 then
					mod.vb.AbbIcon = 8
				end
			end
		end
	end
end
