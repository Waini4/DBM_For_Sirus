local mod = DBM:NewMod("HyjalWaveTimers", "DBM-Hyjal")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210605153940")
mod:SetUsedIcons(7, 8)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod:RegisterEvents(
	"GOSSIP_SHOW",
	"QUEST_PROGRESS",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"UPDATE_WORLD_STATES",
	"UNIT_TARGET",
	"SPELL_AURA_APPLIED 319232 319502 319503",
	"SPELL_AURA_REMOVED 319232 319502 319503",
	"COMBAT_LOG_EVENT_UNFILTERED"
-- "SWING_DAMAGE",
-- "SWING_MISSED"
)
mod.noStatistics            = true

local warnWave              = mod:NewAnnounce("WarnWave", 1)
local warnBrandofHorror     = mod:NewTargetNoFilterAnnounce(319502)
local warnCannibalize       = mod:NewSpellAnnounce(31538, 2)

local specWarnSlimeFinal    = mod:NewSpecialWarningMoveAway(319236, nil, nil, nil, 4, 2)
local specWarnBrandofHorror = mod:NewSpecialWarningMoveAway(319502, nil, nil, nil, 4, 2)
local specWarnSlime         = mod:NewSpecialWarningDodge(319230, nil, nil, nil, 1, 2)
local specWarnSlimeNear     = mod:NewSpecialWarningClose(319230, nil, nil, nil, 1, 2)
local yellSlime             = mod:NewYell(319230)
local yellBrandofHorror     = mod:NewYell(319502)
local yellBrandofHorrorFade = mod:NewShortFadesYell(319502)
-- local specWarnSuicide              = mod:NewSpecialWarningGTFO(319236, nil, nil, nil, 1, 5)

local timerWave             = mod:NewTimer(125, "TimerWave", nil, nil, nil, 1)

mod:AddSetIconOption("SetIconOnSlime", 319230, true, false, { 7, 8 })
mod:AddBoolOption("SetNecromancerIcon")
mod:AddBoolOption("DetailedWave")

local lastWave = 0
local boss = 0
local bossNames = {
	[0] = L.GeneralBoss,
	[1] = L.RageWinterchill,
	[2] = L.Anetheron,
	[3] = L.Kazrogal,
	[4] = L.Azgalor
}
mod.frameForPudge = CreateFrame("Frame", nil, UIParent)
mod.frameForPudge.Scan = false
mod.vb.NecromancerIcon = 6
mod.vb.IsEventsRegisterd = false

local NecrGuids = {}
local function ScanWhitName(name)
	local target
	for i = 1, GetNumRaidMembers() do
		local unit = "raid" .. i .. "target"
		local guid = UnitGUID(unit)
		if name == "Некромант" then
			if UnitName(unit) == name and guid and not NecrGuids[guid] then
				target = unit
				NecrGuids[guid] = true
				return target
			end
		end
	end
	return nil
end
-- local pudgeScan = false
function mod:Slime(targetname)
	if not targetname then return end
	if self.Options.SetIconOnSlime then
		self:SetIcon(targetname, 8, 5)
	end
	if targetname == UnitName("player") then
		specWarnSlime:Show()
		specWarnSlime:Play("runaway")
		yellSlime:Yell()
	elseif self:CheckNearby(10, targetname) then
		specWarnSlimeNear:Show(targetname)
		specWarnSlimeNear:Play("runaway")
	end
end

function mod:GOSSIP_SHOW()
	if GetRealZoneText() ~= L.HyjalZoneName then return end
	local target = UnitName("target")
	if target == L.Thrall or target == L.Jaina then
		local selection = GetGossipOptions()
		if selection == L.RageGossip then
			boss = 1
			self:SendSync("boss", 1)
			lastWave = 6
		elseif selection == L.AnetheronGossip then
			boss = 2
			self:SendSync("boss", 2)
			lastWave = 6
		elseif selection == L.KazrogalGossip then
			boss = 3
			self:SendSync("boss", 3)
			lastWave = 6
		elseif selection == L.AzgalorGossip then
			boss = 4
			self:SendSync("boss", 4)
			lastWave = 6
		end
	end
end

mod.QUEST_PROGRESS = mod.GOSSIP_SHOW

