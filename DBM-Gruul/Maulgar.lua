local mod	= DBM:NewMod("Maulgar", "DBM-Gruul")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528") -- fxpw check 20220609123000
mod:SetCreatureID(18831, 18832, 18834, 18835, 18836)

mod:SetModelID(18831)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 33152	33144 305221",
	"SPELL_CAST_SUCCESS 33131 16508",
	"SPELL_AURA_APPLIED 33238 33054 305247 33147 305236 305216",
	"SPELL_AURA_REMOVED 305236"
)

--Maulgar
mod:AddTimerLine(L.Maulgar)
local timerWhirlwindCD		= mod:NewCDTimer(55, 33238, nil, nil, nil, 2)
local timerWhirlwind		= mod:NewBuffActiveTimer(15, 33238, nil, nil, nil, 2)
local warningWhirlwind		= mod:NewSpellAnnounce(33238, 4)
local timerIntimidateCD     = mod:NewCDTimer(16, 16508, nil, nil, 4, "Melee")
local specWarnWhirlwind		= mod:NewSpecialWarningRun(33238, "Melee", nil, nil, 4, 2)
--Olm
mod:AddTimerLine(L.Olm)

local timerFelhunter		= mod:NewCDTimer(48.5, 33131, nil, nil, nil, 1)--Buff Active or Cd timer?
local warningFelHunter		= mod:NewSpellAnnounce(33131, 3, nil, mod:IsTank() or mod:UnitClass() == "WARLOCK")
--Krosh
mod:AddTimerLine(L.Krosh)
local warningShield			= mod:NewTargetNoFilterAnnounce(33054 or 305247, 3, nil, "MagicDispeller")	--Щит  заклятий
mod:AddBoolOption("RangeFireBomb", 3, false)
--Blindeye
mod:AddTimerLine(L.Blindeye)
local warningPWS			= mod:NewTargetNoFilterAnnounce(33147, 3, nil, false)
local warningPoH			= mod:NewCastAnnounce(33152, 4)
local warningHeal			= mod:NewCastAnnounce(33144, 4)

local specWarnPoH			= mod:NewSpecialWarningInterrupt(33152, "HasInterrupt", nil, nil, 1, 2)
local specWarnHeal			= mod:NewSpecialWarningInterrupt(33144, "HasInterrupt", nil, nil, 1, 2)

local timerPoH				= mod:NewCastTimer(4, 33152, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerHeal				= mod:NewCastTimer(2, 33144, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)

mod:AddTimerLine(L.BlindeyeHeroic)
local specWarnKickCleanse	= mod:NewSpecialWarningInterrupt(305221, "HasInterrupt", nil, nil, 1, 2)	--Пламенное очищение
local warningCleanse		= mod:NewCastAnnounce(305221, 4)	--Пламенное очищение

mod:AddTimerLine(L.Heroic)

local timerMight            = mod:NewTargetTimer(60, 305216, "timerActive")	-- время действия Переполняющая мощь
local timerMightCD          = mod:NewCDTimer(60, 305216)	-- Переполняющая мощь
local warnMight             = mod:NewAnnounce("WarnMight", 4, 305216, nil, nil, nil, 305216)	-- Анонс активации(Переполняющая мощь)

function mod:OnCombatStart(delay)
	timerWhirlwindCD:Start(58-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(33152) then--Prayer of Healing
		if self:CheckInterruptFilter(args.sourceGUID, nil, true) then
			specWarnPoH:Show(args.sourceName)
			specWarnPoH:Play("kickcast")
			timerPoH:Start()
		else
			warningPoH:Show()
		end
	elseif args:IsSpellID(33144) then--Heal
		if self:CheckInterruptFilter(args.sourceGUID, nil, true) then
			specWarnHeal:Show(args.sourceName)
			specWarnHeal:Play("kickcast")
			timerHeal:Start()
		else
			warningHeal:Show()
		end
	elseif args:IsSpellID(305221) then	-- Пламенное очищение
		specWarnKickCleanse:Show(args.sourceName)
		specWarnKickCleanse:Play("kickcast")
	else
		warningCleanse:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(33238) then	-- Вихрь
		if self.Options.SpecWarn33238run then
			specWarnWhirlwind:Show()
			specWarnWhirlwind:Play("justrun")
		else
			warningWhirlwind:Show()
		end
		timerWhirlwind:Start()
		timerWhirlwindCD:Start()
	elseif args:IsSpellID(33054,305247) and not args:IsDestTypePlayer() then	-- Щит заклятий(Гер)
		warningShield:Show(args.destName)
	elseif args.spellId == 33147 and not args:IsDestTypePlayer() then
		warningPWS:Show(args.destName)
	elseif args:IsSpellID(305236) and args:IsPlayer() then	-- рендж при появлении на тебе живой бомбы
		if self.Options.RangeFireBomb then
			DBM.RangeCheck:Show(7)
		end
	elseif args:IsSpellID(305216) then	-- Активация
		local activeIcon
		for i = 1,40 do
			if UnitName("raid" .. i .. "target") == L.name then
				activeIcon = GetRaidTargetIndex("raid" .. i .. "targettarget")
			end
		end
		timerMightCD:Start()
		warnMight:Show(args.destName, activeIcon or "Interface\\Icons\\Inv_misc_questionmark")
		timerMight:Start(args.destName, activeIcon or "Interface\\Icons\\Inv_misc_questionmark")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(33131) then
		warningFelHunter:Show()
		timerFelhunter:Start()
	elseif args.IsSpellID(16508) then	-- Устрашающий рев
			timerIntimidateCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)	-- убрать рендж при исчезновении
	if args:IsSpellID(305236) and args:IsPlayer() then
		if self.Options.RangeFireBomb then
			DBM.RangeCheck:Hide()
		end
	end
end