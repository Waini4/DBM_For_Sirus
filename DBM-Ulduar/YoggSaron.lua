local mod	= DBM:NewMod("YoggSaron", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210625152323")

mod:SetCreatureID(33288)
mod:RegisterCombat("yell", L.YellPull)
mod:SetUsedIcons(8, 7, 6, 2, 1)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312650 313003 64059 313000 64189 312647 63038 312644 312997 314683",
	"SPELL_CAST_SUCCESS 64144 64465 313001 313002 313027 313028 313000 64189 312647",
	"SPELL_SUMMON 62979",
	"SPELL_AURA_APPLIED 312995 312994 312996 63802 63830 63881 312993 313029 64126 313031 63138 312989 63138 63894 64775 313001 313002 313027 313028 64167 64163 64465",
	"SPELL_AURA_REMOVED 64465 312995 312989 63894 64775 313029 312993 63830 63881 313001 313002 313027 313028 64167 64163 312995 312994 312996 63802",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"SPELL_AURA_REMOVED_DOSE 63050"
)


local warnMadness 					= mod:NewCastAnnounce(313003, 2)
local warnSqueeze					= mod:NewTargetAnnounce(313031, 3)
local warnFervor					= mod:NewTargetAnnounce(312989, 4)
local warnDeafeningRoarSoon			= mod:NewPreWarnAnnounce(313000, 5, 3)
local warnGuardianSpawned 			= mod:NewAnnounce("WarningGuardianSpawned", 3, 62979)
local warnCrusherTentacleSpawned	= mod:NewAnnounce("WarningCrusherTentacleSpawned", 2)
local warnP2 						= mod:NewPhaseAnnounce(2, 2)
local warnP3 						= mod:NewPhaseAnnounce(3, 2)
local warnSanity 					= mod:NewAnnounce("WarningSanity", 3, 63050)
local warnBrainLink 				= mod:NewTargetAnnounce(312995, 3)
local warnBrainPortalSoon			= mod:NewAnnounce("WarnBrainPortalSoon", 2, 57687)
local warnEmpowerSoon				= mod:NewSoonAnnounce(313014, 4)

local specWarnBrainLink 			= mod:NewSpecialWarningMoveTo(312995, nil, nil, nil, 1, 2)
local specWarnSanity 				= mod:NewSpecialWarning("SpecWarnSanity")
local specWarnMadnessOutNow			= mod:NewSpecialWarning("SpecWarnMadnessOutNow")
local specWarnDarkVolley			= mod:NewSpecialWarningInterrupt(314683, "HasInterrupt", nil, 2, 1, 2)
local specWarnLunaricGaze			= mod:NewSpecialWarningLookAway(313002, nil, nil, nil, 1, 2)
local specWarnDeafeningRoar			= mod:NewSpecialWarningCount(313000, nil, nil, nil, 1, 2)
local specWarnFervor				= mod:NewSpecialWarningYou(312989, nil, nil, nil, 1, 2)
-- local specWarnMaladyNear			= mod:NewSpecialWarningClose(313029, nil, nil, nil, 1, 2)
local yellSqueeze					= mod:NewYell(313031)
local yellBrainLink					= mod:NewYell(312994)
local yellBrainLinkFade				= mod:NewShortFadesYell(312994)


local enrageTimer					= mod:NewBerserkTimer(900)
local timerMaladyCD					= mod:NewCDTimer(18.1, 313029, nil, nil, nil, 3)
local timerBrainLinkCD				= mod:NewCDTimer(25.5, 312995, nil, nil, nil, 3)
local timerFervor					= mod:NewTargetTimer(15, 312989, nil, false, 2)
local brainportal					= mod:NewTimer(20, "NextPortal", 57687, nil, nil, 5)
local brainportal2					= mod:NewCDTimer(60, 64775, nil, nil, nil, 3)
local timerLunaricGaze				= mod:NewCastTimer(4, 313002, nil, nil, nil, 2)
local timerNextLunaricGaze			= mod:NewCDTimer(8.5, 313002, nil, nil, nil, 2)
local timerEmpower					= mod:NewCDTimer(46, 64465, nil, nil, nil, 3)
local timerEmpowerDuration			= mod:NewBuffActiveTimer(10, 64465, nil, nil, nil, 3)
local timerMadnessCD				= mod:NewCDTimer(60, 313003, nil, nil, nil, 3)
local timerCastDeafeningRoar		= mod:NewCastTimer(2.3, 313000, nil, nil, nil, 2)
local timerNextDeafeningRoar		= mod:NewCDCountTimer(25, 313000, nil, nil, nil, 2)
local timerAchieve					= mod:NewAchievementTimer(420, 3013)

