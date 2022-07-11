if GetLocale() ~= "ruRU" then return end

local L

-----------------------
--  Flame Leviathan  --
-----------------------
L = DBM:GetModLocalization("FlameLeviathan")

L:SetGeneralLocalization({
	name = "Огненный Левиафан"
})

L:SetWarningLocalization({
	PursueWarn           = "Преследуется >%s<",
	warnNextPursueSoon   = "Смена цели через 5 секунд",
	SpecialPursueWarnYou = "Вас преследуют - бегите",
	warnWardofLife       = "Призыв Защитника жизни"
})

L:SetOptionLocalization({
	SpecialPursueWarnYou = "Спец-предупреждение, когда на вас $spell:62374",
	PursueWarn           = "Объявлять цели заклинания $spell:62374",
	warnNextPursueSoon   = "Предупреждать заранее о следующем $spell:62374",
	warnWardofLife       = "Спец-предупреждение для призыва Защитника жизни"
})

L:SetMiscLocalization({
	YellPull = "Обнаружены противники. Запуск протокола оценки угрозы. Главная цель выявлена. Повторный анализ через 30 секунд.",
	Emote    = "%%s наводится на (%S+)%."
})

--------------------------------
--  Ignis the Furnace Master  --
--------------------------------
L = DBM:GetModLocalization("Ignis the Furnace Master")

L:SetGeneralLocalization({
	name = "Повелитель Горнов Игнис"
})

------------------
--  Razorscale  --
------------------
L = DBM:GetModLocalization("Razorscale")

L:SetGeneralLocalization({
	name = "Острокрылая"
})

L:SetWarningLocalization({
	warnTurretsReadySoon = "Гарпунные пушки будут собраны через 20 секунд",
	warnTurretsReady     = "Гарпунные пушки собраны"
})

L:SetTimerLocalization({
	timerTurret1 = "Гарпунная пушка 1",
	timerTurret2 = "Гарпунная пушка 2",
	timerTurret3 = "Гарпунная пушка 3",
	timerTurret4 = "Гарпунная пушка 4",
	timerGrounded = "На земле"
})

L:SetOptionLocalization({
	warnTurretsReadySoon = "Пред-предупреждение для пушек",
	warnTurretsReady     = "Предупреждение для пушек",
	timerTurret1         = "Отсчет времени до пушки 1",
	timerTurret2         = "Отсчет времени до пушки 2",
	timerTurret3         = "Отсчет времени до пушки 3 (25 чел.)",
	timerTurret4         = "Отсчет времени до пушки 4 (25 чел.)",
	timerGrounded        = "Отсчет времени для наземной фазы"
})

L:SetMiscLocalization({
	YellAir     = "Дайте время подготовить пушки.",
	YellAir2    = "Огонь прекратился! Надо починить пушки!",
	YellGround  = "Быстрее! Сейчас она снова взлетит!",
	EmotePhase2 = "%%s обессилела и больше не может летать!"
})

----------------------------
--  XT-002 Deconstructor  --
----------------------------
L = DBM:GetModLocalization("XT002")

L:SetGeneralLocalization {
	name = "Разрушитель XT-002"
}

L:SetMiscLocalization {
	YellPull = "Новые игрушки ? Для меня ? Обещаю, в этот раз я их не поломаю!"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
}

L:SetOptionLocalization {
	SetIconOnLightBombTarget   = "Устанавливать метку на цель заклинания $spell:312941",
	SetIconOnGravityBombTarget = "Устанавливать метку на цель заклинания $spell:312943",
	YellOnLightBomb            = "Кричать, когда на вас $spell:312941",
	YellOnGravityBomb          = "Кричать, когда на вас $spell:312943",
}

--------------------
--  Iron Council  --
--------------------
L = DBM:GetModLocalization("IronCouncil")

L:SetGeneralLocalization({
	name = "Железное собрание"
})

L:SetOptionLocalization({
	AlwaysWarnOnOverload       = "Всегда предупреждать при $spell:63481<br/>(иначе, только когда босс в цели)",
	PlaySoundLightningTendrils = "Звуковой сигнал при $spell:312786",
	SetIconOnOverwhelmingPower = "Устанавливать метку на цель заклинания $spell:312772",
	SetIconOnStaticDisruption  = "Устанавливать метку на цель заклинания $spell:312770",
	PlaySoundOnOverload        = "Звуковой сигнал при $spell:312782",
	PlaySoundDeathRune         = "Звуковой сигнал при $spell:312777"
})

