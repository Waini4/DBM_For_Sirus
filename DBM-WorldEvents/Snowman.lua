local mod = DBM:NewMod("Snowman", "DBM-WorldEvents")
local L   = mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")
mod:SetCreatureID(81373, 81402, 81405)

mod:RegisterCombat("combat", 15866, 15869, 15837)
--mod:RegisterKill("say", L.SayCombatEnd)

mod:RegisterEvents(
    "SPELL_AURA_APPLIED 311798 321125 321126",
    "SPELL_AURA_REMOVED 311798 321125 321126",
    "SPELL_CAST_SUCCESS 311800",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_BG_SYSTEM_NEUTRAL",
    "UNIT_DIED",
    "UNIT_HEALTH"
)

local warnBall        = mod:NewTargetAnnounce(311877, 3)
local warnShild       = mod:NewStackAnnounce(311798, 3)
local warnOrbDied     = mod:NewAnnounce("OrbDiedCount", 3)
local warnOrbSoon     = mod:NewAnnounce("Скоро появятся Ледяные духи!!!!!", 2)

local specWarnGuardSw = mod:NewSpecialWarningSwitch(302946, nil, nil, nil, 1, 2)
local specWarnOrbSw   = mod:NewSpecialWarningSwitch(52954, nil, nil, nil, 1, 2)
local specWarnBallYou = mod:NewSpecialWarningYou(311877, nil, nil, nil, 4, 2)
local yellBall        = mod:NewYell(311877)

local timerBallCD     = mod:NewCDTimer(60, 311877, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1)

mod:AddSetIconOption("BallIcon", 311877, true, false, { 7 })
mod:AddBoolOption("PartySay", false)
local currentWave
local History = false
local Hard = false
local shit = false
local Sneg = 5
local Orbs = 0
local OrbsStack = 0

local warnedBalls = {
    Soon = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
}

local SnowConfig = {
    Normal = {
        [18] = { 93, 90 },
        [19] = { 93, 90, 73, 70, 43, 40 },
        [20] = { 93, 90, 73, 70, 43, 40 },
        [21] = { 93, 90, 73, 70, 43, 40 },
        [22] = { 93, 90, 73, 70, 43, 40 },
        [23] = { 93, 90, 73, 70, 43, 40 },
        [24] = { 93, 90, 73, 70, 43, 40 },
        [25] = { 93, 90, 73, 70, 43, 40, 23, 20, 13, 10 },
    },
    Hard = {
        [1] = { 63, 60, 23, 20 },
        [2] = { 93, 90, 63, 60, 23, 20 },
        [3] = { 93, 90, 63, 60, 23, 20 },
        [4] = { 93, 90, 63, 60, 53, 50, 23, 20, 13, 10 },
        [5] = { 93, 90, 73, 70, 63, 60, 53, 50, 23, 20, 13, 10 },
        [6] = { 93, 90, 73, 70, 63, 60, 53, 50, 23, 20, 13, 10 },
    }
}

local function Stages(self)
    if not Hard and (currentWave >= 20 or (currentWave > 6 and currentWave < 9)) then
        timerBallCD:Start(30)
    elseif Hard then
        timerBallCD:Start(30)
    end
end

function mod:SPELL_AURA_APPLIED(args)
    if args:IsSpellID(311798) then -- 311800
        shit = true
        if History then
            Sneg = 25
        elseif not Hard and not History then
            if currentWave < 20 then
                Sneg = 5
            else
                Sneg = 10
            end
            Sneg = 5
        elseif Hard then
            Sneg = 25
        end
        warnShild:Show(L.name, Sneg)
    end
end

function mod:SPELL_AURA_REMOVED(args)
    if args:IsSpellID(311798) then
        shit = false
    end
end

function mod:CHAT_MSG_BG_SYSTEM_NEUTRAL(msg)
    if msg == L.End or msg:find(L.End) then
        Hard = false
        History = false
        timerBallCD:Stop()
    end
end

function mod:SPELL_CAST_SUCCESS(args)
    if args:IsSpellID(311800) then
        if shit then
            Sneg = Sneg - 1
            warnShild:Show(L.name, Sneg)
        end
    end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
    if msg:match(L.Ball) and target then
        target = DBM:GetUnitFullName(target)
        if target == UnitName("player") then
            specWarnBallYou:Show()
            yellBall:Yell()
        else
            warnBall:Show(target)
        end
        if Hard then
            local Timer = 61 - currentWave
            timerBallCD:Start(Timer)
        else
            timerBallCD:Start()
        end
    elseif msg == L.Guard or msg:find(L.Guard) then
        specWarnGuardSw:Show()
    end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
    if msg == L.Pull or msg:find(L.Pull) or msg == L.Pull2 then
        local text = select(3, GetWorldStateUIInfo(4))
        if not text then return end
        timerBallCD:Stop()
        Orbs = 0
        OrbsStack = 0
        for i in pairs(warnedBalls) do
            warnedBalls[i] = false
        end
        currentWave = tonumber(text:match(L.WaveLight)) or 0
        self:Unschedule(Stages)
        self:Schedule(0.1, Stages, self)
    end
end

function mod:UNIT_DIED(args)
    if self:GetCIDFromGUID(args.destGUID) == 15846 then
        if not History then
            Orbs = Orbs - 1
            warnOrbDied:Show(Orbs)
            OrbsStack = Orbs
        end
    end
end

function mod:UNIT_HEALTH(uId)
    if self:GetUnitCreatureId(uId) ~= 15866 and self:GetUnitCreatureId(uId) ~= 15869 and self:GetUnitCreatureId(uId) ~= 15837 then return end
    if self:GetUnitCreatureId(uId) == 15869 then
        Hard = true
        History = false
    elseif self:GetUnitCreatureId(uId) == 15866 then
        Hard = false
        History = false
    elseif self:GetUnitCreatureId(uId) == 15837 then
        History = true
    end

    local Mode = Hard and SnowConfig.Hard[currentWave] or SnowConfig.Normal[currentWave]
    if not Mode then return end

    local bossHP = DBM:GetBossHPByUnitID(uId)
    if not bossHP then return end

    for i, v in ipairs(Mode) do
        if not warnedBalls[i] and bossHP <= v then
            warnedBalls[i] = true
            if i % 2 == 1 then
                warnedBalls.Soon = true
                warnOrbSoon:Show()
            else
                if self.Options.PartySay then
                    SendChatMessage("ДУХИ убейте", "PARTY")
                end
                Orbs = 5 + OrbsStack
                warnedBalls.Soon = false
                specWarnOrbSw:Show()
            end
            break
        end
    end
end
