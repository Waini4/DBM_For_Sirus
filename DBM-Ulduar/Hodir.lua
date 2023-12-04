local mod	= DBM:NewMod("Hodir", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()
DBM_COMMON_L = {}
local CL = DBM_COMMON_L

mod:SetRevision("20220518110528")
mod:SetCreatureID(32845,32926)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellKill)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312818 312465 61968",
	"SPELL_AURA_APPLIED 312817 312816 312464 312463 62478 63512 312831 312478 65123 65133",
	"SPELL_AURA_REMOVED 312831 312478 65123 65133",
	"SPELL_DAMAGE 62038 62188 312466 312819"
)

--TODO, refactor biting cold to track unit aura stacks and start spaming at like 4-5
local warnStormCloud		= mod:NewTargetNoFilterAnnounce(312831)

local specWarnFlashFreeze	= mod:NewSpecialWarningSpell(312818, nil, nil, nil, 3, 2)
local specWarnStormCloud	= mod:NewSpecialWarningYou(65123, nil, nil, nil, 1, 2)
local yellStormCloud		= mod:NewYell(65133)
local yellStormCloudFades	= mod:NewShortFadesYell(65133)
local specWarnBitingCold	= mod:NewSpecialWarningMove(312819, nil, nil, nil, 1, 2)

local enrageTimer			= mod:NewBerserkTimer(475)
local timerFlashFreeze		= mod:NewCastTimer(9, 312818, nil, nil, nil, 2)
local timerFrozenBlows		= mod:NewBuffActiveTimer(20, 63512, nil, nil, nil, 5, nil, CL.TANK_ICON)
local timerFlashFrCD		= mod:NewCDTimer(60, 312818, nil, nil, nil, 2)
--local timerAchieve			= mod:NewAchievementTimer(179, 3182)

mod:AddSetIconOption("SetIconOnStormCloud", 65123, true, false, {8, 7})

mod.vb.stormCloudIcon = 8

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 32845, "Hodir")

	enrageTimer:Start(-delay)
--	timerAchieve:Start()
	timerFlashFrCD:Start(-delay)
	self.vb.stormCloudIcon = 8
end
function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 32845, "Hodir", wipe)

end
function mod:SPELL_CAST_START(args)
	if args:IsSpellID(312818, 312465, 61968) then
		timerFlashFreeze:Start()
		specWarnFlashFreeze:Show()
		specWarnFlashFreeze:Play("findshelter")
		timerFlashFrCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if args:IsSpellID(312817, 312816, 312464, 312463, 62478, 63512) then
		timerFrozenBlows:Start()
	elseif spellId == 312831 or spellId == 312478 or spellId == 65123 or spellId == 65133 then
		if args:IsPlayer() then
			specWarnStormCloud:Show()
			specWarnStormCloud:Play("gathershare")
			yellStormCloud:Yell()
			yellStormCloudFades:Countdown(spellId)
		else
			warnStormCloud:Show(args.destName)
		end
		if self.Options.SetIconOnStormCloud then
			self:SetIcon(args.destName, self.vb.stormCloudIcon)
		end
		if self.vb.stormCloudIcon == 8 then	-- There is a chance 2 ppl will have the buff on 25 player, so we are alternating between 2 icons
			self.vb.stormCloudIcon = 7
		else
			self.vb.stormCloudIcon = 8
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(312831, 312478, 65123, 65133) then
		if self.Options.SetIconOnStormCloud then
			self:RemoveIcon(args.destName)
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, spellId)
	if (spellId == 62038 or spellId == 62188 or spellId == 312466 or spellId == 312819) and destGUID == UnitGUID("player") and self:AntiSpam(4) then
		specWarnBitingCold:Show()
		specWarnBitingCold:Play("keepmove")
	end
end