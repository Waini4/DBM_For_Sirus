if GetLocale() ~= "ruRU" then return end
local L

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
	WarnNormalSoon	= "Обычная форма через 5 секунд"
})

L:SetTimerLocalization({
	TimerBear		= "Форма медведя",
	TimerNormal		= "Обычная форма"
})

L:SetOptionLocalization({
	WarnBear		= "Show warning for Bear form",--Translate
	WarnBearSoon	= "Show pre-warning for Bear form",--Translate
	WarnNormal		= "Show warning for Normal form",--Translate
	WarnNormalSoon	= "Show pre-warning for Normal form",--Translate
	TimerBear		= "Show timer for Bear form",--Translate
	TimerNormal		= "Show timer for Normal form"--Translate
})

L:SetMiscLocalization({
	YellBear 	= "Если вызвать чудовище, то мало не покажется, точно говорю!",
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
	WarnWind = L.AUTO_ANNOUNCE_OPTIONS.spell:format(43621)
}

L:SetMiscLocalization{
	SayStorm = "Электрическая буря на мне!"
}

---------------
--  Jan'alai --
---------------
L = DBM:GetModLocalization("Janalai")

L:SetGeneralLocalization({
	name = "Джан'алаи"
})

L:SetMiscLocalization({
	YellBomb	= "Сгиньте в огне!",
	YellAdds	= "Где мои Наседки? Пора за яйца приниматься!"
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
	WarnSpirit	= "Show warning for Spirit phase",--Translate
	WarnNormal	= "Show warning for Normal phase"--Translate
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
	name = "Повелитель проклятий Малакрасс"
})

L:SetMiscLocalization({
	YellPull	= "На вас падет тень..."
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