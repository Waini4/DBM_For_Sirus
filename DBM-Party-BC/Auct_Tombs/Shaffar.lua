local mod	= DBM:NewMod("Shaffar", "DBM-Party-BC", 8, 250)

mod:SetRevision("20220518110528")
mod:SetCreatureID(18344)

mod:SetModelScale(0.5)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local specWarnAdds	= mod:NewSpecialWarningAdds(32371, "-Healer", nil, nil, 1, 2)
local timerFireballCD		= mod:NewCDTimer(5, 32363)
local timerFrostboltCD		= mod:NewCDTimer(5, 32364)
local timerNovaCD			= mod:NewCDTimer(24, 32365)
local timerBlinkCD			= mod:NewCDTimer(24, 34605)
local timerEtherealOrb		= mod:NewTimer(10, "TimerEtherealOrb",  64465)
local timerEtherealSpawn	= mod:NewTimer(10, "TimerEtherealSpawn",  69960)

function mod:ethereal()
	timerEtherealOrb:Start()
	timerEtherealSpawn:Start()
	self:ScheduleMethod(10, "ethereal")
end
function mod:OnCombatStart()
	timerFireballCD:Start()
	timerFrostboltCD:Start()
	timerNovaCD:Start(15)
	timerBlinkCD:Start(16)
	timerEtherealOrb:Start()
	timerEtherealSpawn:Start()
	self:ScheduleMethod(10, "ethereal")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(32365) then
		timerNovaCD:Start()
	elseif args:IsSpellID(34605) then
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName)
	if spellName == GetSpellInfo(32371) then
		self:SendSync("Adds")
	end
end

function mod:OnSync(msg)
	if msg == "Adds" and self:AntiSpam(5, 1) then
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")
	end
end