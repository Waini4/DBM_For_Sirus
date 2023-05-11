local mod = DBM:NewMod("Murozond", "DBM-ChamberOfAspects", 3)
local L   = mod:GetLocalizedStrings()

local CL  = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(50612)
mod:RegisterCombat("combat", 50612)
-- mod:SetUsedIcons()
--mod.respawnTime = 20


mod:RegisterEventsInCombat(
	"SPELL_CAST_START 313116 313120 313118 313122 317252 317253 317255 317262",
	"SPELL_CAST_SUCCESS 317259 313122",
	"SPELL_AURA_APPLIED 313122 313115 313129 313130 317260 317256 313119",
	"SPELL_AURA_APPLIED_DOSE 313122 313115 313129 313130 317260 313119 317256",
	-- "UNIT_DIED",
	"SPELL_AURA_REMOVED 313122 317262",
	"UNIT_HEALTH"
)


mod:AddTimerLine(CL.INTERMISSION)
local warnPhase1           = mod:NewPhaseAnnounce(1, 2)
local warnPhase2Soon       = mod:NewPrePhaseAnnounce(2, 2)

local NewPrePhaseAnnounce  = mod:NewCDCountTimer(180, 313122, nil, nil, nil, 2)

local warnPhase2           = mod:NewPhaseAnnounce(2, 2)
local warnEndofTimeSoonEnd = mod:NewAnnounce("EndofTimeSoonEnd", 2, 313122, nil, nil, nil, 313122)

local specWarnPerPhase     = mod:NewSpecialWarning("PrePhase", 313122, nil, nil, 1, 6) -- Перефаза
local specwarnBelay        = mod:NewSpecialWarning("BelayaSfera", 313125, nil, nil, 1, 6)
local specwarnCern         = mod:NewSpecialWarning("Cernsfera", 313126, nil, nil, 1, 6)
local specwarnPerebejka    = mod:NewSpecialWarning("Perebejkai", 313122, nil, nil, 1, 6)

local EndofTime            = mod:NewCastTimer(10, 313122, nil, nil, nil, 2) --перефаза
local EndofTimeBuff        = mod:NewBuffActiveTimer(60, 313122, nil, nil, nil, 3, nil, CL.DEADLY_ICON)

mod:AddBoolOption("AnnounceOrb", false)
--------------------------------------HM--------------------------------
mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE25)

local warnBredHM            = mod:NewStackAnnounce(317252, 5, nil, "Tank")
local specwarnReflectSpells = mod:NewSpecialWarningCast(317262, "-Healer", nil, nil, 3, 2) -- Отражение заклинаний
local specWarnTimeTrapGTFO  = mod:NewSpecialWarningGTFO(317260, nil, nil, nil, 3, 2)

