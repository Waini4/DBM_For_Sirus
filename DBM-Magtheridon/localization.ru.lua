if GetLocale() ~= "ruRU" then return end

local L

--Magtheridon
L = DBM:GetModLocalization("Magtheridon")

L:SetGeneralLocalization{
	name 					= "Магтеридон "
}

L:SetTimerLocalization{
	Pull 					= "Активация босса"
}

L:SetWarningLocalization{

}

L:SetOptionLocalization{
	Pull 					= "Отсчет времени до активации босса"
}

L:SetMiscLocalization{
	YellPullAcolytes 		= "Сдерживающая сила |3-1(%s) начинает ослабевать!",
	YellPullShort 			= "|3-2(%s) удалось почти освободиться от пут!",
	YellPullAcolytes2		= "Вы думаете, что ваша жалкая магия будет удерживать меня вечно?",
	YellPhase2 				= "Меня так просто не возьмешь! Пусть стены темницы содрогнутся... и падут!",
	YellHand				= "Печать Магтеридона на мне!",
	YellHandfail			= "Я взорвал Печать Магтеридона!",
	YellPhase1				= "Я... свободен!",
	Heroic					= "Героический режим",
	Normal					= "Обычный режим",
	Quake					= "Сотрясение",
	General					= "Общее"
}

