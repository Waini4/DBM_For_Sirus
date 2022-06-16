local L

--Maulgar
L = DBM:GetModLocalization("Maulgar")

L:SetGeneralLocalization{
	name = "Король Молгар"
}

L:SetTimerLocalization{
	TimerWhirl = "Вихрь!",
	timerActive = "%s активен"
}

L:SetWarningLocalization{
	WarnMight = "%s активен",
	Move = "%s отойдите!",
	KickNow = "Прерывание %s"
}

L:SetOptionLocalization{
	WarnMight = "Обявлять активацию минибоссов",
	Move = "Обявлять опасные способности для милизоны",
	AnnounceToChat = "Анонсировать об активации в чат",
	KickNow = "Обявлять прерывание заклинания",
	TimerWhirl = "Отсчитывать время до окончания вихря"
}

L:SetMiscLocalization{
}

--Gruul
L = DBM:GetModLocalization("Gruul")

L:SetGeneralLocalization{
	name = "Груул Драконобой"
}

L:SetTimerLocalization{
	Strike = "Хлопок!",
	TimerFurnaceActive = "Печь активна",
	TimerFurnaceInactive = "Печь не активна",
	TimerBurnedFlesh = "Обожженная плоть (х2 урон)"
}

L:SetWarningLocalization{

}

L:SetOptionLocalization{
	Strike = "Отсчет времени до хлопка",
	TimerFurnaceActive = "Отсчет времени пока печь активна",
	TimerFurnaceInactive = "Отсчет времени пока печь не активна",
	TimerBurnedFlesh = "Отсчет времени пока длится х2 урон по боссу"
}

L:SetMiscLocalization{
}
