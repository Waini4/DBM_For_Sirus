local mod	= DBM:NewMod("Magtheridon", "DBM-Magtheridon")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17257)

mod:SetModelID(18527)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 305158 305159 305160 305134 30616 30510",
	"SPELL_CAST_SUCCESS 30572 305166",
	"SPELL_AURA_APPLIED 305131 305135",
	"UNIT_HEALTH",
	"SPELL_DAMAGE 305133",
	"CHAT_MSG_MONSTER_YELL"
)
-- общее --
mod:AddTimerLine(L.General)
local timerNovaCD                   = mod:NewCDTimer(80, 305129, nil, nil, nil, 3) -- Кубы
local timerPull				        = mod:NewTimer(112, "Pull", 305131, nil, nil, 6) -- Пулл босса

-- обычка --
mod:AddTimerLine(L.Normal)
local timerShakeCD                  = mod:NewCDTimer(55, 55101, nil, nil, nil, 3) -- Сотрясение

-- героик --
mod:AddTimerLine(L.Heroic)
local warningNovaCast               = mod:NewCastAnnounce(305129, 10) -- Вспышка скверны
local warnHandOfMagt			    = mod:NewSpellAnnounce(305131, 1) -- Печать магтеридона
local warnDevastatingStrike		    = mod:NewSpellAnnounce(305134, 3, nil, "Tank|Healer") -- сокрушительный удар

local specWarnNova                  = mod:NewSpecialWarningRun(305129, nil, nil, nil, 1, 2) -- Вспышка скверны
local specWarnHandOfMagt            = mod:NewSpecialWarningSpell(305131, nil, nil, nil, 1, 2) -- Печать магтеридона
local specWarnDevastatingStrike	    = mod:NewSpecialWarningYou(305134, "Tank", nil, nil, nil, 1, 2)	--Оповещение на экран о получении сокрушительного удара

local timerHandOfMagtCD             = mod:NewCDTimer(15, 305131, nil, nil, nil, 3)	-- печать магтеридона
local timerDevastatingStrikeCD		= mod:NewCDTimer(15, 305134, nil, "Tank|Healer", nil, 1)	-- сокрушительный удар
local timerShatteredArmor           = mod:NewTargetTimer(30, 305135, nil, "Tank|Healer", nil, 1)	-- дебаф сокрушнительного удара


local pullWarned = true
local warned_P2 = false
local warned_P3 = false
local cub = 1
local shake = 1

local handTargets = {}
local targetShattered

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17257, "Magtheridon")
	self:SetStage(2)
	if self:IsHeroic() then
		timerNovaCD:Start()
		timerHandOfMagtCD:Start()
		timerDevastatingStrikeCD:Start()
	elseif self:IsNormal() then
		timerNovaCD:Start(67)
	end
	cub = 2
	warned_P2 = false
	warned_P3 = false
	pullWarned = true
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17257, "Magtheridon", wipe)
	cub = 1
	shake = 1
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305158, 305159, 305160) then
		warningNovaCast:Show()
		specWarnNova:Show(args.sourceName)
		timerDevastatingStrikeCD:Start()
		timerNovaCD:Start()
	elseif args:IsSpellID(305134) then
		targetShattered = self:GetBossTarget(17257)
		warnDevastatingStrike:Show(targetShattered)
		specWarnDevastatingStrike:Show(targetShattered)
		timerDevastatingStrikeCD:Start()
	elseif args:IsSpellID(30616) then		-- таймер кубов на уровне костылей
		specWarnNova:Show(args.sourceName)
		if cub == 2 then
			timerNovaCD:Start(74)
			cub = cub + 1
		elseif cub == 3 then
			timerNovaCD:Start(67)
			cub = cub + 1
		elseif cub == 4 then
			timerNovaCD:Start(67)
			cub = cub + 1
		elseif cub == 5 then
			timerNovaCD:Start(74)
			cub = cub + 1
		elseif cub == 6 then
			timerNovaCD:Start(70)
			cub = cub + 1
		elseif cub == 7 then
			timerNovaCD:Start(74)
			cub = cub + 1
		elseif cub == 8 then	--этот сделан на угад остальные по стриму [https://www.twitch.tv/videos/1303324658?t]
			timerNovaCD:Start(74)
			cub = cub + 1
		end
	elseif args:IsSpellID(30510) then	--таймер пула
		if pullWarned then
			timerPull:Start()
			pullWarned = false
			self:SetStage(1)
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, _, destFlags, spellId)			-- слакер пишет в рейд что взорвал печать
	if spellId == 305133 and bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 then
		SendChatMessage(L.YellHandfail, "RAID")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(30572) then	-- Сотрясение оказывается разные таймера
		if shake == 1 then
			timerShakeCD:Start()
			shake = shake + 1
		elseif shake == 2 then
			timerShakeCD:Start(37)
			shake = shake + 1
		elseif shake == 3 then
			timerShakeCD:Start(23)
			shake = shake + 1
		elseif shake == 4 then
			timerShakeCD:Start(50)
			shake = shake + 1
		elseif shake == 5 then
			timerShakeCD:Start()
			shake = shake + 1
		elseif shake == 6 then
			timerShakeCD:Start()
			shake = shake + 1
		end
	elseif args:IsSpellID(305166) then
		handTargets[#handTargets + 1] = args.destName
		if #handTargets >= 3 then
			warnHandOfMagt:Show(table.concat(handTargets, ">, <"))
			table.wipe(handTargets)
		end
		timerHandOfMagtCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305131) and args:IsPlayer() then		-- возможно уберу в будущем пишет в чат если на тебе печать
		specWarnHandOfMagt:Show()
	elseif args:IsSpellID(305135) then
		timerShatteredArmor:Start(args.destName)
	end
end

function mod:UNIT_HEALTH(uId)
	if not warned_P2 and self:GetUnitCreatureId(uId) == 17257 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.53 and self:IsHeroic() then
		warned_P2 = true
		self:NewPrePhaseAnnounce(2)
	elseif not warned_P3 and self:GetUnitCreatureId(uId) == 17257 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.50 and self:IsHeroic() then
		warned_P3 = true
		self:NewPhaseAnnounce(2)
		self:SetStage(3)
	elseif not warned_P3 and self:GetUnitCreatureId(uId) == 17257 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.33 and self:IsNormal() then
		warned_P2 = true
		self:NewPrePhaseAnnounce(3)
	elseif not warned_P3 and self:GetUnitCreatureId(uId) == 17257 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.30 and self:IsNormal() then
		warned_P3 = true
		self:SetStage(3)
		self:NewPhaseAnnounce(3)
		timerShakeCD:Start(10)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)	-- идею взял с бс гер вайни --обновление таймера в случае потолка
	if msg == L.YellPhase2 then
		if timerNovaCD:GetRemaining() then
			local elapsed, total = timerNovaCD:GetTime()
			local extend = total-elapsed
			timerNovaCD:Stop()
			timerNovaCD:Update(0, 10+extend)
		end
	elseif msg == L.YellPhase1 then	-- попытка словить активацию магика
		if self:IsHeroic() then
			timerNovaCD:Start()
			timerHandOfMagtCD:Start(20)
			timerDevastatingStrikeCD:Start()
			self:SetStage(2)
		end
	end
end
