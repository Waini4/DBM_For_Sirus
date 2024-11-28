local mod	= DBM:NewMod("Bloodboil", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(22948)
mod:SetUsedIcons(2, 3, 4, 5, 6, 7, 8)

mod:SetModelID(22948)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 373745",
	"SPELL_CAST_SUCCESS 42005",
	"SPELL_AURA_APPLIED 373742 373744 373749 373747",
	"SPELL_AURA_APPLIED_DOSE 373742 373749 373747",
	"SPELL_AURA_REMOVED 373742"
)

--TODO, verify blood is in combat log like that, otherwise have to use playerdebuffstacks frame instead
--local warnFilth			= mod:NewTargetAnnounce(373742, 3)

--local specWarnGTFO		= mod:NewSpecialWarningGTFO(373744, nil, nil, nil, 4, 8)
local specWarnFilth		= mod:NewSpecialWarningStack(373742, nil, 18, nil, nil, 2, 2)
local specWarnBlood		= mod:NewSpecialWarningStack(373749, nil, 2, nil, nil, 1, 2)
--local specWarnRage		= mod:NewSpecialWarningYou(40604, nil, nil, nil, 1, 2)
local yellFilth			= mod:NewCountYell(373742)

local timerStrikeCast	= mod:NewCastTimer(1.5, 373745, nil, "Tank", nil, 2)
local timerStrikeCD		= mod:NewCDTimer(6, 373745, nil, "Tank", 2, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer		= mod:NewBerserkTimer(600)

--mod:AddSetIconOption("SetIconOnFilth", 373742, true, true, { 2, 3, 4, 5, 6, 7, 8})
mod:AddInfoFrameOption(373742)
--mod:AddInfoFrameOption(373747)
--local ApofStack = DBM:GetSpellInfoNew(373747)
local FilthBuff = DBM:GetSpellInfoNew(373742)
mod:AddRangeFrameOption(8, nil, true)
--mod.vb.Filth = 8


function mod:OnCombatStart(delay)
--	self.vb.Filth = 8
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(FilthBuff)
		DBM.InfoFrame:Show(30, "playerdebuffstacks", FilthBuff, 2)
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
	timerStrikeCD:Start()
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 373745 then
		timerStrikeCast:Start()
		timerStrikeCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	local amount = args.amount or 1
	if spellId == 373742 then
		--[[if amount >= 18 then
			if args:IsPlayer() and self:AntiSpam(2) then
				specWarnFilth:Show(amount)
				yellFilth:Yell(amount)
			end
			if self.Options.SetIconOnFilth then
				self:SetIcon(args.destName, self.vb.Filth)
				self.vb.Filth = self.vb.Filth - 1
				if self.vb.Filth < 2 then
					self.vb.Filth = 8
				end
			end
		end]]
	elseif spellId == 373749 then
		if amount >= 2 and args:IsPlayer() and self:AntiSpam(2) then
			specWarnBlood:Show(amount)
		end
	--elseif spellId == 373744 and self:AntiSpam(2) then
	--	specWarnGTFO:Show(args.spellName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
--mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 373742 then
		if self.Options.SetIconOnFilth then
			self:RemoveIcon(args.destName)
		end
	end
end
]]