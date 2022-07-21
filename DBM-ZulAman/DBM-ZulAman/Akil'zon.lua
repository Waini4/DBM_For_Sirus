local mod	= DBM:NewMod("Akilzon", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(23574)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat",23574)

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local timerNextStorm		= mod:NewCDTimer(60, 43648)
local timerNextDisrupt		= mod:NewCDTimer(11, 43622)
local warnWind				= mod:NewAnnounce("WarnWind", 4, 43621)
local timerDisrupt			= mod:NewTargetTimer(20, 44008)
local specWarnDisrupt		= mod:NewSpecialWarningYou(44008)
local berserkTimer			= mod:NewBerserkTimer(480)

mod:AddBoolOption("SetIconOnElectricStorm", true)
mod:AddBoolOption("SayOnElectricStorm", true)
mod:AddBoolOption("WarnWind", true)
mod:AddBoolOption("RangeFrame",true)

local disruptCounter = 0

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23574, "Akil'zon")
	timerNextStorm:Start()
	timerNextDisrupt:Start()
	berserkTimer:Start()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(12)
	end
	disruptCounter = 0
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23574, "Akil'zon", wipe)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43648) then
		timerNextStorm:Start()
		if self.Options.SetIconOnElectricStorm then
			self:SetIcon(args.destName, 8)
		end
		if self.Options.SayOnElectricStorm and args:IsPlayer() then
			SendChatMessage(L.SayStorm, "SAY")
		end
		disruptCounter = 0
	elseif args:IsSpellID(44008) then
		if args:IsPlayer() then
			specWarnDisrupt:Show()
		end
		--timerDisrupt:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(43648) then
		self:RemoveIcon(args.destName)
		timerNextDisrupt:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43622) and disruptCounter ~= 3 then
		timerNextDisrupt:Start()
		disruptCounter = disruptCounter + 1
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43621) then
		warnWind:Show(args.destName)
	end
end

