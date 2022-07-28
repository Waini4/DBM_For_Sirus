local mod = DBM:NewMod("MagicEater", "DBM-Tol'GarodePrison")
--local L   = mod:GetLocalizedStrings()
--local CL  = DBM_COMMON_L

mod:SetRevision("20210501000000") -- fxpw check 20220609123000
mod:SetCreatureID(84017)
mod:SetUsedIcons(6, 7, 8)

mod:RegisterCombat("combat", 84017)

mod:RegisterEvents(
	"SPELL_CAST_START 317673 317674",
	"SPELL_AURA_APPLIED 317641 317645 317681 317683 317662 317666 317650 317653",
	"SPELL_AURA_REMOVED 317662 317666",
	"SPELL_SUMMON 317685",
	"UNIT_HEALTH"
)

--SPELL_AURA_APPLIED,317664,"Колодец Тьмы",0x20,DEBUFF
--SPELL_AURA_APPLIED,317668,"Очаг Скверны",0x4,DEBUFF
local warnActivationDark = mod:NewSpellAnnounce(317650, 3) --Активация: Тьма
local warnActivationFel  = mod:NewSpellAnnounce(317653, 3) --Активация: Скверна
local warnOverloadDark   = mod:NewTargetAnnounce(317662, 2) --Перегрузка метки Тьмы
local warnOverloadFel    = mod:NewTargetAnnounce(317666, 2) --Перегрузка метки Скверны
local warnShocking       = mod:NewSpellAnnounce(317673, 3) --Сотрясающий удар
local warnMagic          = mod:NewTargetAnnounce(317675, 1) --Извергающаяся магия

--local specWarnFelYou     = mod:NewSpecialWarningYou(317641, nil, nil, nil, 2, 1)
--local specWarnDarkYou    = mod:NewSpecialWarningYou(317641, nil, nil, nil, 2, 1)
local specWarnEnveloping = mod:NewSpecialWarningKeepMove(317641, nil, nil, nil, 2, 1) --Окутывающая Тьма
local specWarnSpilling   = mod:NewSpecialWarningStopMove(317645, nil, nil, nil, 2, 1) --Разливающаяся Скверна
local specWarnShadow     = mod:NewSpecialWarningCast(317674, nil, nil, nil, 2, 2) --Воющие тени
local specWarnShelling   = mod:NewSpecialWarningDodge(317685, nil, nil, nil, 2, 1) --Шквальный обстрел

local timerShockingCD   = mod:NewCDTimer(35, 317673, nil, nil, nil, 3) --Сотрясающий удар
local timerShadowCD     = mod:NewCDTimer(38, 317674, nil, nil, nil, 2) --Воющие тени
local timerMagicCD      = mod:NewCDTimer(50, 317675, nil, nil, nil, 5) --Извергающаяся магия
local timerOverloadDark = mod:NewBuffActiveTimer(5, 317650, nil, nil, nil, 7) --Перегрузка метки Тьмы
local timerOverloadFel  = mod:NewBuffActiveTimer(5, 317653, nil, nil, nil, 7) --Перегрузка метки Скверны
local timerShelling     = mod:NewCDTimer(4, 317685, nil, nil, nil, 7) --Шквальный обстрел

--local strupper = strupper
--local player = UnitGUID("player")
local DarkTargets = {}
local FelTargets = {}
mod.vb.DarkIcons = 8
mod.vb.FelIcons = 8


mod:AddSetIconOption("SetIconOnDarkTargets", 317662, true, true, { 6, 7, 8 })
mod:AddSetIconOption("SetIconOnFelTargets", 317666, true, true, { 6, 7, 8 })
mod:AddBoolOption("AssignWarnFal", false, nil, nil, nil, nil, 70126)
mod:AddBoolOption("RangeFrame", true)


