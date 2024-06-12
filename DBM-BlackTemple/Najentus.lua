local mod	= DBM:NewMod("Najentus", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2023".."11".."22".."10".."00".."00") --fxpw check
mod:SetCreatureID(22887)

mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 321595 321598",
	"SPELL_CAST_SUCCESS 321599 321596",
	"SPELL_AURA_APPLIED 321599",
	"SPELL_AURA_REMOVED 321599",
	"UNIT_HEALTH"
)

-- local warnShield		= mod:NewSpellAnnounce(39872, 4)
-- local warnShieldSoon	= mod:NewSoonAnnounce(39872, 10, 3)
-- local warnSpine			= mod:NewTargetNoFilterAnnounce(39837, 3)

-- local specWarnSpineTank	= mod:NewSpecialWarningTaunt(39837, nil, nil, nil, 1, 2)
-- local yellSpine			= mod:NewYell(39837)

-- local timerShield		= mod:NewCDTimer(56, 39872, nil, nil, nil, 5)

local warnCurse				= mod:NewTargetAnnounce(321599, 5)
local specudar           	= mod:NewSpecialWarningCount(321598, "Melee", nil, nil, 2, 2)
local specWarnCurse			= mod:NewSpecialWarningDispel(321599, "RemoveCurse", nil, nil, 1, 5)

local berserkTimer			= mod:NewBerserkTimer(360)

local kolossalnyi_udar		= mod:NewCDCountTimer(9, 321598, nil, nil, nil, 1) --SPELL_CAST_START
local grohot_priliva		= mod:NewCDCountTimer(20.5, 321595, nil, nil, nil, 5) --SPELL_CAST_START
local vodyanoe_proklyatie	= mod:NewCDTimer(30, 321599, nil, nil, nil, 2) --SPELL_CAST_SUCCESS
local pronzayous_ship		= mod:NewCDCountTimer(19, 321596, nil, nil, nil, 5) --SPELL_CAST_SUCCESS

mod.vb.MiniStage = 0
mod.vb.Urad = 0
mod.vb.GrohotCounter = 0
--local CurseStages = {}
--local PrilivStages = {}
--local ShipStages = {19, 20}
local warned_F1 = false
local warned_F2 = false
local warned_F3 = false
local warned_F4 = false
local warned_F5 = false
local warned_F6 = false

-- mod:AddSetIconOption("SpineIcon", 39837)
mod:AddInfoFrameOption(39878, true)
local CurseTargets = {}
mod.vb.CurseIcon = 8
mod:AddRangeFrameOption("8")

local function CurseIcons(self)
	warnCurse:Show(table.concat(CurseTargets, "<, >"))
	table.wipe(CurseTargets)
	self.vb.CurseIcon = 8
end

local function StagesUdar(self)
	self.vb.Urad = 0
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 22887, "High Warlord Naj'entus")
	self.vb.MiniStage = 0
	self.vb.Urad = 0
	self.vb.GrohotCounter = 0
	warned_F1 = false
	warned_F2 = false
	warned_F3 = false
	warned_F4 = false
	warned_F5 = false
	warned_F6 = false
	berserkTimer:Start(-delay)
	kolossalnyi_udar:Start(5.5, self.vb.Urad)
	grohot_priliva:Start(21, self.vb.GrohotCounter)
	vodyanoe_proklyatie:Start(30)
	pronzayous_ship:Start(19)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 22887, "High Warlord Naj'entus",wipe)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(kolossalnyi_udar.spellId) then
		specudar:Show(self.vb.Urad .. " из ".. self.vb.MiniStage)
		if self.vb.MiniStage ~= self.vb.Urad then
			kolossalnyi_udar:Start(3.7, self.vb.Urad)
			self.vb.Urad = self.vb.Urad + 1
			self:Unschedule(StagesUdar)
			self:Schedule(4.5, StagesUdar, self)
		else
			kolossalnyi_udar:Start(nil, self.vb.Urad)
			self.vb.Urad = 0
		end
	elseif args:IsSpellID(grohot_priliva.spellId) then
		--local timer = PrilivStages[self.vb.GrohotCounter]
			grohot_priliva:Start(nil, self.vb.GrohotCounter)
	end
end
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(vodyanoe_proklyatie.spellId) then
		vodyanoe_proklyatie:Start()
		specWarnCurse:Show(args.SpellName)
	elseif args:IsSpellID(pronzayous_ship.spellId) and self:AntiSpam(3,1) then
		pronzayous_ship:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(321599) then
		CurseTargets[#CurseTargets + 1] = args.destName
		if self.Options.SetIconCurseTargets and self.vb.CurseIcon > 0 then
			self:SetIcon(args.destName, self.vb.CurseIcon)
		end
		self.vb.CurseIcon = self.vb.CurseIcon - 1
		self:Unschedule(CurseIcons)
		self:Schedule(0.1, CurseIcons, self)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(321599) then
		if self.Options.SetIconCurseTargets then
			self:RemoveIcon(args.destName)
		end
	end
end

function mod:UNIT_HEALTH(uId)
	local hp = self:GetUnitCreatureId(uId) == 22887 and DBM:GetBossHP(22887) or nil
	if hp then
		if not warned_F1 and hp < 85 then
			warned_F1 = true
			self.vb.MiniStage = self.vb.MiniStage + 1
		elseif not warned_F2 and hp < 70 then
			warned_F2 = true
			self.vb.MiniStage = self.vb.MiniStage + 1
		elseif not warned_F3 and hp < 55 then
			warned_F3 = true
			self.vb.MiniStage = self.vb.MiniStage + 1
		elseif not warned_F4 and hp < 40 then
			warned_F4 = true
			self.vb.MiniStage = self.vb.MiniStage + 1
		elseif not warned_F5 and hp < 25 then
			warned_F5 = true
			self.vb.MiniStage = self.vb.MiniStage + 1
		elseif not warned_F6 and hp < 5 then
			warned_F6 = true
			self.vb.MiniStage = self.vb.MiniStage + 1
	end
		--DBM:Debug("Текущее значение: ".. self.vb.MiniStage.. " : ".. self.vb.GrohotCounter, 2)
	end
end