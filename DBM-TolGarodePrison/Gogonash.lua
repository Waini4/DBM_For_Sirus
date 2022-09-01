local mod = DBM:NewMod("Gogonash", "DBM-TolGarodePrison")
-- local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision("20220312000000") -- fxpw check 20220609123000
mod:SetCreatureID(84000)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat", 84000)

mod:RegisterEvents(
	"SPELL_CAST_START 317549 317548 317541",
	"SPELL_CAST_SUCCESS 317543 317540",
	"SPELL_AURA_APPLIED 317544",
	"SPELL_AURA_APPLIED_DOSE 317544 317542",
	"SPELL_AURA_REMOVED 317544"
)

------------------------------10----------------------------------
local warnLightningofFilth = mod:NewSpellAnnounce(317549, 2)
local warnMarkofFilth      = mod:NewTargetAnnounce(317544, 2)
local warnFlesh            = mod:NewStackAnnounce(317542, 3, nil, "Tank") --Опаленная плоть

local specwarnPrimalHorror        = mod:NewSpecialWarningLookAway(317548, nil, nil, nil, 2, 2)
local specWarnMarkofFilthRun      = mod:NewSpecialWarningRun(317544, nil, nil, nil, 1, 2)
local yellMarkofFilth             = mod:NewYell(317544) --317158
local yellMarkofFilthFade         = mod:NewShortFadesYell(317544)
local specWarnEndlessflameofFilth = mod:NewSpecialWarningDispel(317540, "MagicDispeller", nil, nil, 1, 2)

local LightningofFilthCast = mod:NewCastTimer(1, 317549, nil, nil, nil, 2)
local PrimalHorrorCast     = mod:NewCastTimer(1.84, 317548, nil, nil, nil, 2) -- первобытный ужас
local CrushingBlowCast     = mod:NewCastTimer(2.5, 317541, nil, nil, nil, 2) -- Сокрушающий удар
local MarkofFilthBuff      = mod:NewBuffActiveTimer(5, 317544, nil, nil, nil, 2)

local timerFleshCD             = mod:NewCDTimer(35, 317542, nil, nil, nil, 5) --Опаленная плоть
local timerLightningofFilth    = mod:NewCDTimer(15, 317549, nil, nil, nil, 3) -- Молния скверны
local timerPrimalHorror        = mod:NewCDTimer(30, 317548, nil, nil, nil, 4, nil, CL.IMPORTANT_ICON, nil, 1)
local timerCrushingBlowCD      = mod:NewCDTimer(30, 317541, nil, nil, nil, 2, nil, CL.DEADLY_ICON)
local timerStrikingBlow        = mod:NewCDTimer(10, 317543, nil, "Tank", nil, 5, nil, CL.TANK_ICON)
local timerMarkofFilth         = mod:NewCDTimer(19, 317544, nil, nil, nil, 4, nil, CL.IMPORTANT_ICON)
local timerEndlessflameofFilth = mod:NewCDTimer(18.5, 317540, nil, nil, nil, 4, nil, CL.MAGIC_ICON)

mod:AddSetIconOption("SetIconMarkofFilthTargets", 317544, true, true, { 7, 8 })
mod:AddBoolOption("AnnounceMarkofFilth", false)
mod:AddBoolOption("BossHealthFrame", true, "misc")

local MarkTargets = {}
local MarkofFilthIcon = 8


-- local function sort_by_group(v1, v2)
-- 	return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
-- end
local function SetMarkIcons(self)
	warnMarkofFilth:Show(table.concat(MarkTargets, "<, >"))
	table.wipe(MarkTargets)
	MarkofFilthIcon = 8
end

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", function(self)
	for i = 1, MAX_RAID_MEMBERS do
		local pt = UnitName("raid" .. i .. "target")
		if pt and pt == "Гогонаш" then
			DBM:FireCustomEvent("DBM_EncounterStart", 84000, "Gogonash")
			--	self:SetStage(1)
			MarkofFilthIcon = 8
		end
	end
end)

--[[function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 84000, "Argaloth")
	if self:IsDifficulty("normal10") then
		self.vb.MarkofFilthIcon = 8
		timerStrikingBlow:Start(5 - delay)
		timerLightningofFilth:Start(8 - delay)
		timerMarkofFilth:Start(13 - delay)
		timerPrimalHorror:Start(24 - delay)
		timerCrushingBlowCD:Start(-delay)
		timerFleshCD:Start(-delay)
		if self.Options.BossHealthFrame then
			DBM.BossHealth:Show(L.name)
			DBM.BossHealth:AddBoss(84000, L.name)
		end
	end
end]]

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 84000, "Gogonash", wipe)
	timerStrikingBlow:Stop()
	timerLightningofFilth:Stop()
	timerMarkofFilth:Stop()
	timerPrimalHorror:Stop()
	timerCrushingBlowCD:Stop()
	timerFleshCD:Stop()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(317549) then
		warnLightningofFilth:Show()
		LightningofFilthCast:Start()
		timerLightningofFilth:Start()
	elseif args:IsSpellID(317548) then
		specwarnPrimalHorror:Show()
		PrimalHorrorCast:Start()
		timerPrimalHorror:Start()
	elseif args:IsSpellID(317541) then
		CrushingBlowCast:Start()
		timerCrushingBlowCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(317543) then
		timerStrikingBlow:Start()
	elseif args:IsSpellID(317540) then
		specWarnEndlessflameofFilth:Show()
		timerEndlessflameofFilth:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	-- local spellId = args.spellId
	if args:IsSpellID(317544) then
		MarkTargets[#MarkTargets + 1] = args.destName
		if self.Options.SetIconMarkofFilthTargets and MarkofFilthIcon > 0 then
			self:SetIcon(args.destName, MarkofFilthIcon)
		end
		MarkofFilthBuff:Start()
		timerMarkofFilth:Start()
		if args:IsPlayer() then
			specWarnMarkofFilthRun:Show()
			yellMarkofFilth:Yell()
			yellMarkofFilthFade:Countdown(317544)
		end
		MarkofFilthIcon = MarkofFilthIcon - 1
		self:Unschedule(SetMarkIcons)
		self:Schedule(0.1, SetMarkIcons, self)
	elseif args:IsSpellID(317542) then
		local amount = args.amount or 1
		warnFlesh:Show(args.destName, amount)
		timerFleshCD:Start()
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	-- local spellId = args.spellId
	if args:IsSpellID(317544) then
		if self.Options.SetIconMarkofFilthTargets then
			self:RemoveIcon(args.destName)
		end
	end
end
