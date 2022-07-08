local mod = DBM:NewMod("Mimiron", "DBM-Ulduar")
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision("20210625164000")

mod:SetCreatureID(33670, 33651, 33432)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("yell", L.YellPull)
mod:RegisterCombat("yell", L.YellHardPull)
mod:RegisterKill("yell", L.YellKilled)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_LOOT"
)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 63631 312439 312792 64529 62997 312437 312790 64570 312434 312787 64623",
	"SPELL_CAST_SUCCESS 63027 63667 63016 312789 63414 312794 312441 65192 312440 312793 63041 64402 64064 63681 63036 65034"
	,
	"SPELL_AURA_APPLIED 63666 65026 312347 312435 312700 312788 63041 64402 64064 63681 63036 65034 64529 62997 312437 312790"
	,
	"SPELL_AURA_REMOVED 63666 65026 312347 312435 312700 312788",
	"UNIT_SPELLCAST_CHANNEL_STOP",
	"UNIT_SPELLCAST_SUCCEEDED 34098 64402 65034"
)


local blastWarn     = mod:NewTargetAnnounce(312790, 4)
local shellWarn     = mod:NewTargetAnnounce(312788, 2)
local lootannounce  = mod:NewAnnounce("MagneticCore", 1)
local warnBombSpawn = mod:NewAnnounce("WarnBombSpawn", 3)
--local warnFrostBomb				= mod:NewSpellAnnounce(64623, 3)

local warnShockBlast   = mod:NewSpecialWarningRun(63631, "Melee", nil, nil, 4, 2)
local warnRocketStrike = mod:NewSpecialWarningDodge(64402, nil, nil, nil, 2, 2)
local warnDarkGlare    = mod:NewSpecialWarningDodge(63293, nil, nil, nil, 4, 2)
local warnPlasmaBlast  = mod:NewSpecialWarningDefensive(64529, nil, nil, nil, 1, 2)
local warnFrostBomb    = mod:NewSpecialWarningDodge(64623, nil, nil, nil, 2, 2)

