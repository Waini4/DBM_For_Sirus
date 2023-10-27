-- local ipairs = ipairs
-- local pairs = pairs
-- local ceil, floor = math.ceil, math.floor

-- local GetInstanceInfo = GetInstanceInfo
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers

-- function tIndexOf(tbl, item)
-- 	for i, v in ipairs(tbl) do
-- 		if item == v then
-- 			return i;
-- 		end
-- 	end
-- end
function GetRealmNumber()
	local serverName = GetCVar("realmName")
	local playerRealm = serverName:match("x4") and 4 or
						serverName:match("x5") and 5 or
						serverName:match("x2") and 2 or
						serverName:match("x1") and 1
	return playerRealm
end

-- local debug = false
if not _G.CHAT_SPAM_CHARNOTFOUND then
    _G.CHAT_SPAM_CHARNOTFOUND = true
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg, ...) return msg:match('Персонаж по имени "([^_]+)" в игре не найден') end)
end

function IsInGroup()
	return GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0
end

function IsInRaid()
	return GetNumRaidMembers() > 0
end

function GetNumSubgroupMembers()
	return GetNumPartyMembers()
end

function GetNumGroupMembers()
	return IsInRaid() and GetNumRaidMembers() or GetNumPartyMembers()
end