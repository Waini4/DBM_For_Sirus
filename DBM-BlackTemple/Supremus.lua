local mod	= DBM:NewMod("Supremus", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2023".."11".."22".."10".."00".."00") --fxpw check
mod:SetCreatureID(22898)

mod:SetModelID(21145)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

--[==[
"<-0.00 21:54:26> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [7]
"<0.00 21:54:27> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [8]
"<0.00 21:54:27> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [9]
"<0.00 21:54:27> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [10]
"<0.00 21:54:29> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [11]
"<0.00 21:54:29> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [12]
"<-0.00 21:54:32> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Потусторонняя метка - 5s [[target:Потусторонняя метка::0:]]", -- [13]
"<0.00 21:54:37> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Потусторонняя метка- [[target:Потусторонняя метка::0:]]", -- [14]
"<0.00 21:54:37> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Потусторонняя метка- [[target:Потусторонняя метка::0:]]", -- [15]
"<-0.00 21:54:37> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Связующий удар - 1s [[target:Связующий удар::0:]]", -- [16]
"<-0.00 21:54:38> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Связующий удар- [[target:Связующий удар::0:]]", -- [17]
"<-0.00 21:54:44> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [18]
"<-0.00 21:54:44> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [19]
"<0.00 21:54:44> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [20]
"<-0.01 21:54:46> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [21]
"<-0.01 21:54:46> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [22]
"<0.00 21:54:56> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Связующий удар - 1s [[target:Связующий удар::0:]]", -- [23]
"<0.00 21:54:57> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Связующий удар- [[target:Связующий удар::0:]]", -- [24]
"<0.00 21:54:57> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Связующий удар- [[target:Связующий удар::0:]]", -- [25]
"<0.00 21:55:00> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [26]
"<-0.00 21:55:01> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [27]
"<-0.00 21:55:01> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [28]
"<-0.00 21:55:01> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [29]
"<-0.00 21:55:03> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [30]
"<-0.00 21:55:03> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [31]
"<0.00 21:55:17> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [32]
"<-0.00 21:55:18> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [33]
"<-0.00 21:55:18> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [34]
"<0.00 21:55:18> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [35]
"<-0.00 21:55:20> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [36]
"<-0.00 21:55:20> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [37]
"<0.00 21:55:34> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [38]
"<0.00 21:55:35> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [39]
"<0.00 21:55:35> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [40]
"<-0.00 21:55:35> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [41]
"<0.00 21:55:37> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [42]
"<0.00 21:55:37> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [43]
"<-0.00 21:55:51> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [44]
"<0.01 21:55:52> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [45]
"<0.01 21:55:52> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [46]
"<-0.00 21:55:52> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [47]
"<-0.00 21:55:54> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [48]
"<-0.00 21:55:54> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [49]
"<-0.00 21:55:54> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Связующий удар - 1s [[target:Связующий удар::0:]]", -- [50]
"<-0.00 21:55:55> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Связующий удар- [[target:Связующий удар::0:]]", -- [51]
"<-0.00 21:56:08> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [52]
"<-0.00 21:56:09> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [53]
"<-0.00 21:56:09> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [54]
"<0.00 21:56:09> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [55]
"<-0.00 21:56:11> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [56]
"<-0.00 21:56:11> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Возгорание- [[target:Возгорание::0:]]", -- [57]
"<0.00 21:56:13> [UNIT_SPELLCAST_START] Супремус(Мишкавайп) - Связующий удар - 1s [[target:Связующий удар::0:]]", -- [58]
"<-0.00 21:56:14> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Мишкавайп) -Связующий удар- [[target:Связующий удар::0:]]", -- [59]
"<-0.00 21:56:14> [UNIT_SPELLCAST_STOP] Супремус(Мишкавайп) -Связующий удар- [[target:Связующий удар::0:]]", -- [60]
"<-0.00 21:56:15> [UNIT_TARGET] target#Супремус#Target: Capuzin#TargetOfTarget: ??", -- [61]
"<-0.00 21:56:26> [UNIT_SPELLCAST_START] Супремус(Capuzin) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [62]
"<0.00 21:56:27> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Capuzin) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [63]
"<0.01 21:56:27> [UNIT_SPELLCAST_STOP] Супремус(Capuzin) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [64]
"<-0.01 21:56:27> [UNIT_SPELLCAST_START] Супремус(Capuzin) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [65]
"<0.00 21:56:29> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Capuzin) -Возгорание- [[target:Возгорание::0:]]", -- [66]
"<0.00 21:56:29> [UNIT_SPELLCAST_STOP] Супремус(Capuzin) -Возгорание- [[target:Возгорание::0:]]", -- [67]
"<0.00 21:56:33> [UNIT_SPELLCAST_START] Супремус(Capuzin) - Связующий удар - 1s [[target:Связующий удар::0:]]", -- [68]
"<-0.00 21:56:34> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Capuzin) -Связующий удар- [[target:Связующий удар::0:]]", -- [69]
"<-0.00 21:56:34> [UNIT_SPELLCAST_STOP] Супремус(Capuzin) -Связующий удар- [[target:Связующий удар::0:]]", -- [70]
"<0.00 21:56:35> [UNIT_TARGET] target#Супремус#Target: Разъёба#TargetOfTarget: Супремус", -- [71]
"<-0.00 21:56:44> [UNIT_SPELLCAST_START] Супремус(Разъёба) - Призрачный обстрел - 1s [[target:Призрачный обстрел::0:]]", -- [72]
"<-0.01 21:56:45> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Разъёба) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [73]
"<-0.01 21:56:45> [UNIT_SPELLCAST_STOP] Супремус(Разъёба) -Призрачный обстрел- [[target:Призрачный обстрел::0:]]", -- [74]
"<-0.00 21:56:45> [UNIT_SPELLCAST_START] Супремус(Разъёба) - Возгорание - 1.5s [[target:Возгорание::0:]]", -- [75]
"<-0.00 21:56:47> [UNIT_SPELLCAST_SUCCEEDED] Супремус(Разъёба) -Возгорание- [[target:Возгорание::0:]]", -- [76]
"<-0.00 21:56:47> [UNIT_SPELLCAST_STOP] Супремус(Разъёба) -Возгорание- [[target:Возгорание::0:]]", -- [77]


]==]

local berserkTimer		= mod:NewBerserkTimer(900)
--[[
Призрачный обстрел
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

