local mod   = DBM:NewMod("Solarian", "DBM-TheEye", 1)
local L     = mod:GetLocalizedStrings()
local bband = bit.band
local CL    = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(18805)
mod:RegisterCombat("yell", L.YellPull)
mod:SetUsedIcons(2, 6, 7, 8)

-- mod:RegisterEvents(
-- 	"CHAT_MSG_MONSTER_YELL",
-- 	-- "UNIT_TARGET",
-- 	-- "SPELL_DISPEL",
-- 	-- "SPELL_CAST_START",
-- 	-- "SPELL_CAST_SUCCESS",
-- 	-- "SPELL_AURA_APPLIED",
-- 	-- "SWING_DAMAGE",
-- 	"UNIT_DEAD"
-- )
mod:RegisterEventsInCombat(
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_TARGET",
	-- "SPELL_DISPEL",
	"SPELL_CAST_START 308562 308558 308585 308576",
	-- "SPELL_CAST_SUCCESS",
	"SPELL_AURA_REMOVED 308548 308544 308563 42783",
	"SPELL_AURA_APPLIED 308548 308544 308563 42783",
	"SPELL_AURA_APPLIED_DOSE 308548 308544 308563 42783",
	-- "SWING_DAMAGE",
	"UNIT_HEALTH"
-- "UNIT_DEAD"
)
--------------------------нормал--------------------------

local warnWrathN        = mod:NewTargetAnnounce(42783, 4)
local warnAddsSoon      = mod:NewSpecialWarningAdds(55342, nil, nil, nil, 1, 2)

local specWarnWrathN    = mod:NewSpecialWarningRun(42783, nil, nil, nil, 1, 2)

local timerAdds         = mod:NewTimer(60, "TimerAdds", 55342, "RemoveEnrage", nil, 5, nil, CL.ENRAGE_ICON)
local timerPriestsN     = mod:NewTimer(14, "TimerPriests", 47788, "SpellCaster", nil, 5, nil, CL.HEALER_ICON)
local timerWrathN       = mod:NewTargetTimer(6, 42783, nil, "RemoveEnrage", nil, 5, nil, CL.ENRAGE_ICON, nil, 1, 5)
local timerNextWrathN   = mod:NewCDTimer(21, 42783, nil, "RemoveEnrage", nil, 5, nil, CL.ENRAGE_ICON)

--------------------------героик--------------------------

local warnRing          = mod:NewSoonAnnounce(308563, 3) -- ослепляющее кольцо
-- local warnPhase2Soon = mod:NewPrePhaseAnnounce(2)
local warnPhase2        = mod:NewPhaseAnnounce(2)
local warnKol           = mod:NewTargetAnnounce(308563, 2) -- Кольцо
local warnFlashVoid     = mod:NewSoonAnnounce(308585, 3)

local specWarnHelp      = mod:NewSpecialWarningAdds(308559, nil, nil, nil, 1, 2)     -- Послушники
local specWarnDebaf     = mod:NewSpecialWarningRun(308544, nil, nil, nil, 3, 4)      -- Дебаф 1я фаза
local specWarnFlashVoid = mod:NewSpecialWarningLookAway(308585, nil, nil, nil, 2, 2) -- фир 2 фаза
local yellWrathH        = mod:NewYell(308548)
local yellWrathHOb      = mod:NewYell(42783)
local yellWrathHFades   = mod:NewShortFadesYell(308548)
local yellWrathHObFades = mod:NewShortFadesYell(42783)


local timerRing       = mod:NewCDTimer(20, 308562, nil, nil, nil, 1, nil, CL.ENRAGE_ICON)
local timerNextHelp   = mod:NewCDTimer(40, 308558, nil, nil, nil, 3, nil, CL.TANK_ICON)
local timerWrathH     = mod:NewTargetTimer(6, 308548, nil, "RemoveEnrage", nil, 1, nil, CL.ENRAGE_ICON, nil, 1, 5)
local timerNextWrathH = mod:NewCDTimer(43, 308548, nil, "RemoveEnrage", nil, 1, nil, CL.ENRAGE_ICON)
local timerFlashVoid  = mod:NewCDTimer(75, 308585, nil, nil, nil, 6, nil, CL.HEROIC_ICON)

mod:AddNamePlateOption("Nameplate1", 42783, true)
mod:AddNamePlateOption("Nameplate2", 308548, true)
mod:AddBoolOption("SetPriestIcon")
--local priestsN = true
local priestsH = true
local provid = true
local KolTargets = {}
mod.vb.PriestIcon = 7
-- local warned_preP1 = false
-- local warned_preP2 = false

mod:AddBoolOption("Zrec", true)
-- mod:AddBoolOption("RangeFrame", true)

mod.vb.Fear = 0

local function Kolzo()
	warnKol:Show(table.concat(KolTargets, "<, >"))
	table.wipe(KolTargets)
end

-- mod:SetStage(0)
function mod:OnCombatStart(delay)
	self:SetStage(1)
	DBM:FireCustomEvent("DBM_EncounterStart", 18805, "High Astromancer Solarian")
	if self:IsDifficulty("heroic25") then
		timerNextHelp:Start(40 - delay)
		timerNextWrathH:Start(43 - delay)
		-- self:SetStage(1)
		self:RegisterShortTermEvents(
			"SPELL_DAMAGE", -- unfiltered for DBM arrow
			"SPELL_MISSED", -- unfiltered for DBM arrow
			"SWING_DAMAGE",
			"SWING_MISSED"
		)
	else
		self.vb.Fear = 0
		timerAdds:Start()
		warnAddsSoon:Schedule(52)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 18805, "High Astromancer Solarian", wipe)
	self:UnregisterShortTermEvents()
end

--------------------------нормал--------------------------

function mod:PriestNIcon() --об
	if DBM:GetRaidRank() >= 1 then
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid" .. i .. "target") == L.PriestN then
				--priestsN = false
				SetRaidTarget("raid" .. i .. "target", 6)
				break
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds then
		if self:IsDifficulty("normal25") then
			timerPriestsN:Start()
			timerNextWrathN:Start()
		end
	elseif msg == L.YellPriests then
		--priestsN = true
		timerAdds:Start()
		warnAddsSoon:Schedule(52)
	end
end

-- function mod:UNIT_TARGET() 				-- TODO: зачем вот это вот?
-- 	if priestsN then
-- 		self:PriestNIcon()
-- 	end
-- end

--------------------------героик--------------------------

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 308562 then -- кольцо
		warnRing:Show()
		timerRing:Start()
	elseif spellId == 308558 then -- послушники
		timerNextHelp:Start(80)
		specWarnHelp:Show(args.sourceName)
		priestsH = true
		provid   = true
	elseif spellId == 308585 then -- УЖАС --fxpw страшно вырубай
		specWarnFlashVoid:Show(self.vb.Fear)
		timerFlashVoid:Schedule(5)
	elseif spellId == 308576 then
		self:SetStage(2)
		timerNextHelp:Stop()
		warnFlashVoid:Schedule(70)
		timerFlashVoid:Start()
		warnPhase2:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 308548 then -- хм
		timerNextWrathH:Start()
		timerWrathH:Start(args.destName)
		self:SetIcon(args.destName, 8, 6)
		if args:IsPlayer() then
			yellWrathH:Yell()
			yellWrathHFades:Countdown(spellId)
		end
		if self.Options.Nameplate2 then
			DBM.Nameplate:Show(args.destGUID, 308548)
		end
	elseif spellId == 308544 and self.vb.phase == 1 then -- Стаки луча
		if args:IsPlayer() then
			specWarnDebaf:Show()
		end
	elseif spellId == 308563 then -- Ослепление
		KolTargets[#KolTargets + 1] = args.destName
		self:Unschedule(Kolzo)
		self:Schedule(0.1, Kolzo, self)
	elseif spellId == 42783 then -- об
		timerNextWrathN:Start()
		warnWrathN:Show(args.destName)
		timerWrathN:Start(args.destName)
		---TODO elvui test
		if self.Options.Nameplate1 then
			DBM.Nameplate:Show(args.destGUID, 42783)
		end
		self:SetIcon(args.destName, 8, 6)
		if args:IsPlayer() then
			specWarnWrathN:Show()
			yellWrathHOb:Yell()
			yellWrathHObFades:Countdown(spellId)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(42783) then
		if self.Options.Nameplate1 then
			DBM.Nameplate:Hide(args.destGUID, 42783)
		end
	elseif args:IsSpellID(308548) then
		if self.Options.Nameplate2 then
			DBM.Nameplate:Hide(args.destGUID, 308548)
		end
	end
end

function mod:PriestHIcon() -- хм
	if DBM:GetRaidRank() >= 1 then
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid" .. i .. "target") == L.PriestH then
				priestsH = false
				SetRaidTarget("raid" .. i .. "target", 6)
				break
			end
		end
	end
end

function mod:ProvidIcon()
	if DBM:GetRaidRank() >= 1 then
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid" .. i .. "target") == L.Provid then
				provid = false
				SetRaidTarget("raid" .. i .. "target", 7)
				break
			end
		end
	end
end

function mod:UNIT_TARGET()
	if priestsH then
		self:PriestHIcon()
	end
	--[[if priestsN then -- TODO: что за новый и опять переназначение
		self:PriestNIcon()
	end]]
	if provid then
		self:ProvidIcon()
	end
	if self.Options.SetPriestIcon then
		if DBM:GetRaidRank() >= 1 then
			for i = 1, GetNumRaidMembers() do
				if UnitName("raid" .. i .. "target") == L.PriestN then
					SetRaidTarget("raid" .. i .. "target", self.vb.PriestIcon)
					self.vb.PriestIcon = self.vb.PriestIcon - 1
					if self.vb.PriestIcon <= 6 then
						self.vb.PriestIcon = 7
					end
				end
			end
		end
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, destGUID, _, _, spellId)
	if (spellId ~= 53189 or spellId ~= 53190 or spellId ~= 53194 or spellId ~= 53195) and
		self:GetCIDFromGUID(destGUID) == 3410 and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and
		self:IsInCombat() then --Any spell damage except for starfall (ranks 3 and 4)
		if sourceGUID ~= UnitGUID("player") then
			if self.Options.Zrec and self:GetStage() == 1 then
				DBM.Arrow:ShowRunTo(sourceName, 0, 0)
			end
		end
	end
