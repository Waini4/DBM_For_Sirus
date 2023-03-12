local mod = DBM:NewMod("Maiden", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220831140000")
mod:SetCreatureID(16457)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START 305286 29511",
	"SPELL_AURA_APPLIED 305271 305285 29522",
	"SPELL_AURA_REMOVED 305285"
-- "SPELL_INTERRUPT"
)
mod:AddTimerLine(L.Normal)
local warningRepentanceSoon	= mod:NewSoonAnnounce(29511, nil, nil, nil, 2)
local warningRepentance		= mod:NewSpellAnnounce(29511, nil, nil, nil, 3)	-- Покаяние
local warningHolyFire		= mod:NewTargetAnnounce(29522, nil, nil, nil, 3)	--Священный огонь

local timerRepentance		= mod:NewBuffActiveTimer(12.6, 29511)
local timerRepentanceCDob		= mod:NewCDTimer(33, 29511)
local timerHolyFire			= mod:NewTargetTimer(12, 29522)

mod:AddBoolOption("RangeFrame", true)

-- function mod:OnCombatStart(delay)
-- 	timerRepentanceCD:Start(45-delay)
-- 	warningRepentanceSoon:Schedule(40-delay)
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Show(10)
-- 	end
-- end

-- function mod:OnCombatEnd()
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Hide()
-- 	end
-- end

-- function mod:SPELL_CAST_START(args)
-- 	if args:IsSpellID(29511) then
-- 		warningRepentanceSoon:Cancel()
-- 		warningRepentance:Show()
-- 		timerRepentance:Start()
-- 		timerRepentanceCD:Start()
-- 		warningRepentanceSoon:Schedule(28)
-- 	end
-- end

-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args:IsSpellID(29522) then
-- 		warningHolyFire:Show(args.destName)
-- 		timerHolyFire:Start(args.destName)
-- 	end
-- end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(29522) then
-- 		timerHolyFire:Cancel(args.destName)
-- 	end
-- end

mod:AddTimerLine(L.Heroic)
local timerRepentanceCD = mod:NewCDTimer(60, 305277, nil, nil, nil, 2)	-- Всеобщее покаяние
local timerGroundCD     = mod:NewCDTimer(20, 305271, nil, nil, nil, 3)	-- Священная земля

local WarnGround = mod:NewTargetNoFilterAnnounce(305271, nil, nil, nil, 3, 3)
local specWarnGround = mod:NewSpecialWarningYou(305271, nil, nil, nil, 3, 2)

local soundGroundOnYou				= mod:NewSoundYou(305271)

mod.vb.ground = true

mod:AddSetIconOption("GroundIcon", 305271, true, true, { 8 })
mod:AddBoolOption("HealthFrame", true)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 16457, "Maiden of Virtue")
	if self:IsDifficulty("normal10") then
		timerRepentanceCDob:Start(45-delay)
		warningRepentanceSoon:Schedule(40-delay)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(10)
		end
	elseif self:IsDifficulty("heroic10") then
		timerRepentanceCD:Start(56.5 - delay)
		timerGroundCD:Start(20 - delay)
	end
	if self.Options.HealthFrame then
		DBM.BossHealth:Show(L.name)
	end
	self.vb.ground = true
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 16457, "Maiden of Virtue", wipe)
	DBM.BossHealth:Clear()
	if self:IsDifficulty("normal10") then
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305286) then
		-- local name = {"tobecon","dramatic"}
		-- name  = name[math.random(#name)]
		-- warnSound:Play(name)
		timerRepentanceCD:Start()
		timerGroundCD:Start(30)
		self.vb.ground = true
	elseif args:IsSpellID(29511) then
		warningRepentanceSoon:Cancel()
		warningRepentance:Show()
		timerRepentance:Start()
		timerRepentanceCD:Start()
		warningRepentanceSoon:Schedule(28)
	end
end

local showShieldHealthBar, hideShieldHealthBar
do
	local frame = CreateFrame("Frame")
	local shieldedMob
	local absorbRemaining = 0
	local maxAbsorb = 0
	local function getShieldHP()
		return math.max(1, math.floor(absorbRemaining / maxAbsorb * 100))
	end

	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent",
		function(self, event, timestamp, subEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
			if shieldedMob == destGUID then
				local absorbed
				if subEvent == "SWING_MISSED" then
					absorbed = select(2, ...)
				elseif subEvent == "RANGE_MISSED" or subEvent == "SPELL_MISSED" or subEvent == "SPELL_PERIODIC_MISSED" then
					absorbed = select(5, ...)
				end
				if absorbed then
					absorbRemaining = absorbRemaining - absorbed
				end
			end
		end)

	function showShieldHealthBar(self, mob, shieldName, absorb)
		shieldedMob = mob
		absorbRemaining = absorb
		maxAbsorb = absorb
		DBM.BossHealth:RemoveBoss(getShieldHP)
		DBM.BossHealth:AddBoss(getShieldHP, shieldName)
		self:Schedule(26, hideShieldHealthBar)
	end

	function hideShieldHealthBar()
		DBM.BossHealth:RemoveBoss(getShieldHP)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305271) then
		if self.vb.ground then
			timerGroundCD:Start()
			self.vb.ground = false
		end
		if args:IsPlayer() then
			specWarnGround:Show()
			soundGroundOnYou:Play("runaway")
		else
			WarnGround:Show(args.destName)
		end
		if self.Options.GroundIcon then
			self:SetIcon(args.destName, 8, 5)
		end
	elseif args:IsSpellID(305285) then
		showShieldHealthBar(self, args.destGUID, args.spellName, 600000)
	elseif args:IsSpellID(29522) then
		warningHolyFire:Show(args.destName)
		timerHolyFire:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(305285) then
		hideShieldHealthBar()
	end
	if args:IsSpellID(29522) then
		timerHolyFire:Cancel(args.destName)
	end
end
