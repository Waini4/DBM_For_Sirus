local mod	= DBM:NewMod("Kologarn", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()
DBM_COMMON_L = {}
local CL = DBM_COMMON_L
local bband = bit.band
mod:SetRevision("20210501000000")

mod:SetCreatureID(32930, 32933, 32934)
mod:RegisterCombat("combat", 32930, 32933, 32934)
mod:SetUsedIcons(5, 6, 7, 8)


mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 64003",
	"SPELL_AURA_APPLIED 312758 312757 312760 312407 312405 312404 64290 64292 312748 312395 64002 63355 312748 64002",
	"SPELL_AURA_APPLIED_DOSE 312758 312757 312760 312407 312405 312404 64290 64292 312748 312395 64002 63355 312748 64002",
	"SPELL_AURA_REMOVED 312758 312757 312760 312407 312405 312404 64290 64292",
	"SPELL_DAMAGE 312399 312752 63783 63982 312412 312765 63346 63976",
	-- "SPELL_MISSED",
	"UNIT_DIED"
)
mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_WHISPER"
)

mod:SetBossHealthInfo(
	32930, L.Health_Body,
	32934, L.Health_Right_Arm,
	32933, L.Health_Left_Arm
)

local warnFocusedEyebeam		= mod:NewTargetAnnounce(312765, 3)
local warnGrip					= mod:NewTargetAnnounce(312757, 2)
local warnCrunchArmor			= mod:NewTargetAnnounce(312748, 2, nil, "Tank")

local specWarnCrunchArmor2		= mod:NewSpecialWarningStack(312748, nil, 2, nil, 2, 1, 6)
local specWarnEyebeam			= mod:NewSpecialWarningYou(312765, nil, nil, nil, 4, 2)
local yellBeam					= mod:NewYell(63346)

local timerCrunch10             = mod:NewTargetTimer(6, 312395)
local timerNextSmash			= mod:NewCDTimer(20.4, 64003, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerNextShockwave		= mod:NewCDTimer(23, 312752)
local timerNextEyebeam			= mod:NewCDTimer(18.2, 63346, nil, nil, nil, 3)
local timerNextGrip				= mod:NewCDTimer(20, 64292, nil, nil, nil, 3)
local timerRespawnLeftArm		= mod:NewTimer(48, "timerLeftArm", nil, nil, nil, 1)
local timerRespawnRightArm		= mod:NewTimer(48, "timerRightArm", nil, nil, nil, 1)
local timerTimeForDisarmed		= mod:NewTimer(10, "achievementDisarmed")	-- 10 HC / 12 nonHC



-- mod:AddBoolOption("HealthFrame", true)
mod:AddSetIconOption("SetIconOnGripTarget", 64292, true, false, {7, 6, 5})
mod:AddSetIconOption("SetIconOnEyebeamTarget", 63346, true, false, {8})

mod.vb.disarmActive = false
--local gripTargets = {}

local function armReset(self)
	self.vb.disarmActive = false
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 32930, "Kologarn")
	timerNextShockwave:Start(15.7)
	timerNextSmash:Start(10-delay)
	timerNextEyebeam:Start(11-delay)
	timerNextShockwave:Start(15.7-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 32930, "Kologarn", wipe)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 64003 then
		timerNextSmash:Start()
	end
end

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 32934 then 		-- Правая рука
		timerRespawnRightArm:Start()
		timerNextGrip:Cancel()
		if not self.vb.disarmActive then
			self.vb.disarmActive = true
			timerTimeForDisarmed:Start(12)
			self:Schedule(12, armReset, self)
		end
	elseif self:GetCIDFromGUID(args.destGUID) == 32933 then		-- Левая рука
		timerRespawnLeftArm:Start()
		if not self.vb.disarmActive then
			self.vb.disarmActive = true
			timerTimeForDisarmed:Start(12)
			self:Schedule(12, armReset, self)
		end
	end
end


function mod:SPELL_DAMAGE(_, _, _, _, _, destFlags, spellId) -- надо чекнуть айдишники
	if ((spellId == 312399 or spellId == 312752 or spellId == 63783 or spellId == 63982) and (bband(destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0)) then-- Ударная волна
		timerNextShockwave:Start()
	elseif ((spellId == 312412 or spellId == 312765 or spellId == 63346 or spellId == 63976) and (bband(destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0)) then --Сосредоточенный взгляд
		specWarnEyebeam:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(msg)
	if msg:find(L.FocusedEyebeam) then
		specWarnEyebeam:Show()
		specWarnEyebeam:Play("justrun")
		specWarnEyebeam:ScheduleVoice(1, "keepmove")
		yellBeam:Yell()
	end
end

function mod:OnSync(msg, target)
	if msg == "EyeBeamOn" then
		warnFocusedEyebeam:Show(target)
		if target == UnitName("player") then
			specWarnEyebeam:Show()
			if self.Options.PlaySoundOnEyebeam then
				DBM:PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
			end
		end
		if self.Options.SetIconOnEyebeamTarget then
			self:SetIcon(target, 5, 8)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(312758, 312757, 312760, 312407, 312405, 312404, 64290, 64292) then 	--Каменная хватка
		if self.Options.SetIconOnGripTarget then
			self:SetIcon(args.destName, 8, 10)
		end
		warnGrip:Show(args.destName)
	elseif args:IsSpellID(312748, 312395, 64002, 63355) then	-- Хруст доспеха
        warnCrunchArmor:Show(args.destName)
		if mod:IsDifficulty("heroic10") then
            timerCrunch10:Start(args.destName)  -- We track duration timer only in 10-man since it's only 6sec and tanks don't switch.
		end
	elseif args:IsSpellID(312748, 64002) then		        -- Хруст доспеха (25-man only)
		local amount = args.amount or 1
		if args.amount >= 2 then
			if args:IsPlayer() then
				specWarnCrunchArmor2:Show(amount)
				specWarnCrunchArmor2:Play("stackhigh")
			else
				warnCrunchArmor:Show(args.destName, amount)
			end
		else
			warnCrunchArmor:Show(args.destName, amount)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(312758, 312757, 312760, 312407, 312405, 312404, 64290, 64292) then  -- Вопрос дохуя хваток
		self:RemoveIcon(args.destName)
    end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED