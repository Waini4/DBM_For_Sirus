local mod		= DBM:NewMod("z861", "DBM-PvP", 2)
local L			= mod:GetLocalizedStrings()

mod:SetRevision("20200405141240")
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA",
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_BG_SYSTEM_NEUTRAL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UPDATE_WORLD_STATES"
)
mod:RemoveOption("HealthFrame")

local locale = GetLocale()

local cartTimer		= mod:NewTimer(14.5, "TimerCart", "Interface\\Icons\\INV_Misc_PocketWatch_01")

local bgzone = false
local cartCount = 0

function mod:OnInitialize()
	if select(2, IsInInstance()) == "pvp" and GetCurrentMapAreaID() == 861 then
		bgzone = true
		cartCount = 0
	elseif bgzone then
		bgzone = false
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	self:ScheduleMethod(1, "OnInitialize")
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if not bgzone then return end
	if msg:find(L.Capture) or (locale == "ruRU" and msg:find(L.Capture2)) then
		cartCount = cartCount + 1
		cartTimer:Start(nil, cartCount)
	end
end

mod.CHAT_MSG_SYSTEM = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_NEUTRAL = mod.CHAT_MSG_RAID_BOSS_EMOTE