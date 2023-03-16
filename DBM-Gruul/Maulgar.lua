local mod 	= 	DBM:NewMod("Maulgar", "DBM-Gruul");
local L		= 	mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(18831)
mod:SetUsedIcons(8,7,6,5,4)

mod:RegisterCombat("combat", 18831)
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 305221",
	"SPELL_CAST_SUCCESS 16508",
	"SPELL_AURA_APPLIED 305216 305247 33238"
)

local isDispeller = select(2, UnitClass("player")) == "PRIEST" or select(2, UnitClass("player")) == "SHAMAN" or select(2, UnitClass("player")) == "MAGE"

mod:AddTimerLine(DBM_CORE_L.NORMAL_MODE)

local specWarnMelee                  = mod:NewSpecialWarningMove(33238, "Melee")

local timerWhirlCD                   = mod:NewCDTimer(55, 33238)
local timerWhirl                     = mod:NewTimer(15, "TimerWhirl", 33238)
local timerIntimidateCD              = mod:NewCDTimer(16, 16508)

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE)

local warnMight                      = mod:NewAnnounce("WarnMight", 2)

local specWarnShield                 = mod:NewSpecialWarningDispel(33054 or 305247, isDispeller)
local specWarnKickCleanse            = mod:NewSpecialWarning("KickNow", "-Melee")

local timerMight                     = mod:NewTargetTimer(60, 305216, "timerActive")
local timerMightCD                   = mod:NewCDTimer(65, 305216)

mod:AddBoolOption("WarnMight",true)
mod:AddBoolOption("AnnounceToChat",false)

function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 18831, "High King Maulgar")
	if mod:IsDifficulty("heroic25") then
		timerMight:Start(5)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 18831, "High King Maulgar", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(305221) then
		specWarnKickCleanse:Show(args.spellName)
--	elseif args:IsSpellID(305231) then

	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(16508) then
		timerIntimidateCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(305216) then
		local activeIcon
		for i = 1,40 do
			if UnitName("raid" .. i .. "target") == L.name then
				activeIcon = GetRaidTargetIndex("raid" .. i .. "targettarget")
			end
		end
		timerMightCD:Start()
		warnMight:Show(args.destName, activeIcon or "Interface\\Icons\\Inv_misc_questionmark")
		timerMight:Start(args.destName, activeIcon or "Interface\\Icons\\Inv_misc_questionmark")
		if self.Options.AnnounceToChat then
			SendChatMessage((activeIcon and ("{rt" .. activeIcon .. "} ") or "") .. args.destName .. " активен", "RAID")
		end
	elseif args:IsSpellID(305247) then
		specWarnShield:Show()
	elseif args:IsSpellID(33238) then
		timerWhirlCD:Start()
		timerWhirl:Start()
		specWarnMelee:Show()
	end
end
