local mod = DBM:NewMod("Netherspite", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(15689)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START 38523 305407",
	"SPELL_AURA_APPLIED 305402 305403 305404 305408 305409",
	"SPELL_CAST_SUCCESS 37014 37063",
	"SPELL_PERIODIC_DAMAGE 30533",
	"SPELL_DAMAGE 28865",
	"SPELL_SUMMON 37063",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warningPortalSoon = mod:NewAnnounce("DBM_NS_WARN_PORTAL_SOON", 2, "Interface\\Icons\\Spell_Arcane_PortalIronForge")
local warningBanishSoon = mod:NewAnnounce("DBM_NS_WARN_BANISH_SOON", 2, "Interface\\Icons\\Spell_Shadow_Cripple")
local warningPortal     = mod:NewAnnounce("warningPortal", 3, "Interface\\Icons\\Spell_Arcane_PortalIronForge")
local warningBanish     = mod:NewAnnounce("warningBanish", 3, "Interface\\Icons\\Spell_Shadow_Cripple")
local warningBreathCast = mod:NewCastAnnounce(38523, 2)
local warningVoid       = mod:NewSpellAnnounce(30533, 3)

local specWarnVoid 		= mod:NewSpecialWarningMove(30533, nil, nil, 2, 4, 2)

local timerPortalPhase 	= mod:NewTimer(60, "timerPortalPhase", "Interface\\Icons\\Spell_Arcane_PortalIronForge")
local timerBanishPhase 	= mod:NewTimer(30, "timerBanishPhase", "Interface\\Icons\\Spell_Shadow_Cripple")
local timerBreathCast  	= mod:NewCastTimer(2.5, 38523)

local timerGates       	= mod:NewTimer(13, "TimerGates", 305400)
local timerGhostPhase  	= mod:NewTimer(75, "TimerGhostPhase", 305408)
local timerRepentance  	= mod:NewTimer(30, "TimerRepentance", 305408)
local timerPortals     	= mod:NewTimer(15, "TimerPortals", 33404)
local timerNormalPhase 	= mod:NewTimer(60, "TimerNormalPhase", 23684)
local timerNextVoid		= mod:NewTimer(15, "TimerNextVoid", 37063)
local specWarnGates    	= mod:NewSpecialWarningYou(305403)
local warnGates        	= mod:NewTargetAnnounce(305403, 3)
local timerBreatheCD   	= mod:NewCDTimer(13, 305407)

-- local warnSound						= mod:NewSoundAnnounce()

local berserkTimer = mod:NewBerserkTimer(540)

local gatesTargets = {}
mod.vb.breatheCount = 0

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 15689, "Netherspite")
	if self:IsDifficulty("normal10") then
		timerNextVoid:Start()
		berserkTimer:Start()
		timerPortalPhase:Start(60-delay)
		warningBanishSoon:Schedule(55-delay)
	elseif self:IsDifficulty("heroic10") then
		timerGates:Start()
		timerGhostPhase:Start()
	end

end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 15689, "Netherspite", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(38523) then
		warningBreathCast:Show()
		timerBreathCast:Start()
	elseif args:IsSpellID(305407) then
		if self.vb.breatheCount < 4 then
			timerBreatheCD:Show()
			self.vb.breatheCount = self.vb.breatheCount + 1
		else
			self.vb.breatheCount = 0
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(37014, 37063) then
		warningVoid:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305402, 305403, 305404) then
		if args:IsPlayer() then
			specWarnGates:Show()
		end
		gatesTargets[#gatesTargets + 1] = args.destName
		if #gatesTargets >= 3 then
			warnGates:Show(table.concat(gatesTargets, "<, >"))
			table.wipe(gatesTargets)
		end
	elseif args:IsSpellID(305408, 305409) then
		-- warnSound:Play("run")
		timerRepentance:Start()
		timerPortals:Start()
		timerNormalPhase:Start()
		timerGates:Schedule(60)
		timerGhostPhase:Schedule(60)
	end
end

-- do
local lastVoid = 0
function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(30533) and args:IsPlayer() and GetTime() - lastVoid > 2 then
		specWarnVoid:Show()
		lastVoid = GetTime()
	end
end

-- end

local tick = 0
function mod:SPELL_SUMMON(args)
    if args:IsSpellID(37063) then
        timerNextVoid:Start()
        tick = tick + 1
        if tick >= 3 then
            timerNextVoid:Cancel()
            tick = 0
        end
    end
end

function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, spellId)
	if spellId == 28865 and destGUID == UnitGUID("player") and self:AntiSpam(3, 1) then		-- Увядание
		specWarnVoid:Show()
		specWarnVoid:Play("runaway")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.DBM_NS_EMOTE_PHASE_2 then
		timerPortalPhase:Cancel()
		warningBanish:Show()
		timerBanishPhase:Start()
		warningPortalSoon:Schedule(26)
	elseif msg == L.DBM_NS_EMOTE_PHASE_1 then
		timerNextVoid:Start()
		timerBanishPhase:Cancel()
		warningPortal:Show()
		timerPortalPhase:Start()
		warningBanishSoon:Schedule(56.5)
	end
end
