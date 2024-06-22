local mod = DBM:NewMod("Zort", "DBM-WorldBoss", 2)
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220628193500")
mod:SetCreatureID(50702)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat", 50702)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 307829 307820 307818 307817 308520 307852 308512 307845",
	"SPELL_CAST_SUCCESS 308520 307834 318956",
	"SPELL_AURA_APPLIED 307815 307839 307842 308512 307861 308517 308620 308515 307834 307833",
	"SPELL_AURA_APPLIED_DOSE 307815 307839 307842 308512 308517 307861 308620 308515 307834 307833",
	"SPELL_AURA_REMOVED 307839 308516 308517 318956 307861",
	"SPELL_INTERRUPT 307829",
	"UNIT_HEALTH"
)
--[[mod:RegisterEventsInCombat(
	"UNIT_HEALTH"
)]]
mod:AddTimerLine(L.name)
-- local warnPhase2Soon          = mod:NewPrePhaseAnnounce(2)
-- local warnPhase2              = mod:NewPhaseAnnounce(2)
-- local warnPhase3Soon          = mod:NewPrePhaseAnnounce(3)
-- local warnPhase3              = mod:NewPhaseAnnounce(3)
-- local warnPhase4              = mod:NewPhaseAnnounce(4)
--local warnPech							= mod:NewTargetAnnounce(307814, 2)
local warnFlame               = mod:NewTargetAnnounce(307839, 2)
local warnFlame2              = mod:NewTargetAnnounce(307861, 2)
local warnSveaz               = mod:NewTargetAnnounce(308620, 3)
--local warnkik							= mod:NewCastAnnounce(307829, 2)
--local warnShkval						= mod:NewCastAnnounce(307821, 3)
-- local warnTraitor             = mod:NewCountAnnounce(307814, 2, nil, false)
local warnInternalbleeding    = mod:NewStackAnnounce(307833, 2, nil, "Tank|Healer")
local warnInternalbgPre       = mod:NewPreWarnAnnounce(307833, 5, nil, nil, "Tank|Healer")
local specWarnBreathNightmare = mod:NewSpecialWarningDispel(308512, "RemoveDisease", nil, nil, 1, 6)

local specWarnRazrsveaz       = mod:NewSpecialWarning("KnopSv", 3)
local specCowardice           = mod:NewSpecialWarning(
	"|cff71d5ff|Hspell:307834|hПечать: Трусость|h|r Бей босcа - Держи радиус 6 метров!"
	, 3)
-- local specwarnHp1             = mod:NewSpecialWarning("Hp1", 3)
-- local specwarnHp2             = mod:NewSpecialWarning("Hp2", 3)
-- local specwarnHp3             = mod:NewSpecialWarning("Hp3", 3)
local specWarnshkval          = mod:NewSpecialWarningGTFO(307821, nil, nil, nil, 1, 2)
local specWarnTraitor         = mod:NewSpecialWarningStack(307814, nil, 2, nil, nil, 1, 6)
local specWarnReturnInterrupt = mod:NewSpecialWarningInterrupt(307829, "HasInterrupt", nil, 2, 1, 2)
--local specWarnPechati					= mod:NewSpecialWarningCast(307814, nil, nil, nil, 1, 2) --предатель
local specWarnFlame           = mod:NewSpecialWarningMoveAway(307839, nil, nil, nil, 3, 2)
local specWarnFlame2          = mod:NewSpecialWarningMoveAway(307861, nil, nil, nil, 3, 2)
local specWarnSveaz           = mod:NewSpecialWarningYou(308620, nil, nil, nil, 3, 2)
local yellFlame               = mod:NewYell(307839) --Огонь
local yellFlameFade           = mod:NewShortFadesYell(307839)
local yellFlame2              = mod:NewYell(307861) --Огонь
local yellFlameFade2          = mod:NewShortFadesYell(307861)
local yellCastsvFade          = mod:NewShortFadesYell(308520)

local timerInternalbleeding   = mod:NewCDTimer(26, 307833)
local timerSveazi             = mod:NewCDTimer(28, 308620, nil, nil, nil, 2)
local timerkik                = mod:NewCDTimer(15, 307829, nil, nil, nil, 3)
local timerShkval             = mod:NewCDTimer(20, 307821, nil, nil, nil, 3)
local timerCowardice          = mod:NewCDTimer(33, 307834)
-- local timerFlame            = mod:NewCDTimer(15, 307839)
local timerBreathNightmare    = mod:NewCDTimer(42, 308512, nil, nil, nil, 1, nil, nil, nil, 1)
local timerAmonstrousblow     = mod:NewCDTimer(15, 307845)
local timerCDChep             = mod:NewCDTimer(6, 308520)

mod:AddTimerLine(DBM_COMMON_L.ADDS)
local warnPriziv  = mod:NewCastAnnounce(307852, 3)
-- local timerTrees  = mod:NewCDTimer(5, 307852, nil, nil, nil, 4)
local timerPriziv = mod:NewCDTimer(120, 307852, nil, nil, nil, 4)

mod:AddSetIconOption("SetIconOnSveazTarget", 314606, true, true, { 5, 6, 7 })
mod:AddSetIconOption("SetIconOnFlameTarget", 307839, true, true, { 1, 2 })
mod:AddBoolOption("AnnounceSveaz", false)
mod:AddBoolOption("AnnounceFlame", false)
mod:AddBoolOption("AnnounceKnopk", false)
mod:AddBoolOption("Testicepi", true)
mod:AddBoolOption("AnnounceOFF", false)
mod:AddBoolOption("RangeFrame", true)

mod:AddNamePlateOption("Nameplate1", 307839, true)

local SveazTargets = {}
local FlameTargets = {}
mod.vb.FlameIcons = 2
mod.vb.SveazIcons = 7
-- local warned_kill1 = false
-- local warned_kill2 = false
-- local warned_kill3 = false
-- local warned_P2 = false
-- local warned_P3 = false
--local warned_P4 = false
-- local warned_P5 = false

-- local Trees = {}
-- local Trees_HP = {}
-- local Trees_num = 1
-- mod:SetStage(0)
local function warnSveazTargets(self)
	warnSveaz:Show(table.concat(SveazTargets, "<, >"))
	table.wipe(SveazTargets)
	self.vb.SveazIcons = 7
end

local function warnFlameTargets(self)
	warnFlame:Show(table.concat(FlameTargets, "<, >"))
	table.wipe(FlameTargets)
end
local function warnFlameTargets2(self)
	warnFlame2:Show(table.concat(FlameTargets, "<, >"))
	table.wipe(FlameTargets)
end

function mod:OnCombatStart(delay)
	-- print(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 50702, "Zort")
	self:SetStage(1)
	-- print(self:GetStage())
	self.vb.SveazIcons = 7
	timerkik:Start(-delay)
	timerShkval:Start(-delay)
	--Trees_num = 1
	self.AllThreeDead = 0
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
	local stage = mod:GetStage()
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
		specWarnBreathNightmare:Show(args.destName)
		timerBreathNightmare:Start(stage == 5 and 30 or 42)
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
	local amount = args.amount or 1
	if args:IsSpellID(307815) and amount >= 2 then
		if args:IsPlayer() then
			specWarnTraitor:Show(args.amount)
			specWarnTraitor:Play("stackhigh")
		end
	elseif args:IsSpellID(307839, 307842) then
		FlameTargets[#FlameTargets + 1] = args.destName
		if self.Options.SetIconOnFlameTarget and self.vb.FlameIcons > 0 then
			self:SetIcon(args.destName, self.vb.FlameIcons, 10)
		end
		if self.Options.Nameplate1 then
			DBM.Nameplate:Show(args.destGUID, 307839)
		end
		self.vb.FlameIcons = self.vb.FlameIcons - 1
		self:Unschedule(warnFlameTargets)
		self:Schedule(0.3, warnFlameTargets, self)
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
	elseif args:IsSpellID(307861) then
		FlameTargets[#FlameTargets + 1] = args.destName
		if self.Options.SetIconOnFlameTarget and self.vb.FlameIcons > 0 then
			self:SetIcon(args.destName, self.vb.FlameIcons, 10)
		end
		if self.Options.Nameplate1 then
			DBM.Nameplate:Show(args.destGUID, 307839)
		end
		self.vb.FlameIcons = self.vb.FlameIcons - 1
		self:Unschedule(warnFlameTargets2)
		self:Schedule(0.3, warnFlameTargets2, self)
		if args:IsPlayer() then
			specWarnFlame2:Show()
			yellFlame2:Yell()
			yellFlameFade2:Countdown(307861)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(20)
			end
		end
	elseif args:IsSpellID(308517, 308620, 308515) then
		SveazTargets[#SveazTargets + 1] = args.destName
		if self.Options.SetIconOnSveazTarget and self.vb.SveazIcons > 0 then
			self:SetIcon(args.destName, self.vb.SveazIcons, 10)
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
		warnInternalbleeding:Show(args.destName, amount)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(307839, 307861) then
		self.vb.FlameIcons = 2
		if self.Options.SetIconOnFlameTarget then
			self:SetSortedIcon("roster", args.destName, 7, 8)
		end
		if self.Options.Nameplate1 then
			DBM.Nameplate:Hide(args.destGUID, 307839)
		end
	elseif args:IsSpellID(308516, 308517) then
		if self.Options.SetIconOnSveazTarget then
			self:SetSortedIcon("roster", args.destName, 6, 8)
		end
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

function mod:UNIT_HEALTH()
	local stage = mod:GetStage()
	if stage == 0 then
		mod:SetStage(1)
	elseif stage and stage ~= 0 and UnitAffectingCombat("player") then
		if stage == 1 then
			local hp = DBM:GetBossHPByUnitID("boss3") -- чудовищная
			if hp and hp <= 1 then
				self:NextStage()             -- stage == 2
			end
		elseif stage == 2 then
			local hp = DBM:GetBossHPByUnitID("boss2") -- лик
			if hp and hp <= 1 then
				self:NextStage()             -- stage == 3
			end
		elseif stage == 3 then
			local hp = DBM:GetBossHPByUnitID("boss4") -- щупальце плеть
			if hp and hp <= 1 then
				self:NextStage()             -- stage == 4
			end
		elseif stage == 4 then
			if UnitExists("boss2") then
				if DBM:GetBossHPByUnitID("boss2") < 1 and DBM:GetBossHPByUnitID("boss3") < 1 and DBM:GetBossHPByUnitID("boss4") < 1 then
					self:NextStage() -- stage == 5
				end
			end
		end
		-- local hpz = DBM:GetBossHPByUnitID("boss1")

		-- if hp then
		-- 	if hp <= 67 and stage == 1 then
		-- 		mod:SetStage(2)
		-- 	elseif  hp <= 38 and stage == 2 then
		-- 		mod:SetStage(3)
		-- 	elseif  hp <= 50 and stage == 3 then
		-- 		mod:SetStage(4)
		-- 	elseif  hp <= 26 and stage == 4 then
		-- 		mod:SetStage(5)
		-- 	end
		-- end
	end
end

-- if self:GetUnitCreatureId(guid) == 50702 then -- zort
-- 	-- if  DBM:GetBossHP(guid) <= 68
-- elseif self:GetUnitCreatureId(guid) == 50714 then -- вторая лик
-- 	if  DBM:GetBossHP(guid) <= 2 and self:GetStage() == 2 then
-- 		self:NextStage() --stage == 3
-- 	end
-- elseif self:GetUnitCreatureId(guid) == 50715 then -- первая чудовищная
-- 	if  DBM:GetBossHP(guid) <= 2 and self:GetStage() == 1  then
-- 		self:NextStage() --stage == 2
-- 	elseif  DBM:GetBossHP(guid) >= 99 and self:GetStage() == 3 then
-- 		self:NextStage() --stage == 4
-- 	end
-- elseif self:GetUnitCreatureId(guid) == 50716 then -- щупальце плеть
-- 	if  DBM:GetBossHP(guid) <= 1 and self:GetStage() == 3  then
-- 		self:NextStage() --stage == 4
-- 	end
-- elseif self:GetStage() == 4 and self.AllThreeDead == 4 then
-- 	self:NextStage() --stage == 5
-- end
-- local test = true
-- if test then
-- 	local f = CreateFrame("Frame");
-- 	f.elapsed = 0;
-- 	f:SetScript("OnUpdate", function(self,elapsed)
-- 		self.elapsed = self.elapsed + elapsed;
-- 		if self.elapsed < 5 then return end
-- 		self.elapsed = 0

-- 	end)
-- end
