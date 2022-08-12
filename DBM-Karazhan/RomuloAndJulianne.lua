local mod = DBM:NewMod("RomuloAndJulianne", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(17534, 17533)

mod:RegisterCombat("combat", 17534, 17533)
--mod:RegisterCombat("yell", L.RJ_Pull)
--mod:RegisterKill("yell", L.Bogus)--there isn't actually a yell, but we use this to prevent mod from ending combat early using UNIT_DIED after they both die once.
mod:SetWipeTime(25) --guesswork

mod:RegisterEvents(
	"SPELL_CAST_START 30878",
	"SPELL_AURA_APPLIED 30822 30830 30841 30887",
	"SPELL_AURA_APPLIED_DOSE 30822 30830 30841 30887",
	"SPELL_AURA_REMOVED 30841 30887",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED"
)

local warnPhase2      = mod:NewPhaseAnnounce(2)
local warnPhase3      = mod:NewPhaseAnnounce(3)
local warningHeal     = mod:NewCastAnnounce(30878, 4)
local warningDaring   = mod:NewTargetAnnounce(30841, 3)
local warningDevotion = mod:NewTargetAnnounce(30887, 3)
local warningPosion   = mod:NewAnnounce("warningPosion", 2, 30830, "Tank|Healer")

local timerHeal        = mod:NewCastTimer(2.5, 30878)
local timerDaring      = mod:NewTargetTimer(8, 30841)
local timerDevotion    = mod:NewTargetTimer(10, 30887)
local timerCombatStart = mod:NewTimer(55, "TimerCombatStart", 2457)

mod:AddBoolOption("HealthFrame", true)

local phases = {}
mod.vb.JulianneDied = 0
mod.vb.RomuloDied = 0
mod.vb.phase = 0

local function updateHealthFrame(phase) --WIP
	if phases[phase] then
		return
	end
	phases[phase] = true
	mod.vb.phase = phase

	if phase == 1 then
		DBM.BossHealth:Clear()
		DBM.BossHealth:AddBoss(17534, L.Julianne)
	elseif phase == 2 then --UNIT_DIED event triggers not tested yet
		DBM.BossHealth:AddBoss(17533, L.Romulo)
		warnPhase2:Show()
	elseif phase == 3 then
		DBM.BossHealth:AddBoss(17534, L.Julianne)
		DBM.BossHealth:AddBoss(17533, L.Romulo)
	end
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 17534, "RomuloAndJulianne")
	updateHealthFrame(1)
	self.vb.JulianneDied = 0
	self.vb.RomuloDied = 0
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17534, "RomuloAndJulianne", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30878) then
		warningHeal:Show()
		timerHeal:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30822, 30830) then
		warningPosion:Show(args.spellName, args.destName, args.amount or 1)
	elseif args:IsSpellID(30841) then
		warningDaring:Show(args.destName)
		timerDaring:Start(args.destName)
	elseif args:IsSpellID(30887) then
		warningDevotion:Show(args.destName)
		timerDevotion:Start(args.destName)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(30841) then
		timerDaring:Cancel(args.destName)
	elseif args:IsSpellID(30887) then
		timerDevotion:Cancel(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_RJ_PHASE2_YELL or msg:find(L.DBM_RJ_PHASE2_YELL) then
		warnPhase3:Show()
		updateHealthFrame(3)
	elseif msg == L.Event or msg:find(L.Event) then
		timerCombatStart:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 17534 then
		if self.vb.phase == 3 then --Only want to remove from boss health frame first time they die, and kill only in phase 3.
			self.vb.JulianneDied = GetTime()
			if (GetTime() - self.vb.RomuloDied) < 10 then
				mod:EndCombat()
			end
		else
			DBM.BossHealth:RemoveBoss(cid)
			updateHealthFrame(2)
		end
	elseif cid == 17533 then
		if self.vb.phase == 3 then --Only want to remove from boss health frame first time they die, and kill only in phase 3.
			self.vb.RomuloDied = GetTime()
			if (GetTime() - self.vb.JulianneDied) < 10 then
				mod:EndCombat()
			end
		else
			DBM.BossHealth:RemoveBoss(cid)
		end
	end
end
