local mod	= DBM:NewMod("Shirrak", "DBM-Party-BC", 7, 247)

mod:SetRevision("20220518110528")
mod:SetCreatureID(18371)

mod:SetModelID(18916)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)


mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 32264",
	"SPELL_CAST_SUCCESS 39382 32265"
)

local warnFocusFire				= mod:NewTargetAnnounce(32300, 3)

local specWarnFocusFire			= mod:NewSpecialWarningDodge(32300, nil, nil, nil, 1, 2)
local timerSuppressionCD		= mod:NewCDTimer(3.3, 32264, nil, nil, nil, 1, 2)
local timerBiteCD		        = mod:NewCDTimer(10, 39382, nil, nil, nil, 1, 2)
local timerFireCD		        = mod:NewCDTimer(15, 42075, nil, nil, nil, 1, 2)
local timerAttractionCD	        = mod:NewCDTimer(30, 32265, nil, nil, nil, 1, 2)
-- local specWarnFire          	= mod:NewSpecialWarningYou(42075)


function mod:OnCombatStart(delay)
	timerSuppressionCD:Start()
	timerBiteCD:Start()
	timerAttractionCD:Start()
	timerFireCD:Start()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(32264) then
		timerSuppressionCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(39382) then
		timerBiteCD:Start()
	elseif args:IsSpellID(32265) then
		timerAttractionCD:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, _, _, _, target)
	local targetname = DBM:GetUnitFullName(target) or target
	if targetname == UnitName("player") then
		timerFireCD:Start()
		specWarnFocusFire:Show()
		specWarnFocusFire:Play("watchstep")
	else
		warnFocusFire:Show(target)
	end
end