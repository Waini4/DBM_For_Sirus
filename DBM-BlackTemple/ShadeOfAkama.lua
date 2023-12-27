local mod	= DBM:NewMod("Akama", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(22841)

mod:SetModelID(21357)

mod:RegisterCombat("combat")
--mod:SetWipeTime(50)--Adds come about every 50 seconds, so require at least this long to wipe combat if they die instantly

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 322728 322748 322747 322746 322745 322749",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 322728",
	"SPELL_CAST_START 322727 322728 322731 371519",
	"SPELL_CAST_SUCCESS",
	"SPELL_INTERRUPT ",
	"SPELL_SUMMON",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)
mod:RegisterEvents(
	"SPELL_AURA_REMOVED 34189"
)

--local warnPhase2		= mod:NewPhaseAnnounce(2)
--local warnDefender		= mod:NewAnnounce("warnAshtongueDefender", 2, 41180)
--local warnSorc			= mod:NewAnnounce("warnAshtongueSorcerer", 2, 40520)
local specWarnShadowclean 	= mod:NewSpecialWarningInterrupt(322727, "HasInterrupt", nil, nil, 1, 2)
local specWarnDevastating 	= mod:NewSpecialWarningInterrupt(371519, "HasInterrupt", nil, nil, 1, 2)
local specWarnFadeDebuff	= mod:NewSpecialWarningAddsCustom(40476, nil, nil, nil, 1, 2)
local specWarnMind			= mod:NewSpecialWarningSpell(322728, nil, nil, nil, 1, 3)

local warnDominateMind		= mod:NewTargetAnnounce(322728, 3)

local specWarnAdds			= mod:NewSpecialWarningAdds(40474, "-Healer", nil, nil, 1, 2)

local timerCombatStart		= mod:NewCombatTimer(12)
local timerAddsCD			= mod:NewAddsCustomTimer(120, 40474)--NewAddsCustomTimer
--local timerDefenderCD	= mod:NewTimer(25, "timerAshtongueDefender", 41180, nil, nil, 1)
--local timerSorcCD		= mod:NewTimer(25, "timerAshtongueSorcerer", 40520, nil, nil, 1)

local timerPlagueCD			= mod:NewCDTimer(32, 322731, nil, nil, nil, 5) --чума (должна диспелится)
local timerDominateMindCD	= mod:NewCDTimer(48, 322728, nil, nil, nil, 3)
local timerShadowcleanCD	= mod:NewCDTimer(13.5, 322727, nil, nil, nil, 4) --масс диспел
local timerDispelAkama		= mod:NewNextCountTimer(45, 322743, nil, nil, nil, 1)
local berserkTimer			= mod:NewBerserkTimer(360)


mod.vb.AddsWestCount = 0
mod.vb.ControlAkama = 0
local dominateMindTargets = {}
mod.vb.dominateMindIcon = 6
local isHunter = select(2, UnitClass("player")) == "HUNTER"
mod:AddSetIconOption("SetIconOnDominateMind", 322728, true, false, {4, 5, 6})
mod:AddSetIconOption("SetIconOnPokemon", 322748, true, true, { 3, 4, 5, 6, 7 })

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

local function has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

mod:AddMiscLine(L.EqUneqLineDescription)
mod:AddBoolOption("EqUneqWeapons", mod:IsDps(), nil, selfWarnMissingSet)
mod:AddBoolOption("EqUneqTimer", false)
mod:AddBoolOption("BlockWeapons", false)

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

local function showDominateMindWarning(self)
	warnDominateMind:Show(table.concat(dominateMindTargets, "<, >"))
	--timerDominateMindCD:Start()
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
		self:ScheduleMethod(29, "UnW")
	end
end

--[[
local function addsWestLoop(self)
	self.vb.AddsWestCount = self.vb.AddsWestCount + 1
	specWarnAdds:Show(DBM_COMMON_L.WEST)
	specWarnAdds:Play("killmob")
	specWarnAdds:ScheduleVoice(1, "west")
	if self.vb.AddsWestCount == 2 then--Special
		self:Schedule(51, addsWestLoop, self)
		timerAddsCD:Start(51, DBM_COMMON_L.WEST)
	else
		self:Schedule(47, addsWestLoop, self)
		timerAddsCD:Start(47, DBM_COMMON_L.WEST)
	end
end]]

