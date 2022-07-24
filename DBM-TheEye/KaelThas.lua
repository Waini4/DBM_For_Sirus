local mod = DBM:NewMod("KaelThas", "DBM-TheEye")
local L   = mod:GetLocalizedStrings()

local CL = DBM_COMMON_L
mod:SetRevision("20220609123000") -- fxpw check 20220609123000

mod:SetCreatureID(19622)
mod:RegisterCombat("combat")
mod:SetUsedIcons(5, 6, 7, 8)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 35941 40636 37036 308742 308732 308790",
	"SPELL_AURA_APPLIED 308732 308741 308750 308756	308797 36797",
	"SPELL_AURA_APPLIED_DOSE 308732 308741 308750 308756 308797 36797",
	"UNIT_TARGET",
	"SPELL_AURA_REMOVED 308750 36797",
	"SPELL_CAST_SUCCESS 37018 36723 308749 308743 36815 36731 308734 36797"
)

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_SUCCESS 36797 ",
	"SPELL_AURA_APPLIED_DOSE 36797 308797",
	"SPELL_AURA_APPLIED 36797 308797"
)



local warnPhase           = mod:NewAnnounce("WarnPhase", 1)
local warnNextAdd         = mod:NewAnnounce("WarnNextAdd", 2)
local warnTalaTarget      = mod:NewAnnounce("WarnTalaTarget", 4)
local warnConflagrateSoon = mod:NewSoonAnnounce(37018, 2)
local warnConflagrate     = mod:NewTargetAnnounce(37018, 4)
local warnBombSoon        = mod:NewSoonAnnounce(37036, 2)
local warnBarrierSoon     = mod:NewSoonAnnounce(36815, 2)
local warnPhoenixSoon     = mod:NewSoonAnnounce(36723, 2)
local warnMCSoon          = mod:NewSoonAnnounce(36797, 2)
local warnMC              = mod:NewTargetAnnounce(36797, 3)
local warnGravitySoon     = mod:NewSoonAnnounce(35941, 2)

local specWarnTalaTarget = mod:NewSpecialWarning("SpecWarnTalaTarget")
-- local specWarnFlameStrike   = mod:NewSpecialWarningMove(36731)

local timerNextAdd       = mod:NewTimer(30, "TimerNextAdd", "Interface\\Icons\\Spell_Nature_WispSplode", nil, nil, 2)
local timerPhase3        = mod:NewTimer(123, "TimerPhase3", "Interface\\Icons\\Spell_Shadow_AnimateDead", nil, nil, 2)
local timerPhase4        = mod:NewTimer(180, "TimerPhase4", 34753, nil, nil, 2)
local timerKeltacCD      = mod:NewTimer(32, "Keltac", 2457, nil, nil, 2)
local timerTalaTarget    = mod:NewTimer(8.5, "TimerTalaTarget", "Interface\\Icons\\Spell_Fire_BurningSpeed")
local timerRoarCD        = mod:NewCDTimer(31, 40636, nil, nil, nil, 3)
local timerConflagrateCD = mod:NewCDTimer(20, 37018, nil, nil, nil, 3)
local timerBombCD        = mod:NewCDTimer(25, 37036, nil, nil, nil, 3)
local timerFlameStrike   = mod:NewCDTimer(35, 36731, nil, nil, nil, 3)

local timerBarrierCD = mod:NewCDTimer(70, 36815, nil, nil, nil, 3)
local timerPhoenixCD = mod:NewCDTimer(60, 36723, nil, nil, nil, 1, nil, CL.DAMAGE_ICON)
local timerMCCD      = mod:NewCDTimer(70, 36797, nil, nil, nil, 3)

local timerGravity   = mod:NewBuffFadesTimer(32.5, 35941, nil, nil, nil, 4, nil,
	CL.DEADLY_ICON, nil, 2, 5) --- хм
local timerGravityCD = mod:NewCDTimer(90, 35941, nil, nil, nil, 4, nil, CL.DEADLY_ICON, nil, 2, 4) -- обычка

--об
local warnAvenger     = mod:NewTargetAnnounce(308743, 4)
local specAvenger     = mod:NewSpecialWarningYou(308743)
local specwarnVzriv   = mod:NewSpecialWarningYou(308797, nil, nil, nil, 4, 5)
local specAvengerNear = mod:NewSpecialWarning("|cff71d5ff|Hspell:308743|hЩит мстителя|h|r около вас - Стоп каст!")
local warnFurious     = mod:NewStackAnnounce(308732, 2, nil, "Tank|Healer") -- яростный удар
local warnJustice     = mod:NewStackAnnounce(308741, 2, nil, "Tank|Healer") -- правосудие тьмы
local warnIsc         = mod:NewStackAnnounce(308756, 2, nil, "Tank|Healer") -- Искрящий
local warnShadow      = mod:NewSpellAnnounce(308742, 2) -- освященеи тенью (лужа)
local warnBomb        = mod:NewTargetAnnounce(308750, 2) -- бомба
local warnVzriv       = mod:NewTargetAnnounce(308797, 2) -- лужа

