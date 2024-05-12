local mod	= DBM:NewMod("Souls", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(23420)

mod:SetModelID(21483)
mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 371985 371999 371989 371997",
	"SPELL_AURA_APPLIED_DOSE 371989 371997",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START 371993 371992",
	"SPELL_CAST_SUCCESS 371984 371999 371997 371994 371986",
	"SPELL_DAMAGE 41545",
	"SPELL_MISSED 41545",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED"
)
--[[
--maybe a warning for Seethe if tanks mess up in phase 3
local warnFixate		= mod:NewTargetNoFilterAnnounce(41294, 3, nil, "Tank|Healer", 2)
local warnDrain			= mod:NewTargetNoFilterAnnounce(41303, 3, nil, "Healer", 2)
local warnFrenzy		= mod:NewSpellAnnounce(41305, 3, nil, "Tank|Healer", 2)
local warnFrenzySoon	= mod:NewPreWarnAnnounce(41305, 5, 2)
local warnFrenzyEnd		= mod:NewEndAnnounce(41305, 1, nil, "Tank|Healer", 2)

local specWarnPhase 	= mod:NewSpecialWarning("Скоро фаза %s", nil, nil, nil, 1, 2)
local warnPhaseDesires  = mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2, 1)
local warnPhase2		= mod:NewPhaseAnnounce(2, 2)
local warnMana			= mod:NewAnnounce("WarnMana", 4, 41350)
local warnDeaden		= mod:NewTargetNoFilterAnnounce(41410, 1)
]]
local specWarnPhase 	= mod:NewSpecialWarning("Скоро фаза %s", nil, nil, nil, 1, 2)
local Stage2             	= mod:NewPhaseTimer(11, nil, "Фаза: %s", nil, nil, 4)

-- Гнева
local warnRage				= mod:NewTargetAnnounce(371999, 3)
local warnGripStacks		= mod:NewStackAnnounce(371997, 2, nil, "Tank")
local specWarnRageDispel	= mod:NewSpecialWarningDispel(371999, "RemoveCurse", nil, nil, 1, 2)

local specWarnKick			= mod:NewSpecialWarningInterrupt(371993, "HasInterrupt", nil, nil, 1, 2)

