local mod = DBM:NewMod("Nalorakk", "DBM-ZulAman")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220831130000")

mod:SetCreatureID(23576)
mod:RegisterCombat("yell", L.YellPullNal)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 42389 42398",
	"CHAT_MSG_MONSTER_YELL"
)

local warnBear           = mod:NewAnnounce("WarnBear", 4, 39414)
local warnBearSoon       = mod:NewAnnounce("WarnBearSoon", 3, 39414)
local warnTroll          = mod:NewAnnounce("WarnTroll", 4, 39414)
local warnTrollSoon      = mod:NewAnnounce("WarnTrollSoon", 3, 39414)
local warnSilence        = mod:NewSpellAnnounce(42398, 3)

local timerNextBearForm  = mod:NewTimer(45, "TimerBear", 9634, nil, nil, 6)
local timerNextTrollForm = mod:NewTimer(30, "TimerTroll", 26297, nil, nil, 6)
local timerNextSilence   = mod:NewCDTimer(20, 42398)
local timerMangle        = mod:NewTargetTimer(60, 42389)

local berserkTimer       = mod:NewBerserkTimer(480)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 23576, "Nalorakk")
	warnBearSoon:Schedule(40)
	timerNextBearForm:Start(45)
	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 23576, "Nalorakk", wipe)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(42389) then
		timerMangle:Start(args.destName)
	elseif args:IsSpellID(42398) and self:AntiSpam(4, 1) then
		warnSilence:Show()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellBear or msg:find(L.YellBear) then
		timerNextBearForm:Cancel()
		warnBearSoon:Cancel()
		warnBear:Show()
		timerNextSilence:Start()
		timerNextTrollForm:Start()
		warnTrollSoon:Schedule(25)
	elseif msg == L.YellTroll or msg:find(L.YellTroll) then
		timerNextTrollForm:Cancel()
		warnTrollSoon:Cancel()
		timerNextSilence:Cancel()
		warnTroll:Show()
		timerNextBearForm:Start()
		warnBearSoon:Schedule(40)
	end
end
