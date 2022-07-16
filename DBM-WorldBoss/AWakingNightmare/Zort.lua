local mod = DBM:NewMod("Zort", "DBM-WorldBoss", 2)
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220628193500")
mod:SetCreatureID(50702)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat", 50702)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 307829 307820 307818 307817 308520 307852 308512 307845",
	"SPELL_CAST_SUCCESS 308520 307834 318956",
	"SPELL_AURA_APPLIED 307815 307839 307842 308512 308517 308620 308515 307834 307833",
	"SPELL_AURA_APPLIED_DOSE 307815 307839 307842 308512 308517 308620 308515 307834 307833",
	"UNIT_TARGET",
	"SPELL_DAMAGE",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_AURA_REMOVED 307839 308516 308517 318956",
	"SPELL_INTERRUPT 307829",
	"SPELL_CAST_FAILED",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"SWING_DAMAGE"
)

mod:AddTimerLine(L.name)
local warnPhase2Soon          = mod:NewPrePhaseAnnounce(2)
local warnPhase2              = mod:NewPhaseAnnounce(2)
local warnPhase3Soon          = mod:NewPrePhaseAnnounce(3)
local warnPhase3              = mod:NewPhaseAnnounce(3)
local warnPhase4              = mod:NewPhaseAnnounce(4)
--local warnPech							= mod:NewTargetAnnounce(307814, 2)
local warnFlame               = mod:NewTargetAnnounce(307839, 2)
local warnSveaz               = mod:NewTargetAnnounce(308620, 3)
--local warnkik							= mod:NewCastAnnounce(307829, 2)
--local warnShkval						= mod:NewCastAnnounce(307821, 3)
local warnTraitor             = mod:NewCountAnnounce(307814, 2, nil, false)
local warnInternalbleeding    = mod:NewStackAnnounce(307833, 2, nil, "Tank|Healer")
local warnInternalbgPre       = mod:NewPreWarnAnnounce(307833, 5, nil, nil, "Tank|Healer")
local specWarnBreathNightmare = mod:NewSpecialWarningDispel(308512, "RemoveDisease", nil, nil, 1, 6)

local specWarnRazrsveaz       = mod:NewSpecialWarning("KnopSv", 3)
local specCowardice           = mod:NewSpecialWarning("|cff71d5ff|Hspell:307834|hПечать: Трусость|h|r Бей босcа - Держи радиус 6 метров!"
	, 3)
local specwarnHp1             = mod:NewSpecialWarning("Hp1", 3)
local specwarnHp2             = mod:NewSpecialWarning("Hp2", 3)
local specwarnHp3             = mod:NewSpecialWarning("Hp3", 3)
local specWarnshkval          = mod:NewSpecialWarningGTFO(307821, nil, nil, nil, 1, 2)
local specWarnTraitor         = mod:NewSpecialWarningStack(307814, nil, 2, nil, nil, 1, 6)
local specWarnReturnInterrupt = mod:NewSpecialWarningInterrupt(307829, "HasInterrupt", nil, 2, 1, 2)
--local specWarnPechati					= mod:NewSpecialWarningCast(307814, nil, nil, nil, 1, 2) --предатель
local specWarnFlame           = mod:NewSpecialWarningMoveAway(307839, nil, nil, nil, 3, 2)
local specWarnFlame2          = mod:NewSpecialWarningMoveAway(307861, nil, nil, nil, 3, 2)
local specWarnSveaz           = mod:NewSpecialWarningYou(308620, nil, nil, nil, 3, 2)
local yellFlame               = mod:NewYell(307839, nil, nil, nil, "YELL") --Огонь
local yellFlameFade           = mod:NewShortFadesYell(307839, nil, nil, nil, "YELL")
local yellCastsvFade          = mod:NewShortFadesYell(308520)

