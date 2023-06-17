-------------------------------------------
-------------------------------------------

local mod = DBM:NewMod("Alar", "DBM-TheEye", 1)
-- local L		= mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(19514)
mod:RegisterCombat("combat", 19514)
mod:SetCreatureID(19514)
mod:SetUsedIcons(3, 4, 5, 6, 7, 8)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_WHISPER",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)
mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 34229 35181 308640",
	"SPELL_CAST_START 34342 46599 308638 308987 308633 308671 308663 308664 308665 308667",
	"SPELL_HEAL 34342",
	"UNIT_HEALTH"
)


-- Normal
local warnPlatSoon    = mod:NewAnnounce("WarnPlatSoon", 3, 46599)
local warnFeatherSoon = mod:NewSoonAnnounce(34229, 4)
local warnBombSoon    = mod:NewSoonAnnounce(35181, 3)
local warnBomb        = mod:NewTargetAnnounce(35181, 3)

--local specWarnFeather			= mod:NewSpecialWarningSpell(34229, not mod:IsRanged())
local specWarnBomb = mod:NewSpecialWarningYou(35181)
-- local specWarnPatch				= mod:NewSpecialWarningMove(35383)

local timerNextPlat    = mod:NewTimer(43, "TimerNextPlat", 46599)
local timerFeather     = mod:NewCastTimer(10, 34229)
local timerNextFeather = mod:NewCDTimer(180, 34229)
local timerNextCharge  = mod:NewCDTimer(20, 35412)
local timerNextBomb    = mod:NewCDTimer(46, 35181)

local berserkTimerN = mod:NewBerserkTimer(360)
local berserkTimerN2 = mod:NewBerserkTimer(480)

-- Heroic
local specWarnPhase2Soon    = mod:NewSpecialWarning("WarnPhase2Soon", 1) -- Вторая фаза
local specWarnPhase2        = mod:NewSpecialWarning("WarnPhase2", 1) -- Вторая фаза
local specWarnFlamefall     = mod:NewSpecialWarningSpell(308987, nil, nil, nil, 1, 2) -- Падение пламени
local specWarnAnimated      = mod:NewSpecialWarningSpell(308633, nil, nil, nil, 1, 2) -- Ожившее плямя
local specWarnFireSign      = mod:NewSpecialWarningSpell(308638, nil, nil, nil, 1, 2) -- Знак огня
local specWarnPhoenixScream = mod:NewSpecialWarningSpell(308671, nil, nil, nil, 1, 2) -- Крик феникса

local timerAnimatedCD      = mod:NewCDTimer(70, 308633, nil, "Healer", nil, 5, nil, CL.HEALER_ICON) -- Ожившее плямя
local timerFireSignCD      = mod:NewCDTimer(39, 308638, nil, "Healer", nil, 5, nil, CL.HEALER_ICON) -- Знак огня
local timerFlamefallCD     = mod:NewCDTimer(31, 308987, nil, nil, nil, 1, nil, CL.DEADLY_ICON) -- Перезарядка перьев
local timerPhoenixScreamCD = mod:NewCDTimer(20, 308671, nil, nil, nil, 1, nil, CL.HEROIC_ICON) -- Крик феникса


local timerAnimatedCast      = mod:NewCastTimer(2, 308633, nil, nil, nil, 2) -- Ожившее плямя
local timerFireSignCast      = mod:NewCastTimer(1, 308638, nil, nil, nil, 2) -- Знак огня
local timerFlamefallCast     = mod:NewCastTimer(5, 308987, nil, nil, nil, 2, nil, CL.DEADLY_ICON, nil, 1, 5) -- Каст перьев
local timerPhase2Cast        = mod:NewCastTimer(20, 308640, nil, nil, nil, 1, nil, CL.DEADLY_ICON) -- Перефаза
-- 2 фаза --
local timerPhoenixScreamCast = mod:NewCastTimer(2, 308671, nil, nil, nil, 6, nil, CL.HEROIC_ICON) -- Крик феникса
local timerScatteringCast    = mod:NewCastTimer(20, 308663) -- Знак феникса: рассеяность
local timerWeaknessCast      = mod:NewCastTimer(20, 308664) -- Знак феникса: слабость
local timerFuryCast          = mod:NewCastTimer(20, 308665) -- Знак феникса: ярость
local timerFatigueCast       = mod:NewCastTimer(20, 308667) -- Знак феникса: усталость

