local mod = DBM:NewMod("Azgalor", "DBM-Hyjal")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17842)
mod:SetUsedIcons(1, 2, 3, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 319026 320374 319029 319006 319011",
	"SPELL_CAST_START 319021 319024",
	"SPELL_AURA_REMOVED 319026 320374 319029 319011",
	"SPELL_INSTAKILL 319023",
	"SPELL_CAST_SUCCESS 320374 319010 319029",
	"SPELL_HEAL 319012"
)


local warnPersecutionbytheflameofFilth = mod:NewTargetNoFilterAnnounce(320374, 3)
local warnMarkofRock                   = mod:NewTargetNoFilterAnnounce(319029, 3)
local warnphaseSoon                    = mod:NewPrePhaseAnnounce(2, nil, nil, nil, nil, nil, 2)
local warnPhase                        = mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2, 1)
local warnLohTrall                     = mod:NewSpellAnnounce(319006, 3)


local specWarnLohTral          = mod:NewSpecialWarning("|cff71d5ff|Hspell:319010|hПокров Охраны|h|r На тотеме!")
local specWarnMarkofRock       = mod:NewSpecialWarning("|cff71d5ff|Hspell:319029|hМетка Рока|h|r Беги к тралу чтобы не умереть!")
local specWarnInfernalDownpour = mod:NewSpecialWarningMoveTo(319021, nil, nil, nil, 2, 2)
local specWarnFlameofFilthYou  = mod:NewSpecialWarningYou(320374, nil, nil, nil, 4, 2) --ливень
local yellFlame                = mod:NewYell(320374, "Пламя")
local yellMark                 = mod:NewYell(319029)
local yellMarkFade             = mod:NewShortFadesYell(319029)

local timerProtectionCoverBuff = mod:NewBuffFadesTimer(10, 319010, nil, nil, nil, 5, nil, DBM_COMMON_L.IMPORTANT_ICON)
local timerFlameofFilthBuff    = mod:NewBuffFadesTimer(10, 320374, nil, nil, nil, 2)
local timerMarkofRockBuff      = mod:NewTargetTimer(30, 319029, nil, nil, nil, 2)

local timerFlameofFilthCD               = mod:NewNextTimer(5, 320374, "Пламя", nil, nil, 3)
local timerEnhancedGlaiveofDefilementCD = mod:NewNextTimer(10, 319026, nil, nil, nil, 3)
local timerMarkofRockCD                 = mod:NewNextCountTimer(40, 319029, nil, nil, nil, 3)
local timerguardianofthespiritCD        = mod:NewTargetTimer(60, 319012, nil, nil, nil, 5)
local timerInfernalDownpourCast         = mod:NewCastTimer(5, 320374, nil, nil, nil, 3) -- Без дебаффа на долгий каст
local timerInfernalDownpourCD           = mod:NewNextCountTimer(40, 319021, nil, nil, nil, 2, nil,
	DBM_COMMON_L.DEADLY_ICON, nil, 1)


mod:AddSetIconOption("SetIconFlameTargets", 320374, true, false, { 1, 2, 3 })
mod:AddSetIconOption("SetIconMarkTarget", 319029, true, false, { 8 })
mod:AddNamePlateOption("Nameplate1", 320374, true)
mod:AddNamePlateOption("Nameplate2", 319029, true)
mod:AddBoolOption("AnnounceVoicePhase", true, "misc")
mod.vb.NecromancerIcon = 7
mod.vb.FlameIcons = 3
mod.vb.MarkIcon = 8
mod.vb.MarkCount = 0
mod.vb.TotemCount = 0
mod.vb.TotemKill = 0

