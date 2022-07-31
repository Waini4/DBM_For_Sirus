local mod	= DBM:NewMod("DevourerofSouls", "DBM-Party-WotLK", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(36502)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68982 70322 68820 68939 68899 70324",
	"SPELL_AURA_APPLIED 69051 68939",
	"SPELL_AURA_REMOVED 69051"
)

local warnUnleashedSouls		= mod:NewSpellAnnounce(68939, 3)
local warnWellofSouls			= mod:NewSpellAnnounce(68820, 3)
local warnMirroredSoul			= mod:NewTargetAnnounce(69051, 4)

local specwarnMirroredSoul		= mod:NewSpecialWarningReflect(69051, nil, nil, nil, 1, 2)
local specwarnWailingSouls		= mod:NewSpecialWarningSpell(68899, nil, nil, nil, 2, 2)
local specwarnPhantomBlast		= mod:NewSpecialWarningInterrupt(68982, "HasInterrupt", nil, nil, 1, 2)

local timerMirroredSoulCD		= mod:NewCDTimer(20, 69051, nil, nil, nil, 2)
local timerMirroredSoul			= mod:NewTargetTimer(8, 69051, nil, nil, nil, 3)
local timerUnleashedSoulsCD		= mod:NewCDTimer(18.3, 68939, nil, nil, nil, 2)
local timerUnleashedSouls		= mod:NewBuffActiveTimer(5, 68939, nil, nil, nil, 2)

mod:AddSetIconOption("SetIconOnMirroredTarget", 69051, false, false, {8})

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 36502, "DevourerofSouls")
	timerMirroredSoulCD:Start(7.8)
	timerUnleashedSoulsCD:Start(19.8)
end


function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 36502, "DevourerofSouls", wipe)
end


function mod:SPELL_CAST_START(args)
	if args:IsSpellID(68982, 70322) and self:CheckInterruptFilter(args.sourceGUID, false, true) then	-- Phantom Blast
		specwarnPhantomBlast:Show(args.sourceName)
		specwarnPhantomBlast:Play("kickcast")
	elseif args.spellId == 68820 then					-- Well of Souls
		warnWellofSouls:Show()
	elseif args.spellId == 68939 then					-- Unleashed Souls
		warnUnleashedSouls:Show()
	elseif args:IsSpellID(68899, 70324) then					-- Wailing Souls
		specwarnWailingSouls:Show()
		specwarnWailingSouls:Play("aesoon")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 69051 and args:IsDestTypePlayer() then	-- Mirrored Soul
		warnMirroredSoul:Show(args.destName)
		timerMirroredSoul:Start(args.destName)
		specwarnMirroredSoul:Show(args.sourceName)--if sourcename isn't good use L.name
		specwarnMirroredSoul:Play("stopattack")
		timerMirroredSoulCD:Start()
		if self.Options.SetIconOnMirroredTarget then
			self:SetIcon(args.destName, 8, 8)
		end
	elseif args.spellId == 68939 then							-- Unleashed Souls
		timerUnleashedSouls:Start()
		timerUnleashedSoulsCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 69051 and args:IsDestTypePlayer() then	-- Mirrored Soul
		timerMirroredSoul:Cancel(args.destName)
		if self.Options.SetIconOnMirroredTarget then
			self:RemoveIcon(args.destName)
		end
	end
end