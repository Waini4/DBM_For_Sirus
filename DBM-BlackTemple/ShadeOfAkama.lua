local mod = DBM:NewMod("Akama", "DBM-BlackTemple")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(22841)

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellKill)
--mod:SetWipeTime(50)--Adds come about every 50 seconds, so require at least this long to wipe combat if they die instantly

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 322728 322748 322747 322746 322745 322749 371509 322732 322734 322739 374653",
	--"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 322728 371509 322732 322743 374653",
	"SPELL_CAST_START 322727 322728 322731 322737 371519 322739",
	"SPELL_CAST_SUCCESS 371507 371511",
	--"SPELL_INTERRUPT ",
	--"SPELL_SUMMON",
	"SPELL_HEAL 322750",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)
mod:RegisterEvents(
	"SPELL_AURA_REMOVED 34189",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_TARGET",
	"UNIT_HEALTH"
)

--local warnDefenderSoon	= mod:NewSoonAnnounce("warnAshtongueDefender", 2, 41180)
--local warnSorc			= mod:NewAnnounce("warnAshtongueSorcerer", 2, 40520)
local warnPhase2       = mod:NewPhaseAnnounce(2)
local warnDominateMind = mod:NewTargetAnnounce(322728, 3)
local warnDom          = mod:NewCastAnnounce(322739, 3, 1)


local specWarnDom         = mod:NewSpecialWarningTarget(322739, nil, nil, nil, 1, 1)
local specWarnShadowclean = mod:NewSpecialWarningInterrupt(322727, "HasInterrupt", nil, nil, 1, 2)
local specWarnDevastating = mod:NewSpecialWarningInterrupt(371519, "HasInterrupt", nil, nil, 1, 2)
--local specWarnFadeDebuff 	= mod:NewSpecialWarningFades(322743, nil, nil, nil, 3, 4)
--local specWarnPePa		= mod:NewSpecialWarningAdds(40476, nil, nil, nil, 1, 2)
local specWarnMind        = mod:NewSpecialWarningSpell(322728, nil, nil, nil, 1, 3)
local specWarnDPS         = mod:NewSpecialWarning(
	"|cffffe00a|Hspell:374653|hОстаточные эманации|h|r ПОЯВИЛОСЬ, МОЖНО БИТЬ АКАМУ!!!!", nil, nil, nil, 1, 3)
local specWarnFadeDebuff  = mod:NewSpecialWarning(
	"|cff71d5ff|Hspell:322743|hЗа гранью|h|r СПАЛО, МОЖНО БИТЬ ЧАРОТВОРЦА!!!!", nil, nil, nil, 3, 2)
local specWarnReflect     = mod:NewSpecialWarningReflect(371509, nil, nil, nil, 2, 3)
--local specWarnClean		= mod:NewSpecialWarningSpell(371511, nil, nil, nil, 1, 3)
local specWarnInferno     = mod:NewSpecialWarningCast(322737, nil, nil, nil, 1, 2)
local specCowardice       = mod:NewSpecialWarning("НЕ СБИЛИ |cff71d5ff|Hspell:322750|hЛик Тени|h|r БОСС ОТХИЛИЛСЯ!!!!",
	nil, nil, nil, 2, 2)
local specWarnDef         = mod:NewSpecialWarningSoon(40474, "-Healer", nil, nil, 1, 2)
local specWarnAdds        = mod:NewSpecialWarningSoon(42035, "-Healer", nil, nil, 1, 2)



local timerCombatStart    = mod:NewCombatTimer(12)
local timerDefendCD       = mod:NewAddsCustomTimer(70, 40474, "Защитники: %d", nil, nil, 5) --NewAddsCustomTimer
local timerAddsCD         = mod:NewAddsCustomTimer(40, 42035, "Адды: %d", nil, nil, 5)
--local timerDefenderCD	= mod:NewTimer(25, "timerAshtongueDefender", 41180, nil, nil, 1)
--local timerSorcCD		= mod:NewTimer(25, "timerAshtongueSorcerer", 40520, nil, nil, 1)
local timerInfernoCast    = mod:NewCastTimer(3.5, 322737, nil, nil, nil, 2)
local timerPlagueCD       = mod:NewCDTimer(32, 322731, nil, nil, nil, 5)   --чума (должна диспелится)
local timerDominateMindCD = mod:NewCDTimer(48, 322728, nil, nil, nil, 3)
local timerShadowcleanCD  = mod:NewCDTimer(13.5, 322727, nil, nil, nil, 4) --масс диспел
local timercleanCD        = mod:NewCDTimer(15, 371511, nil, nil, nil, 4)   --диспел 5 челов
local timerDispelAkama    = mod:NewNextCountTimer(50, 322743, nil, nil, nil, 1)
--local timerWaveCD			= mod:NewCDTimer(7, 371507, nil, nil, nil, 3)
local timerReflect        = mod:NewCDTimer(12, 371509, nil, "SpellCaster", nil, 3)
local timerInferno        = mod:NewCDTimer(20, 322737, nil, nil, nil, 3)
local timerReflectBuff    = mod:NewBuffActiveTimer(3, 371509, nil, nil, nil, 3)
local timerDpsBuff        = mod:NewBuffActiveTimer(10, 374653, nil, nil, nil, 5)
local berserkTimer        = mod:NewBerserkTimer(360)
local Stage2              = mod:NewPhaseTimer(360, nil, "Фаза: %d", nil, nil, 4)
local timerDomCD          = mod:NewCDTimer(27, 322739, nil, nil, nil, 4)

--mod:AddBoolOption("SetNecromancerIcon", false)
--mod:AddNamePlateOption("Nameplate1", 371509, true)
mod:AddNamePlateOption("Nameplate2", 322732, true)
mod:AddBoolOption("RaidSay", false)
mod:AddSetIconOption("SetIconOnBeacon", 322748, true, true, { 1, 2, 3, 4, 5, 6, 7, 8 })
--mod:AddSetIconOption("SetIconOnDominateMind", 322728, true, false, {4, 5, 6})

--mod.vb.NecromancerIcon = 1
local EndAkama = false
local dominateMindTargets = {}
mod.vb.warnDefenderCount = 1
mod.vb.AddsLoop = 0
mod.vb.ControlAkama = 0
--mod.vb.dominateMindIcon = 6
--local Adds = {}
--local addsLoops = {50, 70}

local function addsLoop(self)
	self.vb.AddsLoop = self.vb.AddsLoop + 1
	self.vb.warnDefenderCount = self.vb.warnDefenderCount + 1
	timerReflect:Start()
	specWarnDef:Schedule(65)
	timerDefendCD:Start(70, self.vb.warnDefenderCount + 1)
	specWarnAdds:Schedule(35)
	timerAddsCD:Start(40, self.vb.AddsLoop + 1)
	self:Schedule(70, addsLoop, self)
end

local function warnMindTargets(self)
	warnDominateMind:Show(table.concat(dominateMindTargets, "<, >"))
	table.wipe(dominateMindTargets)
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 22841, "Shade of Akama")
	self:SetStage(1)
	EndAkama = false
	self.vb.warnDefenderCount = 1
	self.vb.AddsLoop = 0
	--self.vb.dominateMindIcon = 6
	self.vb.ControlAkama = 0
	Stage2:Start(nil, 2)
	timerDispelAkama:Start(30, self.vb.ControlAkama)
	timerDominateMindCD:Start(30)
	self:Schedule(10, addsLoop, self)
	timerAddsCD:Start(10, self.vb.AddsLoop)
	self:RegisterShortTermEvents(
		"SWING_DAMAGE",
		"SWING_MISSED",
		"UNIT_SPELLCAST_SUCCEEDED"
	)
	if self.Options.HealthFrame then
		DBM.BossHealth:Show(L.name)
		DBM.BossHealth:AddBoss(22841, L.name)
		DBM.BossHealth:AddBoss(23421, L.Ciao)
		DBM.BossHealth:AddBoss(23524, L.Dusha)
		DBM.BossHealth:AddBoss(23523, L.Groz)
		DBM.BossHealth:AddBoss(23318, L.CrisaTH)
		DBM.BossHealth:AddBoss(23216, L.GigaChad)
	end
	--timerAddsCD:Start(18, DBM_COMMON_L.EAST or "East")
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 22841, "Shade of Akama", wipe)
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(322728) then
		specWarnMind:Show()
		timerDominateMindCD:Start()
	elseif args:IsSpellID(322727) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnShadowclean:Show(args.sourceName)
		end
		timerShadowcleanCD:Start()
	elseif args:IsSpellID(371519) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDevastating:Show(args.sourceName)
		end
	elseif args:IsSpellID(322737) then
		timerInfernoCast:Start()
		specWarnInferno:Schedule(3)
		timerInferno:Start()
	elseif args:IsSpellID(322739) then
		warnDom:Show()
		timerDomCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	--if args:IsSpellID(371507) and self:AntiSpam(2,2) then
	--	specWarnWave:Show()
	--	timerWaveCD:Start()
	--if args:IsSpellID(371511) then
	--	specWarnClean:Show()
	--	timercleanCD:Start()
	--end
end

