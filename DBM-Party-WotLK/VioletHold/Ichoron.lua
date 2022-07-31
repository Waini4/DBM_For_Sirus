local mod	= DBM:NewMod("Ichoron", "DBM-Party-WotLK", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(29313)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)
mod:RegisterEventsInCombat(
)

local CombatTimer		= mod:NewCombatTimer(17)

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.IchoronPull or msg:find(L.IchoronPull) then	--[CHAT_MSG_MONSTER_YELL] Я... сама... ярость!:Гнойрон:::::0:0::0:1541::0:", -- [940]
        self:SendSync("IchoronPull")
    end
end

function mod:OnSync(msg)
	if msg == "IchoronPull" then
		CombatTimer:Start()
	end
end