--local SummoningtheTimelessHM 	= mod:NewCDTimer(90, 313120, nil, nil, nil, 2) -- призыв аддов
local DistortionWaveHM      = mod:NewCDTimer(40, 317253, nil, nil, nil, 5, nil, CL.HEALER_ICON)                           -- Волна искажений
local timerReflectBuff      = mod:NewBuffActiveTimer(5, 317262, nil, nil, nil, 2)                                         --отражение
local TimeTrapCD            = mod:NewCDTimer(30, 317259, nil, nil, nil, 3)                                                -- Ловушка времени
local BreathofInfinityHm    = mod:NewCDTimer(15, 317252, nil, "Tank", nil, 5, nil, CL.TANK_ICON)                          -- танк дабаф хм
local ReflectSpellsCD       = mod:NewCDTimer(20, 317262, nil, "SpellCaster|-Healer", nil, 3, nil, CL.DEADLY_ICON, nil, 1) -- Отражение заклинаний
local timerBredHM           = mod:NewTargetTimer(120, 313115, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local TerrifyingFutureHM    = mod:NewCDTimer(40, 317255, nil, "Melee", nil, 2, nil, CL.DEADLY_ICON, nil, 1)               -- Мили Фир
local GibVremea             = mod:NewCDTimer(5, 317258, nil, nil, nil, 4, nil, CL.HEALER_ICON)

mod:AddBoolOption("GibVr", false)

---------------------------------------------ОБ---------------------------------
mod:AddTimerLine(DBM_CORE_L.NORMAL_MODE25)
local warnBred             = mod:NewStackAnnounce(313115, 5, nil, "Tank")

local warnTerrifyingFuture = mod:NewSpecialWarningLookAway(313118, "Melee", nil, nil, 2, 2)

local DistortionWave       = mod:NewCDTimer(40, 313116, nil, nil, nil, 2)                                  -- Волна искажений
local SummoningtheTimeless = mod:NewCDTimer(90, 313120, nil, nil, nil, 2)                                  -- призыв аддов
local BreathofInfinity     = mod:NewCDTimer(50, 313115, nil, "Tank", nil, 5, nil, CL.TANK_ICON)            -- танк дабаф
local timerBred            = mod:NewTargetTimer(60, 313115, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local TerrifyingFuture     = mod:NewCDTimer(40, 313118, nil, "Melee", nil, 2, nil, CL.DEADLY_ICON, nil, 1) -- Мили Фир

local warned_preP1         = false
local warned_preP2         = false
mod.vb.PreHuy              = 0
mod.vb.FearMili            = 0
-- mod:AddBoolOption("BossHealthFrame", true, "misc")

mod:AddBoolOption("AnnounceFails", false, "announce")
mod:AddBoolOption("AnnounceFear", false, "announce")
local FearTargets = {}
-- mod:SetStage(0)
function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 50612, "Murozond")
	self.vb.PreHuy = 0
	self.vb.FearMili = 0
	mod:SetStage(1)
	if mod:IsDifficulty("heroic25") then
		NewPrePhaseAnnounce:Start(nil, self.vb.PreHuy + 1)
		SummoningtheTimeless:Start(10)
		ReflectSpellsCD:Start(24)
		TerrifyingFutureHM:Start()
		TimeTrapCD:Start(30)
		if self.Options.GibVr then
			GibVremea:Start()
			self:ScheduleMethod(5, "Vremea")
		end
	else
		DistortionWave:Start(20)
		SummoningtheTimeless:Start(35)
		BreathofInfinity:Start()
		TerrifyingFuture:Start()
	end
	-- if self.Options.BossHealthFrame then
	-- 	DBM.BossHealth:Show(L.name)
	-- 	DBM.BossHealth:AddBoss(50612, L.name)
	-- end
	if self.Options.AnnounceFear then
		self:ScheduleMethod(38, "AnnonceF")
	end
	table.wipe(FearTargets)
end

local FearFails = {}
local function FearFails1(e1, e2)
	return (FearTargets[e1] or 0) > (FearTargets[e2] or 0)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 50612, "Murozond", wipe)
	DBM.BossHealth:Clear()
	DistortionWave:Stop()
	SummoningtheTimeless:Stop()
	BreathofInfinity:Stop()
	TerrifyingFuture:Stop()
	warnTerrifyingFuture:Cancel()
	warnEndofTimeSoonEnd:Cancel()
	if self.Options.GibVr then
		GibVremea:Stop()
		self:UnscheduleMethod("Vremea")
	end
	if self.Options.AnnounceFails and DBM:GetRaidRank() >= 1 and self:AntiSpam(5) then
		local lFear = ""
		for k, _ in pairs(FearTargets) do
			table.insert(FearFails, k)
		end
		table.sort(FearFails, FearFails1)
		for _, v in ipairs(FearFails) do
			lFear = lFear .. " " .. v .. "(" .. (FearTargets[v] or "") .. ")"
		end
		SendChatMessage(L.Fear:format(lFear), "RAID")
		table.wipe(FearFails)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 313116 then
		DistortionWave:Start()
	elseif spellId == 313120 then
		if mod:IsDifficulty("heroic25") then
			SummoningtheTimeless:Start(90)
		else
			SummoningtheTimeless:Start()
		end
	elseif spellId == 313118 then
		TerrifyingFuture:Start()
		warnTerrifyingFuture:Show()
		if self.Options.AnnounceFear then
			self:ScheduleMethod(38, "AnnonceF")
		end
	elseif spellId == 313122 and not warned_preP2 then
		self.vb.PreHuy = self.vb.PreHuy + 1
		EndofTime:Start()
		warnEndofTimeSoonEnd:Schedule(65)
		self:SetStage(2)
		warnPhase2:Show()
		warned_preP2 = true
		specwarnPerebejka:Schedule(19)
		self:ScheduleMethod(19, "Perebejka")
		if mod:IsDifficulty("heroic25") then
			specWarnPerPhase:Show()
			NewPrePhaseAnnounce:Stop()
			self:ScheduleMethod(0.1, "StopBossCastHM")
		else
			self:ScheduleMethod(0.1, "StopBossCast")
		end
		if self.Options.AnnounceFear then
			self:UnscheduleMethod("AnnonceF")
		end
	end
	-----------HM------------
	if spellId == 317252 then
		BreathofInfinityHm:Start()
	elseif spellId == 317253 then
		DistortionWaveHM:Start()
	elseif spellId == 317255 then
		TerrifyingFutureHM:Start()
		warnTerrifyingFuture:Show()
		if self.Options.AnnounceFear then
			self:ScheduleMethod(38, "AnnonceF")
		end
	elseif spellId == 317262 then
		specwarnReflectSpells:Show()
	end
end

function mod:Perebejka()
	if self:GetStage() == 2 then
		specwarnPerebejka:Schedule(15)
		self:ScheduleMethod(15, "Perebejka")
	end
end

function mod:Vremea()
	if self.Options.GibVr then
		GibVremea:Start()
		self:ScheduleMethod(5, "Vremea")
	end
end

function mod:AnnonceF()
	SendChatMessage("Скоро Фир!", "SAY", nil, nil)
end

