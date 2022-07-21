local mod = DBM:NewMod("Malacrass", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(24239)
mod:RegisterCombat("combat", 24239)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 43442",
	"SPELL_CAST_SUCCESS 43383 43429",
	"SPELL_AURA_APPLIED 43501 43439 43440 305658"
)
local isDecurser = select(2, UnitClass("player")) == "DRUID" or select(2, UnitClass("player")) == "MAGE"
local iconFolder = "Interface\\AddOns\\Dbm-Core\\icon\\%s"

local timerBolts      = mod:NewCDTimer(40, 43383)
local timerSpecial    = mod:NewTimer(10, "TimerSpecial", 43501)
local specWarnDecurse = mod:NewSpecialWarningDispel(43439, isDecurser)
local specWarnMelee   = mod:NewSpecialWarning("SpecWarnMelee", "Melee")
local specWarnMove    = mod:NewSpecialWarning("SpecWarnMove")
local warnSiphon      = mod:NewAnnounce("WarnSiphon", 4, 43501)

mod:AddBoolOption("TimerSpecial", true)
mod:AddBoolOption("SpecWarnMelee", true)
mod:AddBoolOption("SpecWarnMove", true)
mod:AddBoolOption("WarnSiphon", true)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 24239, "Hex Lord Malacrass")
	timerBolts:Start(20)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 24239, "Hex Lord Malacrass", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43442) then
		specWarnMelee:Show(args.spellName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43383) then
		timerBolts:Start()
	elseif args:IsSpellID(43429) then
		specWarnMelee:Show(args.spellName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43501) then
		local class, classEN
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid" .. i) == args.destName then
				class, classEN = UnitClass("raid" .. i)
				break
			end
		end
		warnSiphon:Show(">" .. args.destName .. "<", iconFolder:format(classEN))
		timerSpecial:Show(class, iconFolder:format(classEN))
		timerSpecial:Schedule(8, class, iconFolder:format(classEN))
		timerSpecial:Schedule(16, class, iconFolder:format(classEN))
	elseif args:IsSpellID(43439) then
		specWarnDecurse:Show(args.destName)
	elseif args:IsSpellID(43440) then
		if args:IsPlayer() then
			specWarnMove:Show(args.spellName)
		end
	elseif args:IsSpellID(305658) then
		if args:IsPlayer() then
			specWarnMove:Show(args.spellName)
		end
	end
end
