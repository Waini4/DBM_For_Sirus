local mod = DBM:NewMod("MagicEater", "DBM-TolGarodePrison")
-- local L   = mod:GetLocalizedStrings()
-- local CL  = DBM_COMMON_L

mod:SetRevision("20210501000000") -- fxpw check 20220609123000
mod:SetCreatureID(84017)
mod:SetUsedIcons(6, 7, 8)

mod:RegisterCombat("combat", 84017)

mod:RegisterEvents(
	"SPELL_CAST_START 317673 317674 317743",
	"SPELL_AURA_APPLIED 317641 317645 317681 317683 317662 317666 317650 317653",
	"SPELL_AURA_REMOVED 317662 317666",
	"SPELL_SUMMON 317685",
	"UNIT_HEALTH"
)

--SPELL_AURA_APPLIED,317664,"Колодец Тьмы",0x20,DEBUFF
--SPELL_AURA_APPLIED,317668,"Очаг Скверны",0x4,DEBUFF
local warnActivationDark   = mod:NewSpellAnnounce(317650, 3)  --Активация: Тьма
local warnShelling         = mod:NewSpellAnnounce(317685, 3)  --Активация: Скверна
local warnActivationFel    = mod:NewSpellAnnounce(317653, 3)
local warnOverloadDark     = mod:NewTargetAnnounce(317662, 2) --Перегрузка метки Тьмы
local warnOverloadFel      = mod:NewTargetAnnounce(317666, 2) --Перегрузка метки Скверны
local warnShocking         = mod:NewSpellAnnounce(317673, 3)  --Сотрясающий удар
local warnMagic            = mod:NewTargetAnnounce(317675, 1) --Извергающаяся магия

local specShockingMoveAway = mod:NewSpecialWarningMoveAway(317673, nil, "Melee", nil, 4, 1)
local specWarnFelYou       = mod:NewSpecialWarningYou(317666, nil, nil, nil, 4, 1)
local specWarnFelMoveTo    = mod:NewSpecialWarningMoveTo(317666, nil, nil, nil, 3, 1)
local specWarnDarkYou      = mod:NewSpecialWarningYou(317662, nil, nil, nil, 4, 1)
local specWarnDarkMoveTo   = mod:NewSpecialWarningMoveTo(317662, nil, nil, nil, 3, 1)
local specWarnEnveloping   = mod:NewSpecialWarningKeepMove(317641, nil, nil, nil, 1, 1) --Окутывающая Тьма
local specWarnSpilling     = mod:NewSpecialWarningStopMove(317645, nil, nil, nil, 1, 1) --Разливающаяся Скверна
local specWarnShadow       = mod:NewSpecialWarningCast(317674, nil, nil, nil, 2, 2)     --Воющие тени
local specWarnShelling     = mod:NewSpecialWarningDodge(317685, nil, nil, nil, 1, 1)    --Шквальный обстрел

local timerShockingCD      = mod:NewCDTimer(35, 317673, nil, nil, nil, 3)               --Сотрясающий удар
local timerDarkCD          = mod:NewCDTimer(20, 317650, nil, nil, nil, 4)               --Активация: Тьма
local timerFelCD           = mod:NewCDTimer(20, 317653, nil, nil, nil, 4)               --Активация: Скверна
local timerShadowCD        = mod:NewCDTimer(39, 317674, nil, nil, nil, 2)               --Воющие тени
local timerMagicCD         = mod:NewCDTimer(50, 317675, nil, "Tank", nil, 5)            --Извергающаяся магия
local timerOverloadDark    = mod:NewBuffActiveTimer(8, 317650, nil, nil, nil, 7)        --Перегрузка метки Тьмы
local timerOverloadFel     = mod:NewBuffActiveTimer(8, 317653, nil, nil, nil, 7)        --Перегрузка метки Скверны
local timerShellingCast    = mod:NewCastTimer(2, 317685, nil, nil, nil, 7)              --Шквальный обстрел
local timerShellingCD      = mod:NewCDTimer(83, 317685, nil, nil, nil, 7)               --Шквальный обстрел

local DarkTargets          = {}
local FelTargets           = {}
local DarkIcons            = 8
local FelIcons             = 8


