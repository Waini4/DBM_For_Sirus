local mod = DBM:NewMod("TeronGorefiend", "DBM-BlackTemple")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(22871)

mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 373799 373791 373807 373795",
	"SPELL_AURA_APPLIED 373795 373811 373792 373793 373801 373804",
	"SPELL_AURA_APPLIED_DOSE 373795 373811 373792 373793",
	"SPELL_CAST_SUCCESS 373803 373796 373804 373791",
	"SPELL_DAMAGE 373793 373792"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)


mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(1) .. " : " .. "|cff00f7ffВласть Белого Хлада|r")
local warnFreezingStacks = mod:NewStackAnnounce(373795, 2, nil, "Tank")

local specWarnCold       = mod:NewSpecialWarningGTFO(373796, "SpellCaster", nil, nil, 4, 2)
--local specWarnColdMove		= mod:NewSpecialWarningKeepMove(373793, nil, nil, nil, 1, 2)
local specWarnColdMove   = mod:NewSpecialWarningMove(373793, nil, nil, nil, 1, 6)

local timerCombatStart   = mod:NewCombatTimer(20)
local timerNextFreezing  = mod:NewCDTimer(6, 373795, nil, "Tank", nil, 3)
local timerColdCast      = mod:NewCastTimer(7, 373798, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
local timerCold          = mod:NewCDTimer(10, 373796, nil, "SpellCaster", nil, 4, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)
local StageTimer         = mod:NewPhaseTimer(120, nil, "Скоро Фаза: %s", nil, nil, 4)

local FreezBuff          = DBM:GetSpellInfoNew(373795)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(2) .. " : " .. "|cffff1919Власть Страданий|r")

--local warnReposeStacks	= mod:NewStackAnnounce(373811, 2, nil, "Tank")
local warnDisease          = mod:NewTargetAnnounce(373801, 3)
local warnBlood            = mod:NewTargetAnnounce(373804, 3)

local specWarnBloodYou     = mod:NewSpecialWarningYou(373804, nil, nil, nil, 4, 2)
local specWarnPhase2       = mod:NewSpecialWarning("СКОРО ФАЗА |cffff1919Власть Страданий|r", nil, nil, nil, 1, 2)
local specWarnDecapitation = mod:NewSpecialWarningDodge(373803, nil, nil, nil, 4, 2)

local timerNextBlood       = mod:NewCDTimer(15, 373804, nil, "SpellCaster", nil, 3)
local timerNextDisease     = mod:NewCDTimer(10, 373801, nil, "RemoveDisease")
local timerDecapitation    = mod:NewCDTimer(12, 373803, nil, "Melee", nil, 5, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)


mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(3) .. " : " .. "|cfffc9bffВласть Тьмы|r")

local specWarnPhase3   = mod:NewSpecialWarning("СКОРО ФАЗА |cfffc9bffВласть Тьмы|r", nil, nil, nil, 1, 2)
local warnReposeStacks = mod:NewStackAnnounce(373811, 2, nil, "Tank")

local timerNextRepose  = mod:NewCDTimer(6, 373811, nil, "Tank", nil, 3)
local berserkTimer     = mod:NewBerserkTimer(90)
--local timerRepos			= mod:NewTimer(60, "Стаки: %d, %s", 373811, "Tank", nil, 3) -- Прим удар

local ReposeBuff       = DBM:GetSpellInfoNew(373811)
mod:AddRangeFrameOption(9, nil, true)
mod:AddBoolOption("RaidTimer", false)
local StageAura = { "Власть Страданий", "Власть Тьмы" }
--local CrushedTargets = {}
mod.vb.Aura = 0
mod:AddInfoFrameOption(373795, true)
local DiseaseTargets = {}
local BloodTargets = {}

local function warnDiseaseTargets(self)
	warnDisease:Show(table.concat(DiseaseTargets, "<, >"))
	table.wipe(DiseaseTargets)
end
local function warnBloodTargets(self)
	warnBlood:Show(table.concat(BloodTargets, "<, >"))
	table.wipe(BloodTargets)