mod:AddSetIconOption("SetIconOnFearTarget", 313029, true, false, {6})
mod:AddBoolOption("ShowSaraHealth", true)
mod:AddSetIconOption("SetIconOnFervorTarget", 312989, false, false, {7})
mod:AddSetIconOption("SetIconOnBrainLinkTarget", 312995, true, false, {7, 8})
mod:AddSetIconOption("SetIconOnBeacon", 64465, true, true, {1, 2, 3, 4, 5, 6, 7, 8})

mod.vb.brainLinkIcon = 2
mod.vb.RoarCount = 0
local brainLinkTargets = {}
local beaconIcon = 8
local Guardians = 0
--mod.vb.numberOfPlayers = 1

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33288, "YoggSaron")
	self.vb.brainLinkIcon = 2
	self.vb.RoarCount = 0
	beaconIcon = 8
	Guardians = 0
	self:SetStage(1)
	enrageTimer:Start()
	timerAchieve:Start()
	if self.Options.ShowSaraHealth and not self.Options.HealthFrame then
		DBM.BossHealth:Show(L.name)
	end
	if self.Options.ShowSaraHealth then
		DBM.BossHealth:AddBoss(33134, L.Sara)
	end
	table.wipe(brainLinkTargets)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterStart", 33288, "YoggSaron", wipe)
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:FervorTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") and self:AntiSpam(4, 1) then
		specWarnFervor:Show()
		specWarnFervor:Play("targetyou")
	end
end

local function warnBrainLinkWarning(self)
	warnBrainLink:Show(table.concat(brainLinkTargets, "<, >"))
	timerBrainLinkCD:Start()--VERIFY ME
	table.wipe(brainLinkTargets)
	self.vb.brainLinkIcon = 2
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(312650, 313003, 64059) then	-- Induce Madness
		warnMadness:Show()
		specWarnMadnessOutNow:Schedule(55)
	elseif args:IsSpellID(313000, 64189, 312647) then		--Deafening Roar
		self.vb.RoarCount = self.vb.RoarCount + 1
		timerCastDeafeningRoar:Start()
		specWarnDeafeningRoar:Show(self.vb.RoarCount)
		timerNextDeafeningRoar:Start(nil, self.vb.RoarCount+1)
		specWarnDeafeningRoar:Play("silencesoon")
	elseif args:IsSpellID(312989) then		--Sara's Fervor
		self:ScheduleMethod(0.1, "FervorTarget")
	elseif args:IsSpellID(63038, 312644, 312997, 314683) then
		specWarnDarkVolley:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(64144) and self:GetUnitCreatureId(args.sourceGUID) == 33966 then
		warnCrusherTentacleSpawned:Show()
	elseif args.spellId == 64465 and self:AntiSpam(3, 4) then
		timerEmpower:Start()
		timerEmpowerDuration:Start()
		warnEmpowerSoon:Schedule(40)
	elseif args:IsSpellID(313001, 313002, 313027, 313028) and self:AntiSpam(3, 3) then	-- Lunatic Gaze
		--timerLunaricGaze:Start()
		brainportal:Start(60)
		brainportal2:Start(90)
		--timerMadnessCD:Start(90)
		warnBrainPortalSoon:Schedule(55)
	elseif args:IsSpellID(313000, 64189, 312647) then
		timerNextDeafeningRoar:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(62979) then
		Guardians = Guardians + 1
		warnGuardianSpawned:Show(Guardians)
	end

