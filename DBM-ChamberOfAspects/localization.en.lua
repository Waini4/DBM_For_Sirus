local L
local DBML = DBM_CORE_L
----------------------------
--  The Obsidian Sanctum  --
----------------------------
--  Shadron  --
---------------
L = DBM:GetModLocalization("Shadron")

L:SetGeneralLocalization({
	name = "Shadron"
})

----------------
--  Tenebron  --
----------------
L = DBM:GetModLocalization("Tenebron")

L:SetGeneralLocalization({
	name = "Tenebron"
})

----------------
--  Vesperon  --
----------------
L = DBM:GetModLocalization("Vesperon")

L:SetGeneralLocalization({
	name = "Vesperon"
})

------------------
--  Sartharion  --
------------------
L = DBM:GetModLocalization("Sartharion")

L:SetGeneralLocalization({
	name = "Sartharion"
})

L:SetWarningLocalization({
	WarningTenebron			= "Tenebron incoming",
	WarningShadron			= "Shadron incoming",
	WarningVesperon			= "Vesperon incoming",
	WarningFireWall			= "Fire Wall",
	WarningWhelpsSoon		= "Tenebron Whelps Soon",
	WarningPortalSoon		= "Shadron Portal Soon",
	WarningReflectSoon		= "Vesperon Reflect Soon",
	WarningVesperonPortal	= "Vesperon's portal",
	WarningTenebronPortal	= "Tenebron's portal",
	WarningShadronPortal	= "Shadron's portal"
})

L:SetTimerLocalization({
	TimerTenebron			= "Tenebron arrives",
	TimerShadron			= "Shadron arrives",
	TimerVesperon			= "Vesperon arrives",
	TimerTenebronWhelps		= "Tenebron Whelps",
	TimerShadronPortal		= "Shadron Portal",
	TimerVesperonPortal		= "Vesperon Portal",
	TimerVesperonPortal2	= "Vesperon Portal 2"
})

L:SetOptionLocalization({
	AnnounceFails			= "Post player fails for Fire Wall and Shadow Fissure to raid chat<br/>(requires announce to be enabled and leader/promoted status)",
	TimerTenebron			= "Show timer for Tenebron's arrival",
	TimerShadron			= "Show timer for Shadron's arrival",
	TimerVesperon			= "Show timer for Vesperon's arrival",
	TimerTenebronWhelps		= "Show timer for Tenebron Whelps",
	TimerShadronPortal		= "Show timer for Shadron Portal",
	TimerVesperonPortal		= "Show timer for Vesperon Portal",
	TimerVesperonPortal2	= "Show timer for Vesperon Portal 2",
	WarningFireWall			= "Show special warning for Fire Wall",
	WarningTenebron			= "Announce Tenebron incoming",
	WarningShadron			= "Announce Shadron incoming",
	WarningVesperon			= "Announce Vesperon incoming",
	WarningWhelpsSoon		= "Announce Tenebron Whelps soon",
	WarningPortalSoon		= "Announce Shadron Portal soon",
	WarningReflectSoon		= "Announce Vesperon Reflect soon",
	WarningTenebronPortal	= "Show special warning for Tenebron's portal",
	WarningShadronPortal	= "Show special warning for Shadron's portal",
	WarningVesperonPortal	= "Show special warning for Vesperon's portal"
})

L:SetMiscLocalization({
	Wall			= "The lava surrounding %s churns!",
	Portal			= "%s begins to open a Twilight Portal!",
	NameTenebron	= "Tenebron",
	NameShadron		= "Shadron",
	NameVesperon	= "Vesperon",
	FireWallOn		= "Fire Wall: %s",
	VoidZoneOn		= "Shadow Fissure: %s",
	VoidZones		= "Shadow Fissure fails (this try): %s",
	FireWalls		= "Fire Wall fails (this try): %s"
})

------------------------
--  The Ruby Sanctum  --
------------------------
--  Baltharus the Warborn  --
-----------------------------
L = DBM:GetModLocalization("Baltharus")

L:SetGeneralLocalization({
	name = "Baltharus the Warborn"
})

L:SetWarningLocalization({
	WarningSplitSoon	= "Split soon"
})

L:SetOptionLocalization({
	WarningSplitSoon	= "Show pre-warning for Split"
})

-------------------------
--  Saviana Ragefire  --
-------------------------
L = DBM:GetModLocalization("Saviana")

L:SetGeneralLocalization({
	name = "Saviana Ragefire"
})

--------------------------
--  General Zarithrian  --
--------------------------
L = DBM:GetModLocalization("Zarithrian")

L:SetGeneralLocalization({
	name = "General Zarithrian"
})

L:SetWarningLocalization({
	WarnAdds	= "New adds",
	warnCleaveArmor	= "%s on >%s< (%s)"		-- Cleave Armor on >args.destName< (args.amount)
})

L:SetTimerLocalization({
	TimerAdds	= "New adds",
	AddsArrive	= "Adds arrive in"
})

