if GetLocale() ~= "ruRU" then return end
local DBML = DBM_CORE_L
local L

--Alar
L = DBM:GetModLocalization("Alar")

L:SetGeneralLocalization({
	name = "Ал'ар"
})

L:SetTimerLocalization({
	TimerNextPlat = "След. платформа"
})

L:SetWarningLocalization({
	WarnPlatSoon = "Скоро следующая платформа",
	SpecWarnFeatherNear = "Падающее перо феникса около вас - остерегайтесь",
	WarnSupernova = "Супернова >%d<",
	WarnPhase2Soon = "Скоро 2-я фаза",
	WarnPhase2 = "ФАЗА 2 БЕЕГИИТЕЕ",
	WarnFlamefal0 = "Перья полетели, БЕГИТЕ!!!",

	WarnFireSign = "Знак огня"
})

L:SetOptionLocalization({
	TimerNextPlat = "Отсчет времени до перелета на следующую платформу",
	TwilightCutterCast = "Предупреждать заранее о $spell:308631",
	WarnPlatSoon = "Предупреждение о перелете на следующую платформу",
	SpecWarnFeather = "Спец-предупреждение, когда $spell:308632 на вас",
	SpecWarnFeatherNear = "Спец-предупреждение, когда $spell:308632 около вас",
	YellOnFeather = "Кричать, когда $spell:308632 на вас",
	FeatherIcon = DBML.AUTO_ICONS_OPTION_TARGETS:format(308632),
	FeatherArrow = "Показывать стрелку, когда $spell:308632 около вас",
	WarnPhase2Soon = "Предупреждать заранее о переходе в фазу 2 (на ~7%)",
	WarnPhase2 = "Начало фазы 2 $spell:308649 ",
	WarnSupernova = "Предупреждение о ваших стаках $spell:308636",
	WarnFlamefal0 = "Предупреждение, что перья полетели!!!",
	WarnFireSign = "Объявить в рейд о касте знака огня"
})


L:SetMiscLocalization({
	YellFeather = "Перо падает на меня!",
})

--Solarian
L = DBM:GetModLocalization("Solarian")

L:SetGeneralLocalization({
	name = "Верховный звездочет Солариан"
})

L:SetTimerLocalization({
	TimerNextRing = "Ослепление",
	TimerNextStar = "Звездное пламя",
	TimerNextHelp = "Вызов послушников",
	TimerNextGates = "Призыв врат бездны",
	TimerNextHeal = "Высшее исцеление",
	TimerAdds = "Вызов послушников",
	TimerPriests = "Вызов жрецов"
})

L:SetWarningLocalization({
	WarnAddsSoon = "Скоро вызов послушников"
})

L:SetOptionLocalization({
	WarnAddsSoon   = "Предупреждение о скором вызове послушников",
	TimerNextRing  = "Отсчет времени до следующего $spell:308563 ",
	TimerNextStar  = "Отсчет времени до следующего $spell:308565 ",
	TimerNextHelp  = "Отсчет времени до следующего $spell:308559 ",
	TimerNextHeal  = "Отсчет времени до следующего $spell:308561 ",
	TimerNextGates = "Отсчет времени до следующего $spell:308545 ",
	TimerAdds      = "Отсчет времени до следующих послушников",
	TimerPriests   = "Отсчет времени до следующих жрецов",
	Zrec           = "Показывать стрелку на Жреца"
})

L:SetMiscLocalization({
	YellPull = "Тал ану-мен но син-дорай!",
	YellAdds = "Вы безнадежно слабы!",
	YellPriests = "Я навсегда избавлю вас от мании величия!",
	PriestH = "Жрец из зала Солориана",
	PriestN = "Жрец из Зала Звездочета",
	Provid = "Провидец из зала Солориана",
	BeaconIconSet = "{Череп}{Череп}{rt%d}Гнев на:{Череп}{Череп}{Череп}%s{Череп}{Череп}{Череп}",

})

--VoidReaver
L = DBM:GetModLocalization("VoidReaver")

L:SetGeneralLocalization({
	name = "Страж Бездны"
})

L:SetWarningLocalization({
	Phase1 = "ВНИМАНИЕ!!! ФАЗА пониженного УРОНА!!!",
	Phase2 = "ВНИМАНИЕ!!! ФАЗА ПОВЫШЕННОГО УРОНА!!!"
})

L:SetOptionLocalization({
	Phase1               = "Предупреждать о фазе с пониженным уроном",
	Phase2               = "Предупреждать о фазе с повышенным уроном",
	SetIconOnSignTargets = "Устанавливать иконки на цели $spell:308471",
	AnnounceSign         = "Объявлять игроков, на кого установлен $spell:308471, в рейд чат"
})

L:SetMiscLocalization({
	YellPull = "Внимание! Вы подлежите уничтожению!",
	SignIcon = "Чародейский знак {rt%d} установлен на: %s"
})

--KaelThas
L = DBM:GetModLocalization("KaelThas")

