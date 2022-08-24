local mod	= DBM:NewMod("Deathwhisper", "DBM-Icecrown", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220702001333")
mod:SetCreatureID(36855)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 71289 71001 72108 72109 72110 71237 70674 71204",
	"SPELL_AURA_APPLIED_DOSE 71204",
	"SPELL_AURA_REMOVED 70842 71289",
	"SPELL_CAST_START 71420 72007 72501 72502 70900 70901 72499 72500 72497 72496",
	"SPELL_CAST_SUCCESS 71289",
	"SPELL_INTERRUPT",
	"SPELL_SUMMON 71426",
	"SWING_DAMAGE",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_TARGET"
)


-- General
local specWarnWeapons				= mod:NewSpecialWarning("WeaponsStatus", false)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:RemoveOption("HealthFrame")
mod:AddBoolOption("ShieldHealthFrame", false, "misc")
mod:AddBoolOption("RemoveDruidBuff", false, "misc")

-- Adds
mod:AddTimerLine(DBM_COMMON_L.ADDS)
local warnAddsSoon					= mod:NewAnnounce("WarnAddsSoon", 2)
local warnReanimating				= mod:NewAnnounce("WarnReanimating", 3)
local warnDeathDecay				= mod:NewSpellAnnounce(72108, 2)
local warnDarkTransformation		= mod:NewSpellAnnounce(70900, 4)
local warnDarkEmpowerment			= mod:NewSpellAnnounce(70901, 4)

local specWarnVampricMight			= mod:NewSpecialWarningDispel(70674, "MagicDispeller", nil, nil, 1, 2)
local specWarnDarkMartyrdom			= mod:NewSpecialWarningRun(71236, "Melee", nil, nil, 4, 2)

local timerAdds						= mod:NewTimer(60, "TimerAdds", 61131, nil, nil, 1, DBM_COMMON_L.TANK_ICON)

-- Boss
mod:AddTimerLine(L.name)
-- Stage One
mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(1))
local warnDominateMind				= mod:NewTargetAnnounce(71289, 3)

local specWarnDeathDecay			= mod:NewSpecialWarningGTFO(71001, nil, nil, nil, 1, 8)

local timerDominateMind				= mod:NewBuffActiveTimer(12, 71289)
local timerDominateMindCD			= mod:NewCDTimer(40, 71289, nil, nil, nil, 3)

mod:AddInfoFrameOption(70842, false)
mod:AddSetIconOption("SetIconOnDeformedFanatic", 70900, true, true, {8})
mod:AddSetIconOption("SetIconOnEmpoweredAdherent", 70901, true, true, {7})
mod:AddSetIconOption("SetIconOnDominateMind", 71289, true, false, {4, 5, 6})

-- Stage Two
mod:AddTimerLine(DBM_CORE_L.SCENARIO_STAGE:format(2))
local warnSummonSpirit				= mod:NewSpellAnnounce(71426, 2)
local warnPhase2					= mod:NewPhaseAnnounce(2, 1, nil, nil, nil, nil, nil, 2)
local warnTouchInsignificance		= mod:NewStackAnnounce(71204, 2, nil, "Tank|Healer")

local specWarnCurseTorpor			= mod:NewSpecialWarningYou(71237, nil, nil, nil, 1, 2)
local specWarnTouchInsignificance	= mod:NewSpecialWarningStack(71204, nil, 3, nil, nil, 1, 6)
local specWarnFrostbolt				= mod:NewSpecialWarningInterrupt(72007, "HasInterrupt", nil, 2, 1, 2)
local specWarnVengefulShade			= mod:NewSpecialWarning("SpecWarnVengefulShade", true, nil, nil, nil, 1, 2, nil, 71426, 71426)

local timerSummonSpiritCD			= mod:NewCDTimer(10, 71426, nil, true, 2)
local timerFrostboltCast			= mod:NewCastTimer(2, 72007, nil, "HasInterrupt")
local timerTouchInsignificance		= mod:NewTargetTimer(30, 71204, nil, "Tank|Healer", nil, 5)

local soundWarnSpirit				= mod:NewSound(71426)

local dominateMindTargets = {}
mod.vb.dominateMindIcon = 6
local deformedFanatic
local empoweredAdherent
local shieldName = DBM:GetSpellInfo(70842)
local lastDD = 0
local bband = bit.band
local isHunter = select(2, UnitClass("player")) == "HUNTER"

