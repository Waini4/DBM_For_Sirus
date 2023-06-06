local mod		= DBM:NewMod("z861", "DBM-PvP", 2)
local L			= mod:GetLocalizedStrings()

mod:SetRevision("2023".."06".."05".."14".."00".."00")
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA",
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_BG_SYSTEM_ALLIANCE",
	"CHAT_MSG_BG_SYSTEM_HORDE",
	"CHAT_MSG_BG_SYSTEM_NEUTRAL",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)
mod:RemoveOption("HealthFrame")
local carts = {}
-- local ClearCartCache
local pairs, abs, sqrt, tremove = pairs, math.abs, math.sqrt, table.remove
local GetNumBattlefieldVehicles, GetBattlefieldVehicleInfo =  GetNumBattlefieldVehicles, GetBattlefieldVehicleInfo
local GetCurrentMapAreaID = GetCurrentMapAreaID
local bgzone = false
-- local tinsert = table.insert
local GetTime = GetTime
-- local cartCount	= 0
local lavaDown = true
local topDown = true
local cartRespawn = mod:NewTimer(14.5, "TimerRespawn", "Interface\\Icons\\INV_Misc_PocketWatch_01") -- interface/icons/inv_misc_pocketwatch_01.blp

local times = { 181, 234, 129, 97, 153 }
-- local caps = {
-- 	{ x = 22.848, y = 42.823 },    -- left down
-- 	{ x = 76.517, y = 21.757 },    -- left up
-- 	{ x = 41.281, y = 48.239 },    -- middle
-- 	{ x = 69.326, y = 70.632 },    -- lava down
-- 	{ x = 76.517, y = 21.757 },    -- lava up
-- }
local names = {
	L["Top - Down"],
	L["Top - Up"],
	L["Middle"],
	L["Lava - Down"],
	L["Lava - Up"]
}
local cartTimer	= mod:NewTimer(14.5, "TimerCart", "Interface\\Icons\\Spell_Frost_FrostShock") -- Interface\\icons\\spell_misc_hellifrepvphonorholdfavor.blp

local battleStart = false

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if not bgzone or not msg then
		return
	end
	if msg:find(L.Capture) then
		cartRespawn:Start(nil)
		self:ScheduleMethod(10, "UpdateCartsTime")
		-- self:ScheduleMethod(15, "UpdateCartsInfoMethod")
	elseif msg:find(L.Update1) or msg:find(L.Update2) then
		mod:UpdateCartsInfo()
	elseif msg:find(L.LavaChange) then
		lavaDown = not lavaDown
		mod:UpdateCarByIndex(3)
	elseif msg:find(L.TopChange) then
		topDown = not topDown
		mod:UpdateCarByIndex(1)
	elseif msg:find(L.BattleStart) then
		lavaDown = true
		topDown = true
		battleStart = true
		-- self:ScheduleMethod(5, "UpdateCartsInfoTicker")
		for i = 1,3 do
			local x, y,nameRu = GetBattlefieldVehicleInfo(i)
			if x and y then
				local index = string.match(nameRu,"1") and 1 or
				string.match(nameRu,"2") and 2 or
				string.match(nameRu,"3") and 3
				x = x * 100
				y = y * 100
				carts[index] = {
					dir = (index == 1 and 1) or
						(index == 2 and 3) or
						(index == 3 and 4),
					spawn	= GetTime(),
					x		= x,
					y		= y,
					c		= -1
				}
				if not cartTimer:IsStarted(names[carts[index].dir]) then -- Prevent duplicate cart timers.
					cartTimer:Start(carts[index].spawn + times[carts[index].dir] - GetTime(), names[carts[index].dir])
				end
			end
		end
	end
	-- mod:UPDATE_WORLD_STATES()
end

local function GetCartDirByIndex(index)
	if index == 1 then
		return topDown and 1 or 2
	elseif index == 2 then
		return 3
	elseif index == 3 then
		return lavaDown and 4 or 5
	end
end

