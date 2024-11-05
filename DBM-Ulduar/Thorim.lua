local mod    = DBM:NewMod("Thorim", "DBM-Ulduar")
local L      = mod:GetLocalizedStrings()
DBM_COMMON_L = {}
local CL     = DBM_COMMON_L

mod:SetRevision("20220518110528")
mod:SetCreatureID(32865)
mod:SetUsedIcons(7)

mod:RegisterCombat("yell", L.YellPhase1)
mod:RegisterKill("yell", L.YellKill)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312542 312895",
	"SPELL_AURA_APPLIED 312889 312536 62042 312898 312545 62130 312911 312910 312558 312557 62526 62527",
	"SPELL_AURA_APPLIED_DOSE 312889 312536 62042 312898 312545 62130 312911 312910 312558 312557 62526 62527",
	"SPELL_CAST_SUCCESS 62042 62507 312897 312896 312898 312545 62604 312895 312542 300871 64390 64213",
	"SPELL_DAMAGE 62017 312539 312892 312897"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

local warnPhase2          = mod:NewPhaseAnnounce(2, 1)
local warnStormhammer     = mod:NewTargetAnnounce(312907, 2)
local warnLightningCharge = mod:NewSpellAnnounce(312897, 2)
local warningBomb         = mod:NewTargetAnnounce(312911, 4)

local yellBomb                      = mod:NewYell(312911)
local specWarnBomb                  = mod:NewSpecialWarningClose(312911, nil, nil, nil, 1, 2)
local specWarnLightningShock        = mod:NewSpecialWarningMove(62017, nil, nil, nil, 1, 2)
local specWarnUnbalancingStrikeSelf = mod:NewSpecialWarningDefensive(312898, nil, nil, nil, 1, 2)
local specWarnUnbalancingStrike     = mod:NewSpecialWarningTaunt(312898, nil, nil, nil, 1, 2)

mod:AddBoolOption("AnnounceFails", false, "announce")

local enrageTimer            = mod:NewBerserkTimer(369)
local timerStormhammer       = mod:NewBuffActiveTimer(16, 62042, nil, nil, nil, 3) --Cast timer? Review if i ever do this boss again.
local timerLightningCharge   = mod:NewCDTimer(16, 312897, nil, nil, nil, 3)
local timerUnbalancingStrike = mod:NewCDTimer(15, 312898, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerHardmode          = mod:NewTimer(175, "TimerHardmode", 312898)
-- local timerFrostNova				= mod:NewNextTimer(20, 62605)
-- local timerFrostNovaCast			= mod:NewCastTimer(2.5, 62605)
local timerChainLightning    = mod:NewNextTimer(13, 312895)
local timerFBVolley          = mod:NewCDTimer(13, 62604)

mod:AddRangeFrameOption("11")
mod:AddSetIconOption("SetIconOnRunic", 62527, false, false, { 7 })

local lastcharge = {}

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 32865, "Thorim")
	self:SetStage(1)
	enrageTimer:Start()
	timerHardmode:Start()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(11)
	end
	table.wipe(lastcharge)
end

local sortedFailsC = {}
local function sortFails1C(e1, e2)
	return (lastcharge[e1] or 0) > (lastcharge[e2] or 0)
end

function mod:OnCombatEnd()
	DBM:FireCustomEvent("DBM_EncounterStart", 32865, "Thorim", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.AnnounceFails then
		local lcharge = ""
		for k, _ in pairs(lastcharge) do
			table.insert(sortedFailsC, k)
		end
		table.sort(sortedFailsC, sortFails1C)
		for _, v in ipairs(sortedFailsC) do
			lcharge = lcharge .. " " .. v .. "(" .. (lastcharge[v] or "") .. ")"
		end
		SendChatMessage(L.Charge:format(lcharge), "RAID")
		table.wipe(sortedFailsC)
	end
end

function mod:SPELL_CAST_START(args)
	-- local spellId = args.spellId
	if args:IsSpellID(312542, 312895) then -- Chain Lightning by Thorim
		timerChainLightning:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	-- local spellId = args.spellId
	if args:IsSpellID(312889, 312536) then -- Storm Hammer
		warnStormhammer:Show(args.destName)
	elseif args:IsSpellID(62507) then -- Touch of Dominion
		timerHardmode:Start(150)
	elseif args:IsSpellID(312898, 312545, 62130) then -- Unbalancing Strike
		if args:IsPlayer() then
			specWarnUnbalancingStrikeSelf:Show()
			specWarnUnbalancingStrikeSelf:Play("defensive")
		else
			specWarnUnbalancingStrike:Show(args.destName)
		end
	elseif args:IsSpellID(312911, 312910, 312558, 312557, 62526, 62527) then -- Runic Detonation
		if args:IsPlayer() then
			yellBomb:Yell()
		elseif self:CheckNearby(10, args.destName) then
			specWarnBomb:Show(args.destName)
			specWarnBomb:Play("runaway")
		else
			warningBomb:Show(args.destName)
		end
		if self.Options.SetIconOnRunic then
			self:SetIcon(args.destName, 7, 5)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 62042 then -- Storm Hammer
		timerStormhammer:Schedule(2)
	elseif args:IsSpellID(312897, 312896) then -- Lightning Charge
		warnLightningCharge:Show()
		timerLightningCharge:Start()
	elseif args:IsSpellID(312898, 312545) then -- Unbalancing Strike
		if self:IsDifficulty("normal10", "heroic10") then
			timerUnbalancingStrike:Start(22)
		else
			timerUnbalancingStrike:Start()
		end
	elseif spellId == 62604 then -- Frostbolt Volley by Sif
		timerFBVolley:Start()
	elseif args:IsSpellID(312895, 312542, 300871, 64390, 64213) then
		timerChainLightning:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destName, destFlags, spellId)
	if spellId == 62017 or spellId == 312539 or spellId == 312892 then -- Lightning Shock
		if bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0
			and bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
			and self:AntiSpam(5) then
			specWarnLightningShock:Show()
			specWarnLightningShock:Play("runaway")
		end
	elseif self.Options.AnnounceFails and spellId == 312897 and DBM:GetRaidRank() >= 1 and
		DBM:GetRaidUnitId(destName) ~= "none" and destName then
		lastcharge[destName] = (lastcharge[destName] or 0) + 1
		SendChatMessage(L.ChargeOn:format(destName), "RAID")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then -- Bossfight (tank and spank)
		self:SendSync("Phase2")
		-- elseif msg == L.YellKill or msg:find(L.YellKill) then
		-- 	enrageTimer:Stop()
	end
end

function mod:OnSync(event, arg)
	if event == "Phase2" and self:GetStage() < 2 and UnitAffectingCombat("player") and select(1, IsInInstance()) and
		select(2, IsInInstance()) == "raid" then
		self:SetStage(2)
		warnPhase2:Show()
		enrageTimer:Stop()
		timerHardmode:Stop()
		enrageTimer:Start(300)
	end
end
