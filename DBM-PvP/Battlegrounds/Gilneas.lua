local mod = DBM:NewMod("z916", "DBM-PvP", 2)
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20200405141240")
mod:SetZone(DBM_DISABLE_ZONE_DETECTION)

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA",
	"CHAT_MSG_BG_SYSTEM_HORDE",
	"CHAT_MSG_BG_SYSTEM_ALLIANCE",
	"CHAT_MSG_BG_SYSTEM_NEUTRAL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UPDATE_WORLD_STATES"
)
mod:RemoveOption("HealthFrame")

local winTimer = mod:NewTimer(30, "TimerWin", "Interface\\Icons\\INV_Misc_PocketWatch_01")
local capTimer = mod:NewTimer(63, "TimerCap", "Interface\\Icons\\Spell_Misc_HellifrePVPHonorHoldFavor")

local bgzone = false
mod:AddBoolOption("ShowGilneasBasesToWin", false, nil, function()
	if mod.Options.ShowGilneasBasesToWin and bgzone then
		mod:ShowBasesToWin()
	else
		mod:HideBasesToWin()
	end
end)

local ResPerSec = {
	[0] = 0,
	[1] = 1,
	[2] = 3,
	[3] = 30
}

local allyIcon = "IInterface\\Icons\\INV_BannerPVP_02.blp"
local allyColor = { r = 0, g = 0, b = 1 }
local hordeIcon = "Interface\\Icons\\INV_BannerPVP_01.blp"
local hordeColor = { r = 1, g = 0, b = 0 }

local objectives = {
	Lighthouse = 0,
	Mines = 0,
	Waterworks = 0
}

local function getObjectiveType(id)
	if id >= 6 and id <= 12 then return "Lighthouse"
	elseif id >= 16 and id <= 20 then return "Mines"
	elseif id >= 26 and id <= 30 then return "Waterworks"
	else return false
	end
end

local function getObjectiveState(id)
	if id == 11 or id == 18 or id == 28 then
		return 1 -- Alliance controlled
	elseif id == 10 or id == 20 or id == 30 then
		return 2 -- Horde controlled
	elseif id == 9 or id == 17 or id == 27 then
		return 3 -- Alliance assaulted
	elseif id == 12 or id == 19 or id == 29 then
		return 4 -- Horde assaulted
	else
		return false
	end
end

local function get_basecount()
	local alliance = 0
	local horde = 0
	for _, v in pairs(objectives) do
		if v == 11 or v == 18 or v == 28 then
			alliance = alliance + 1
		elseif v == 10 or v == 20 or v == 30 then
			horde = horde + 1
		end
	end
	return alliance, horde
end

local function get_score()
	if not bgzone then return 0, 0 end
	local AllyScore = tonumber(string.match((select(3, GetWorldStateUIInfo(1)) or ""), L.ScoreExpr)) or 0
	local HordeScore = tonumber(string.match((select(3, GetWorldStateUIInfo(2)) or ""), L.ScoreExpr)) or 0
	return AllyScore, HordeScore
end

local get_gametime
local update_gametime
do
	local gametime = 0
	function update_gametime()
		gametime = time()
	end

	function get_gametime()
		local systime = GetBattlefieldInstanceRunTime()
		if systime > 0 then
			return systime / 1000
		else
			return time() - gametime
		end
	end
end

local function Gilneas_Initialize()
	if select(2, IsInInstance()) == "pvp" and GetCurrentMapAreaID() == 916 then
		bgzone = true
		update_gametime()
		for i = 1, GetNumMapLandmarks(), 1 do
			local name, _, textureIndex = GetMapLandmarkInfo(i)
			if name and textureIndex then
				local objectiveType = getObjectiveType(textureIndex)
				if objectiveType then
					objectives[objectiveType] = textureIndex
				end
			end
		end
		if mod.Options.ShowGilneasBasesToWin then
			mod:ShowBasesToWin()
		end
	elseif bgzone then
		bgzone = false
		if mod.Options.ShowGilneasBasesToWin then
			mod:HideBasesToWin()
		end
	end
end

mod.OnInitialize = Gilneas_Initialize
mod.ZONE_CHANGED_NEW_AREA = Gilneas_Initialize

do
	local function check_for_updates()
		if not bgzone then return end
		for i = 1, GetNumMapLandmarks(), 1 do
			local name, _, textureIndex = GetMapLandmarkInfo(i)
			if name and textureIndex then
				local objectiveType = getObjectiveType(textureIndex) -- name of the objective without spaces
				local objectiveState = getObjectiveState(textureIndex) -- state of the objective
				if objectiveType and objectiveState and textureIndex ~= objectives[objectiveType] then
					capTimer:Stop(name)
					if objectiveState > 2 then
						capTimer:Start(nil, name)
						if objectiveState == 3 then
							capTimer:SetColor(allyColor, name)
							capTimer:UpdateIcon(allyIcon, name)
						else
							capTimer:SetColor(hordeColor, name)
							capTimer:UpdateIcon(hordeIcon, name)
						end
					end
					objectives[objectiveType] = textureIndex
				end
			end
		end
	end

	local function schedule_check(self)
		self:Schedule(1, check_for_updates)
	end

	mod.CHAT_MSG_BG_SYSTEM_ALLIANCE = schedule_check
	mod.CHAT_MSG_BG_SYSTEM_HORDE = schedule_check
	mod.CHAT_MSG_RAID_BOSS_EMOTE = schedule_check
	mod.CHAT_MSG_BG_SYSTEM_NEUTRAL = schedule_check
