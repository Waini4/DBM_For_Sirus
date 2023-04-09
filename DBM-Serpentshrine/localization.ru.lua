if GetLocale() ~= "ruRU" then return end
local DBML = DBM_CORE_L
local L

--Hydross
L = DBM:GetModLocalization("Hydross")

L:SetGeneralLocalization {
	name = "Гидросс Нестабильный"
}

L:SetTimerLocalization {
	TimerMarkOfHydross = "Знак Гидроса %s%%",
	TimerMarkOfCorruption = "Знак порчи %s%%"
}

L:SetWarningLocalization {
	WarnMarkOfHydross    = "Знак Гидроса %s%%",
	WarnMarkOfCorruption = "Знак порчи %s%%",
	SpecWarnThreatReset  = "Сброс угрозы - АСТАНАВИТЕСЬ!!!!",
	Yad                  = "ГРЯЗНАЯ ФАЗА, БЕГИТЕ В ЛУЖУ",
	Chis                 = "Чистая фаза"
}

L:SetOptionLocalization {
	TimerMarkOfHydross    = "Таймер $spell:38215",
	TimerMarkOfCorruption = "Таймер $spell:38219",
	WarnMarkOfHydross     = DBML.AUTO_ANNOUNCE_OPTIONS.spell:format(38215, GetSpellInfo(38215)),
	WarnMarkOfCorruption  = DBML.AUTO_ANNOUNCE_OPTIONS.spell:format(38219, GetSpellInfo(38219)),
	SpecWarnThreatReset   = "Спец. предупреждение о сбрасывании угрозы",
	SetIconOnSklepTargets = "Устанавливать иконки на цели $spell:309046",
	SetIconOnKorTargets   = "Устанавливать иконки на цели $spell:309065",
	Yad                   = "Объявлять перефазу ",
	Chis                  = "Объявлять перефазу  ",
	AnnounceSklep         = "Объявлять игроков, на кого установлен $spell:309046, в рейд чат",
	AnnounceKor           = "Объявлять игроков, на кого установлена $spell:309065, в рейд чат "
}

L:SetMiscLocalization {
	YellPull = "Я не позволю вам вмешиваться!",
	YellPoison = "Агрррхх, яд.",
	YellWater = "Так лучше, намного лучше.",
	SklepIcon = "Водяная гробница {rt%d} установлена на: %s",
	KorIcon = "Коррозия {rt%d} установлена на: %s"
}


--Tidewalker
L = DBM:GetModLocalization("Tidewalker")

L:SetGeneralLocalization {
	name = "Морогрим Волноступ"
}

L:SetTimerLocalization {
	TimerMurlocks = "Мурлоки"
}

L:SetWarningLocalization {
	WarnMurlocksSoon = "Мурлоки на подходе",
	WarnGlobes       = "Глобулы!"
}

L:SetOptionLocalization {
	WarnMurlocksSoon = "Обьявлять о скором вызове мурлоков",
	WarnGlobes       = "Объявлять о появлении глобул",
	TimerMurlocks    = "Отсчет времени до вызова мурлоков"
}

L:SetMiscLocalization {
	YellPull     = "Да поглотит вас пучина вод!",
	EmoteMurlocs = "Сильный толчок землетрясения насторожил мурлоков поблизости!",
	EmoteGraves  = "%s отправляет своих врагов в водяные могилы!",
	EmoteGlobes  = "%s призывает водяные шары!"
}

--Leotheras
L = DBM:GetModLocalization("Leotheras")

L:SetGeneralLocalization {
	name = "Леотерас Слепец"
}

L:SetTimerLocalization {
	TimerDemon = "Форма демона",
	TimerNormal = "Обычная форма",
	TimerInnerDemons = "Контроль над разумом"
}

L:SetWarningLocalization {
	WarnPhase2Soon = "Скоро переход в фазу 2",
}

L:SetOptionLocalization {
	TimerDemon            = "Отсчет времени до превращения в демона",
	TimerNormal           = "Отсчет времени до конца формы демона",
	TimerInnerDemons      = "Таймер $spell:37676",
	KleiIcon              = DBML.AUTO_ICONS_OPTION_TARGETS:format(310496),
	SetIconOnDemonTargets = "Устанавливать иконки на цели демонов",
	SetIconOnPepelTargets = "Устанавливать иконки на цели испепеления",
	WarnPhase2Soon        = "Предупреждать заранее о переходе в фазу 2 (на ~37%)",
	AnnounceKlei          = "Объявлять игроков, на кого установлено клеймо, в рейд чат",
	PepelShieldFrame      = "Показать людей с индикатором здоровья для Испепеления",
	AnnouncePepel         = "Объявлятьв игроков, на кого установлено испепеление, в рейд чат ",
}

L:SetMiscLocalization {
	YellPull         = "Наконец-то мое заточение окончено!",
	YellDemon        = "Прочь, жалкий эльф. Настало мое время!",
	YellShadow       = "Нет... нет! Что вы наделали? Я – главный! Слышишь меня? Я... Ааааах! Мне его... не удержать.",
	PepelIcon        = "Испепеление {rt%d} установлено на %s",
	IncinerateTarget = "Испепеление: %s",
	Power            = "Энергия",
	Klei             = "Клеймо {rt%d} установлено на %s"
}

--LurkerBelow
L = DBM:GetModLocalization("LurkerBelow")

L:SetGeneralLocalization {
	name = "Скрытень из глубин"
}

L:SetTimerLocalization {
	Submerge = "Погружение",
	Emerge   = "Появление"

}

L:SetWarningLocalization {
	WarnSubmerge = "Скоро погружение",
	WarnEmerge   = "Скоро появление"
}

L:SetOptionLocalization {
	WarnSubmerge = "Объявлять погружение",
	WarnEmerge   = "Объявлять появление",
	Submerge     = "Отсчет времени до погружения",
	Emerge       = "Отсчет времени до появления"
}

L:SetMiscLocalization {
	EmoteSpout = "%s делает глубокий вдох."
}

--Fathomlord
L = DBM:GetModLocalization("Fathomlord")

L:SetGeneralLocalization {
	name = "Повелитель глубин Каратресс"
}

L:SetTimerLocalization {
	TimerKaraTarget = "Преследование на %s"
}

L:SetWarningLocalization {
	WarnKaraTarget = "Каратес преследует %s",
	SpecWarnKaraTarget = "Вас преследует Каратес - бегите"
}

L:SetOptionLocalization {
	HealthFrameBoss      = "Показывать здоровье боссов в фазе 1",
	WarnPhase2Soon       = "Предупреждать заранее о переходе в фазу 2 (на ~52%)",
	SetIconOnSvazTargets = "Устанавливать иконки на цели испепеления",
	SetIconOnStrela      = "Устанавливать иконки на цель стрелы",
	AnnounceSvaz         = "Объявлятьв игроков, на кого установлено $spell:309261, в рейд чат ",
	WarnKaraTarget       = "Обьявлять цели преследуемые Каратесом",
	SpecWarnKaraTarget   = "Спец. предупреждение для преследуемого Каратесом",
	TimerKaraTarget      = "Отсчет времени до смены цели Каратеса"
}

L:SetMiscLocalization {
	YellPull   = "Стража, к бою! У нас гости...",
	SvazIcon   = "Пламенная свзь {rt%d} установлена на %s",
	KaraTarget = "смотрит на |3%-3%([%w\128-\255]+%).",
	Karat      = "Каратресс",
	Volni      = "Волниис",
	Shark      = "Шарккис",
	Karib      = "Карибдис",
}

--Vashj
L = DBM:GetModLocalization("Vashj")

L:SetGeneralLocalization {
	name = "Леди Вайш"
}

L:SetTimerLocalization {
	Strider          = "Странник",
	TaintedElemental = "Нечистый элементаль",
	Naga             = "Гвардеец"
}

L:SetWarningLocalization {
	WarnCore                = "%s получил порченую магму",
	WarnPhase               = "Фаза %d",
	WarnElemental           = "Нечистый элементаль на подходе",
	SpecWarnStaticAngerNear = "Статический заряд рядом - отойдите."
}

L:SetOptionLocalization {
	WarnCore                = "Объявить наличие порченой магмы",
	WarnPhase               = "Обьявлять о смене фазы",
	Strider                 = "Отсчет времени до следующего Странника",
	TaintedElemental        = "Отсчет времени до следующего Нечистого элементаля",
	Naga                    = "Отсчет времени до следующего Гвардейца",
	WarnElemental           = "Объявлять о прибытии Нечистый элементаль",
	Elem                    = "Показывать стрелку на Нечистого элементаля",
	AnnounceStatic          = "Объявлятьв игроков, на кого установлено $spell:310636, в рейд чат ",
	SpecWarnStaticAngerNear = "Спец-предупреждение, когда $spell:310636 около вас"
}

L:SetMiscLocalization {
	YellPhase2       = "Время пришло! Не щадите никого!",
	YellPhase3       = "Вам не пора прятаться?",
	TaintedElemental = "Нечистый элементаль",
	StaticIcon       = "Статический заряд {rt%d} установлен на %s"
}

--Gorelac
L = DBM:GetModLocalization("Gorelac")

L:SetGeneralLocalization {
	name = "Горе'лац"
}


--TrashMobs
L = DBM:GetModLocalization("TrashMobs")

L:SetGeneralLocalization {
	name = "Трэш мобы"
}
