local mod = DBM:NewMod("Ctrax", "DBM-Tol'GarodePrison")
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L

mod:SetRevision("20210501000000") -- fxpw check 20220609123000
mod:SetCreatureID(84002)
mod:RegisterCombat("combat", 84002)
mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterEvents(
	"SPELL_CAST_START 317579 317596 317571 317604",
	-- "SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 317594 317595 317565",
	"SPELL_AURA_APPLIED_DOSE 317594 317595 317565",
	"SPELL_AURA_REMOVED 317594 317565",
	"SPELL_SUMMON 317567",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_HEALTH"
)

--8 сек дар йога 317601
--15 сек область тьмы 317596
--20 сек колодец 317594
--50 погружение

local warnPhase2Soon   = mod:NewPrePhaseAnnounce(2) -- анонс о скорой 2 фазе
local warnPhase2       = mod:NewPhaseAnnounce(2) -- оповещение второй фазы
local warnAncientCurse = mod:NewTargetAnnounce(317594, 3)
local warnSphere       = mod:NewSpellAnnounce(317567, 2) --Сфера Тьмы
local warnBreath       = mod:NewSpellAnnounce(317571, 2, nil, "Healer") --Дыхание Мрака

local specwarnEscapingDarkness = mod:NewSpecialWarningCast(317579, nil, nil, nil, 2, 2)
local specWarnAncientCurseYou  = mod:NewSpecialWarningMoveAway(317594, nil, nil, nil, 3, 2)
local specWarnWell             = mod:NewSpecialWarningMove(317595, nil, nil, nil, 2, 1) --Теневой Колодец
local yellAncientCurse         = mod:NewYell(317594, nil, nil, nil, "YELL") --317158
local yellAncientCurseFade     = mod:NewShortFadesYell(317594, nil, nil, nil, "YELL")
local specWarnImmersion        = mod:NewSpecialWarning("Immersion", nil, nil, nil, 2, 1) --Погружение во мрак

local timerBreathCD         = mod:NewCDTimer(24, 317571, nil, nil, nil, 2) --Дыхание Мрака
local timerEscapingDarkness = mod:NewCDTimer(35, 317579, nil, nil, nil, 2, nil, CL.DEADLY_ICON)
local timerdar              = mod:NewCDTimer(8, 317601, nil, nil, nil, 2, nil, CL.IMPORTANT_ICON)
local timerRegionofDarkness = mod:NewCDTimer(35, 317596, nil, nil, nil, 2, nil, CL.IMPORTANT_ICON)
local timerCurse            = mod:NewTargetTimer(5, 317594, nil, nil, nil, 2) --Древнее проклятие
local timerAncientCurse     = mod:NewCDTimer(23, 317594, nil, nil, nil, 2, nil, CL.IMPORTANT_ICON)
local timerMark             = mod:NewTargetTimer(10, 317565, nil, nil, nil, 2) --Метка Безликого
local timerImmersion        = mod:NewCastTimer(5, 317604, nil, nil, nil, 7) --Погружение во мрак

local warned_P1 = false
local warned_P2 = false
local CurseTargets = {}
mod.vb.CurseIcon = 7

mod:AddInfoFrameOption(317579, false)
mod:AddSetIconOption("SetIconOnMark", 317565, true, true, { 8 })
mod:AddSetIconOption("SetIconOnCurse", 317594, true, true, { 4, 5, 6, 7 })
mod:SetStage(0)

local function CurseIcons(self)
	table.wipe(CurseTargets)
	self.vb.MarkofFilthIcon = 7
end

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", function(self)
	for i = 1, MAX_RAID_MEMBERS do
		local pt = UnitName("raid" .. i .. "-target")
		if pt and pt == "Поглотитель разума Ктракс" then
			DBM:FireCustomEvent("DBM_EncounterStart", 84002, "Ctrax")
			self:SetStage(1)
			timerEscapingDarkness:Start()
			self:ScheduleMethod(0.1, "CreatePowerFrame")
			if self.Options.BossHealthFrame then
				DBM.BossHealth:Show(L.name)
				DBM.BossHealth:AddBoss(84002, L.name)
			end
		end
	end
