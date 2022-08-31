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
	WarnNormal		= "Форма тролля",
	WarnNormalSoon	= "Форма тролля через 5 секунд",
})

L:SetTimerLocalization({
	TimerBear		= "Форма медведя",
	TimerTroll		= "Форма тролля",
})

L:SetOptionLocalization({
	WarnBear		= "Предупреждение при форме тролля",
	WarnBearSoon	= "Предупреждать заранее о следующей форме медведя",
	WarnTroll		= "Предупреждение при форме тролля",
	WarnTrollSoon	= "Предупреждать заранее о следующей форме тролля",
	TimerBear		= "Отсчет времени до следующей формы медведя",
	TimerTroll		= "Отсчет времени до следующей формы тролля"

})

L:SetMiscLocalization({
	YellBear		= "Хотели разбудить во мне зверя? Вам это удалось.",
	YellTroll		= "C дороги!",
	YellPullNal		= "Очень скоро вы умрете!"
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
	SayStorm = "Электрическая буря на мне!",
	YellPullAKil = "Я – охотник! Вы – добыча!"
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
	YellHatcher		= "Эй, хранители! Займитесь яйцами!",
	YellPullJan		= "Духи ветра станут вашей погибелью!"
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

L:SetMiscLocalization({
	YellPullMal	= "Тьма поглотит вас!"
})
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
	YellPhase5	= "Для того чтобы увидеть дракондора, в небо смотреть необязательно!",
	YellPullZul	= "У нас вечно хотят что-то отнять. Теперь мы вернем себе все. Любой, кто встанет у нас на пути, захлебнется в собственной крови! Империя Амани возрождается...ради мщения. И начнем мы...с вас!"
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
