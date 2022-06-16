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
local dominateMindTargets = {}

mod:AddSetIconOption("SetIconOnDominateMind", 30923, true, true, {6})
mod:AddBoolOption("RemoveWeaponOnMindControl", true)


function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 30923 then
		warnMindControl:Show(args.destName)
		timerMindControl:Start(args.destName)
		if MC == 1 then	--"Власть-30923-npc:17381 = pull:34.6, 25.1, 30.2", -- [4]
			timerMindControlCD:Start()
			MC = MC + 1
		elseif MC == 2 then
			timerMindControlCD:Start(25,1)
			MC = MC + 1
		elseif MC == 3 then
			timerMindControlCD:Start(30,2)
			MC = MC + 1
		else timerMindControlCD:Start()
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
		dominateMindTargets[#dominateMindTargets + 1] = args.destName
		if self.Options.SetIconOnDominateMind then
			self:SetIcon(args.destName, dominateMindIcon, 12)
			dominateMindIcon = dominateMindIcon - 1
		end
	end
	if args:IsSpellID(30925) then
		timerBomb:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 30923 then
		timerMindControl:Stop(args.destName)
	end
end
