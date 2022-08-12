local mod = DBM:NewMod("Prince", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(15690)
mod:RegisterCombat("combat", 15690)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 305425 305443 305447",
	"SPELL_AURA_APPLIED 305433 305435 305429",
	"UNIT_HEALTH",
	"CHAT_MSG_MONSTER_YELL"
)

--обычка--
local warningInfernal = mod:NewSpellAnnounce(37277, 2)
local timerInfernal   = mod:NewCDTimer(45, 37277) -- метеоры

--хм--
local warningNovaCast = mod:NewCastAnnounce(30852, 3)
local timerNovaCD     = mod:NewCDTimer(12, 305425)
local timerFlameCD    = mod:NewCDTimer(30, 305433)
local specWarnFlame   = mod:NewSpecialWarningYou(305433)
local warnFlame       = mod:NewTargetAnnounce(305433, 3)
local timerCurseCD    = mod:NewCDTimer(30, 305435)

local timerIceSpikeCD = mod:NewCDTimer(10, 305443)

local timerCallofDeadCD  = mod:NewCDTimer(10, 305447)
local warnCallofDead     = mod:NewTargetAnnounce(305447, 3)
local specWarnCallofDead = mod:NewSpecialWarningYou(305447)

local warnNextPhaseSoon	= mod:NewAnnounce("WarnNextPhaseSoon", 1)
-- local warnSound						= mod:NewSoundAnnounce()
-- mod.vb.phaseCounter     = 1
local warnPorch         = mod:NewTargetAnnounce(305429, 3)
local yellPorch         = mod:NewYell(305429, nil, nil, nil, "YELL")
local yellPorchFades    = mod:NewShortFadesYell(305429)

local flameTargets = {}
local PorchTargets = {}
mod.vb.PorchIcons = 8
mod.vb.phase = 0

mod:AddBoolOption("AnnouncePorch", false)
-- mod:SetStage(0)
function mod:OnCombatStart(delay)
	self:SetStage(1)
	DBM:FireCustomEvent("DBM_EncounterStart", 15690, "Prince Malchezaar")
	if self:IsDifficulty("normal10") then
		timerInfernal:Start()
	elseif self:IsDifficulty("heroic10") then
		self.vb.PorchIcons = 8
		timerCurseCD:Start(20-delay)
		timerNovaCD:Start()
		table.wipe(flameTargets)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_PRINCE_YELL_INF1 or msg == L.DBM_PRINCE_YELL_INF2 then
		warningInfernal:Show()
		timerInfernal:Start()
	elseif msg == L.DBM_PRINCE_YELL_P3 then
		warnNextPhaseSoon:Show("3")
		self.vb.phase = 3
	elseif msg == L.DBM_PRINCE_YELL_P2 then
		warnNextPhaseSoon:Show("2")
	elseif self.vb.phase == 3 and (msg == L.DBM_PRINCE_YELL_INF1 or msg == L.DBM_PRINCE_YELL_INF2) then
		warningInfernal:Show()
		timerInfernal:Start(17)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 15690, "Prince Malchezaar", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305425) then
		warningNovaCast:Show()
		timerNovaCD:Start()
	elseif args:IsSpellID(305443) then
		timerIceSpikeCD:Start()
	elseif args:IsSpellID(305447) then
		timerCallofDeadCD:Start()
		warnCallofDead:Show(args.destName)
		if args:IsPlayer() then
			specWarnCallofDead:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if args:IsSpellID(305433) then
		timerFlameCD:Start(self:GetStage() < 3 and 30 or 10)
		flameTargets[#flameTargets + 1] = args.destName
		if #flameTargets >= 2 and self:GetStage() < 3 then
			warnFlame:Show(table.concat(flameTargets, "<, >"))
			table.wipe(flameTargets)
		elseif self:GetStage() >= 3 then
			warnFlame:Show(args.destName)
			table.wipe(flameTargets)
		end
		if args:IsPlayer() then
			specWarnFlame:Show()
		end
	elseif args:IsSpellID(305435) then
		timerCurseCD:Start(self:GetStage() == 2 and 30 or 20)
	elseif args:IsSpellID(305429) then
		PorchTargets[#PorchTargets + 1] = args.destName
		self:ScheduleMethod(0.1, "SetPorchIcons")
		if args:IsPlayer() then
			yellPorch:Yell()
			yellPorchFades:Countdown(spellId)
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 15690 and self:IsDifficulty("heroic10") then
		local hp = DBM:GetBossHP(uId)
		local stage = self:GetStage()
		if (stage == 1 and hp <= 80) then
			self:SetStage(2)
			warnNextPhaseSoon:Show("2")
			timerFlameCD:Start(20)
			timerCurseCD:Start(20)
		elseif (stage == 2 and hp <= 40) then
			self:SetStage(3)
			warnNextPhaseSoon:Show(L.FlameWorld)
			timerCurseCD:Cancel()
			timerNovaCD:Cancel()
			timerFlameCD:Start(10)
		elseif (stage == 3 and hp <= 30) then
			self:SetStage(4)
			warnNextPhaseSoon:Show(L.IceWorld)
			timerFlameCD:Cancel()
			timerIceSpikeCD:Start()
			timerCurseCD:Start(20)
		elseif (stage == 4 and hp <= 20) then
			self:SetStage(5)
			warnNextPhaseSoon:Show(L.BlackForest)
			timerCurseCD:Cancel()
			timerIceSpikeCD:Cancel()
			timerCallofDeadCD:Start()
		elseif (stage == 5 and hp <= 10) then
			warnNextPhaseSoon:Show(L.LastPhase)
			timerCallofDeadCD:Cancel()
			timerFlameCD:Start()
		end
	-- elseif self:GetUnitCreatureId(uId) == 15690 and self:IsDifficulty("normal10") then
	-- 	local hp = DBM:GetBossHP(uId)
	-- 	local stage = self:GetStage()
	-- 	if (stage == 1 and hp <= 60) then
	-- 		self:SetStage(2)
	-- 	elseif (stage == 2 and hp <= 30) then
	-- 		self:SetStage(3)
	-- 	end
	end
end

do
	-- local function sort_by_group(v1, v2)
	-- 	return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	-- end
	function mod:SetPorchIcons()
		table.sort(PorchTargets, function(v1, v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
		for _, v in ipairs(PorchTargets) do
			if mod.Options.AnnouncePorch then
				if DBM:GetRaidRank() > 0 then
					SendChatMessage(L.Porch:format(self.vb.PorchIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.Porch:format(self.vb.PorchIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnPorchTargets then
				self:SetIcon(UnitName(v), self.vb.PorchIcons, 10)
			end
			self.vb.PorchIcons = self.vb.PorchIcons - 1
		end
		if #PorchTargets <= 2 then
			warnPorch:Show(table.concat(PorchTargets, "<, >"))
			table.wipe(PorchTargets)
			self.vb.PorchIcons = 7
		end
	end
end
