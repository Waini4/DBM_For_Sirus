local mod	= DBM:NewMod("Ahune", "DBM-WorldEvents")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220630185628")
mod:SetCreatureID(25740)--25740 Ahune, 25755, 25756 the two types of adds

mod:SetReCombatTime(10)
mod:RegisterCombat("combat")
mod:SetMinCombatTime(15)

mod:RegisterEvents(
	"CHAT_MSG_SAY"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 45954",
	"SPELL_AURA_REMOVED 45954"
)

local warnSubmerged				= mod:NewAnnounce("Submerged", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnEmerged				= mod:NewAnnounce("Emerged", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")

local specWarnAttack			= mod:NewSpecialWarning("specWarnAttack", nil, nil, nil, 1, 2)

local timerCombatStart			= mod:NewCombatTimer(10)--rollplay for first pull
local timerEmerge				= mod:NewTimer(33.5, "EmergeTimer", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp", nil, nil, 6)
local timerSubmerge				= mod:NewTimer(92, "SubmergeTimer", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp", nil, nil, 6)--Variable, 92-96

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 25740, "Ahune")
	if self:AntiSpam(4, 1) then
		timerSubmerge:Start(95-delay)--first is 95, rest are 92
	end
end

function mod:OnCombatEnd(delay)
	DBM:FireCustomEvent("DBM_EncounterEnd", 25740, "Ahune")
	timerCombatStart:Cancel()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 45954 and self:AntiSpam(4, 1) then -- Ahunes Shield
		warnEmerged:Show()
		timerSubmerge:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 45954 then -- Ahunes Shield
		warnSubmerged:Show()
		timerEmerge:Start()
		specWarnAttack:Show()
		specWarnAttack:Play("changetarget")
	end
end

function mod:CHAT_MSG_SAY(msg)
	if msg == L.Pull then
		timerCombatStart:Start()
		self:Schedule(10, DBM.StartCombat, DBM, self, 0)
	end
end