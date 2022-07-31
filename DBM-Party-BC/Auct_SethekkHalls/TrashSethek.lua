local mod	= DBM:NewMod("TrashSethek", "DBM-Party-BC", 9, 252)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220518110528")

mod:RegisterEventsInCombat(
	"SPELL_SUMMON 32764",
    "SPELL_CAST_SUCCESS 35120"
)

local warnControl        = mod:NewTargetAnnounce(35120, 2)

mod:AddSetIconOption("TotemIcons", 32764, true, true, { 7, 8})
mod:AddBoolOption("WarnControll")

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(32764) then --SPELL_SUMMON:0xF13000479700007F:Затерянный во времени наблюдатель:0xF130004F7700009E:Тотем подчинения:32764:Вызов подчиняющего тотема:nil:nil:", -- [520]
		if self.Options.TotemIcons then
				self:ScanForMobs(args.destGUID, 0, 8, 1, 0.1, 20, "TotemIcons")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args) -- SPELL_CAST_SUCCESS:0xF130004F7700009E:Тотем подчинения:0x000000000017F2A3:Tekir:35120:Подчинение:nil:nil:", -- [521]
	if args:IsSpellID(35120) then
        if self.Options.WarnControll then
            warnControl:Show(args.destName)
        end
	end
end

