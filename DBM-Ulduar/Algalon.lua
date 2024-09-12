local mod = DBM:NewMod("Algalon", "DBM-Ulduar")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210501000000")
mod:SetCreatureID(32871)

mod:RegisterCombat("combat", "yell", L.YellPull)
mod:RegisterKill("yell", L.YellKill)
mod:SetWipeTime(20)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 313034 64443 64584",
	"SPELL_CAST_SUCCESS 313039 64122 65108 64598 62301 313037 313036",
	"SPELL_AURA_APPLIED 313033 64412",
	"SPELL_AURA_APPLIED_DOSE 313033 64412",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_HEALTH"
)
mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL"
)

local announceBigBang     = mod:NewSpellAnnounce(313034, 4)
local warnPhase2          = mod:NewPhaseAnnounce(2)
local warnPhase2Soon      = mod:NewAnnounce("WarnPhase2Soon", 2)
local announcePreBigBang  = mod:NewPreWarnAnnounce(313034, 10, 3)
local announceBlackHole   = mod:NewSpellAnnounce(313039, 2)
local announceCosmicSmash = mod:NewAnnounce("WarningCosmicSmash", 3, 313036)
local announcePhasePunch  = mod:NewAnnounce("WarningPhasePunch", 4, 313039, "Tank")

local specwarnStarLow         = mod:NewSpecialWarning("warnStarLow", "Tank", nil, nil, 1, 2)
local specWarnPhasePunch      = mod:NewSpecialWarningStack(313033, nil, 4, nil, nil, 1, 6)
local specWarnBigBang         = mod:NewSpecialWarningDefensive(313034, "Tank", nil, nil, 3, 2)
local specWarnCosmicSmash     = mod:NewSpecialWarningCount(313036, nil, nil, nil, 2, 2)
local enrageTimer             = mod:NewBerserkTimer(360)
local timerNextBigBang        = mod:NewNextTimer(90.5, 313034, nil, nil, nil, 2)
local timerBigBangCast        = mod:NewCastTimer(8, 313034)
local timerNextCollapsingStar = mod:NewTimer(15, "NextCollapsingStar")
local timerCDCosmicSmash      = mod:NewCDCountTimer(25, 313036, nil, nil, nil, 2)
local timerCastCosmicSmash    = mod:NewCastTimer(4.5, 313036)
local timerPhasePunch         = mod:NewBuffActiveTimer(45, 313033, nil, "Tank", nil, 6)
local timerNextPhasePunch     = mod:NewNextTimer(16, 313033, nil, "Tank", nil, 6)
local timerCombatStart		  = mod:NewCombatTimer(8)

mod.vb.SmashCount = 0
local warned_preP2 = false
local warned_star = false

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 32871, "Algalon")
	self.vb.SmashCount = 0
	warned_preP2 = false
	warned_star = false
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 32871, "Algalon", wipe)
end

function mod:startTimers()
	enrageTimer:Start()
	timerNextBigBang:Start()
	announcePreBigBang:Schedule(80)
	timerCDCosmicSmash:Start(nil, self.vb.SmashCount + 1)
	timerNextCollapsingStar:Start()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(313034, 64443, 64584) then -- Суровый удар
		timerBigBangCast:Start()
		timerNextBigBang:Start()
		announceBigBang:Show()
		announcePreBigBang:Schedule(80)
		specWarnBigBang:Show()
		specWarnBigBang:Play("defensive")
		DBM:PlaySoundFile("Sound\\Creature\\illidan\\black_illidan_04.wav")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(313039, 64122, 65108) then -- Взрыв чёрной дыры
		announceBlackHole:Show()
		warned_star = false
	elseif args:IsSpellID(64598, 62301, 313037, 313036) then -- Кара небесная
		self.vb.SmashCount = self.vb.SmashCount + 1
		timerCastCosmicSmash:Start()
		timerCDCosmicSmash:Start(nil, self.vb.SmashCount + 1)
		announceCosmicSmash:Show()
		specWarnCosmicSmash:Show(self.vb.SmashCount)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(313033, 64412) then
		timerNextPhasePunch:Start()
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 3 then
			specWarnPhasePunch:Show(args.amount)
		end
		timerPhasePunch:Start(args.destName)
		announcePhasePunch:Show(args.destName, amount)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.Emote_CollapsingStar or msg:find(L.Emote_CollapsingStar) then
		timerNextCollapsingStar:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase2 or msg:find(L.Phase2) then
		timerNextCollapsingStar:Cancel()
		warnPhase2:Show()
	elseif msg == L.YellPull or msg:find(L.YellPull) then
	    timerCombatStart:Start(26)
		self:ScheduleMethod(26, "startTimers")
    elseif msg == L.PullCheck or msg:find(L.PullCheck) then
		timerCombatStart:Start()
		self:ScheduleMethod(8, "startTimers")
	end
end

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 65311 then--Supermassive Fail (fires when he becomes actually active)
		timerNextCollapsingStar:Start(16)
		timerCDCosmicSmash:Start(26)
		announcePreBigBang:Schedule(80)
		timerNextBigBang:Start(90)
		enrageTimer:Start(360)
	elseif spellId == 65256 then--Self Stun (phase 2)
		warned_preP2 = true
		timerNextCollapsingStar:Stop()
		warnPhase2:Show()
	end
end
]]
function mod:UNIT_HEALTH(uId)
	if not warned_preP2 and self:GetUnitCreatureId(uId) == 32871 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.23 then
		warned_preP2 = true
		warnPhase2Soon:Show()
	elseif not warned_star and self:GetUnitCreatureId(uId) == 32955 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.10 then
		warned_star = true
		specwarnStarLow:Show()
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
