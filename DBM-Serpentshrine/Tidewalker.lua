--------------------------------------------------------------
--------------------------------------------------------------

local mod = DBM:NewMod("Tidewalker", "DBM-Serpentshrine")
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(21213)

mod:RegisterCombat("yell", L.YellPull)
mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 310152 310151",
	"SPELL_CAST_SUCCESS 310140",
	"SPELL_AURA_APPLIED 310136 310144 310155 310138 37850 38023 38024 38025 38049",
	"SPELL_AURA_APPLIED_DOSE 310136 310144 310155 310138 37850 38023 38024 38025 38049",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_HEALTH"
)

local warnMurlocksSoon = mod:NewAnnounce("WarnMurlocksSoon", 3, "Interface\\Icons\\INV_Misc_MonsterHead_02")
local warnGraves       = mod:NewTargetAnnounce(37850, 3)
local warnGlobes       = mod:NewAnnounce("WarnGlobes", 3)

local timerMurlocks = mod:NewTimer(50, "TimerMurlocks", "Interface\\Icons\\INV_Misc_MonsterHead_02")
local timerGravesCD = mod:NewCDTimer(30, 37850)

local berserkTimer = mod:NewBerserkTimer(480)

-----------ХМ-------------

local warnVzglad     = mod:NewStackAnnounce(310136, 5, nil, "Tank") -- Взгляд
local warnZemla      = mod:NewSoonAnnounce(310152, 2) -- Землетрясение
local warnHwat       = mod:NewTargetAnnounce(310144, 3) -- Хватка
--local warnSuh        = mod:NewTargetAnnounce(310155, 3) -- Обезвоживание
local warnKrik       = mod:NewSpellAnnounce(310151, 2) -- Земля
local warnTop        = mod:NewSpellAnnounce(310140, 2) -- Топот
local warnMon        = mod:NewSpellAnnounce(310137, 4) -- Топот
local warnPhase2Soon = mod:NewPrePhaseAnnounce(2)
local warnPhase2     = mod:NewPhaseAnnounce(2)

local specWarnZemla = mod:NewSpecialWarningMoveAway(310152, nil, nil, nil, 3, 5) -- Землетрясение
local specWarnKrik  = mod:NewSpecialWarningCast(310151, "SpellCaster", nil, nil, 1, 2)

local timerVzglad    = mod:NewTargetTimer(60, 310136, nil, "Tank", nil, 5, nil, CL.TANK_ICON) -- Взгляд
local timerHwatCD    = mod:NewCDTimer(32, 310144, nil, nil, nil, 3) -- хватка
local timerHwat      = mod:NewTargetTimer(3, 310144, nil, nil, nil, 3)
local timerZemlaCast = mod:NewCastTimer(8, 310152, nil, nil, nil, 1) -- Землетрясение
local timerZemlaCD   = mod:NewCDTimer(45, 310152, nil, nil, nil, 1) -- Землетрясение -- fxpw непонятно он теперь меньше или больше
local timerTopCast   = mod:NewCastTimer(3, 310140, nil, nil, nil, 2) -- Топот
local timerTopCD     = mod:NewCDTimer(20, 310140, nil, nil, nil, 2)
local timerKrikCast  = mod:NewCastTimer(3, 310151, nil, nil, nil, 2)
local timerMonCD     = mod:NewCDTimer(12, 310137, nil, nil, nil, 4)
local timerKrikCD    = mod:NewCDTimer(28, 310151, nil, nil, nil, 2)
local timerSuhCD     = mod:NewCDTimer(20, 310155, nil, nil, nil, 1)

local berserkTimerhm = mod:NewBerserkTimer(360)
local berserkTimerNM = mod:NewBerserkTimer(480)

mod:AddSetIconOption("SetIconOnSuhTargets", 310155, true, true, { 4, 5, 6, 7, 8 })

mod.vb.phase = 0

local graveTargets = {}
local warned_preP1 = false
local warned_preP2 = false
local SuhTargets = {}

function mod:AnnounceGraves()
	warnGraves:Show(table.concat(graveTargets, "<, >"))
	table.wipe(graveTargets)
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 21213, "Morogrim Tidewalker")
	if mod:IsDifficulty("heroic25") then
		berserkTimerhm:Start()
		self.vb.phase = 1
		warned_preP1 = false
		warned_preP2 = false
	else
		berserkTimerNM:Start()
		warnMurlocksSoon:Schedule(37)
		timerMurlocks:Start(42)
		timerGravesCD:Start()
		berserkTimer:Start()
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 21213, "Morogrim Tidewalker", wipe)
	DBM.RangeCheck:Hide()
end

function mod:UNIT_HEALTH(uId)
	if mod:IsDifficulty("heroic25") then
		if self.vb.phase == 1 and not warned_preP1 and self:GetUnitCreatureId(uId) == 21213 and
			UnitHealth(uId) / UnitHealthMax(uId) <= 0.52 then
			warned_preP1 = true
			warnPhase2Soon:Show()
		end
		if self.vb.phase == 1 and not warned_preP2 and self:GetUnitCreatureId(uId) == 21213 and
			UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 then
			warned_preP2 = true
			self.vb.phase = 2
			warnPhase2:Show()
			berserkTimerhm:Cancel()
			berserkTimerhm:Start()
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 310152 then -- Землетрясение
		warnZemla:Show(10)
		timerZemlaCast:Start()
		timerZemlaCD:Start()
		specWarnZemla:Show()
		DBM.RangeCheck:Show(8)
	elseif spellId == 310151 then -- Землетрясение
		specWarnKrik:Show()
		warnKrik:Show()
		timerKrikCD:Start()
		timerKrikCast:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 310140 then -- Топот
		warnTop:Show()
		timerTopCast:Start()
		timerTopCD:Start()
	end
end

local spellIds = {
	["37850"] = true,
	["38023"] = true,
	["38024"] = true,
	["38025"] = true,
	["38049"] = true

}
function mod:SPELL_AURA_APPLIED(args) -- все хм --
	local spellId = args.spellId
	if spellId == 310136 then --Взгляд
		warnVzglad:Show(args.destName, args.amount or 1)
		timerVzglad:Start(args.destName)
	elseif spellId == 310144 then -- хватка
		timerHwat:Start(args.destName)
		timerHwatCD:Start()
		warnHwat:Show(args.destName)
	elseif spellId == 310155 then
		timerSuhCD:Start()
	elseif spellId == 310138 then
		timerMonCD:Start()
		warnMon:Show()
	elseif spellIds[spellId] then -- ОБЫЧКА
		graveTargets[#graveTargets + 1] = args.destName
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteMurlocs then
		warnMurlocksSoon:Cancel()
		warnMurlocksSoon:Schedule(45)
		timerMurlocks:Start(50)
	elseif msg == L.EmoteGraves then
		timerGravesCD:Start()
		self:ScheduleMethod(0.2, "AnnounceGraves")
	elseif msg == L.EmoteGlobes then
		warnGlobes:Show()
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