end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312995 or spellId == 312994 or spellId == 312996 or spellId == 63802 then
		self:Unschedule(warnBrainLinkWarning)
		brainLinkTargets[#brainLinkTargets + 1] = args.destName
		if self.Options.SetIconOnBrainLinkTarget then
			self:SetIcon(args.destName, self.vb.brainLinkIcon)
		end
		self.vb.brainLinkIcon = self.vb.brainLinkIcon - 1
		if args:IsPlayer() then
			specWarnBrainLink:Show()
			specWarnBrainLink:Play("linegather")
			yellBrainLink:Yell()
			yellBrainLinkFade:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(20)
			end
		end
		if #brainLinkTargets == 2 then
			warnBrainLinkWarning(self)
		else
			self:Schedule(0.5, warnBrainLinkWarning, self)
		end
	elseif spellId == 63830 or spellId == 63881 or spellId == 312993 or spellId == 313029 then   -- Душевная болезнь (Death Coil)
		if self.Options.SetIconOnFearTarget then
			self:SetIcon(args.destName, 8, 30)
		end
	elseif spellId == 64126 or spellId == 313031 or spellId == 63138 then	-- Squeeze
		warnSqueeze:Show(args.destName)
		if args:IsPlayer() then
			yellSqueeze:Yell()
		end
	elseif spellId == 312989 or spellId == 63138 then	-- Sara's Fervor
		warnFervor:Show(args.destName)
		timerFervor:Start(args.destName)
		if self.Options.SetIconOnFervorTarget then
			self:SetIcon(args.destName, 7)
		end
		if args:IsPlayer() and self:AntiSpam(4, 1) then
			specWarnFervor:Show()
			specWarnFervor:Play("targetyou")
		end
	elseif (spellId == 63894 or spellId == 64775) then	--and self.vb.phase < 2-- Shadowy Barrier of Yogg-Saron (this is happens when p2 starts)
		self:SetStage(2)
		warnP2:Show()
		brainportal2:Start(60)
		warnBrainPortalSoon:Schedule(57)
		if self.Options.ShowSaraHealth then
			DBM.BossHealth:RemoveBoss(33134)--33890
			DBM.BossHealth:AddBoss(33890,L.Mozg)
			DBM.BossHealth:AddBoss(33966, L.HevTentacle)
		end
	elseif args:IsSpellID(313001, 313002, 313027, 313028, 64167, 64163) then	-- Взгляд безумца (reduces sanity)
		timerLunaricGaze:Start()
		if self.vb.phase == 3 then
			specWarnLunaricGaze:Show()
			brainportal:Cancel()
			brainportal2:Cancel()
			if self.Options.ShowSaraHealth then
				DBM.BossHealth:RemoveBoss(33890)--33890
				DBM.BossHealth:RemoveBoss(33966)
			end
		end
	elseif spellId == 64465 then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 2, beaconIcon, 1, 0.2, 10, "SetIconOnBeacon")
		end
		beaconIcon = beaconIcon - 1
		if beaconIcon == 0 then
			beaconIcon = 8
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 64465 and self.Options.SetIconOnBeacon then
		self:SetIcon(args.destName, 0)
	end
	if spellId == 312995 and self.Options.SetIconOnBrainLinkTarget then		-- Brain Link
		self:SetIcon(args.destName, 0)
		if args:IsPlayer() then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 312989 and self.Options.SetIconOnFervorTarget then	-- Sara's Fervor
		self:SetIcon(args.destName, 0)
	elseif spellId == 63894 or spellId == 64775 then		-- Shadowy Barrier removed from Yogg-Saron (start p3)
		self:SendSync("Phase3")			-- Sync this because you don't get it in your combat log if you are in brain room.
	elseif args:IsSpellID(313001, 313002, 313027, 313028, 64167, 64163) and self:AntiSpam(3, 2) then	-- Lunatic Gaze
		timerNextLunaricGaze:Start()
	elseif args:IsSpellID(313029, 312993, 63830, 63881) and self.Options.SetIconOnFearTarget then   -- Malady of the Mind (Death Coil)
		self:SetIcon(args.destName, 0)
	elseif spellId == 64465 then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 2, 0, 1, 0.2, 12, "SetIconOnBeacon")
		end
	elseif spellId == 312995 or spellId == 312994 or spellId == 312996 or spellId == 63802 then
		if args:IsPlayer() then
			yellBrainLinkFade:Cancel()
		end
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 63050 and args.destGUID == UnitGUID("player") then
		if args.amount == 50 then
			warnSanity:Show(args.amount)
		elseif args.amount == 35 or args.amount == 25 or args.amount == 15 then
			specWarnSanity:Show(args.amount)
		end
	end
end

function mod:OnSync(msg)
	if msg == "Phase3" then
		self:SetStage(3)
		brainportal:Cancel()
		brainportal2:Cancel()
		warnBrainPortalSoon:Cancel()
		timerMaladyCD:Cancel()
		timerBrainLinkCD:Cancel()
		timerMadnessCD:Cancel()
		timerEmpower:Cancel()
		warnP3:Show()
		warnEmpowerSoon:Schedule(40)
		timerNextDeafeningRoar:Start()
		warnDeafeningRoarSoon:Schedule(15)
	end
end