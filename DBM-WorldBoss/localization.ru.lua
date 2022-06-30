if GetLocale() ~= "ruRU" then return end

local L

-- Норигорн
L = DBM:GetModLocalization("Norigorn")

L:SetGeneralLocalization {
	name = "Норигорн"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
}

L:SetMiscLocalization {
}
L:SetOptionLocalization {
}

L = DBM:GetModLocalization("Zort")

L:SetGeneralLocalization {
	name = "Зорт (Вне категории)"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
	KnopSv = "Нажмите кнопку (Разорвать связь!)",
	Hp1    = "ХП БОССА МЕНЬШЕ 73%",
	Hp2    = "ХП БОССА МЕНЬШЕ 43%",
	Hp3    = "4 ФАЗА 4 ФАЗА"
}

L:SetMiscLocalization {
	Pechat = "Печать: Предательство {rt%d} установлена на %s",
	Flame  = "Пламя Кошмаров {rt%d} установлена на %s",
	Razr   = "Разрываю цепь",
	Sveaz  = "Кошмарная цепь {rt%d} установлена на %s",
	Lic    = "Лик Зорта",
	Shup   = "Щупальце-плеть Зорта",
	Cudo   = "Чудовищное щупальце Зорта",
	Zort   = "Зорт",
	Tree   = "Чудовищные деревья"
}
L:SetOptionLocalization {
	SetIconOnSveazTarget = "Устанавливать метки на цели заклинания $spell:314606",
	SetIconOnFlameTarget = "Устанавливать метки на цели заклинания $spell:307839",
	AnnounceFlame        = "Объявлять игроков, на кого установлена метка $spell:307839, в рейд чат",
	RangeFrame           = "Показывать окно проверки дистанции(6/12/20)",
	AnnounceKnopk        = "Сказать в белый чат об нажитии кнопки",
	AnnounceOFF          = "Отключить оповещение о нажатии",
	AnnounceSveaz        = "Объявить игрока на которого установлена метка $spell:314606, в рейд чат",
}
