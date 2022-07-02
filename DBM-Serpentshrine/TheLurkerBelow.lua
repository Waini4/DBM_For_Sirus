-- local mod	= DBM:NewMod("LurkerBelow", "DBM-Serpentshrine")
-- local L		= mod:GetLocalizedStrings()

-- mod:SetRevision("20220518110528")
-- mod:SetCreatureID(21217)

-- mod:SetModelID(20216)

-- mod:RegisterCombat("combat")

-- mod:RegisterEventsInCombat(
-- 	"RAID_BOSS_EMOTE",
-- 	"UNIT_DIED",
-- 	"UNIT_SPELLCAST_SUCCEEDED"
-- )

-- local warnSubmerge		= mod:NewAnnounce("WarnSubmerge", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
-- local warnEmerge		= mod:NewAnnounce("WarnEmerge", 1, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
-- local warnWhirl			= mod:NewSpellAnnounce(37363, 2)

-- local specWarnSpout		= mod:NewSpecialWarningSpell(37433, nil, nil, nil, 2, 2)

-- local timerSubmerge		= mod:NewTimer(105, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp", nil, nil, 6)
-- local timerEmerge		= mod:NewTimer(60, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp", nil, nil, 6)
-- local timerSpoutCD		= mod:NewCDTimer(50, 37433, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
-- local timerSpout		= mod:NewBuffActiveTimer(22, 37433, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
-- local timerWhirlCD		= mod:NewCDTimer(18, 37363, nil, nil, nil, 2)

-- mod.vb.submerged = false
-- mod.vb.guardianKill = 0
-- mod.vb.ambusherKill = 0

-- local function emerged(self)
-- 	self.vb.submerged = false
-- 	timerEmerge:Cancel()
-- 	warnEmerge:Show()
-- 	timerSubmerge:Start()
-- end

-- function mod:OnCombatStart(delay)
-- 	self.vb.submerged = false
-- 	timerWhirlCD:Start(15-delay)
-- 	timerSpoutCD:Start(37-delay)
-- 	timerSubmerge:Start(90-delay)
-- end

-- function mod:RAID_BOSS_EMOTE(_, source)
-- 	if (source or "") == L.name then
-- 		specWarnSpout:Show()
-- 		specWarnSpout:Play("watchwave")
-- 		timerSpout:Start()
-- 		timerSpoutCD:Start()
-- 	end
-- end

-- function mod:UNIT_DIED(args)
-- 	local cId = self:GetCIDFromGUID(args.destGUID)
-- 	if cId == 21865 then
-- 		self.vb.ambusherKill = self.vb.ambusherKill + 1
-- 		if self.vb.ambusherKill == 6 and self.vb.guardianKill == 3 and self.vb.submerged then
-- 			self:Unschedule(emerged)
-- 			self:Schedule(2, emerged, self)
-- 		end
-- 	elseif cId == 21873 then
-- 		self.vb.guardianKill = self.vb.guardianKill + 1
-- 		if self.vb.ambusherKill == 6 and self.vb.guardianKill == 3 and self.vb.submerged then
-- 			self:Unschedule(emerged)
-- 			self:Schedule(2, emerged, self)
-- 		end
-- 	end
-- end

-- function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
-- 	if spellId == 28819 and self:AntiSpam(2, 1) then--Submerge Visual
-- 		self:SendSync("Submerge")
-- 	elseif spellId == 37660 and self:AntiSpam(2, 2) then
-- 		self:SendSync("Whirl")
-- 	end
-- end

-- function mod:OnSync(msg)
-- 	if not self:IsInCombat() then return end
-- 	if msg == "Submerge" then
-- 		self.vb.submerged = true
-- 		self.vb.guardianKill = 0
-- 		self.vb.ambusherKill = 0
-- 		timerSubmerge:Cancel()
-- 		timerSpoutCD:Cancel()
-- 		timerWhirlCD:Cancel()
-- 		warnSubmerge:Show()
-- 		timerEmerge:Start()
-- 		self:Schedule(60, emerged, self)
-- 	elseif msg == "Whirl" then
-- 		warnWhirl:Show()
-- 		timerWhirlCD:Start()
-- 	end
-- end




-----------------------------------------------
-----------------------------------------------

local mod	= DBM:NewMod("LurkerBelow", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(21217)
mod:RegisterCombat("combat", 21217)

mod:RegisterEventsInCombat(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnSubmerge        = mod:NewAnnounce("WarnSubmerge", 3)
local warnEmerge          = mod:NewAnnounce("WarnEmerge", 3)

local specWarnSpout       = mod:NewSpecialWarningRun(37433)

local timerSubmerge       = mod:NewTimer(115, "Submerge", "Interface\\AddOns\\DBM-Core\\Textures\\CryptFiendBurrow.blp")
local timerEmerge         = mod:NewTimer(64, "Emerge", "Interface\\AddOns\\DBM-Core\\Textures\\CryptFiendUnBurrow.blp")
local timerSpout          = mod:NewCastTimer(14, 37433)
local timerSpoutCD        = mod:NewCDTimer(36, 37433)

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
	timerSubmerge:Start(90)
	self:ScheduleMethod(90, "Submerge")
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
