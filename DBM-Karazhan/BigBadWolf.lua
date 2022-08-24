local mod = DBM:NewMod("BigBadWolf", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(17521)
mod:RegisterCombat("yell", L.DBM_BBW_YELL_1)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 30753 30752"
)

local warningFearSoon = mod:NewSoonAnnounce(30752, 2)
local warningFear     = mod:NewSpellAnnounce(30752, 3)
local warningRRHSoon  = mod:NewSoonAnnounce(30753, 3)
local warningRRH      = mod:NewTargetAnnounce(30753, 4)

local specWarnRRH = mod:NewSpecialWarningYou(30753, nil, nil, nil, 4, 2)

local timerRRH    = mod:NewTargetTimer(20, 30753, nil, nil, nil, 3)
local timerRRHCD  = mod:NewNextTimer(30, 30753, nil, nil, nil, 3)
local timerFearCD = mod:NewNextTimer(24, 30752, nil, nil, nil, 2)

mod:AddBoolOption("RRHIcon")
mod:AddSetIconOption("RRHIcon", 69762, true, true, { 8 })


local lastFear = 0


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30753) then
		warningRRH:Show(args.destName)
		timerRRH:Start(args.destName)
		timerRRHCD:Start()
		warningRRHSoon:Cancel()
		warningRRHSoon:Schedule(25)
		if args:IsPlayer() then
			specWarnRRH:Show()
		end
		if self.Options.RRHIcon then
			local targetname = self:GetBossTarget(17521)
			self:SetIcon(targetname, 8, 20)
		end
	elseif args:IsSpellID(30752) and GetTime() - lastFear > 2 then
		warningFear:Show()
		warningFearSoon:Cancel()
		warningFearSoon:Schedule(19)
		timerFearCD:Start()
		lastFear = GetTime()
	end
end
