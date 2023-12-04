local mod	= DBM:NewMod("Ignis the Furnace Master", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(33118)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312727 312728 62680 63472",
	"SPELL_CAST_SUCCESS 312729 312730 62548 63474",
	"SPELL_AURA_APPLIED 312732 312731 62717 63477 62382",
	"SPELL_AURA_REMOVED 312732 312731 62717 63477"
)

local announceSlagPot			= mod:NewTargetNoFilterAnnounce(312731, 3)
local announceConstruct			= mod:NewCountAnnounce(62488, 2)

local warnFlameJetsCast			= mod:NewSpecialWarningCast(312727, nil, nil, nil, 2, 2)
local warnFlameBrittle			= mod:NewSpecialWarningSwitch(62382, "Dps", nil, nil, 1, 2)

local timerFlameJetsCast		= mod:NewCastTimer(2.7, 312727)
local timerActivateConstruct	= mod:NewCDCountTimer(30, 62488, nil, nil, nil, 1)
local timerFlameJetsCooldown	= mod:NewCDCountTimer(42, 312727, nil, nil, nil, 2)
local timerScorchCooldown		= mod:NewCDTimer(31, 312730, nil, nil, nil, 5)
local timerScorchCast			= mod:NewCastTimer(3, 312730)
local timerSlagPot				= mod:NewTargetTimer(10, 312731, nil, nil, nil, 3)
--local timerAchieve				= mod:NewAchievementTimer(240, 2930)

mod.vb.FlameJetsCount = 0

mod:AddSetIconOption("SlagPotIcon", 63477, false, false, {8})

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33118, "Ignis the Furnace Master")
	self.vb.FlameJetsCount = 0
	--timerAchieve:Start()
	timerScorchCooldown:Start(12-delay)
	timerFlameJetsCooldown:Start(29, self.vb.FlameJetsCount)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 33118, "Ignis the Furnace Master", wipe)

end
function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 312727 or spellId == 312728 or spellId == 62680 or spellId == 63472 then		-- Flame Jets
		timerFlameJetsCast:Start()
		warnFlameJetsCast:Show()
		warnFlameJetsCast:Play("stopcast")
		self.vb.FlameJetsCount = self.vb.FlameJetsCount + 1
		timerFlameJetsCooldown:Start(nil, self.vb.FlameJetsCount + 1)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 312729 or spellId == 312730 or spellId == 62548 or spellId == 63474 then	-- Scorch
		timerScorchCast:Start()
		timerScorchCooldown:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312732 or spellId == 312731 or spellId == 62717 or spellId == 63477 then		-- Slag Pot
		announceSlagPot:Show(args.destName)
		timerSlagPot:Start(args.destName)
		if self.Options.SlagPotIcon then
			self:SetIcon(args.destName, 8, 10)
		end
	elseif args.spellId == 62382 and self:AntiSpam(5, 1) then
		warnFlameBrittle:Show()
		warnFlameBrittle:Play("killmob")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 312732 or spellId == 312731 or spellId == 62717 or spellId == 63477 then		-- Slag Pot
		if self.Options.SlagPotIcon then
			self:RemoveIcon(args.destName)
		end
	end
end