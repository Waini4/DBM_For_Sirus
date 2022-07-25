if GetLocale() ~= "ruRU" then return end

local L

--Nalorakk
L = DBM:GetModLocalization("Nalorakk")

L:SetGeneralLocalization{
	name = "Налоракк"
}

L:SetTimerLocalization{
	BearForm = "Форма медведя",
	TrollForm = "Форма тролля"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
	BearForm = "Отсчет времени до следующей формы медведя",
	TrollForm = "Отсчет времени до следующей формы тролля"
}

L:SetMiscLocalization{
	YellBear		= "Хотели разбудить во мне зверя? Вам это удалось.",
	YellTroll		= "С дороги!"
}

--Akilzon
L = DBM:GetModLocalization("Akilzon")

L:SetGeneralLocalization{
	name = "Акил'зон"
}

L:SetTimerLocalization{

}

L:SetWarningLocalization{
	WarnWind = "%s УЛЕТЕЛ!"
}

L:SetOptionLocalization{
	RangeFrame				= "Показывать окно проверки дистанции (12 м)",
	SetIconOnElectricStorm = "Отмечать на ком Электрическая буря",
	SayOnElectricStorm = "Говорить в чат на ком Электрическая буря",
	WarnWind = DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(43621, GetSpellInfo(43621) or "unknown")
}

L:SetMiscLocalization{
	SayStorm = "Электрическая буря на мне!"
}

--Jan'alai
L = DBM:GetModLocalization("Janalai")

L:SetGeneralLocalization{
	name = "Джан'алай"
}

L:SetTimerLocalization{
	Hatchers = "Смотрители кладки",
	Bombs = "Бомбы",
	Explosion = "Взрыв!"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
	Hatchers = "Отсчет времени до прихода смотрителей",
	Bombs = "Отсчет времени до начала установки бомб",
	Explosion = "Отсчет времени до взрыва"
}

L:SetMiscLocalization{
	YellBombs		= "Щас я вас сожгу!",
	YellHatcher		= "Эй, хранители! Займитесь яйцами!"
}

--Halazzi
L = DBM:GetModLocalization("Halazzi")

L:SetGeneralLocalization{
	name = "Халаззи"
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
}

--Malacrass
L = DBM:GetModLocalization("Malacrass")

L:SetGeneralLocalization{
	name = "Малакрасс"
}

L:SetTimerLocalization{
	TimerSpecial = "Спец. способность %s"
}

L:SetWarningLocalization{
	WarnSiphon = "Малакрасс крадет способности у %s ",
	SpecWarnMelee = "%s отойдите!",
	SpecWarnMove = "%s отойдите!"
}

L:SetOptionLocalization{
	TimerSpecial = "Отсчитывать время между спец-способности",
	SpecWarnMelee = "Обьявлять опасные способности для милизоны",
	SpecWarnMove = "Обьявлять опасные способности для рдд",
	WarnSiphon = DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(43501, GetSpellInfo(43501) or "unknown")

}

L:SetMiscLocalization{

}

--ZulJin
L = DBM:GetModLocalization("ZulJin")

L:SetGeneralLocalization{
	name = "Зул'Джин"
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
	WarnThrow = "Кровотечение на >%s<!",
	WarnJump = "Кровотечение на >%s<!",
	WarnNextPhaseSoon = "Скоро фаза %s",
	WarnFlamePillar = "КОЛОННА ОГНЯ НА >%s<!"
}

L:SetOptionLocalization{
	WarnThrow = "Анонсировать цели кровотечения на фазе тролля",
	WarnJump = "Анонсировать цели кровотечения на фазе рыси",
	WarnNextPhaseSoon = "Предупреждать о скорой смене облика",
	WarnFlamePillar = "Объявлять на ком Колонна огня"
}

L:SetMiscLocalization{
	Bear = "медведя",
	Hawk = "орла",
	Lynx = "рыси",
	Dragon = "драконодора",
	YellBearZul		= "Сейчас-сейчас. Выучил вот пару новых фокусов... вместе с братишкой-медведем.",
	YellLynx		= "Знакомьтесь, мои новые братишки: клык и коготь!",
	FrostPresence = "Власть льда",
	DriudBearForm = "Облик лютого медведя"
}