local specWarnBomb = mod:NewSpecialWarningClose(308750)
local specWarnCata = mod:NewSpecialWarningRun(308790)


local timerFuriousCD  = mod:NewCDTimer(7, 308732, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerAxeCD      = mod:NewCDTimer(22, 308734, nil, nil, nil, 1)
local timerFurious    = mod:NewTargetTimer(30, 308732, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerJusticeCD  = mod:NewCDTimer(9, 308741, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerJustice    = mod:NewTargetTimer(30, 308741, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerIsc        = mod:NewTargetTimer(15, 308756, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerIscCD      = mod:NewCDTimer(6, 308756, nil, "Tank|Healer", nil, 5, nil, CL.TANK_ICON)
local timerShadowCD   = mod:NewCDTimer(17, 308742, nil, nil, nil, 4)
local timerBombhmCD   = mod:NewCDTimer(35, 308749, nil, nil, nil, 1)
local timerCataCD     = mod:NewCDTimer(126, 308790, nil, nil, nil, 2)
local timerCataCast   = mod:NewCastTimer(8, 308790, nil, nil, nil, 2)
local timerVzrivCD    = mod:NewCDTimer(115, 308797, nil, nil, nil, 3)
local timerVzrivCast  = mod:NewCastTimer(5, 308797, nil, nil, nil, 3)
local timerGravityH   = mod:NewCDTimer(63, 35941, "Interface\\Icons\\Spell_Magic_FeatherFall", nil, nil, 6, nil,
	CL.DEADLY_ICON) -- хм
local timerGravityHCD = mod:NewCDTimer(150, 35941, nil, nil, nil, 6, nil, CL.DEADLY_ICON) -- хм
local timerAvengerS   = mod:NewCDTimer(22, 308743, nil, nil, nil, 3)

mod:AddBoolOption("SetIconOnMC", true)
mod:AddBoolOption("SayBoom", true)
-- mod:AddBoolOption("SoundMem", true)
mod:AddBoolOption("BoomIcon", true)
mod:AddBoolOption("SayBomb", true)
mod:AddBoolOption("SetIconOnBombTargets", true)
mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("AvengerLatencyCheck", false)
mod:AddBoolOption("Avenger", true)
mod:AddBoolOption("YellOnAvenger", true)

mod.vb.phase = 0
local dominateMindTargets = {}
local dominateMindIcon = 8
local mincControl = {}
local axe = true
local BombTargets = {}
local BombIcons = 8


function mod:AxeIcon()
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid" .. i .. "target") == L.Axe then
			axe = false
			SetRaidTarget("raid" .. i .. "target", 8)
			break
		end
	end
end

function mod:OnCombatStart()
	DBM:FireCustomEvent("DBM_EncounterStart", 19622, "Kael'thas Sunstrider")
	self:SetStage(1)
	dominateMindIcon = 8
	axe = true
	warnPhase:Show(L.WarnPhase1)
	timerNextAdd:Start(L.NamesAdds["Thaladred"])
	table.wipe(dominateMindTargets)
	table.wipe(mincControl)
	if mod:IsDifficulty("heroic25") then
		timerAxeCD:Start(52)
	end
end

function mod:OnCombatEnd(wipe)
	DBM:FireCustomEvent("DBM_EncounterEnd", 19622, "Kael'thas Sunstrider", wipe)
	DBM.RangeCheck:Hide()
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:match(L.TalaTarget) then
		local target = msg:sub(29, -3) or "Unknown"
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
			timerFuriousCD:Cancel()
			timerFurious:Cancel()
			timerAxeCD:Cancel()
			timerAvengerS:Start(34.5)
		elseif msg == L.YellCaper then
			timerRoarCD:Cancel()
			timerAvengerS:Cancel()
			timerShadowCD:Cancel()
			timerJusticeCD:Cancel()
			timerJustice:Cancel()
			timerBombhmCD:Start(41)
			warnNextAdd:Show(L.NamesAdds["Capernian"])
			timerNextAdd:Start(7, L.NamesAdds["Capernian"])
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		elseif msg == L.YellTelon then
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
			timerBombhmCD:Cancel()
			warnConflagrateSoon:Cancel()
			timerConflagrateCD:Cancel()
			warnNextAdd:Show(L.NamesAdds["Telonicus"])
			timerNextAdd:Start(8.4, L.NamesAdds["Telonicus"])
		elseif msg == L.YellPhase3 then
			self:SetStage(3)
			warnPhase:Show(L.WarnPhase3)
			timerPhase4:Start(210)
			timerBombhmCD:Start(39)
			timerAxeCD:Start(28)
			timerAvengerS:Start(28)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		elseif msg == L.YellPhase4 then
			self:SetStage(4)
			warnPhase:Show(L.WarnPhase4)
			timerPhase4:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		elseif msg == L.YellPhase5 then
			self:SetStage(5)
			warnPhase:Show(L.WarnPhase5)
			timerKeltacCD:Start()
			timerVzrivCD:Start(82)
			timerCataCD:Start(92)
			timerGravityHCD:Start(122)
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
			self:SetStage(2)
			warnBombSoon:Cancel()
			timerBombCD:Cancel()
			warnPhase:Show(L.WarnPhase2)
			timerPhase3:Start()
		elseif msg == L.YellPhase3 then
			self:SetStage(3)
			warnPhase:Show(L.WarnPhase3)
			timerPhase4:Start()
			timerRoarCD:Start()
			warnBombSoon:Schedule(10)
			timerBombCD:Start(15)
			DBM.RangeCheck:Show(10)
		elseif msg == L.YellPhase4 then
			self:SetStage(4)
			if self.Options.RemoveShadowResistanceBuffs and mod:IsDifficulty("normal25", "normal10") then
				mod:ScheduleMethod(0.1, "RemoveBuffs")
			end
			warnPhase:Show(L.WarnPhase4)
			timerPhase4:Cancel()
			DBM.RangeCheck:Hide()
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
		elseif msg == L.YellPhase5 then
			self:SetStage(5)
			warnPhase:Show(L.WarnPhase5)
			timerMCCD:Cancel()
			warnMCSoon:Cancel()
			timerGravityCD:Start()
			warnGravitySoon:Schedule(85)

		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(35941) then
		if mod:IsDifficulty("heroic25") then
			timerGravityH:Start()
			timerGravityHCD:Start()
		else
			timerGravity:Start()
			timerGravityCD:Start()
			warnGravitySoon:Schedule(85)
		end
	elseif args:IsSpellID(40636) then
		timerRoarCD:Start()
	elseif args:IsSpellID(37036) then
		warnBombSoon:Schedule(20)
		timerBombCD:Start()
	elseif args:IsSpellID(308742) then --освящение тенью
		timerShadowCD:Start()
		warnShadow:Schedule(0)
	elseif args:IsSpellID(308732) then
		timerFuriousCD:Start()
	elseif args:IsSpellID(308790) then --катаклизм
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
	if args:IsSpellID(37018) then
		warnConflagrate:Show(args.destName)
		warnConflagrateSoon:Cancel()
		warnConflagrateSoon:Schedule(16)
		timerConflagrateCD:Start()
	elseif args:IsSpellID(36723) then
		timerPhoenixCD:Start()
		warnPhoenixSoon:Schedule(55)
	elseif args:IsSpellID(308749) then
		timerBombhmCD:Start()
	elseif args:IsSpellID(308743) then
		timerAvengerS:Start()
		if self.Options.AvengerLatencyCheck then
			self:ScheduleMethod(0.1, "OldAvengerTarget")
		else
			self:ScheduleMethod(0.1, "AvengerTarget")
		end
	elseif args:IsSpellID(36815) then
		timerBarrierCD:Start()
		warnBarrierSoon:Schedule(65)
	elseif args:IsSpellID(36731) then
		timerFlameStrike:Start()
	elseif args:IsSpellID(308734) then -- axe
		timerAxeCD:Start()
	elseif args:IsSpellID(36797) then
		if args:IsPlayer() and self.Options.RemoveWeaponOnMindControl then
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
		self:SetIcon(args.destName, dominateMindIcon, 12)
		dominateMindIcon = dominateMindIcon - 1
	end
end

function mod:AvengerTarget()
	local target = self:GetBossTarget(20060)
	if not target then return end
	if mod:LatencyCheck() then
		self:SendSync("Avenger", target)
	end
end

function mod:OldAvengerTarget()
	local targetname = self:GetBossTarget()
	if not targetname then return end
	warnAvenger:Show(targetname)
	if targetname == UnitName("player") then
		specAvenger:Show(targetname)
		if self.Options.YellOnAvenger then
			SendChatMessage(L.YellAvenger, "Say")
		end
	elseif targetname then
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = CheckInteractDistance(uId, 2)
			local x, y = GetPlayerMapPosition(uId)
			if x == 0 and y == 0 then
				SetMapToCurrentZone()
				x, y = GetPlayerMapPosition(uId)
			end
			if inRange then
				specAvengerNear:Show()
				if self.Options.Avenger then
					DBM.Arrow:ShowRunAway(x, y, 15, 5)
				end
			end
		end
	end
end

function mod:OnSync(msg, target)
	if msg == "Avenger" then
		if not self.Options.AvengerLatencyCheck then
			warnAvenger:Show(target)
			if target == UnitName("player") then
				specAvenger:Show()
				if self.Options.YellOnAvenger then
					SendChatMessage(L.YellAvenger, "Say")
				end
			elseif target then
				local uId = DBM:GetRaidUnitId(target)
				if uId then
					local inRange = CheckInteractDistance(uId, 2)
					local x, y = GetPlayerMapPosition(uId)
					if x == 0 and y == 0 then
						SetMapToCurrentZone()
						x, y = GetPlayerMapPosition(uId)
					end
					if inRange then
						specAvengerNear:Show()
						if self.Options.Avenger then
							DBM.Arrow:ShowRunAway(x, y, 15, 5)
						end
					end
				end
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(308732) then --хм яростный удар
		warnFurious:Show(args.destName, args.amount or 1)
		timerFurious:Start(args.destName)
		timerFuriousCD:Start()
	elseif args:IsSpellID(308741) then --хм Правосудие тенью
		timerJusticeCD:Start()
		warnJustice:Show(args.destName, args.amount or 1)
		timerJustice:Start(args.destName)
	elseif args:IsSpellID(308750) then --бомба
		BombTargets[#BombTargets + 1] = args.destName
		if args:IsPlayer() then
			if self.Options.SayBomb then
				SendChatMessage(format("{череп}|cff71d5ff|Hspell:308750|h[Живая бомба ужаса]|h|r{череп}НА МНЕ{череп}")
					, "SAY")
			end
		else
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId then
				local inRange = CheckInteractDistance(uId, 3)
				local x, y = GetPlayerMapPosition(uId)
				if x == 0 and y == 0 then
					SetMapToCurrentZone()
					x, y = GetPlayerMapPosition(uId)
				end
				if inRange then
					specWarnBomb:Show(args.destName)
				end
			end
		end
		if self.Options.SetIconOnBombTargets then
			self:SetIcon(args.destName, BombIcons)
			BombIcons = BombIcons - 1
		end
		if #BombTargets >= 2 then
			warnBomb:Show(table.concat(BombTargets, "<, >"))
			table.wipe(BombTargets)
			BombIcons = 8
		end
	elseif args:IsSpellID(308756) then --хм искрящий удар
		warnIsc:Show(args.destName, args.amount or 1)
		timerIsc:Start(args.destName)
		timerIscCD:Start()
	elseif args:IsSpellID(308797) then --ВЗРЫВ
		timerVzrivCD:Start()
		timerVzrivCast:Start()
		warnVzriv:Show(args.destName)
		if self.Options.BoomIcon then
			self:SetIcon(args.destName, 8, 5)
		end
		if args:IsPlayer() then
			specwarnVzriv:Show()
			if self.Options.SayBoom then
				SendChatMessage(format("{череп}|cff71d5ff|Hspell:308797|h[Взрыв пустоты]|h|r{череп}НА МНЕ{череп}")
					, "SAY")
			end
		end
	elseif args:IsSpellID(36797) then
		timerMCCD:Start()
		warnMCSoon:Schedule(65)
		mincControl[#mincControl + 1] = args.destName
		if #mincControl >= 3 then
			warnMC:Show(table.concat(mincControl, "<, >"))
			if self.Options.SetIconOnMC then
				table.sort(mincControl, function(v1, v2) return DBM:GetRaidSubgroup(v1) < DBM:GetRaidSubgroup(v2) end)
				local MCIcons = 8
				for _, v in ipairs(mincControl) do
					self:SetIcon(v, MCIcons)
					MCIcons = MCIcons - 1
				end
			end
			table.wipe(mincControl)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(308750) then
		if self.Options.SetIconOnBombTargets then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(36797) then
		self:SetIcon(args.destName, 0)
	end
end

function mod:UNIT_TARGET()
	if axe then
		self:AxeIcon()
	end
end

function mod:RemoveBuffs()
	CancelUnitBuff("player", (GetSpellInfo(48469))) -- Mark of the Wild
	CancelUnitBuff("player", (GetSpellInfo(48470))) -- Gift of the Wild
	CancelUnitBuff("player", (GetSpellInfo(48169))) -- Shadow Protection
	CancelUnitBuff("player", (GetSpellInfo(48170))) -- Prayer of Shadow Protection
end
