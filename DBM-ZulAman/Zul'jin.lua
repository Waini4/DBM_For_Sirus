local mod	= DBM:NewMod("ZulJin", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220803000728")
mod:SetCreatureID(23863)

mod:SetZone()

mod:RegisterCombat("combat")

-- mod:RegisterEvents(
-- 	"CHAT_MSG_MONSTER_YELL",
-- 	"UNIT_HEALTH"
-- )

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 43093 43150 43213",
	"SPELL_CAST_SUCCESS 43095 43215 43213 43093",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_SUCCESS 43095 43215 43213 43093",
	"SPELL_AURA_APPLIED 43093 17207 43153",
	"UNIT_HEALTH"
)
-- общее
local berserkTimer				= mod:NewBerserkTimer(600)

local warnPhase					= mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)
local warnNextPhaseSoon			= mod:NewPrePhaseAnnounce(2, nil, nil, nil, nil, nil, 2)
mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(1))
local timerWhirlwind			= mod:NewCDTimer(17, 17207)
local timerThrow				= mod:NewCDTimer(10, 43093)

local warnThrow					= mod:NewTargetNoFilterAnnounce(43093, 3, nil, "Tank|Healer")

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(2))
local timerParalyzeCD			= mod:NewCDTimer(20, 43095, nil, nil, nil, 3, nil, DBM_COMMON_L.MAGIC_ICON)

local warnParalyze				= mod:NewSpellAnnounce(43095, 4)
local warnParalyzeSoon			= mod:NewPreWarnAnnounce(43095, 5, 3)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(4))
local timerJump					= mod:NewCDTimer(20, 43153)
local timerBreath				= mod:NewCDTimer(10, 43215)
local warnJump					= mod:NewAnnounce("WarnJump", 4, 43153)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(5))
local timerFlameWhirl			= mod:NewCDTimer(12, 43213)
local timerFlamePillar			= mod:NewCDTimer(10, 43216)

-- local lastPhase = false
local notBleedWarned = true
local bleedTargets = {}

mod:AddSetIconOption("ThrowIcon", 43093, true, 0, {7})

function mod:tPillar()
	-- lastPhase = true
end

function mod:tBleed()
	warnJump:Show(table.concat(bleedTargets, "<, >"))
	table.wipe(bleedTargets)
	timerJump:Start()
	notBleedWarned = true
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23863, "Zul'jin")
	self:SetStage(1)
	timerWhirlwind:Start(6)
	timerThrow:Start(7)
	notBleedWarned = true
	-- lastPhase = false
	table.wipe(bleedTargets)
	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23863, "Zul'jin", wipe)
	notBleedWarned = true
	-- lastPhase = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43093) then
		warnThrow:Show(args.destName)
		if self.Options.ThrowIcon then
			self:SetIcon(args.destName, 7)
		end
	elseif args:IsSpellID(17207) then
		timerWhirlwind:Start()
	elseif args:IsSpellID(43153) then
		if DBM:GetRaidUnitId(args.destName) then
			bleedTargets[#bleedTargets + 1] = args.destName
		end
		if notBleedWarned then
			self:ScheduleMethod(1.5, "tBleed")
			notBleedWarned = false
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43095) then
		timerParalyzeCD:Start()
		warnParalyze:Show()
	elseif args:IsSpellID(43215) then
		timerBreath:Start()
	elseif args:IsSpellID(43213) then
		timerFlameWhirl:Start()
	elseif args:IsSpellID(43093) then
		timerThrow:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
		warnPhase:Play("ptwo")
		self:SetStage(2)
	elseif msg == L.YellPhase3 or msg:find(L.YellPhase3) then
		warnParalyzeSoon:Cancel()
		timerParalyzeCD:Cancel()
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(3))
		warnPhase:Play("pthree")
		self:SetStage(3)
	elseif msg == L.YellPhase4 or msg:find(L.YellPhase4) then
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(4))
		warnPhase:Play("pfour")
		self:SetStage(4)
	elseif msg == L.YellPhase5 or msg:find(L.YellPhase5) then
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(5))
		warnPhase:Play("pfive")
		self:SetStage(5)
	elseif msg == L.YellBearZul then
		timerWhirlwind:Cancel()
		timerThrow:Cancel()
		timerParalyzeCD:Start()
	elseif msg == L.YellLynx then
		timerJump:Start(10)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 23863 then
		local hp = DBM:GetBossHPByUnitID(uId)
		local stage = self:GetStage()
		if stage and stage ~= 0 and hp then
			if (stage == 1 and hp <= 81) then
				self:SetStage(2)
				-- phaseCounter = phaseCounter + 1
				warnNextPhaseSoon:Show(L.Bear)
			elseif (stage == 2 and hp <= 61) then
				self:SetStage(3)
				-- phaseCounter = phaseCounter + 1
				-- timerParalysis:Cancel()
				warnNextPhaseSoon:Show(L.Hawk)
			elseif (stage == 3 and hp <= 41) then
				self:SetStage(4)
				-- phaseCounter = phaseCounter + 1
				warnNextPhaseSoon:Show(L.Lynx)
			elseif (stage == 4 and hp <= 20) then
				-- phaseCounter = phaseCounter + 1
				warnNextPhaseSoon:Show(L.Dragon)
				-- self:SetStage(5)
				self:SetStage(5)
				timerJump:Cancel()
				-- needAnonse = true
				timerFlamePillar:Start(18)

			end
		elseif stage == 0 then
			self:SetStage(1)
		end

	end
end
--Надеюсь я верно понял

-- function DBM:GetStage(modId) -- modid == name in 1 line
-- 	if modId then
-- 		local mod = self:GetModByName(modId)
-- 		if mod and mod.inCombat then
-- 			return mod.vb.phase or 0, mod.vb.stageTotality or 0
-- 		end
-- 	else
-- 		if #inCombat > 0 then --At least one boss is engaged
-- 			local mod = inCombat[1] --Get first mod in table
-- 			if mod then
-- 				return mod.vb.phase or 0, mod.vb.stageTotality or 0
-- 			end
-- 		end
-- 	end
-- 	error("Cant have stage from " .. modId)
-- 	return 0
-- end