local RaidWarningFrame = RaidWarningFrame
local GetFramesRegisteredForEvent, RaidNotice_AddMessage = GetFramesRegisteredForEvent, RaidNotice_AddMessage
local function selfWarnMissingSet()
	if mod.Options.EqUneqWeapons and mod:IsHeroic() and not mod:IsEquipmentSetAvailable("pve") then
		for i = 1, select("#", GetFramesRegisteredForEvent("CHAT_MSG_RAID_WARNING")) do
			local frame = select(i, GetFramesRegisteredForEvent("CHAT_MSG_RAID_WARNING"))
			if frame.AddMessage then
				frame.AddMessage(frame, L.setMissing)
			end
		end
		RaidNotice_AddMessage(RaidWarningFrame, L.setMissing, ChatTypeInfo["RAID_WARNING"])
	end
end

mod:AddMiscLine(L.EqUneqLineDescription)
mod:AddBoolOption("EqUneqWeapons", mod:IsDps(), nil, selfWarnMissingSet)
mod:AddBoolOption("EqUneqTimer", false)
mod:AddBoolOption("BlockWeapons", false)

local function selfSchedWarnMissingSet(self)
	if self.Options.EqUneqWeapons and self:IsHeroic() and not self:IsEquipmentSetAvailable("pve") then
		for i = 1, select("#", GetFramesRegisteredForEvent("CHAT_MSG_RAID_WARNING")) do
			local frame = select(i, GetFramesRegisteredForEvent("CHAT_MSG_RAID_WARNING"))
			if frame.AddMessage then
				self:Schedule(10, frame.AddMessage, frame, L.setMissing)
			end
		end
		self:Schedule(10, RaidNotice_AddMessage, RaidWarningFrame, L.setMissing, ChatTypeInfo["RAID_WARNING"])
	end
end
mod:Schedule(0.5, selfSchedWarnMissingSet, mod) -- mod options default values were being read before SV ones, so delay this

local function has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function mod:UnW()
	if self.Options.EqUneqWeapons and not self.Options.BlockWeapons and self:IsEquipmentSetAvailable("pve") then
		PickupInventoryItem(16)
		PutItemInBackpack()
		PickupInventoryItem(17)
		PutItemInBackpack()
		DBM:Debug("MH and OH unequipped",2)
		if isHunter then
			PickupInventoryItem(18)
			PutItemInBackpack()
			DBM:Debug("Ranged unequipped",2)
		end
	end
end

function mod:EqW()
	if self.Options.EqUneqWeapons and not self.Options.BlockWeapons and self:IsEquipmentSetAvailable("pve") then
		DBM:Debug("trying to equip pve",1)
		UseEquipmentSet("pve")
		if not self:IsTank() then
			CancelUnitBuff("player", (GetSpellInfo(25780))) -- Righteous Fury
		end
	end
end

function mod:RemoveBuffs() -- Spell is removed based on name so no longer need SpellID for each rank
	CancelUnitBuff("player", (GetSpellInfo(48469)))		-- Mark of the Wild
	CancelUnitBuff("player", (GetSpellInfo(48470)))		-- Gift of the Wild
	CancelUnitBuff("player", (GetSpellInfo(69381)))		-- Drums of the Wild
	CancelUnitBuff("player", (GetSpellInfo(48170)))		-- Prayer of Shadow Protection
end

local function showDominateMindWarning(self)
	warnDominateMind:Show(table.concat(dominateMindTargets, "<, >"))
	timerDominateMind:Start()
	timerDominateMindCD:Start()
	if (not has_value(dominateMindTargets,UnitName("player")) and self.Options.EqUneqWeapons and self:IsDps()) then
		DBM:Debug("Equipping scheduled",1)
		self:ScheduleMethod(0.1, "EqW")
		self:ScheduleMethod(1.7, "EqW")
		self:ScheduleMethod(3.3, "EqW")
		self:ScheduleMethod(5.5, "EqW")
		self:ScheduleMethod(7.5, "EqW")
		self:ScheduleMethod(9.9, "EqW")
	end
	table.wipe(dominateMindTargets)
	self.vb.dominateMindIcon = 6
	if self.Options.EqUneqWeapons and self:IsDps() and self.Options.EqUneqTimer then
		self:ScheduleMethod(39, "UnW")
	end
end

