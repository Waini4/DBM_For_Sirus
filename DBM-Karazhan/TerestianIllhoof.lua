local mod = DBM:NewMod("TerestianIllhoof", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(15688)

mod:SetBossHealthInfo(
	15688, L.name
)

--mod:RegisterCombat("yell", L.DBM_TI_YELL_PULL)
mod:RegisterCombat("combat")
--17229--imp, for future use

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 305351 30115 305367 305360",
	"SPELL_CAST_START 305345"
)

-- local warningWeakened	= mod:NewTargetAnnounce(30065, 2)
-- local warningImpSoon	= mod:NewSoonAnnounce(30066, 2)
-- local warningImp		= mod:NewSpellAnnounce(30066, 3)
-- local warningSacSoon	= mod:NewSoonAnnounce(30115, 3)
-- local warningSacrifice	= mod:NewTargetAnnounce(30115, 4)
--
-- local specWarnSacrifice	= mod:NewSpecialWarningYou(30115)
--
-- local timerWeakened		= mod:NewBuffActiveTimer(31, 30065)
-- local timerSacrifice	= mod:NewTargetTimer(30, 30115)
-- local timerSacrificeCD	= mod:NewNextTimer(43, 30115)

local warningHandCast = mod:NewCastAnnounce(305345, 3)
-- local warnSound						= mod:NewSoundAnnounce()

local timerHandCD    = mod:NewCDTimer(15, 305345)
local timerMarkCD    = mod:NewCDTimer(33, 305351)
local timerSacrifice = mod:NewCDTimer(42, 30115)

local WarnMark     = mod:NewTargetAnnounce(305351, 3)
local specWarnMark = mod:NewSpecialWarningYou(305351)
local specWarnSeed = mod:NewSpecialWarningSpell(305360, "Tank")
local specWarnDart = mod:NewSpecialWarningStack(305367, nil, 7)

-- local berserkTimer		        = mod:NewBerserkTimer(600)

mod.vb.tolik = true

-- mod:AddBoolOption("HealthFrame", true)

-- function mod:OnCombatStart(delay)
-- 	berserkTimer:Start(-delay)
-- end
--
-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args:IsSpellID(30115) then
-- 		DBM.BossHealth:AddBoss(17248, L.DChains)
-- 		warningSacrifice:Show(args.destName)
-- 		timerSacrifice:Start(args.destName)
-- 		timerSacrificeCD:Start()
-- 		warningSacSoon:Cancel()
-- 		warningSacSoon:Schedule(38)
-- 		if args:IsPlayer() then
-- 			specWarnSacrifice:Show()
-- 		end
-- 	elseif args:IsSpellID(30065) then
-- 		warningWeakened:Show(args.destName)
-- 		timerWeakened:Start()
-- 		warningImpSoon:Schedule(26)
-- 	end
-- end
--
-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(30115) then
-- 		timerSacrifice:Cancel(args.destName)
-- 	end
-- end
--
-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(30066) then
-- 		warningImpSoon:Cancel()
-- 		warningImp:Show()
-- 		DBM.BossHealth:AddBoss(17229, L.Kilrek)
-- 	end
-- end
--
-- function mod:UNIT_DIED(args)
-- 	local cid = self:GetCIDFromGUID(args.destGUID)
-- 	if cid == 17229 then--Kil'rek
-- 		DBM.BossHealth:RemoveBoss(cid)
-- 	elseif cid == 17248 then--Demon Chains
-- 		DBM.BossHealth:RemoveBoss(cid)
-- 	end
-- end
function mod:resetTolik()
	self.vb.tolik = true
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 15688, "Terestian Illhoof")
	if self:IsDifficulty("normal10") then
		timerSacrifice:Start(28)
	elseif self:IsDifficulty("heroic10") then
		self.vb.tolik = true
		timerHandCD:Start()
		timerMarkCD:Start()
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 15688, "Terestian Illhoof", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305345) then
		warningHandCast:Show()
		timerHandCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305351) then
		if args.sourceName == L.name then
			timerMarkCD:Start()
			WarnMark:Show(args.destName)
		elseif self.vb.tolik then
			self.vb.tolik = false
			self:ScheduleMethod(2, "resetTolik")
		end
		if args:IsPlayer() then
			specWarnMark:Show()
		end
	elseif args:IsSpellID(30115) then
		timerSacrifice:Start()
	elseif args:IsSpellID(305367) and args:IsPlayer() and ((args.amount or 1) >= 7) then
		specWarnDart:Show(args.amount)
	elseif args:IsSpellID(305360) and args:IsPlayer() then
		specWarnSeed:Show()
	end
end
