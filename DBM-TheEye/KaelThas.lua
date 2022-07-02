-- local mod	= DBM:NewMod("KaelThas", "DBM-TheEye")
-- local L		= mod:GetLocalizedStrings()

-- mod:SetRevision("20220518110528")
-- mod:SetCreatureID(19622)

-- --mod:RegisterCombat("yell", L.YellPull1, L.YellPull2)
-- mod:RegisterCombat("combat")
-- mod:SetUsedIcons(1, 6, 7, 8)

-- mod:RegisterEvents(
-- 	"SPELL_CAST_START 44863 36819 35941",
-- 	"SPELL_AURA_APPLIED 37018 36797 37027 36815 35859",
-- 	"SPELL_AURA_APPLIED_DOSE 35859",
-- 	"SPELL_AURA_REMOVED 36815 36797 37027",
-- 	"SPELL_CAST_SUCCESS 36723 36834 34341",
-- 	"CHAT_MSG_MONSTER_EMOTE",
-- 	"CHAT_MSG_MONSTER_YELL",
-- 	"UNIT_DIED",
-- 	"UNIT_SPELLCAST_SUCCEEDED"
-- )

-- local warnGaze			= mod:NewAnnounce("WarnGaze", 4, 39414)
-- local warnFear			= mod:NewCastAnnounce(44863, 3)
-- local warnConflag		= mod:NewTargetAnnounce(37018, 4, nil, false)
-- local warnToy			= mod:NewTargetAnnounce(37027, 2, nil, false)
-- local warnPhase2		= mod:NewPhaseAnnounce(2)
-- local warnMobDead		= mod:NewAnnounce("WarnMobDead", 3, nil, false)
-- local warnPhase3		= mod:NewPhaseAnnounce(3)
-- local warnPhase4		= mod:NewPhaseAnnounce(4)
-- local warnDisruption	= mod:NewSpellAnnounce(36834, 3)
-- local warnMC			= mod:NewTargetNoFilterAnnounce(36797, 4)
-- local warnPhoenix		= mod:NewSpellAnnounce(36723, 2)
-- local warnFlamestrike	= mod:NewSpellAnnounce(36735, 4)
-- local warnEgg			= mod:NewAnnounce("WarnEgg", 4, 36723)
-- local warnPyro			= mod:NewCastAnnounce(36819, 4)
-- local warnPhase5		= mod:NewPhaseAnnounce(5)
-- local warnGravity		= mod:NewSpellAnnounce(35966, 3)

-- local specWarnGaze		= mod:NewSpecialWarning("SpecWarnGaze", nil, nil, nil, 4, 2)
-- local specWarnToy		= mod:NewSpecialWarningYou(37027, nil, nil, nil, 1, 2)
-- local specWarnEgg		= mod:NewSpecialWarning("SpecWarnEgg", nil, nil, nil, 1, 2)
-- local specWarnShield	= mod:NewSpecialWarningSpell(36815)--No decent voice for this
-- local specWarnPyro		= mod:NewSpecialWarningInterrupt(36819, "HasInterrupt", nil, nil, 1, 2)
-- local specWarnVapor		= mod:NewSpecialWarningStack(35859, nil, 2, nil, nil, 1, 6)

-- local timerPhase		= mod:NewTimer(105, "TimerPhase", 28131, nil, nil, 6, nil, nil, 1, 4)
-- local timerPhase1mob	= mod:NewTimer(30, "TimerPhase1mob", 28131, nil, nil, 1, nil, nil, 1, 4)
-- local timerNextGaze		= mod:NewTimer(8.5, "TimerNextGaze", 39414, nil, nil, 3)
-- local timerFearCD		= mod:NewCDTimer(31, 39427, nil, nil, nil, 2)
-- local timerToy			= mod:NewTargetTimer(60, 37027, nil, false, nil, 3)
-- local timerPhoenixCD	= mod:NewCDTimer(45, 36723, nil, nil, nil, 1)
-- local timerRebirth		= mod:NewTimer(15, "TimerRebirth", 36723, nil, nil, 1)
-- local timerShieldCD		= mod:NewCDTimer(60, 36815, nil, nil, nil, 4)
-- local timerGravityCD	= mod:NewNextTimer(92, 35941, nil, nil, nil, 6)
-- local timerGravity		= mod:NewBuffActiveTimer(32, 35941, nil, nil, nil, 6)
-- local timerMCCD			= mod:NewCDTimer(60, 36797)