L:SetMiscLocalization({
	Steelbreaker       = "Сталелом",
	RunemasterMolgeim  = "Мастер рун Молгейм",
	StormcallerBrundir = "Буревестник Брундир"
	--	YellPull1			= "Кто бы вы ни были – жалкие бродяги или великие герои... Вы всего лишь смертные!",
	--	YellPull2			= "Я буду спокоен, лишь когда окончательно истреблю вас.",
	--	YellPull3			= "Чужаки! Вам не одолеть Железное Собрание!",
	--	YellRuneOfDeath		= "Расшифруйте вот это!",
	--	YellRunemasterMolgeimDied = "И что вам дало мое поражение? Вы все так же обречены, смертные.",
	--	YellRunemasterMolgeimDied2 = "Наследие бурь не умрет вместе со мной.",
	--	YellStormcallerBrundirDied = "Никто не превзойдет силу шторма.",
	--	YellStormcallerBrundirDied2 = "Вас ждет бездна безумия!",
	--	YellSteelbreakerDied = "Мое поражение лишь приблизит вашу погибель.",
	--	YellSteelbreakerDied2 = "Не может быть!"
})

----------------------------
--  Algalon the Observer  --
----------------------------
L = DBM:GetModLocalization("Algalon")

L:SetGeneralLocalization {
	name = "Алгалон Наблюдатель"
}

L:SetTimerLocalization {
	NextCollapsingStar      = "Вспыхивающая звезда",
	PossibleNextCosmicSmash = "Кара небесная",
	TimerCombatStart        = "Битва начнется через"
}

L:SetWarningLocalization {
	WarningPhasePunch  = "Фазовый удар на |3-5(>%s<) - cтак %d",
	WarningCosmicSmash = "Кара небесная - взрыв через 4 секунды",
	WarnPhase2Soon     = "Скоро фаза 2",
	warnStarLow        = "У Вспыхивающей звезды мало здоровья"
}

L:SetOptionLocalization {
	WarningPhasePunch       = "Объявлять цели заклинания Фазовый удар",
	NextCollapsingStar      = "Отсчет времени до появления Вспыхивающей звезды",
	WarningCosmicSmash      = "Предупреждение для Кары небесной",
	PossibleNextCosmicSmash = "Отсчет времени до следующей Кары небесной",
	TimerCombatStart        = "Отсчет времени до начала боя",
	WarnPhase2Soon          = "Предупреждать заранее о фазе 2 (на ~23%)",
	warnStarLow             = "Спец-предупреждение, когда у Вспыхивающей звезды мало здоровья (на ~25%)"
}

L:SetMiscLocalization {
	YellPull             = "Ваши действия нелогичны. Все возможные исходы этой схватки просчитаны. Пантеон получит сообщение от Наблюдателя в любом случае.",
	YellKill             = "Я видел миры, охваченные пламенем Творцов. Их жители гибли, не успев издать ни звука. Я был свидетелем того, как галактики рождались и умирали в мгновение ока. И все время я оставался холодным... и безразличным. Я. Не чувствовал. Ничего. Триллионы загубленных судеб. Неужели все они были подобны вам? Неужели все они так же любили жизнь?",
	Emote_CollapsingStar = "%s призывает вспыхивающие звезды!",
	CollapsingStar       = "Вспыхивающая звезда",
	Phase2               = "Узрите чудо созидания!",
	PullCheck            = "Алгалон подаст сигнал бедствия через (%d+) мин."
}

----------------
--  Kologarn  --
----------------
L = DBM:GetModLocalization("Kologarn")

L:SetGeneralLocalization({
	name = "Кологарн"
})

L:SetTimerLocalization({
	timerLeftArm        = "Возрождение левой руки",
	timerRightArm       = "Возрождение правой руки",
	achievementDisarmed = "Обезоружен"
})

