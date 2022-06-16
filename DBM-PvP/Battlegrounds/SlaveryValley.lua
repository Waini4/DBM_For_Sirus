local mod		= DBM:NewMod("z611", "DBM-PvP", 2)
local L			= mod:GetLocalizedStrings()

mod:SetRevision("20200405141240")
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA",
	"CHAT_MSG_BG_SYSTEM_NEUTRAL",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)
mod:RemoveOption("HealthFrame")

local poi = {}

local allyTowerIcon = "Interface\\AddOns\\DBM-PvP\\Textures\\GuardTower"
local allyColor = {r = 0, g = 0, b = 1}
local hordeTowerIcon = "Interface\\AddOns\\DBM-PvP\\Textures\\OrcTower"
local hordeColor = {r = 1, g = 0, b = 0}

local POITimer		= mod:NewTimer(60, "TimerPOI", "Interface\\Icons\\Spell_Misc_HellifrePVPHonorHoldFavor")

local function isInArgs(val, ...) -- search for val in all args (...)
	for i = 1, select("#", ...), 1 do
		local v = select(i,  ...)
		if v == val then
			return true
		end
	end
	return false
end

local function getPoiState(id)
	if isInArgs(id, 11, 15, 18) then return 1 -- alliance
	elseif isInArgs(id, 10, 13, 20) then return 2 -- horde
	elseif isInArgs(id, 6, 8, 16) then return 3 -- if getPoiState(id) == 3 then --- untaken
	elseif isInArgs(id, 9, 4, 17) then return 4 -- if getPoiState(id) == 4 then --- alliance takes
	elseif isInArgs(id, 12, 14, 19) then return 5 -- if getPoiState(id) == 5 then --- horde takes
	else return 0
	end
end

local bgzone = false
function mod:OnInitialize()
	if select(2, IsInInstance()) == "pvp" and GetCurrentMapAreaID() == 611 then
		bgzone = true
		for i = 1, GetNumMapLandmarks(), 1 do
			local name, _, textureIndex = GetMapLandmarkInfo(i)
			if name and textureIndex then
				poi[i] = textureIndex
			end
		end
	elseif bgzone then
		bgzone = false
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	self:ScheduleMethod(1, "OnInitialize")
end

local function checkForUpdates()
	if not bgzone then return end
	for k, v in pairs(poi) do
		local name, _, textureIndex = GetMapLandmarkInfo(k)
		if name and textureIndex then
			-- new state vs old state
			if getPoiState(v) <= 3 and getPoiState(textureIndex) > 3 then
				-- poi is now in conflict, we have to start a bar :)
				POITimer:Start(nil, name)
				if getPoiState(textureIndex) == 4 then -- alliance takes
					POITimer:SetColor(allyColor, name)
					POITimer:UpdateIcon(allyTowerIcon, name)
				else
					POITimer:SetColor(hordeColor, name)
					POITimer:UpdateIcon(hordeTowerIcon, name)
				end
			elseif getPoiState(textureIndex) <= 2 then
				-- poi is now longer in conflict, remove the bars
				POITimer:Stop(name)
			end
			poi[k] = textureIndex
		end
	end
end

local function scheduleCheck(self)
	self:Schedule(1, checkForUpdates)
end

function mod:CHAT_MSG_BG_SYSTEM_NEUTRAL(msg)
	if not bgzone then return end
	scheduleCheck(self)
end