local timerInternalbleeding = mod:NewCDTimer(26, 307833)
local timerSveazi           = mod:NewCDTimer(28, 308620, nil, nil, nil, 2)
local timerkik              = mod:NewCDTimer(15, 307829, nil, nil, nil, 3)
local timerShkval           = mod:NewCDTimer(20, 307821, nil, nil, nil, 3)
local timerCowardice        = mod:NewCDTimer(33, 307834)
local timerFlame            = mod:NewCDTimer(15, 307839)
local timerBreathNightmare  = mod:NewCDTimer(15, 308512)
local timerAmonstrousblow   = mod:NewCDTimer(15, 307845)
local timerCDChep           = mod:NewCDTimer(6, 308520)

mod:AddTimerLine(DBM_COMMON_L.ADDS)
local warnPriziv  = mod:NewCastAnnounce(307852, 3)
local timerTrees  = mod:NewCDTimer(5, 307852, nil, nil, nil, 4)
local timerPriziv = mod:NewCDTimer(120, 307852, nil, nil, nil, 4)

mod:AddSetIconOption("SetIconOnSveazTarget", 314606, true, true, { 5, 6, 7 })
mod:AddSetIconOption("SetIconOnFlameTarget", 307839, true, true, { 1, 2 })
mod:AddBoolOption("AnnounceSveaz", false)
mod:AddBoolOption("AnnounceFlame", false)
mod:AddBoolOption("AnnounceKnopk", false)
mod:AddBoolOption("Testicepi", true)
mod:AddBoolOption("AnnounceOFF", false)
mod:AddBoolOption("RangeFrame", true)
mod:AddInfoFrameOption(308620, true)

local SveazTargets = {}
local FlameTargets = {}
mod.vb.FlameIcons = 2
mod.vb.SveazIcons = 7
local warned_kill1 = false
local warned_kill2 = false
local warned_kill3 = false
local warned_P2 = false
local warned_P3 = false
local warned_P4 = false
local warned_P5 = false

local Trees = {}
local Trees_HP = {}
local Trees_num = 1

local function warnSveazTargets(self)
	warnSveaz:Show(table.concat(SveazTargets, "<, >"))
	table.wipe(SveazTargets)
	self.vb.SveazIcons = 7
end