L:SetOptionLocalization({
	timerLeftArm        = "Отсчет времени до Возрождения левой руки",
	timerRightArm       = "Отсчет времени до Возрождения правой руки",
	achievementDisarmed = "Отсчет времени для достижения Обезоружен"
})

L:SetMiscLocalization({
	--	Yell_Trigger_arm_left	= "Царапина...",
	--	Yell_Trigger_arm_right	= "Всего лишь плоть!",
	--	YellEncounterStart		= "Вам не пройти!",
	--	YellLeftArmDies			= "Царапина...",
	--	YellRightArmDies		= "Всего лишь плоть!",
	Health_Body      = "Кологарн",
	Health_Right_Arm = "Правая рука",
	Health_Left_Arm  = "Левая рука",
	FocusedEyebeam   = "%s устремляет на вас свой взгляд!"
})

---------------
--  Auriaya  --
---------------
L = DBM:GetModLocalization("Auriaya")

L:SetGeneralLocalization({
	name = "Ауриайа"
})

L:SetWarningLocalization({
	WarnCatDied    = "Дикий эащитник погибает (осталось %d жизней)",
	WarnCatDiedOne = "Дикий эащитник погибает (осталась 1 жизнь)"
})

L:SetTimerLocalization({
	timerDefender = "Возрождение Дикого защитника"
})

L:SetOptionLocalization({
	WarnCatDied    = "Предупреждение, когда Дикий защитник погибает",
	WarnCatDiedOne = "Предупреждение, когда у Дикого защитника остается 1 жизнь",
	timerDefender  = "Отсчет времени до возрождения Дикого защитника"
})

L:SetMiscLocalization({
	Defender = "Дикий эащитник (%d)",
	YellPull = "Вы зря сюда заявились!"
})

-------------
--  Hodir  --
-------------
L = DBM:GetModLocalization("Hodir")

L:SetGeneralLocalization({
	name = "Ходир"
})

L:SetMiscLocalization({
	YellKill = "Наконец-то я... свободен от его оков…"
})

--------------
--  Thorim  --
--------------
L = DBM:GetModLocalization("Thorim")

L:SetGeneralLocalization({
	name = "Торим"
})

L:SetTimerLocalization({
	TimerHardmode = "Сложный режим"
})

L:SetOptionLocalization({
	TimerHardmode = "Отсчет времени для сложного режима",
	RangeFrame    = "Показывать окно проверки дистанции",
	AnnounceFails = "Объявлять игроков, попавших под $spell:62017, в рейд-чат<br/>(требуются права лидера или помощника)"
})

L:SetMiscLocalization({
	YellPhase1 = "Незваные гости! Вы заплатите за то, что посмели вмешаться... Погодите, вы...",
	YellPhase2 = "Бесстыжие выскочки, вы решили бросить вызов мне лично? Я сокрушу вас всех!",
	YellKill   = "Придержите мечи! Я сдаюсь.",
	ChargeOn   = "Разряд молнии: %s",
	Charge     = "Попали под Разряд молнии (в этом бою): %s"
})

-------------
--  Freya  --
-------------
L = DBM:GetModLocalization("Freya")

L:SetGeneralLocalization({
	name = "Фрейя"
})

L:SetWarningLocalization({
	WarnSimulKill = "Первый помощник погиб - воскрешение через ~12 сек.",
	WarnLifebinderSoon = "Скоро появится Дар Эонар!",
	EonarsGift = "Смена цели - переключитесь на Дар Эонара"
})

L:SetTimerLocalization({
	TimerSimulKill = "Воскрешение"
})

L:SetOptionLocalization({
	WarnSimulKill      = "Объявлять, когда первый монстр погибает",
	TimerSimulKill     = "Отсчет времени до воскрешения монстров",
	MobsHealthFrame    = "Показывать хп мобов",
	WarnLifebinderSoon = "Скоро древо?" -- TODO
})

L:SetMiscLocalization({
	SpawnYell         = "Помогите мне, дети мои!",
	WaterSpirit       = "Древний дух воды",
	Snaplasher        = "Хватоплет",
	StormLasher       = "Грозовой плеточник",
	YellKill          = "Он больше не властен надо мной. Мой взор снова ясен. Благодарю вас, герои.",
	YellAdds1         = "Эонар, твоей прислужнице нужна помощь!",
	YellAdds2         = "Вас захлестнет сила стихий!",
	EmoteLGift        = "начинает расти!", -- |cFF00FFFFДар Хранительницы жизни|r начинает расти!
	TrashRespawnTimer = "Возрождение монстров"


})

