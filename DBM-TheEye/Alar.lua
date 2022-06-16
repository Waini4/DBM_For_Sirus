-- local mod	= DBM:NewMod("Alar", "DBM-TheEye")
-- local L		= mod:GetLocalizedStrings()

-- mod:SetRevision("20220518110528")
-- mod:SetCreatureID(19514)

-- mod:RegisterCombat("combat")

-- mod:RegisterEventsInCombat(
-- 	"SPELL_AURA_APPLIED 34229 35383 35410",
-- 	"SPELL_AURA_REMOVED 35410",
-- 	"SPELL_HEAL 34342"
-- )

-- local warnPhase2		= mod:NewPhaseAnnounce(2, 2)
-- local warnArmor			= mod:NewTargetAnnounce(35410, 2)
-- local warnMeteor		= mod:NewSpellAnnounce(35181, 3)

-- local specWarnQuill		= mod:NewSpecialWarningDodge(34229, nil, nil, nil, 2, 2)
-- local specWarnFire		= mod:NewSpecialWarningMove(35383, nil, nil, nil, 1, 2)
-- local specWarnArmor		= mod:NewSpecialWarningTaunt(35410, nil, nil, nil, 1, 2)

-- local timerQuill		= mod:NewCastTimer(10, 34229, nil, nil, nil, 3)
-- local timerMeteor		= mod:NewCDTimer(52, 35181, nil, nil, nil, 2)
-- local timerArmor		= mod:NewTargetTimer(60, 35410, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)
-- local timerNextPlatform	= mod:NewTimer(34, "NextPlatform", 40192, nil, nil, 6)--This has no spell trigger, the target scanning bosses target is still required if loop isn't accurate enough.

-- local berserkTimer		= mod:NewBerserkTimer(600)

-- local buffetName = DBM:GetSpellInfo(34121)
-- local UnitGUID = UnitGUID
-- local UnitName = UnitName
-- mod.vb.phase2Start = 0
-- mod.vb.flying = false

-- --Loop doesn't work do to varying travel time between platforms. We just need to do target scanning and start next platform timer when Al'ar reaches a platform and starts targeting player again
-- --Still semi inaccurate. Sometimes Al'ar changes platforms 5-8 seconds early with no explanation. I have a feeling it's just tied to Al'ars behavior being buggy with one person.
-- --I don't remember code being faulty when you actually had 4 people up there.
-- local function Platform(self)--An attempt to avoid ugly target scanning, but i get feeling this won't be accurate enough.
-- 	timerNextPlatform:Start()
-- 	self.vb.flying = false
-- end

-- local function Add(self)--An attempt to avoid ugly target scanning, but i get feeling this won't be accurate enough.
-- 	timerNextPlatform:Cancel()
-- 	timerNextPlatform:Start(7)
-- 	self.vb.flying = true
-- 	self:Schedule(7, Platform, self)
-- end

-- function mod:OnCombatStart(delay)
-- 	self:AntiSpam(30, 1)--Prevent it thinking add spawn on pull and messing up first platform timer
-- 	self.vb.flying = false
-- 	self:SetStage(1)
-- 	self.vb.phase2Start = 0
-- 	timerNextPlatform:Start(35-delay)
-- 	self:RegisterOnUpdateHandler(function(self)
-- 		if self:IsInCombat() then
-- 			local foundIt
-- 			local target
-- 			if UnitExists("boss1") then
-- 				foundIt = true
-- 				target = UnitName("boss1target")
-- 				if not target and UnitCastingInfo("boss1") == buffetName then
-- 					target = "Dummy"
-- 				end
-- 			else
-- 				for uId in DBM:GetGroupMembers() do
-- 					if self:GetUnitCreatureId(uId.."target") == 19514 then
-- 						foundIt = true
-- 						target = UnitName(uId.."targettarget")
-- 						if not target and UnitCastingInfo(uId.."target") == buffetName then
-- 							target = "Dummy"
-- 						end
-- 						break
-- 					end
-- 				end
-- 			end

-- 			if foundIt and not target and self.vb.phase == 1 and self:AntiSpam(30, 1) then--Al'ar is no longer targeting anything, which means he spawned an add and is moving platforms
-- 				Add(self)
-- 				--Could also be quills though, which is why we can't really put in an actual add warning.
-- 			elseif not target and self.vb.phase == 2 and self:AntiSpam(30, 2) and (GetTime() - self.vb.phase2Start) > 25 then--No target in phase 2 means meteor
-- 				warnMeteor:Show()
-- 				timerMeteor:Start()
-- 			elseif target and self.vb.flying then--Al'ar has reached a platform and is once again targeting aggro player
-- 				Platform(self)
-- 			end
-- 		end
-- 	end, 0.25)
-- end

-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args.spellId == 34229 then
-- 		specWarnQuill:Show()
-- 		specWarnQuill:Play("findshelter")
-- 		timerQuill:Start()
-- 	elseif args.spellId == 35383 and args:IsPlayer() and self:AntiSpam(3, 1) then
-- 		specWarnFire:Show()
-- 		specWarnFire:Play("runaway")
-- 	elseif args.spellId == 35410 then
-- 		warnArmor:Show(args.destName)
-- 		if not args:IsPlayer() then
-- 			specWarnArmor:Show(args.destName)
-- 			specWarnArmor:Play("tauntboss")
-- 		end
-- 		timerArmor:Start(args.destName)
-- 	end
-- end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args.spellId == 35410 then
-- 		timerArmor:Cancel(args.destName)
-- 	end
-- end

