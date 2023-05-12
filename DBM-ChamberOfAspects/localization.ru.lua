if GetLocale() ~= "ruRU" then return end

local L
local DBML = DBM_CORE_L
----------------------------
--  The Obsidian Sanctum  --
----------------------------
--  Shadron  --
---------------
L = DBM:GetModLocalization("Shadron")

L:SetGeneralLocalization({
	name = "Шадрон"
})

----------------
--  Tenebron  --
----------------
L = DBM:GetModLocalization("Tenebron")

L:SetGeneralLocalization({
	name = "Тенеброн"
})

----------------
--  Vesperon  --
----------------
L = DBM:GetModLocalization("Vesperon")

L:SetGeneralLocalization({
	name = "Весперон"
})

------------------
--  Sartharion  --
------------------
L = DBM:GetModLocalization("Sartharion")

L:SetGeneralLocalization({
	name = "Сартарион"
})

L:SetWarningLocalization({
	WarningTenebron       = "Прибытие Тенеброна",
	WarningShadron        = "Прибытие Шадрона",
	WarningVesperon       = "Прибытие Весперона",
	WarningFireWall       = "Огненная стена",
	WarningWhelpsSoon     = "Скоро дракончики тенеброна",
	WarningPortalSoon     = "Скоро портал Шадрон",
	WarningReflectSoon    = "Весперон: Скоро отражение",
	WarningVesperonPortal = "Портал Весперона",
	WarningTenebronPortal = "Портал Тенеброна",
	WarningShadronPortal  = "Портал Шадрона"
})

L:SetTimerLocalization({
	TimerTenebron        = "Прибытие Тенеброна",
	TimerShadron         = "Прибытие Шадрона",
	TimerVesperon        = "Прибытие Весперона",
	TimerTenebronWhelps  = "Тенебронские дракончики",
	TimerShadronPortal   = "Портал Шадрона",
	TimerVesperonPortal  = "Портал Весперона",
	TimerVesperonPortal2 = "Портал Весперона 2"
})

L:SetOptionLocalization({
	AnnounceFails         =
	"Объявлять игроков, потерпевших неудачу в Огненной стене и Расщелине тьмы<br/>(требуются права лидера или помощника)",
	TimerTenebron         = "Отсчет времени до прибытия Тенеброна",
	TimerShadron          = "Отсчет времени до прибытия Шадрона",
	TimerVesperon         = "Отсчет времени до прибытия Весперона",
	TimerTenebronWhelps   = "Показать таймер для тенебронских дракончиков",
	TimerShadronPortal    = "Показать таймер для портала Шадрона",
	TimerVesperonPortal   = "Показать таймер для портала Весперон",
	TimerVesperonPortal2  = "Показать таймер для портала Весперон 2",
	WarningFireWall       = "Cпец-предупреждение для Огненной стены",
	WarningTenebron       = "Объявлять прибытие Тенеброна",
	WarningShadron        = "Объявлять прибытие Шадрона",
	WarningVesperon       = "Объявлять прибытие Весперона",
	WarningWhelpsSoon     = "Скоро анонсируйте тенебронских дракончиков",
	WarningPortalSoon     = "Анонсируйте портал Шадрон в ближайшее время",
	WarningReflectSoon    = "Анонсировать Весперон, размышлять в ближайшее время",
	WarningTenebronPortal = "Cпец-предупреждение для порталов Тенеброна",
	WarningShadronPortal  = "Cпец-предупреждение для порталов Шадрона",
	WarningVesperonPortal = "Cпец-предупреждение для порталов Весперона"
})

L:SetMiscLocalization({
	Wall         = "Лава вокруг %s начинает бурлить!",
	Portal       = "%s открывает сумрачный портал!",
	NameTenebron = "Тенеброн",
	NameShadron  = "Шадрон",
	NameVesperon = "Весперон",
	FireWallOn   = "Огненная стена: %s",
	VoidZoneOn   = "Расщелина тьмы: %s",
	VoidZones    = "Потерпели неудачу в Расщелине тьмы (за эту попытку): %s",
	FireWalls    = "Потерпели неудачу в Огненной стене (за эту попытку): %s"
})

------------------------
--  The Ruby Sanctum  --
------------------------
--  Baltharus the Warborn  --
-----------------------------
L = DBM:GetModLocalization("Baltharus")

L:SetGeneralLocalization({
	name = "Балтар Рожденный в Битве"
})

L:SetWarningLocalization({
	WarningSplitSoon = "Скоро разделение"
})

L:SetOptionLocalization({
	WarningSplitSoon = "Предупреждать заранее о разделении"
})

-------------------------
--  Saviana Ragefire  --
-------------------------
L = DBM:GetModLocalization("Saviana")

L:SetGeneralLocalization({
	name = "Савиана Огненная Пропасть"
})

--------------------------
--  General Zarithrian  --
--------------------------
L = DBM:GetModLocalization("Zarithrian")

L:SetGeneralLocalization({
	name = "Генерал Заритриан"
})

L:SetWarningLocalization({
	WarnAdds = "Новые помощники",
	warnCleaveArmor = "%s на |3-5(>%s<) (%s)" -- Cleave Armor on >args.destName< (args.amount)
})

L:SetTimerLocalization({
	TimerAdds = "Новые помощники",
	AddsArrive = "Прибытие помощников"
})

L:SetOptionLocalization({
	WarnAdds   = "Объявлять новых помощников",
	TimerAdds  = "Отсчет времени до новых помощников",
	CancelBuff = "Удалить $spell:10278 и $spell:642, если используется для удаления $spell:74367",
	AddsArrive = "Отсчет времени до прибытия помощников"
})

L:SetMiscLocalization({
	SummonMinions = "Слуги! Обратите их в пепел!"
})

-------------------------------------
--  Halion the Twilight Destroyer  --
-------------------------------------
L = DBM:GetModLocalization("Halion")

L:SetGeneralLocalization({
	name = "Халион Сумеречный Разрушитель"
})

L:SetWarningLocalization({
	WarnPhase2Soon     = "Скоро фаза 2",
	WarnPhase3Soon     = "Скоро фаза 3",
	TwilightCutterCast = "Применение заклинания Лезвие сумерек: 5 сек"
})

L:SetOptionLocalization({
	WarnPhase2Soon         = "Предупреждать заранее о фазе 2 (на ~79%)",
	WarnPhase3Soon         = "Предупреждать заранее о фазе 3 (на ~54%)",
	TwilightCutterCast     = "Предупреждать о применении заклинания $spell:77844",
	AnnounceAlternatePhase = "Показывать предупреждения и таймеры для обоих миров",
	SoundOnConsumption     = "Звуковой сигнал при $spell:74562 и $spell:74792", --We use localized text for these functions
	SetIconOnConsumption   = "Устанавливать метки на цели заклинаний $spell:74562 и\n$spell:74792", --So we can use single functions for both versions of spell.
	YellOnConsumption      = "Кричать, когда $spell:74562 или $spell:74792 на вас",
	WhisperOnConsumption   = "Шепот целям заклинаний $spell:74562 и $spell:74792"
})

L:SetMiscLocalization({
	NormalHalion       = "Физический Халион",
	TwilightHalion     = "Сумеречный Халион",
	MeteorCast         = "Небеса в огне!",
	Phase2             = "В мире сумерек вы найдете лишь страдания! Входите, если посмеете!",
	Phase3             = "Я есть свет и я есть тьма! Трепещите, ничтожные, перед посланником Смертокрыла!",
	twilightcutter     = "Во вращающихся сферах пульсирует темная энергия!",
	YellCombustion     = "Пылающий огонь на мне!",
	WhisperCombustion  = "Пылающий огонь на вас! Бегите к стене!",
	YellConsumption    = "Пожирание души на мне!",
	WhisperConsumption = "Пожирание души на вас! Бегите к стене!",
	Kill               =
	"Это ваша последняя победа. Насладитесь сполна ее вкусом. Ибо когда вернется мой господин, этот мир сгинет в огне!"
})
-- Импорус
L = DBM:GetModLocalization("Imporus")

