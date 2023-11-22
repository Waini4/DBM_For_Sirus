local mod	= DBM:NewMod("Supremus", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2023".."11".."22".."10".."00".."00") --fxpw check
mod:SetCreatureID(22898)

mod:SetModelID(21145)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

local berserkTimer		= mod:NewBerserkTimer(900)
--[[
["SPELL_CAST_START"] = {
	"Возгорание-322301-npc:22898 = pull:0.0, 0.0, -0.0, 0.0, -0.0, -0.0, 0.0, -0.0, 0.0", -- [1]
	"Потусторонняя метка-322292-npc:22898 = pull:0.0", -- [2]
	"Призрачный обстрел-322297-npc:22898 = pull:-0.0, 0.0, 0.0, 0.0, 0.0, -0.0, 0.0, 0.0, 0.0", -- [3]
	"Связующий удар-322294-npc:22898 = pull:-0.0, 0.0, -0.0, 0.0, -0.0", -- [4]
},
]]
-- start fight 21 32 s=20
local vozgoranie = mod:NewCDTimer(20, 322301) --SPELL_CAST_START (s)20 (1)36 (2)53
local prizrachnii_obstrel = mod:NewCDTimer(20, 322297) --SPELL_CAST_START (s)20 (1)34 (2)51
local potustoron_metka = mod:NewCDTimer(40, 322292) --SPELL_CAST_START (s)20 40
local svyaz_udar = mod:NewCDTimer(20, 322294) --SPELL_CAST_START (s)0:20 (1)0:45 (2)1:04

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 322301 322297 322292 322294"
)
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	vozgoranie:Start(16)
	prizrachnii_obstrel:Start(14)
	potustoron_metka:Start(20)

end

function mod:OnCombatEnd()
	berserkTimer:Stop()
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(vozgoranie.spellid) then
		vozgoranie:Start()
	elseif args:IsSpellID(prizrachnii_obstrel.spellid) then
		prizrachnii_obstrel:Start()
	elseif args:IsSpellID(potustoron_metka.spellid) then
		potustoron_metka:Start()
	elseif args:IsSpellID(svyaz_udar.spellid) then
		svyaz_udar:Start()
	end
end
-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(vodyanoe_proklyatie.spellid) then
-- 		vodyanoe_proklyatie:Start()
-- 	elseif args:IsSpellID(pronzayous_ship.spellid) then
-- 		pronzayous_ship:Start()
-- 	end
-- end