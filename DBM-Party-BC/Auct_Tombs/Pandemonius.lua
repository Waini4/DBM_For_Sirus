local mod	= DBM:NewMod("Pandemonius", "DBM-Party-BC", 8, 250)

mod:SetRevision("20220518110528")
mod:SetCreatureID(18341)

mod:SetModelScale(0.6)
mod:SetModelOffset(0, 0, 0.8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 32358 38759 38760"
)

local specWarnShell			= mod:NewSpecialWarningReflect(32358, nil, nil, 2, 1, 2)

local timerShell			= mod:NewBuffActiveTimer(7, 32358, nil, nil, nil, 5)
local timerShellCD			= mod:NewCDTimer(20, 38759)
local timerBlastCD			= mod:NewCDTimer(20, 38760)
local firstBlast = true

function mod:blastreset()
	firstBlast = true
end

function mod:OnCombatStart()
	timerBlastCD:Start()
	timerShellCD:Start()
	firstBlast = true
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38760) and firstBlast then
		firstBlast = false
		timerBlastCD:Start()
		self:ScheduleMethod(10, "blastreset")
	elseif args:IsSpellID(32358, 38759) then
		timerShell:Start()
		specWarnShell:Show(args.sourceName)
		specWarnShell:Play("stopattack")
		timerShellCD:Start()
		timerShellCD:Show()
	end
end
