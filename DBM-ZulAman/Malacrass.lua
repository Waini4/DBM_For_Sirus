local mod = DBM:NewMod("Malacrass", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))

mod:SetCreatureID(24239)
mod:RegisterCombat("combat", 24239)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 43442 43548 43451 43431",
	"SPELL_CAST_SUCCESS 43383 43429",
	"SPELL_AURA_APPLIED 43501 43439 43440 305658",
	"SPELL_SUMMON 43436"
)

local warnHeal1		= mod:NewCastAnnounce(43548, 3)
local warnHeal2		= mod:NewCastAnnounce(43451, 3)
local warnHeal3		= mod:NewCastAnnounce(43431, 3)
local warnHeal4		= mod:NewTargetNoFilterAnnounce(43421, 3)

local isDecurser = select(2, UnitClass("player")) == "DRUID" or select(2, UnitClass("player")) == "MAGE"
local iconFolder = "Interface\\AddOns\\Dbm-Core\\icon\\%s"

local specWarnHeal1	= mod:NewSpecialWarningInterrupt(43548, "HasInterrupt", nil, nil, 1, 2)
local specWarnHeal2	= mod:NewSpecialWarningInterrupt(43451, "HasInterrupt", nil, nil, 1, 2)
local specWarnHeal3	= mod:NewSpecialWarningInterrupt(43431, "HasInterrupt", nil, nil, 1, 2)
local specWarnHeal4	= mod:NewSpecialWarningDispel(43421, "MagicDispeller", nil, nil, 1, 2)


local timerBolts      = mod:NewCDTimer(40, 43383)
local timerSpecial    = mod:NewTimer(10, "TimerSpecial", 43501)
local specWarnDecurse = mod:NewSpecialWarningDispel(43439, isDecurser)
local specWarnMelee   = mod:NewSpecialWarning("SpecWarnMelee", "Melee")
local specWarnMove    = mod:NewSpecialWarning("SpecWarnMove")
local specWarnTotem		= mod:NewSpecialWarningSwitch(43436, "Dps", nil, nil, 1, 2)
local warnSiphon      = mod:NewAnnounce("WarnSiphon", 4, 43501)
local timerSiphon	= mod:NewTargetTimer(30, 43501, nil, nil, nil, 6)

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
	elseif args:IsSpellID(43548) then
		if self.Options.SpecWarn43548interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal1:Show(args.sourceName)
			specWarnHeal1:Play("kickcast")
		else
			warnHeal1:Show()
		end
	elseif args:IsSpellID(43451) then
		if self.Options.SpecWarn43451interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal2:Show(args.sourceName)
			specWarnHeal2:Play("kickcast")
		else
			warnHeal2:Show()
		end
	elseif args:IsSpellID(43431) then
		if self.Options.SpecWarn43431interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal3:Show(args.sourceName)
			specWarnHeal3:Play("kickcast")
		else
			warnHeal3:Show()
		end
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
		-- warnSiphon:Show(args.destName)
		timerSiphon:Show(args.destName)
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
	elseif args:IsSpellID(43421) and not args:IsDestTypePlayer() then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal4:Show(args.destName)
			specWarnHeal4:Play("dispelboss")
		else
			warnHeal4:Show(args.destName)
		end
	end
end
function mod:SPELL_SUMMON(args)
	if args:IsSpellID(43436) then
		specWarnTotem:Show()
		specWarnTotem:Play("attacktotem")
	end
end