local function addsTimer(self)
	timerAdds:Cancel()
	warnAddsSoon:Cancel()
	if self:IsHeroic() then
		warnAddsSoon:Schedule(40)	-- 5 secs prewarning
		self:Schedule(45, addsTimer, self)
		timerAdds:Start(45)
	else
		warnAddsSoon:Schedule(55)	-- 5 secs prewarning
		self:Schedule(60, addsTimer, self)
		timerAdds:Start()
	end
end

local function TrySetTarget(self)
	if DBM:GetRaidRank() >= 1 then
		for i = 1, GetNumRaidMembers() do
			local uId = "raid"..i
			if UnitGUID(uId.."target") == deformedFanatic and self.Options.SetIconOnDeformedFanatic then
				deformedFanatic = nil
				self:SetIcon(uId.."target", 8)
			elseif UnitGUID(uId.."target") == empoweredAdherent and self.Options.SetIconOnEmpoweredAdherent then
				empoweredAdherent = nil
				self:SetIcon(uId.."target", 7)
			end
			if not (deformedFanatic or empoweredAdherent) then
				break
			end
		end
	end
end
-- mod:SetStage(0)
function mod:OnCombatStart(delay)
	self:SetStage(1)
	if self.Options.ShieldHealthFrame then
		DBM.BossHealth:Show(L.name)
		DBM.BossHealth:AddBoss(36855, L.name)
		self:ScheduleMethod(0.5, "CreateShildHPFrame")
	end
	berserkTimer:Start(-delay)
	timerAdds:Start(5.5)
	warnAddsSoon:Schedule(2.5)			-- 3sec pre-warning on start
	self:Schedule(5.5, addsTimer, self)
	if not self:IsDifficulty("normal10") then
		timerDominateMindCD:Start(27.5)		-- Sometimes 1 fails at the start, then the next will be applied 70 secs after start ?? :S
		if self.Options.RemoveDruidBuff then  -- Edit to automaticly remove Mark/Gift of the Wild on entering combat
			self:ScheduleMethod(24, "RemoveBuffs")
		end
		if self.Options.EqUneqWeapons and self:IsDps() and self.Options.EqUneqTimer then
			specWarnWeapons:Show()
			self:ScheduleMethod(26.5, "UnW")
		end
	end
	table.wipe(dominateMindTargets)
	self.vb.dominateMindIcon = 6
	deformedFanatic = nil
	empoweredAdherent = nil
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(shieldName)
		DBM.InfoFrame:Show(1, "enemypower", 2)
	end
end

function mod:OnCombatEnd()
	DBM.BossHealth:Clear()
	self:UnscheduleMethod("UnW")
	self:UnscheduleMethod("EqW")
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