-- mod:AddSetIconOption("MCIcon", 36797, true, false, {8, 7, 6})
-- mod:AddBoolOption("GazeIcon", false)
-- --mod:AddSetIconOption("GazeIcon", 38280, false, false, {1})--Problem with no auto localized spellID to use
-- mod:AddRangeFrameOption(10, 37018)

-- mod.vb.mcIcon = 8
-- local warnConflagTargets = {}
-- local warnMCTargets = {}

-- local function showConflag()
-- 	warnConflag:Show(table.concat(warnConflagTargets, "<, >"))
-- 	table.wipe(warnConflagTargets)
-- end

-- local function MCFailsafe(self)
-- 	timerMCCD:Start(70)
-- 	self:Schedule(70, MCFailsafe, self)
-- end

-- local function showMC(self)
-- 	warnMC:Show(table.concat(warnMCTargets, "<, >"))
-- 	table.wipe(warnMCTargets)
-- 	self.vb.mcIcon = 8
-- 	timerMCCD:Start()
-- end

-- local showShieldHealthBar, hideShieldHealthBar
-- do
-- 	local frame = CreateFrame("Frame") -- using a separate frame avoids the overhead of the DBM event handlers which are not meant to be used with frequently occuring events like all damage events...
-- 	local shieldedMob
-- 	local absorbRemaining = 0
-- 	local maxAbsorb = 0
-- 	local function getShieldHP()
-- 		return math.max(1, math.floor(absorbRemaining / maxAbsorb * 100))
-- 	end
-- 	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
-- 	frame:SetScript("OnEvent", function(self, event, timestamp, subEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
-- 		if shieldedMob == destGUID then
-- 			local absorbed
-- 			if subEvent == "SWING_MISSED" then
-- 				absorbed = select( 2, ... )
-- 			elseif subEvent == "RANGE_MISSED" or subEvent == "SPELL_MISSED" or subEvent == "SPELL_PERIODIC_MISSED" then
-- 				absorbed = select( 5, ... )
-- 			end
-- 			if absorbed then
-- 				absorbRemaining = absorbRemaining - absorbed
-- 			end
-- 		end
-- 	end)

-- 	function showShieldHealthBar(self, mob, shieldName, absorb)
-- 		shieldedMob = mob
-- 		absorbRemaining = absorb
-- 		maxAbsorb = absorb
-- 		DBM.BossHealth:RemoveBoss(getShieldHP)
-- 		DBM.BossHealth:AddBoss(getShieldHP, shieldName)
-- 		self:Schedule(15, hideShieldHealthBar)
-- 	end

-- 	function hideShieldHealthBar()
-- 		DBM.BossHealth:RemoveBoss(getShieldHP)
-- 	end
-- end

-- function mod:OnCombatStart(delay)
-- 	table.wipe(warnConflagTargets)
-- 	table.wipe(warnMCTargets)
-- 	self.vb.mcIcon = 8
-- 	self:SetStage(1)
-- 	timerPhase1mob:Start(32, L.Thaladred)
-- 	if self.Options.HealthFrame then
-- 		DBM.BossHealth:Clear()
-- 		DBM.BossHealth:Show(L.name)
-- 		DBM.BossHealth:AddBoss(20064, L.Thaladred)
-- 	end
-- end

-- function mod:OnCombatEnd()
-- 	if self.Options.RangeFrame then
-- 		DBM.RangeCheck:Hide()
-- 	end
-- end

-- function mod:SPELL_AURA_APPLIED(args)
-- 	local spellId = args.spellId
-- 	if spellId == 37018 then
-- 		warnConflagTargets[#warnConflagTargets + 1] = args.destName
-- 		self:Unschedule(showConflag)
-- 		self:Schedule(0.3, showConflag)
-- 	elseif spellId == 36797 then
-- 		warnMCTargets[#warnMCTargets + 1] = args.destName
-- 		self:Unschedule(showMC)
-- 		if self.Options.MCIcon then
-- 			self:SetIcon(args.destName, self.vb.mcIcon, 25)
-- 		end
-- 		self.vb.mcIcon = self.vb.mcIcon - 1
-- 		if #warnMCTargets >= 3 then
-- 			showMC(self)
-- 		else
-- 			self:Schedule(0.3, showMC, self)
-- 		end
-- 	elseif spellId == 37027 then
-- 		timerToy:Start(args.destName)
-- 		if args:IsPlayer() then
-- 			specWarnToy:Show()
-- 		else
-- 			warnToy:Show(args.destName)
-- 		end
-- 	elseif spellId == 36815 and self.vb.phase ~= 5 then
-- 		showShieldHealthBar(self, args.destGUID, args.spellName, 80000)
-- 		specWarnShield:Show()
-- 		timerShieldCD:Start()
-- 	elseif args.spellId == 35859 and args:IsPlayer() and self:IsInCombat() and (args.amount or 1) >= 2 then
-- 		specWarnVapor:Show(args.amount)
-- 		specWarnVapor:Play("stackhigh")
-- 	end
-- end
-- mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

-- function mod:SPELL_AURA_REMOVED(args)
-- 	local spellId = args.spellId
-- 	if spellId == 36815 and self.vb.phase ~= 5 then
-- 		specWarnPyro:Show(args.sourceName)
-- 		specWarnPyro:Play("kickcast")
-- 		hideShieldHealthBar()
-- 	elseif spellId == 36797 then
-- 		if self.Options.MCIcon then
-- 			self:SetIcon(args.destName, 0)
-- 		end
-- 	elseif spellId == 37027 then
-- 		timerToy:Cancel(args.destName)
-- 	end
-- end

-- function mod:SPELL_CAST_START(args)
-- 	local spellId = args.spellId
-- 	if spellId == 44863 then
-- 		warnFear:Show()
-- 		timerFearCD:Start()
-- 	elseif spellId == 36819 then
-- 		warnPyro:Show()
-- 	elseif spellId == 35941 then
-- 		warnGravity:Show()
-- 		timerGravity:Start()
-- 		timerGravityCD:Start()
-- 	end
-- end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args.spellId == 36723 then
-- 		warnPhoenix:Show()
-- 		if self.vb.phase == 5 then
-- 			timerPhoenixCD:Start(90)
-- 		else
-- 			timerPhoenixCD:Start()
-- 		end
-- 	elseif args.spellId == 36834 then
-- 		warnDisruption:Show()
-- 	elseif args.spellId == 34341 and self:IsInCombat() then
-- 		warnEgg:Show()
-- 		specWarnEgg:Show()
-- 		specWarnEgg:Play("killmob")
-- 		timerRebirth:Show()
-- 		DBM.BossHealth:AddBoss(21364, L.Egg)
-- 		self:Schedule(15, function()
-- 			DBM.BossHealth:RemoveBoss(21364)
-- 		end)
-- 	end
-- end

-- function mod:UNIT_DIED(args)
-- 	local cid = self:GetCIDFromGUID(args.destGUID)
-- 	if cid == 20064 then
-- 		timerNextGaze:Cancel()
-- 		DBM.BossHealth:RemoveBoss(20064)
-- 	elseif cid == 20060 then
-- 		timerFearCD:Cancel()
-- 		DBM.BossHealth:RemoveBoss(20060)
-- 	elseif cid == 20062 then
-- 		if self.Options.RangeFrame then
-- 			DBM.RangeCheck:Hide()
-- 		end
-- 		DBM.BossHealth:RemoveBoss(20062)
-- 	elseif cid == 20063 then
-- 		DBM.BossHealth:RemoveBoss(20063)
-- 	elseif cid == 21268 then
-- 		warnMobDead:Show(L.Bow)
-- 		DBM.BossHealth:RemoveBoss(21268)
-- 	elseif cid == 21269 then
-- 		warnMobDead:Show(L.Axe)
-- 		DBM.BossHealth:RemoveBoss(21269)
-- 	elseif cid == 21270 then
-- 		warnMobDead:Show(L.Mace)
-- 		DBM.BossHealth:RemoveBoss(21270)
-- 	elseif cid == 21271 then
-- 		warnMobDead:Show(L.Dagger)
-- 		DBM.BossHealth:RemoveBoss(21271)
-- 	elseif cid == 21272 then
-- 		warnMobDead:Show(L.Sword)
-- 		DBM.BossHealth:RemoveBoss(21272)
-- 	elseif cid == 21273 then
-- 		warnMobDead:Show(L.Shield)
-- 		DBM.BossHealth:RemoveBoss(21273)
-- 	elseif cid == 21274 then
-- 		warnMobDead:Show(L.Staff)
-- 		DBM.BossHealth:RemoveBoss(21274)
-- 	elseif cid == 21364 then
-- 		timerRebirth:Cancel()
-- 		DBM.BossHealth:RemoveBoss(21364)
-- 	end
-- end

-- function mod:CHAT_MSG_MONSTER_EMOTE(msg, _, _, _, target)
-- 	if (msg == L.EmoteGaze or msg:find(L.EmoteGaze)) and target then
-- 		target = DBM:GetUnitFullName(target)
-- 		timerNextGaze:Start()
-- 		if target == UnitName("player") then
-- 			specWarnGaze:Show()
-- 			specWarnGaze:Play("justrun")
-- 		else
-- 			warnGaze:Show(target)
-- 		end
-- 		if self.Options.GazeIcon then
-- 			self:SetIcon(target, 1, 15)
-- 		end
-- 	end
-- end

-- function mod:CHAT_MSG_MONSTER_YELL(msg)
-- 	if msg == L.YellSang or msg:find(L.YellSang) then
-- 		timerPhase1mob:Start(12.5, L.Sanguinar)
-- 		DBM.BossHealth:AddBoss(20060, L.Sanguinar)
-- 	elseif msg == L.YellCaper or msg:find(L.YellCaper) then
-- 		timerPhase1mob:Start(7, L.Capernian)
-- 		DBM.BossHealth:AddBoss(20062, L.Capernian)
-- 		if self.Options.RangeFrame then
-- 			DBM.RangeCheck:Show(10)
-- 		end
-- 	elseif msg == L.YellTelo or msg:find(L.YellTelo) then
-- 		timerPhase1mob:Start(8.4, L.Telonicus)
-- 		DBM.BossHealth:AddBoss(20063, L.Telonicus)
-- 	elseif msg == L.YellPhase2 or msg:find(L.YellPhase2) then
-- 		self:SetStage(2)
-- 		timerPhase:Start(105)--105
-- 		warnPhase2:Show()
-- 		warnPhase3:Schedule(105)--210
-- 		DBM.BossHealth:AddBoss(21268, L.Bow)
-- 		DBM.BossHealth:AddBoss(21269, L.Axe)
-- 		DBM.BossHealth:AddBoss(21270, L.Mace)
-- 		DBM.BossHealth:AddBoss(21271, L.Dagger)
-- 		DBM.BossHealth:AddBoss(21272, L.Sword)
-- 		DBM.BossHealth:AddBoss(21273, L.Shield)
-- 		DBM.BossHealth:AddBoss(21274, L.Staff)
-- 	elseif msg == L.YellPhase3 or msg:find(L.YellPhase3) then
-- 		self:SetStage(3)
-- 		warnPhase3:Show()
-- 		if self.Options.RangeFrame then
-- 			DBM.RangeCheck:Show(10)
-- 		end
-- 		self:Schedule(10, function()
-- 			DBM.BossHealth:AddBoss(20064, L.Thaladred)
-- 			DBM.BossHealth:AddBoss(20060, L.Sanguinar)
-- 			DBM.BossHealth:AddBoss(20062, L.Capernian)
-- 			DBM.BossHealth:AddBoss(20063, L.Telonicus)
-- 			timerPhase:Start(73)--83 pre nerf, 183 post nerf
-- 		end)
-- 	elseif msg == L.YellPhase4 or msg:find(L.YellPhase4) then
-- 		self:SetStage(4)
-- 		DBM.BossHealth:AddBoss(19622, L.name)
-- 		warnPhase4:Show()
-- 		timerPhase:Cancel()
-- 		timerPhoenixCD:Start(50)
-- 		timerShieldCD:Start(60)
-- 		timerMCCD:Start(40)
-- 		self:Schedule(40, MCFailsafe, self)
-- 	elseif msg == L.YellPhase5 or msg:find(L.YellPhase5) then
-- 		self:SetStage(5)
-- 		timerPhoenixCD:Cancel()
-- 		timerShieldCD:Cancel()
-- 		timerPhase:Start(45)
-- 		warnPhase5:Schedule(45)
-- 		timerGravityCD:Start(60)
-- 		timerPhoenixCD:Start(137)
-- 	end
-- end

-- function mod:UNIT_SPELLCAST_SUCCEEDED(uId, spellName)
-- 	if spellName == GetSpellInfo(36735) then
-- 		self:SendSync("Flamestrike")
-- 	end
-- end

-- function mod:OnSync(event, arg)
-- 	if not self:IsInCombat() then return end
-- 	if event == "Flamestrike" then
-- 		warnFlamestrike:Show()
-- 	end
-- end


----------------------------------------------------
----------------------------------------------------




local mod	= DBM:NewMod("KaelThas", "DBM-TheEye")
local L		= mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(19622)
mod:RegisterCombat("yell", L.YellPhase1)
mod:SetUsedIcons(5, 6, 7, 8)
mod:AddBoolOption("RemoveWeaponOnMindControl", true)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	-- "SPELL_CAST_START",
	-- "SPELL_AURA_APPLIED",
	-- "SPELL_AURA_APPLIED_DOSE",
	"UNIT_TARGET"
	-- "SPELL_AURA_REMOVED",
	-- "SPELL_CAST_SUCCESS"
)
mod:RegisterEventsInCombat(
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_START 40636 37036 35941 308742 308790",
	"SPELL_AURA_APPLIED 36797 308732 308741 308749 308756",
	"SPELL_AURA_APPLIED_DOSE 36797 308732 308741 308749 308756",
	"UNIT_TARGET",
	"SPELL_AURA_REMOVED 36797 308797 34480 308969 308970",
	"SPELL_CAST_SUCCESS 36797 37018 36723 36815 36731 308797"
)

local warnPhase             = mod:NewAnnounce("WarnPhase", 1)
local warnNextAdd           = mod:NewAnnounce("WarnNextAdd", 2)
local warnTalaTarget        = mod:NewAnnounce("WarnTalaTarget", 4)
local warnConflagrateSoon   = mod:NewSoonAnnounce(37018, 2)
local warnConflagrate       = mod:NewTargetAnnounce(37018, 4)
local warnBombSoon          = mod:NewSoonAnnounce(37036, 2)
local warnBarrierSoon       = mod:NewSoonAnnounce(36815, 2)
local warnPhoenixSoon       = mod:NewSoonAnnounce(36723, 2)
local warnMCSoon            = mod:NewSoonAnnounce(36797, 2)
local warnMC                = mod:NewTargetAnnounce(36797, 3)
local warnGravitySoon       = mod:NewSoonAnnounce(35941, 2)

local specWarnTalaTarget    = mod:NewSpecialWarning("SpecWarnTalaTarget", nil, nil, nil, 1, 2)

local timerNextAdd          = mod:NewTimer(30, "TimerNextAdd", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 2)
local timerPhase3           = mod:NewTimer(123, "TimerPhase3", "Interface\\Icons\\Spell_Shadow_AnimateDead", nil, nil, 2)
local timerPhase4           = mod:NewTimer(180, "TimerPhase4", 34753, nil, nil, 2)
local timerTalaTarget       = mod:NewTimer(8.5, "TimerTalaTarget", "Interface\\Icons\\Spell_Fire_BurningSpeed")
local timerRoarCD           = mod:NewCDTimer(31, 40636, nil, nil, nil, 3)
local timerConflagrateCD    = mod:NewCDTimer(20, 37018, nil, nil, nil, 3)
local timerBombCD           = mod:NewCDTimer(25, 37036, nil, nil, nil, 3)
local timerFlameStrike      = mod:NewCDTimer(35, 36731, nil, nil, nil, 3)

local timerBarrierCD        = mod:NewCDTimer(70, 36815, nil, nil, nil, 3)
local timerPhoenixCD        = mod:NewCDTimer(60, 36723, nil, nil, nil, 1, nil, CL.DAMAGE_ICON	)
local timerMCCD             = mod:NewCDTimer(70, 36797, nil, nil, nil, 3)

local timerGravity          = mod:NewTimer(32.5, "TimerGravity", "Interface\\Icons\\Spell_Magic_FeatherFall", nil, nil, 4, nil, CL.DEADLY_ICON, nil, 2, 5)
local timerGravityCD        = mod:NewCDTimer(90, 35941, nil, nil, nil, 4, nil, CL.DEADLY_ICON, nil, 2, 4)

--------------------------хм------------------------

local warnFurious		= mod:NewStackAnnounce(308732, 2, nil, "Tank|Healer") -- яростный удар
local warnJustice		= mod:NewStackAnnounce(308741, 2, nil, "Tank|Healer") -- правосудие тьмы
local warnIsc			= mod:NewStackAnnounce(308756, 2, nil, "Tank|Healer") -- Искрящий
local warnShadow        = mod:NewSoonAnnounce(308742, 2) -- освященеи тенью (лужа)
local warnBombhm        = mod:NewTargetAnnounce(308750, 2) -- бомба
local warnVzriv         = mod:NewTargetAnnounce(308797, 2) -- лужа

local specWarnCata      = mod:NewSpecialWarningRun(308790, nil, nil, nil, 4, 2)
local specWarnVzriv     = mod:NewSpecialWarningRun(308797, nil, nil, nil, 3, 3)
local yellVzriv			= mod:NewYell(308797, nil, nil, nil, "YELL")

local timerFuriousCD    = mod:NewCDTimer(7, 308732, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerFurious		= mod:NewTargetTimer(30, 308732, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerJusticeCD    = mod:NewCDTimer(9, 308741, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerJustice		= mod:NewTargetTimer(30, 308741, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerIsc	    	= mod:NewTargetTimer(15, 308756, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerShadowCD		= mod:NewCDTimer(17, 308742, nil, nil, nil, 4)
local timerBombhmCD		= mod:NewCDTimer(35, 308749, nil, nil, nil, 1)
local timerCataCD		= mod:NewCDTimer(126, 308790, nil, nil, nil, 2)
local timerCataCast		= mod:NewCastTimer(8, 308790, nil, nil, nil, 2)
local timerVzrivCD		= mod:NewCDTimer(115, 308797, nil, nil, nil, 2)
local timerVzrivCast    = mod:NewCastTimer(5, 308797, nil, nil, nil, 2)
local timerGravityH     = mod:NewTimer(63, "TimerGravity", "Interface\\Icons\\Spell_Magic_FeatherFall", nil, nil, 6, nil, CL.DEADLY_ICON)
local timerGravityHCD	= mod:NewCDTimer(150, 35941, nil, nil, nil, 6, nil, CL.DEADLY_ICON)
--local timerBurningCD    = mod:NewCDTimer(8, 308741, nil, nil, nil, 5, nil, CL.TANK_ICON)
--local timerBurning		= mod:NewTargetTimer(30, 308741, nil, nil, nil, 5, nil, CL.TANK_ICON)



----------------------------------------------------

--local Kel = true


mod:AddSetIconOption("SetIconOnMC", 36797, true, true, {6, 7, 8})
mod:AddSetIconOption("VzrivIcon", 308742, true, true, {8})
mod:AddBoolOption("AnnounceVzriv", false)
mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("RemoveShadowResistanceBuffs", true)

mod.vb.phase = 0
local BombhmTargets = {}
-- local VzrivTargets = {}
local VzrivIcon = 8
local dominateMindTargets = {}
local dominateMindIcon = 8
local mincControl = {}
local axe = true

function mod:AxeIcon()
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid"..i.."target") == L.Axe then
			axe = false
			SetRaidTarget("raid"..i.."target", 8)
			break
		end
	end
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 19622, "Kael'thas Sunstrider")
	self.vb.phase = 1
	dominateMindIcon = 8
	axe = true
	warnPhase:Show(L.WarnPhase1)
	timerNextAdd:Start(L.NamesAdds["Thaladred"])
	table.wipe(dominateMindTargets)
	table.wipe(mincControl)
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 19622, "Kael'thas Sunstrider", wipe)
	DBM.RangeCheck:Hide()
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:match(L.TalaTarget) then
		local target = msg:sub(29,-3) or "Unknown"
		warnTalaTarget:Show(target)
		timerTalaTarget:Start(target)
		if target == UnitName("player") then
			specWarnTalaTarget:Show()
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if mod:IsDifficulty("heroic25") then
		if msg == L.YellSang then
		    timerTalaTarget:Cancel()
		    warnNextAdd:Show(L.NamesAdds["Lord Sanguinar"])
		    timerNextAdd:Start(12.5, L.NamesAdds["Lord Sanguinar"])
		elseif msg == L.YellCaper then
			timerRoarCD:Cancel()
			warnNextAdd:Show(L.NamesAdds["Capernian"])
			timerNextAdd:Start(7, L.NamesAdds["Capernian"])
			DBM.RangeCheck:Show(10)
		elseif msg == L.YellTelon then
			DBM.RangeCheck:Hide()
			warnConflagrateSoon:Cancel()
			timerConflagrateCD:Cancel()
			warnNextAdd:Show(L.NamesAdds["Telonicus"])
			timerNextAdd:Start(8.4, L.NamesAdds["Telonicus"])
		elseif msg == L.YellPhase3  then
			self.vb.phase = 3
			warnPhase:Show(L.WarnPhase3)
			timerPhase4:Start()
			timerRoarCD:Start()
			warnBombSoon:Schedule(10)
			timerBombCD:Start(15)
			DBM.RangeCheck:Show(10)
		elseif msg == L.YellPhase4  then
			self.vb.phase = 4
			warnPhase:Show(L.WarnPhase4)
			timerPhase4:Cancel()
			DBM.RangeCheck:Hide()
		elseif msg == L.YellPhase5  then
			self.vb.phase = 5
			warnPhase:Show(L.WarnPhase5)
		end
	else
		if msg == L.YellSang then
		    timerTalaTarget:Cancel()
			warnNextAdd:Show(L.NamesAdds["Lord Sanguinar"])
			timerNextAdd:Start(12.5, L.NamesAdds["Lord Sanguinar"])
			timerRoarCD:Start(33)
		elseif msg == L.YellCaper then
			timerRoarCD:Cancel()
			warnNextAdd:Show(L.NamesAdds["Capernian"])
			timerNextAdd:Start(7, L.NamesAdds["Capernian"])
			DBM.RangeCheck:Show(10)
		elseif msg == L.YellTelon then
			DBM.RangeCheck:Hide()
			warnConflagrateSoon:Cancel()
			timerConflagrateCD:Cancel()
			warnNextAdd:Show(L.NamesAdds["Telonicus"])
			timerNextAdd:Start(8.4, L.NamesAdds["Telonicus"])
			warnBombSoon:Schedule(13)
			timerBombCD:Start(18)
		elseif msg == L.YellPhase2 then
			self.vb.phase = 2
			warnBombSoon:Cancel()
			timerBombCD:Cancel()
			warnPhase:Show(L.WarnPhase2)
			timerPhase3:Start()
		elseif msg == L.YellPhase3  then
			self.vb.phase = 3
			warnPhase:Show(L.WarnPhase3)
			timerPhase4:Start()
			timerRoarCD:Start()
			warnBombSoon:Schedule(10)
			timerBombCD:Start(15)
			DBM.RangeCheck:Show(10)
		elseif msg == L.YellPhase4  then
			self.vb.phase = 4
			if self.Options.RemoveShadowResistanceBuffs and mod:IsDifficulty("normal25", "normal10") then
				mod:ScheduleMethod(0.1, "RemoveBuffs")
			end
			warnPhase:Show(L.WarnPhase4)
			timerPhase4:Cancel()
			timerRoarCD:Cancel()
			warnBombSoon:Cancel()
			timerBombCD:Cancel()
			warnConflagrateSoon:Cancel()
			timerConflagrateCD:Cancel()
			timerMCCD:Start(40)
			timerBarrierCD:Start(60)
			timerPhoenixCD:Start(50)
			warnBarrierSoon:Schedule(55)
			warnPhoenixSoon:Schedule(45)
			warnMCSoon:Schedule(35)
		elseif msg == L.YellPhase5  then
			self.vb.phase = 5
			warnPhase:Show(L.WarnPhase5)
			timerMCCD:Cancel()
			warnMCSoon:Cancel()
			timerGravityCD:Start()
			warnGravitySoon:Schedule(85)

		end
	end
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(36797) then
-- 		if args:IsPlayer() and self.Options.RemoveWeaponOnMindControl then
-- 		   if self:IsWeaponDependent("player") then
-- 				PickupInventoryItem(16)
-- 				PutItemInBackpack()
-- 				PickupInventoryItem(17)
-- 				PutItemInBackpack()
-- 			elseif select(2, UnitClass("player")) == "HUNTER" then
-- 				PickupInventoryItem(18)
-- 				PutItemInBackpack()
-- 			end
-- 		end
-- 		dominateMindTargets[#dominateMindTargets + 1] = args.destName
-- 		if self.Options.SetIconOnDominateMind then
-- 			self:SetIcon(args.destName, dominateMindIcon, 12)
-- 			dominateMindIcon = dominateMindIcon - 1
-- 		end
-- --		self:Unschedule(showDominateMindWarning)
-- --		if mod:IsDifficulty("heroic10") or mod:IsDifficulty("normal25") or (mod:IsDifficulty("heroic25") and #dominateMindTargets >= 3) then
-- --			showDominateMindWarning()
-- --		else
-- --			self:Schedule(0.9, showDominateMindWarning)
-- --		end

-- 	end
-- end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 40636 then
		timerRoarCD:Start()
	elseif spellId == 37036 then
		warnBombSoon:Schedule(20)
		timerBombCD:Start()
	elseif spellId == 35941 then
	    if mod:IsDifficulty("heroic25") then
			timerGravityH:Start()
			timerGravityHCD:Start()
			else
			timerGravity:Start()
			timerGravityCD:Start()
		    warnGravitySoon:Schedule(85)
		end
    elseif spellId == 308742 then --освящение тенью
	    timerShadowCD:Start()
		warnShadow:Schedule(0)
    elseif spellId == 308790 then --катаклизм
	    timerCataCD:Start()
		timerCataCast:Start()
	    specWarnCata:Show()
		DBM.RangeCheck:Show(40, GetRaidTargetIndex)
		self:ScheduleMethod(10, "Timer")
	end
end

function mod:Timer()
	DBM.RangeCheck:Hide()
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if args:IsSpellID(36797) then
		if args:IsPlayer() and self.Options.RemoveWeaponOnMindControl then  --TODO: это не работает или зачем удалили?
		   if self:IsWeaponDependent("player") then
				PickupInventoryItem(16)
				PutItemInBackpack()
				PickupInventoryItem(17)
				PutItemInBackpack()
			elseif select(2, UnitClass("player")) == "HUNTER" then
				PickupInventoryItem(18)
				PutItemInBackpack()
			end
		end
		dominateMindTargets[#dominateMindTargets + 1] = args.destName
		if self.Options.SetIconOnDominateMind then
			self:SetIcon(args.destName, dominateMindIcon, 12)
			dominateMindIcon = dominateMindIcon - 1
		end
	end
	if spellId == 37018 then
		warnConflagrate:Show(args.destName)
		warnConflagrateSoon:Cancel()
		warnConflagrateSoon:Schedule(16)
		timerConflagrateCD:Start()
	elseif spellId == 36723 then
		timerPhoenixCD:Start()
		warnPhoenixSoon:Schedule(55)
	elseif spellId == 36815 then
		timerBarrierCD:Start()
		warnBarrierSoon:Schedule(65)
	elseif spellId == 36731 then
		timerFlameStrike:Start()
	elseif spellId == 308797 then --ВЗРЫВ ТЬМЫ
		if args:IsPlayer() then
			specWarnVzriv:Show()
			yellVzriv:Yell()
		end
		timerVzrivCast:Start()
		timerVzrivCD:Start()
		warnVzriv:Show(args.destName)
		if self.Options.VzrivIcon then
			self:SetIcon(args.destName, 8, 10)
		end
		if mod.Options.AnnounceVzriv then
			if DBM:GetRaidRank() > 0 then
				SendChatMessage(L.Vzriv:format(VzrivIcon, args.destName), "RAID_WARNING")
			else
				SendChatMessage(L.Vzriv:format(VzrivIcon, args.destName), "RAID")
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 36797 then
		timerMCCD:Start()
		warnMCSoon:Schedule(65)
		mincControl[#mincControl + 1] = args.destName
		if #mincControl >= 3 then
			warnMC:Show(table.concat(mincControl, "<, >"))
			if self.Options.SetIconOnMC then
				table.sort(mincControl, function(v1,v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
				local MCIcons = 8
				for _, v in ipairs(mincControl) do
					self:SetIcon(v, MCIcons)
					MCIcons = MCIcons - 1
				end
			end
			table.wipe(mincControl)
		end
	elseif spellId == 308732 then --хм яростный удар
		warnFurious:Show(args.destName, args.amount or 1)
		timerFurious:Start(args.destName)
		timerFuriousCD:Start()
	elseif spellId == 308741 then --хм Правосудие тенью
		timerJusticeCD:Start()
        warnJustice:Show(args.destName, args.amount or 1)
		timerJustice:Start(args.destName)
	elseif spellId == 308749 then --бомба
		timerBombhmCD:Start()
		warnBombhm:Show(table.concat(BombhmTargets, "<, >"))
	elseif spellId == 308756 then --хм искрящий удар
		warnIsc:Show(args.destName, args.amount or 1)
		timerIsc:Start(args.destName)
	end
end




function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 36797 then
		self:SetIcon(args.destName, 0)
	elseif spellId == 308797 then
		self:SetIcon(args.destName, 0)
	elseif spellId == 34480 or spellId == 308969 or spellId == 308970 then --падение
		timerGravity:Stop()
		timerGravityH:Stop()
	end
end

function mod:UNIT_TARGET()
	if axe then
		self:AxeIcon()
	end
end

function mod:RemoveBuffs()
	CancelUnitBuff("player", (GetSpellInfo(48469)))		-- Mark of the Wild
	CancelUnitBuff("player", (GetSpellInfo(48470)))		-- Gift of the Wild
	CancelUnitBuff("player", (GetSpellInfo(48169)))		-- Shadow Protection
	CancelUnitBuff("player", (GetSpellInfo(48170)))		-- Prayer of Shadow Protection
end

--[[function mod:KelIcon()
	if DBM:GetRaidRank() >= 1 then
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid"..i.."target") == L.Kel then
				Kel = false
				SetRaidTarget("raid"..i.."target", 5)
				break
			end
		end
	end
end ]]

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED