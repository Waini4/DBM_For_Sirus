-----------------------------------------------
-----------------------------------------------

local mod = DBM:NewMod("LurkerBelow", "DBM-Serpentshrine")
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(21217)
mod:RegisterCombat("combat", 21217)

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnSubmerge = mod:NewAnnounce("WarnSubmerge", 3)
local warnEmerge   = mod:NewAnnounce("WarnEmerge", 3)

local specWarnSpout = mod:NewSpecialWarningRun(37433)

local timerSubmerge = mod:NewTimer(60, "Submerge", "Interface\\AddOns\\DBM-Core\\Textures\\CryptFiendBurrow.blp")
local timerEmerge   = mod:NewTimer(64, "Emerge", "Interface\\AddOns\\DBM-Core\\Textures\\CryptFiendUnBurrow.blp")
local timerSpout    = mod:NewCastTimer(14, 37433)
local timerSpoutCD  = mod:NewCDTimer(36, 37433)

function mod:Submerge()
	warnSubmerge:Show()
	timerEmerge:Start()
	timerSpoutCD:Cancel()
	self:UnscheduleMethod("Emerge")
	self:ScheduleMethod(64, "Emerge")
end

function mod:Emerge()
	warnEmerge:Show()
	timerSubmerge:Start()
	timerSpoutCD:Start(45)
	self:UnscheduleMethod("Submerge")
	self:ScheduleMethod(115, "Submerge")
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 21217, "The Lurker Below")
	timerSubmerge:Start(60)
	self:ScheduleMethod(60, "Submerge")
	timerSpoutCD:Start(47)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteSpout then
		specWarnSpout:Show()
		timerSpout:Start()
		timerSpoutCD:Schedule(14)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 21217, "The Lurker Below", wipe)
	self:UnscheduleMethod("Emerge")
	self:UnscheduleMethod("Submerge")
end
