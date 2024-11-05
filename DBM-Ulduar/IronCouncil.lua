local mod	= DBM:NewMod("IronCouncil", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()
DBM_COMMON_L = {}
local CL = DBM_COMMON_L

mod:SetRevision("20210501003000")

mod:SetCreatureID(32857, 32867, 32927)
mod:RegisterCombat("combat",32857, 32867, 32927)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterEvents(
	"SPELL_CAST_START 312766 312770 312417 312413 61920 312780 312427 63479 61879 312783 312430 63483 61915 312769 312416 61903 63493 312775 312774 312421 62274 63489 312779 312778 312425 312426 62273 61973 64321 61974 63495",
	"SPELL_AURA_APPLIED 312769 312416 61903 63493 312424 312777 62269 63490 312775 312774 312421 62274 63489 312771 312772 312418 312419 64637 61888 312786 312785 312432 312433 63486 61887 312770 312417 63495 61912 63494",
	"SPELL_CAST_SUCCESS 312777 312424 63490 62269 312781 312428 61869 63481",
	"UNIT_DIED"
)

-- mod:AddBoolOption("HealthFrame", true)

mod:SetBossHealthInfo(
	32867, L.Steelbreaker,
	32927, L.RunemasterMolgeim,
	32857, L.StormcallerBrundir
)

local warnSupercharge			= mod:NewSpellAnnounce(312766, 3)

-- Stormcaller Brundir
local warnChainlight			= mod:NewSpellAnnounce(312780, 2, nil, false, 2)
local timerOverload				= mod:NewCastTimer(6, 312782, nil, nil, nil, 2)
local timerLightningWhirl		= mod:NewCastTimer(5, 312784, nil, nil, nil, 4, nil, CL.INTERRUPT_ICON)
local specwarnLightningTendrils	= mod:NewSpecialWarningRun(312786, nil, nil, nil, 4, 2)
local timerLightningTendrils	= mod:NewBuffActiveTimer(27, 312786, nil, nil, nil, 6)
local specwarnOverload			= mod:NewSpecialWarningRun(312782, nil, nil, nil, 4, 2)
local specWarnLightningWhirl	= mod:NewSpecialWarningInterrupt(63483, "HasInterrupt", nil, nil, 1, 2)
mod:AddBoolOption("AlwaysWarnOnOverload", false, "announce")
mod:AddBoolOption("PlaySoundOnOverload", true)
mod:AddBoolOption("PlaySoundLightningTendrils", true)

-- Steelbreaker
local warnFusionPunch			= mod:NewSpellAnnounce(312769, 4)
local timerFusionPunchCast		= mod:NewCastTimer(3, 312769, nil, nil, nil, 5, nil, CL.TANK_ICON)
local timerFusionPunchActive	= mod:NewTargetTimer(4,312769, nil, nil, nil, 5, nil, CL.TANK_ICON)
local warnOverwhelmingPower		= mod:NewTargetAnnounce(312772, 2)
local timerOverwhelmingPower	= mod:NewTargetTimer(25, 312772, nil, nil, nil, 5, nil, CL.TANK_ICON)
local warnStaticDisruption		= mod:NewTargetAnnounce(312770, 3)
local timerStaticDisruption		= mod:NewNextTimer(32, 312770, nil,nil, nil, 5)
mod:AddSetIconOption("SetIconOnOverwhelmingPower", 61888, false, false, {8})
mod:AddSetIconOption("SetIconOnStaticDisruption", 312770, false, false, {1, 2, 3, 4, 5, 6, 7})

-- Runemaster Molgeim
local timerShieldofRunes		= mod:NewBuffActiveTimer(15, 312775)
local warnRuneofPower			= mod:NewTargetAnnounce(61973, 2) -- Руна мощи
local warnRuneofDeath			= mod:NewSpellAnnounce(312777, 2) -- Руна смерти
local warnShieldofRunes			= mod:NewSpellAnnounce(312774, 2) -- Руна щита
local warnRuneofSummoning		= mod:NewSpellAnnounce(312778, 3) --Руна призыва
local specwarnRuneofDeath		= mod:NewSpecialWarningMove(312777, nil, nil, nil, 1, 2)
local specWarnRuneofShields		= mod:NewSpecialWarningDispel(63967, "MagicDispeller", nil, nil, 1, 2)
local timerRuneofDeathDura		= mod:NewNextTimer(35, 312777, nil, nil, nil, 3)
local timerRuneofPower			= mod:NewCDTimer(35, 61973, nil, nil, nil, 5)

mod:AddBoolOption("PlaySoundDeathRune", true, "announce")


local enrageTimer				= mod:NewBerserkTimer(900)

local disruptTargets = {}
local disruptIcon = 7

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 32857, "IronCouncil")
	enrageTimer:Start()
	timerRuneofPower:Start(21)
	table.wipe(disruptTargets)
	disruptIcon = 7
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 32857, "IronCouncil", wipe)
	DBM.RangeCheck:Hide()