local timerNextGrip 		= mod:NewNextTimer(3, 371997, nil, nil, nil, 5)
--local timerGrip				= mod:NewTargetTimer(10, 371997, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerNextRage 		= mod:NewCDTimer(20, 371999, nil, nil, nil, 5)

--желания
local specWarnThirst        = mod:NewSpecialWarningMoveAway(371992, "Melee", nil, nil, 4, 2) --Пожирающая жажда
local specWarnDeceit		= mod:NewSpecialWarningStack(371989, nil, 10, nil, nil, 1, 6)

local timerNextThirst		= mod:NewCDTimer(18, 371992, nil, nil, nil, 5, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)
local timerNextKick		= mod:NewCDTimer(10, 371993, nil, nil, nil, 5) --желания
--Воплощение страдания

--371985,"Иссушающая лихорадка"
local warnFever		= mod:NewTargetAnnounce(371985, 3)
local specWarnGTFO	    = mod:NewSpecialWarningGTFO(371984, nil, nil, nil, 1, 2)

local timerNextGTFO		= mod:NewCDTimer(9, 371984, nil, nil, nil, 3) --реликв потерь

--[[
local warnPhase3		= mod:NewPhaseAnnounce(3, 2)
local warnSoul			= mod:NewSpellAnnounce(41545, 2, nil, "Tank", 2)
local warnSpite			= mod:NewTargetAnnounce(41376, 3)

local specWarnShield	= mod:NewSpecialWarningDispel(41431, "RemoveCurse", nil, 2, 1, 2)
local specWarnSpite		= mod:NewSpecialWarningYou(41376, nil, nil, nil, 1, 2)
local specWarnGTFO	    = mod:NewSpecialWarningGTFO(371984, nil, nil, nil, 1, 2)

--Phase 1
local timerNextGTFO		= mod:NewCDTimer(9, 371984, nil, nil, nil, 3) --реликв потерь

local timerPhaseChange	= mod:NewPhaseTimer(41)
local timerFrenzy		= mod:NewBuffActiveTimer(8, 41305, nil, "Tank|Healer", 2, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerNextFrenzy	= mod:NewNextTimer(40, 41305, nil, "Tank|Healer", 2, 5, nil, DBM_COMMON_L.TANK_ICON)
--Phase 2
local timerDeaden		= mod:NewTargetTimer(10, 41410, nil, nil, nil, 5, nil, DBM_COMMON_L.DAMAGE_ICON, nil, mod:IsTank() and select(2, UnitClass("player")) == "WARRIOR" and 2, 4)
local timerNextDeaden	= mod:NewCDTimer(31, 41410, nil, nil, nil, 5)--Roll timer because I don't want to assign it interrupt one when many groups will use prot warrior
local timerMana			= mod:NewTimer(160, "TimerMana", 41350)
local timerNextShock	= mod:NewCDTimer(12, 41426, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--Blizz lied, this is a 12-15 second cd. you can NOT solo interrupt these with most classes
--Phase 3
local timerNextShield	= mod:NewCDTimer(15, 41431, nil, "MagicDispeller", 2, 5, nil, DBM_COMMON_L.MAGIC_ICON)
local timerNextSoul		= mod:NewCDTimer(10, 41545, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)

mod:AddSetIconOption("DrainIcon", 41303, false)
mod:AddSetIconOption("SpiteIcon", 41376, false)
]]
local GripBuff = DBM:GetSpellInfoNew(371997)
mod.vb.lastFixate = "None"
local FeverTargets = {}
local RageTargets = {}
local UnitSpirits = 0
mod.vb.StageUwU = 0
mod:AddInfoFrameOption(371997, true)
local Stages = { "|cffff1919Воплощение Гнева|r", "|cfffc9bffВоплощение Желания|r", "|cffffe00aВоплощение Страдания|r"}

--[[
0x80000000,371980,"Аура ужасных страданий",0x20
	371980,"Аура ужасных страданий",0x20,DEBUFF

	23:07:35.615 - 23:08:54.826 = 25+54=79

23:24:53.069 - 23:26:24.904 = 2.29	1.28
23:30:14.210 - 23:30:25.141 = 0.01

23:35:41.702 - 23:37:14.248 = 1.27 60+32=92
23:39:02.203 - 23:39:22.263 = 0.20

23:42:36.957 - 23:43:54.061 = 67

0x80000000,371986,"Аура неутолимой жажды",0x40
]]

local function warnFeverTargets(self)
	warnFever:Show(table.concat(FeverTargets, "<, >"))
	table.wipe(FeverTargets)
end
local function warnRageTargets(self)
	warnRage:Show(table.concat(RageTargets, "<, >"))
	table.wipe(RageTargets)
end

local function Unit(self)
	UnitSpirits = 0
end




function mod:OnCombatStart(delay)
	UnitSpirits = 0
	self.vb.StageUwU = 1
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 371985 then
		FeverTargets[#FeverTargets + 1] = args.destName
		self:Unschedule(warnFeverTargets)
		self:Schedule(0.1, warnFeverTargets, self)
	elseif args.spellId == 371999 then
		RageTargets[#RageTargets + 1] = args.destName
		self:Unschedule(warnRageTargets)
		self:Schedule(0.1, warnRageTargets, self)
	elseif args.spellId == 371997 then
		local amount = args.amount or 1
		warnGripStacks:Show(args.destName, amount)
		--timerGrip:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GripBuff)
			DBM.InfoFrame:Show(30, "playerdebuffstacks", GripBuff, 2)
		end
	elseif args.spellId == 371989 then
		if args:IsPlayer() then
			if ((args.amount or 1) >= 10) and self:AntiSpam(4, 2) then
				specWarnDeceit:Show(args.amount)
			end
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 41305 then
		warnFrenzyEnd:Show()
		warnFrenzySoon:Schedule(35)
		timerNextFrenzy:Start()
	end
end]]

function mod:SPELL_CAST_START(args)
	if args.spellId == 371992 then
		specWarnThirst:Schedule(17, args.destName)
		timerNextThirst:Start()
	elseif args.spellId == 371993 and self:AntiSpam(3, 1) then
		timerNextKick:Start()
		specWarnKick:Show(args.sourceName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 371984 then --Aura of Desire
		timerNextGTFO:Start()
		specWarnGTFO:Show(args.sourceName)
	elseif args.spellId == 371999 and self:AntiSpam(3, 1) then --Aura of Anger
		specWarnRageDispel:Show(args.sourceName)
		timerNextRage:Start()
	elseif args.spellId == 371997 then
		timerNextGrip:Start()
	elseif args.spellId == 371980 then
		self.vb.StageUwU = 0
	elseif args.spellId == 371986 then
		specWarnThirst:Schedule(14, args.destName)
		timerNextThirst:Start(15)
	end
end

--[[
function mod:SPELL_DAMAGE(_, _, _, _, _, _, spellId)
	if spellId == 41545 and self:AntiSpam(3, 1) then
		warnSoul:Show()
		timerNextSoul:Start()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

--Boss Unit IDs stilln ot present in 7.2.5 so mouseover/target and antispam required
function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName)
	if spellName == GetSpellInfo(28819) and self:AntiSpam(2, 2) then--Submerge Visual
		self:SendSync("PhaseEnd")
	end
end

--Backup to no one targetting boss
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase1End or msg:find(L.Phase1End) or msg == L.Phase2End or msg:find(L.Phase2End) then
		self:SendSync("PhaseEnd")
	end
end

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "PhaseEnd" then
		warnFrenzyEnd:Cancel()
		warnFrenzySoon:Cancel()
		warnMana:Cancel()
		timerNextFrenzy:Stop()
		timerFrenzy:Stop()
		timerMana:Stop()
		timerNextShield:Stop()
		timerNextDeaden:Stop()
		timerNextShock:Stop()
		timerPhaseChange:Start()--41
	end
end
]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 23469 then
		UnitSpirits = UnitSpirits+1
		if UnitSpirits == 8 then
			self.vb.StageUwU = self.vb.StageUwU+1
			Stage2:Start(nil, Stages[self.vb.StageUwU])
			specWarnPhase:Show(Stages[self.vb.StageUwU])
			self:Schedule(2, Unit, self)
		end
	end
end -- Гнев, желания,