-- --Target scanning is more accurate for finding phase 2 well before the heal, HOWEVER, fails if soloing alar and you aren't targeting him.
-- function mod:SPELL_HEAL(_, _, _, _, _, _, spellId)
-- 	if spellId == 34342 then
-- 		self.vb.phase2Start = GetTime()
-- 		self:SetStage(2)
-- 		warnPhase2:Show()
-- 		berserkTimer:Start()
-- 		timerMeteor:Start(30)--This seems to vary slightly depending on where in room he shoots it.
-- 		timerNextPlatform:Cancel()
-- 	end
-- end

-- --[[
-- function mod:SPELL_DAMAGE(_, _, _, _, _, _, spellId)
-- 	if (spellId == 35181 or spellId == 45680) and self:AntiSpam(30, 2) then
-- 	end
-- end
-- mod.SPELL_MISSED = mod.SPELL_DAMAGE
-- --]]

-------------------------------------------
-------------------------------------------

local mod	= DBM:NewMod("Alar", "DBM-TheEye", 1)
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
	"UNIT_HEALTH"
)


-- Normal
local warnPlatSoon				= mod:NewAnnounce("WarnPlatSoon", 3, 46599)
local warnFeatherSoon			= mod:NewSoonAnnounce(34229, 4)
local warnBombSoon				= mod:NewSoonAnnounce(35181, 3)
local warnBomb					= mod:NewTargetAnnounce(35181, 3)

--local specWarnFeather			= mod:NewSpecialWarningSpell(34229, not mod:IsRanged())
local specWarnBomb				= mod:NewSpecialWarningYou(35181)
-- local specWarnPatch				= mod:NewSpecialWarningMove(35383)

local timerNextPlat				= mod:NewTimer(33, "TimerNextPlat", 46599)
local timerFeather				= mod:NewCastTimer(10, 34229)
local timerNextFeather			= mod:NewCDTimer(180, 34229)
local timerNextCharge			= mod:NewCDTimer(22, 35412)
local timerNextBomb				= mod:NewCDTimer(46, 35181)

local berserkTimerN				= mod:NewBerserkTimer(1200)

-- Heroic
local specWarnPhase2Soon		= mod:NewSpecialWarning("WarnPhase2Soon", 1) -- Вторая фаза
local specWarnPhase2			= mod:NewSpecialWarning("WarnPhase2", 1) -- Вторая фаза
local specWarnFlamefall			= mod:NewSpecialWarningSpell(308987, nil, nil, nil, 1, 2) -- Падение пламени
local specWarnAnimated			= mod:NewSpecialWarningSpell(308633, nil, nil, nil, 1, 2) -- Ожившее плямя
local specWarnFireSign			= mod:NewSpecialWarningSpell(308638, nil, nil, nil, 1, 2) -- Знак огня
local specWarnPhoenixScream     = mod:NewSpecialWarningSpell(308671, nil, nil, nil, 1, 2)  -- Крик феникса

local timerAnimatedCD			= mod:NewCDTimer(70, 308633, nil, "Healer", nil, 5, nil, CL.HEALER_ICON) -- Ожившее плямя
local timerFireSignCD			= mod:NewCDTimer(39, 308638, nil, "Healer", nil, 5, nil, CL.HEALER_ICON) -- Знак огня
local timerFlamefallCD			= mod:NewCDTimer(31, 308987, nil, nil, nil, 1, nil, CL.DEADLY_ICON	) -- Перезарядка перьев
local timerPhoenixScreamCD		= mod:NewCDTimer(20, 308671, nil, nil, nil, 1, nil, CL.HEROIC_ICON) -- Крик феникса


local timerAnimatedCast			= mod:NewCastTimer(2, 308633, nil, nil, nil, 2) -- Ожившее плямя
local timerFireSignCast			= mod:NewCastTimer(1, 308638, nil, nil, nil, 2) -- Знак огня
local timerFlamefallCast		= mod:NewCastTimer(5, 308987, nil, nil, nil, 2, nil, CL.DEADLY_ICON	, nil, 1, 5) -- Каст перьев
local timerPhase2Cast			= mod:NewCastTimer(20, 308640, nil, nil, nil, 1, nil, CL.DEADLY_ICON	) -- Перефаза
-- 2 фаза --
local timerPhoenixScreamCast	= mod:NewCastTimer(2, 308671, nil, nil, nil, 6, nil, CL.HEROIC_ICON) -- Крик феникса
local timerScatteringCast		= mod:NewCastTimer(20, 308663) -- Знак феникса: рассеяность
local timerWeaknessCast			= mod:NewCastTimer(20, 308664) -- Знак феникса: слабость
local timerFuryCast				= mod:NewCastTimer(20, 308665) -- Знак феникса: ярость
local timerFatigueCast			= mod:NewCastTimer(20, 308667) -- Знак феникса: усталость

local berserkTimerH				= mod:NewBerserkTimer(444)
local berserkTimerH2			= mod:NewBerserkTimer(500)


mod:AddBoolOption("FeatherIcon")
mod:AddBoolOption("YellOnFeather", true, "announce")
mod:AddBoolOption("FeatherArrow")

mod.vb.phase = 0

local warned_preP1 = false
-- local LKTank

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 19514, "Al'ar")

	self.vb.phase = 1
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
	elseif spellId == 308640 then  -- Phase 2
		timerPhase2Cast:Start()
		specWarnPhase2:Show()
		berserkTimerH:Cancel()
		berserkTimerH2:Start()
		self.vb.phase = 2
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