do	-- add the additional Shield Bar
	local last = 100
	local function getShieldPercent()

		local unitId = "boss1"
		local guid = UnitGUID(unitId)
		if mod:GetCIDFromGUID(guid) == 36855 then
			last = math.floor(UnitMana(unitId)/UnitManaMax(unitId) * 100)
			return last
		end

		unitId = "boss1"
		guid = UnitGUID(unitId)
		if mod:GetCIDFromGUID(guid) == 36855 then
			last = math.floor(UnitMana(unitId)/UnitManaMax(unitId) * 100)
			return last
		end

		for i = 0, GetNumRaidMembers(), 1 do
			unitId = ((i == 0) and "target") or ("raid"..i.."target")
			guid = UnitGUID(unitId)
			if mod:GetCIDFromGUID(guid) == 36855 then
				last = math.floor(UnitMana(unitId)/UnitManaMax(unitId) * 100)
				return last
			end
		end

		return last
	end
	function mod:CreateShildHPFrame()
		DBM.BossHealth:AddBoss(getShieldPercent, L.ShieldPercent)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 71289 then
		dominateMindTargets[#dominateMindTargets + 1] = args.destName
		if self.Options.SetIconOnDominateMind then
			self:SetIcon(args.destName, self.vb.dominateMindIcon, 12)
		end
		self.vb.dominateMindIcon = self.vb.dominateMindIcon - 1
		self:Unschedule(showDominateMindWarning)
		if self:IsDifficulty("heroic10", "normal25") or (self:IsDifficulty("heroic25") and #dominateMindTargets >= 3) then
			showDominateMindWarning(self)
		else
			self:Schedule(0.9, showDominateMindWarning, self)
		end
	elseif args:IsSpellID(71001, 72108, 72109, 72110) then
		if args:IsPlayer() then
			specWarnDeathDecay:Show()
			specWarnDeathDecay:Play("watchfeet")
		end
		if (GetTime() - lastDD > 5) then
			warnDeathDecay:Show()
			lastDD = GetTime()
		end
	elseif spellId == 71237 and args:IsPlayer() then
		specWarnCurseTorpor:Show()
		specWarnCurseTorpor:Play("targetyou")
	elseif spellId == 70674 and not args:IsDestTypePlayer() and (UnitName("target") == L.Fanatic1 or UnitName("target") == L.Fanatic2 or UnitName("target") == L.Fanatic3) then
		specWarnVampricMight:Show(args.destName)
		specWarnVampricMight:Play("helpdispel")
	elseif spellId == 71204 then
		timerTouchInsignificance:Start(args.destName)
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 3 then
			specWarnTouchInsignificance:Show(amount)
			specWarnTouchInsignificance:Play("stackhigh")
		else
			warnTouchInsignificance:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 70842 then
		self:SetStage(2)
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		timerSummonSpiritCD:Start(12)
		timerAdds:Cancel()
		warnAddsSoon:Cancel()
		self:Unschedule(addsTimer)
		if self:IsHeroic() then	-- Edited from retail
			timerAdds:Start(45)
			warnAddsSoon:Schedule(40) -- 5 secs prewarning
			self:Schedule(45, addsTimer, self)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
    elseif args:IsSpellID(71289) then
		if (args.destName == UnitName("player") or args:IsPlayer()) and self.Options.EqUneqWeapons and self:IsDps() then
	        self:ScheduleMethod(0.1, "EqW")
	        self:ScheduleMethod(1.7, "EqW")
	        self:ScheduleMethod(3.3, "EqW")
			self:ScheduleMethod(5.0, "EqW")
			self:ScheduleMethod(8.0, "EqW")
			self:ScheduleMethod(9.9, "EqW")
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if args:IsSpellID(71420, 72007, 72501, 72502) then
		specWarnFrostbolt:Show(args.sourceName)
		specWarnFrostbolt:Play("kickcast")
		timerFrostboltCast:Start()
	elseif spellId == 70900 then
		warnDarkTransformation:Show()
		if self.Options.SetIconOnDeformedFanatic then
			deformedFanatic = args.sourceGUID
			TrySetTarget(self)
		end
	elseif spellId == 70901 then
		warnDarkEmpowerment:Show()
		if self.Options.SetIconOnEmpoweredAdherent then
			empoweredAdherent = args.sourceGUID
			TrySetTarget(self)
		end
	elseif args:IsSpellID(72499, 72500, 72497, 72496) then
		specWarnDarkMartyrdom:Show()
		specWarnDarkMartyrdom:Play("justrun")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 71289 then
		timerDominateMindCD:Start()
		DBM:Debug("MC on "..args.destName,2)
		if self.Options.EqUneqWeapons and args.destName == UnitName("player") and self:IsDps() then
			self:UnW()
			self:UnW()
			self:ScheduleMethod(0.01, "UnW")
			DBM:Debug("Unequipping",2)
		end
	end
end
local extraSpellIds = {
	[71420]= true,
	[72007]= true,
	[72501]= true,
	[72502]= true
}
function mod:SPELL_INTERRUPT(args)
	if type(args.extraSpellId) == "number" and extraSpellIds[args.extraSpellId] then
		timerFrostboltCast:Cancel()
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 71426 and self:AntiSpam(5, 1) then -- Summon Vengeful Shade
		warnSummonSpirit:Show()
		timerSummonSpiritCD:Start()
		soundWarnSpirit:Play("Interface\\AddOns\\DBM-Core\\sounds\\RaidAbilities\\spirits.mp3")
	end
end

function mod:SWING_DAMAGE(sourceGUID, _, _, _,_,destFrag)
	if (bband(destFrag, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(destFrag, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0) and self:GetCIDFromGUID(sourceGUID) == 38222 then
		specWarnVengefulShade:Show()
		specWarnVengefulShade:Play("targetyou")
	end
end

-- function mod:UNIT_TARGET_UNFILTERED()
-- 	if empoweredAdherent or deformedFanatic then
-- 		TrySetTarget(self)
-- 	end
-- end
function mod:UNIT_TARGET()
	if empoweredAdherent or deformedFanatic then
		TrySetTarget(self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellReanimatedFanatic or msg:find(L.YellReanimatedFanatic) then
		warnReanimating:Show()
	end
end