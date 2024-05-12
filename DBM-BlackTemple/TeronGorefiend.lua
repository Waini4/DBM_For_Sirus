local mod	= DBM:NewMod("TeronGorefiend", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(22871)

mod:SetModelID(21254)
mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 373799 373791 373807 373795",
	"SPELL_AURA_APPLIED 373795 373811 373792 373801",
	"SPELL_AURA_APPLIED_DOSE 373795 373811 373792",
	"SPELL_AURA_REMOVED ",
	"SPELL_CAST_SUCCESS 373803 373796"
)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(1) .. " : " .. "|cff00f7ffВласть Белого Хлада|r")
local warnFreezingStacks	= mod:NewStackAnnounce(373795, 2, nil, "Tank")
local specWarnCold			= mod:NewSpecialWarningGTFO(373796, "SpellCaster", nil, nil, 4, 2)
local specWarnColdMove		= mod:NewSpecialWarningKeepMove(373792, nil, nil, nil, 1, 2)

local timerNextFreezing		= mod:NewCDTimer(6, 373795, nil, "Tank", nil, 3)
local timerColdCast 		= mod:NewCastTimer(10, 373798, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
local timerCold     		= mod:NewCDTimer(20, 373796, nil, "SpellCaster", nil, 4, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)
local StageTimer			= mod:NewPhaseTimer(120, nil, "Скоро Фаза: %s", nil, nil, 4)

local FreezBuff 			= DBM:GetSpellInfoNew(373795)

mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(2) .. " : " .. "|cffff1919Власть Страданий|r")

--local warnReposeStacks	= mod:NewStackAnnounce(373811, 2, nil, "Tank")
local warnDisease			= mod:NewTargetAnnounce(373801, 3)
local specWarnDecapitation	= mod:NewSpecialWarningDodge(373803, nil, nil, nil, 4, 2)

local timerNextDisease		= mod:NewCDTimer(10, 373801, nil, "RemoveDisease")
local timerDecapitation     = mod:NewCDTimer(12, 373803, nil, "Melee", nil, 5, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)


mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(3) .. " : " .. "|cfffc9bffВласть Тьмы|r")

local warnReposeStacks		= mod:NewStackAnnounce(373811, 2, nil, "Tank")

local timerNextRepose		= mod:NewCDTimer(6, 373811, nil, "Tank", nil, 3)
local berserkTimer          = mod:NewBerserkTimer(90)
--local timerRepos			= mod:NewTimer(60, "Стаки: %d, %s", 373811, "Tank", nil, 3) -- Прим удар

local ReposeBuff = DBM:GetSpellInfoNew(373811)
mod:AddRangeFrameOption(9, nil, true)
local StageAura = {"Власть Страданий", "Власть Тьмы"}
--local CrushedTargets = {}
mod.vb.Aura = 0
mod:AddInfoFrameOption(373795, true)
local DiseaseTargets = {}

local function warnDiseaseTargets(self)
	warnDisease:Show(table.concat(DiseaseTargets, "<, >"))
	table.wipe(DiseaseTargets)
end

function mod:OnCombatStart(delay)
	self.vb.Aura = 0
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(9)
	end
end

function mod:OnCombatEnd(wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	elseif self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 373799 then
		specWarnDecapitation:Schedule(10)
		timerDecapitation:Start()
		StageTimer:Start(nil, StageAura[self.vb.Aura+1])
		timerCold:Stop()
		timerNextFreezing:Stop()
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif args.spellId == 373795 then
		timerNextFreezing:Start()
	elseif args.spellId == 373791 then
		timerCold:Start()
		StageTimer:Start(nil, StageAura[self.vb.Aura+1])
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
	elseif args.spellId == 373792 then
		if args:IsPlayer() and amount >= 2 then
			specWarnColdMove:Show()
		end
	elseif args.spellId == 373801 then
		timerNextDisease:Start()
		DiseaseTargets[#DiseaseTargets + 1] = args.destName
		self:Unschedule(warnDiseaseTargets)
		self:Schedule(0.1, warnDiseaseTargets, self)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

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
	end
end