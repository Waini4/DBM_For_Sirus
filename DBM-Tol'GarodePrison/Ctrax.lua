local mod	= DBM:NewMod("Ctrax", "DBM-Tol'GarodePrison")
local L		= mod:GetLocalizedStrings()

local CML = DBM_COMMON_L
local LCL = DBM_CORE_L

mod:SetRevision("20210501000000") -- fxpw check 20220609123000
mod:SetCreatureID(84002)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 317579 317596",
	-- "SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 317594",
	"SPELL_AURA_APPLIED_DOSE 317594",
	-- "SPELL_AURA_REMOVED",
	-- "SPELL_SUMMON",
	"UNIT_HEALTH"
)

--8 сек дар йога 317601
--15 сек область тьмы 317596
--20 сек колодец 317594
--50 погружение

local warnPhase2Soon   					= mod:NewPrePhaseAnnounce(2)	-- анонс о скорой 2 фазе
local warnPhase2     					= mod:NewPhaseAnnounce(2)		-- оповещение второй фазы
local warnAncientCurse					= mod:NewTargetAnnounce(317594, 3)

local specwarnEscapingDarkness			= mod:NewSpecialWarningCast(317579, nil, nil, nil, 2, 2)
local specWarnAncientCurseYou			= mod:NewSpecialWarningYou(317594, nil, nil, nil, 3, 2)
local yellAncientCurse					= mod:NewYell(317594, nil, nil, nil, "YELL") --317158
local yellAncientCurseFade				= mod:NewShortFadesYell(317594, nil, nil, nil, "YELL")

local timerEscapingDarkness				= mod:NewCDTimer(35, 317579, nil, nil, nil, 2, nil, CML.DEADLY_ICON)
local timerdar							= mod:NewCDTimer(8, 317601, nil, nil, nil, 2, nil, CML.IMPORTANT_ICON)
local timerRegionofDarkness				= mod:NewCDTimer(35, 317596, nil, nil, nil, 2, nil, CML.IMPORTANT_ICON)
local timerAncientCurse					= mod:NewCDTimer(20, 317594, nil, nil, nil, 2, nil, CML.IMPORTANT_ICON)

local warned_P1 = false
local warned_P2 = false

mod:AddInfoFrameOption(317579, false)

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerEscapingDarkness:Start()
	self:ScheduleMethod(0.5, "CreatePowerFrame")
	if mod:IsDifficulty("normal10") then
		if self.Options.BossHealthFrame then
			DBM.BossHealth:Show(L.name)
			DBM.BossHealth:AddBoss(84002, L.name)
		end
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(LCL.INFOFRAME_POWER)
		DBM.InfoFrame:Show(2, "enemypower", 1)--TODO, figure out power type
	end
end

function mod:OnCombatEnd(wipe)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

do	-- тест!!!!!
	local last = 100
	local function getPowerPercent()
		local guid = UnitGUID("focus")
		if mod:GetCIDFromGUID(guid) == 84002 then
			last = math.floor(UnitPower("focus")/UnitPowerMax("focus") * 100)
			return last
		end
		for i = 0, GetNumRaidMembers(), 1 do
			local unitId = ((i == 0) and "target") or ("raid"..i.."target")
			guid = UnitGUID(unitId)
			if mod:GetCIDFromGUID(guid) == 84002 then
				last = math.floor(UnitPower(unitId)/UnitPowerMax(unitId) * 100)
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
	local spellId = args.spellId
	if spellId == 317579 then
		specwarnEscapingDarkness:Show()
		timerEscapingDarkness:Start()
	elseif spellId == 317596 then
		timerRegionofDarkness:Start()
	end
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	local spellId = args.spellId
-- end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 317594 then
		warnAncientCurse:Show(args.destName)
		timerAncientCurse:Start()
		if args:IsPlayer() then
			specWarnAncientCurseYou:Show()
			yellAncientCurse:Yell()
			yellAncientCurseFade:Countdown(spellId)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

-- function mod:SPELL_AURA_REMOVED(args)
-- 	local spellId = args.spellId
-- end

function mod:UNIT_HEALTH(uId)	-- перефаза по хп
	if not warned_P1 and self:GetUnitCreatureId(uId) == 84002 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.53 and mod:IsDifficulty("heroic25") then
		warned_P1 = true
		warnPhase2Soon:Show()
	elseif not warned_P2 and self:GetUnitCreatureId(uId) == 84002 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 and mod:IsDifficulty("heroic25") then
		warned_P2 = true
		warnPhase2:Show()
		self:SetStage(2)
		timerEscapingDarkness:Cancel()
		timerdar:Start()
		timerRegionofDarkness:Start(15)
		timerAncientCurse:Start()
	end
end