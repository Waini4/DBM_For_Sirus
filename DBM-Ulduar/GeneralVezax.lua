local mod = DBM:NewMod("GeneralVezax", "DBM-Ulduar")
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision("20220518110528")
mod:SetCreatureID(33271)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312977 62661 312981 62662",
	"SPELL_INTERRUPT 312977 62661",
	"SPELL_AURA_APPLIED 312981 62662",
	"SPELL_AURA_REMOVED 62662 312981",
	"SPELL_CAST_SUCCESS 62660 63276 63364 312978 312974 312621"
)
mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnShadowCrash          = mod:NewTargetAnnounce(312978, 4)
local warnLeechLife            = mod:NewTargetNoFilterAnnounce(312974, 3)
local warnSaroniteVapor        = mod:NewSoonAnnounce(63337, 2)

local specWarnShadowCrash      = mod:NewSpecialWarningDodge(312978, nil, nil, nil, 1, 2)
local specWarnShadowCrashNear  = mod:NewSpecialWarningClose(312978, nil, nil, nil, 1, 2)
local yellShadowCrash          = mod:NewYell(312978)
local specWarnSurgeDarkness    = mod:NewSpecialWarningDefensive(312981, nil, nil, 2, 1, 2)
local specWarnLifeLeechYou     = mod:NewSpecialWarningMoveAway(312974, nil, nil, nil, 3, 2)
local yellLifeLeech            = mod:NewYell(312974)
local specWarnLifeLeechNear    = mod:NewSpecialWarningClose(312974, nil, nil, 2, 1, 2)
local specWarnSearingFlames    = mod:NewSpecialWarningInterruptCount(312977, "HasInterrupt", nil, nil, 1, 2)

local timerEnrage              = mod:NewBerserkTimer(600)
local timerSearingFlamesCast   = mod:NewCastTimer(2, 312977)
local timerSurgeofDarkness     = mod:NewBuffActiveTimer(10, 312981, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerNextSurgeofDarkness = mod:NewCDTimer(61.7, 312981, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerSaroniteVapors      = mod:NewNextCountTimer(30, 63322, nil, nil, nil, 5)
local timerShadowCrashCD       = mod:NewCDTimer(13.5, 312978, nil, nil, nil, 3)
local timerLifeLeech           = mod:NewTargetTimer(10, 312974, nil, false, 2, 3)
local timerLifeLeechCD         = mod:NewCDTimer(40, 312974, nil, nil, nil, 3) -- ??

mod:AddSetIconOption("SetIconOnShadowCrash", 312978, true, false, { 8 })
mod:AddSetIconOption("SetIconOnLifeLeach", 312974, true, false, { 7 })
mod:AddBoolOption("CrashArrow", true)

mod:AddTimerLine(DBM_CORE_L.HARD_MODE)
local specWarnAnimus = mod:NewSpecialWarningSwitch(63145, nil, nil, nil, 1, 2)

local timerHardmode = mod:NewTimer(195, "hardmodeSpawn", nil, nil, nil, 1)

mod.vb.interruptCount = 0
mod.vb.vaporsCount = 0

function mod:ShadowCrashTarget(targetname, uId)
	if not targetname then return end
	if self.Options.SetIconOnShadowCrash then
		self:SetIcon(targetname, 8, 5)
	end
	if targetname == UnitName("player") then
		specWarnShadowCrash:Show()
		specWarnShadowCrash:Play("runaway")
		yellShadowCrash:Yell()
	elseif self:CheckNearby(11, targetname) then
		specWarnShadowCrashNear:Show(targetname)
		specWarnShadowCrashNear:Play("runaway")
		if uId then
			local x, y = GetPlayerMapPosition(uId)
			if x == 0 and y == 0 then
				SetMapToCurrentZone()
				x, y = GetPlayerMapPosition(uId)
			end
			if self.Options.CrashArrow then
				DBM.Arrow:ShowRunAway(x, y, 15, 5)
			end
			warnShadowCrash:Show(targetname)
		end
	end
end

local function Vapors(self)
	self.vb.vaporsCount = self.vb.vaporsCount + 1
	timerSaroniteVapors:Start(34, self.vb.vaporsCount + 1)
	warnSaroniteVapor:Schedule(30)
	warnSaroniteVapor:Schedule(33)
	self:Schedule(34, Vapors, self)
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33271, "GeneralVezax")
	self.vb.interruptCount = 0
	self.vb.vaporsCount = 0
	timerShadowCrashCD:Start(9 - delay)
	timerLifeLeechCD:Start(39 - delay)
	timerSaroniteVapors:Start(30 - delay, 1)
	self:Schedule(30, Vapors, self)
	timerEnrage:Start(-delay)
	timerHardmode:Start(-delay)
	timerNextSurgeofDarkness:Start(-delay)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 33271, "GeneralVezax", wipe)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 312977 or spellId == 62661 then -- Searing Flames
		self.vb.interruptCount = self.vb.interruptCount + 1
		if self.vb.interruptCount == 4 then
			self.vb.interruptCount = 1
		end
		local kickCount = self.vb.interruptCount
		specWarnSearingFlames:Show(args.sourceName, kickCount)
		specWarnSearingFlames:Play("kick" .. kickCount .. "r")
		timerSearingFlamesCast:Start()
	elseif spellId == 312981 or spellId == 62662 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnSurgeDarkness:Show()
			specWarnSurgeDarkness:Play("defensive")
		end
		timerNextSurgeofDarkness:Start()
	end
end

function mod:SPELL_INTERRUPT(args)
	local spellId = args.spellId
	if spellId == 312977 or spellId == 62661 then
		timerSearingFlamesCast:Stop()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312981 or spellId == 62662 then -- Surge of Darkness
		timerSurgeofDarkness:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 312981 or spellId == 62662 then
		timerSurgeofDarkness:Stop()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 312978 or spellId == 62660 then -- Shadow Crash
		self:BossTargetScanner(33271, "ShadowCrashTarget", 0.05, 20)
		timerShadowCrashCD:Start()
	elseif args:IsSpellID(312974, 63276, 312621) then -- Mark of the Faceless
		if self.Options.SetIconOnLifeLeach then
			self:SetIcon(args.destName, 7, 10)
		end
		timerLifeLeech:Start(args.destName)
		timerLifeLeechCD:Start()
		if args:IsPlayer() then
			specWarnLifeLeechYou:Show()
			specWarnLifeLeechYou:Play("runout")
			yellLifeLeech:Yell()
		else
			warnLeechLife:Show(args.destName)
		end
	elseif spellId == 63364 then
		specWarnAnimus:Show()
		specWarnAnimus:Play("bigmob")
		self:Unschedule(Vapors)
		timerSaroniteVapors:Stop()
		warnSaroniteVapor:Cancel()
		warnSaroniteVapor:Cancel()
	end
end

--[[
function mod:CHAT_MSG_RAID_BOSS_EMOTE(emote)
	if emote == L.EmoteSaroniteVapors or emote:find(L.EmoteSaroniteVapors) then
		self.vb.vaporsCount = self.vb.vaporsCount + 1
		warnSaroniteVapor:Show(self.vb.vaporsCount)
		if self.vb.vaporsCount < 6 then
			timerSaroniteVapors:Start(nil, self.vb.vaporsCount + 1)
		end
	end
end
]]