--[[
322748,"Пепельная Эгида - Тьма"
322747,"Пепельная Эгида - Лед"
322746,"Пепельная Эгида - Природа"
322745,"Пепельная Эгида - Огонь"
322749,"Пепельная Эгида - Тайная магия
]]

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(322728) then
		dominateMindTargets[#dominateMindTargets + 1] = args.destName
		self:Unschedule(warnMindTargets)
		self:Schedule(0.1, warnMindTargets, self)
		-- DBM:Debug("MC on "..args.destName,2)
	elseif args:IsSpellID(322748) then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 1, 5, 1, 0.1, 20, "SetIconOnBeacon")
		end
	elseif args:IsSpellID(322747) then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 1, 6, 1, 0.01, 20, "SetIconOnBeacon")
		end
	elseif args:IsSpellID(322746) then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 1, 4, 1, 0.01, 20, "SetIconOnBeacon")
		end
	elseif args:IsSpellID(322745) then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 1, 7, 1, 0.01, 20, "SetIconOnBeacon")
		end
	elseif args:IsSpellID(322749) then
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 1, 3, 1, 0.01, 20, "SetIconOnBeacon")
		end
	elseif args:IsSpellID(371509) and self:AntiSpam(8, 1) then
		specWarnReflect:Show(args.destName)
		timerReflectBuff:Start()
	elseif args:IsSpellID(322732) then
		if self.Options.Nameplate2 then
			DBM.Nameplate:Show(args.destGUID, 322732)
		end
	elseif args:IsSpellID(322734) then
		warnPhase2:Show()
		timerInferno:Start(15)
		timerDomCD:Start(31)
		berserkTimer:Start()
		self:NextStage()
	elseif args:IsSpellID(322739) then
		specWarnDom:Show(args.destName)
		if self.Options.SetIconOnBeacon then
			self:ScanForMobs(args.destGUID, 1, 8, 1, 0.01, 20, "SetIconOnBeacon")
		end
	elseif args:IsSpellID(374653) then
		specWarnDPS:Show()
		timerDpsBuff:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 34189 and args:GetDestCreatureID() == 23191 then --Coming out of stealth (he's been activated)
		timerCombatStart:Start()
		--elseif args:IsSpellID(322728) then
	elseif args:IsSpellID(371509) then
		timerReflect:Start()
	elseif args:IsSpellID(322732) then
		if self.Options.Nameplate2 then
			DBM.Nameplate:Hide(args.destGUID, 322732)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, mob)
	if msg == L.SummonPepel or msg:find(L.SummonPepel) then
		self.vb.ControlAkama = self.vb.ControlAkama + 1
		timerDispelAkama:Start(nil, self.vb.ControlAkama + 1)
		specWarnFadeDebuff:Show()
	end
end

function mod:SPELL_HEAL(_, _, _, _, destName, _, spellId)
	--local spellId = args.spellId
	if spellId == 322750 then
		specCowardice:Show()
		if self.Options.RaidSay then
			SendChatMessage("ПРОШЕЛ ХИЛ!!!!!!!!!", "RAID")
		end
	end
end

--[[
function mod:SWING_DAMAGE(_, sourceName)
	if sourceName == L.name and self.vb.phase == 1 then
		self:UnregisterShortTermEvents()
		self:SetStage(2)
		warnPhase2:Show()
		timerAddsCD:Stop()
		timerDefenderCD:Stop()
		timerSorcCD:Stop()
		self:Unschedule(addsWestLoop)
		self:Unschedule(addsEastLoop)
		self:Unschedule(sorcLoop)
		self:Unschedule(defenderLoop)
	end
end
mod.SWING_MISSED = mod.SWING_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if (spellId == 40607 or spellId == 40955) and self.vb.phase == 1 and self:AntiSpam(3, 1) then--Fixate/Summon Shade of Akama Trigger
		self:UnregisterShortTermEvents()
		self:SetStage(2)
		warnPhase2:Show()
		timerAddsCD:Stop()
		timerDefenderCD:Stop()
		timerSorcCD:Stop()
		self:Unschedule(addsWestLoop)
		self:Unschedule(addsEastLoop)
		self:Unschedule(sorcLoop)
		self:Unschedule(defenderLoop)
	end
end
]]
--[[function mod:UNIT_TARGET()
	if self.Options.SetNecromancerIcon then
		local uid = ScanWhitName("Пеплоуст-чаротворец")
		if uid then
			self:SetIcon(uid, 8)
		end
	end
end]]

function mod:UNIT_HEALTH(uId)
	if UnitHealth(uId) / UnitHealthMax(uId) <= 0.01 and self:GetUnitCreatureId(uId) == 23191 and not EndAkama then
		EndAkama = true
		DBM:EndCombat(self)
	end
end
