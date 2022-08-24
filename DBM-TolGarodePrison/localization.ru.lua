if GetLocale() ~= "ruRU" then return end

local L


L = DBM:GetModLocalization("Gogonash")

L:SetGeneralLocalization {
	name = "Гогонаш"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
}

L:SetOptionLocalization {
	SetIconMarkofFilthTargets = "Устанавливать иконки на цели $spell:317544",
	BossHealthFrame           = "Показывать здоровье босса"
}

L:SetMiscLocalization {
	MarkofFilthIcon = "Метка скверны {rt%d} установлена на: %s"
}


L = DBM:GetModLocalization("Ctrax")

L:SetGeneralLocalization {
	name = "Поглотитель разума Ктракс"
}

L:SetTimerLocalization {
}

L:SetWarningLocalization {
	Immersion = "Бегите в теневой колодец!"
}

L:SetOptionLocalization {
	BossHealthFrame = "Показывать здоровье босса",
	PowerPercent    = "Энергия босса",
	Immersion       = "Спец-предупреждение 'Бегите в теневой колодец' при $spell:317604"
}

L:SetMiscLocalization {
	PowerPercent = "Энергия босса"
}

L = DBM:GetModLocalization("MagicEater")

L:SetGeneralLocalization {
	name = "Пожиратель магии"
}

L:SetMiscLocalization {
	Puk = "Пожиратель яростно клацает пастями!"
}