end

do
	local winner_is = 0 -- 0 = nobody 1 = alliance 2 = horde
	local last_horde_score = 0
	local last_alliance_score = 0
	local last_horde_bases = 0
	local last_alliance_bases = 0

	function mod:UPDATE_WORLD_STATES()
		if not bgzone then return end

		local AllyBases, HordeBases = get_basecount()
		local AllyScore, HordeScore = get_score()
		local callupdate = false

		if AllyScore ~= last_alliance_score then
			last_alliance_score = AllyScore
			if winner_is == 1 then
				callupdate = true
			end
		elseif HordeScore ~= last_horde_score then
			last_horde_score = HordeScore
			if winner_is == 2 then
				callupdate = true
			end
		end
		if last_alliance_bases ~= AllyBases then
			last_alliance_bases = AllyBases
			callupdate = true
		end
		if last_horde_bases ~= HordeBases then
			last_horde_bases = HordeBases
			callupdate = true
		end

		if callupdate then
			self:UpdateWinTimer()
		end
	end

	function mod:UpdateWinTimer()
		local AllyTime = (1500 - last_alliance_score) / ResPerSec[last_alliance_bases]
		local HordeTime = (1500 - last_horde_score) / ResPerSec[last_horde_bases]

		if AllyTime > 1500 then AllyTime = 1500 end
		if HordeTime > 1500 then HordeTime = 1500 end

		if AllyTime == HordeTime then
			winner_is = 0
			winTimer:Stop()
		elseif AllyTime > HordeTime then -- Horde wins
			winner_is = 2
			winTimer:Update(get_gametime(), get_gametime() + HordeTime)
			winTimer:DisableEnlarge()
			local AllyPoints = math.floor(math.floor(((HordeTime * ResPerSec[last_alliance_bases]) + last_alliance_score) / 10) *
				10)
			winTimer:UpdateName(L.WinBarText:format(AllyPoints, 1500))
			winTimer:SetColor(hordeColor)
			winTimer:UpdateIcon(hordeIcon)
		elseif HordeTime > AllyTime then -- Alliance wins
			winner_is = 1
			winTimer:Update(get_gametime(), get_gametime() + AllyTime)
			winTimer:DisableEnlarge()
			local HordePoints = math.floor(math.floor(((AllyTime * ResPerSec[last_horde_bases]) + last_horde_score) / 10) * 10)
			winTimer:UpdateName(L.WinBarText:format(1500, HordePoints))
			winTimer:SetColor(allyColor)
			winTimer:UpdateIcon(allyIcon)
		end

		if self.Options.ShowGilneasBasesToWin then
			local FriendlyLast, EnemyLast, FriendlyBases, EnemyBases, baseLowest
			if UnitFactionGroup("player") == "Alliance" then
				FriendlyLast = last_alliance_score
				EnemyLast = last_horde_score
				FriendlyBases = last_alliance_bases
				EnemyBases = last_horde_bases
			else
				FriendlyLast = last_horde_score
				EnemyLast = last_alliance_score
				FriendlyBases = last_horde_bases
				EnemyBases = last_alliance_bases
			end
			if ((1500 - FriendlyLast) / ResPerSec[FriendlyBases]) > ((1500 - EnemyLast) / ResPerSec[EnemyBases]) then
				for i = 1, 3 do
					local EnemyTime = (1500 - EnemyLast) / ResPerSec[3 - i]
					local FriendlyTime = (1500 - FriendlyLast) / ResPerSec[i]
					if (FriendlyTime < EnemyTime) then
						baseLowest = FriendlyTime
					else
						baseLowest = EnemyTime
					end

					local EnemyFinal = math.floor((EnemyLast + math.floor(baseLowest * ResPerSec[3 - i] + 0.5)) / 10) * 10
					local FriendlyFinal = math.floor((FriendlyLast + math.floor(baseLowest * ResPerSec[i] + 0.5)) / 10) * 10
					if (FriendlyFinal >= 1500 and EnemyFinal < 1500) then
						self.ScoreFrameToWinText:SetText(L.BasesToWin:format(i))
						break
					end
				end
			else
				self.ScoreFrameToWinText:SetText("")
			end
		end

	end
end

function mod:ShowBasesToWin()
	if AlwaysUpFrame1Text and AlwaysUpFrame2Text then
		if not self.ScoreFrameToWin then
			self.ScoreFrameToWin = CreateFrame("Frame", nil, AlwaysUpFrame2)
			self.ScoreFrameToWin:SetHeight(10)
			self.ScoreFrameToWin:SetWidth(200)
			self.ScoreFrameToWin:SetPoint("TOPLEFT", "AlwaysUpFrame2", "BOTTOMLEFT", 22, 2)
			self.ScoreFrameToWinText = self.ScoreFrameToWin:CreateFontString(nil, nil, "GameFontNormalSmall")
			self.ScoreFrameToWinText:SetAllPoints(self.ScoreFrameToWin)
			self.ScoreFrameToWinText:SetJustifyH("LEFT")
		end
		self.ScoreFrameToWinText:SetText("")
		self.ScoreFrameToWin:Show()
	end
end

function mod:HideBasesToWin()
	if self.ScoreFrameToWin then
		self.ScoreFrameToWin:Hide()
		self.ScoreFrameToWinText:SetText("")
	end
end
