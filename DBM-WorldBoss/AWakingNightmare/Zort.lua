local mod	= DBM:NewMod("Zort", "DBM-WorldBoss", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("20220615151300"):sub(12, -3)) -- fxpw check 202206151120000
mod:SetCreatureID(50702)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 307829 307820 307818 307817 308520 308512 307845",
	"SPELL_CAST_SUCCESS 308520 307834",
	"SPELL_AURA_APPLIED 307815 307839 308517 307834 307833",
    "SPELL_AURA_APPLIED_DOSE 307815 307839 308517 307834 307833",
	-- "UNIT_TARGET",
    -- "SPELL_DAMAGE",
    -- "SPELL_PERIODIC_DAMAGE",
	"SPELL_AURA_REMOVED 307839 308516 308517",
	"SPELL_INTERRUPT 307829",
	-- "SPELL_CAST_FAILED",
    "UNIT_HEALTH",
	"UNIT_DIED"
	-- "SWING_DAMAGE"
)


local warnPhase2Soon   					= mod:NewPrePhaseAnnounce(2)
local warnPhase2     					= mod:NewPhaseAnnounce(2)
local warnPhase3Soon   					= mod:NewPrePhaseAnnounce(3)
local warnPhase3     					= mod:NewPhaseAnnounce(3)
local warnPech							= mod:NewTargetAnnounce(307814, 2)
local warnFlame							= mod:NewTargetAnnounce(307839, 2)
local warnSveaz							= mod:NewTargetAnnounce(308517, 3)
local warnkik							= mod:NewCastAnnounce(307829, 2)
local warnPriziv						= mod:NewCastAnnounce(307852, 3)
local warnShkval						= mod:NewCastAnnounce(307821, 3)
local warnTraitor						= mod:NewCountAnnounce(307814, 2, nil, false)
local warnInternalbleeding	    		= mod:NewStackAnnounce(307833, 2, nil, "Tank|Healer")
local warnInternalbgPre	    			= mod:NewPreWarnAnnounce(307833, 5, nil, nil, "Tank|Healer")
local specWarnBreathNightmare	    	= mod:NewSpecialWarningDispel(308512, "RemoveDisease", nil, nil, 1, 6)

local specWarnRazrsveaz 				= mod:NewSpecialWarning("KnopSv", 3)
local specCowardice	           			= mod:NewSpecialWarning("|cff71d5ff|Hspell:307834|hПечать: Трусость|h|r Бей босcа - Держи радиус 6 метров!")
local specWarnshkval					= mod:NewSpecialWarningGTFO(307821, nil, nil, nil, 1, 2)
local specWarnTraitor					= mod:NewSpecialWarningStack(307814, nil, 2, nil, nil, 1, 6)
local specWarnReturnInterrupt			= mod:NewSpecialWarningInterrupt(307829, "HasInterrupt", nil, 2, 1, 2)
local specWarnPechati					= mod:NewSpecialWarningCast(307814, nil, nil, nil, 1, 2) --предатель
local specWarnFlame						= mod:NewSpecialWarningMoveAway(307839, nil, nil, nil, 3, 2)
local specWarnSveaz						= mod:NewSpecialWarningYou(308516, nil, nil, nil, 3, 2)
local yellFlame							= mod:NewYell(307839, nil, nil, nil, "YELL") --Огонь
local yellFlameFade						= mod:NewShortFadesYell(307839, nil, nil, nil, "YELL")
local yellCastsvFade					= mod:NewShortFadesYell(308520)

local timerInternalbleeding	   			= mod:NewCDTimer(28, 307833)
local timerSveazi						= mod:NewCDTimer(28, 308517, nil, nil, nil, 2)
local timerPriziv						= mod:NewCDTimer(120, 307852, nil, nil, nil, 4)
local timerkik							= mod:NewCDTimer(15, 307829, nil, nil, nil, 3)
local timerShkval						= mod:NewCDTimer(20, 307821, nil, nil, nil, 3)
local timerCowardice	       			= mod:NewCDTimer(33, 307834)
local timerFlame		       			= mod:NewCDTimer(15, 307839)
local timerBreathNightmare	    		= mod:NewCDTimer(15, 308512)
local timerAmonstrousblow	   			= mod:NewCDTimer(15, 307845)

mod:AddSetIconOption("SetIconOnSveazTarget", 314606, true, true, {5, 6, 7})
mod:AddSetIconOption("SetIconOnFlameTarget", 307839, true, true, {1, 2})
mod:AddBoolOption("AnnounceSveaz", false)
mod:AddBoolOption("AnnounceFlame", false)
mod:AddBoolOption("AnnounceKnopk", false)
mod:AddBoolOption("RangeFrame", true)

