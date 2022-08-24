local mod	= DBM:NewMod("Omor", "DBM-Party-BC", 1, 248)

mod:SetRevision("20220518110528")
mod:SetCreatureID(17308)

mod:SetModelID(18237)
mod:SetModelOffset(-2, 0.8, -1)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 37566",
	"SPELL_AURA_REMOVED 37566",
	"SPELL_CAST_START 30637"
)

local warnBane      = mod:NewTargetNoFilterAnnounce(37566)

local specwarnBane  = mod:NewSpecialWarningMoveAway(37566, nil, nil, nil, 1, 2)
local yellBane		= mod:NewYell(37566)

local timerOrbital	= mod:NewCDTimer(30.2, 30637,nil, nil, nil, 2)
local timerBane     = mod:NewTargetTimer(15, 37566, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnBaneTarget", 37566, true, false, {6, 7, 8})
mod:AddRangeFrameOption(37566, 15)

function mod:OnCombatStart()
	timerOrbital:Start(24.5)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 37566 then
		timerBane:Start(args.destName)
		if self.Options.SetIconOnBaneTarget then
			self:SetIcon(args.destName, 10)
		end
		if args:IsPlayer() then
            specwarnBane:Show()
            specwarnBane:Play("runout")
            yellBane:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(15)
			end
		else
			warnBane:Show(args.destName)
        end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 37566 then
		timerBane:Stop(args.destName)
		if self.Options.SetIconOnBaneTarget then
			self:RemoveIcon(args.destName)
		end
		if args:IsPlayer() and self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end