local function DarkWarnIcons(self)
	warnOverloadDark:Show(table.concat(DarkTargets, "<, >"))
	table.wipe(DarkTargets)
	self.vb.DarkIcons = 6
end

local function FelWarnIcons(self)
	warnOverloadFel:Show(table.concat(FelTargets, "<, >"))
	table.wipe(FelTargets)
	self.vb.FelIcons = 6
end

--[[
local function warnfelIcons(self)
	if self:IsDifficulty("normal10") then
		specWarnFelYou:Show(strupper(CL.LEFT) .. ": <" .. "   >" .. (player) ..
			"< >")
	end
end]]
-- mod:SetStage(0)
function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerShockingCD:Start(34 - delay)
	timerShadowCD:Start(-delay)
	timerMagicCD:Start(49 - delay)
	if self:IsDifficulty("normal25") then
		self.vb.DarkIcons = 8
		self.vb.FelIcons = 8
	end
end

function mod:OnCombatEnd(wipe)
	timerShockingCD:Stop()
	timerShadowCD:Stop()
	timerMagicCD:Stop()
	DBM.RangeCheck:Hide()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(317673) then --Сотрясающий удар
		warnShocking:Show()
		timerShockingCD:Start()
	elseif args:IsSpellID(317674) then --Воющие тени
		specWarnShadow:Show()
		timerShadowCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	--	local amount = args.amount or 1
	if args:IsSpellID(317641) then --Окутывающая Тьма
		if args:IsPlayer() then
			specWarnEnveloping:Show()
		end
	elseif args:IsSpellID(317645) then --Разливающаяся Скверна
		if args:IsPlayer() then
			specWarnSpilling:Show()
		end
	elseif args:IsSpellID(317681, 317683) then --Извергающаяся магия
		warnMagic:Show(args.destName)
		timerMagicCD:Start(args.destName)
	elseif args:IsSpellID(317662) then --Перегрузка метки Тьмы
		timerOverloadDark:Start()
		if self:IsDifficulty("normal10") then
			warnOverloadDark:Show(args.destName)
		else
			DarkTargets[#DarkTargets + 1] = args.destName
			if self.Options.SetIconOnDarkTargets and self.vb.DarkIcons > 0 then
				self:SetIcon(args.destName, self.vb.DarkIcons)
			end
			self.vb.DarkIcons = self.vb.DarkIcons - 1
			self:Unschedule(DarkWarnIcons)
			self:Schedule(0.1, DarkWarnIcons, self)
		end
	elseif args:IsSpellID(317666) then --Перегрузка метки Скверны
		timerOverloadFel:Start()
		if self:IsDifficulty("normal10") then
			warnOverloadFel:Show(args.destName)
		else
			FelTargets[#FelTargets + 1] = args.destName
			if self.Options.SetIconOnFelTargets and self.vb.FelIcons > 0 then
				self:SetIcon(args.destName, self.vb.FelIcons)
			end
			self.vb.FelIcons = self.vb.FelIcons - 1
			self:UnscheduleMethod(FelWarnIcons)
			self:ScheduleMethod(0.1, FelWarnIcons, self)
		end
	elseif args:IsSpellID(317650) and self:AntiSpam(3) then --Активация: Тьма
		warnActivationDark:Show()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
	elseif args:IsSpellID(317653) and self:AntiSpam(3) then --Активация: Скверна
		warnActivationFel:Show()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(317662) then --Перегрузка метки Тьмы
		if self.Options.SetIconOnDarkTargets then
			self:RemoveIcon(args.destName)
		end
	elseif args:IsSpellID(317666) then --Перегрузка метки Скверны
		if self.Options.SetIconOnFelTargets then
			self:RemoveIcon(args.destName)
		end
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(317685) then --Шквальный обстрел
		specWarnShelling:Show()
		PlaySoundFile("Sound\\Creature\\LadyMalande\\BLCKTMPLE_LadyMal_Aggro01.wav")
		timerShelling:Start()
	end
end
