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
	"SPELL_AURA_APPLIED 312199 316508"
	-- "SPELL_AURA_REMOVED"
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

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE25)

local warnTemporalArrow = mod:NewTargetAnnounce(316519, 4)

local TemporalBeatStack = mod:NewBuffActiveTimer(30, 316508, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local IadCD             = mod:NewCDTimer(58, 312199, nil, nil, nil, 3, nil, CL.POISON_ICON)
local RezonansCD        = mod:NewCDTimer(53, 316523, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local BurningTimeCD     = mod:NewCDTimer(53, 316526, nil, nil, nil, 1, nil, CL.DEADLY_ICON)
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
		RezonansCD:Start(50)
		specWarnnRezonansSoon:Schedule(41)
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
	-- DBM.BossHealth:Clear()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	-- local spellId = args.spellId
	if args:IsSpellID(316523) then
		warnRezonansCast:Show()
		RezonansCast:Start()
		BurningTimeCD:Start()
		specWarnnBurningTimeSoon:Schedule(48)
	elseif args:IsSpellID(316526) then
		warnBurningTimeCast:Show()
		BurningTimeCast:Start()
		RezonansCD:Start()
		specWarnnRezonansSoon:Schedule(43)
	elseif args:IsSpellID(312197) then
		if self:IsTank() and not DBM:UnitDebuff("player", args.spellID) then
			specWarnTemporalBeat:Show(args.destName)
			specWarnTemporalBeat:Play("tauntboss")
		end
		warnBurningTimeCast:Show()
		BurningTimeCast:Start()
		RezonansCDOb:Start()
		specWarnnRezonansSoon:Schedule(25)
	elseif args:IsSpellID(312194) then
		if self:IsTank() and not DBM:UnitDebuff("player", args.spellID) then
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
	-- local spellId = args.spellId
	if args:IsSpellID(312199) and self:AntiSpam(3, 1) then
		IadCD:Start()
	elseif args:IsSpellID(316508) then
		local amount = args.amount or 1
		if amount >= 8 and args:IsTank() then
			if args:IsPlayer() then
				specWarnTemporalBeat:Show(amount)
				specWarnTemporalBeat:Play("stackhigh")
			else
				if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", args.spellId) then
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
	if args:IsSpellID(316519,316520) then
		TemporalArrow:Start()
		self:ScheduleMethod(0.1, "TemporalBeatTarget")
	elseif args:IsSpellID(316523) then
	--	BurningTimeCD:Start()
	--	specWarnnBurningTimeSoon:Schedule(45)
	elseif args:IsSpellID(16526) then
	--	RezonansCD:Start()
	--	specWarnnRezonansSoon:Schedule(45)
	elseif args:IsSpellID(312199) then
		IadCD:Start()
	end
end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	local spellId = args.spellId
-- end

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
			-- print(target, 8, 5)
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