mod:AddSetIconOption("SetIconOnDarkTargets", 317662, true, true, { 6, 7, 8 })
mod:AddSetIconOption("SetIconOnFelTargets", 317666, true, true, { 6, 7, 8 })
--mod:AddBoolOption("AssignWarnFal", false, nil, nil, nil, nil, 70126)
mod:AddRangeFrameOption(8, nil, true)


local function DarkWarnIcons(self)
	warnOverloadDark:Show(table.concat(DarkTargets, "<, >"))
	table.wipe(DarkTargets)
	DarkIcons = 8
end

local function FelWarnIcons(self)
	warnOverloadFel:Show(table.concat(FelTargets, "<, >"))
	table.wipe(FelTargets)
	FelIcons = 8
end

mod:SetStage(0)

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", function()
	for i = 1, MAX_RAID_MEMBERS do
		local pt = UnitName("raid" .. i .. "-target")
		if pt and pt == "Пожиратель магии" then
			DBM:FireCustomEvent("DBM_EncounterStart", 84017, "MagicEater")
			--self:SetStage(1)
			timerShockingCD:Start(34)
			timerShadowCD:Start()
			timerShellingCD:Start(60)
			timerMagicCD:Start(49)
			timerDarkCD:Start()
			DarkIcons = 8
			FelIcons = 8
		end
	end
end)

--[[
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, mob)
	if strmatch(msg, L.Puk) then
		DBM:FireCustomEvent("DBM_EncounterStart", 84017, "Shadhar")
		self:SetStage(1)
		timerShockingCD:Start(34)
		timerShadowCD:Start()
		timerShellingCD:Start(60)
		timerMagicCD:Start(49)
		timerDarkCD:Start()
		self.vb.DarkIcons = 8
		self.vb.FelIcons = 8
	end
end]]
--[[
function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 84017, "MagicEater")
	self:SetStage(1)
	timerShockingCD:Start(34 - delay)
	timerShadowCD:Start(-delay)
	timerMagicCD:Start(49 - delay)
	if self:IsDifficulty("normal25") then
		self.vb.DarkIcons = 8
		self.vb.FelIcons = 8
	end
end]]
function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 84017, "MagicEater", wipe)
	timerShockingCD:Stop()
	timerShadowCD:Stop()
	timerMagicCD:Stop()
	DBM.RangeCheck:Hide()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(317673, 317743) then --Сотрясающий удар
		specShockingMoveAway:Show()
		warnShocking:Show()
		timerShockingCD:Start()
	elseif args:IsSpellID(317674) then --Воющие тени
		specWarnShadow:Show()
		timerShadowCD:Start()
	elseif args:IsSpellID(317685) then --Воющие тени
		warnShelling:Show()
		timerShellingCast:Start()
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
		DarkTargets[#DarkTargets + 1] = args.destName
		if self.Options.SetIconOnDarkTargets and DarkIcons > 0 then
			self:SetIcon(args.destName, DarkIcons)
		end
		if args:IsPlayer() then
			specWarnDarkYou:Show()
		elseif self:CheckNearby(20, args.destName) then
			specWarnDarkMoveTo:Show(args.destName)
		end
		timerOverloadDark:Start(args.destName)
		warnOverloadDark:Show(args.destName)
		DarkIcons = DarkIcons - 1
		self:Unschedule(DarkWarnIcons)
		self:Schedule(0.1, DarkWarnIcons, self)
	elseif args:IsSpellID(317666) then --Перегрузка метки Скверны
		FelTargets[#FelTargets + 1] = args.destName
		if self.Options.SetIconOnFelTargets and FelIcons > 0 then
			self:SetIcon(args.destName, FelIcons)
		end
		timerOverloadFel:Start(args.destName)
		if args:IsPlayer() then
			specWarnFelYou:Show()
		elseif self:CheckNearby(20, args.destName) then
			specWarnFelMoveTo:Show(args.destName)
		end
		warnOverloadFel:Show(args.destName)
		FelIcons = FelIcons - 1
		self:Unschedule(FelWarnIcons)
		self:Schedule(0.1, FelWarnIcons, self)
	elseif args:IsSpellID(317650) and self:AntiSpam(3) then --Активация: Тьма
		warnActivationDark:Show()
		timerFelCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	elseif args:IsSpellID(317653) and self:AntiSpam(3) then --Активация: Скверна
		warnActivationFel:Show()
		timerDarkCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
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
		timerShellingCD:Start()
	end
end
