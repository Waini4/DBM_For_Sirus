local mod	= DBM:NewMod("TheMaker", "DBM-Party-BC", 2, 256)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17381)

mod:SetModelID(18369)
mod:SetModelOffset(-4, 0, -0.4)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 30923 30925",
	"SPELL_AURA_REMOVED 30923"
)

local warnMindControl		= mod:NewTargetAnnounce(30923, 4)

local timerBomb				= mod:NewCDTimer(10, 30925, nil, nil, nil, 2)
local timerMindControlCD	= mod:NewCDTimer(34.6, 30923, nil, nil, nil, 2)
local timerMindControl		= mod:NewTargetTimer(10, 30923, nil, nil, nil, 3)

local MC = 1

mod:AddSetIconOption("SetIconOnDominateMind", 30923, true, true, {5})
mod:AddBoolOption("RemoveWeaponOnMindControl", true)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17381, "TheMaker")
	MC = 2
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17381, "TheMaker", wipe)
	MC = 1
end


local MCTimers = {
	[1] = 34.5,
	[2] = 25.1,
	[3] = 30.1,
	[4] = 30,
	[5] = 30,
	[6] = 30
}

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 30923 then
		warnMindControl:Show(args.destName)
		timerMindControl:Start(args.destName)
		if MC >= 2 then
			timerMindControlCD:Start()(MCTimers[MC])
			MC = MC + 1
		end
		if args:IsPlayer() and self.Options.RemoveWeaponOnMindControl then	-- автоснятие шмоток
			if self:IsWeaponDependent("player") then
				PickupInventoryItem(16)
				PutItemInBackpack()
				PickupInventoryItem(17)
				PutItemInBackpack()
			elseif select(2, UnitClass("player")) == "HUNTER" then
				PickupInventoryItem(18)
				PutItemInBackpack()
			end
		end
		if self.Options.SetIconOnDominateMind then
			self:SetIcon(args.destName, 6, 6)
		end
	end
	if args:IsSpellID(30925) then
		timerBomb:Start()	-- думаю не нужный, ни урона ни опаски. пусть стоит пока что,но таймер не верный там скрипт кривой
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 30923 then
		timerMindControl:Stop(args.destName)
		if self.Options.SetIconOnDominateMind then
			self:RemoveIcon(args.destName)
		end
	end
end