local enrage                    = mod:NewBerserkTimer(900)
local timerHardmode             = mod:NewTimer(610, "TimerHardmode", 312812)
local timerP1toP2               = mod:NewTimer(41, "TimeToPhase2", 312813, nil, nil, 6)
local timerP2toP3               = mod:NewTimer(22, "TimeToPhase3", 312813, nil, nil, 6)
local timerP3toP4               = mod:NewTimer(27, "TimeToPhase4", 312813, nil, nil, 6)
local timerProximityMines       = mod:NewNextTimer(12.5, 312789, nil, "Melee", nil, 3)
local timerShockBlast           = mod:NewCastTimer(4, 312792, nil, nil, nil, 2, nil, CL.DEADLY_ICON)
local timerShockBlastCD         = mod:NewCDTimer(40, 312792, nil, nil, nil, 2, nil, CL.DEADLY_ICON)
local timerNextRockets          = mod:NewNextTimer(20, 63041, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local timerSpinUp               = mod:NewCastTimer(4, 312794, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local timerRocketStrikeCD       = mod:NewCDTimer(20, 63631, nil, nil, nil, 3)
local timerDarkGlareCast        = mod:NewCastTimer(10, 63274, nil, nil, nil, 3, nil, CL.DEADLY_ICON)
local timerNextDarkGlare        = mod:NewNextTimer(37, 63274, nil, nil, nil, 3, nil, CL.DEADLY_ICON) -- Лазерный обстрел P3Wx2
local timerNextShockblast       = mod:NewNextTimer(34, 312792, nil, nil, nil, 2, nil, CL.DEADLY_ICON)
local timerPlasmaBlastCD        = mod:NewCDTimer(30, 312790, nil, nil, 2, 5, nil, CL.TANK_ICON)
local timerShell                = mod:NewTargetTimer(6, 312788, nil, "Healer", 2, 5, nil, CL.HEALER_ICON)
local timerFlameSuppressant     = mod:NewCastTimer(71, 312793, nil, nil, nil, 3)
local timerNextFlameSuppressant = mod:NewNextTimer(10, 312793, nil, "Melee", nil, 3)
local timerNextFlames           = mod:NewNextTimer(28, 312803, nil, nil, nil, 3)
local timerNextFrostBomb        = mod:NewNextTimer(60, 64623, nil, nil, nil, 3, nil, CL.HEROIC_ICON) --Ледяная бомба
local timerBombExplosion        = mod:NewCastTimer(17, 312804, nil, nil, nil, 3)
local timerBombBotSpawn         = mod:NewCDTimer(15, 63811, nil, nil, nil, 2)
--local timerVolleyCD		        = mod:NewCDTimer(20, 63041)



mod:AddSetIconOption("SetIconOnNapalm", 65026, false, false, { 1, 2, 3, 4, 5, 6, 7 })
mod:AddSetIconOption("SetIconOnPlasmaBlast", 64529, false, false, { 8 })
mod:AddRangeFrameOption("6")
mod:AddBoolOption("HealthFramePhase4", true)
mod:AddBoolOption("AutoChangeLootToFFA", true)
mod:AddBoolOption("RangeFrame")

mod.vb.hardmode = false
mod.vb.phase = 0
local napalmShellIcon = 7
local lootmethod, masterlooterRaidID
local spinningUp = DBM:GetSpellInfo(312794)
local lastSpinUp = 0
local is_spinningUp = false
local napalmShellTargets = {}

local function warnNapalmShellTargets(self)
	shellWarn:Show(table.concat(napalmShellTargets, "<, >"))
	table.wipe(napalmShellTargets)
	napalmShellIcon = 7
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33670, "Mimiron")
	self.vb.phase = 0
	self.vb.hardmode = false
	enrage:Start(-delay)
	self:NextPhase()
	is_spinningUp = false
	napalmShellIcon = 7
	table.wipe(napalmShellTargets)
	timerPlasmaBlastCD:Start(-delay)
	timerShockBlastCD:Start(28 - delay)
	timerProximityMines:Start()
	self:ScheduleMethod(12.5, "Mine")

	if DBM:GetRaidRank() == 2 then
		lootmethod, masterlooterRaidID = GetLootMethod()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(6)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 33670, "Mimiron", wipe)
	DBM.BossHealth:Hide()
	timerBombBotSpawn:Cancel()
	self:UnscheduleMethod("BombBot")
	self:UnscheduleMethod("Flames")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
		if masterlooterRaidID then
			SetLootMethod(lootmethod, "raid" .. masterlooterRaidID)
		else
			SetLootMethod(lootmethod)
		end
	end
end

function mod:Flames()
	timerNextFlames:Start()
	self:ScheduleMethod(28, "Flames")
end

function mod:BombBot() -- Bomb Bot
	if self.vb.phase == 3 then
		timerBombBotSpawn:Start(12)
		self:ScheduleMethod(12, "BombBot")
	end
end

function mod:Mine()
	if self.vb.phase == 4 or self.vb.phase == 1 then
		timerProximityMines:Start(38)
		self:ScheduleMethod(35, "Mine")
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP(unit, spell)
	if spell == spinningUp and GetTime() - lastSpinUp < 3.9 then
		is_spinningUp = false
		self:SendSync("SpinUpFail")
	end
end

