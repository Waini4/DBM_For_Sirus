local mod = DBM:NewMod("Snowman", "DBM-WorldEvents")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(81373, 81402, 81405)

mod:RegisterCombat("combat", 81373, 81402, 81405)
--mod:RegisterKill("say", L.SayCombatEnd)

mod:RegisterEvents(
    "SPELL_AURA_APPLIED 311798 321125 321126",
    "SPELL_AURA_REMOVED 311798 321125 321126",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_SAY"
)

local warnBall        = mod:NewTargetAnnounce(311877, 3)
local warnShild       = mod:NewStackAnnounce(311798, 3)

local specWarnGuardSw = mod:NewSpecialWarningSwitch(302946, nil, nil, nil, 1, 2)
local specWarnBallYou = mod:NewSpecialWarningYou(311877, nil, nil, nil, 4, 2)
local yellBall        = mod:NewYell(311877)


local timerBallCD = mod:NewCDTimer(60, 311877, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)

mod:AddSetIconOption("BallIcon", 311877, true, false, { 7 })
local currentWave
local Hard = false


function mod:SPELL_AURA_APPLIED(args)
    if args:IsSpellID(311798) then
        local amount = args.amount or 1
        warnShild:Show(L.name, amount)
    elseif args:IsSpellID(321125, 321126) then
        Hard = true
    end
end

function mod:SPELL_AURA_REMOVED(args)
    if args:IsSpellID(321125, 321126) then
        Hard = false
    end
end

local function Stages(self)
    if not Hard and (currentWave >= 20 or (currentWave > 6 and currentWave < 9)) then
        timerBallCD:Start(30)
    elseif Hard then
        timerBallCD:Start(30)
    end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
    if msg:match(L.Ball) and target then -- No combatlog event for head spawning, Emote works iffy(head doesn't emote First time, only 2nd and forward)
        target = DBM:GetUnitFullName(target)
        if target == UnitName("player") then
            specWarnBallYou:Show()
            yellBall:Yell()
        else
            warnBall:Show(target)
        end
        if self.Options.BallIcon then
            -- self:ScanForMobs(target, 1, 7, 1, 0.1, 20, "BallIcon")
            self:SetIcon(target, 7, 5)
        end
        timerBallCD:Start()
    elseif msg == L.Guard or msg:find(L.Guard) then
        specWarnGuardSw:Show()
    end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
    if msg == L.Pull or msg:find(L.Pull) or msg == L.Pull2 then --msg:match(L.HealSham or L.HealPrist)
        local text = select(3, GetWorldStateUIInfo(4))
        if not text then return end
        timerBallCD:Stop()
        currentWave = text:match(L.WaveLight)
        if not currentWave then
            currentWave = 0
        end
        currentWave = tonumber(currentWave)
        self:Unschedule(Stages)
        self:Schedule(0.1, Stages, self)
    end
end
