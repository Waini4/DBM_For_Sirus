--------------------------------------------------------------
--------------------------------------------------------------

local mod = DBM:NewMod("Leotheras", "DBM-Serpentshrine")
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(21215)
mod:RegisterCombat("combat", 21215)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod:SetModelID(20514)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 310481 310484 310478 310516",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_START 37676 310510 310508 310503 310487 310521 310514",
	"UNIT_HEALTH",
	"SPELL_AURA_APPLIED 37640 37676 310480 310502 310502 310521 310496 310497 310514",
	"SPELL_AURA_APPLIED_DOSE 37640 37676 310480 310502 310502 310521 310496 310497 310514",
	"SPELL_AURA_REMOVED 37676",
	"SPELL_HEAL",
	"SPELL_PERIODIC_HEAL"
)

-- local warnDemonSoon         = mod:NewAnnounce("WarnDemonSoon", 3, "Interface\\Icons\\Spell_Shadow_Metamorphosis")
-- local warnNormalSoon        = mod:NewAnnounce("WarnNormalSoon", 3, "Interface\\Icons\\INV_Weapon_ShortBlade_07")
local warnDemons       = mod:NewTargetAnnounce(37676, 4)

local specWarnDemon    = mod:NewSpecialWarningYou(37676)

local timerDemon       = mod:NewTimer(45, "TimerDemon", "Interface\\Icons\\Spell_Shadow_Metamorphosis")
local timerNormal      = mod:NewTimer(60, "TimerNormal", "Interface\\Icons\\INV_Weapon_ShortBlade_07")
local timerInnerDemons = mod:NewTimer(32.5, "TimerInnerDemons", 11446)
local timerWhirlwind   = mod:NewCastTimer(12, 37640)
local timerWhirlwindCD = mod:NewCDTimer(19, 37640)

local berserkTimer     = mod:NewBerserkTimer(360)


---------------------------------хм---------------------------------

local warnRass       = mod:NewStackAnnounce(310480, 5, nil, "Tank") -- Рассеченая душа
local warnKogti      = mod:NewStackAnnounce(310502, 5, nil, "Tank") -- Когти
local warnNat        = mod:NewTargetAnnounce(310478, 3)             -- Натиск
local warnChardg     = mod:NewTargetAnnounce(310481, 3)             -- Рывок
local warnPepels     = mod:NewTargetAnnounce(310514, 3)             -- Испепеление
local warnKlei       = mod:NewTargetAnnounce(310496, 4)             -- Клеймо
local warnMeta       = mod:NewSpellAnnounce(310484, 3)              --Мета
local warnPepel      = mod:NewSpellAnnounce(310514, 3)              --пепел
local warnVsp        = mod:NewStackAnnounce(310521, 5)              --Вспышка
local warnPhase2Soon = mod:NewPrePhaseAnnounce(2)
local warnPhase2     = mod:NewPhaseAnnounce(2)
local yellKlei       = mod:NewYell(310496)
local yellKleiFade   = mod:NewShortFadesYell(310496)


local specWarnChardg  = mod:NewSpecialWarningYou(310481, nil, nil, nil, 1, 2)
local specWarnKlei    = mod:NewSpecialWarningYou(310496, nil, nil, nil, 1, 2)
local specWarnObstrel = mod:NewSpecialWarningRun(310510, nil, nil, nil, 2, 2)
local specWarnAnig    = mod:NewSpecialWarningDodge(310508, nil, nil, nil, 3, 2)
local specWarnVzg     = mod:NewSpecialWarningDodge(310516, nil, nil, nil, 3, 2)
local specWarnVost    = mod:NewSpecialWarningSoak(310503, nil, nil, nil, 1, 2)
local specWarnPechat  = mod:NewSpecialWarningSoak(310487, nil, nil, nil, 1, 2)
local specWarnPepel   = mod:NewSpecialWarningSwitch(310514, "Healer", nil, nil, 1, 4)
local specWarnPepely  = mod:NewSpecialWarningYou(310514, nil, nil, nil, 1, 4)

local timerRass       = mod:NewTargetTimer(40, 310480, nil, "Tank", nil, 5, nil, CL.TANK_ICON) -- Рассеченая душа
local timerKogti      = mod:NewTargetTimer(40, 310502, nil, "Tank", nil, 5, nil, CL.TANK_ICON) -- Когти
local timerVsp        = mod:NewTargetTimer(60, 310521, nil, nil, nil, 5, nil, CL.TANK_ICON)    -- Когти
local timerKlei       = mod:NewTargetTimer(30, 310497, nil, nil, nil, 3)                       -- Клеймо
local timerAnigCast   = mod:NewCastTimer(10, 310508, nil, nil, nil, 2)                         -- Аниг
local timerVzgCast    = mod:NewCastTimer(5, 310516, nil, nil, nil, 2)                          -- Взгляд
local timerChardgCast = mod:NewCastTimer(3, 310481, nil, nil, nil, 3)                          -- Рывок
local timerMetaCast   = mod:NewCastTimer(3, 310484, nil, nil, nil, 3)                          -- Мета
local timerNatCast    = mod:NewCastTimer(3, 310478, nil, nil, nil, 3)                          -- Натиск
local timerPepelCast  = mod:NewCastTimer(3, 310514, nil, nil, nil, 3)                          -- Испепел


