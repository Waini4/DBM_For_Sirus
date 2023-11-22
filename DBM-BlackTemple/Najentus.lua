local mod	= DBM:NewMod("Najentus", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2023".."11".."22".."10".."00".."00") --fxpw check
mod:SetCreatureID(22887)

mod:SetModelID(21174)
mod:SetUsedIcons(8)
--[[
["SPELL_CAST_START"] = {
"Грохот Прилива-321595-npc:22887 = pull:0.0, 0.0, -0.0, -0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0", -- [1]
"Колоссальный удар-321598-npc:22887 = pull:0.0, 0.0, -0.0, -0.0, 0.0, -0.0, -0.0, 0.0, 0.0, -0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, -0.0, -0.0, 0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, 0.0, -0.0, -0.0, -0.0, 0.0, 0.0, 0.0, -0.0, -0.0, -0.0, 0.0, 0.0, -0.0, -0.0, 0.0, -0.0, -0.0, -0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, -0.0, -0.0, 0.0, -0.0", -- [2]
},
["SPELL_CAST_SUCCESS"] = {
"Водяное проклятие-321599-npc:22887 = pull:0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0", -- [1]
"Пронзающий шип-321596-npc:22887 = pull:0.0, 0.0, -0.0, -0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, -0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0", -- [2]
},
["SPELL_AURA_APPLIED"] = {
"Водяное проклятие-321599-npc:22887 = pull:0.0[+2], -0.0[+5], -0.0[+4], -0.0[+9], -0.0[+6], -0.0[+13], -0.0[+6], -0.0[+2], -0.0[+2], -0.0[+2], -0.0[+9]", -- [1]
"Грохот Прилива-321595-npc:22887 = pull:0.0[+4], -0.0[+2], -0.0[+3], -0.0, -0.0[+3], -0.0[+4], -0.0[+5], -0.0[+1], -0.0[+4], -0.0[+8], -0.0[+5], -0.0, -0.0[+7], -0.0[+1], -0.0[+2], -0.0[+2], -0.0[+1], -0.0[+3], -0.0[+3], -0.0[+4], -0.0[+2], -0.0[+1], -0.0[+3], -0.0[+3], -0.0[+2], -0.0[+4], -0.0[+6], -0.0, -0.0[+1], -0.0[+2], -0.0[+1], -0.0, -0.0[+1], -0.0[+5], -0.0[+3], -0.0[+2], -0.0[+1], -0.0[+1], -0.0, -0.0[+6], -0.0[+1], -0.0, -0.0[+2], -0.0[+2], -0.0, -0.0[+2], -0.0[+4], -0.0[+4], -0.0[+2], -0.0[+1], -0.0[+2], -0.0[+6], -0.0[+5], -0.0[+1], -0.0[+2], -0.0[+4], -0.0[+1], -0.0, -0.0[+1], -0.0[+4], -0.0[+1], -0.0[+3], -0.0[+5], -0.0[+3], -0.0[+1], -0.0[+1], -0.0[+2], -0.0[+3], -0.0[+1], -0.0, -0.0[+5], -0.0[+2], -0.0[+6], -0.0, -0.0[+1], -0.0[+3], -0.0, -0.0[+2], -0.0[+3], -0.0[+1], -0.0[+1], -0.0[+1], -0.0[+2], -0.0[+4], -0.0[+3], -0.0[+3], -0.0[+1], -0.0[+2], -0.0, -0.0[+3], -0.0[+1], -0.0[+3], -0.0[+3], -0.0[+2], -0.0[+2], -0.0[+4], -0.0[+3], -0.0, -0.0[+3], -0.0, -0.0, -0.0[+3], -0.0[+1], -0.0[+3], -0.0[+5], -0.0[+4], -0.0[+4], -0.0[+2], -0.0[+6], -0.0[+1], -0.0[+3], -0.0[+2], -0.0[+1], -0.0[+5], -0.0[+3], -0.0[+6], -0.0[+1], -0.0[+6], -0.0[+5], -0.0, -0.0[+2], -0.0, -0.0[+2], -0.0[+1], -0.0, -0.0[+1], -0.0[+4], -0.0[+3], -0.0[+1], -0.0[+1], -0.0[+1], -0.0[+4], -0.0, -0.0[+1], -0.0[+2], -0.0[+7], -0.0[+2], -0.0[+3], -0.0, -0.0[+2], -0.0[+3], -0.0[+6], -0.0, -0.0[+1], -0.0, -0.0[+2], -0.0, -0.0[+9], -0.0[+2], -0.0[+1], -0.0[+3], -0.0, -0.0[+1], -0.0[+3], -0.0[+3], -0.0[+4], -0.0, -0.0", -- [2]
"Пронзающий шип-321597-npc:22887 = pull:0.0, -0.0, -0.0, -0.0[+1], -0.0, -0.0[+3], -0.0[+1], -0.0[+1], -0.0[+2], -0.0[+1], -0.0[+3], -0.0[+1], -0.0, -0.0, -0.0[+3], -0.0[+2], -0.0[+1], -0.0[+1], -0.0[+3], -0.0, -0.0[+2], -0.0, -0.0[+2], -0.0, -0.0, -0.0[+2]", -- [3]
},
]]
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 321595 321598",
	"SPELL_CAST_SUCCESS 321599 321596"
)

-- local warnShield		= mod:NewSpellAnnounce(39872, 4)
-- local warnShieldSoon	= mod:NewSoonAnnounce(39872, 10, 3)
-- local warnSpine			= mod:NewTargetNoFilterAnnounce(39837, 3)

-- local specWarnSpineTank	= mod:NewSpecialWarningTaunt(39837, nil, nil, nil, 1, 2)
-- local yellSpine			= mod:NewYell(39837)

-- local timerShield		= mod:NewCDTimer(56, 39872, nil, nil, nil, 5)


local berserkTimer		= mod:NewBerserkTimer(480)

local kolossalnyi_udar = mod:NewCDTimer(9, 321598) --SPELL_CAST_START
local grohot_priliva = mod:NewCDTimer(25, 321595) --SPELL_CAST_START
local vodyanoe_proklyatie = mod:NewCDTimer(30, 321599) --SPELL_CAST_SUCCESS
local pronzayous_ship = mod:NewCDTimer(20, 321596) --SPELL_CAST_SUCCESS

-- mod:AddSetIconOption("SpineIcon", 39837)
mod:AddInfoFrameOption(39878, true)
mod:AddRangeFrameOption("8")

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	kolossalnyi_udar:Start(6)
	grohot_priliva:Start(15)
	vodyanoe_proklyatie:Start(30)
	pronzayous_ship:Start(15)

	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(kolossalnyi_udar.spellId) then
		kolossalnyi_udar:Start()
	elseif args:IsSpellID(grohot_priliva.spellId) then
		grohot_priliva:Start()
	end
end
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(vodyanoe_proklyatie.spellId) then
		vodyanoe_proklyatie:Start()
	elseif args:IsSpellID(pronzayous_ship.spellId) then
		pronzayous_ship:Start()
	end
end
