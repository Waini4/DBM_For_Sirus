local mod = DBM:NewMod("Moroes", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()
local CL  = DBM_COMMON_L

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(15687, 19875, 19874, 19872, 17007, 19876, 19873) --Moroes
--19875, 19874, 19872, 17007, 19876, 19873--all the adds, for future use
--mod:RegisterCombat("yell", L.DBM_MOROES_YELL_START)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START 305464 305463 305472",
	"SPELL_AURA_APPLIED 305470 305478 305460",
	-- "SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS 305460"
-- "PLAYER_REGEN_DISABLED_AND_MESSAGE"
)


-- local warnPhase2Soon		    = mod:NewPrePhaseAnnounce(2)
local warnPhase2    = mod:NewPhaseAnnounce(2)
local warnDanceSoon = mod:NewSoonAnnounce(305472, 3)
local warnDeathMark = mod:NewTargetAnnounce(305470, 4)


local specWarnDance = mod:NewSpecialWarningSoak(305472, nil, nil, nil, 1, 2) -- танец
local specWarnMark  = mod:NewSpecialWarningRun(305470, nil, nil, nil, 1, 3) -- метка


local timerPierceCD    = mod:NewCDTimer(10, 305464, nil, nil, nil, 5, nil, CL.TANK_ICON)
local timerWoundCD     = mod:NewCDTimer(10, 305463, nil, nil, nil, 5, nil, CL.TANK_ICON)
local timerDeathMark   = mod:NewTargetTimer(7, 305470, nil, nil, nil, 5, nil, CL.HEALER_ICON) -- метка
local timerDeathMarkCD = mod:NewCDTimer(25, 305470, nil, nil, nil, 3, nil, CL.HEALER_ICON) -- метка
local timerPhase2      = mod:NewPhaseTimer(180)
local timerDanceCD     = mod:NewCDTimer(20, 305472, nil, nil, nil, 7) -- танец
local timerSpreeCD     = mod:NewCDTimer(85, 305461, nil, nil, 6) -- череда

local berserkTimer = mod:NewBerserkTimer(525)

mod:AddSetIconOption("MarkIcon", 305470, true, true, { 8 })

mod.vb.phase = 0
mod.vb.ora = true
mod.vb.phase2 = false

function mod:resetOra()
	mod.vb.ora = true
end

function mod:phase2warn()
	timerDeathMarkCD:Schedule(2)
	self:ScheduleMethod(2, "phase2")
end

function mod:phase2()
	warnPhase2:Show()
	self.vb.phase = 2
	timerSpreeCD:Start(79)
	timerDanceCD:Cancel()
end

-- local f = CreateFrame("Frame", nil, UIParent)
-- f:RegisterEvent("PLAYER_REGEN_DISABLED")
-- f:SetScript("OnEvent", function()
-- 	for i = 1, MAX_RAID_MEMBERS do
-- 	local pt = UnitName("raid"..i.."-target")
-- 		if pt and pt == "Мороуз" then
-- 				DBM:FireCustomEvent("DBM_EncounterStart", 15687, "Moroes")
-- 			if mod:IsDifficulty("heroic10") then
-- 		mod.vb.phase = 1
-- 		mod.vb.phase2 = false
-- 		timerDanceCD:Start()
-- 		timerPhase2:Start()
-- 		self:ScheduleMethod(178, "phase2warn")
-- 		warnDanceSoon:Show(17)
-- 		berserkTimer:Start()
-- 			end
-- 		end
-- 	end
-- end)


function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 15687, "Moroes")
	if self:IsDifficulty("heroic10") then
		self.vb.phase = 1
		self.vb.phase2 = false
		timerDanceCD:Start()
		timerPhase2:Start()
		self:ScheduleMethod(178, "phase2warn")
		warnDanceSoon:Show(17)
		berserkTimer:Start()
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 15687, "Moroes", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305464) and self.vb.phase2 then
		timerPierceCD:Start()
	elseif args:IsSpellID(305463) and self.vb.phase2 then
		timerWoundCD:Start()
	elseif args:IsSpellID(305472) then -- танец
		warnDanceSoon:Show(17)
		timerDanceCD:Start()
		specWarnDance:Show()
	end
