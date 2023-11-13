if GetLocale() ~= "ruRU" then return end

local L

--------------------------
--  General BG Options  --
--------------------------
L = DBM:GetModLocalization("Battlegrounds")

L:SetGeneralLocalization({
	name = "Общие параметры"
})

L:SetTimerLocalization({
	TimerInvite = "%s"
})

L:SetOptionLocalization({
	ColorByClass	= "Показывать имена цветом класса в таблице очков",
	ShowInviteTimer	= "Отсчет времени до входа на ПБ",
	AutoSpirit		= "Автоматически покидать тело"
})

L:SetMiscLocalization({
	ArenaInvite	= "Приглашение на Арену"
})

--------------
--  Arenas  --
--------------
L = DBM:GetModLocalization("Arenas")

L:SetGeneralLocalization({
	name = "Арены"
})

L:SetTimerLocalization({
	TimerStart	= "Битва начнется через",
	TimerShadow	= "Сумеречное зрение"
})

L:SetOptionLocalization({
	TimerStart	= "Отсчет времени до начала битвы",
	TimerShadow = "Отсчет времени для Сумрачного зрения"
})

L:SetMiscLocalization({
	Start60	= "Одна минута до начала боя на арене!",
	Start30	= "Битва на Арене начнется через 30 секунд!",
	Start15	= "Пятнадцать секунд до начала схватки на арене!"
})

----------------------
--  Alterac Valley  --
----------------------
L = DBM:GetModLocalization("z402")

L:SetGeneralLocalization({
	name = "Альтеракская долина"
})

L:SetTimerLocalization({
	TimerStart	= "Битва начнется через",
	TimerTower	= "%s",
	TimerGY		= "%s"
})

L:SetMiscLocalization({
	BgStart60	= "До начала сражения за Альтеракскую долину остается 1 минута.",
	BgStart30	= "30 секунд до начала битвы в Альтеракской долине.",
	ZoneName	= "Альтеракская долина"
})

L:SetOptionLocalization({
	TimerStart	= "Отсчет времени до начала битвы",
	TimerTower	= "Отсчет времени до захвата",
	TimerGY		= "Отсчет времени до захвата кладбищ",
	AutoTurnIn	= "Автоматическая сдача заданий"
})

--------------------
--  Arathi Basin  --
--------------------
L = DBM:GetModLocalization("z462")

L:SetGeneralLocalization({
	name = "Низина Арати"
})

L:SetMiscLocalization({
	BgStart60	= "Битва за Низину Арати начнется через минуту.",
	BgStart30	= "Битва за Низину Арати начнется через 30 секунд.",
	ZoneName	= "Низина Арати",
	ScoreExpr	= "(%d+)/1600",
	Alliance	= "Альянса",
	Horde		= "Орды",
	WinBarText	= "Финал: %d - %d",
	BasesToWin	= "Захвачено баз: %d",
	Flag		= "Флаг"
})

L:SetTimerLocalization({
	TimerStart	= "Битва начнется через",
	TimerCap	= "%s"
})

L:SetOptionLocalization({
	TimerStart				= "Отсчет времени до начала битвы",
	TimerWin				= "Отсчет времени до победы",
	TimerCap				= "Отсчет времени до захвата",
	ShowAbEstimatedPoints	= "Отображать предполагаемые очки оставшиеся до победы/поражения",
	ShowAbBasesToWin		= "Отображать базы, которые необходимо захватить"
})

--------------------
--  Arathi Basin Winter --
--------------------
L = DBM:GetModLocalization("z958")

L:SetGeneralLocalization({
	name = "Низина Арати Зима"
})

L:SetMiscLocalization({
	BgStart60	= "Битва за Низину Арати начнется через минуту.",
	BgStart30	= "Битва за Низину Арати начнется через 30 секунд.",
	ZoneName	= "Зимняя Низина Арати",
	ScoreExpr	= "(%d+)/1600",
	Alliance	= "Альянса",
	Horde		= "Орды",
	WinBarText	= "Финал: %d - %d",
	BasesToWin	= "Захвачено баз: %d",
	Flag		= "Флаг"
})

