
--------------------------------------
--------------------------------------
local mod	= DBM:NewMod("Fathomlord", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(21214)
mod:RegisterCombat("combat", L.YellPull)
mod:SetUsedIcons(4, 5, 6, 7, 8)

mod:RegisterEvents(
	"SPELL_CAST_START 38445 38330 29436",
	"SPELL_CAST_SUCCESS 38236 38373 38306 38304 38358 38441",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_DAMAGE 38358",
	"CHAT_MSG_MONSTER_EMOTE"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 309253 309289 309256",
	"SPELL_CAST_SUCCESS 309262 309258",
	"SPELL_AURA_APPLIED 309292 309262",
	"SPELL_AURA_REMOVED 309252 309292 309262",
	"UNIT_DIED"
)

mod:AddTimerLine(DBM_CORE_L.NORMAL_MODE25)
local warnNovaSoon       	= mod:NewSoonAnnounce(38445, 3)   -- Огненная звезда
local warnBeastInside		= mod:NewCastAnnounce(38373, 3) -- Зверь
local warnHealf				= mod:NewCastAnnounce(38330, 4)
local warnLeech				= mod:NewCastAnnounce(29436, 4)
local warnTide				= mod:NewCastAnnounce(38358, 4)
local warnLightning			= mod:NewCastAnnounce(38441, 4)


local specWarnNova       	= mod:NewSpecialWarningSpell(38445)  -- Огненная звезда
local specWarnFire      	= mod:NewSpecialWarningSpell(38236)
local specWarnKick			= mod:NewSpecialWarningInterrupt(38330, "HasInterrupt", nil, nil, 1, 2)

local timerHealCD 			= mod:NewCDTimer(16, 38330, nil, nil, nil, 4)
local timerNovaCD        	= mod:NewCDTimer(26, 38445, nil, nil, nil, 2)
local timerSpitfireCD   	= mod:NewCDTimer(30, 38236, nil, nil, nil, 2)
local timerTideCD   		= mod:NewCDTimer(15, 38358, nil, nil, nil, 2)
local timerLeechCD   		= mod:NewCDTimer(15, 29436, nil, nil, nil, 2)
local timerDispelCD    		= mod:NewCDTimer(15, 38306, nil, nil, nil, 2)
local timerBeastinsideCD    = mod:NewCDTimer(30, 38373, nil, nil, nil, 3)
local timerLightning    	= mod:NewCDTimer(10, 38441, nil, nil, nil, 3)

local berserkTimer          = mod:NewBerserkTimer(600)

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE25)
------------------------ХМ-------------------------

-- local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2)
local warnPhase2    		= mod:NewPhaseAnnounce(2)
local warnZeml          	= mod:NewSpellAnnounce(309289, 4)
-- local warnPhaseCast	        = mod:NewSpellAnnounce(309292, 4)
local warnOko	            = mod:NewSpellAnnounce(309258, 2, nil, "Melee")
local warnStrela            = mod:NewTargetAnnounce(309253, 3) -- Стрела катаклизма
local specWarnStrela	    = mod:NewSpecialWarningYou(309253, nil, nil, nil, 3, 2)
local specWarnHeal			= mod:NewSpecialWarningInterrupt(309256, "HasInterrupt", nil, 2, 1, 2)
local specWarnZeml			= mod:NewSpecialWarningMoveAway(309289, nil, nil, nil, 3, 5)

