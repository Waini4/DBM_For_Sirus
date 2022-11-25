local mod = DBM:NewMod("Attumen", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(15550, 34972, 34972, 100507)
mod:RegisterCombat("combat")
mod:RegisterKill("kill")

--[[mod:RegisterEvents(
	"PLAYER_REGEN_DISABLED"
)]]
mod:RegisterEvents(
	"SPELL_AURA_APPLIED 43127 29833 305265 305253 305253",
	"SPELL_AURA_REMOVED 305265",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_START 305258 305263 305251 305259",
	"UNIT_HEALTH",
	-- "UNIT_DIED",
	"PLAYER_REGEN_DISABLED",
	"SPELL_CAST_SUCCESS 305253"
)

------------------ОБ------------------

local warnPhase2     = mod:NewPhaseAnnounce(2)
local warnPhase3     = mod:NewPhaseAnnounce(3)
local warnPhase2Soon = mod:NewPrePhaseAnnounce(2)

local warningCurseSoon = mod:NewSoonAnnounce(43127, 2)
local warningCurse     = mod:NewSpellAnnounce(43127, 3)

local timerCurseCD = mod:NewNextTimer(31, 43127, nil, nil, nil, 3)

------------------ХМ------------------

local specWarnMezair 	= mod:NewSpecialWarningDodge(305258, nil, nil, nil, 2, 2)
local warningTramp		= mod:NewCastAnnounce(305264, 3)

local timerInvCD       = mod:NewCDTimer(21, 305251, nil, nil, nil, 3) -- Незримое присутствие
local timerChargeCD    = mod:NewCDTimer(11, 305258, nil, nil, nil, 2) -- Галоп фаза 2
local timerCharge2CD   = mod:NewCDTimer(15, 305263, nil, nil, nil, 2) -- Галоп фаза 3
local timerChargeCast  = mod:NewCastTimer(3, 305258, nil, nil, nil, 2) -- Галоп каст
local timerSufferingCD = mod:NewCDTimer(21, 305259, nil, nil, nil, 3) -- Разделенные муки
local timerTrampCD     = mod:NewCDTimer(15, 305264, nil, nil, nil, 3) -- Могучий топот

local TrampTimers = {
	[2] = 17,
	[3] = 16,
	[4] = 15,
	[5] = 14,
	[6] = 13,
	[7] = 13,
	[8] = 13
}

-- local warnSound						= mod:NewSoundAnnounce()

mod:AddSetIconOption("InvIcons", 305253, true, true, { 8 })

mod.vb.phase = 0
mod.vb.lastCurse = 0
mod.vb.phaseCounter = true
local cast = 1

function mod:PLAYER_REGEN_DISABLED()
	if not mod.inCombat then
		mod:OnCombatStart()
	end
end

-- local f = CreateFrame("Frame", nil, UIParent)
-- f:RegisterEvent("PLAYER_REGEN_DISABLED")
-- f:SetScript("OnEvent", function()
-- 	for i = 1, MAX_RAID_MEMBERS do
-- 		local pt = UnitName("raid"..i.."-target")
-- 			if pt and pt == "Ловчий Аттумен" then
-- 					DBM:FireCustomEvent("DBM_EncounterStart", 100507, "Attumen the Huntsman")
-- 					mod.vb.phase = 1
-- 					mod.vb.phaseCounter = true
-- 				if mod:IsDifficulty("heroic10") then
-- 					timerInvCD:Start(20)
-- 				end
-- 			end
-- 		end
-- end)

function mod:OnCombatStart(delay)
	-- DBM:FireCustomEvent("DBM_EncounterStart", 100507, "Attumen the Huntsman")
	-- self.vb.phase = 1
	-- self.vb.cena = true
	-- self.vb.phaseCounter = true
	-- if mod:IsDifficulty("heroic10") then
	-- 	-- print(47)
	-- 	timerInvCD:Start(20)
	-- end
	for i = 1, 10 do
		if UnitExists("raid" .. i) then
			local pt = UnitName("raid" .. i .. "-target")
			if pt and pt == "Ловчий Аттумен" then
				DBM:FireCustomEvent("DBM_EncounterStart", 100507, "Attumen the Huntsman")
				self:SetStage(1)
				mod.vb.phaseCounter = true
				if self:IsDifficulty("heroic10") then
					timerInvCD:Start(20)
					cast = 2
				end
			end
		end
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 100507, "Attumen the Huntsman", wipe)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43127, 29833) and GetTime() - self.vb.lastCurse > 5 then -- Обычка
		warningCurse:Show()
		timerCurseCD:Show()
		warningCurseSoon:Cancel()
		if self.vb.phase == 2 then
			timerCurseCD:Start(41)
			warningCurseSoon:Schedule(36)
		else
			timerCurseCD:Start()
			warningCurseSoon:Schedule(26)
		end
		mod.vb.lastCurse = GetTime()
	elseif args:IsSpellID(305265) then -- что-то типо 2 фазы
		timerChargeCD:Start()
		timerSufferingCD:Start()
		timerInvCD:Cancel()
		warnPhase2:Show()
	-- elseif args:IsSpellID(305253) then -- попытка при получении скрытого дебафа игроком оповещение на экран кто полутал дебаф
	-- 	WarInv:Show(args.destName)
	-- 	if self.Options.SetIconOnTouchTarget then
	-- 		self:SetIcon(args.destName, 8, 5)
	-- 	end
	-- elseif args:IsSpellID(305253) and args:IsPlayer() then -- попытка при получении скрытого дебафа крикнуть что он на тебе updt. пидоры на сирусчае
	-- 	SendChatMessage(L.YellInv, "SAY")
	end
end

function mod:SPELL_AURA_REMOVED(args) -- Присутствие Аттумена, баф пропал - 3 фаза пошла
	if args:IsSpellID(305265) then
		timerCharge2CD:Start()
		timerTrampCD:Start(20)
		warnPhase3:Show()
	end
end

-- function mod:SPELL_CAST_SUCCESS(args) -- попытка №6
-- 	if args:IsSpellID(305253) then -- попытка при получении скрытого дебафа игроком оповещение на экран кто полутал дебаф
-- 		WarInv:Show(args.destName)
-- 		if self.Options.SetIconOnTouchTarget then
-- 			self:SetIcon(args.destName, 8, 5)
-- 		end
-- 	end
-- end -- есть предположение что дебаф призрака накладывается на последнего члена рейда(исключение петы) нужно больше логов.

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305258) then	-- галоп
		timerChargeCD:Start()
		timerChargeCast:Start()
		specWarnMezair:Show()
	elseif args:IsSpellID(305263) then	-- галоп2
		timerCharge2CD:Start()
		timerChargeCast:Start()
		specWarnMezair:Show()
	elseif args:IsSpellID(305264) then	-- могучий топот тестовый, имхо видно всё.
		warningTramp:Show()
		if cast >= 2 then
			timerTrampCD:Start(TrampTimers[cast])
			cast = cast + 1
		end
	elseif args:IsSpellID(305251) then	-- незримое присутствие
		timerInvCD:Start()
	elseif args:IsSpellID(305259) then	-- муки
		timerSufferingCD:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_ATH_YELL_1 then -- 2 фаза
		self.vb.phase = 2
		warnPhase2:Show()
		warningCurseSoon:Cancel()
		timerCurseCD:Start(25)
	end
end

function mod:UNIT_HEALTH(uId)
	if (self:GetUnitCreatureId(uId) == 15550 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.52 and self.vb.phaseCounter) then -- фаза
		self.vb.phaseCounter = false
		warnPhase2Soon:Show()
	end
end