function mod:CHAT_MSG_LOOT(msg)
	local player, itemID = msg:match(L.LootMsg)
	if player and itemID and tonumber(itemID) == 46029 and self:IsInCombat() then
		lootannounce:Show(player)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(63631, 312439, 312792) then
		warnShockBlast:Show()
		warnShockBlast:Play("runout")
		timerShockBlast:Start()
		timerNextShockblast:Start()
	elseif args:IsSpellID(64529, 62997, 312437, 312790) then -- plasma blast
		timerPlasmaBlastCD:Start()
		local tanking, status = UnitDetailedThreatSituation("player", "boss1") --Change boss unitID if it's not boss 1
		if tanking or (status == 3) then
			warnPlasmaBlast:Show()
			warnPlasmaBlast:Play("defensive")
		end
	elseif args:IsSpellID(64570, 312434, 312787) then
		timerFlameSuppressant:Start()
	elseif args:IsSpellID(64623) then
		warnFrostBomb:Show()
		timerBombExplosion:Start()
		timerNextFrostBomb:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(63666, 65026, 312347, 312435, 312700, 312788) and args:IsDestTypePlayer() then -- Napalm Shell
		napalmShellTargets[#napalmShellTargets + 1] = args.destName
		timerShell:Start()
		if self.Options.SetIconOnNapalm then
			self:SetIcon(args.destName, napalmShellIcon, 6)
		end
		napalmShellIcon = napalmShellIcon - 1
		self:Unschedule(warnNapalmShellTargets)
		self:Schedule(0.3, warnNapalmShellTargets)
	elseif args:IsSpellID(63041, 64402, 64064, 63681, 63036, 65034) then
		timerNextRockets:Start()
	elseif args:IsSpellID(64529, 62997, 312437, 312790) then -- Plasma Blast
		blastWarn:Show(args.destName)
		if self.Options.SetIconOnPlasmaBlast then
			self:SetIcon(args.destName, 8, 6)
		end
	end
end

local function show_warning_for_spinup(self)
	if is_spinningUp then
		warnDarkGlare:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(63027, 63667, 63016, 312789) then -- mines
		timerProximityMines:Start()
	elseif args:IsSpellID(63414, 312794, 312441) then -- Spinning UP (before Dark Glare)
		is_spinningUp = true
		timerSpinUp:Start()
		timerDarkGlareCast:Schedule(4)
		timerNextDarkGlare:Schedule(19) -- 4 (cast spinup) + 15 sec (cast dark glare)
		DBM:Schedule(0.15, show_warning_for_spinup) -- wait 0.15 and then announce it, otherwise it will sometimes fail
		lastSpinUp = GetTime()
	elseif args:IsSpellID(65192, 312440, 312793) then
		timerNextFlameSuppressant:Start()
	elseif args:IsSpellID(63041, 64402, 64064, 63681, 63036, 65034) then
		timerNextRockets:Start()
	end
end

function mod:NextPhase()
	self:SetStage(0)
	if self.vb.phase == 1 then
		if self.Options.HealthFrame then
			DBM.BossHealth:Clear()
			DBM.BossHealth:AddBoss(33432, L.MobPhase1)
		end
	elseif self.vb.phase == 2 then
		timerNextShockblast:Stop()
		timerFlameSuppressant:Stop()
		timerP1toP2:Start()
		timerProximityMines:Stop()
		self:UnscheduleMethod("Mine")
		timerNextDarkGlare:Start(75)
		if self.Options.HealthFrame then
			DBM.BossHealth:Clear()
			DBM.BossHealth:AddBoss(33651, L.MobPhase2)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.vb.hardmode then
			timerNextFrostBomb:Start(76)
		end
	elseif self.vb.phase == 3 then
		if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
			SetLootMethod("freeforall")
		end
		timerDarkGlareCast:Cancel()
		timerNextDarkGlare:Cancel()
		timerNextFrostBomb:Cancel()
		timerP2toP3:Start()
		timerBombBotSpawn:Start(32)
		self:ScheduleMethod(32, "BombBot")
		if self.Options.HealthFrame then
			DBM.BossHealth:Clear()
			DBM.BossHealth:AddBoss(33670, L.MobPhase3)
		end

	elseif self.vb.phase == 4 then
		if self.Options.AutoChangeLootToFFA and DBM:GetRaidRank() == 2 then
			if masterlooterRaidID then
				SetLootMethod(lootmethod, "raid" .. masterlooterRaidID)
			else
				SetLootMethod(lootmethod)
			end
		end
		timerBombBotSpawn:Cancel()
		self:UnscheduleMethod("BombBot")
		timerP3toP4:Start()
		if self.vb.hardmode then
			self:UnscheduleMethod("Flames")
			self:Flames()
			timerNextFrostBomb:Start(29)
			timerNextDarkGlare:Start(59.8)
			timerNextShockblast:Start(75)
		end
		if self.Options.HealthFramePhase4 or self.Options.HealthFrame then
			DBM.BossHealth:Show(L.name)
			DBM.BossHealth:AddBoss(33670, L.MobPhase3)
			DBM.BossHealth:AddBoss(33651, L.MobPhase2)
			DBM.BossHealth:AddBoss(33432, L.MobPhase1)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(63666, 65026, 312347, 312435, 312700, 312788) then -- Napalm Shell
		if self.Options.SetIconOnNapalm then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		self:SendSync("Phase2") -- untested alpha! (this will result in a wrong timer)
	elseif msg == L.YellPhase3 or msg:find(L.YellPhase3) then
		self:SendSync("Phase3") -- untested alpha! (this will result in a wrong timer)

	elseif msg == L.YellPhase4 or msg:find(L.YellPhase4) then
		self:SendSync("Phase4") -- SPELL_AURA_REMOVED detection might fail in phase 3...there are simply not enough debuffs on him
	elseif msg == L.YellHardPull or msg:find(L.YellHardPull) then
		timerHardmode:Start()
		timerFlameSuppressant:Start()
		enrage:Stop()
		self.vb.hardmode = true
		timerNextFlames:Start(1.5)
		self:ScheduleMethod(1.5, "Flames")
	elseif (msg == L.YellKilled or msg:find(L.YellKilled)) then -- register kill
		enrage:Stop()
		timerHardmode:Stop()
		timerNextFlames:Stop()
		self:UnscheduleMethod("Flames")
		timerNextFrostBomb:Stop()
		timerNextDarkGlare:Stop()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, spellId)
	if spellName == GetSpellInfo(34098) then --ClearAllDebuffs
		self:NextStage()
		if self.vb.phase == 2 then
			timerNextShockblast:Stop()
			timerProximityMines:Stop()
			timerFlameSuppressant:Stop()
			--timerNextFlameSuppressant:Stop()
			timerPlasmaBlastCD:Stop()
			timerP1toP2:Start()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
			timerRocketStrikeCD:Start(63)
			timerNextDarkGlare:Start(78)
			if self.vb.hardmode then
				timerNextFrostBomb:Start(94)
			end
		elseif self.vb.phase == 3 then
			timerDarkGlareCast:Stop()
			timerNextDarkGlare:Stop()
			timerNextFrostBomb:Stop()
			timerRocketStrikeCD:Stop()
			timerP2toP3:Start()
		elseif self.vb.phase == 4 then
			timerP3toP4:Start()
			if self.vb.hardmode then
				timerNextFrostBomb:Start(32)
			end
			timerRocketStrikeCD:Start(50)
			timerNextDarkGlare:Start(59.8)
			timerNextShockblast:Start(81)
		end
	elseif spellId == 64402 or spellId == 65034 then --P2, P4 Rocket Strike
		warnRocketStrike:Show()
		warnRocketStrike:Play("watchstep")
		timerRocketStrikeCD:Start()
	end
end

function mod:OnSync(event, args)
	if event == "SpinUpFail" then
		is_spinningUp = false
		timerSpinUp:Cancel()
		timerDarkGlareCast:Cancel()
		timerNextDarkGlare:Cancel()
		warnDarkGlare:Cancel()
	elseif event == "Phase2" and self.vb.phase == 1 then -- alternate localized-dependent detection
		self:NextPhase()
	elseif event == "Phase3" and self.vb.phase == 2 then
		self:NextPhase()
	elseif event == "Phase4" and self.vb.phase == 3 then
		self:NextPhase()
	elseif event == "LootMsg" and args and self:AntiSpam(2, 1) then
		lootannounce:Show(args)
	end
end
