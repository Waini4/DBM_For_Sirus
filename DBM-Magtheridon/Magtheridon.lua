local mod = DBM:NewMod("Magtheridon", "DBM-Magtheridon")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(17257)

mod:SetModelID(17257)
mod:RegisterCombat("yell", L.YellPhase1)
mod:RegisterCombat("combat", 17257)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE",
	"SPELL_CAST_START 30510"
)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 305158 305159 305160 305134 30616 30510",
	"SPELL_CAST_SUCCESS 30572 305166 30510",
	"UNIT_SPELLCAST_SUCCEEDED",
	"SPELL_AURA_APPLIED 305131 305135 44032",
	"UNIT_HEALTH",
	"SPELL_DAMAGE"
)

local MyRealm = select(4, DBM:GetMyPlayerInfo())
mod:AddInfoFrameOption(44032, true)

mod:AddTimerLine(DBM_CORE_L.NORMAL_MODE)

local timerNovaNormalCD         = mod:NewCDTimer(60, 30616, nil, nil, nil, 3) -- таймер вспышка огненной звезды из обычки
local timerQuakeCD				= mod:NewCDTimer(50, 30572, nil, nil, nil, 3) -- таймер сотрясения в нормале
local timerDebris				= mod:NewCastTimer(16, 36449) -- Потолок

local warnNovaNormal			= mod:NewSoonAnnounce(30616, 4) -- Вспышка огненной звезды (скилл из обычки)
local warnQuake					= mod:NewSpellAnnounce(30572, 3) -- сотрясение в нормале (откидывание)
local warnDebris				= mod:NewSpellAnnounce(36449, 3) -- Потолок

local specWarnNovaNormal 		= mod:NewSpecialWarningSpell(30616, nil, nil, nil, 1, 2)

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE)

local timerNovaHeroicCD 		= mod:NewCDTimer(80, 305129, nil, nil, nil, 3) -- таймер вспышки скверны из героика
local timerHandOfMagtCD			= mod:NewCDTimer(15, 305131, nil, nil, nil, 3) -- печать магтеридона
local timerDevastatingStrikeCD	= mod:NewCDTimer(15, 305134, nil, "Tank|Healer", nil, 1) -- сокрушительный удар
local timerShatteredArmor		= mod:NewTargetTimer(30, 305135, nil, "Tank|Healer", nil, 1) -- дебаф сокрушнительного удара

local warnNovaHeroic       		= mod:NewSoonAnnounce(305129, 10) -- Вспышка скверны
local warnHandOfMagt        	= mod:NewSpellAnnounce(305131, 1) -- Печать магтеридона
local warnDevastatingStrike 	= mod:NewSpellAnnounce(305134, 3, nil, "Tank|Healer") -- сокрушительный удар

local specWarnNovaHeroic        = mod:NewSpecialWarningSpell(305129, nil, nil, nil, 1, 2) -- Вспышка скверны (скилл из героика)
local specWarnHandOfMagt        = mod:NewSpecialWarningSpell(305131, nil, nil, nil, 1, 2) -- Печать магтеридона
local specWarnDevastatingStrike = mod:NewSpecialWarningYou(305134, "Tank", nil, nil, nil, 1, 2) --Оповещение на экран о получении сокрушительного удара

local berserkTimer				= mod:NewBerserkTimer(600)
local timerPull   				= mod:NewTimer(9, "Pull", 305131, nil, nil, 6) -- Пулл босса

local warnPhase3Soon			= mod:NewPrePhaseAnnounce(3)
local warnPhase3				= mod:NewPhaseAnnounce(3)

mod.vb.warned_preP2 = false
mod.vb.warned_preP3 = false

local MgDebuff = DBM:GetSpellInfoNew(44032)
--
local handTargets = {}
local targetShattered

local lastQuake = 0
local elapsed, total
local fakeQuake = false
--
function mod:Nova()
	timerNovaNormalCD:Start()
	warnNovaNormal:Schedule(55)
	self:UnscheduleMethod("Nova")
	self:ScheduleMethod(60, "Nova")
end

function mod:ExtendNova(extendBy)
	elapsed, total = timerNovaNormalCD:GetTime()
	timerNovaNormalCD:Update(elapsed, total + extendBy)
	self:UnscheduleMethod("Nova")
	self:ScheduleMethod(total - elapsed + extendBy, "Nova")
	if total - elapsed > 5 then
		warnNovaNormal:Cancel()
		warnNovaNormal:Schedule(total - elapsed + extendBy - 5)
	end