end

mod.SPELL_MISSED = mod.SPELL_DAMAGE
function mod:SWING_DAMAGE(sourceGUID, sourceName, sourceFlags, destGUID, destName)
	-- if self:GetCIDFromGUID(destGUID) == 3410 and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 then
	if self:GetCIDFromGUID(destGUID) == 3410 and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and
		self:IsInCombat() then
		if sourceGUID ~= UnitGUID("player") then
			if self.Options.Zrec and self:GetStage() == 1 then
				DBM.Arrow:ShowRunTo(sourceName, 0, 0)
			end
		end
	end
	-- end
end

mod.SWING_MISSED = mod.SWING_DAMAGE

local stage
function mod:UNIT_HEALTH(uId)
	local hp = self:GetUnitCreatureId(uId) == 18805 and DBM:GetBossHP(18805) or nil
	stage = self:GetStage()
	-- if self:GetStage() and not warned_preP1 and self:GetUnitCreatureId(uId) == 18805 and DBM:GetBossHPByUnitID(uId) <= 33 and self:IsDifficulty("normal25") then
	-- 	warned_preP1 = true
	-- 	warnPhase2Soon:Show()
	-- elseif not warned_preP2 and self:GetUnitCreatureId(uId) == 18805 and DBM:GetBossHPByUnitID(uId) <= 30 and self:IsDifficulty("normal25") then
	-- 	warned_preP2 = true
	-- 	warnPhase2:Show()
	-- 	timerAdds:Cancel()
	if hp and stage then
		if hp < 40 and self:IsDifficulty("heroic25") and stage == 1 then
			DBM.Arrow:Hide()
			self:SetStage(2)
			timerAdds:Cancel()
		elseif hp < 20 and self:IsDifficulty("normal25") and stage == 1 then
			self:SetStage(2)
		end
	end
	-- elseif self:GetUnitCreatureId(uId) == 18805 and DBM:GetBossHP(18805) <= 40 and self:IsDifficulty("heroic25") and self:GetStage() and self:GetStage() == 1 then -- TODO: 2 фаза для хма, может багаться получается?
	-- 	self:SetStage(2)
	-- elseif self:GetUnitCreatureId(uId) == 18805 and DBM:GetBossHP(18805) <= 20 and self:IsDifficulty("normal25") and self:GetStage() and self:GetStage() == 1 then
	-- 	self:SetStage(2)
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
