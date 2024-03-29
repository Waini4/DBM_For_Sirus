local mod	= DBM:NewMod("Grobbulus", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041927")
mod:SetCreatureID(15931)
mod:SetUsedIcons(1, 2, 3, 4)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 28169",
	"SPELL_AURA_REMOVED 28169",
	"SPELL_CAST_SUCCESS 28240 28157 54364"
)

local myRealm = select(4, DBM:GetMyPlayerInfo()) == 1

local warnInjection			= mod:NewTargetNoFilterAnnounce(28169, 2)
local warnCloud				= mod:NewSpellAnnounce(28240, 2)
local warnSlimeSprayNow		= mod:NewSpellAnnounce(54364, 2)
local warnSlimeSpraySoon	= mod:NewSoonAnnounce(54364, 1)

local specWarnInjection		= mod:NewSpecialWarningYou(28169, nil, nil, nil, 1, 2)
local yellInjection			= mod:NewYellMe(28169, nil, false)

local timerInjection		= mod:NewTargetTimer(10, 28169, nil, nil, nil, 3)
local timerCloud			= mod:NewNextTimer(15, 28240, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerSlimeSpray		= mod:NewNextTimer(myRealm and 20 or 32, 54364, nil, nil, nil, 2)
local enrageTimer			= mod:NewBerserkTimer(myRealm and 600 or 720)

mod:AddSetIconOption("SetIconOnInjectionTarget", 28169, false, false, {1, 2, 3, 4})

mod.vb.slimeSprays = 1
local mutateIcons = {}

local function addIcon(self)
	for i,j in ipairs(mutateIcons) do
		local icon = 0 + i
		self:SetIcon(j, icon)
	end
end

local function removeIcon(self, target)
	for i,j in ipairs(mutateIcons) do
		if j == target then
			table.remove(mutateIcons, i)
			self:SetIcon(target, 0)
		end
	end
	addIcon(self)
end

function mod:OnCombatStart(delay)
	self.vb.slimeSprays = 1
	table.wipe(mutateIcons)
	enrageTimer:Start(-delay)
	timerCloud:Start(myRealm and 14 or 15)
	warnSlimeSpraySoon:Schedule(27)
	timerSlimeSpray:Start()
end

function mod:OnCombatEnd()
	for _, j in ipairs(mutateIcons) do
		self:SetIcon(j, 0)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 28169 then
		warnInjection:Show(args.destName)
		timerInjection:Start(args.destName)
		if args:IsPlayer() then
			specWarnInjection:Show()
			specWarnInjection:Play("runout")
			yellInjection:Yell()
		end
		if self.Options.SetIconOnInjectionTarget then
			table.insert(mutateIcons, args.destName)
			addIcon(self)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 28169 then
		timerInjection:Cancel(args.destName)--Cancel timer if someone is dumb and dispels it.
		if self.Options.SetIconOnInjectionTarget then
			removeIcon(self, args.destName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 28240 then
		warnCloud:Show()
		timerCloud:Start()
	elseif args:IsSpellID(28157, 54364) then
		warnSlimeSprayNow:Show()
		self.vb.slimeSprays = self.vb.slimeSprays + 1
		if self.vb.slimeSprays % 2 == 0 then -- every 2/4/6... spray short cd
			warnSlimeSpraySoon:Schedule(myRealm and 20 or 26)
			timerSlimeSpray:Start(myRealm and 20 or 31)
		else -- every 3/5/7... spray long cd
			warnSlimeSpraySoon:Schedule(myRealm and 20 or 54)
			timerSlimeSpray:Start(myRealm and 20 or 59)
		end
	end
end