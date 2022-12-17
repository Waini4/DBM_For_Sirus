local mod	= DBM:NewMod("FlameLeviathan", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210501000000")

mod:SetCreatureID(33113)

mod:RegisterCombat("combat", 33113)

mod:RegisterEventsInCombat(
	"SPELL_AURA_REMOVED 312690 312689 62396",
	"SPELL_AURA_APPLIED 312689 312690 312336 62396 312339 312692 62475 312352 312705 62297",
	"SPELL_SUMMON 62907 312355 312363 312708 312716"
)


local warnHodirsFury		= mod:NewTargetAnnounce(312705)
local pursueTargetWarn		= mod:NewAnnounce("PursueWarn", 2, 62374)
local warnNextPursueSoon	= mod:NewAnnounce("warnNextPursueSoon", 3, 62374)

local warnSystemOverload	= mod:NewSpecialWarningSpell(62475)
local pursueSpecWarn		= mod:NewSpecialWarning("SpecialPursueWarnYou", nil, nil, 2, 4)
local warnWardofLife		= mod:NewSpecialWarning("warnWardofLife")

local timerWardofLife		= mod:NewCDTimer(30, 62907, nil, nil, nil, 2)
local timerSystemOverload	= mod:NewBuffActiveTimer(20, 62475, nil, nil, nil, 6)
local timerFlameVents		= mod:NewCastTimer(10, 312689, nil, nil, nil, 2)
local timerPursued			= mod:NewTargetTimer(30, 62374, nil, nil, nil, 3)

--local soundPursued = mod:NewSound(62374)
-- mod:AddBoolOption("HealthFrameBoss", true)


local guids = {}
local function buildGuidTable(self)
	table.wipe(guids)
	for uId in DBM:GetGroupMembers() do
		local name, server = GetUnitName(uId, true)
		local fullName = name .. (server and server ~= "" and ("-" .. server) or "")
		guids[UnitGUID(uId.."pet") or "none"] = fullName
	end
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 33113, "FlameLeviathan")
	buildGuidTable(self)
	if mod:IsDifficulty("heroic10") then
		timerWardofLife:Start(-delay)
	else
		timerWardofLife:Start(30)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 33113, "FlameLeviathan", wipe)

	timerWardofLife:Cancel()
	timerPursued:Cancel()
end

function mod:OnTimerRecovery()
	buildGuidTable(self)
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 62907 or spellId == 312355 or spellId == 312363 or spellId == 312708 or spellId == 312716 then		-- Ward of Life spawned (Creature id: 34275)
		if self:AntiSpam(5, "warnWardofLife") then
			warnWardofLife:Show()
		timerWardofLife:Start(25)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312689 or spellId == 312690 or spellId == 312336 or spellId == 62396 then		-- Flame Vents
		timerFlameVents:Start()
	elseif spellId == 312339 or spellId == 312692 or spellId == 62475 then	-- Systems Shutdown / Overload
		timerSystemOverload:Start()
		warnSystemOverload:Show()
	elseif spellId == 62374 then	-- Pursued
		local target = guids[args.destGUID]
		warnNextPursueSoon:Schedule(25)
		timerPursued:Start(target)
		pursueTargetWarn:Show(target)
		if target then
			pursueTargetWarn:Show(target)
			if target == UnitName("player") then
				pursueSpecWarn:Show()
			end
		end
	elseif spellId == 312352 or spellId == 312705 or spellId == 62297 then		-- Hodir's Fury (Person is frozen)
			warnHodirsFury:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 312690 or spellId == 312689 or spellId == 62396 then
		timerFlameVents:Stop()
	end
end