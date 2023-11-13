local mod = DBM:NewMod("Curator", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(99973, 99972, 99974, 15691)
--mod:SetCreatureID(15691)
--mod:RegisterCombat("yell", L.DBM_CURA_YELL_PULL)
mod:RegisterCombat("combat", 99974, 15691)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 305309 305305",
	"SPELL_AURA_REMOVED 305313 305309 305305",
	"SPELL_CAST_START 305296 305312",
	-- "SPELL_INTERRUPT",
	"CHAT_MSG_MONSTER_YELL"
)

-- local warnEvoSoon		= mod:NewPreWarnAnnounce(30254, 10, 2)
-- local warnEvo			= mod:NewSpellAnnounce(30254, 3)
-- local warnArcaneInfusion= mod:NewSpellAnnounce(30403, 3)
--
-- local timerEvo			= mod:NewBuffActiveTimer(20, 30254)
-- local timerNextEvo		= mod:NewNextTimer(115, 30254)
--
-- local berserkTimer		= mod:NewBerserkTimer(720)
--
-- mod:AddBoolOption("RangeFrame", true)
--
-- function mod:OnCombatStart(delay)
-- 	berserkTimer:Start(-delay)
-- 	timerNextEvo:Start(109-delay)
-- 	warnEvoSoon:Schedule(99-delay)
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Show(10)
-- 	end
-- end
--
-- function mod:OnCombatEnd()
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Hide()
-- 	end
-- end
--
-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args:IsSpellID(30403) then
-- 		warnArcaneInfusion:Show()
-- 	end
-- end
--
-- function mod:CHAT_MSG_MONSTER_YELL(msg)
-- 	if msg == L.DBM_CURA_YELL_OOM then
-- 		warnEvoSoon:Cancel()
-- 		warnEvo:Show()
-- 		timerNextEvo:Start()
-- 		timerEvo:Start()
-- 		warnEvoSoon:Schedule(95)
-- 	end
-- end

--обычка--
local timerEvo = mod:NewNextTimer(101, 30254) -- Прилив сил

-- героик --
local warnUnstableTar = mod:NewAnnounce("WarnUnstableTar", 3, 305309)

-- local specWarnAnnihilationKick		= mod:NewSpecialWarning("Прерывание")
local specWarnCond  = mod:NewSpecialWarningYou(305305, nil, nil, nil, 1, 2)
local specWarnRunes = mod:NewSpecialWarningRun(305296, nil, nil, nil, 1, 2)

local timerAnnihilationCD = mod:NewCDTimer(23, 305312, nil, nil, nil, 2) -- Анигиляция
local timerCondCD         = mod:NewCDTimer(11, 305305, nil, nil, nil, 2) -- Проводник молний
local timerRunesCD        = mod:NewCDTimer(25, 305296, nil, nil, nil, 1) -- руны
local timerRunesBam       = mod:NewTimer(8, "TimerRunesBam", 305314, nil, nil, 2) -- взрыв рун

-- local warnSound						= mod:NewSoundAnnounce()

local unstableTargets = {}
mod.vb.ter = true
mod.vb.isinCombat = false
mod:AddNamePlateOption("Nameplate1", 305305, true)


function mod:OnCombatStart()
	if self:IsDifficulty("normal10") then
		DBM:FireCustomEvent("DBM_EncounterStart", 15691, "The Curator")
		timerEvo:Start()
	elseif self:IsDifficulty("heroic10") then
		DBM:FireCustomEvent("DBM_EncounterStart", 99974, "The Curator")
		for i = 1, 3 do
			if UnitAura("boss" .. i, "Деактивация", nil, "HARMFUL") == nil then
				if i == 3 then
					timerAnnihilationCD:Start()
					timerCondCD:Start()
				elseif i == 1 then
					timerRunesCD:Start()
				end
			end
		end
		self.vb.isinCombat = true
		self.vb.ter = true
		table.wipe(unstableTargets)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_CURA_YELL_OOM then
		timerEvo:Start(101)
	end
end

function mod:OnCombatEnd(wipe)
	if self:IsDifficulty("normal10") then
		DBM:FireCustomEvent("DBM_EncounterEnd", 15691, "The Curator", wipe)
	elseif self:IsDifficulty("heroic10") then
		DBM:FireCustomEvent("DBM_EncounterEnd", 99974, "The Curator", wipe)
	end
	self.vb.isinCombat = false
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(305313) then
		-- if self.vb.isinCombat then
			-- local name = {"tobecon","dramatic"}
			-- name  = name[math.random(#name)]
			-- warnSound:Play(name)
		-- end
		for i = 1, 3 do
			if UnitAura("boss" .. i, "Деактивация", nil, "HARMFUL") == nil then
				if i == 3 then
					timerAnnihilationCD:Start()
					timerCondCD:Start()
				elseif i == 1 then
					timerRunesCD:Start()
				end
			end
		end
	elseif args:IsSpellID(305305) then
		if self.Options.Nameplate1 then
			DBM.Nameplate:Hide(args.destGUID, 305305)
		end
	elseif args:IsSpellID(305309) then
		for i = 1, 10 do
			if UnitAura("raid" .. i, "Нестабильная энергия") then
				unstableTargets[#unstableTargets + 1] = UnitName("raid" .. i)
			end
		end
		warnUnstableTar:Show(table.concat(unstableTargets, "<, >"))
		table.wipe(unstableTargets)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305305) then
		timerCondCD:Start()
		if args:IsPlayer() then
			specWarnCond:Show()
		end
		if self.Options.Nameplate1 then
			DBM.Nameplate:Show(args.destGUID, 305305)
		end
	elseif args:IsSpellID(305309) then
		for i = 1, 10 do
			if UnitAura("raid" .. i, "Нестабильная энергия") then
				unstableTargets[#unstableTargets + 1] = UnitName("raid" .. i)
			end
		end
		warnUnstableTar:Show(table.concat(unstableTargets, "<, >"))
		table.wipe(unstableTargets)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305296) then
		self.vb.ter = true
		specWarnRunes:Show()
		timerRunesCD:Start()
		timerRunesBam:Start()
	elseif args:IsSpellID(305312) then
		timerAnnihilationCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(305298) then
		if self.vb.ter then
			self.vb.ter = false
		end
	end
end
