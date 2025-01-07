if GetLocale() ~= "ruRU" then return end

local L

----------------------
--  Coren Direbrew  --
----------------------
L = DBM:GetModLocalization("CorenDirebrew")

L:SetGeneralLocalization({
	name = "Корен Худовар"
})

L:SetWarningLocalization({
	specWarnBrew     = "Избавьтесь от варева прежде, чем она бросит вам другое!",
	specWarnBrewStun = "СОВЕТ: Вы получили удар, не забудьте выпить варево в следующий раз!"
})

L:SetOptionLocalization({
	specWarnBrew     = "Спец-предупреждение для Пива темной официантки",
	specWarnBrewStun = "Спец-предупреждение для Оглушения темным пивом официантки",
	YellOnBarrel     = "Крикнуть, когда на вас Бочка"
})

L:SetMiscLocalization({
	YellBarrel = "Бочка на мне!"
})

-------------------------
--  Headless Horseman  --
-------------------------
L = DBM:GetModLocalization("HeadlessHorseman")

L:SetGeneralLocalization({
	name = "Всадник без головы"
})

L:SetWarningLocalization({
	warnHorsemanSoldiers = "Призыв Пульсирующих тыкв",
	specWarnHorsemanHead = "Вихрь - переключитесь на голову"
})

L:SetOptionLocalization({
	warnHorsemanSoldiers = "Предупреждать о призыве Пульсирующих тыкв",
	specWarnHorsemanHead = "Спец-предупреждение для Вихря (призыв 2ой и следующей головы)"
})

L:SetMiscLocalization({
	HorsemanHead     = "Не надоело еще убегать?",
	HorsemanSoldiers = "Восстаньте слуги, устремитесь в бой! Пусть павший рыцарь обретет покой!",
	SayCombatEnd     = "Со смертью мы давно уже друзья...Что ждет теперь на пустоши меня?"
})

-----------------------
--  Apothecary Trio  --
-----------------------
L = DBM:GetModLocalization("ApothecaryTrio")

L:SetGeneralLocalization({
	name = "Трое аптекарей"
})

L:SetTimerLocalization({
	HummelActive = "Хаммел вступает в бой",
	BaxterActive = "Бакстер вступает в бой",
	FryeActive   = "Фрай вступает в бой"
})

L:SetOptionLocalization({
	TrioActiveTimer = "Отсчет времени до вступления Троих аптекарей в бой"
})

L:SetMiscLocalization({
	SayCombatStart = "Тебе хоть сказали, кто я и чем занимаюсь?"
})

-------------
--  Ahune  --
-------------
L = DBM:GetModLocalization("Ahune")

L:SetGeneralLocalization({
	name = "Ахун"
})

L:SetWarningLocalization({
	Submerged      = "Ахун исчез",
	Emerged        = "Ахун появился",
	specWarnAttack = "Ахун уязвим - атакуйте сейчас!"
})

L:SetTimerLocalization({
	SubmergeTimer = "Исчезновение",
	EmergeTimer   = "Появление",
	TimerCombat   = "Начало боя"
})

L:SetOptionLocalization({
	Submerged      = "Предупреждение, когда Ахун исчезает",
	Emerged        = "Предупреждение, когда Ахун появляется",
	specWarnAttack = "Спец-предупреждение, когда Ахун становится уязвим",
	SubmergeTimer  = "Отсчет времени до исчезновения",
	EmergeTimer    = "Отсчет времени до появления",
	TimerCombat    = "Отсчет времени до начала боя",
})

L:SetMiscLocalization({
	Pull = "Камень Льда растаял!"
})

L = DBM:GetModLocalization("Snowman")

L:SetGeneralLocalization({
	name = "Мороженка"
})

L:SetWarningLocalization({
	OrbDiedCount = "Осталось ледяных духов: %s",
})

L:SetTimerLocalization({
})

L:SetOptionLocalization({
	OrbDiedCount = "Показывать предупреждение о количестве оставшихся духов.",
	PartySay = "Оповещение в чат Группы"
})

L:SetMiscLocalization({
	Ball = "Гигантский снежный ком нацелен на (%S+)",
	WaveLight = "Текущий уровень: (%d+)",
	Cek = "Золото:",
	Guard = "Ледяной защитник предотвращает весь урон получаемый Мороженкой.",
	GuardName = "Ледяной защитник",
	Pull = "Мы должны разморозить его сердце и вернуть ему веселье Зимнего покрова.",
	Pull2 = "Узрите! Узрите величайшего снеговика из когда-либо созданных!",
	End = "Победитель определен!"
})
