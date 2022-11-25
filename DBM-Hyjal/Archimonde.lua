local mod	= DBM:NewMod("Archimonde", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17968)
mod:SetZone()
-- mod:SetUsedIcons(8)
mod:SetUsedIcons(1,2,3,4,5,7, 8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 319910 319906 319917 319922",
	"SPELL_AURA_APPLIED 319907 319917 319931",
	"SPELL_AURA_REMOVED 319907 319917 319931",
	-- "SPELL_CAST_SUCCESS "
	"UNIT_HEALTH"
)


local warnLeg   				= mod:NewTargetNoFilterAnnounce(319907, 3)
local warnSoulAbductionTarget 	= mod:NewTargetAnnounce(319917, 1)
local warnHarassmentTarget 		= mod:NewTargetAnnounce(319931, 1)
local warnPhase					= mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)

local specWarnSoulAbduction	= mod:NewSpecialWarningMoveTo(319917, nil, nil, nil, 2, 4)
local specWarnMarkofLegion	= mod:NewSpecialWarningYou(319907, nil, nil, nil, 4, 2)
local specWarnHarassment	= mod:NewSpecialWarningMoveAway(319931, nil, nil, nil, 4, 4)

-- 10/20 19:48:32.669  SPELL_CAST_START,0xF130004630000052,"Архимонд",0xa48,0x0000000000000000,nil,0x80000000,319910,"Пламя Рока",0x8
local markOfRockCD		= mod:NewCDTimer(40, 319910, nil, nil, nil, 3) -- Пламя рока кд
local markOfLegDur		= mod:NewTargetTimer(10, 319907, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON) -- метка легиона
local sosCD				= mod:NewCDTimer(40, 319917, nil, nil, nil, 3) -- состалка кд
local markOfLegCD		= mod:NewCDTimer(22, 319907, nil, nil, nil, 2) -- метка легиона кд
local ShadowGeyserCD	= mod:NewCDTimer(20, 319922, nil, nil, nil, 4)
local perstCD			= mod:NewNextTimer(8, 319906, nil, "Tank", nil, 4, nil, DBM_COMMON_L.TANK_ICON) -- перст кд
local berserkTimer		= mod:NewBerserkTimer(600)
local yellMark			= mod:NewYell(319907)
local yellMarkFade		= mod:NewShortFadesYell(319907)
local yellHaras			= mod:NewYell(319931)


mod:AddNamePlateOption("markOfLegPlate", 319907, true)
mod:AddNamePlateOption("SoulAbductionPlate", 319917, true)
mod:AddNamePlateOption("HarassmentPlate", 319931, true)
mod:AddSetIconOption("SetIconOnLegTarget", 319907, true, true, { 7, 8 })
mod:AddSetIconOption("SetIconOnSos", 319917, true, true, { 1,2,3,4,5 })

local SoulTargets = {}
local HarasmTargets = {}
local warned_F1 = false
local warned_F2 = false
mod.vb.markLegion = 8
mod.vb.markSos = 5
mod.vb.FlameCount = 0
mod.vb.MarkCount = 0

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17968, "Archimonde")
	self:SetStage(1)
	warned_F1 = false
	warned_F2 = false
	perstCD:Start(16)
	markOfLegCD:Start()
	markOfRockCD:Start(40)
	self.vb.markLegion = 8
	self.vb.markSos = 5
	berserkTimer:Start()
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17968, "Archimonde")
end

