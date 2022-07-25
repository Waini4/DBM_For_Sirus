---------------------------------------
---------------------------------------

local mod = DBM:NewMod("Gorelac", "DBM-Serpentshrine")
-- local L		= mod:GetLocalizedStrings()
local CL = DBM_COMMON_L

mod:SetRevision("20220609123000") -- fxpw check 20220609123000


mod:SetCreatureID(121217)
mod:RegisterCombat("combat", 121217)
mod:SetUsedIcons(7, 8)


mod:RegisterEvents(
	"SPELL_CAST_START 310566 310549 310564 310565 310557",
	"SPELL_CAST_SUCCESS 310548 310560 310561 310562 310563",
	"SPELL_AURA_APPLIED 310546 310547 310548 310549 310566",
	"SPELL_AURA_REMOVED 310549 310548"
)


local warnStrongBeat    = mod:NewStackAnnounce(310548, 1, nil, "Tank")
local warnPoisonous     = mod:NewSpellAnnounce(310549, 4)
-- local warnParalysis				= mod:NewSpellAnnounce(310555, 4)
local warnMassiveShell  = mod:NewTargetAnnounce(310560, 2)
local warnPowerfulShot  = mod:NewTargetAnnounce(310564, 4)
local warnShrillScreech = mod:NewSpellAnnounce(310566, 4)
local warnCallGuardians = mod:NewSpellAnnounce(310557, 4)

local specWarnRippingThorn   = mod:NewSpecialWarningStack(310546, "Melee", 7)
local specWarnPoisonousBlood = mod:NewSpecialWarningStack(310547, "SpellCaster", 7)
local specWarnStrongBeat     = mod:NewSpecialWarningYou(310548, nil, nil, nil, 2, 2)
local specWarnPoisonous      = mod:NewSpecialWarningYou(310549, nil, nil, nil, 2, 2)
local specwarnCallGuardians  = mod:NewSpecialWarningSwitch(310557, "Ranged|Tank", nil, nil, 1, 2)
local specWarnShrillScreech  = mod:NewSpecialWarningYou(310566, nil, nil, nil, 2, 2)

local timerStrongBeat      = mod:NewBuffFadesTimer(30, 310548, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerPoisonous       = mod:NewBuffFadesTimer(30, 310549, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerShrillScreech   = mod:NewBuffFadesTimer(6, 310566, nil, nil, nil, 5, nil, CL.INTERRUPT_ICON)
local timerPoisonousCD     = mod:NewCDTimer(25, 310549, nil, nil, nil, 3, nil, CL.TANK_ICON)
local timerStrongBeatCD    = mod:NewCDTimer(25, 310548, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local timerCallGuardiansCD = mod:NewNextTimer(45, 310557, nil, nil, nil, 1, nil, CL.DAMAGE_ICON)

local enrageTimer = mod:NewBerserkTimer(750)


function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 121217, "Gorelac")
	enrageTimer:Start()
	timerCallGuardiansCD:Start(45 - delay)
	DBM.RangeCheck:Show(6)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 121217, "Gorelac", wipe)
	DBM.RangeCheck:Hide()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 310566 then
		warnShrillScreech:Show()
	elseif spellId == 310549 then
		warnPoisonous:Show()
		timerPoisonousCD:Start()
	elseif args:IsSpellID(310565, 310564) then
		warnPowerfulShot:Show(args.destName)
	elseif spellId == 310557 then
		warnCallGuardians:Show()
		specwarnCallGuardians:Show()
		timerCallGuardiansCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 310546 then
		local amount = args.amount or 1
		if amount >= 10 then
			if args:IsPlayer() then
				specWarnRippingThorn:Show(args.amount)
				-- specWarnRippingThorn:Play("stackhigh")
			end
		end
	elseif spellId == 310547 then
		local amount = args.amount or 1
		if amount >= 10 then
			if args:IsPlayer() then
				specWarnPoisonousBlood:Show(args.amount)
				-- specWarnPoisonousBlood:Play("stackhigh")
			end
		end
	elseif spellId == 310548 then
		warnStrongBeat:Show(args.destName, args.amount or 1)
		if args:IsPlayer() then
			specWarnStrongBeat:Show()
			timerStrongBeat:Start(args.destName)
		end
	elseif spellId == 310549 then
		timerPoisonous:Start(args.destName)
		if args:IsPlayer() then
			specWarnPoisonous:Show()
		end
	elseif spellId == 310566 then
		timerShrillScreech:Start()
		if args:IsPlayer() then
			specWarnShrillScreech:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 310548 then
		timerStrongBeatCD:Start()
	elseif args:IsSpellID(310560, 310561, 310562, 310563) then
		warnMassiveShell:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 310549 then
		if args:IsPlayer() then
			timerPoisonous:Cancel()
		end
	elseif spellId == 310548 then
		if args:IsPlayer() then
			timerStrongBeat:Cancel()
		end
	end
end
