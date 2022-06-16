if GetLocale() ~= "ruRU" then return end

local L


L = DBM:GetModLocalization("Gogonash")

L:SetGeneralLocalization{
	name = "Гогонаш"
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
	SetIconMarkofFilthTargets  		= "Устанавливать иконки на цели $spell:317544",
	AnnounceMarkofFilth  			= "Объявлять игроков, на кого установлена $spell:317544, в рейд чат ",
	BossHealthFrame					= "Показывать здоровье босса"
}

L:SetMiscLocalization{
	MarkofFilthIcon	= "Метка скверны {rt%d} установлена на: %s"
}


L = DBM:GetModLocalization("Ctrax")

L:SetGeneralLocalization{
	name = "Ктракс"
}

L:SetTimerLocalization{
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
	BossHealthFrame					= "Показывать здоровье босса",
	PowerPercent					= "Энергия босса"
}

L:SetMiscLocalization{
	PowerPercent					="Энергия босса"
}

L = DBM:GetModLocalization("MagicEater")

L:SetGeneralLocalization{
	name = "Пожиратель магии"
}

L:SetMiscLocalization{
}