end

function mod:Quake(timer)
	timerQuakeCD:Start(timer)
	self:UnscheduleMethod("Quake")
	self:ScheduleMethod(timer or 50, "Quake")
	if GetTime() - lastQuake > 10  then
		self:ExtendNova(7)
		lastQuake = GetTime()
	end
end

function mod:QuakeFakeDetection()
	if fakeQuake then
		fakeQuake = false
	else
		warnQuake:Show()
		self:Quake()
	end
end

function mod:ExtendQuake(extendBy)
	elapsed, total = timerQuakeCD:GetTime()
	timerQuakeCD:Update(elapsed, total + extendBy)
	self:UnscheduleMethod("Quake")
	self:ScheduleMethod(total - elapsed + extendBy, "Quake")
end

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 17257, "Magtheridon")
	self:SetStage(1)
	if self:IsHeroic() then
		timerNovaHeroicCD:Start()
        timerHandOfMagtCD:Start()
        timerDevastatingStrikeCD:Start()
	elseif self:IsNormal() then
		fakeQuake = false
		self:Quake(30)
		self:Nova()
		berserkTimer:Start()
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if MyRealm == 2 and msg == L.YellPullShort or msg:find(L.YellPullShort) then
		timerPull:Start()
	end
	 if msg == L.YellPullAcolytes or msg:find(L.YellPullAcolytes) and MyRealm ~= 2 then
		timerPull:Start(120)
	 end

end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305158, 305159, 305160) then
		warnNovaHeroic:Show()
		timerNovaHeroicCD:Start()
        specWarnNovaHeroic:Show(args.sourceName)
        timerDevastatingStrikeCD:Start()
    elseif args:IsSpellID(305134) then
        targetShattered = self:GetBossTarget(17257)
        warnDevastatingStrike:Show(targetShattered)
		specWarnDevastatingStrike:Show(targetShattered)
		timerDevastatingStrikeCD:Start()
    elseif args:IsSpellID(30616) then
        specWarnNovaNormal:Show(args.sourceName)
        self:Nova()
    end
end

function mod:SPELL_DAMAGE(_, _, _, _, _, destFlags, spellId) -- слакер пишет в рейд что взорвал печать
	if spellId == 305133 and bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 then
		SendChatMessage(L.YellHandfail, "RAID")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(305166) then
		handTargets[#handTargets + 1] = args.destName
		if #handTargets >= 3 then
			warnHandOfMagt:Show(table.concat(handTargets, ">, <"))
			table.wipe(handTargets)
		end
		timerHandOfMagtCD:Start()
	elseif args:IsSpellID(30572) then
		fakeQuake = true
    end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305131) and args:IsPlayer() then
		specWarnHandOfMagt:Show()
	elseif args:IsSpellID(305135) then
		timerShatteredArmor:Start(args.destName)
	elseif args:IsSpellID(44032) then
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(MgDebuff)
			DBM.InfoFrame:Show(16, "playerdebuffremaining", MgDebuff, 5)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, ...)
	if UnitName(unit) == L.name and spellName == L.Quake then
		self:ScheduleMethod(0.1, "QuakeFakeDetection")
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 17257 then
		if self:IsHeroic() then
			if not self.vb.warned_preP2  and DBM:GetBossHP(17257) <= 53 then
				self.vb.warned_preP2 = true
				warnPhase3Soon:Show()
			elseif not self.vb.warned_preP3 and DBM:GetBossHP(17257) <= 50 then
				self.vb.warned_preP3 = true
				warnPhase3:Show()
				self:SetStage(3)
			end
		elseif self:IsNormal() then
			 if  not self.vb.warned_preP2 and DBM:GetBossHP(17257) <= 33 then
				self.vb.warned_preP2 = true
				warnPhase3Soon:Show()
			elseif not self.vb.warned_preP3 and DBM:GetBossHP(17257) <= 30 then
				self.vb.warned_preP3 = true
				self:SetStage(3)
				warnPhase3:Show()
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 then
        if self:IsNormal() then
			warnDebris:Show()
			timerDebris:Start()
			self:ExtendNova(13)
			self:ExtendQuake(13)
		elseif self:IsHeroic() then
			timerNovaHeroicCD:Cancel()
		end
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 17257, "Magtheridon", wipe)
	self:UnscheduleMethod("Quake")
	self:UnscheduleMethod("Nova")
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end