local berserkTimerH  = mod:NewBerserkTimer(444)
local berserkTimerH2 = mod:NewBerserkTimer(500)


mod:AddBoolOption("FeatherIcon")
mod:AddBoolOption("YellOnFeather", true, "announce")
mod:AddBoolOption("FeatherArrow")

mod.vb.phase = 0

local warned_preP1 = false
-- local LKTank
-- mod:SetStage(0)
function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 19514, "Al'ar")

	self:SetStage(1)
	if mod:IsDifficulty("heroic25") then
		timerAnimatedCD:Start()
		timerFireSignCD:Start()
		timerFlamefallCD:Start()
		berserkTimerH:Start()
		warned_preP1 = false
	else
		berserkTimerN:Start()
		timerNextPlat:Start(39)
		timerNextFeather:Start()
		warnPlatSoon:Schedule(36)
		warnFeatherSoon:Schedule(169)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 19514, "Al'ar", wipe)
end

function mod:Platform()
	timerNextPlat:Start()
	warnPlatSoon:Schedule(33)
	self:UnscheduleMethod("Platform")
	self:ScheduleMethod(36, "Platform")
end

function mod:SPELL_HEAL(_, _, _, _, _, _, spellId)	-- 2 фаза обычки
	if spellId == 34342 then
		self:SetStage(2)
		specWarnPhase2:Show()
		berserkTimerN:Cancel()
		berserkTimerN2:Start()
		timerNextBomb:Start(30) -- пока на вскидку
		timerNextPlat:Cancel()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 34229 then
		timerFeather:Start()
		timerNextFeather:Start()
		timerNextPlat:Cancel()
		timerNextPlat:Schedule(10)
		self:UnscheduleMethod("Platform")
		self:ScheduleMethod(46, "Platform")
	elseif spellId == 35181 then
		warnBomb:Show(args.destName)
		timerNextBomb:Start()
		if args:IsPlayer() then
			specWarnBomb:Show()
		end
	elseif spellId == 308640 then -- Phase 2
		timerPhase2Cast:Start()
		specWarnPhase2:Show()
		berserkTimerH:Cancel()
		berserkTimerH2:Start()
		self:SetStage(2)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 34342 then
		timerFeather:Cancel()
		timerNextFeather:Cancel()
		timerNextPlat:Cancel()
		self:UnscheduleMethod("Platform")
		warnPlatSoon:Cancel()
		warnFeatherSoon:Cancel()
		timerNextCharge:Start()
		timerNextBomb:Start()
		warnBombSoon:Schedule(43)
	elseif spellId == 46599 then -- Знак огня
		timerNextPlat:Start(33)
	elseif spellId == 308638 then -- Знак огня
		specWarnFireSign:Show()
		timerFireSignCD:Start()
		timerFireSignCast:Start()
	elseif spellId == 308987 then -- Падение пламени
		specWarnFlamefall:Show()
		timerFlamefallCD:Start()
		timerFlamefallCast:Start()
	elseif spellId == 308633 then -- Ожившее плямя
		specWarnAnimated:Show()
		timerAnimatedCD:Start()
		timerAnimatedCast:Start()
		------- 2 фаза ---------
	elseif spellId == 308671 then -- Крик феникса
		timerPhoenixScreamCast:Start()
		timerPhoenixScreamCD:Start()
		specWarnPhoenixScream:Show()
	elseif spellId == 308663 then -- Знак феникса: Рассеяность
		timerScatteringCast:Start()
	elseif spellId == 308664 then -- Знак феникса: Слабость
		timerWeaknessCast:Start()
	elseif spellId == 308665 then -- Знак феникса: Ярость
		timerFuryCast:Start()
	elseif spellId == 308667 then -- Знак феникса: Усталость
		timerFatigueCast:Start()
	end
end

function mod:UNIT_HEALTH(uId)
		if not warned_preP1 and self:GetUnitCreatureId(uId) == 19514 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.07 then
		warned_preP1 = true
		specWarnPhase2Soon:Show()
		end
end

---------------------------перья--------------------





mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