L:SetOptionLocalization({
	WarnAdds		= "Announce new adds",
	TimerAdds		= "Show timer for new adds",
	AddsArrive		= "Show timer for adds arrival",
	CancelBuff		= "Remove $spell:10278 and $spell:642 if used to remove $spell:74367",
	warnCleaveArmor	= DBM_CORE_L.AUTO_ANNOUNCE_OPTIONS.spell:format(74367)
})

L:SetMiscLocalization({
	SummonMinions	= "Turn them to ash, minions!"
})

-------------------------------------
--  Halion the Twilight Destroyer  --
-------------------------------------
L = DBM:GetModLocalization("Halion")

L:SetGeneralLocalization({
	name = "Halion the Twilight Destroyer"
})

L:SetWarningLocalization({
	TwilightCutterCast	= "Casting Twilight Cutter: 5 sec"
})

L:SetOptionLocalization({
	TwilightCutterCast		= "Show warning when $spell:74769 is being cast",
	AnnounceAlternatePhase	= "Show warnings/timers for phase you aren't in as well",
	SetIconOnConsumption	= "Set icons on $spell:74562 or $spell:74792 targets"--So we can use single functions for both versions of spell.
})

L:SetMiscLocalization({
	Halion					= "Halion",
	PhysicalRealm			= "Physical Realm",
	MeteorCast				= "The heavens burn!",
	Phase2					= "You will find only suffering within the realm of twilight! Enter if you dare!",
	Phase3					= "I am the light and the darkness! Cower, mortals, before the herald of Deathwing!",
	twilightcutter			= "Beware the shadow!", --"The orbiting spheres pulse with dark energy!". Can't use this since on Warmane it triggers twice, 5s prior and on cutter.
	Kill					= "Relish this victory, mortals, for it will be your last. This world will burn with the master's return!"
})

-- Импорус
L = DBM:GetModLocalization("Imporus")

L:SetGeneralLocalization{
	name = "Импорус"
}

L:SetMiscLocalization{
	YellCrash			= "Темпоральная стрела летит в меня!",
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
	BurningTimeSoon				="Скоро каст Лужи",
	RezonansSoon				="Скоро каст Резонанса"
}

L:SetOptionLocalization{
	SetIconOnTemporalBeat			= "Устанавливать метку на цель заклинания $spell:316519",
	YellOnTemporalCrash				= "Кричать, когда в вас летит $spell:316519",
	RezonansSoon 					= "Таймер о скором применении $spell:316523",
	BossHealthFrame					= "Показывать здоровье босса",
	RangeFrame						= "Показывать окно проверки дистанции (10м)",
	BurningTimeSoon 				= "Таймер о скором применении $spell:316526"
}


-- Элонус
L = DBM:GetModLocalization("Elonus")

L:SetGeneralLocalization{
	name = "Элонус"
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
	WarningReplicaSpawned = "Появляется копия Элонуса Исказитель времени!!!",
	WarningReplicaSpawnedSoon = "Скоро появляется копия Элонуса"
}

L:SetOptionLocalization{
	AnnounceReverCasc			= "Объявлять игроков, на кого установлена метка $spell:312208, в рейд чат",
	AnnounceTempCasc			= "Объявить игрока на которого установлена метка $spell:312206, в рейд чат",
	AnnounceErap				= "Объявлять игроков, на кого установлена метка $spell:312204, в рейд чат",
	WarningReplicaSpawned		= "Предупреждение о появлении копии Элонуса",
	RangeFrame					= "Показывать окно проверки дистанции (6м)",
	TempCascIcon 				= DBML.AUTO_ICONS_OPTION_TARGETS:format(312206),
	BossHealthFrame				= "Показывать здоровье босса"
}

L:SetMiscLocalization{
	RevCasc				= "Обратный каскад {rt%d} установлена на %s",
	Erapc				= "Слово силы: Стереть {rt%d} установлена на %s",
	CollapsingStar			= "Копия Элониса",
	IncinerateTarget		= "Щит",
	TempCasc			= "Темпоральный каскад {rt%d} установлен на %s"
}


--Мурозонд
L = DBM:GetModLocalization("Murozond")

L:SetGeneralLocalization{
	name           = "Мурозонд"
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
	PrePhase = "Скоро Перефаза",
	Cernsfera = "Лови - Черную Сферу",
	BelayaSfera = "Лови - Белую Сферу",
	Perebejkai = "Перебегите"
}

L:SetOptionLocalization{
	BossHealthFrame		= "Показывать здоровье босса",
	AnnounceFails		= "Объявлять игроков, попавших под $spell:317255, в рейд-чат\n(требуются права лидера или помощника)",
	GibVr				= "Таймер каста $spell:317258 (Для хилов)",
	AnnounceFear		= "Анонс в белый чат фира (для миликов)"
}

L:SetMiscLocalization{
	FearOn	= "Фир на: %s",
	Fear		= "Кто попал под Фир (в этом бою): %s"
}