L:SetGeneralLocalization {
	name = "Импорус (1 босс)"
}

L:SetMiscLocalization {
	YellCrash = "Темпоральная стрела летит в меня!",
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
	BurningTimeSoon = "Скоро каст Лужи",
	RezonansSoon    = "Скоро каст Резонанса"
}

L:SetOptionLocalization {
	SetIconOnTemporalBeat = "Устанавливать метку на цель заклинания $spell:316519",
	YellOnTemporalCrash   = "Кричать, когда в вас летит $spell:316519",
	RezonansSoon          = "Таймер о скором применении $spell:316523",
	BossHealthFrame       = "Показывать здоровье босса",
	RangeFrame            = "Показывать окно проверки дистанции (10м)",
	BurningTimeSoon       = "Таймер о скором применении $spell:316526"
}


-- Элонус
L = DBM:GetModLocalization("Elonus")

L:SetGeneralLocalization {
	name = "Элонус (2 босс)"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
	WarningReplicaSpawned = "Появляется копия Элонуса Исказитель времени!!!",
	WarningReplicaSpawnedSoon = "Скоро появляется копия Элонуса"
}

L:SetOptionLocalization {
	AnnounceReverCasc     = "Объявлять игроков, на кого установлена метка $spell:312208, в рейд чат",
	AnnounceTempCasc      = "Объявить игрока на которого установлена метка $spell:312206, в рейд чат",
	AnnounceErap          = "Объявлять игроков, на кого установлена метка $spell:312204, в рейд чат",
	WarningReplicaSpawned = "Предупреждение о появлении копии Элонуса",
	RangeFrame            = "Показывать окно проверки дистанции (8м)",
	TempCascIcon          = DBML.AUTO_ICONS_OPTION_TARGETS:format(312206),
	BossShieldFrame       = "Щит Босса и его копии."
}

L:SetMiscLocalization {
	RevCasc          = "Обратный каскад {rt%d} установлена на %s",
	Erapc            = "Слово силы: Стереть {rt%d} установлена на %s",
	CollapsingStar   = "Копия Элониса",
	IncinerateTarget = "Щит",
	TempCasc         = "Темпоральный каскад {rt%d} установлен на %s"
}


--Мурозонд
L = DBM:GetModLocalization("Murozond")

L:SetGeneralLocalization {
	name = "Мурозонд"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
	PrePhase         = "Скоро Перефаза",
	Cernsfera        = "Лови - Черную Сферу",
	BelayaSfera      = "Лови - Белую Сферу",
	EndofTimeSoonEnd = "Конец времени закончится через 5 секунд",
	Perebejkai       = "Перебегите"

}

L:SetOptionLocalization {
	BossHealthFrame   = "Показывать здоровье босса",
	AnnounceFails     = "Объявлять игроков, попавших под $spell:317255, в рейд-чат\n(требуются права лидера или помощника)",
	GibVr             = "Таймер каста $spell:317258 (Для хилов)",
	AnnounceFear      = "Анонс в белый чат фира (для миликов)",
	AnnounceOrb       = "Предупреждение 'лови сферу'",
	Cernsfera         = "Предупреждение о Ловле Черной Сферы",
	BelayaSfera       = "Предупреждение о Ловле Белой Сферы",
	EndofTimeSoonEnd  = "Предупреждать заранее о $spell:313122",
	specwarnPerebejka = "Предупреждение Перебегите"
}

L:SetMiscLocalization {
	FearOn = "Фир на: %s",
	Fear   = "Кто попал под Фир (в этом бою): %s",
	Ref1   = "Следите за своими чарами..",
	Ref2   = "То что меня не убивает.. вполне может убить вас.",
	Ref3   = "Успеете ли среагировать?.."
}