local SveazTargets = {}
local FlameTargets = {}
local FlameIcons = 2
local SveazIcons = 7
local warned_preP = false
local warned_preP1 = false
local warned_preP2 = false
local warned_preP3 = false
local ShupPletidead = false
local Licdead = false
local ChudShupdead = false

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 50702, "Zort")
	mod:SetStage(1)
	timerkik:Start(-delay)
	timerShkval:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 50702, "Zort", wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(307829) then
		warnkik:Show()
		timerkik:Start()
		specWarnReturnInterrupt:Show()
	elseif args:IsSpellID(307820, 307818, 307817) then
		warnShkval:Show()
		timerShkval:Start()
		specWarnshkval:Show()
	elseif args:IsSpellID(308520) then
		yellCastsvFade:Countdown(308520)
	elseif  args:IsSpellID(307852) and self:AntiSpam(2) then
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
		if mod.Options.AnnounceKnopk then
			SendChatMessage(L.Razr, "SAY")
		end
	elseif args:IsSpellID(307834) then
		timerCowardice:Start()
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(307815) then
		if args:IsPlayer() and (args.amount or 1) >= 2 then
				specWarnTraitor:Show(args.amount)
				specWarnTraitor:Play("stackhigh")
		end
	elseif args:IsSpellID(307839) then
		FlameTargets[#FlameTargets + 1] = args.destName
		self:ScheduleMethod(0.1, "SetFlameIcons")
		if args:IsPlayer() then
			specWarnFlame:Show()
			yellFlame:Yell()
			yellFlameFade:Countdown(307839)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(12)
			end
		end
	elseif args:IsSpellID(308517) then
		SveazTargets[#SveazTargets + 1] = args.destName
		self:ScheduleMethod(0.1, "SetSveazIcons")
		timerSveazi:Start()
		if args:IsPlayer() and self:AntiSpam(2) then
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
		FlameIcons = 2
		if self.Options.SetIconOnFlameTarget then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
	 end
	elseif args:IsSpellID(308516, 308517) then
		if self.Options.SetIconOnSveazTarget then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:CHAT_MSG_SAY(msg)
	if strmatch(msg, L.Razr) then
		specWarnRazrsveaz:Show()
	end
end

function mod:SPELL_INTERRUPT(args)
	if  args:IsSpellID(307829) then
	timerkik:Start()
	specWarnReturnInterrupt:Show()
	end
end

do
	local function sort_by_group(v1, v2)
		return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	end
	function mod:SetFlameIcons()
		table.sort(FlameTargets, sort_by_group)
		for v in ipairs(FlameTargets) do
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
			for v in ipairs(SveazTargets) do
				if mod.Options.AnnounceSveaz then
					if DBM:GetRaidRank() > 0 then
						SendChatMessage(L.Sveaz:format(SveazIcons, UnitName(v)), "RAID_WARNING")
					else
						SendChatMessage(L.Sveaz:format(SveazIcons, UnitName(v)), "RAID")
					end
				end
				if self.Options.SetIconOnSveazTarget then
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
end


function mod:UNIT_HEALTH(uId)
	local cid = self:GetUnitCreatureId(uId)
		if self.vb.phase == 1 and not warned_preP and cid == 50702 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.73 then
			warned_preP = true
			warnPhase2Soon:Show()
		end
		if self.vb.phase == 1 and not warned_preP1 and cid == 50702 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.70 then
			warned_preP1 = true
			mod:SetStage(2)
			warnPhase2:Show()
		end
		if self.vb.phase == 2 and not warned_preP2 and cid == 50702 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.43 then
			warned_preP2 = true
			warnPhase3Soon:Show()
		end
		if self.vb.phase == 2 and not warned_preP3 and cid == 50702 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.40 then
			warned_preP3 = true
			mod:SetStage(3)
			warnPhase3:Show()
		end
end

function mod:UNIT_DIED(args)
	if args.destName == L.Cudo then
		timerCowardice:Start(10)
		timerFlame:Start(5)
	elseif args.destName == L.Lic then
		timerCowardice:Cancel()
		timerPriziv:Start(10)
		timerSveazi:Start(20)
		timerAmonstrousblow:Start(24)
	elseif args.destName == L.Shup then
		timerPriziv:Cancel()
		timerSveazi:Cancel()
		timerBreathNightmare:Start()
		timerInternalbleeding:Start(64)
		warnInternalbgPre:Schedule(59)
		timerShkval:Start(60)
 end
end