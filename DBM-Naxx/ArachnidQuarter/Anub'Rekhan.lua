local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220629223621")
mod:SetCreatureID(15956)

mod:RegisterCombat("combat_yell", L.Pull1, L.Pull2)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 28785 54021",
	"SPELL_AURA_REMOVED 28785 54021"
)
local myRealm = select(4, DBM:GetMyPlayerInfo()) == 1

local warningLocustSoon		= mod:NewSoonAnnounce(28785, 2)
local warningLocustFaded	= mod:NewFadesAnnounce(28785, 1)
--local warnImpale			= mod:NewTargetNoFilterAnnounce(28783, 3)

local specialWarningLocust	= mod:NewSpecialWarningSpell(28785, nil, nil, nil, 2, 2)
--local yellImpale			= mod:NewYell(28783)

local timerLocustIn			= mod:NewCDTimer(myRealm and 45 or 90, 28785, nil, nil, nil, 6)
local timerLocustFade		= mod:NewBuffActiveTimer(myRealm and 10 or 23, 28785, nil, nil, nil, 6)

mod:AddBoolOption("ArachnophobiaTimer", true, "timer", nil, nil, nil, "at1859")--Sad caveat that 10 and 25 man have own achievements and we have to show only 1 in GUI


function mod:OnCombatStart(delay)
	if self:IsDifficulty("normal25") then
		timerLocustIn:Start(myRealm and 60 or 100)
		warningLocustSoon:Schedule(myRealm and 60 or 90)
	else
		timerLocustIn:Start(myRealm and 50 or 91)
		warningLocustSoon:Schedule(myRealm and 50 or 76)
	end
end

function mod:OnCombatEnd(wipe)
	if not wipe and self.Options.ArachnophobiaTimer then
		DBT:CreateBar(1200, L.ArachnophobiaTimer)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28785, 54021) then  -- Locust Swarm
		specialWarningLocust:Show()
		specialWarningLocust:Play("aesoon")
		timerLocustIn:Stop()
		if self:IsDifficulty("normal25") then
			timerLocustFade:Start(myRealm and 10 or 23)
		else
			timerLocustFade:Start(myRealm and 10 or 19)
		end
--	elseif args.spellId == 28783 then  -- Impale (56090?)
--		self:BossTargetScanner(args.sourceGUID, "ImpaleTarget", 0.1, 6)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(28785, 54021)
	and args.auraType == "BUFF" then
		warningLocustFaded:Show()
		timerLocustIn:Start()
		warningLocustSoon:Schedule(myRealm and 40 or 62)
	end
end