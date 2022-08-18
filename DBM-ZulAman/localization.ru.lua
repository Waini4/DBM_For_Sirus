if GetLocale() ~= "ruRU" then return end
local L
local DBML = DBM_CORE_L
---------------
--  Nalorakk --
---------------
L = DBM:GetModLocalization("Nalorakk")

L:SetGeneralLocalization({
	name = "Налоракк"
})

L:SetWarningLocalization({
	WarnBear		= "Форма медведя",
	WarnBearSoon	= "Форма медведя через 5 секунд",
	WarnNormal		= "Обычная форма",
	WarnNormalSoon	= "Обычная форма через 5 секунд",
	BearForm = "Форма медведя",
	TrollForm = "Форма тролля"
})

L:SetTimerLocalization({
	TimerBear		= "Форма медведя",
	TimerNormal		= "Обычная форма",
	BearForm = "Форма медведя",
	TrollForm = "Форма тролля"
})

L:SetOptionLocalization({
	WarnBear		= "Show warning for Bear form",--Translate
	WarnBearSoon	= "Show pre-warning for Bear form",--Translate
	WarnNormal		= "Show warning for Normal form",--Translate
	WarnNormalSoon	= "Show pre-warning for Normal form",--Translate
	TimerBear		= "Show timer for Bear form",--Translate
	TimerNormal		= "Show timer for Normal form",--Translate
	BearForm = "Отсчет времени до следующей формы медведя",
	TrollForm = "Отсчет времени до следующей формы тролля"
})

L:SetMiscLocalization({
	YellBear		= "Хотели разбудить во мне зверя? Вам это удалось.",
	YellTroll		= "С дороги!",
	YellNormal	= "Пропустите Налоракка!"
})

---------------
--  Akil'zon --
---------------
L = DBM:GetModLocalization("Akilzon")

L:SetGeneralLocalization({
	name = "Акил'зон"
})

L:SetWarningLocalization{
	WarnWind = "%s УЛЕТЕЛ!"
}

L:SetOptionLocalization{
	SetIconOnElectricStorm = "Отмечать на ком Электрическая буря",
	SayOnElectricStorm = "Говорить в чат на ком Электрическая буря",
	WarnWind = DBML.AUTO_ANNOUNCE_OPTIONS.spell:format(43621)
}

L:SetMiscLocalization{
	SayStorm = "Электрическая буря на мне!"
}

---------------
--  Jan'alai --
---------------
L = DBM:GetModLocalization("Janalai")

L:SetGeneralLocalization({
	name = "Джан'алай"
})
L:SetTimerLocalization{
	Hatchers = "Смотрители кладки",
	Bombs = "Бомбы",
	Explosion = "Взрыв!"
}

L:SetOptionLocalization{
	Hatchers = "Отсчет времени до прихода смотрителей",
	Bombs = "Отсчет времени до начала установки бомб",
	Explosion = "Отсчет времени до взрыва"
}
L:SetMiscLocalization({
	YellBombs		= "Щас я вас сожгу!",
	YellHatcher		= "Эй, хранители! Займитесь яйцами!"
})

--------------
--  Halazzi --
--------------
L = DBM:GetModLocalization("Halazzi")

L:SetGeneralLocalization({
	name = "Халаззи"
})

L:SetWarningLocalization({
	WarnSpirit	= "Призывает дух",
	WarnNormal	= "Дух исчезает"
})

L:SetOptionLocalization({
	WarnSpirit	= "Показывать предупреждение для призрачной фазы",
	WarnNormal	= "Показывать предупреждение для обычной фазы"
})

L:SetMiscLocalization({
	YellSpirit	= "Со мною дикий дух...",
	YellNormal	= "О дух, вернись ко мне!"
})

--------------------------
--  Hex Lord Malacrass --
--------------------------
L = DBM:GetModLocalization("Malacrass")

L:SetGeneralLocalization({
	name = "Малакрасс"
})

L:SetMiscLocalization({
	YellPull	= "На вас падет тень..."
})
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
	SpecWarnMelee = "Обьявлять опасные способности для мдд",
	SpecWarnMove = "Обьявлять опасные способности для рдд",
	WarnSiphon = DBML.AUTO_ANNOUNCE_OPTIONS.spell:format(43501, GetSpellInfo(43501))

}
--------------
--  Zul'jin --
--------------
L = DBM:GetModLocalization("ZulJin")

L:SetGeneralLocalization({
	name = "Зул'джин"
})

L:SetMiscLocalization({
	Bear = "медведя",
	Hawk = "орла",
	Lynx = "рыси",
	Dragon = "драконодора",
	YellBearZul		= "Сейчас-сейчас. Выучил вот пару новых фокусов... вместе с братишкой-медведем.",
	YellLynx		= "Знакомьтесь, мои новые братишки: клык и коготь!",
	FrostPresence = "Власть льда",
	DriudBearForm = "Облик лютого медведя",
	YellPhase2	= "Выучил новый фокус… прямо как братишка-медведь...",
	YellPhase3	= "От орла нигде не скрыться!",
	YellPhase4	= "Позвольте представить моих двух братцев: клык и коготь!",
	YellPhase5	= "Для того чтобы увидеть дракондора, в небо смотреть необязательно!"
})
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