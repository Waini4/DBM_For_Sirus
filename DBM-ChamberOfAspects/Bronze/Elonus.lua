local mod = DBM:NewMod("Elonus", "DBM-ChamberOfAspects", 3)
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(50609, 50610)
mod:RegisterCombat("combat", 50609)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
--mod.respawnTime = 20

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312214 312211 312210 312204 317156",
	-- "SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 312206 317158 317160 312208 312204 317156 317155 312213 317163 317165 317161 312209",
	"SPELL_AURA_APPLIED_DOSE 312206 317158 317160 312208 312204 317156 317155 312213 317163 317165 317161 312209",
	-- "UNIT_TARGET",
	"SPELL_DAMAGE",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_AURA_REMOVED 312204 317156 312206 317158 312208 317160 312213 317163 317161 312209",
	"UNIT_HEALTH"
-- "SWING_DAMAGE"
)

mod:AddTimerLine(L.name)

local warnArcanePunishment = mod:NewStackAnnounce(317155, 5, nil, "Tank")

local specWarnArcanePunishment   = mod:NewSpecialWarningTaunt(317155, "Tank", nil, nil, 1, 2)
local specWarnReplicaSpawnedSoon = mod:NewSpecialWarning("WarningReplicaSpawnedSoon", 312211, nil, nil, 1, 6) -- Перефаза
-- local specWarnReturnSoon					= mod:NewSpecialWarning("WarnirnReturnSoon", 312214, nil, nil, 1, 6)

local ArcanePunishmentStack = mod:NewBuffActiveTimer(30, 317155, nil, "Tank", nil, 5, nil, CL.TANK_ICON)

local warned_CopSoon = false
local warned_Cop = false

------------------------------OB---------------------------------------------
local warnTemporalCascade = mod:NewTargetAnnounce(312206, 4)
local warnReverseCascade  = mod:NewTargetAnnounce(312208, 3)
local warnReplicaSpawned  = mod:NewAnnounce("WarningReplicaSpawned", 3, 312211, "-Healer") --Временные линии(копии)
local warnPowerWordErase  = mod:NewTargetAnnounce(312204, 4) --Слово силы: Стереть

--local specPowerWordErase					= mod:NewSpecialWarningDispel(312204, "Healer", nil, nil, 1, 2)
local specWarnResonantScream         = mod:NewSpecialWarningCast(312210, "SpellCaster", nil, 2, 2, 2) --Резонирующий крик(кик)
local specWarnReturnInterrupt        = mod:NewSpecialWarningInterrupt(312214, "HasInterrupt", nil, 2, 1, 2)
local specWarnReturn                 = mod:NewSpecialWarningSwitch(312214, "-Healer", nil, nil, 1, 2)
local specWarnTemporalCascadeYou     = mod:NewSpecialWarningYou(312206, nil, nil, nil, 3, 2)
local specWarnReverseCascadeMoveAway = mod:NewSpecialWarningMoveAway(312208, nil, nil, nil, 4, 3)
local yellTemporalCascade            = mod:NewYell(312206, nil, nil, nil, "YELL") --317158
local yellReverseCascade             = mod:NewYell(312208, nil, nil, nil, "YELL")
local yellTemporalCascadeFade        = mod:NewShortFadesYell(312206, nil, nil, nil, "YELL")
local yellReverseCascadeFade         = mod:NewShortFadesYell(312208, nil, nil, nil, "YELL")

local EraseCount          = mod:NewCDCountTimer(60, 312204, nil, nil, nil, 4, nil, CL.MAGIC_ICON .. "" .. CL.HEALER_ICON) --Слово силы: Стереть
local ResonantScream      = mod:NewCDTimer(12, 312210, nil, "SpellCaster", nil, 1, nil, nil, nil, 1) --Резонирующий крик(кик)
local ReplicCount         = mod:NewCDCountTimer(120, 312211, nil, nil, nil, 2, nil, CL.IMPORTANT_ICON) --Временные линии(копии)
local ReturnCount         = mod:NewCDCountTimer(120, 312214, nil, nil, nil, 2) --Возврат
local TemporalCascade     = mod:NewCDTimer(20, 312206, nil, nil, nil, 3, nil, CL.DEADLY_ICON) --Темпоральный каскад
local TemporalCascadeBuff = mod:NewBuffFadesTimer(10, 312206, nil, nil, nil, 6, nil, CL.DEADLY_ICON) --Темпоральный каскад
local ReverseCascadeBuff  = mod:NewBuffFadesTimer(10, 312208, nil, nil, nil, 6, nil, CL.DEADLY_ICON) --Обратный каскад