end

--SPELL_CAST_SUCCESS,0xF130003D47000471,"Мороуз",0x110a48,0x0000000000000000,nil,0x80000000,305460,"Череда убийств",0x1

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(305460) then
		timerSpreeCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305470) then -- метка
		if args:IsPlayer() then
			specWarnMark:Show()
		end
		warnDeathMark:Show(args.destName)
		timerDeathMark:Start(args.destName)
		timerDeathMarkCD:Start()
		if self.Options.MarkIcon then
			self:SetIcon(args.destName, 8, 7)
		end
	elseif args:IsSpellID(305478) then
		if args:IsPlayer() then
			local name = { "djeban", "sexgay", "cigan", "hardbass", "upkicks" } --танец
			name       = name[math.random(#name)]
		end
	elseif args:IsSpellID(305460) then
		if self.vb.ora then
			local name  = { "ora", "muda", "atata" } --танец
			name        = name[math.random(#name)]
			self.vb.ora = false
			self:ScheduleMethod(5, "resetOra")
		end
	end
end

-- local warningVanishSoon		= mod:NewSoonAnnounce(29448, 2)
-- local warningVanish			= mod:NewSpellAnnounce(29448, 3)
-- local warningGarrote		= mod:NewTargetAnnounce(37066, 4)
-- local warningGouge			= mod:NewTargetAnnounce(29425, 4)
-- local warningBlind			= mod:NewTargetAnnounce(34694, 3)
-- local warningMortalStrike	= mod:NewTargetAnnounce(29572, 2)
-- local warningManaBurn		= mod:NewCastAnnounce(29405, 3, nil, false)
-- local warningGreaterHeal	= mod:NewCastAnnounce(35096, 3, nil, false)
-- local warningHolyLight		= mod:NewCastAnnounce(29562, 3, nil, false)
--
-- local timerVanishCD			= mod:NewCDTimer(31, 29448)
-- local timerGouge			= mod:NewTargetTimer(6, 29425)
-- local timerBlind			= mod:NewTargetTimer(10, 34694)
-- local timerMortalStrike		= mod:NewTargetTimer(5, 29572)
--
-- local lastVanish = 0
--
-- function mod:OnCombatStart(delay)
-- 	timerVanishCD:Start(-delay)
-- 	warningVanishSoon:Schedule(31-delay)
-- 	lastVanish = 0
-- end
--
-- function mod:SPELL_CAST_START(args)
-- 	if args:IsSpellID(29405) then
-- 		warningManaBurn:Show()
-- 	elseif args:IsSpellID(35096) then
-- 		warningGreaterHeal:Show()
-- 	elseif args:IsSpellID(29562) then
-- 		warningHolyLight:Show()
-- 	end
-- end
--
-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args:IsSpellID(29448) then
-- 		warningVanish:Show()
-- 		lastVanish = GetTime()
-- 	elseif args:IsSpellID(29425) then
-- 		warningGouge:Show(args.destName)
-- 		timerGouge:Show(args.destName)
-- 	elseif args:IsSpellID(34694) then
-- 		warningBlind:Show(args.destName)
-- 		timerBlind:Show(args.destName)
-- 	elseif args:IsSpellID(29572) then
-- 		warningMortalStrike:Show(args.destName)
-- 		timerMortalStrike:Show(args.destName)
-- 	elseif args:IsSpellID(37066) then
-- 		warningGarrote:Show(args.destName)
-- 		if (GetTime() - lastVanish) < 20 then--firing this event here instead, since he does garrote as soon as he comes out of vanish.
-- 			timerVanishCD:Start()
-- 			warningVanishSoon:Schedule(26)
-- 		end
-- 	end
-- end
--
-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(34694) then
-- 		timerBlind:Cancel(args.destName)
-- 	end
-- end