----------------------
--  Freya's Elders  --
----------------------
L = DBM:GetModLocalization("Freya_Elders")

L:SetGeneralLocalization({
	name = "Древни Фрейи"
})

L:SetOptionLocalization({
	TrashRespawnTimer = "Отсчет времени до возрождения монстров"
})

L:SetMiscLocalization({
	TrashRespawnTimer = "Возрождение монстров",
})

---------------
--  Mimiron  --
---------------
L = DBM:GetModLocalization("Mimiron")

L:SetGeneralLocalization {
	name = "Мимирон"
}

L:SetWarningLocalization {
	MagneticCore      = "Магнитное ядро у |3-1(>%s<)",
	WarningShockBlast = "Шоковый удар - бегите",
	WarningSpinUp     = "Обстрел - бегите",
	WarnBombSpawn     = "Бомбот"
}

L:SetTimerLocalization {
	TimerHardmode = "Сложный режим - Самоуничтожение",
	TimeToPhase2 = "Фаза 2",
	TimeToPhase3 = "Фаза 3",
	TimeToPhase4 = "Фаза 4"
}

L:SetOptionLocalization {
	YellOnblastWarn       = "Кричать, когда на вас $spell:312790",
	YellOnshellWarn       = "Кричать, когда на вас $spell:312435",
	TimeToPhase2          = "Отсчет времени для фазы 2",
	TimeToPhase3          = "Отсчет времени для фазы 3",
	TimeToPhase4          = "Отсчет времени для фазы 4",
	MagneticCore          = "Объявлять подобравших Магнитное ядро",
	HealthFramePhase4     = "Отображать индикатор здоровья в фазе 4",
	TimerMine             = "Отображение таймера появления мин",
	AutoChangeLootToFFA   = "Смена режима добычи на Каждый за себя в фазе 3",
	WarnBombSpawn         = "Предупреждение о Бомботах",
	TimerHardmode         = "Отсчет времени для сложного режима",
	PlaySoundOnShockBlast = "Звуковой сигнал при $spell:312792",
	PlaySoundOnDarkGlare  = "Звуковой сигнал при $spell:312794",
	ShockBlastWarningInP1 = "Спец-предупреждение для $spell:312792 в фазе 1",
	ShockBlastWarningInP4 = "Спец-предупреждение для $spell:312792 в фазе 4",
	RangeFrame            = "Показывать окно проверки дистанции в фазе 1 (6 м)"
}

L:SetMiscLocalization {
	MobPhase1    = "Левиафан II",
	MobPhase2    = "VX-001",
	MobPhase3    = "Воздушное судно",
	MobPhase4    = "В-0-7-ТРОН",
	YellPull     = "У нас мало времени, друзья! Вы поможете испытать новейшее и величайшее из моих изобретений. И учтите: после того, что вы натворили с XT-002, отказываться просто некрасиво.",
	YellHardPull = "Так, зачем вы это сделали? Разве вы не видели надпись \"НЕ НАЖИМАЙТЕ ЭТУ КНОПКУ!\"? Ну как мы сумеем завершить испытания при включенном механизме самоликвидации, а?",
	YellPhase2   = "ПРЕВОСХОДНО! Просто восхитительный результат! Целостность обшивки – 98,9 процента! Почти что ни царапинки! Продолжаем!",
	YellPhase3   = "Спасибо, друзья! Благодаря вам я получил ценнейшие сведения! Так, а куда же я дел... – ах, вот куда.",
	YellPhase4   = "Фаза предварительной проверки завершена. Пора начать главный тест!",
	YellKilled   = "Очевидно, я совершил небольшую ошибку в расчетах. Пленный злодей затуманил мой разум и заставил меня отклониться от инструкций. Сейчас все системы в норме. Конец связи.",
	LootMsg      = "([^%s]+).*Hitem:(%d+)",
	HARD_MODE    = "Сложный режим"
}