mod:AddSetIconOption("SetIconTempCascIcon", 312206, true, false, { 7, 8 })
mod:AddSetIconOption("SetIconOnRevCascTargets", 312208, true, false, { 1, 2, 3, 4, 5, 6 })
mod:AddSetIconOption("SetIconOnErapTargets", 312204, true, false, { 1, 2, 3 })
mod:AddInfoFrameOption(312208, true)
-- mod:AddBoolOption("BossHealthFrame", true, "misc")
mod:AddBoolOption("RangeFrame", true)

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE25 .. " " .. CL.HEROIC_ICON)

local specWarnTimelessWhirlwindsGTFO = mod:NewSpecialWarningGTFO(317165, nil, nil, nil, 1, 2)

local TimelessWhirlwinds = mod:NewCDTimer(20, 317165, nil, nil, nil, 2) --Вневременные вихри


local RevCascTargets = {}
local TempCascTargets = {}
local ErapTargets = {}
mod.vb.ErapIcons = 3
mod.vb.RevCascIcons = 6
mod.vb.TempCascIcon = 8
mod.vb.RetCount = 0
mod.vb.RepCount = 0
mod.vb.ErapCount = 0

local function warnReverTargets(self)
	warnReverseCascade:Show(table.concat(RevCascTargets, "<, >"))
	table.wipe(RevCascTargets)
	self.vb.RevCascIcons = 6
end

local function warnTempTargets(self)
	warnTemporalCascade:Show(table.concat(TempCascTargets, "<, >"))
	table.wipe(TempCascTargets)
end

local function warnerapTargets(self)
	warnPowerWordErase:Show(table.concat(ErapTargets, "<, >"))
	table.wipe(ErapTargets)
	self.vb.ErapIcons = 3
end

local showShieldHealthBar, hideShieldHealthBar
do
	local frame = CreateFrame("Frame") -- using a separate frame avoids the overhead of the DBM event handlers which are not meant to be used with frequently occuring events like all damage events...
	local shieldedMob
	local absorbRemaining = 0
	local maxAbsorb = 0
	local function getShieldHP()
		return math.max(1, math.floor(absorbRemaining / maxAbsorb * 100))
	end

	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self, _, _, subEvent, _, _, _, destGUID, _, _, ...)
		if shieldedMob == destGUID then
			local absorbed
			if subEvent == "SWING_MISSED" then
				absorbed = select(2, ...)
			elseif subEvent == "RANGE_MISSED" or subEvent == "SPELL_MISSED" or subEvent == "SPELL_PERIODIC_MISSED" then
				absorbed = select(5, ...)
			end
			if absorbed then
				absorbRemaining = absorbRemaining - absorbed
			end
		end
	end)

	function showShieldHealthBar(self, mob, shieldName, absorb)
		shieldedMob = mob
		absorbRemaining = absorb
		maxAbsorb = absorb
		DBM.BossHealth:RemoveBoss(getShieldHP)
		DBM.BossHealth:AddBoss(getShieldHP, shieldName)
		self:Schedule(15, hideShieldHealthBar)
	end

	function hideShieldHealthBar()
		DBM.BossHealth:RemoveBoss(getShieldHP)
	end
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 50609 or 50610, "Elonus")
	mod:SetStage(1)
	self.vb.RetCount = 0
	self.vb.RepCount = 0
	self.vb.ErapCount = 0
	self.vb.RevCascIcons = 6
	self.vb.RevCascIcons = 8
	TemporalCascade:Start()
	ResonantScream:Start()
	EraseCount:Start(66, self.vb.ErapCount + 1)
	if mod:IsDifficulty("normal25") then
		self.vb.ErapIcons = 3
		ReplicCount:Start(25, self.vb.RepCount + 1)
		ReturnCount:Start(30, self.vb.RetCount + 1)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
	-- if self.Options.BossHealthFrame then
	-- 	DBM.BossHealth:Show(L.name)
	-- 	DBM.BossHealth:AddBoss(50609, L.name)
	-- end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 50609 or 50610 or 50618, "Elonus", wipe)
	DBM.RangeCheck:Hide()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 312214 and self:AntiSpam(3, 6) then
		self.vb.RetCount = self.vb.RetCount + 1
		ReturnCount:Start(nil, self.vb.RetCount + 1)
		specWarnReturn:Show(args.sourceName)
		ResonantScream:Stop()
	elseif spellId == 312211 then
		self.vb.RepCount = self.vb.RepCount + 1
		warnReplicaSpawned:Show()
		ReplicCount:Start(nil, self.vb.RepCount + 1)
	elseif spellId == 312210 then
		ResonantScream:Start()
		specWarnResonantScream:Show()
	elseif spellId == 312204 or spellId == 317156 then
		self.vb.ErapCount = self.vb.ErapCount + 1
		EraseCount:Start(nil, self.vb.ErapCount + 1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312206 or spellId == 317158 then
		TempCascTargets[#TempCascTargets + 1] = args.destName
		if self.Options.SetIconTempCascIcon and self.vb.TempCascIcon > 0 then
			self:SetIcon(args.destName, self.vb.TempCascIcon, 10)
		end
		TemporalCascade:Start()
		TemporalCascadeBuff:Show(args.destName)
		TimelessWhirlwinds:Start()
		if args:IsPlayer() then
			specWarnTemporalCascadeYou:Show()
			yellTemporalCascade:Yell()
			yellTemporalCascadeFade:Countdown(spellId)
		end
		self.vb.TempCascIcon = self.vb.TempCascIcon - 1
		self:Unschedule(warnTempTargets)
		self:Schedule(0.3, warnTempTargets, self)
	elseif args:IsSpellID(312208, 317160, 317161, 312209) then
		RevCascTargets[#RevCascTargets + 1] = args.destName
		if self.Options.SetIconOnRevCascTargets and self.vb.RevCascIcons > 0 then
			self:SetIcon(args.destName, self.vb.RevCascIcons, 10)
		end
		ReverseCascadeBuff:Start()
		DBM.Nameplate:Show(args.destGUID, 317160)

		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(10, "playerdebuffremaining", spellId)
		end
		if args:IsPlayer() then
			specWarnReverseCascadeMoveAway:Show()
			yellReverseCascade:Yell()
			yellReverseCascadeFade:Countdown(317160)
		end
		self.vb.RevCascIcons = self.vb.RevCascIcons - 1
		self:Unschedule(warnReverTargets)
		self:Schedule(0.3, warnReverTargets, self)
	elseif spellId == 312204 or spellId == 317156 then
		if mod:IsDifficulty("normal25") then
			ErapTargets[#ErapTargets + 1] = args.destName
			if self.Options.SetIconOnErapTargets and self.vb.ErapIcons > 0 then
				self:SetIcon(args.destName, self.vb.ErapIcons)
			end
			self.vb.ErapIcons = self.vb.ErapIcons - 1
			self:Unschedule(warnerapTargets)
			self:Schedule(0.3, warnerapTargets, self)
		end
		--specPowerWordErase:Show(args.destName)
		warnPowerWordErase:Show(args.destName)
	elseif spellId == 317155 and self:IsTank() and self:AntiSpam(2, 2) then
		local amount = args.amount or 1
		if amount >= 4 then
			if args:IsPlayer() then
				specWarnArcanePunishment:Show(amount)
				specWarnArcanePunishment:Play("stackhigh")
			else
				if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", spellId) then
					specWarnArcanePunishment:Show(args.destName)
					specWarnArcanePunishment:Play("tauntboss")
				else
					warnArcanePunishment:Show(args.destName, amount)
				end
			end
		end
		ArcanePunishmentStack:Start()
	elseif spellId == 312213 or spellId == 317163 then
		if mod:IsDifficulty("normal25") then
			showShieldHealthBar(self, args.destGUID, args.spellName, 400000)
		else
			showShieldHealthBar(self, args.destGUID, args.spellName, 1400000)
		end
	elseif spellId == 317165 and args:IsPlayer() then
		specWarnTimelessWhirlwindsGTFO:Show(args.spellName)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	local spellId = args.spellId
-- end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 312204 or spellId == 317156 then
		if self.Options.SetIconOnErapTargets then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 312206 or spellId == 317158 then
		if self.Options.SetIconTempCascIcon then
			self:SetIcon(args.destName, 0)
			self.vb.TempCascIcon = 8
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
		if args:IsPlayer() then
			yellTemporalCascadeFade:Cancel()
		end
	elseif args:IsSpellID(312208, 317160, 317161, 312209) then
		if self.Options.SetIconOnRevCascTargets then
			self:SetIcon(args.destName, 0)
		end
		DBM.Nameplate:Hide(args.destGUID, 317160)
		if args:IsPlayer() then
			yellReverseCascadeFade:Cancel()
		end
	elseif spellId == 312213 or spellId == 317163 then
		specWarnReturnInterrupt:Show()
		specWarnReturnInterrupt:Play("kickcast")
		hideShieldHealthBar()
	end
end

function mod:UNIT_HEALTH(uId)
	if mod:IsDifficulty("heroic25") then
		if self.vb.phase == 1 and not warned_CopSoon and self:GetUnitCreatureId(uId) == 50609 and
			UnitHealth(uId) / UnitHealthMax(uId) <= 0.53 then
			warned_CopSoon = true
			specWarnReplicaSpawnedSoon:Show()
		end
		if self.vb.phase == 1 and not warned_Cop and self:GetUnitCreatureId(uId) == 50609 and
			UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 then
			warned_Cop = true
			DBM.BossHealth:AddBoss(50610, L.name)
		end
	end
end
