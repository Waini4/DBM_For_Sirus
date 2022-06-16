local mod	= DBM:NewMod("Gruul", "DBM-Gruul")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528") -- fxpw check 20220609123000
mod:SetCreatureID(19044)

mod:SetModelID(19044)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 33525 33654 305197 305183",
	"SPELL_CAST_SUCCESS 36297 305188",
	"SPELL_AURA_APPLIED 36300 36240 305201 305204",
	"SPELL_AURA_APPLIED_DOSE 36300 36240 305201 305204"
)

--TODO, add an option that lets users choose between 11, 13, and 18, 18 being default
--[[
(ability.id = 33525 or ability.id = 33654) and type = "begincast"
 or ability.id = 36297 and type = "cast"
 or ability.id = 36300
--]]
mod:AddTimerLine(L.Normal)
local warnGrowth					= mod:NewStackAnnounce(36300, 2)
local warnGroundSlam				= mod:NewSpellAnnounce(33525, 3)
local warnShatter					= mod:NewSpellAnnounce(33654, 4)
local warnSilence					= mod:NewSpellAnnounce(36297, 4)

local specWarnCaveIn				= mod:NewSpecialWarningGTFO(36240, nil, nil, nil, 1, 6)
local specWarnShatter				= mod:NewSpecialWarningMoveAway(33654, nil, nil, nil, 1, 6)

local timerGrowthCD					= mod:NewNextTimer(30, 36300, nil, nil, nil, 6)
local timerGroundSlamCD				= mod:NewCDTimer(74, 33525, nil, nil, nil, 2)--74-80 second variation,and this is just from 2 pulls.
local timerShatterCD				= mod:NewNextTimer(10, 33654, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 4)--10 seconds after ground slam
--local timerSilenceCD				= mod:NewCDTimer(32, 36297, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON)--Also showing a HUGE variation of 32-130 seconds.
mod:AddTimerLine(L.Heroic)
local specWarnHands					= mod:NewSpecialWarningMoveAway(305188, "Hands")	-- Анонс рук(Зов камня)

local timerHandCD                   = mod:NewCDTimer(29, 305188)	-- Руки(Зов камня)
local timerHateStrike		    	= mod:NewCDTimer(6, 305197)			-- Удар ненависти
local timerStunningBlow		    	= mod:NewCDTimer(16, 305183)		-- Ошеломляющий удар
local timerHandStrike               = mod:NewTimer(7,"Strike", 305188)	-- руки закроются через/Хлопок
local timerFurnaceActive            = mod:NewTimer(8,"TimerFurnaceActive", 305201)	-- время активности печи
local timerFurnaceInactive          = mod:NewTimer(43,"TimerFurnaceInactive", 305201)	-- время неактивности печи
local timerBurnedFlesh              = mod:NewTimer(20,"TimerBurnedFlesh", 305204)	-- Обожженная плоть

-- mod:AddRangeFrameOption(mod.Options.RangeDistance == "Smaller" and 11 or 18, 33654)
-- mod:AddDropdownOption("RangeDistance", {"Smaller", "Safe"}, "Safe", cat)
mod:AddBoolOption("HandsOption",false)

function mod:OnCombatStart(delay)
	if mod:IsDifficulty("heroic25") or mod:IsDifficulty("heroic10") then
		timerHandCD:Start(24)
		timerHateStrike:Start(20)
		timerStunningBlow:Start(15)
	elseif mod:IsDifficulty("normal25") or mod:IsDifficulty("normal10") then
		timerGrowthCD:Start(-delay)
		timerGroundSlamCD:Start(40-delay)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(self.Options.RangeDistance == "Smaller" and 11 or 18)
		end
		-- DBM:AddMsg("Ground Slam timer is not broken. This is an ability that has a 74 second minimum cooldown window, but after coming off CD can be delayed up to 21 seconds on when it's cast. Basically it's a 74-95sec window. DBM shows timer for the start of that window, but cannot control whether or not the boss casts it at 74, 85, or 95. Use this knowledge to inform you of when the ability can NOT be cast, not when it will be.")
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 33525 then--Ground Slam
		warnGroundSlam:Show()
		timerShatterCD:Start()
		timerGroundSlamCD:Start()
		specWarnShatter:Schedule(3)
		specWarnShatter:ScheduleVoice(3, "scatter")
	elseif args.spellId == 33654 then--Shatter
		warnShatter:Show()
	elseif args:IsSpellID(305197) then	-- Удар ненависти
		timerHateStrike:Start()
	elseif args:IsSpellID(305183) then	-- Ошеломляющий удар
		timerStunningBlow:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 36297 then--Reverberation (Silence)
		warnSilence:Show()
--		timerSilenceCD:Start()
	elseif args:IsSpellID(305188) then	-- Анонс появления рук и следующий таймер рук
		if self.Options.HandsOption then
			specWarnHands:Show()
		end
		timerHandCD:Start()
		timerHandStrike:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 36300 then--Growth
		local amount = args.amount or 1
		warnGrowth:Show(args.spellName, amount)
		timerGrowthCD:Start()
--		if amount == 3 then--First silence is 15 (or 30?) seconds after 3rd growth.
--			timerSilenceCD:Start(30)
--		end
	elseif args.spellId == 36240 and args:IsPlayer() and not self:IsTrivial() then--Cave In
		specWarnCaveIn:Show(args.spellName)
		specWarnCaveIn:Play("watchfeet")
	end
	if args:IsSpellID(305201) then	-- время активности печи
		timerFurnaceActive:Start()
	elseif args:IsSpellID(305204) then	-- Обожженная плоть
		timerBurnedFlesh:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED