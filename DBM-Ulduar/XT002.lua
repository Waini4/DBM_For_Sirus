local mod = DBM:NewMod("XT002", "DBM-Ulduar")
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L

mod:SetRevision("20220518110528")
mod:SetCreatureID(33293)
mod:SetUsedIcons(1, 2)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 62776 312586 312939",
	"SPELL_AURA_APPLIED 62775 312587 312940 63018 65121 312588 312941 312943 312590 64234 63024",
	"SPELL_AURA_REMOVED 63018 65121 312588 312941 63024 64234 312590 312943 312945 63849",
	"SPELL_DAMAGE 64208 64206",
	"SPELL_MISSED 64208 64206"
)

local warnLightBomb   = mod:NewTargetAnnounce(312941, 3)
local warnGravityBomb = mod:NewTargetAnnounce(312943, 3)

local specWarnLightBomb    = mod:NewSpecialWarningMoveAway(312941, nil, nil, nil, 1, 2)
local yellLightBomb        = mod:NewYell(312941)
local specWarnGravityBomb  = mod:NewSpecialWarningMoveAway(312943, nil, nil, nil, 1, 2)
local yellGravityBomb      = mod:NewYell(312943)
local specWarnConsumption  = mod:NewSpecialWarningMove(64206, nil, nil, nil, 1, 2) --Hard mode void zone dropped by Gravity Bomb
local yellGravityBombFades = mod:NewShortFadesYell(312943)
local yellLightBombFades   = mod:NewShortFadesYell(312941)

local enrageTimer              = mod:NewBerserkTimer(600)
local timerTympanicTantrumCast = mod:NewCastTimer(62776)
local timerTympanicTantrum     = mod:NewBuffActiveTimer(8, 312939, nil, nil, nil, 5, nil, CL.HEALER_ICON)
local timerTympanicTantrumCD   = mod:NewCDTimer(35, 312939, nil, nil, nil, 2, nil, CL.HEALER_ICON)
local timerHeart               = mod:NewCastTimer(30, 312945, nil, nil, nil, 6, nil, CL.DAMAGE_ICON)
local timerLightBomb           = mod:NewTargetTimer(9, 312941, nil, nil, nil, 3)
local timerGravityBomb         = mod:NewTargetTimer(9, 312943, nil, nil, nil, 3)
--local timerAchieve             = mod:NewAchievementTimer(205, 2937)

mod:AddSetIconOption("SetIconOnLightBombTarget", 312941, true, true, { 7 })
mod:AddSetIconOption("SetIconOnGravityBombTarget", 64234, true, true, { 8 })
mod:AddNamePlateOption("LightBombPlate", 312941, true)
mod:AddNamePlateOption("GravityBombPlate", 312943, true)
mod:AddRangeFrameOption(12, nil, true)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33293, "XT-002 Deconstructor")
	enrageTimer:Start(-delay)
	--timerAchieve:Start()
	if self:IsDifficulty("normal10") then
		timerTympanicTantrumCD:Start(35 - delay)
	else
		timerTympanicTantrumCD:Start(60 - delay)
	end
end

function mod:OnCombatEnd()
	DBM:FireCustomEvent("DBM_EncounterStart", 33293, "XT-002 Deconstructor", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(62776, 312586, 312939) then
		timerTympanicTantrumCast:Start()
		timerTympanicTantrumCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if args:IsSpellID(62775, 312587, 312940) and args.auraType == "DEBUFF" then -- Tympanic Tantrum
		timerTympanicTantrum:Start()
	elseif args:IsSpellID(63018, 65121, 312588, 312941) then -- Light Bomb
		if args:IsPlayer() then
			specWarnLightBomb:Show()
			specWarnLightBomb:Play("runout")
			yellLightBomb:Yell()
			yellLightBombFades:Countdown(312941)
		end
		if self.Options.SetIconOnLightBombTarget then
			self:SetIcon(args.destName, 7)
		end
		warnLightBomb:Show(args.destName)
		timerLightBomb:Start(args.destName)
		if self.Options.LightBombPlate then
			DBM.Nameplate:Show(args.destGUID, 312941)
		end
	elseif args:IsSpellID(63024, 64234, 312590, 312943) then
		if args:IsPlayer() then
			specWarnGravityBomb:Show()
			specWarnGravityBomb:Play("runout")
			yellGravityBomb:Yell()
			yellGravityBombFades:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(30)
			end
		end
		if self.Options.SetIconOnGravityBombTarget then
			self:SetIcon(args.destName, 8)
		end
		warnGravityBomb:Show(args.destName)
		timerGravityBomb:Start(args.destName)
		if self.Options.GravityBombPlate then
			DBM.Nameplate:Show(args.destGUID, 312943)
		end
	elseif args:IsSpellID(312945, 63849) then
		timerHeart:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if args:IsSpellID(63018, 65121, 312588, 312941) then -- Ополяющий свет
		if args:IsPlayer() then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnLightBombTarget then
			self:RemoveIcon(args.destName)
		end
		if args:IsPlayer() then
			yellLightBombFades:Cancel()
		end
		if self.Options.LightBombPlate then
			DBM.Nameplate:Hide(args.destGUID, 312941)
		end
	elseif args:IsSpellID(63024, 64234, 312590, 312943) then -- Грави бомба
		if args:IsPlayer() then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnGravityBombTarget then
			self:RemoveIcon(args.destName)
		end
		if self.Options.GravityBombPlate then
			DBM.Nameplate:Hide(args.destGUID, 312943)
		end
		if args:IsPlayer() then
			yellGravityBombFades:Cancel()
		end
	elseif args:IsSpellID(312945, 63849) then
		timerHeart:Stop()
	end
end

function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, spellId)
	if (spellId == 64208 or spellId == 64206) and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnConsumption:Show()
		specWarnConsumption:Play("runaway")
	end
end

mod.SPELL_MISSED = mod.SPELL_DAMAGE
