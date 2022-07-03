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
	"SPELL_AURA_APPLIED 312206 317158 317160 312208 312204 317156 317155 312213 317163 317165",
	"SPELL_AURA_APPLIED_DOSE 312206 317158 317160 312208 312204 317156 317155 312213 317163 317165",
	-- "UNIT_TARGET",
	"SPELL_DAMAGE",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_AURA_REMOVED 312204 317156 312206 317158 312208 317160 312213 317163",
	"UNIT_HEALTH"
-- "SWING_DAMAGE"
)



local warnArcanePunishment = mod:NewStackAnnounce(317155, 5, nil, "Tank")

local specWarnArcanePunishment       = mod:NewSpecialWarningTaunt(317155, "Tank", nil, nil, 1, 2)
local specWarnReplicaSpawnedSoon     = mod:NewSpecialWarning("WarningReplicaSpawnedSoon", 312211, nil, nil, 1, 6) -- Перефаза
-- local specWarnReturnSoon					= mod:NewSpecialWarning("WarnirnReturnSoon", 312214, nil, nil, 1, 6)
local specWarnTimelessWhirlwindsGTFO = mod:NewSpecialWarningGTFO(317165, nil, nil, nil, 1, 2)

local TimelessWhirlwinds    = mod:NewCDTimer(20, 317165, nil, nil, nil, 2) --Вневременные вихри
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
local specWarnReverseCascadeMoveAway = mod:NewSpecialWarningMoveAway(312208, nil, nil, nil, 1, 2)
local yellTemporalCascade            = mod:NewYell(312206, nil, nil, nil, "YELL") --317158
local yellReverseCascade             = mod:NewYell(312208, nil, nil, nil, "YELL")
local yellTemporalCascadeFade        = mod:NewShortFadesYell(312206, nil, nil, nil, "YELL")
local yellReverseCascadeFade         = mod:NewShortFadesYell(312208, nil, nil, nil, "YELL")

local EraseCount          = mod:NewCDCountTimer(60, 312204, nil, nil, nil, 2) --Слово силы: Стереть
local ResonantScream      = mod:NewCDTimer(12, 312210, nil, "SpellCaster", nil, 1, nil, nil, nil, 1) --Резонирующий крик(кик)
local ReplicCount         = mod:NewCDCountTimer(120, 312211, nil, nil, nil, 2) --Временные линии(копии)
local ReturnCount         = mod:NewCDCountTimer(120, 312214, nil, nil, nil, 2) --Возврат
local TemporalCascade     = mod:NewCDTimer(20, 312206, nil, nil, nil, 2) --Темпоральный каскад
local TemporalCascadeBuff = mod:NewBuffFadesTimer(10, 312206, nil, nil, nil, 6) --Темпоральный каскад
local ReverseCascadeBuff  = mod:NewBuffFadesTimer(10, 312208, nil, nil, nil, 6) --Обратный каскад
local enrage              = mod:NewBerserkTimer(600)

mod:AddSetIconOption("SetIconTempCascIcon", 312206, true, false, { 7, 8 })
mod:AddSetIconOption("SetIconOnRevCascTargets", 312208, true, false, { 1, 2, 3, 4, 5, 6 })
mod:AddSetIconOption("SetIconOnErapTargets", 312204, true, false, { 1, 2, 3 })
mod:AddBoolOption("AnnounceReverCasc", false)
mod:AddBoolOption("AnnounceErap", false)
mod:AddBoolOption("AnnounceTempCasc", false)
mod:AddInfoFrameOption(312208, true)
-- mod:AddBoolOption("BossHealthFrame", true, "misc")
mod:AddBoolOption("RangeFrame", true)


local RevCascTargets = {}
local TempCascTargets = {}
local ErapTargets = {}
local ErapIcons = 3
local RevCascIcons = 6
local TempCascIcon = 8
mod.vb.RetCount = 0
mod.vb.RepCount = 0
mod.vb.ErapCount = 0



