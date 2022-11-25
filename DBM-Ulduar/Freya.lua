local mod	= DBM:NewMod("Freya", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()
DBM_COMMON_L = {}
local CL = DBM_COMMON_L

mod:SetRevision("20210501000000")

mod:SetCreatureID(32906)
mod:RegisterCombat("combat", 32906)
mod:RegisterKill("yell", L.YellKill)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod.respawnTime = 20

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 62437 62859 312489 312842",
	"SPELL_CAST_SUCCESS 312883 63571 62589 312527 312880 62566 63601",
	"SPELL_AURA_APPLIED 62861 62438 312490 312507 312843 312860 62451 62865 312535 312888",
	"SPELL_AURA_REMOVED 62519 312486 312839 62861 62438 312490 312507 312843 312860",
	"UNIT_DIED"
)
mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnPhase2			= mod:NewPhaseAnnounce(2, 3)
local warnSimulKill			= mod:NewAnnounce("WarnSimulKill", 1)
local warnFury				= mod:NewTargetAnnounce(312880, 2)
local warnRoots				= mod:NewTargetAnnounce(312860, 2)

local specWarnnLifebinderSoon = mod:NewAnnounce("WarnLifebinderSoon", 2, 62568)
local specWarnEonarsGift    = mod:NewSpecialWarning("EonarsGift", 3)
local specWarnFury			= mod:NewSpecialWarningMoveAway(312880, nil, nil, nil, 1, 2)
local yellFury				= mod:NewYell(312880)
local yellRoots				= mod:NewYell(312860)
local specWarnTremor		= mod:NewSpecialWarningCast(312842, nil, nil, 2, 1, 2)	-- Hard mode
local specWarnBeam			= mod:NewSpecialWarningMove(312888, nil, nil, nil, 1, 2)	-- Hard mode

local enrage 				= mod:NewBerserkTimer(600)
local timerAlliesOfNature	= mod:NewNextTimer(60, 62678, nil, nil, nil, 1, nil, CL.DAMAGE_ICON)
local timerSimulKill		= mod:NewTimer(12, "TimerSimulKill", nil, nil, nil, 5, CL.DAMAGE_ICON)
local timerFury				= mod:NewTargetTimer(10, 312880, nil, nil, nil, 2)
local timerTremorCD 		= mod:NewCDTimer(28, 312842, nil, nil, nil, 2)
local timerBoom 		    = mod:NewCDTimer(31, 312883, nil, nil, nil, 2)
local timerLifebinderCD 	= mod:NewTimer(40, "Дар Эонара", nil, nil, nil, 1)
local timerRootsCD 			= mod:NewCDTimer(29.6, 312856, nil, nil, nil, 3)


mod:AddSetIconOption("SetIconOnFury", 312881, false, false, {7, 8})
mod:AddSetIconOption("SetIconOnRoots", 312860, false, false, {6, 5, 4})
mod:AddBoolOption("MobsHealthFrame", true)

local adds	= {}
local killTime	= 0
mod.vb.iconId = 6
mod.vb.altIcon = true
-- mod:SetStage(0)
function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 32906, "Freya")
	self.vb.altIcon = true
	self.vb.iconId = 6
	self:SetStage(1)
	enrage:Start()
	timerAlliesOfNature:Start(10)
	table.wipe(adds)
	timerLifebinderCD:Start(25)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 32906, "Freya", wipe)
	DBM.BossHealth:Hide()
	if not wipe then
		if  DBT:GetBar(L.TrashRespawnTimer) then
			DBT:CancelBar(L.TrashRespawnTimer)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(62437, 62859, 312489, 312842) and self:AntiSpam() then
		specWarnTremor:Show()
		timerTremorCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(312883) then
		timerBoom:Start(8)
	elseif args:IsSpellID(63571, 62589, 312527, 312880, 62566) then -- Nature's Fury
		if self.Options.SetIconOnFury then
			self.vb.altIcon = not self.vb.altIcon	--Alternates between Skull and X
			self:SetIcon(args.destName, self.vb.altIcon and 7 or 8, 10)
		end
		if args:IsPlayer() then -- only cast on players; no need to check destFlags
			specWarnFury:Show()
			specWarnFury:Play("runout")
			yellFury:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		else
			warnFury:Show(args.destName)
		end
		timerFury:Start(args.destName)
	elseif args.spellId == 63601 then
			timerRootsCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62861, 62438, 312490, 312507, 312843, 312860) then
		warnRoots:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			yellRoots:Yell()
		end
		self.vb.iconId = self.vb.iconId - 1
		if self.Options.SetIconOnRoots then
			self:SetIcon(args.destName, self.vb.iconId, 15)
		end
	elseif args:IsSpellID(62451, 62865, 312535, 312888) and args:IsPlayer() then
		specWarnBeam:Show()
		specWarnBeam:Play("runaway")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(62519, 312486, 312839) then
		warnPhase2:Show()
		self:SetStage(2)
		timerBoom:Start()
	elseif args:IsSpellID(62861, 62438, 312490, 312507, 312843, 312860) then
		self:RemoveIcon(args.destName)
		mod.vb.iconId = mod.vb.iconId + 1
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.SpawnYell then
		timerAlliesOfNature:Start()
		if self.Options.MobsHealthFrame then
			if not adds[33202] then DBM.BossHealth:AddBoss(33202, L.WaterSpirit) end -- ancient water spirit
			if not adds[32916] then DBM.BossHealth:AddBoss(32916, L.Snaplasher) end  -- snaplasher
			if not adds[32919] then DBM.BossHealth:AddBoss(32919, L.StormLasher) end -- storm lasher
		end
		adds[33202] = true
		adds[32916] = true
		adds[32919] = true
	elseif msg == L.YellAdds1 then
		timerAlliesOfNature:Start()
	elseif msg == L.YellAdds2 then
		timerAlliesOfNature:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, mob)
	if strmatch(msg, L.EmoteLGift) then
		specWarnEonarsGift:Show()
		timerLifebinderCD:Start()
		specWarnnLifebinderSoon:Schedule(35)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 33202 or cid == 32916 or cid == 32919 then
		if self.Options.MobsHealthFrame then
			DBM.BossHealth:RemoveBoss(cid)
		end
		if (GetTime() - killTime) > 20 then
			killTime = GetTime()
			timerSimulKill:Start()
			warnSimulKill:Show()
		end
		adds[cid] = nil
		local counter = 0
		for _, _ in pairs(adds) do
			counter = counter + 1
		end
		if counter == 0 then
			timerSimulKill:Stop()
		end
	end
end