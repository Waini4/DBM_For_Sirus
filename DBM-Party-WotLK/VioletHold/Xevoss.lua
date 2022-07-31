local mod	= DBM:NewMod("Xevoss", "DBM-Party-WotLK", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(29266)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)
mod:RegisterEventsInCombat(
)

local CombatTimer		= mod:NewCombatTimer(11)

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.XevossPull or msg:find(L.XevossPull) then	--[CHAT_MSG_MONSTER_YELL] Снова в деле! Так, подумаем о путях отхода.:Ксевозз:::::0:0::0:1655::0:", -- [2664]
        self:SendSync("XevossPull")
    end
end

function mod:OnSync(msg)
	if msg == "XevossPull" then
		CombatTimer:Start()
	end
end