L:SetTimerLocalization({
	TimerStart	= "Битва начнется через",
	TimerCap	= "%s"
})

L:SetOptionLocalization({
	TimerStart				= "Отсчет времени до начала битвы",
	TimerWin				= "Отсчет времени до победы",
	TimerCap				= "Отсчет времени до захвата",
	ShowAbEstimatedPoints	= "Отображать предполагаемые очки оставшиеся до победы/поражения",
	ShowAbBasesToWin		= "Отображать базы, которые необходимо захватить"
})



------------------------
--  Eye of the Storm  --
------------------------
L = DBM:GetModLocalization("z541")

L:SetGeneralLocalization({
	name = "Око Бури"
})

L:SetMiscLocalization({
	BgStart60		= "Битва начнется через минуту!",
	BgStart30		= "Битва начнется через 30 секунд!",
	ZoneName		= "Око Бури",
	ScoreExpr		= "(%d+)/1600",
	Alliance 		= "Альянса",
	Horde 			= "Орды",
	WinBarText 		= "Финал: %d - %d",
	Flag			= "Флаг",
	FlagReset 		= "Флаг возвращен на базу.",
	FlagTaken 		= "(.+) захватывает флаг!",
	FlagCaptured	= "(.+) захватил флаг!",
	FlagDropped		= "Флаг уронили!"

})

L:SetTimerLocalization({
	TimerStart	= "Битва начнется через",
	TimerFlag	= "Флаг восстановлен"
})

L:SetOptionLocalization({
	TimerStart		= "Отсчет времени до начала битвы",
	TimerWin 		= "Отсчет времени до победы",
	TimerFlag 		= "Отсчет времени до восстановления флага",
	ShowPointFrame	= "Отображать флагоносца и предполагаемые очки"
})

---------------------
--  Warsong Gulch  --
---------------------
L = DBM:GetModLocalization("z444")

L:SetGeneralLocalization({
	name = "Ущелье Песни Войны"
})

L:SetMiscLocalization({
	BgStart60 			= "Битва за Ущелье Песни Войны начнется через 1 минуту.",
	BgStart30 			= "Битва за Ущелье Песни Войны начнется через 30 секунд. Приготовиться!",
	ZoneName 			= "Ущелье Песни Войны",
	Alliance 			= "Альянса",
	Horde 				= "Орды",
	InfoErrorText		= "Функция выбора флагоносца, будет восстановлена после выхода из режима боя.",

	ExprFlagPickUp		= "(.+) несет флаг (.+)!",
	ExprFlagPickUp2		= "Флаг (.+) у [|0-9-]*%((.+)%)",
	ExprFlagDropped		= "(.+) роняет флаг (.+)!",
	ExprFlagCaptured	= "(.+) захватывает флаг (.+)!",
	FlagAlliance		= "Флаг Альянса",
	FlagHorde			= "Флаг Орды",
	FlagBase			= "База"
})

L:SetTimerLocalization({
	TimerStart	= "Битва начнется через",
	TimerFlag	= "Восстановление флага"
})

L:SetOptionLocalization({
	TimerStart					= "Отсчет времени до начала битвы",
	TimerFlag					= "Отсчет времени до восстановления флага",
	ShowFlagCarrier				= "Показать флагоносца",
	ShowFlagCarrierErrorNote	= "Сообщения об ошибках в режиме боя"
})

------------------------
--  Isle of Conquest  --
------------------------
L = DBM:GetModLocalization("z483")

L:SetGeneralLocalization({
	name = "Остров Завоеваний"
})

L:SetWarningLocalization({
	WarnSiegeEngine		= "Осадная машина готова!",
	WarnSiegeEngineSoon	= "Осадная машина через ~10 сек"
})

L:SetTimerLocalization({
	TimerStart			= "Битва начнется через",
	TimerPOI			= "%s",
	TimerSiegeEngine	= "Готовность осадной машины"
})

L:SetOptionLocalization({
	TimerStart			= "Отсчет времени до начала битвы",
	TimerPOI			= "Отсчет времени до захвата",
	TimerSiegeEngine	= "Показать таймер для строительства осадной машины",
	WarnSiegeEngine		= "Показывать предупреждение, когда Осадная машина будет готова",
	WarnSiegeEngineSoon	= "Показывать предупреждение, когда Осадная машина почти готова"
})

L:SetMiscLocalization({
	ZoneName				= "Остров Завоеваний",
	BgStart60				= "Битва начнется через 60 секунд.",
	BgStart30				= "Битва начнется через 30 секунд.",
	BgStart15				= "Битва начнется через 15 секунд.",
	SiegeEngine				= "Siege Engine",
	GoblinStartAlliance		= "See those seaforium bombs? Use them on the gates while I repair the siege engine!",
	GoblinStartHorde		= "I'll work on the siege engine, just watch my back.  Use those seaforium bombs on the gates if you need them!",
	GoblinHalfwayAlliance	= "I'm halfway there! Keep the Horde away from here.  They don't teach fighting in engineering school!",
	GoblinHalfwayHorde		= "I'm about halfway done! Keep the Alliance away - fighting's not in my contract!",
	GoblinFinishedAlliance	= "My finest work so far! This siege engine is ready for action!",
	GoblinFinishedHorde		= "The siege engine is ready to roll!",
	GoblinBrokenAlliance	= "It's broken already?! No worries. It's nothing I can't fix.",
	GoblinBrokenHorde		= "It's broken again?! I'll fix it... just don't expect the warranty to cover this"
})

-------------------------
--  Slavery Valley  --
-------------------------
L = DBM:GetModLocalization("z611")

L:SetGeneralLocalization({
	name		= "Долина Узников"
})

L:SetTimerLocalization({
	TimerPOI	= "%s",
})

L:SetOptionLocalization({
	TimerPOI	= "Отсчет времени до захвата",
})

L:SetMiscLocalization({

})

-------------------------
--  Silvershard Mines  --
-------------------------
L = DBM:GetModLocalization("z861")

L:SetGeneralLocalization({
	name		= "Сверкающие копи"
})

L:SetTimerLocalization({
	TimerRespawn	= "Восстановление вагонетки",
	TimerCart		= "%s"
})

L:SetOptionLocalization({
	TimerRespawn	= "Отсчет времени до восстановления вагонетки",
	TimerCart		= "Таймер захвата повозки"
})

L:SetMiscLocalization({

	Arrived	= "прибыв",
	Capture		= "захватил",
	Update1	= "контроль над вагонеткой",
	Update2	= "прибывает из",
	BattleStart	= "итва началась",
	LavaChange	= "осточная стрелка",
	TopChange	= "еверная стрелка",
	["Top - Down"] = "Левая-низ",
	["Top - Up"] = "Левая-верх",
	["Middle"] = "Средняя",
	["Lava - Down"] = "Лава-низ",
	["Lava - Up"] = "Лава-верх",
})

--------------------------
--  Battle for Gilneas  --
--------------------------
L = DBM:GetModLocalization("z916")

L:SetGeneralLocalization({
	name = "Битва за Гилнеас"
})

L:SetMiscLocalization({
	ScoreExpr	= "(%d+)/1500",
	WinBarText	= "Финал: %d - %d",
	BasesToWin	= "Захвачено баз: %d",
	Flag		= "Флаг"
})

L:SetTimerLocalization({
	TimerCap	= "%s"
})

L:SetOptionLocalization({
	TimerWin				= "Отсчет времени до победы",
	TimerCap				= "Отсчет времени до захвата",
	ShowGilneasEstimatedPoints	= "Отображать предполагаемые очки оставшиеся до победы/поражения",
	ShowGilneasBasesToWin		= "Отображать базы, которые необходимо захватить"
})
