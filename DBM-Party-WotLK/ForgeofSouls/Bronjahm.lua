local mod	= DBM:NewMod("Bronjahm", "DBM-Party-WotLK", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(36497)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68872",
	"SPELL_AURA_APPLIED 68839",
	"UNIT_HEALTH boss1"
)

local warnSoulstormSoon		= mod:NewSoonAnnounce(68872, 2)
local warnCorruptSoul		= mod:NewTargetNoFilterAnnounce(68839, 4)

local specwarnSoulstorm		= mod:NewSpecialWarningSpell(68872, nil, nil, nil, 2, 2)
local specwarnCorruptedSoul	= mod:NewSpecialWarningMoveTo(68839, nil, nil, nil, 1, 7)

local timerSoulstormCast	= mod:NewCastTimer(4, 68872, nil, nil, nil, 2)
local timerFear				= mod:NewCDTimer(10.5, 68950, nil, nil, nil, 2)

mod.vb.warned_preStorm = false

mod:AddSetIconOption("SetIconOnCorrupt", 68839, false, false, {8})

local fear = 1
local FearTimers = {
	[2] = 10.4,
	[3] = 12.3,
	[4] = 11.4
}


function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 36497, "Bronjahm")
	self:SetStage(1)
	self.vb.warned_preStorm = false
	fear = 2
end


function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 36497, "Bronjahm", wipe)
	fear = 1

end

function mod:SPELL_CAST_START(args)
	if args.spellId == 68872 then							-- Soulstorm
		specwarnSoulstorm:Show()
		specwarnSoulstorm:Play("aesoon")
		timerSoulstormCast:Start()
		self:SetStage(2)
	elseif args.spellId == 68950 then
		if fear >= 2 then
			timerFear:Start(FearTimers[fear])
			fear = fear + 1
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 68839 then							-- Corrupt Soul
		if args:IsPlayer() then
			specwarnCorruptedSoul:Show(DBM_COMMON_L.EDGE)
			specwarnCorruptedSoul:Play("runtoedge")
		else
			warnCorruptSoul:Show(args.destName)
		end
		if self.Options.SetIconOnCorrupt then
			self:SetIcon(args.destName, 8, 8)
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if not self.vb.warned_preStorm and self:GetUnitCreatureId(uId) == 36497 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.45 then
		self.vb.warned_preStorm = true
		warnSoulstormSoon:Show()
	end
end