end

function mod:RuneTarget(targetname)
	if not targetname then return end
		warnRuneofPower:Show(targetname)
end

local function warnStaticDisruptionTargets()
	warnStaticDisruption:Show(table.concat(disruptTargets, "<, >"))
	table.wipe(disruptTargets)
	disruptIcon = 7
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(312766, 312413, 61920) then -- Supercharge - Unleashes one last burst of energy as the caster dies, increasing all allies damage by 25% and granting them an additional ability.
		warnSupercharge:Show()
	elseif args:IsSpellID(312780, 312427, 63479, 61879) then	-- Цепная молния
		warnChainlight:Show()
	elseif args:IsSpellID(312783, 312430, 63483, 61915) then	-- Вихрь молний
		timerLightningWhirl:Start()
	elseif args:IsSpellID(312769, 312416, 61903, 63493) then	-- Энергетический удар
		warnFusionPunch:Show()
		timerFusionPunchCast:Start()
	elseif args:IsSpellID(312775, 312774, 312421, 62274, 63489) then		-- Рунический щит
		warnShieldofRunes:Show()
	elseif args:IsSpellID(312779, 312778, 312425, 312426, 62273) then			--	Руна призыва
		warnRuneofSummoning:Show()
	elseif args:IsSpellID(312770, 312417, 63495, 61912, 63494) then
		timerStaticDisruption:Start()
	elseif args:IsSpellID(61973, 64321, 61974) then
			self:ScheduleMethod(0.1, "RuneTarget")
			timerRuneofPower:Start()
	end
end

function mod:UNIT_DIED(args)
	if args.destName == L.StormcallerBrundir then
        timerRuneofPower:Start(25)
        timerRuneofDeathDura:Start(25)
        timerShieldofRunes:Start(27)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(312777, 312424, 63490, 62269) then		-- Руна смерти
		warnRuneofDeath:Show()
		timerRuneofDeathDura:Start()
	elseif args:IsSpellID(312781, 312428, 61869, 63481) then	-- Перегрузка
		timerOverload:Start()
		if self.Options.AlwaysWarnOnOverload or UnitName("target") == L.StormcallerBrundir then
			specwarnOverload:Show()
			specwarnOverload:Play("justrun")
			if self.Options.PlaySoundOnOverload then
				DBM:PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(312769, 312416, 61903, 63493) then		-- Энергетический удар
		timerFusionPunchActive:Start(args.destName)
	elseif args:IsSpellID(312424, 312777, 62269, 63490) then	-- Руна смерти - move away from it
		if args:IsPlayer() then
			specwarnRuneofDeath:Show()
			specwarnRuneofDeath:Play("runaway")
			if self.Options.PlaySoundDeathRune then
				DBM:PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
			end
		end
	elseif args:IsSpellID(312775, 312774, 312421, 62274, 63489) and not args:IsDestTypePlayer() then		-- Рунический щит
		timerShieldofRunes:Start()
		specWarnRuneofShields:Show(args.destName)
		specWarnRuneofShields:Play("dispelboss")
	elseif args:IsSpellID(312771, 312772, 312418, 312419, 64637, 61888) then	-- Переполняющая энергия
		warnOverwhelmingPower:Show(args.destName)
		if mod:IsDifficulty("heroic10") then
			timerOverwhelmingPower:Start(60, args.destName)
		else
			timerOverwhelmingPower:Start(35, args.destName)
		end

		if self.Options.SetIconOnOverwhelmingPower then
			if mod:IsDifficulty("heroic10") then
				self:SetIcon(args.destName, 8, 60) -- skull for 60 seconds (until meltdown)
			else
				self:SetIcon(args.destName, 8, 35) -- skull for 35 seconds (until meltdown)
			end
		end
	elseif args:IsSpellID(312786, 312785, 312432, 312433, 63486, 61887) then	-- Светящиеся придатки
		timerLightningTendrils:Start()
		specwarnLightningTendrils:Show()
		specwarnLightningTendrils:Play("justrun")
		if self.Options.PlaySoundLightningTendrils then
			DBM:PlaySoundFile("Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
		end
	elseif args:IsSpellID(312770, 312417, 63495, 61912, 63494) then	-- Static Disruption (Hard Mode)
		disruptTargets[#disruptTargets + 1] = args.destName
		if self.Options.SetIconOnStaticDisruption then
			self:SetIcon(args.destName, disruptIcon, 20)
			disruptIcon = disruptIcon - 1
		end
		self:Unschedule(warnStaticDisruptionTargets)
		self:Schedule(0.3, warnStaticDisruptionTargets)
	elseif args:IsSpellID(63483, 61915) then	-- LightningWhirl
		timerLightningWhirl:Start()
		if self:CheckInterruptFilter(args.destGUID, false, true) then
			specWarnLightningWhirl:Show(args.destName)
			specWarnLightningWhirl:Play("kickcast")
		end
	end
end