local function warnFlameTargets(self)
	warnFlame:Show(table.concat(FlameTargets, "<, >"))
	table.wipe(FlameTargets)
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 50702, "Zort")
	mod:SetStage(1)
	self.vb.SveazIcons = 7
	timerkik:Start(-delay)
	timerShkval:Start(-delay)
	Trees_num = 1
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 50702, "Zort", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	DBM.BossHealth:Clear()
	-- Trees_num = 1
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(307829) then
		--warnkik:Show()
		timerkik:Start()
		specWarnReturnInterrupt:Show()
	elseif args:IsSpellID(307820, 307818, 307817) then
		--warnShkval:Show()
		timerShkval:Start()
		specWarnshkval:Show(args.spellName)
	elseif args:IsSpellID(308520) then
		yellCastsvFade:Countdown(308520)
	elseif args:IsSpellID(307852) and self:AntiSpam(2) then
		warnPriziv:Show()
		timerPriziv:Start()
	elseif args:IsSpellID(308512) then
		specWarnBreathNightmare:Show()
		timerBreathNightmare:Start(30)
	elseif args:IsSpellID(307845) then
		timerAmonstrousblow:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(308520) then
		timerCDChep:Start()
		if mod.Options.AnnounceKnopk then
			SendChatMessage(L.Razr, "SAY")
		end
	elseif args:IsSpellID(307834) then
		timerCowardice:Start()
	elseif args:IsSpellID(318956) then
		mod:SetStage(3)
		self:NewPhaseAnnounce(3)
		timerCowardice:Cancel()
		timerPriziv:Start(10)
		timerSveazi:Start(20)
		timerAmonstrousblow:Start(24)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(307815) then
		if args:IsPlayer() and (args.amount or 1) >= 2 then
			specWarnTraitor:Show(args.amount)
			specWarnTraitor:Play("stackhigh")
		end
	elseif args:IsSpellID(307839, 307842) then
		FlameTargets[#FlameTargets + 1] = args.destName
		if self.Options.SetIconOnFlameTarget and self.vb.FlameIcons > 0 then
			self:SetIcon(args.destName, self.vb.FlameIcons, 10)
		end
		DBM.Nameplate:Show(args.destGUID, 307839)
		self.vb.FlameIcons = self.vb.FlameIcons - 1
		self:Unschedule(warnFlameTargets)
		self:Schedule(0.3, warnFlameTargets, self)
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(10, "playerdebuffremaining", 307839)
		end
		if args:IsPlayer() then
			specWarnFlame:Show()
			yellFlame:Yell()
			yellFlameFade:Countdown(307839)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(12)
			end
		end
	elseif args:IsSpellID(308512) and self:AntiSpam(3) then
		specWarnBreathNightmare:Show()
		timerBreathNightmare:Start(45)
	elseif args:IsSpellID(307861) then
		if args:IsPlayer() then
			specWarnFlame2:Show()
		end
	elseif args:IsSpellID(308517, 308620, 308515) then
		SveazTargets[#SveazTargets + 1] = args.destName
		if self.Options.SetIconOnSveazTarget and self.vb.SveazIcons > 0 then
			self:SetIcon(args.destName, self.vb.SveazIcons, 10)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(15, "playerdebuffremaining", 308620)
		end
		self.vb.SveazIcons = self.vb.SveazIcons - 1
		self:Unschedule(warnSveazTargets)
		self:Schedule(0.3, warnSveazTargets, self)
		timerSveazi:Start()
		if args:IsPlayer() then
			specWarnSveaz:Show()
		end
	elseif args:IsSpellID(307834) then
		if args:IsPlayer() then
			specCowardice:Show()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(6)
			end
		end
	elseif args:IsSpellID(307833) then
		timerInternalbleeding:Start()
		warnInternalbleeding:Show(args.destName, args.amount or 1)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(307839) then
		self.vb.FlameIcons = 2
		if self.Options.SetIconOnFlameTarget then
			self:SetIcon(args.destName, 0)
		end
		DBM.Nameplate:Hide(args.destGUID, 307839)
	elseif args:IsSpellID(308516, 308517) then
		if self.Options.SetIconOnSveazTarget then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(318956) and not warned_P4 then
		self:NewPhaseAnnounce(4)
		warned_P4 = true
		timerPriziv:Cancel()
		timerSveazi:Cancel()
		timerBreathNightmare:Start()
		timerInternalbleeding:Start(64)
		warnInternalbgPre:Schedule(59)
		timerShkval:Start(60)
	end
end

function mod:CHAT_MSG_SAY(msg)
	if strmatch(msg, L.Razr) and mod.Options.AnnounceOFF then
		specWarnRazrsveaz:Show()
	end
end

function mod:SPELL_INTERRUPT(args)
	if args:IsSpellID(307829) then
		timerkik:Start()
		specWarnReturnInterrupt:Show()
	end
end

--[[
local function Chepi()
	local start, duration = GetSpellCooldown(308520);
	if (start > 1 and duration > 1) then
		timerCDChep:Update(0, start + duration - GetTime())
	else
		SendChatMessage("Цепь готова", "RAID");
	end
end]]

--[[
do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	end

	function mod:SetFlameIcons()
		table.sort(FlameTargets, sort_by_group)
		for _, v in ipairs(FlameTargets) do
			if mod.Options.AnnounceFlame then
				if DBM:GetRaidRank() > 0 and self:AntiSpam(3) then
					SendChatMessage(L.Flame:format(FlameIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.Flame:format(FlameIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnFlameTarget then
				self:SetIcon(UnitName(v), FlameIcons, 15)
			end
			FlameIcons = FlameIcons - 1
		end
		warnFlame:Show(table.concat(FlameTargets, "<, >"))
		table.wipe(FlameTargets)
	end

	function mod:SetSveazIcons()
		if DBM:GetRaidRank() >= 0 then
			table.sort(SveazTargets, sort_by_group)
			for _, v in ipairs(SveazTargets) do
				if mod.Options.AnnounceSveaz then
					if DBM:GetRaidRank() > 0 then
						SendChatMessage(L.Sveaz:format(SveazIcons, UnitName(v)), "RAID_WARNING")
					else
						SendChatMessage(L.Sveaz:format(SveazIcons, UnitName(v)), "RAID")
					end
				end
				if self.Options.SetIconOnSveazTarget and SveazIcons > 0 then
					self:SetIcon(UnitName(v), SveazIcons, 10)
				end
				SveazIcons = SveazIcons - 1
			end
		end
		if #SveazTargets >= 3 then
			warnSveaz:Show(table.concat(SveazTargets, "<, >"))
			table.wipe(SveazTargets)
			SveazIcons = 7
		end
	end
end]]

function mod:UNIT_HEALTH(guid)
	local uid = self:GetUnitCreatureId(guid)
	if self.vb.phase == 1 and not warned_kill1 and uid == 50702 and DBM:GetBossHP(50702) <= 73 then
		mod:SetStage(2)
		warned_kill1 = true
		specwarnHp1:Show()
	end
	if self.vb.phase == 2 and not warned_kill2 and uid == 50702 and DBM:GetBossHP(50702) <= 43 then
		mod:SetStage(3)
		warned_kill2 = true
		specwarnHp2:Show()
	end
	if self.vb.phase == 3 and not warned_kill2 and(
			(uid == 50716 and DBM:GetBossHP(50716) <= 1) or	(uid == 50715 and DBM:GetBossHP(50715) <= 98)) then
		warned_kill2 = true
		specwarnHp3:Show()
	end
end

function mod:UNIT_DIED(args)
	if args.destName == L.Cudo then
		timerCowardice:Start(10)
		timerFlame:Start(5)
		warnPhase2:Show()
	elseif args.destName == L.Lic then
		timerCowardice:Cancel()
		timerPriziv:Start(10)
		timerSveazi:Start(20)
		timerAmonstrousblow:Start(24)
		warnPhase3:Show()
	elseif args.destName == L.Shup then
		warnPhase4:Show()
		timerPriziv:Cancel()
		timerSveazi:Cancel()
		timerBreathNightmare:Start()
		timerInternalbleeding:Start(64)
		warnInternalbgPre:Schedule(59)
		timerShkval:Start(60)
	end
end

mod:RegisterOnUpdateHandler(function(self)
	if not self:IsInCombat() then return end
	for uId in DBM:GetGroupMembers() do
		local target = uId .. "target"

		if self:GetUnitCreatureId(target) == 50707 then
			local targetGUID = UnitGUID(target)

			if not Trees[targetGUID] then
				if targetGUID then
					Trees[targetGUID] = L.Tree .. " №" .. Trees_num
					do
						local last = 100
						local function getTreesPercent()
							local trackingGUID = targetGUID
							for uId2 in DBM:GetGroupMembers() do
								local unitId = uId2 .. "target"
								if trackingGUID == UnitGUID(unitId) and mod:GetCIDFromGUID(trackingGUID) == 50707 then
									last = math.floor(UnitHealth(unitId) / UnitHealthMax(unitId) * 100)
									if trackingGUID then
										Trees_HP[trackingGUID] = last
										return last
									end
								end
							end
							return Trees_HP[trackingGUID]
						end

						DBM.BossHealth:AddBoss(getTreesPercent, Trees[targetGUID])
					end
					Trees_num = Trees_num + 1
				end
			end
		end
	end
end, 0.1)