function mod:StopBossCastHM()
	if SummoningtheTimeless:GetRemaining() then
		local elapsed, total = SummoningtheTimeless:GetTime()
		local extend = total - elapsed
		SummoningtheTimeless:Stop()
		SummoningtheTimeless:Update(0, 75 + extend)
	end
	if ReflectSpellsCD:GetRemaining() then
		local elapsed, total = ReflectSpellsCD:GetTime()
		local extend = total - elapsed
		ReflectSpellsCD:Stop()
		ReflectSpellsCD:Update(0, 75 + extend)
	end
	if TimeTrapCD:GetRemaining() then
		local elapsed, total = TimeTrapCD:GetTime()
		local extend = total - elapsed
		TimeTrapCD:Stop()
		TimeTrapCD:Update(0, 75 + extend)
	end
	if BreathofInfinityHm:GetRemaining() then
		local elapsed, total = BreathofInfinityHm:GetTime()
		local extend = total - elapsed
		BreathofInfinityHm:Stop()
		BreathofInfinityHm:Update(0, 75 + extend)
	end
	if TerrifyingFutureHM:GetRemaining() then
		local elapsed, total = TerrifyingFutureHM:GetTime()
		local extend = total - elapsed
		TerrifyingFutureHM:Stop()
		TerrifyingFutureHM:Update(0, 75 + extend)
	end
end

function mod:StopBossCast()
	if SummoningtheTimeless:GetRemaining() then
		local elapsed, total = SummoningtheTimeless:GetTime()
		local extend = total - elapsed
		SummoningtheTimeless:Stop()
		SummoningtheTimeless:Update(0, 75 + extend)
	end
	if DistortionWave:GetRemaining() then
		local elapsed, total = DistortionWave:GetTime()
		local extend = total - elapsed
		DistortionWave:Stop()
		DistortionWave:Update(0, 75 + extend)
	end
	if BreathofInfinity:GetRemaining() then
		local elapsed, total = BreathofInfinity:GetTime()
		local extend = total - elapsed
		BreathofInfinity:Stop()
		BreathofInfinity:Update(0, 75 + extend)
	end
	if TerrifyingFuture:GetRemaining() then
		local elapsed, total = TerrifyingFuture:GetTime()
		local extend = total - elapsed
		TerrifyingFuture:Stop()
		TerrifyingFuture:Update(0, 75 + extend)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 313122 and args:IsPlayer() then
		EndofTimeBuff:Start()
	elseif spellId == 313115 then
		warnBred:Show(args.destName, args.amount or 1)
		timerBred:Start(args.destName)
	elseif spellId == 313129 and args:IsPlayer() and self.Options.AnnounceOrb then
		specwarnCern:Schedule(1)
	elseif spellId == 313130 and args:IsPlayer() and self.Options.AnnounceOrb then
		specwarnBelay:Schedule(1)
		-------------HM----------------
	elseif spellId == 317262 then
		timerReflectBuff:Start()
	elseif args:IsSpellID(317260, 317259, 317261) and args:IsPlayer() then
		specWarnTimeTrapGTFO:Show(args.spellName)
	elseif spellId == 317252 then
		warnBredHM:Show(args.destName, args.amount or 1)
		timerBredHM:Start(args.destName)
	elseif args:IsSpellID(313119, 317256) and args.sourceName == L.name and args.destName then
		FearTargets[args.destName] = (FearTargets[args.destName] or 0) + 1
		if self.Options.AnnounceFails then
			SendChatMessage(L.FearOn:format(args.destName), "RAID")
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 317259 then
		TimeTrapCD:Start()
	elseif spellId == 313122 then
		specwarnPerebejka:Start(9)
		self:ScheduleMethod(9, "Perebejka")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	local cid = self:GetCIDFromGUID(args.destGUID)
	if spellId == 313122 then
		if cid == 50612 and self:GetStage() == 2 then
			mod:SetStage(1)
			warned_preP1 = false
			warned_preP2 = false
			specwarnPerebejka:Cancel()
			self:UnscheduleMethod("Perebejka")
			warnPhase1:Show() -- 1 перефаза
			if mod:IsDifficulty("heroic25") then
				NewPrePhaseAnnounce:Start(nil, self.vb.PreHuy + 1)
			end
		end
	end
	---------HM------------
	--[[if spellId == 317262 then
		--ReflectSpellsCD:Start()
	end]]
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Ref1 or msg:find(L.Ref1) then
		ReflectSpellsCD:Start(21)
	elseif msg == L.Ref2 or msg:find(L.Ref2) then
		ReflectSpellsCD:Start(24)
	elseif msg == L.Ref3 or msg:find(L.Ref3) then
		ReflectSpellsCD:Start(25)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:IsStage(1) and not warned_preP1 and self:GetUnitCreatureId(uId) == 50612 and ((DBM:GetBossHPByUnitID(uId) % 25) < 3) then
		warned_preP1 = true
		warnPhase2Soon:Show()
	end
end
