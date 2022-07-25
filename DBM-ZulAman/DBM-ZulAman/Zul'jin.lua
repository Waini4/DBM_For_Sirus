local mod = DBM:NewMod("ZulJin", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(23863)
mod:RegisterCombat("combat", 23863)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS 43095 43215 43213 43093",
	"SPELL_AURA_APPLIED  17207 43153",
	"UNIT_HEALTH",
	"UNIT_TARGET"
)

local warnNextPhaseSoon = mod:NewAnnounce("WarnNextPhaseSoon", 1)

local timerWhirlwind = mod:NewCDTimer(17, 17207)
local timerThrow     = mod:NewCDTimer(10, 43093)
local warnThrow      = mod:NewAnnounce("WarnThrow", 4, 43093)

local timerParalysis = mod:NewCDTimer(20, 43095)

local timerJump = mod:NewCDTimer(20, 43153)
local warnJump  = mod:NewAnnounce("WarnJump", 4, 43153)

local timerBreath      = mod:NewCDTimer(10, 43215)
local timerFlameWhirl  = mod:NewCDTimer(12, 43213)
local timerFlamePillar = mod:NewCDTimer(10, 43216)

local specWarnFlamePillar      = mod:NewSpecialWarningRun(43216)
local specWarnFlamePillarMelee = mod:NewSpecialWarningRun(43216, "Melee")
local warnFlamePillar          = mod:NewAnnounce("WarnFlamePillar", 4, 43216)

local berserkTimer = mod:NewBerserkTimer(600)

local bleedTargets = {}
local phaseCounter = 1
local lastPhase = false
local notBleedWarned = true
mod:AddBoolOption("WarnThrow", true)
mod:AddBoolOption("WarnJump", true)
mod:AddBoolOption("WarnNextPhaseSoon", true)
mod:AddBoolOption("WarnFlamePillar", true)

local function IsMeleeZ(uId)
	return select(2, UnitClass(uId)) == "ROGUE"
		or select(2, UnitClass(uId)) == "WARRIOR"
		or select(2, UnitClass(uId)) == "DEATHKNIGHT"
		or (select(2, UnitClass(uId)) == "PALADIN" and select(3, GetTalentTabInfo(3)) >= 51)
		or (select(2, UnitClass(uId)) == "SHAMAN" and select(3, GetTalentTabInfo(2)) >= 31)
		or (select(2, UnitClass(uId)) == "DRUID" and select(3, GetTalentTabInfo(2)) >= 51)
end

local function IsTankZ(uId)
	return (select(2, UnitClass(uId)) == "WARRIOR" and select(3, GetTalentTabInfo(3)) >= 13)
		or (select(2, UnitClass(uId)) == "DEATHKNIGHT" and UnitAura(uId, L.FrostPresence))
		or (select(2, UnitClass(uId)) == "PALADIN" and select(3, GetTalentTabInfo(2)) >= 51)
		or (select(2, UnitClass(uId)) == "DRUID" and UnitAura(uId, L.DriudBearForm))
end

function mod:tPillar()
	lastPhase = true
end

function mod:tBleed()
	warnJump:Show(table.concat(bleedTargets, "<, >"))
	table.wipe(bleedTargets)
	timerJump:Start()
	notBleedWarned = true
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23863, "Zul'jin")
	timerWhirlwind:Start(6)
	timerThrow:Start(7)
	phaseCounter = 1
	lastPhase = false
	notBleedWarned = true
	table.wipe(bleedTargets)
	berserkTimer:Start()
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23863, "Zul'jin", wipe)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43095) then
		timerParalysis:Show()
	elseif args:IsSpellID(43215) then
		timerBreath:Start()
	elseif args:IsSpellID(43213) then
		timerFlameWhirl:Start()
	elseif args:IsSpellID(43093) then
		timerThrow:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(17207) then
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

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellBearZul then
		timerWhirlwind:Cancel()
		timerThrow:Cancel()
		timerParalysis:Start()
	elseif msg == L.YellLynx then
		timerJump:Start(10)
	end
end

function mod:UNIT_TARGET(uId)
	if (lastPhase and self:GetUnitCreatureId(uId) == 23863) then
		timerFlamePillar:Start()
		if not IsTankZ("targettarget") then
			warnFlamePillar:Show(UnitName("targettarget"))
		end
		if UnitName("player") == UnitName("targettarget") and not IsTankZ("player") then
			specWarnFlamePillar:Show()
		end
		if IsMeleeZ("player") and IsMeleeZ("targettarget") and not IsTankZ("targettarget") then
			specWarnFlamePillarMelee:Show()
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if (self:GetUnitCreatureId(uId) == 23863 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.81 and phaseCounter == 1) then
		phaseCounter = phaseCounter + 1
		warnNextPhaseSoon:Show(L.Bear)
	elseif (self:GetUnitCreatureId(uId) == 23863 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.61 and phaseCounter == 2) then
		phaseCounter = phaseCounter + 1
		timerParalysis:Cancel()
		warnNextPhaseSoon:Show(L.Hawk)
	elseif (self:GetUnitCreatureId(uId) == 23863 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.41 and phaseCounter == 3) then
		phaseCounter = phaseCounter + 1
		warnNextPhaseSoon:Show(L.Lynx)
	elseif (self:GetUnitCreatureId(uId) == 23863 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.21 and phaseCounter == 4) then
		phaseCounter = phaseCounter + 1
		warnNextPhaseSoon:Show(L.Dragon)
	elseif (self:GetUnitCreatureId(uId) == 23863 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.20 and not lastPhase) then
		timerJump:Cancel()
		self:ScheduleMethod(10, "tPillar")
		timerFlamePillar:Start(18)
	end
end