---------------------
--  General Vezax  --
---------------------
L = DBM:GetModLocalization("GeneralVezax")

L:SetGeneralLocalization({
	name = "Генерал Везакс"
})

L:SetTimerLocalization({
	hardmodeSpawn = "Саронитовый враг"
})

L:SetOptionLocalization({
	SetIconOnShadowCrash = "Устанавливать метки на цели заклинания $spell:312978",
	SetIconOnLifeLeach   = "Устанавливать метки на цели заклинания $spell:312974",
	hardmodeSpawn        = "Отсчет времени до появления Саронитового врага (сложный режим)",
	CrashArrow           = "Показывать стрелку, когда $spell:62660 около вас",
	YellLeech            = "Вытягивание жизни на мне!",
	YellCrash            = "Темное сокрушение на мне!"
})

L:SetMiscLocalization({
	EmoteSaroniteVapors = "Поблизости начинают возникать саронитовые испарения!"
})

------------------
--  Yogg-Saron  --
------------------
L = DBM:GetModLocalization("YoggSaron")

L:SetGeneralLocalization {
	name = "Йогг-Сарон"
}

L:SetMiscLocalization {
	YellPull             = "Скоро мы сразимся с главарем этих извергов! Обратите гнев и ненависть против его прислужников!",
	YellPhase2           = "Я – это сон наяву.",
	Sara                 = "Сара",
	Mozg                 = "Мозг Йог-Сарона",
	HevTentacle          = "Тяжёлое щупальце",
	WarningYellSqueeze   = "Выдавливание на мне! Помогите!",
	S1TheLucidDream      = "Фаза 1: осознанный сон",
	S2DescentIntoMadness = "Фаза 2: Провал Безумия",
	S3TrueFaceofDeath    = "Фаза 3: истинный лик смерти",
	DescentIntoMadness   = "Провал Безумия",
	ImmortalGuardian     = "Бессмертный страж"
}

L:SetWarningLocalization {
	WarningGuardianSpawned        = "Страж %d",
	WarningCrusherTentacleSpawned = "Тяжёлое щупальце",
	WarningSanity                 = "Осталось %d Здравомыслия",
	SpecWarnSanity                = "Осталось %d Здравомыслия",
	SpecWarnGuardianLow           = "Прекратите атаковать этого Стража",
	SpecWarnMadnessOutNow         = "Доведение до помешательства заканчивается - выбегайте",
	WarnBrainPortalSoon           = "Провал Безумия через 3 секунды",
	SpecWarnFervor                = "Рвение Сары на вас",
	SpecWarnFervorCast            = "Рвение Сары накладывается на вас",
	specWarnBrainPortalSoon       = "Скоро Провал Безумия"
}

L:SetTimerLocalization {
	NextPortal = "Провал Безумия",
	NextPortal2 = "Перезарядка Портала"
}

L:SetOptionLocalization {
	WarningGuardianSpawned        = "Предупреждение о появлении Стража",
	WarningCrusherTentacleSpawned = "Предупреждение о появлении Тяжелого щупальца",
	WarningSanity                 = "Предупреждение, когда у вас мало $spell:63050",
	SpecWarnSanity                = "Спец-предупреждение, когда у вас очень мало $spell:63050",
	SpecWarnGuardianLow           = "Спец-предупреждение, когда у Стража (в фазе 1) мало здоровья (для бойцов)",
	WarnBrainPortalSoon           = "Предупреждать заранее о Провале Безумия",
	SpecWarnMadnessOutNow         = "Спец-предупреждение незадолго до окончания $spell:313003",
	SpecWarnFervorCast            = "Спец-предупреждение, когда на вас накладывается $spell:312989\n(должна быть в цели или фокусе хотя бы у одного члена рейда)",
	specWarnBrainPortalSoon       = "Спец-предупреждение о следующем Провале Безумия",
	ShowSaraHealth                = "Показывает Здоровье Сары на 1 + Мозга на 2 (Сара на 1 фазе должна быть в фокусе хоть у 1 члена группы)",
	NextPortal                    = "Отсчёт времени до следующего Провала Безумия",
	MaladyArrow                   = "Показывать стрелку, когда $spell:313029 около вас",
}
