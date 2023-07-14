local mod = DBM:NewMod("Aran", "DBM-Karazhan")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20210502220000") -- fxpw check 202206151120000
mod:SetCreatureID(16524)
mod:RegisterCombat("combat")
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterEvents(
	"SPELL_CAST_START 30004 29973 305338 305329 305326 305331",
	"SPELL_AURA_APPLIED 29991 29946 305328",
	"SPELL_AURA_REMOVED 29991 305328",
	"SPELL_SUMMON 29962 37051 37052 37053",
	"UNIT_DIED"
)
mod:AddTimerLine(DBM_CORE_L.NORMAL_MODE)

local warningFlameCast  = mod:NewCastAnnounce(30004, 4)
local warningArcaneCast = mod:NewCastAnnounce(29973, 4)
local warningBlizzard   = mod:NewSpellAnnounce(29969, 3)
local warningElementals = mod:NewSpellAnnounce(37053, 3)
local warningChains     = mod:NewTargetAnnounce(29991, 2)
-- local warningFlameTargets	= mod:NewTargetAnnounce(29946, 4)
-- local warnSound						= mod:NewSoundAnnounce()

local specWarnDontMove = mod:NewSpecialWarning("DBM_ARAN_DO_NOT_MOVE")
local specWarnArcane   = mod:NewSpecialWarningRun(29973)
local specWarnBlizzard = mod:NewSpecialWarningMove(29951)

local timerSpecial         = mod:NewTimer(30, "TimerSpecialHeroic", "Interface\\Icons\\INV_Enchant_EssenceMagicLarge")
local timerFlameCast       = mod:NewCastTimer(5, 30004)
local timerArcaneExplosion = mod:NewCastTimer(10, 29973)
local timerBlizzadCast     = mod:NewCastTimer(3.7, 29969)
local timerFlame           = mod:NewBuffActiveTimer(20.5, 29946)
local timerBlizzad         = mod:NewBuffActiveTimer(40, 29951)
local timerElementals      = mod:NewBuffActiveTimer(90, 37053)
local timerChains          = mod:NewTargetTimer(10, 29991)

mod:AddTimerLine(DBM_CORE_L.HEROIC_MODE)

local warnFreeze         = mod:NewAnnounce("WarnFreeze", 4, 305328)

local specWarnWinter     = mod:NewSpecialWarningRun(305329)
local specWarnFreeze     = mod:NewSpecialWarning("SpecWarnFreeze")

local timerFreeze        = mod:NewTargetTimer(30, 305328)
local timerSpecialHeroic = mod:NewTimer(43, "TimerSpecialHeroic", "Interface\\Icons\\INV_Enchant_EssenceMagicLarge")

local berserkTimer = mod:NewBerserkTimer(900)

mod:AddSetIconOption("ElementalIcons", 29962, true, true, { 6, 7, 8 })

local beastIcon = {}
local WreathTargets = {}
mod.vb.famCounter = 1


function mod:OnCombatStart(delay)
	DBM:FireCustomEvent("DBM_EncounterStart", 16524, "Shade of Aran")
	if self:IsDifficulty("normal10") then
		berserkTimer:Start(-delay)
	elseif self:IsDifficulty("heroic10") then
		timerSpecialHeroic:Start()
		self.vb.famCounter = 1
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 16524, "Shade of Aran", wipe)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30004) then
		warningFlameCast:Show()
		timerFlameCast:Start()
		timerSpecial:Start()
	elseif args:IsSpellID(29973) then
		warningArcaneCast:Show()
		timerArcaneExplosion:Start()
		specWarnArcane:Show()
		timerSpecial:Start()
	elseif args:IsSpellID(29969) then
		warningBlizzard:Show()
		timerBlizzadCast:Show()
		timerBlizzad:Schedule(3.7) --may need tweaking
		timerSpecial:Start()
	elseif args:IsSpellID(305338) then
		specWarnDontMove:Show()
		timerSpecialHeroic:Start()
	elseif args:IsSpellID(305329) then
		specWarnWinter:Show()
		timerSpecialHeroic:Start()
	elseif args:IsSpellID(305326) then
		if args.destName == UnitName("player") then
			specWarnFreeze:Show()
		end
	elseif args:IsSpellID(305331) then
		-- local name = {"tobecon","dramatic"}
		-- name  = name[math.random(#name)]
		-- warnSound:Play(name)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29991) then
		warningChains:Show(args.destName)
		timerChains:Start(args.destName)
	elseif args:IsSpellID(29946) then
		timerFlame:Start()
		if args:IsPlayer() then
			specWarnDontMove:Show()
		end
	elseif args:IsSpellID(305328) then
		timerFreeze:Start(args.destName)
		warnFreeze:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(29991) then
		timerChains:Cancel(args.destName)
	elseif args:IsSpellID(305328) then
		timerFreeze:Cancel(args.destName)
	end
end

do
	local elementalIcon = {}
	local currentIcon = 1
	local iconsSet = 0
	local function resetElementalIconState()
		table.wipe(elementalIcon)
		currentIcon = 1
		iconsSet = 0
	end

	local lastElemental = 0
	function mod:SPELL_SUMMON(args)
		if args:IsSpellID(29962, 37051, 37052, 37053) then -- Summon Water elementals
			if time() - lastElemental > 5 then
				warningElementals:Show()
				timerElementals:Show()
				lastElemental = time()
				if self.Options.ElementalIcons then
					resetElementalIconState()
				end
			end
			if self.Options.ElementalIcons then
				elementalIcon[args.destGUID] = currentIcon
				currentIcon = currentIcon + 1
			end
		end
	end

	mod:RegisterOnUpdateHandler(function(self)
		if self.Options.ElementalIcons and (DBM:GetRaidRank() > 0 and (iconsSet ~= 4)) then
			for i = 1, GetNumRaidMembers() do
				local uId = "raid" .. i .. "target"
				local guid = UnitGUID(uId)
				if guid then
					if beastIcon[guid] then
						SetRaidTarget(uId, elementalIcon[guid])
						iconsSet = iconsSet + 1
						elementalIcon[guid] = nil
					end
				end
			end
		end
	end, 1)
end

do
	local lastBlizzard = 0
	function mod:SPELL_PERIODIC_DAMAGE(args)
		if args:IsSpellID(29951) and args:IsPlayer() and GetTime() - lastBlizzard > 2 then
			specWarnBlizzard:Show()
			lastBlizzard = GetTime()
		end
	end
end

function mod:UNIT_DIED(args)
	if args.destName == L.Familliar then
		if self.vb.famCounter == 3 then
			timerSpecialHeroic:Start()
			self.vb.famCounter = 1
		else
			self.vb.famCounter = self.vb.famCounter + 1
		end
	end
end