mod:AddSetIconOption("SetIconOnDemonTargets", 37676, true, true, { 5, 6, 7, 8 })
mod:AddSetIconOption("SetIconOnPepelTargets", 310514, true, true, { 4, 5, 6, 7 })
mod:AddSetIconOption("KleiIcon", 310496, true, true, { 8 })
mod:AddBoolOption("PepelShieldFrame", true, "misc")
mod:AddBoolOption("AnnounceKlei", false)
mod:AddBoolOption("AnnouncePepel", false)

mod.vb.phase = 0
mod.vb.PepelCount = 0
local demonTargets = {}
local warned_preP1 = false
local warned_preP2 = false
local PepelTargets = {}
local KleiIcons = 8
local PowerTr = false

do
	-- local function sort_by_group(v1, v2)
	-- 	return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	-- end
	function mod:SetPepelIcons()
		if DBM:GetRaidRank() >= 0 then
			table.sort(PepelTargets, function(v1, v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
			local PepelIcons = 7
			for _, v in ipairs(PepelTargets) do
				if mod.Options.IncinerateShieldFrame then
					if DBM:GetRaidRank() > 0 then
						SendChatMessage(L.PepelIcon:format(PepelIcons, UnitName(v)), "RAID_WARNING")
					else
						SendChatMessage(L.PepelIcon:format(PepelIcons, UnitName(v)), "RAID")
					end
				end
				if self.Options.SetIconOnPepelTargets then
					self:SetIcon(UnitName(v), PepelIcons)
				end
				PepelIcons = PepelIcons - 1
			end
			if #PepelTargets >= 4 then
				warnPepels:Show(table.concat(PepelTargets, "<, >"))
				table.wipe(PepelTargets)
				PepelIcons = 7
			end
		end
	end
end

local setPepelTarget, clearPepelTarget, clearPepelVariables
do
	local incinerateTarget = {}
	local healed = {}

	function mod:SPELL_HEAL(_, _, _, destGUID, _, _, _, _, _, _, _, absorbed)
		if incinerateTarget[destGUID] then
			healed[destGUID] = healed[destGUID] + (absorbed or 0)
			DBM.BossHealth:Update()
			--print(destName .. ":" .. healed[destGUID])
		end
	end

	mod.SPELL_PERIODIC_HEAL = mod.SPELL_HEAL


	local function updatePepelTargets()
		local maxAbsorb = 150000
		DBM.BossHealth:Clear()
		for i, v in pairs(incinerateTarget) do
			DBM.BossHealth:AddBoss(function() return math.max(1, math.floor((healed[i] or 0) / maxAbsorb * 100)) end,
				L.IncinerateTarget:format(v))
		end
	end

	function setPepelTarget(guid, name)
		incinerateTarget[guid] = name
		healed[guid] = 0
		updatePepelTargets()
	end

	function clearPepelTarget(guid, name)
		incinerateTarget[guid] = nil
		healed[guid] = nil
		PowerTr = true
		updatePepelTargets()
	end

	function clearPepelVariables()
		table.wipe(incinerateTarget)
		table.wipe(incinerateTarget)
		updatePepelTargets()
	end
end

do -- add the additional Rune Power Bar
	local last = 0
	local function getPowerPercent()
		local guid = UnitGUID("focus")
		if mod:GetCIDFromGUID(guid) == 21215 then
			last = math.floor(UnitPower("focus") / UnitPowerMax("focus") * 100)
			return last
		end
		for i = 0, GetNumRaidMembers(), 1 do
			local unitId = ((i == 0) and "target") or ("raid" .. i .. "target")
			guid = UnitGUID(unitId)
			if mod:GetCIDFromGUID(guid) == 21215 then
				last = math.floor(UnitPower(unitId) / UnitPowerMax(unitId) * 100)
				return last
			end
		end
		return last
	end
	function mod:CreateBossRPFrame()
		DBM.BossHealth:AddBoss(getPowerPercent, L.Power)
	end
end


function mod:WarnDemons()
	warnDemons:Show(table.concat(demonTargets, "<, >"))
	if self.Options.SetIconOnDemonTargets then
		table.sort(demonTargets, function(v1, v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
		local k = 8
		for _, v in ipairs(demonTargets) do
			self:SetIcon(v, k)
			k = k - 1
		end
	end
	table.wipe(demonTargets)
end

function mod:FlashFunc(args)
	local targetname = self:GetBossTarget(21215)
	if not targetname then return end
	if self.Options.SetIconOnStrela then
		self:SetIcon(targetname, 8, 6)
	end
	warnVsp:Show(args.destName, args.amount or 1)
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 21215, "Leotheras the Blind")
	table.wipe(demonTargets)
	self:SetStage(1)
	if mod:IsDifficulty("heroic25") then
		self.vb.PepelCount = 0
		self:ScheduleMethod(0.5, "CreateBossRPFrame")
		if self.Options.PepelShieldFrame then
			DBM.BossHealth:Show(L.name)
			DBM.BossHealth:AddBoss(21215, L.name)
			clearPepelVariables()
		end
	else
		berserkTimer:Start()
		timerDemon:Start(60)
		timerWhirlwindCD:Start(18)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 21215, "Leotheras the Blind", wipe)
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 310481 then
		timerChardgCast:Start()
		warnChardg:Show(args.destName)
		if args:IsPlayer() then
			specWarnChardg:Show()
		end
	elseif spellId == 310484 then
		warnMeta:Show()
		timerMetaCast:Start()
	elseif spellId == 310478 then
		warnNat:Show(args.destName)
		timerNatCast:Start()
	elseif spellId == 310516 then
		specWarnVzg:Show()
		timerVzgCast:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 37640 then
		timerWhirlwind:Start()
		timerWhirlwindCD:Schedule(12)
	elseif spellId == 37676 then
		demonTargets[#demonTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnDemon:Show()
		end
		self:UnscheduleMethod("WarnDemons")
		self:ScheduleMethod(0.1, "WarnDemons")
	elseif spellId == 310480 then --хм Рассеченая душа
		warnRass:Show(args.destName, args.amount or 1)
		timerRass:Start(args.destName)
	elseif spellId == 310502 then --хм Когти скверны
		warnKogti:Show(args.destName, args.amount or 1)
		timerKogti:Start(args.destName)
	elseif spellId == 310521 then --хм Вспышка
		if (args.amount or 1) > 3 then
			warnVsp:Show(args.destName, args.amount or 1)
			timerVsp:Start(args.destName)
		end
	elseif spellId == 310496 or spellId == 310497 then --хм Клеймо
		warnKlei:Show(args.destName)
		if self.Options.KleiIcon then
			self:SetIcon(args.destName, 8, 30)
			timerKlei:Start(args.destName)
		end
		if args:IsPlayer() then
			specWarnKlei:Show()
			yellKlei:Yell()
			yellKleiFade:Countdown(spellId)
		end
		if mod.Options.AnnounceKlei then
			if DBM:GetRaidRank() > 0 then
				SendChatMessage(L.Klei:format(KleiIcons, args.destName), "RAID_WARNING")
			else
				SendChatMessage(L.Klei:format(KleiIcons, args.destName), "RAID")
			end
		end
	elseif spellId == 310514 then
		PepelTargets[#PepelTargets + 1] = args.destName
		self.vb.PepelCount = self.vb.PepelCount + 1
		if args:IsPlayer() then
			specWarnPepely:Show(args.destName)
		end
		self:ScheduleMethod(0.1, "SetPepelIcons")
		if self.Options.PepelShieldFrame then
			setPepelTarget(args.destGUID, args.destName)
			self:Schedule(12, clearPepelTarget, args.destGUID, args.destName)
		end
		if PowerTr then
			PowerTr = false
			self:ScheduleMethod(0.5, "CreateBossRPFrame")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 37676 then
		self:RemoveIcon(args.destName)
	elseif spellId == 310514 then
		self.vb.PepelCount = self.vb.PepelCount - 1
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 37676 then
		timerInnerDemons:Start()
	elseif spellId == 310510 then
		specWarnObstrel:Show()
	elseif spellId == 310508 then
		specWarnAnig:Show()
		timerAnigCast:Start()
	elseif spellId == 310503 then
		specWarnVost:Show()
	elseif spellId == 310487 then
		specWarnPechat:Show()
	elseif spellId == 310521 then
		-- self:BossTargetScanner(21215, "ShadowCrashTarget", 0.05, 1) -- dont has function for return value -- todo
		warnVsp:Show(args.destName)
	elseif spellId == 310514 then
		specWarnPepel:Show()
		timerPepelCast:Start(2)
		warnPepel:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 2121 then
		if self:GetStage() == 1 and not warned_preP1 then
			if mod:IsDifficulty("heroic25") and DBM:GetBossHPByUnitID(uId) <= 37 then
				warned_preP1 = true
				warnPhase2Soon:Show()
			elseif DBM:GetBossHPByUnitID(uId) <= 27 then
				warned_preP1 = true
				warnPhase2Soon:Show()
			end
		elseif self:GetStage() == 1 and not warned_preP2 then
			if mod:IsDifficulty("heroic25") and DBM:GetBossHPByUnitID(uId) <= 35 then
				warned_preP2 = true
				self:SetStage(2)
				warnPhase2:Show()
			elseif DBM:GetBossHPByUnitID(uId) <= 25 then
				warned_preP2 = true
				self:SetStage(2)
				warnPhase2:Show()
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellDemon then
		timerDemon:Cancel()
		timerWhirlwindCD:Cancel()
		timerDemon:Schedule(60)
		timerWhirlwindCD:Schedule(60)
		timerNormal:Start()
	elseif msg == L.YellShadow then
		timerDemon:Cancel()
		timerNormal:Cancel()
		timerWhirlwindCD:Start(22.5)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