end

local function Combat(self)
	self.vb.Aura = 0
	specWarnPhase2:Schedule(110)
	timerCold:Start()
	StageTimer:Start(nil, StageAura[self.vb.Aura + 1])
	if self.Options.RaidTimer then
		DBM:CreatePizzaTimer(120, "2-3 фаза")
	end
end

function mod:OnCombatStart(delay)
	self.vb.Aura = 0
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(9)
	end
end

function mod:OnCombatEnd(wipe)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 373799 then
		specWarnDecapitation:Schedule(10)
		timerDecapitation:Start()
		StageTimer:Start(nil, StageAura[self.vb.Aura + 1])
		timerCold:Stop()
		timerNextFreezing:Stop()
		specWarnPhase3:Schedule(110)
		if self.Options.RaidTimer then
			DBM:CreatePizzaTimer(120, "2-3 фаза")
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif args.spellId == 373795 then
		timerNextFreezing:Start()
		--elseif args.spellId == 373791 then
		--	specWarnPhase2:Schedule(110)
		--	timerCold:Start()
		--	StageTimer:Start(nil, StageAura[self.vb.Aura+1])
	elseif args.spellId == 373807 then
		timerNextRepose:Start()
		timerDecapitation:Stop()
		specWarnDecapitation:Cancel()
		berserkTimer:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local amount = args.amount or 1
	if args.spellId == 373811 then
		warnReposeStacks:Show(args.destName, amount)
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(ReposeBuff)
			DBM.InfoFrame:Show(30, "playerdebuffstacks", ReposeBuff, 2)
		end
	elseif args.spellId == 373795 then
		warnFreezingStacks:Show(args.destName, amount)
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(FreezBuff)
			DBM.InfoFrame:Show(30, "playerdebuffstacks", FreezBuff, 2)
		end
	elseif args:IsSpellID(373793, 373792) then
		if args:IsPlayer() then
			specWarnColdMove:Show()
		end
	elseif args.spellId == 373801 then
		timerNextDisease:Start()
		DiseaseTargets[#DiseaseTargets + 1] = args.destName
		self:Unschedule(warnDiseaseTargets)
		self:Schedule(0.1, warnDiseaseTargets, self)
	elseif args.spellId == 373804 then
		BloodTargets[#BloodTargets + 1] = args.destName
		self:Unschedule(warnBloodTargets)
		self:Schedule(0.1, warnBloodTargets, self)
		if args:IsPlayer() then
			specWarnBloodYou:Show()
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
--mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 40243 then
		if self.Options.CrushIcon then
			self:RemoveIcon(args.destName)
		end
	elseif args.spellId == 40251 then
		timerDeath:Stop(args.destName)
		timerVengefulSpirit:Start(args.destName)
		if args:IsPlayer() then
			specWarnDeathEnding:Cancel()
			specWarnDeathEnding:CancelVoice()
		end
	end
end]]

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 373803 then
		specWarnDecapitation:Schedule(10)
		timerDecapitation:Start()
	elseif args.spellId == 373796 then
		timerCold:Start()
		timerColdCast:Start()
		specWarnCold:Show(args.SourceName)
	elseif args.spellId == 373804 then
		timerNextBlood:Start()
	elseif args.spellId == 373791 then
		specWarnPhase2:Schedule(110)
		timerCold:Start()
		StageTimer:Start(nil, StageAura[self.vb.Aura + 1])
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.CamStart or msg:find(L.CamStart) then
		timerCombatStart:Start()
		if self.Options.RaidTimer then
			DBM:CreatePizzaTimer(20, "Пул")
		end
		self:Unschedule(Combat)
		self:Schedule(20, Combat, self)
	end
end

function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, spellId)
	local s = tonumber(string.format("%d", (GetUnitSpeed("Player") / 7) * 100))
	if (spellId == 373792 or spellId == 373793) and destGUID == UnitGUID("player") then
		if s == 0 and self:AntiSpam(1, 1) then
			specWarnColdMove:Show()
		end
	end
end