function mod:UPDATE_WORLD_STATES()
	local text = select(3, GetWorldStateUIInfo(4))
	if not text then return end
	local currentWave = text:match(L.WaveCheck)
	if not currentWave then
		currentWave = 0
	end
	self:WaveFunction(currentWave)
end

function mod:OnSync(msg, arg)
	if msg == "boss" then
		boss = tonumber(arg)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 17852 or cid == 17772 then
		lastWave = 0
		timerWave:Cancel()
	elseif cid == 17767 then
		self:SendSync("boss", 2)
	elseif cid == 17808 then
		self:SendSync("boss", 3)
	elseif cid == 17888 then
		self:SendSync("boss", 4)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 31538 then
		warnCannibalize:Show()
	elseif args:IsSpellID(319502, 319503) then
		warnBrandofHorror:Show(args.destName)
		if args:IsPlayer() then
			specWarnBrandofHorror:Show()
			yellBrandofHorror:Yell()
			yellBrandofHorrorFade:Countdown(319502)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(319232) then
		self:BossTargetScanner(50640, "Slime", 0.05, 6)
	elseif args:IsSpellID(319502, 319503) then
	elseif args:IsPlayer() then
		yellBrandofHorrorFade:Cancel()
	end
end

function mod:WaveFunction(currentWave)
	local timer = 0
	currentWave = tonumber(currentWave)
	if currentWave > lastWave then
		table.wipe(NecrGuids)
		if boss == 0 then --unconfirmed or firs for trash
			timer = 125
			if self.Options.DetailedWave and boss == 0 then
				if currentWave == 1 then --
					self.frameForPudge.Scan = false
					warnWave:Show(L.WarnWave_2:format(currentWave, 5, L.Ghoul, 2, L.Necromancer))
				elseif currentWave == 2 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 5, L.Ghoul, 2, L.Fiend, 2, L.Necromancer))
				elseif currentWave == 3 then
					self.frameForPudge.Scan = true
					warnWave:Show(L.WarnWave_3:format(currentWave, 2, L.Fiend, 2, L.Necromancer, 1, L.Pudge1))
				elseif currentWave == 4 then
					self.frameForPudge.Scan = false
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Fiend, 2, L.Necromancer, 1, L.Pudge2))
				elseif currentWave == 5 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Fiend, 3, L.Necromancer, 1, L.Pudge2))
				end
			end
			-- if boss == 0 or boss == 1 or boss == 2 then
		elseif boss == 1 or boss == 2 then
			timer = 180
			if currentWave == 5 then
				timer = 210
			end
			if self.Options.DetailedWave and (boss == 1 or boss == 0) then
				if currentWave == 1 then
					self.frameForPudge.Scan = false
					warnWave:Show(L.WarnWave_2:format(currentWave, 5, L.Ghoul, 2, L.Necromancer))
				elseif currentWave == 2 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 5, L.Ghoul, 2, L.Fiend, 2, L.Necromancer))
				elseif currentWave == 3 then
					self.frameForPudge.Scan = true
					warnWave:Show(L.WarnWave_3:format(currentWave, 2, L.Fiend, 2, L.Necromancer, 1, L.Pudge1))
				elseif currentWave == 4 then
					self.frameForPudge.Scan = false
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Fiend, 2, L.Necromancer, 1, L.Pudge2))
				elseif currentWave == 5 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Fiend, 3, L.Necromancer, 1, L.Pudge2))
				end
			elseif self.Options.DetailedWave and boss == 2 then
				if currentWave == 1 then
					warnWave:Show(L.WarnWave_1:format(currentWave, 10, L.Ghoul))
				elseif currentWave == 2 then
					warnWave:Show(L.WarnWave_2:format(currentWave, 8, L.Ghoul, 4, L.Abomination))
				elseif currentWave == 3 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Ghoul, 4, L.Fiend, 4, L.Necromancer))
				elseif currentWave == 4 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 6, L.Fiend, 4, L.Necromancer, 2, L.Banshee))
				elseif currentWave == 5 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 6, L.Ghoul, 4, L.Banshee, 2, L.Necromancer))
				end
				-- else
				-- 	warnWave:Show(L.WarnWave_0:format(currentWave))
			end
			self:SendSync("boss", boss)
		elseif boss == 3 or boss == 4 then
			timer = 135
			if currentWave == 2 or currentWave == 4 then
				timer = 165
			elseif currentWave == 3 then
				timer = 160
			end
			if self.Options.DetailedWave and boss == 3 then
				if currentWave == 1 then
					warnWave:Show(L.WarnWave_4:format(currentWave, 4, L.Ghoul, 4, L.Abomination, 2, L.Necromancer, 2,
						L.Banshee))
				elseif currentWave == 2 then
					warnWave:Show(L.WarnWave_2:format(currentWave, 4, L.Ghoul, 10, L.Gargoyle))
				elseif currentWave == 3 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 6, L.Ghoul, 6, L.Fiend, 2, L.Necromancer))
				elseif currentWave == 4 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 6, L.Fiend, 2, L.Necromancer, 6, L.Gargoyle))
				elseif currentWave == 5 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Ghoul, 6, L.Abomination, 4, L.Necromancer))
				end
			elseif self.Options.DetailedWave and boss == 4 then
				if currentWave == 1 then
					warnWave:Show(L.WarnWave_2:format(currentWave, 6, L.Abomination, 6, L.Necromancer))
				elseif currentWave == 2 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 5, L.Ghoul, 8, L.Gargoyle, 1, L.Wyrm))
				elseif currentWave == 3 then
					warnWave:Show(L.WarnWave_2:format(currentWave, 6, L.Ghoul, 8, L.Infernal))
				elseif currentWave == 4 then
					warnWave:Show(L.WarnWave_2:format(currentWave, 6, L.Stalker, 8, L.Infernal))
				elseif currentWave == 5 then
					warnWave:Show(L.WarnWave_3:format(currentWave, 4, L.Abomination, 4, L.Necromancer, 6, L.Stalker))
				end
				-- 	else
				-- 		warnWave:Show(L.WarnWave_0:format(currentWave))
			end
			self:SendSync("boss", boss)
		end
		timerWave:Start(timer)
		lastWave = currentWave
		-- elseif lastWave > currentWave then
		-- 	if lastWave == 5 then
		-- 		warnWave:Show(bossNames[boss])
		-- 	end
		-- 	timerWave:Cancel()
		-- 	lastWave = currentWave
		-- elseif UnitIsDeadOrGhost("player") then
		-- 	timerWave:Cancel()
	end
end

function mod:UNIT_TARGET()
	if self.Options.SetNecromancerIcon then
		local uid = ScanWhitName("Некромант")
		if uid then
			self:SetIcon(uid, self.vb.NecromancerIcon)
			mod.vb.NecromancerIcon = mod.vb.NecromancerIcon - 1
			if mod.vb.NecromancerIcon < 4 then
				mod.vb.NecromancerIcon = 6
			end
		end
	end
end

local upd = 0

mod.frameForPudge:Show()
mod.frameForPudge:SetScript("OnUpdate", function(self, up)
	if self.Scan then
		upd = upd + up
		if upd > 0.7 then
			for i = 1, GetNumRaidMembers() do
				local unit = "raid" .. i .. "target"
				local name = UnitName(unit)
				if name == L.Pudge1 then
					-- if UnitName(unit) == name then
					local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
					if hp and hp > 1 and hp < 15 then
						if mod:AntiSpam(3, 1) then
							specWarnSlimeFinal:Show()
						end
					end
					-- end
				end
			end
			upd = 0
		end
	end
end)
-- function mod:SWING_DAMAGE(sourceGUID, sourceName, sourceFlags, destGUID, destName)
-- 	-- if self:GetCIDFromGUID(destGUID) == 3410 and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 then
-- 	if destName == "Изрыгатель слизи" then
-- 	-- if self:GetCIDFromGUID(destGUID) == 50640 and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and self:IsInCombat() then
-- 	-- if sourceGUID ~= UnitGUID("player") then
-- 		local uid = ScanWhitName("Изрыгатель слизи")
-- 		if uid then
-- 			local hp = UnitHealth(uid) / UnitHealthMax(uid) * 100
-- 			if hp and hp < 25 then
-- 				print("da3")
-- 				Suicide(UnitName(uid))
-- 			end
-- 		end
-- 	end
-- 		-- end
-- 	-- end
-- 	-- end
-- end

-- mod.SWING_MISSED = mod.SWING_DAMAGE
