if GetLocale() ~= "ruRU" then return end

local L

--Maulgar
L = DBM:GetModLocalization("Maulgar")

L:SetGeneralLocalization({
	name = "Король Молгар"
})
L:SetMiscLocalization({
	Maulgar						= "Мулгар",
	Olm							= "Олм",
	Krosh						= "Крош",
	Blindeye					= "Слепоглаз",
	BlindeyeHeroic				= "Слепоглаз героический",
	Heroic						= "Героический режим"
})
L:SetOptionLocalization({
	RangeFireBomb				= "Фрейм дистанции для $spell:305236",
	WarnMight					= "Обьявлять активированных чемпионов"
})
L:SetWarningLocalization({
	warnMight					= "|3-3(>%s<) Активировался!"
})


--Gruul the Dragonkiller
L = DBM:GetModLocalization("Gruul")

L:SetGeneralLocalization({
	name = "Груул Драконобой"
})

L:SetTimerLocalization{
	Strike 						= "Хлопок!",
	TimerFurnaceActive 			= "Печь активна",
	TimerFurnaceInactive 		= "Печь не активна",
	TimerBurnedFlesh 			= "Обожженная плоть (х2 урон)"
	
}

L:SetMiscLocalization({
	Normal						= "Обычный режим",
	Heroic						= "Героический режим"
})

L:SetWarningLocalization({
	WarnGrowth	= "%s (%d)",
	Hands						="Руки появились!"
})

L:SetOptionLocalization({
	WarnGrowth					= "Показывать предупреждение для $spell:36300",
	RangeDistance				= "Фрейм дистанции для $spell:33654",
	Smaller						= "Маленькая дистанция (11)",
	Safe						= "Безопасная дистанция (18)",
	Strike 						= "Отсчет времени до хлопка",
	TimerFurnaceActive 			= "Отсчет времени пока печь активна",
	TimerFurnaceInactive 		= "Отсчет времени пока печь не активна",
	TimerBurnedFlesh 			= "Отсчет времени пока длится х2 урон по боссу",
	Blow 						= "Отсчет до Ошеломляющего удара",
	Hate						= "Отсчет до Удара ненависти",
	HandsOption 				= "Анонс появления рук"

})