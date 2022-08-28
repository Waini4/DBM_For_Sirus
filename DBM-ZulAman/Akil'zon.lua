local mod	= DBM:NewMod("Akilzon", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220802205228")
mod:SetCreatureID(23574)

mod:SetUsedIcons(1)

mod:RegisterCombat("yell", L.YellPullAKil)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 43621",
	"SPELL_AURA_APPLIED 43648 44008",
	"SPELL_AURA_REMOVED 43648"
)

local warnStorm						= mod:NewTargetNoFilterAnnounce(43648, 4)
local warnStormSoon					= mod:NewSoonAnnounce(43648, 5, 3)
local warnWind						= mod:NewAnnounce("WarnWind", 4, 43621)

local SpecWarnDisrupt				= mod:NewSpecialWarningRun(43622, nil, nil, nil, 1, 2)
local specWarnStorm					= mod:NewSpecialWarningSpell(43648, nil, nil, nil, 2, 2)

local timerNextDisrupt				= mod:NewCDTimer(11, 43622)
local timerStorm					= mod:NewCastTimer(8, 43648, nil, nil, nil, 2, nil, DBM_COMMON_L.HEALER_ICON)
local timerStormCD					= mod:NewCDTimer(55, 43648, nil, nil, nil, 3)
local timerNextStatic				= mod:NewCDTimer(14, 44008)
local SayOnElectricStorm			= mod:NewYellMe(43622)
local berserkTimer					= mod:NewBerserkTimer(480)

mod:AddRangeFrameOption(12,44008)
mod:AddBoolOption("WarnWind", true)--old option
mod:AddSetIconOption("SetIconOnElectricStorm", 43648, true, false, {1})

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23574, "Akil'zon")
	warnStormSoon:Schedule(43)
	timerStormCD:Start(48)
	berserkTimer:Start(-delay)
	timerNextStatic:Start()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
end

function mod:OnCombatEnd()
	DBM:FireCustomEvent("DBM_EncounterEnd", 23574, "Akil'zon", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43648) then
		warnStorm:Show(args.destName)
		specWarnStorm:Show()
		specWarnStorm:Play("specialsoon")
		timerStorm:Start()
		warnStormSoon:Schedule(50)
		timerStormCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
			self:Schedule(10, function()
				DBM.RangeCheck:Show()
			end)
		end
		if self.Options.SetIconOnElectricStorm then
			self:SetIcon(args.destName, 1)
		end
		SayOnElectricStorm:Yell()
	elseif args:IsSpellID(44008) then
		if args:IsPlayer() then
			SpecWarnDisrupt:Show()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(43648) then
		self:RemoveIcon(args.destName)
		timerNextDisrupt:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43621) then
		warnWind:Show(args.destName)
	elseif args:IsSpellID(44008) then
		timerNextStatic:Show()
	end
end