function mod:UpdateCarByIndex(index)
	if not battleStart then return end
	local cart = carts[index]
	mod:UpdateCartsInfo()
	if not cartTimer:IsStarted(names[cart.dir]) then -- Prevent duplicate cart timers.
		if not cart.spawn then
			cart.spawn = GetTime()
		end
		cartTimer:Start(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
	else
		cartTimer:Stop(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
		cartTimer:Start(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
	end
end
function mod:UpdateCartsInfo()
	if not battleStart then return end
	for i = 1, GetNumBattlefieldVehicles() do
		local x, y, nameRu , _ , nameSide  =  GetBattlefieldVehicleInfo(i)
		if x and y and nameSide then
			local index = string.match(nameRu,"1") and 1 or
			string.match(nameRu,"2") and 2 or
			string.match(nameRu,"3") and 3
			x = x * 100
			y = y * 100
			if not carts[index] then
				carts[index] = {}
			end
			local cart = carts[index]
			cart.x = x
			cart.y = y
			-- cart.lastDir = cart.dir or 0
			cart.spawn = cart.spawn or GetTime()
			cart.dir = GetCartDirByIndex(index)
			cart.c = (nameSide:match("Red") and 0) or (nameSide:match("Blue") and 1) or -1
			local timername = names[cart.dir]
			if not cartTimer:IsStarted(timername) then -- Prevent duplicate cart timers.
				cartTimer:Start(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
			end
			if cart.c == 1 then
				cartTimer:SetColor({r=0, g=0, b=1}, timername) -- c == 1 == Blue
				cartTimer:UpdateIcon("Interface\\Icons\\INV_BannerPVP_02", timername) -- Interface\\Icons\\INV_BannerPVP_02.blp
			elseif cart.c == 0 then
				cartTimer:SetColor({r=1, g=0, b=0}, timername) -- c == 0 == red
				cartTimer:UpdateIcon("Interface\\Icons\\INV_BannerPVP_01", timername) -- Interface\\Icons\\INV_BannerPVP_01.blp
			else
				cartTimer:SetColor({r=128, g = 128, b=128})
				cartTimer:UpdateIcon("Interface\\Icons\\INV_BannerPVP_03", timername) -- Interface\\Icons\\INV_BannerPVP_03.blp
			end
		else

		end
	end
end

function mod:UpdateCartsInfoMethod()
	self:UnscheduleMethod("UpdateCartsInfoMethod")
	self:UpdateCartsInfo()

end

function mod:UpdateCartsInfoTicker()
	self:UpdateCartsInfo()
end

function mod:UpdateCartsTime()
	if not battleStart then return end
	self:UnscheduleMethod("UpdateCartsTime")
	local f,s,t = false, false, false
	for ic = 1, GetNumBattlefieldVehicles() do
		local x, y, nameRu , _ , nameSide  =  GetBattlefieldVehicleInfo(ic)
		if x and y and nameSide then
			local index = string.match(nameRu,"1") and 1 or
			string.match(nameRu,"2") and 2 or
			string.match(nameRu,"3") and 3
			if not f and index == 1 then
				f = true
			end
			if not s and index == 2 then
				s = true
			end
			if not t and index == 3 then
				t = true
			end
		end
	end
	if not f then
		carts[1].spawn = nil
		carts[1].x = -1
		carts[1].y = -1
		carts[1].c = -1
		cartTimer:Stop(names[carts[1].dir])
	end
	if not s then
		carts[2].spawn = nil
		carts[2].x = -1
		carts[2].y = -1
		carts[1].c = -1
		cartTimer:Stop(names[carts[2].dir])
	end
	if not t then
		carts[3].spawn = nil
		carts[3].x = -1
		carts[3].y = -1
		carts[3].c = -1
		cartTimer:Stop(names[carts[3].dir])
	end


end

mod.CHAT_MSG_SYSTEM = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_ALLIANCE = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_HORDE = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_NEUTRAL = mod.CHAT_MSG_RAID_BOSS_EMOTE

function mod:OnInitialize()

	if select(2, IsInInstance()) == "pvp" and GetCurrentMapAreaID() == 861 then
		bgzone = true
		mod.updFrame = mod.updFrame or CreateFrame("Frame")
		mod.updFrame.lastUpd = GetTime()
		mod.updFrame:SetScript("OnUpdate",function(self,elaps)
			if self.lastUpd - GetTime() + 5 < 0 then
				self.lastUpd = GetTime()
				if battleStart then
					mod:UpdateCartsInfoTicker()
				end
			end
		end)

	elseif bgzone then
		bgzone = false
		battleStart = false
		mod.updFrame:SetScript("OnUpdate",function()

		end)

	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	self:ScheduleMethod(1, "OnInitialize")
end