L:SetGeneralLocalization({
	name = "Кель'тас Солнечный Скиталец"
})

L:SetTimerLocalization({
	TimerNextAdd = "%s",
	TimerPhase3 = "Фаза 3",
	TimerPhase4 = "Фаза 4",
	TimerTalaTarget = "Преследование на %s",
	TimerGravity = "Падение",
	Keltac = "Отсчет появления келя"

})

L:SetWarningLocalization({
	WarnNextAdd = "%s на подходе",
	WarnPhase = "%s",
	WarnTalaTarget = "Таладред преследует %s",
	SpecWarnTalaTarget = "Вас преследует Таладред - бегите"

})

L:SetOptionLocalization({
	WarnNextAdd               = "Объявление о скорой активации следующего помощника",
	TimerNextAdd              = "Отсчет времени до следующего помощника",
	WarnPhase                 = "Анонс перехода на след. фазу",
	TimerPhase3               = "Отсчет времени до 3й фазы",
	TimerPhase4               = "Отсчет времени до 4й фазы",
	WarnTalaTarget            = "Обьявлять цели преследуемые Таладредом",
	SpecWarnTalaTarget        = "Спец. предупреждение для преследуемого Таладредом",
	TimerTalaTarget           = "Отсчет времени до смены цели Таладреда",
	TimerGravity              = DBML.AUTO_YELL_OPTION_TEXT.fade:format(35941),
	RemoveWeaponOnMindControl = "Убирать оружие на МК.",
	SetIconOnMC               = DBML.AUTO_ICONS_OPTION_TARGETS:format(36797),
	VzrivIcon                 = DBML.AUTO_ICONS_OPTION_TARGETS:format(308797),
	AnnounceVzriv             = "Объявлять игроков, на кого установлен взрыв, в рейд чат",
	SayBoom                   = DBML.AUTO_YELL_OPTION_TEXT.shortyell:format(308797),
	BoomIcon                  = DBML.AUTO_ICONS_OPTION_TARGETS:format(308797),
	SayBomb                   = DBML.AUTO_YELL_OPTION_TEXT.shortyell:format(308750),
	SetIconOnBombTargets      = DBML.AUTO_ICONS_OPTION_TARGETS:format(308750),
	Avenger                   = DBML.AUTO_ARROW_OPTION_TEXT:format(308743),
	YellOnAvenger             = DBML.AUTO_YELL_OPTION_TEXT.shortyell:format(308743),
	AvengerLatencyCheck       = "Отключить синхр-цию для $spell:308743\n(используйте только в случае возникновения проблем)",
	Keltac                    = "Отсчет до появления Кель'таса"
})

L:SetMiscLocalization({
	YellPhase1  = "Мне очень жаль, но вы не сможете ничего изменить. Теперь меня никто не остановит! Селама ашаль-аноре!",
	YellSang    = "Вы справились с моими лучшими советниками... Но перед мощью Кровавого Молота не устоит никто. Узрите лорда Сангвинара!",
	YellCaper   = "Каперниан проследит, чтобы вы не задержались здесь надолго.",
	YellTelon   = "Неплохо, теперь вы можете потягаться с моим главным инженером Телоникусом.",
	YellPhase2  = "Как видите, оружия у меня предостаточно...",
	YellPhase3  = "Возможно, я недооценил вас. Было бы несправедливо заставлять вас драться с четырьмя советниками сразу, но... Мои люди тоже никогда не знали справедливости. Я лишь возвращаю долг.",
	YellPhase4  = "Увы, иногда приходится брать все в свои руки. Баламоре шаналь!",
	YellPhase5  = "Я не затем ступил на этот путь, чтобы остановиться на полдороги! Мои планы должны сбыться – и они сбудутся! Узрите же истинную мощь!",
	NamesAdds   = { ["Thaladred"] = "Таладред", ["Lord Sanguinar"] = "Лорд Сангвинар",
		["Capernian"] = "Каперниан", ["Telonicus"] = "Телоникус" },
	WarnPhase1  = "Фаза 1 - Таладред на подходе",
	WarnPhase2  = "Фаза 2 - Орудия на подходе",
	WarnPhase3  = "Фаза 3 - Приспешники на подходе",
	WarnPhase4  = "Фаза 4 - Кель'тас на подходе",
	WarnPhase5  = "Фаза 5",
	TalaTarget  = "смотрит на |3%-3%([%w\128-\255]+%).",
	Axe         = "Сокрушение",
	Kel         = "Кель'тас Солнечный Скиталец",
	Vzriv       = "Взрыв {rt%d} установлен на %s",
	YellAvenger = "{череп}|cff71d5ff|Hspell:308743|h[Щит мстителя]|h|r{череп}ЛЕТИТ В МЕНЯ!{череп}"
})


--Trash
L = DBM:GetModLocalization("Trash")

L:SetGeneralLocalization({
	name = "Трэш мобы"
})