-- 320374 Преследование пламенем скверны

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17888, "Azgalor")
	self:SetStage(1)
	self.vb.NecromancerIcon = 7
	self.vb.TotemCount = 0
	self.vb.FlameIcons = 3
	self.vb.MarkIcon = 8
	self.vb.TotemKill = 0
	self.vb.MarkCount = 0
	timerInfernalDownpourCD:Start(30, self.vb.TotemCount)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17888, "Azgalor")
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(319021) then
		self.vb.TotemCount = self.vb.TotemCount + 1
		specWarnInfernalDownpour:Show("Тотему")
		timerInfernalDownpourCast:Start()
		timerInfernalDownpourCD:Start(nil, self.vb.TotemCount + 1)
	elseif args:IsSpellID(319024) then
		timerMarkofRockCD:Start(30, self.vb.MarkCount)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(320374) then
		timerFlameofFilthCD:Start()
	elseif args:IsSpellID(319010) then
		timerProtectionCoverBuff:Start()
	elseif args:IsSpellID(319029) then
		self.vb.MarkCount = self.vb.MarkCount + 1
		timerMarkofRockCD:Start(nil, self.vb.MarkCount + 1)
	end
end

function mod:SPELL_INSTAKILL(args)
	local stage = mod:GetStage()
	if args:IsSpellID(319023) then
		self.vb.TotemKill = self.vb.TotemKill + 1
		if self.vb.TotemKill == 4 then
			self:SetStage(2)
			if self.Options.AnnounceVoicePhase then
				DBM:PlaySoundFile("Interface\\AddOns\\DBM-Core\\sounds\\Ozvu4ka\\2phaseTrall.mp3")
			end
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
			timerInfernalDownpourCD:Stop()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(319026) then
		--timerEnhancedGlaiveofDefilementCD:Start()
	elseif args:IsSpellID(320374) then
		if args:IsPlayer() then
			yellFlame:Yell()
			specWarnFlameofFilthYou:Show()
			timerFlameofFilthBuff:Start()
		end
		if DBM:CanUseNameplateIcons() and self.Options.Nameplate1 then
			DBM.Nameplate:Show(args.destGUID, 320374)
		end
		if self.Options.SetIconFlameTargets then
			self:SetIcon(args.destName, self.vb.FlameIcons, 10)
			self.vb.FlameIcons = self.vb.FlameIcons - 1
			if self.vb.FlameIcons < 2 then
				self.vb.FlameIcons = 3
			end
		end
		warnPersecutionbytheflameofFilth:Show(args.destName)
	elseif args:IsSpellID(319029) then
		if self.Options.SetIconMarkTarget then
			self:SetIcon(args.destName, self.vb.MarkIcon)
		end
		warnMarkofRock:Show(args.destName)
		if DBM:CanUseNameplateIcons() and self.Options.Nameplate2 then
			DBM.Nameplate:Show(args.destGUID, 319029)
		end
		if args:IsPlayer() then
			specWarnMarkofRock:Show()
			yellMark:Yell()
			yellMarkFade:Countdown(319029)
		end
		timerMarkofRockBuff:Start(args.destName)
	elseif args:IsSpellID(319006) then
		warnLohTrall:Show()
		specWarnLohTral:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(319026) then
		timerEnhancedGlaiveofDefilementCD:Start()
	elseif args:IsSpellID(320374) then
		if self.Options.SetIconFlameTargets then
			self:RemoveIcon(args.destName)
		end
		if DBM:CanUseNameplateIcons() and self.Options.Nameplate1 then
			DBM.Nameplate:Hide(args.destGUID, 320374)
		end
	elseif args:IsSpellID(319029) then
		if self.Options.SetIconMarkTarget then
			self:RemoveIcon(args.destName)
			self.vb.MarkIcon = 8
		end
		if DBM:CanUseNameplateIcons() and self.Options.Nameplate2 then
			DBM.Nameplate:Hide(args.destGUID, 319029)
		end
		if args:IsPlayer() then
			yellMarkFade:Cancel()
		end
		if self.vb.MarkCount == (1 or 3 or 5 or 7 or 9) then
			timerguardianofthespiritCD:Start(args.destName)
		end
	elseif args:IsSpellID(319006) then
		specWarnLohTral:Show()
	end
end

function mod:SPELL_HEAL(_, _, _, _, destName, _, spellId)
	--local spellId = args.spellId
	if spellId == 319012 then
		timerguardianofthespiritCD:Start(destName)
	end
end
