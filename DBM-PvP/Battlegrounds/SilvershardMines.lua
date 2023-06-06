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
local caps = {
	{ x = 22.848, y = 42.823 },    -- top down
	{ x = 76.517, y = 21.757 },    -- top up
	{ x = 41.281, y = 48.239 },    -- middle
	{ x = 69.326, y = 70.632 },    -- lava down
	{ x = 76.517, y = 21.757 },    -- lava up
}
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
	-- print(msg)
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
mod.CHAT_MSG_SYSTEM = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_ALLIANCE = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_HORDE = mod.CHAT_MSG_RAID_BOSS_EMOTE
mod.CHAT_MSG_BG_SYSTEM_NEUTRAL = mod.CHAT_MSG_RAID_BOSS_EMOTE



local function IsValidUpdate(dir1, dir2)
	if dir1 == 0 or dir2 == 0 then
		return false
	end
	if dir1 == dir2 then
		return true
	elseif dir1 == 3 or dir2 == 3 then
		return false
	elseif abs(dir1 - dir2) == 1 then
		return true
	end
	return false
end

local function GetDistance(x1, y1, x2, y2)
	return sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- function ClearCartCache()
-- 	local time = GetTime()
-- 	for i, cart in pairs(carts) do
-- 		if cart.dir ~= 0 and times[cart.dir] + cart.spawn + 2 > time then
-- 			if GetDistance(cart.x, cart.y, caps[cart.dir].x, caps[cart.dir].y) < 3 then
-- 				cartTimer:Stop(names[cart.dir])
-- 				tremove(carts, i)
-- 			end
-- 		end
-- 	end
-- end

-- local function PointToLineDist(a, b, x, y)
-- 	return (a * x + b - y) / (sqrt(a ^ 2 + 1))
-- end

-- local function IdentifyCartCoord(x, y)
-- 	local dist1, dist2, dist3, dist4 = PointToLineDist(-2.126, -168.449, x, y), PointToLineDist(-0.513, 76.476, x, y), PointToLineDist(-0.555, 64.673, x, y), PointToLineDist(0.952, -12.176, x, y)
-- 	if dist1 < 0 and dist3 < 0 then
-- 		return dist4 > 0 and 5 or 4 -- Lava Up / Down
-- 	elseif dist1 > 0 and dist3 < 0 and dist2 < 0 then
-- 		return 3 -- Middle
-- 	elseif dist2 > 0 and (dist1 > 0 or dist3 > 0) then
-- 		return dist4 > 0 and 2 or 1 -- Top Up / Down
-- 	end
-- end

-- local function IdentifyCart(cartNum)
-- 	local cart = carts[cartNum]
-- 	if not cart then
-- 		return
-- 	end
-- 	local closestID, distance = 0, 1000
-- 	for d = 1, GetNumBattlefieldVehicles() do
-- 		local x, y = GetBattlefieldVehicleInfo(d)
-- 		x = x * 100
-- 		y = y * 100
-- 		local dist = GetDistance(56.87, 47.117, x, y)
-- 		if dist < distance then
-- 			local used = false
-- 			for _, v in pairs(carts) do
-- 				if GetDistance(x, y, v.x, v.y) < 2 then
-- 					used = true
-- 					break
-- 				end
-- 			end
-- 			if not used then
-- 				closestID = d
-- 				distance = dist
-- 			end
-- 		end
-- 	end
-- 	if closestID ~= 0 then
-- 		local x, y = GetBattlefieldVehicleInfo(closestID)
-- 		cart.x		= x * 100
-- 		cart.y		= y * 100
-- 		cart.dir	= IdentifyCartCoord(cart.x, cart.y)
-- 	end
-- end
-- local cache = {}
-- function mod:UPDATE_WORLD_STATES()
-- 	if not bgzone then return end
-- 	table.wipe(cache)
-- 	for i = 1, GetNumBattlefieldVehicles() do
-- 		local x, y, nameRu , _ , name  =  GetBattlefieldVehicleInfo(i)
-- 		if x and y and name then
-- 			local index = string.match(nameRu,"1") and 1 or
-- 			string.match(nameRu,"2") and 2 or
-- 			string.match(nameRu,"3") and 3
-- 				x = x * 100
-- 				y = y * 100
-- 				cache[index] = {
-- 					x	= x,
-- 					y	= y,
-- 					spawn = GetTime(),
-- 					dir	= IdentifyCartCoord(x, y),
-- 					c	= (name:match("Red") and 0) or (name:match("Blue") and 1) or -1
-- 				}
-- 		else

-- 		end

-- 	end
-- 	local time = GetTime()
-- 	local prune = #cache < #carts
-- 	for _, newCart in pairs(cache) do
-- 		for i, cart in pairs(carts) do
-- 			if (cart.x == -1 or cart.y == -1) and cart.spawn + 1 < time then
-- 				IdentifyCart(i)
-- 				-- print(225,cartTimer:IsStarted(names[cart.dir]),names[cart.dir])
-- 				if not cartTimer:IsStarted(names[cart.dir]) then -- Prevent duplicate cart timers.
-- 					cartTimer:Start(cart.spawn + times[cart.dir] - time, names[cart.dir])
-- 				end
-- 			elseif GetDistance(newCart.x, newCart.y, cart.x, cart.y) < 1 and IsValidUpdate(cart.dir, newCart.dir) then
-- 				if newCart.c ~= cart.c then
-- 					local name = names[cart.dir]
-- 					-- print(232,cartTimer:IsStarted(names[cart.dir]),names[cart.dir])
-- 					if newCart.c == 1 then
-- 						cartTimer:SetColor({r=0, g=0, b=1}, name) -- c == 1 == Blue
-- 						cartTimer:UpdateIcon("Interface\\Icons\\INV_BannerPVP_02", name) -- Interface\\Icons\\INV_BannerPVP_02.blp
-- 					elseif newCart.c == 0 then
-- 						cartTimer:SetColor({r=1, g=0, b=0}, name) -- c == 0 == red
-- 						cartTimer:UpdateIcon("Interface\\Icons\\INV_BannerPVP_01", name) -- Interface\\Icons\\INV_BannerPVP_01.blp
-- 					else
-- 						cartTimer:SetColor({r=128, g = 128, b=128})
-- 						cartTimer:UpdateIcon("Interface\\Icons\\INV_BannerPVP_03", name) -- Interface\\Icons\\INV_BannerPVP_03.blp
-- 					end
-- 				end
-- 				cart.dir	= newCart.dir
-- 				cart.x		= newCart.x
-- 				cart.y		= newCart.y
-- 				cart.c		= newCart.c
-- 			elseif prune and (cart.spawn + times[cart.dir] - time < -1) then
-- 				carts[i] = nil
-- 			end
-- 		end
-- 	end
-- end
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
	local cart = carts[index]
	if not cart.spawn then
		cart.spawn = GetTime()
	end
	mod:UpdateCartsInfo()
	if not cartTimer:IsStarted(names[cart.dir]) then -- Prevent duplicate cart timers.

		cartTimer:Start(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
	else
		cartTimer:Stop(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
		cartTimer:Start(cart.spawn + times[cart.dir] - GetTime(), names[cart.dir])
	end
end
function mod:UpdateCartsInfo()
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
	-- self:UnscheduleMethod("UpdateCartsInfoTicker")
end

function mod:UpdateCartsTime()
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
		-- cartCount = 0
	elseif bgzone then
		bgzone = false
		battleStart = false
		mod.updFrame:SetScript("OnUpdate",function()

		end)
		-- self:UnscheduleMethod("UpdateCartsInfoTicker")
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	self:ScheduleMethod(1, "OnInitialize")
end