local timerPhaseCast        = mod:NewCastTimer(60, 309292, nil, nil, nil, 6) -- Скользящий натиск
local timerStrelaCast		= mod:NewCastTimer(6, 309253, nil, nil, nil, 3) -- Стрела катаклизма
local timerStrelaCD			= mod:NewCDTimer(43, 309253, nil, nil, nil, 3) -- Стрела катаклизма
local timerSvazCd			= mod:NewCDTimer(25, 309262, nil, nil, nil, 3)
local timerOkoCD	        = mod:NewCDTimer(16, 309258, nil, "Melee", nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerPhaseCastCD	    = mod:NewCDTimer(90, 309289, nil, nil, nil, 6)
local timerZemlyaCast		= mod:NewCastTimer(5, 309289, nil, nil, nil, 2)
local timerCastHeal	    	= mod:NewCDTimer(29, 309256, nil, "HasInterrupt", nil, 4)
local bers					= mod:NewBerserkTimer(360)
local yellStrela			= mod:NewYell(309253)
-----------Шарккис-----------
local warnSvaz              = mod:NewTargetAnnounce(309262, 3) -- Пламенная связь
-- local warnPust		        = mod:NewStackAnnounce(309277, 5, nil, "Tank") -- Опустошающее пламя

local specWarnSvaz          = mod:NewSpecialWarningMoveAway(309262, nil, nil, nil, 1, 3) -- Пламенная свзяь

mod:AddBoolOption("HealthFrameBoss", true)
mod:AddSetIconOption("SetIconOnSvazTargets", 309261, true, true, {5, 6, 7})
mod:AddSetIconOption("SetIconOnStrela", 309253, true, false, {8})
mod:AddBoolOption("AnnounceSvaz", false)

local SvazTargets = {}
local SvazIcons = 7
local Sumkill = 0

do
	-- local function sort_by_group(v1, v2)
	-- 	return DBM:GetRaidSubgroup(UnitName(v1)) < DBM:GetRaidSubgroup(UnitName(v2))
	-- end
	function mod:SetSvazIcons()
		table.sort(SvazTargets, function(v1,v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
		for _, v in ipairs(SvazTargets) do
			if mod.Options.AnnounceSvaz then
				if DBM:GetRaidRank() > 0 then
					SendChatMessage(L.SvazIcon:format(SvazIcons, UnitName(v)), "RAID_WARNING")
				else
					SendChatMessage(L.SvazIcon:format(SvazIcons, UnitName(v)), "RAID")
				end
			end
			if self.Options.SetIconOnSvazTargets then
				self:SetIcon(UnitName(v), SvazIcons, 10)
			end
			SvazIcons = SvazIcons - 1
		end
		if #SvazTargets >= 3 then
			warnSvaz:Show(table.concat(SvazTargets, "<, >"))
			table.wipe(SvazTargets)
			SvazIcons = 7
		end
	end
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 21214, "Fathom-Lord Karathress")
	mod:SetStage(1)
	if self.Options.HealthFrameBoss and not self.Options.HealthFrame then
		DBM.BossHealth:Show(L.name)
	end
	if self.Options.HealthFrameBoss then
		DBM.BossHealth:AddBoss(21966, L.Shark)
		DBM.BossHealth:AddBoss(21965, L.Volni)
		DBM.BossHealth:AddBoss(21964, L.Karib)
		DBM.BossHealth:AddBoss(21214, L.Karat)
	end
	if mod:IsDifficulty("heroic25") then
		berserkTimer:Start()
		timerOkoCD:Start()
		timerSvazCd:Start()
		timerCastHeal:Start()
		timerStrelaCD:Start()
	else -- Обычка
		timerBeastinsideCD:Start(6.6)
		berserkTimer:Start()
		timerNovaCD:Start()
		timerSpitfireCD:Start(21.8)
		timerDispelCD:Start(6.7)
		warnNovaSoon:Show(23)
		Sumkill = 0
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 21214, "Fathom-Lord Karathress", wipe)
	DBM.BossHealth:Clear()
	DBM.RangeCheck:Hide()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 38445 then -- Обычка
		warnNovaSoon:Show(23)
		specWarnNova:Show()
		timerNovaCD:Start()
	elseif spellId == 309253 then -- Стрела катаклизма
		self:ScheduleMethod(1.5, "strelafunc")
		timerStrelaCD:Start()
		timerStrelaCast:Start()
	elseif spellId == 309256 then -- Хил
		specWarnHeal:Show()
		-- specWarnHeal:Play("kickcast")
		timerCastHeal:Start()
	elseif spellId == 309289 then -- Землетрясение
		warnZeml:Show()
		timerZemlyaCast:Start()
		specWarnZeml:Show()
	elseif spellId == 38330 then
		warnHealf:Show()
		timerHealCD:Start()
		specWarnKick:Show(args.sourceName)
	elseif spellId == 29436 then
		warnLeech:Show()
		timerLeechCD:Start()
	end
end

function mod:strelafunc()
	local targetname = self:GetBossTarget(21214)
		if not targetname then return end
		if self.Options.SetIconOnStrela then
			self:SetIcon(targetname, 8, 6)
		end
		warnStrela:Show(targetname)
		if targetname == UnitName("player") then
			specWarnStrela:Show()
			yellStrela:Yell()
		end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 38236 then -- Обычка
		specWarnFire:Show()
		timerSpitfireCD:Start()
	elseif spellId == timerDispelCD.spellId then -- противоядие
		timerDispelCD:Start()
	elseif spellId == 309258 then -- Око
		warnOko:Show()
		timerOkoCD:Start()
	elseif spellId == 309262 then -- Связь
		timerSvazCd:Start()
	elseif spellId == 38373 then
		warnBeastInside:Show(args.destName)
		timerBeastinsideCD:Start()
	elseif spellId == 38358 then
		warnTide:Show()
		timerTideCD:Start()
	elseif spellId == 38441 and self:GetStage() == 2 then
		warnLightning:Show()
		timerLightning:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 309292 then
	timerPhaseCast:Start()
	elseif spellId == 309262 then -- Пламенная связь
		SvazTargets[#SvazTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnSvaz:Show()
		end
		self:ScheduleMethod(0.1, "SetSvazIcons")
	elseif spellId == 38373 and args:GetDestCreatureID() == 21214 then
		warnBeastInside:Show(args.destName)
		timerBeastinsideCD:Start(48)
	end
end

function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, spellId)
	if spellId == 38358 and Sumkill == 3 and self:AntiSpam(4, 5) then--Flame Crash
		warnTide:Show()
		timerTideCD:Start(22)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 309252 then --барьер
	    self:SetStage(2)
	    warnPhase2:Show()
		timerPhaseCastCD:Start(95)
		timerCastHeal:Cancel()
		timerOkoCD:Cancel()
		bers:Cancel()
		bers:Start()
	elseif spellId == 309292 then
		timerPhaseCastCD:Start()
	elseif spellId == 309262 and args:IsPlayer() then --Связь
		if self.Options.SetIconOnSvazTargets then
			self:RemoveIcon(args.destName)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 21966 or cid == 21965 or cid == 21964 then
		if mod:IsDifficulty("normal25") then
			Sumkill = Sumkill+1
			if Sumkill == 3 then
				self:SetStage(2)
			end
		end
		if self.Options.HealthFrameBoss then
			DBM.BossHealth:RemoveBoss(cid)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED