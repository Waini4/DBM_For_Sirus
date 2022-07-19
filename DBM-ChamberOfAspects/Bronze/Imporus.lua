local mod = DBM:NewMod("Imporus", "DBM-ChamberOfAspects", 3)
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(50608)
mod:RegisterCombat("combat", 50608)
mod:SetUsedIcons(8)
--mod.respawnTime = 20


mod:RegisterEventsInCombat(
	"SPELL_CAST_START 316523 316526 312197 312194",
	"SPELL_CAST_SUCCESS 316519 316520 316523 316526 312199",
	"SPELL_AURA_APPLIED 312199 316508",
	"SPELL_AURA_REMOVED"
)

local warnRezonansCast    = mod:NewSpellAnnounce(316523, 3)
local warnBurningTimeCast = mod:NewSpellAnnounce(316526, 3)

local warnTemporalBeat = mod:NewStackAnnounce(316508, 5, nil, "Tank")

local specWarnnBurningTimeSoon = mod:NewSpecialWarningSoon(316526, nil, nil, nil, 1, 2)
local specWarnnRezonansSoon    = mod:NewSpecialWarningSoon(316523, nil, nil, nil, 4, 2)
local specWarnTemporalBeat     = mod:NewSpecialWarningTaunt(316508, "Tank", nil, nil, 1, 2)

local RezonansCast    = mod:NewCastTimer(3, 316523, nil, nil, nil, 2)
local BurningTimeCast = mod:NewCastTimer(3, 316526, nil, nil, nil, 2)
local enrage          = mod:NewBerserkTimer(600)

mod:AddSetIconOption("SetIconOnTemporalBeat", 316519, true, false, { 8 })

mod:AddTimerLine(DBM_CORE_L.NORMAL_MODE25)
local RezonansCDOb    = mod:NewCDTimer(33, 312194, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local BurningTimeCDOb = mod:NewCDTimer(33, 312197, nil, nil, nil, 3, nil, CL.DEADLY_ICON)

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE25 .. " " .. CL.HEROIC_ICON)

local warnTemporalArrow = mod:NewTargetAnnounce(316519, 4)

local TemporalBeatStack = mod:NewBuffActiveTimer(30, 316508, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local IadCD             = mod:NewCDTimer(58, 312199, nil, nil, nil, 3, nil, CL.POISON_ICON)
local RezonansCD        = mod:NewCDTimer(48, 316523, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local BurningTimeCD     = mod:NewCDTimer(48, 316526, nil, nil, nil, 1, nil, CL.DEADLY_ICON)
local TemporalArrow     = mod:NewCDTimer(20, 316519, nil, nil, nil, 3)

mod:AddBoolOption("YellOnTemporalCrash", true, "announce")
mod:AddBoolOption("RangeFrame", true)
-- mod:AddBoolOption("BossHealthFrame", true, "misc") --- TODO: чекнуть работает ли стандартное хп

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 50608, "Imporus")
	-- if self.Options.BossHealthFrame then
	-- 	DBM.BossHealth:Show(L.name)
	-- 	DBM.BossHealth:AddBoss(50608, L.name)
	-- end
	IadCD:Start(10)
	if mod:IsDifficulty("heroic25") then
		enrage:Start()
		TemporalArrow:Start(-delay)
		RezonansCD:Start(45)
		specWarnnRezonansSoon:Schedule(36)
	else
		RezonansCD:Start(30)
		specWarnnRezonansSoon:Schedule(22)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 50608, "Imporus", wipe)
	DBM.BossHealth:Clear()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 316523 then
		warnRezonansCast:Show()
		RezonansCast:Start()
		BurningTimeCD:Start()
		specWarnnBurningTimeSoon:Schedule(43)
	elseif spellId == 316526 then
		warnBurningTimeCast:Show()
		BurningTimeCast:Start()
		RezonansCD:Start()
		specWarnnRezonansSoon:Schedule(38)
	elseif spellId == 312197 then
		if self:IsTank() and not DBM:UnitDebuff("player", spellId) then
			specWarnTemporalBeat:Show(args.destName)
			specWarnTemporalBeat:Play("tauntboss")
		end
		warnBurningTimeCast:Show()
		BurningTimeCast:Start()
		RezonansCDOb:Start()
		specWarnnRezonansSoon:Schedule(25)
	elseif spellId == 312194 then
		if self:IsTank() and not DBM:UnitDebuff("player", spellId) then
			specWarnTemporalBeat:Show(args.destName)
			specWarnTemporalBeat:Play("tauntboss")
		end
		warnRezonansCast:Show()
		RezonansCast:Start()
		BurningTimeCDOb:Start()
		specWarnnBurningTimeSoon:Schedule(25)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312199 then
		IadCD:Start()
	elseif spellId == 316508 then
		local amount = args.amount or 1
		if amount >= 8 and args:IsTank() then
			if args:IsPlayer() then
				specWarnTemporalBeat:Show(amount)
				specWarnTemporalBeat:Play("stackhigh")
			else
				if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", spellId) then
					specWarnTemporalBeat:Show(args.destName)
					specWarnTemporalBeat:Play("tauntboss")
				else
					warnTemporalBeat:Show(args.destName, amount)
				end
			end
		end
		TemporalBeatStack:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 316519 or spellId == 316520 then
		TemporalArrow:Start()
		self:ScheduleMethod(0.1, "TemporalBeatTarget")
	elseif spellId == 316523 then
		BurningTimeCD:Start()
		specWarnnBurningTimeSoon:Schedule(40)
	elseif spellId == 316526 then
		RezonansCD:Start()
		specWarnnRezonansSoon:Schedule(40)
	elseif spellId == 312199 then
		IadCD:Start()

	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
end

function mod:TemporalBeatTarget()
	local target = self:GetBossTarget(50608)
	if not target then return end
	if mod:LatencyCheck() then
		self:SendSync("CrashOn", target)
	end
end

function mod:OnSync(msg, target)
	if msg == "CrashOn" then
		TemporalArrow:Start()
		warnTemporalArrow:Show(target)
		if self.Options.SetIconOnTemporalBeat then
			self:SetIcon(target, 8, 5)
		end
		if target == UnitName("player") then
			warnTemporalArrow:Show()
			if self.Options.YellOnTemporalCrash then
				SendChatMessage(L.YellCrash, "SAY")
			else
				SendChatMessage(L.YellCrash, "RAID")
			end
		end
	end
end