local setIncinerateTarget, clearIncinerateTarget
local diffMaxAbsorb = { heroic25 = 1400000, normal25 = 400000 }
do
	local incinerateTarget
	local damaged = 0
	local maxAbsorb = diffMaxAbsorb[DBM:GetCurrentInstanceDifficulty()] or 0

	local function getShieldHP()
		return math.max(100, math.floor(damaged / maxAbsorb * 100))
	end

	function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, _, _, _, _, _, absorbed)
		if destGUID == incinerateTarget then
			damaged = damaged + (absorbed or 0)
		end
	end

	mod.SPELL_PERIODIC_DAMAGE = mod.SPELL_DAMAGE

	function setIncinerateTarget(mod, target, name)
		incinerateTarget = target
		damaged = 0
		DBM.BossHealth:RemoveBoss(getShieldHP)
		DBM.BossHealth:AddBoss(getShieldHP, L.IncinerateTarget:format(name))
	end

	function clearIncinerateTarget(self, name)
		DBM.BossHealth:RemoveBoss(getShieldHP)
		damaged = 0
		if self.Options.IncinerateFleshIcon then
			self:RemoveIcon(name)
		end
	end
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 50609 or 50610, "Elonus")
	mod:SetStage(1)
	self.vb.RetCount = 0
	self.vb.RepCount = 0
	self.vb.ErapCount = 0
	TemporalCascade:Start()
	ResonantScream:Start()
	EraseCount:Start(66, self.vb.ErapCount + 1)
	enrage:Start()
	if mod:IsDifficulty("normal25") then
		ReplicCount:Start(25, self.vb.RepCount + 1)
		ReturnCount:Start(30, self.vb.RetCount + 1)
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
		TemporalCascade:Start()
		warnTemporalCascade:Show(args.destName)
		TemporalCascadeBuff:Show(args.destName)
		TimelessWhirlwinds:Start()
		if args:IsPlayer() then
			specWarnTemporalCascadeYou:Show()
			yellTemporalCascade:Yell()
			yellTemporalCascadeFade:Countdown(spellId)
		end
		if mod.Options.AnnounceTempCasc then
			if DBM:GetRaidRank() > 0 then
				SendChatMessage(L.TempCasc:format(TempCascIcon, args.destName), "RAID_WARNING")
			else
				SendChatMessage(L.TempCasc:format(TempCascIcon, args.destName), "RAID")
			end
		end
		if self.Options.SetIconTempCascIcon then
			self:SetIcon(args.destName, TempCascIcon, 10)
		end
		TempCascIcon = TempCascIcon - 1
	elseif spellId == 312208 or spellId == 317160 then
		RevCascTargets[#RevCascTargets + 1] = args.destName
		ReverseCascadeBuff:Start()
		DBM.Nameplate:Show(args.destGUID, 317160)

		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(10, "playerdebuffremaining", spellId)
		end
		if args:IsPlayer() then
			specWarnReverseCascadeMoveAway:Show()
			yellReverseCascade:Yell()
			yellReverseCascadeFade:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
		self:ScheduleMethod(0.1, "SetRevCascIcons")
	elseif spellId == 312204 or spellId == 317156 then
		ErapTargets[#ErapTargets + 1] = args.destName
		if mod:IsDifficulty("normal25") then
			self:ScheduleMethod(0.1, "SetErapIcons")
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
		setIncinerateTarget(self, args.destGUID, args.destName)
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
		if self.Options.TempCascIcon then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
		TempCascIcon = 8
		if args:IsPlayer() then
			yellTemporalCascadeFade:Cancel()
		end
	elseif spellId == 312208 or spellId == 317160 then
		if self.Options.SetIconOnRevCascTargets then
			self:SetIcon(args.destName, 0)
		end
		DBM.Nameplate:Hide(args.destGUID, 317160)
		if args:IsPlayer() then
			yellReverseCascadeFade:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 312213 or spellId == 317163 then
		specWarnReturnInterrupt:Show()
		specWarnReturnInterrupt:Play("kickcast")
		clearIncinerateTarget(self, args.destName)
	end
end

do
	-- local function sort_by_group(v1, v2)
	-- 	return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	-- end
	function mod:SetRevCascIcons()
		table.sort(RevCascTargets, function(v1, v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
		for _, v in ipairs(RevCascTargets) do
			if mod.Options.AnnounceReverCasc then
				if DBM:GetRaidRank() > 0 then
					SendChatMessage(L.RevCasc:format(RevCascIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.RevCasc:format(RevCascIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnRevCascTargets then
				self:SetIcon(UnitName(v), RevCascIcons, 10)
			end
			RevCascIcons = RevCascIcons - 1
		end
		warnReverseCascade:Show(table.concat(RevCascTargets, "<, >"))
		table.wipe(RevCascTargets)
		RevCascIcons = 6
	end

	function mod:SetErapIcons()
		table.sort(ErapTargets, function(v1, v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
		for _, v in ipairs(ErapTargets) do
			if mod.Options.AnnounceErap then
				if DBM:GetRaidRank() > 0 then
					SendChatMessage(L.Erapc:format(ErapIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.Erapc:format(ErapIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnErapTargets then
				self:SetIcon(UnitName(v), ErapIcons)
			end
			ErapIcons = ErapIcons - 1
		end
		if #ErapTargets >= 3 then
			warnPowerWordErase:Show(table.concat(ErapTargets, "<, >"))
			table.wipe(ErapTargets)
			ErapIcons = 3
		end
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
