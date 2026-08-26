local mod	= DBM:NewMod("Shahraz", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(22947)

mod:SetModelID(22947)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"RAID_BOSS_EMOTE",
	"SPELL_CAST_START 374696 374699 374706",
	"SPELL_AURA_APPLIED 374701 374707 374690 374693 374691",
	"SPELL_AURA_APPLIED_DOSE 374701 374707 374690 374693 374691",
	"SPELL_AURA_REMOVED 374701 374707 374690 374693 374691",
	"SPELL_CAST_SUCCESS 374693",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)


--TODO, announce auras?
local warnFA			= mod:NewTargetNoFilterAnnounce(374706, 4)
--local warnShriek		= mod:NewSpellAnnounce(40823)
--local warnEnrageSoon	= mod:NewSoonAnnounce(21340)--not actual spell id
--local warnEnrage		= mod:NewSpellAnnounce(21340)

local specWarnDA		= mod:NewSpecialWarningMoveAway(374699, nil, nil, nil, 1, 2)
local specWarnFA		= mod:NewSpecialWarningGTFO(374706, nil, nil, nil, 1, 2)
local specWarnPassion	= mod:NewSpecialWarningStack(374690, nil, 30, nil, nil, 1, 6)
local specWarnPunishment= mod:NewSpecialWarningSoon(374696, nil, nil, nil, 1, 2)

local timerPunishment	= mod:NewCDTimer(40, 374696, nil, nil, nil, 3)
local StageTimer        = mod:NewPhaseTimer(125, nil, "Фаза: %d", nil, nil, 4)
local timerCDDA			= mod:NewCDTimer(40, 374699, nil, nil, nil, 4) -- Притяжение
local timerCdDB			= mod:NewCDTimer(40, 374706, nil, nil, nil, 3)
local timerDisire		= mod:NewCDTimer(40, 374693, nil, nil, nil, 3) --МК

--mod:AddSetIconOption("FAIcons", 41001, true)

mod:AddSetIconOption("SetIconOnFatalAttraction", 374699, true, false, { 3,4,5 })
mod:AddSetIconOption("SetIconOnDustructiveBond", 374706, true, false, { 3,4,5 })

mod:AddInfoFrameOption(374691, true)
mod.vb.prewarn_enrage = false
mod.vb.enrage = false
mod.vb.FatIcons = 5
mod.vb.Mobs = 0
mod.vb.Stage = 2

--mod:AddSliderOption("Slider", 1, 100, 1)
local StackBuff = DBM:GetSpellInfoNew(374691)
local RevCascTargets = {}

--mod:AddSliderOption("PassionThreshold1", 1, 100, 1, mod.Options.PassionThreshold1)


local function warnMindTargets(self)
	warnFA:Show(table.concat(RevCascTargets, "<, >"))
	table.wipe(RevCascTargets)
end

local aura = {
	[40880] = true,
	[40882] = true,
	[40883] = true,
	[40891] = true,
	[40896] = true,
	[40897] = true
}

function mod:OnCombatStart(delay)
	self.vb.prewarn_enrage = false
	self.vb.enrage = false
	self.vb.Mobs = 0
	self.vb.Stage = 2
--print("Start")
	--timerShriekCD:Start(15.8-delay)
	--timerFACD:Start(24.4-delay)
	--[[if self.Options.HealthFrame then
		DBM.BossHealth:Show(L.name)
		DBM.BossHealth:AddBoss(22841, "Воплощенное страдание")
		DBM.BossHealth:AddBoss(23421, "Воплощенное страдание")
	end]]
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	self:UnregisterShortTermEvents()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 41001 then
		warnFA:CombinedShow(1, args.destName)
		if args:IsPlayer() then
			specWarnFA:Show()
			specWarnFA:Play("scatter")
		end
		if self.Options.FAIcons then
			self:SetSortedIcon(1, args.destName, 1)
		end
	elseif args:IsSpellID(374701) then
		if args:IsPlayer() then
			specWarnDA:Show()
		end
	elseif args:IsSpellID(374707) then
		if args:IsPlayer() then
			specWarnFA:Show()
		end
		RevCascTargets[#RevCascTargets + 1] = args.destName
		if self.Options.SetIconOnDustructiveBond then
			-- self:SetIcon(args.destName, self.vb.RevCascIcons, 10)
			-- function module:SetSortedIcon(mod, sortType, delay, target, startIcon, maxIcon, descendingIcon, returnFunc, scanId)
			self:SetIcon(args.destName, self.vb.FatIcons)
		self.vb.FatIcons = self.vb.FatIcons - 1
		self:Unschedule(warnMindTargets)
		self:Schedule(0.1, warnMindTargets, self)
		end
	elseif args:IsSpellID(374690,374691) then
		--local maxStacksThreshold = mod.Options.PassionThreshold1
		if args:IsPlayer() then
			if ((args.amount or 1) >= 30) and self:AntiSpam(4, 2) and not self:IsTank() then
				specWarnPassion:Show(args.amount)
				if timerPunishment:GetRemaining() < 5 then
					specWarnPunishment:Show()
					specWarnPunishment:Play("aesoon")
				end
			end
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(StackBuff)
			DBM.InfoFrame:Show(30, "playerdebuffstacks", StackBuff, 2)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 41001 and self.Options.FAIcons then
		self:RemoveIcon(args.destName)
	elseif args:IsSpellID(374707) then
		if self.Options.SetIconOnDustructiveBond then
			self:RemoveIcon(args.destName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 374693 then
		timerDisire:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(374696) then
		timerPunishment:Start()
		self.vb.Mobs = 0
	elseif args:IsSpellID(374699) then
		timerCDDA:Start()
	elseif args:IsSpellID(374706) then
		timerCdDB:Start()
	end
end

function mod:RAID_BOSS_EMOTE(msg, source)
	if not self.vb.enrage and (source or "") == L.name then
		self.vb.enrage = true
	--	warnEnrage:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if UnitHealth(uId) / UnitHealthMax(uId) <= 0.23 and self:GetUnitCreatureId(uId) == 22947 and not self.vb.prewarn_enrage then
		self:UnregisterShortTermEvents()
		self.vb.prewarn_enrage = true
	end
end

--["40869-Fatal Attraction"] = "pull:24.4, 26.8, 28.0, 20.7, 21.9, 26.6, 22.0, 23.2, 23.0, 25.7, 26.6, 26.8, 25.6, 23.1, 26.8, 25.4",
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if self:AntiSpam(3, spellId) then
		if aura[spellId] then
			local spellName = DBM:GetSpellInfo(spellId)
			--timerAura:Start(spellName)
		elseif spellId == 40869 then--Cast event not in combat log, only applied and that can be resisted (especially on non timewalker). this ensures timer always exists
		--	timerFACD:Start()
		end
	end
end

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 24504 or self:GetCIDFromGUID(args.destGUID) == 90040 then
		self.vb.Mobs = self.vb.Mobs + 1
		--print("Stage "..self.vb.Stage.." complete ".. self.vb.Mobs)
		if self.vb.Mobs == self.vb.Stage then
		--	print("da")
			timerPunishment:Start(15)
			timerCDDA:Start(10)
			timerDisire:Start(15)
			timerCdDB:Start(35)
			StageTimer:Start(nil, 1)
			self.vb.Stage = self.vb.Stage + 1
			self.vb.Mobs = 0
		end
	--[[	if self.Options.HealthFrame then
			DBM.BossHealth:RemoveBoss(24504)
		end]]
	end
end