-- local markOfRockDur				= mod:NewTargetTimer(30, 319910, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
-- local markOfLegDur				= mod:NewTargetTimer(30, 319907, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
-- 10/20 19:48:14.450  SPELL_AURA_APPLIED,0xF130004630000052,"Архимонд",0x10a48,0x000000000019EA63,"Аптеччка",0x512,319907,"Метка Легиона",0x20,DEBUFF

-- 10/20 19:48:44.783  SPELL_AURA_APPLIED,0x0000000000000000,nil,0x80000000,0x00000000000157DA,"Overdosen",0x514,319914,"Пламя Рока",0x4,DEBUFF
-- 10/20 19:48:44.783  SPELL_AURA_APPLIED,0x0000000000000000,nil,0x80000000,0x00000000000157DA,"Overdosen",0x514,319914,"Пламя Рока",0x4,DEBUFF
-- local timerFlameOfRockCD		= mod:NewCDTimer(41, 319914, nil, nil, nil, 2) -- пламя рока кд

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(perstCD.spellId) then
		perstCD:Start()
	elseif args:IsSpellID(markOfRockCD.spellId) then
		markOfRockCD:Start()
	elseif args:IsSpellID(sosCD.spellId) then
		sosCD:Start()
	elseif args:IsSpellID(319922) then -- 2 фаза
		ShadowGeyserCD:Start()
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(markOfLegDur.spellId) then
		markOfLegDur:Start(args.destName)
		if DBM:CanUseNameplateIcons() and self.Options.markOfLegPlate then
			DBM.Nameplate:Show(args.destGUID, 319907)
		end
		if args:IsPlayer() then
			specWarnMarkofLegion:Show()
			yellMark:Yell()
			yellMarkFade:Countdown(319907)
		end
		if self.Options.SetIconOnLegTarget then
			self:SetIcon(args.destName, self.vb.markLegion)
			self.vb.markLegion = self.vb.markLegion - 1
			if self.vb.markLegion < 7 then
				self.vb.markLegion = 8
			end
		end
		warnLeg:Show(args.destName)
	elseif args:IsSpellID(319917) then
		warnSoulAbductionTarget:Show(table.concat(SoulTargets, "<, >"))
		if args:IsPlayer() then
			specWarnSoulAbduction:Show("Беги в воду!")
		end
		if DBM:CanUseNameplateIcons() and self.Options.SoulAbductionPlate then
			DBM.Nameplate:Show(args.destGUID, 319917)
		end
		if self.Options.SetIconOnSos then
			self:SetIcon(args.destName, self.vb.markSos)
			self.vb.markSos = self.vb.markSos - 1
			if self.vb.markSos < 1 then
				self.vb.markSos = 5
			end
		end
		table.wipe(SoulTargets)
	elseif args:IsSpellID(319931) then
		warnHarassmentTarget:Show(table.concat(HarasmTargets, "<, >"))
		if args:IsPlayer() then
			specWarnHarassment:Show()
			yellHaras:Yell()
		end
		if DBM:CanUseNameplateIcons() and self.Options.HarassmentPlate then
			DBM.Nameplate:Show(args.destGUID, 319931)
		end
		table.wipe(HarasmTargets)
	end
end

-- 10/20 19:48:46.750  SPELL_AURA_REMOVED,0xF130004630000052,"Архимонд",0xa48,0x00000000001A0EF0,"Antaras",0x514,319907,"Метка Легиона",0x20,DEBUFF
-- local markOfLegCD			 =  mod:NewCDTimer(22, 319907, nil, nil, nil, 2) -- метка легиона кд

-- 10/20 19:48:46.750  SPELL_AURA_REMOVED,0xF130004630000052,"Архимонд",0xa48,0x00000000001A0EF0,"Antaras",0x514,319907,"Метка Легиона",0x20,DEBUFF
-- local markOfLegVzrivCD		= mod:NewCDTimer(22, 319908, nil, nil, nil, 2) -- взрыв кд
function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(markOfLegCD.spellId) then
		markOfLegCD:Start()
		if DBM:CanUseNameplateIcons() and self.Options.markOfLegPlate then
			DBM.Nameplate:Hide(args.destGUID, 319907)
		end
		self:RemoveIcon(args.destName)
	elseif args:IsSpellID(319917) then
		if self.Options.SetIconOnSos then
			self:RemoveIcon(args.destName)
		end
		if DBM:CanUseNameplateIcons() and self.Options.SoulAbductionPlate then
			DBM.Nameplate:Hide(args.destGUID, 319917)
		end
	elseif args:IsSpellID(319931) then
		if DBM:CanUseNameplateIcons() and self.Options.HarassmentPlate then
			DBM.Nameplate:Hide(args.destGUID, 319931)
		end
		if args:IsPlayer() then
			yellMarkFade:Cancel()
		end
	end
end
--40.5
-- SPELL_CAST_START,0xF130004630000052,"Архимонд",0x10a48,0x0000000000000000,nil,0x80000000,319906,"Перст гибели",0x20
-- 10/20 20:53:30.653  SPELL_CAST_START,0xF130004630000001,"Архимонд",0x10a48,0x0000000000000000,nil,0x80000000,319917,"Похищение души",0x20
function mod:UNIT_HEALTH(uId)
	local hp = self:GetUnitCreatureId(uId) == 17968 and DBM:GetBossHP(17968) or nil
	if hp then -- or hp < 82 or hp < 72 or hp < 62 or hp < 52 or hp < 42 or hp < 32 or hp < 22 or hp < 12 then
		if not warned_F1 and hp < 77 then
			self:SetStage(2)
			warned_F1 = true
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
			warnPhase:Play("ptwo")
		elseif not warned_F2 and hp < 50 then
			warned_F2 = true
			self:SetStage(3)
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(3))
			warnPhase:Play("pthree")
		end
	end
end



