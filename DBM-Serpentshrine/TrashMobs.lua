local mod = DBM:NewMod("TrashMobs", "DBM-Serpentshrine")
-- local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(21251)

-- mod:RegisterEvents(
-- 	"CHAT_MSG_MONSTER_YELL",
-- 	"UNIT_DIED",
-- 	"UNIT_TARGET",
-- 	"CHAT_MSG_LOOT"
-- )
mod:RegisterEvents(
	"SPELL_AURA_APPLIED 39042"
-- "SPELL_CAST_START",
-- "SPELL_CAST_SUCCESS",
-- "SPELL_AURA_REMOVED"
)

local specWarnRange = mod:NewSpecialWarningMoveAway(39042)


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(39042) then
		DBM.RangeCheck:Show(10)
		if args:IsPlayer() and self:AntiSpam(4) then
			specWarnRange:Show()
		end
	end
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
end