end)
--[[
function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 84002, "Ctrax")
	self:SetStage(1)
	timerEscapingDarkness:Start()
	self:ScheduleMethod(0.1, "CreatePowerFrame")
	if self.Options.BossHealthFrame then
		DBM.BossHealth:Show(L.name)
		DBM.BossHealth:AddBoss(84002, L.name)
	end

	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(CL.INFOFRAME_POWER)
		DBM.InfoFrame:Show(2, "enemypower", 1) --TODO, figure out power type
	end
end]]

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 84002, "Ctrax", wipe)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

do -- тест!!!!!
	local last = 100
	local function getPowerPercent()
		local guid = UnitGUID("focus")
		if mod:GetCIDFromGUID(guid) == 84002 then
			last = math.floor(UnitPower("focus") / UnitPowerMax("focus") * 100)
			return last
		end
		for i = 0, GetNumRaidMembers(), 1 do
			local unitId = ((i == 0) and "target") or ("raid" .. i .. "target")
			guid = UnitGUID(unitId)
			if mod:GetCIDFromGUID(guid) == 84002 then
				last = math.floor(UnitPower(unitId) / UnitPowerMax(unitId) * 100)
				return last
			end
		end
		return last
	end

	function mod:CreatePowerFrame()
		DBM.BossHealth:AddBoss(getPowerPercent, L.PowerPercent)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(317579) then
		specwarnEscapingDarkness:Show()
		timerEscapingDarkness:Start()
	elseif args:IsSpellID(317596) then
		timerRegionofDarkness:Start()
	elseif args:IsSpellID(317571) then --Дыхание Мрака
		warnBreath:Show()
		timerBreathCD:Start()
	elseif args:IsSpellID(317604) then --Погружение во мрак
		specWarnImmersion:Show()
		timerImmersion:Start()
		PlaySoundFile("Sound\\Creature\\LadyMalande\\BLCKTMPLE_LadyMal_Aggro01.wav")
	end
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	local spellId = args.spellId
-- end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if args:IsSpellID(317594) then
		CurseTargets[#CurseTargets + 1] = args.destName
		if self.Options.SetIconOnCurse and self.vb.CurseIcon > 0 then
			self:SetIcon(args.destName, self.vb.CurseIcon)
		end
		warnAncientCurse:Show(args.destName)
		timerAncientCurse:Start()
		if args:IsPlayer() then
			timerCurse:Start(args.destName)
			specWarnAncientCurseYou:Show()
			yellAncientCurse:Yell()
			yellAncientCurseFade:Countdown(spellId)
		end
		self.vb.CurseIcon = self.vb.CurseIcon - 1
		self:Unschedule(CurseIcons)
		self:Schedule(0.5, CurseIcons, self)
	elseif args:IsSpellID(317595) and self:AntiSpam(3) then --Теневой Колодец
		if args:IsPlayer() then
			specWarnWell:Show()
		end
	elseif args:IsSpellID(317565) then --Метка Безликого
		timerMark:Start(args.destName)
		if self.Options.SetIconOnMark then
			self:SetIcon(args.destName, 8, 10)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(317567) then --Сфера Тьмы
		warnSphere:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(317594) then --Древнее проклятие
		if self.Options.SetIconOnCurse then
			self:RemoveIcon(args.destName)
		end
	elseif args:IsSpellID(317565) then --Метка Безликого
		if self.Options.SetIconOnMark then
			self:RemoveIcon(args.destName)
		end
	end
end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	local spellId = args.spellId
-- end

function mod:UNIT_HEALTH(uId) -- перефаза по хп
	if not warned_P1 and self:GetUnitCreatureId(uId) == 84002 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.53 and
		mod:IsDifficulty("heroic25") then
		warned_P1 = true
		warnPhase2Soon:Show()
	elseif not warned_P2 and self:GetUnitCreatureId(uId) == 84002 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 and
		mod:IsDifficulty("heroic25") then
		warned_P2 = true
		warnPhase2:Show()
		self:SetStage(2)
		timerEscapingDarkness:Cancel()
		timerdar:Start()
		timerRegionofDarkness:Start(15)
		timerAncientCurse:Start()
	end
end