local function addsLoop(self)
	specWarnAdds:Show()
	specWarnAdds:Play("killmob")
	--specWarnAdds:ScheduleVoice(1, "east")
	timerAddsCD:Start()
end
--[[
local function sorcLoop(self)
	warnSorc:Show()
	self:Schedule(25, sorcLoop, self)
	timerSorcCD:Start(25)
end

local function defenderLoop(self)
	warnDefender:Show()
	self:Schedule(30, defenderLoop, self)
	timerDefenderCD:Start(30)
end]]

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 22841, "Shade of Akama")
	self:SetStage(1)
	self.vb.AddsWestCount = 0
	self.vb.dominateMindIcon = 6
	self.vb.ControlAkama = 0
	berserkTimer:Start()
	timerDispelAkama:Start(nil, self.vb.ControlAkama)
	timerDominateMindCD:Start(30)
	self:Schedule(80, addsLoop, self)
	timerAddsCD:Start(80, "Боковые")
	self:RegisterShortTermEvents(
		"SWING_DAMAGE",
		"SWING_MISSED",
		"UNIT_SPELLCAST_SUCCEEDED"
	)
	--timerAddsCD:Start(18, DBM_COMMON_L.EAST or "East")
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 22841, "Shade of Akama", wipe)
	self:UnregisterShortTermEvents()
	self:UnscheduleMethod("UnW")
	self:UnscheduleMethod("EqW")
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
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 322728 then
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(322728) then
		-- DBM:Debug("MC on "..args.destName,2)
		if self.Options.EqUneqWeapons and args.destName == UnitName("player") and self:IsDps() then
			self:UnW()
			self:UnW()
			self:ScheduleMethod(0.01, "UnW")
			DBM:Debug("Unequipping",2)
		end
		dominateMindTargets[#dominateMindTargets + 1] = args.destName
		if self.Options.SetIconOnDominateMind then
			self:SetIcon(args.destName, self.vb.dominateMindIcon, 12)
		end
		self.vb.dominateMindIcon = self.vb.dominateMindIcon - 1
		self:Unschedule(showDominateMindWarning)
		self:Schedule(0.9, showDominateMindWarning, self)
	end
end


function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 34189 and args:GetDestCreatureID() == 23191 then--Coming out of stealth (he's been activated)
		timerCombatStart:Start()
	elseif args:IsSpellID(322728) then
		if (args.destName == UnitName("player") or args:IsPlayer()) and self.Options.EqUneqWeapons and self:IsDps() then
	        self:ScheduleMethod(0.1, "EqW")
	        self:ScheduleMethod(1.7, "EqW")
	        self:ScheduleMethod(3.3, "EqW")
			self:ScheduleMethod(5.0, "EqW")
			self:ScheduleMethod(8.0, "EqW")
			self:ScheduleMethod(9.9, "EqW")
		end
	elseif args:IsSpellID(322748) then
		if self.Options.SetIconOnPokemon then
			self:ScanForMobs(args.destGUID, 1, 5, 1, 0.1, 20, "SetIconOnPokemon")
		end
	elseif args:IsSpellID(322747) then
		if self.Options.SetIconOnPokemon then
			self:ScanForMobs(args.destGUID, 1, 6, 1, 0.01, 20, "SetIconOnPokemon")
		end
	elseif args:IsSpellID(322746) then
		if self.Options.SetIconOnPokemon then
			self:ScanForMobs(args.destGUID, 1, 4, 1, 0.01, 20, "SetIconOnPokemon")
		end
	elseif args:IsSpellID(322745) then
		if self.Options.SetIconOnPokemon then
			self:ScanForMobs(args.destGUID, 1, 7, 1, 0.01, 20, "SetIconOnPokemon")
		end
	elseif args:IsSpellID(322749) then
		if self.Options.SetIconOnPokemon then
			self:ScanForMobs(args.destGUID, 1, 3, 1, 0.01, 20, "SetIconOnPokemon")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, mob)
	if msg == L.SummonPepel or msg:find(L.SummonPepel) then
		self.vb.ControlAkama = self.vb.ControlAkama + 1
		timerDispelAkama:Start(nil, self.vb.ControlAkama + 1)
		specWarnFadeDebuff:Show(DBM_COMMON_L.NORTH)
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
function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 22841 then
		DBM:EndCombat(self)
	end
end