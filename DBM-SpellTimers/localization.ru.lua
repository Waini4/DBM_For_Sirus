if GetLocale() ~= "ruRU" then
	return
end
local L = DBM_SpellsUsed_Translations

L.TabCategory_SpellsUsed = "Восст-ия заклинаний/навыков"
L.AreaGeneral            = "Основные настройки для восст. заклинаний/навыков"
L.Enabled                = "Включить таймеры восстановлений"
L.ShowLocalMessage       = "Показать локальное сообщение при применении"
L.OnlyFromRaid           = "Показывать восстановление только от участников рейда"
L.EnableInPVP            = "Показывать восстановления на полях боя"
L.EnablePortals          = "Показать длительность порталов"
L.Reset                  = "Сброс на по умолчанию"
L.Local_CastMessage      = "Обнаружено применение: %s"
L.AreaAuras              = "Настройки заклинаний/навыков"
L.SpellID                = "ID заклинания"
L.BarText                = "Текст (по умолчанию: %spell: %player)"
L.Cooldown               = "Восстановление"
L.Error_FillUp           = "Пожалуйста, заполните все поля перед добавлением нового"
L.AreaTitle_BarSetup1    = "Параметры индикатора"
L.Recovery               = "Осн бар восст. заклинаний"
L.Big                    = "Восст. заклинаний < 12c"
L.RecoveryMove           = "Перетащите (Осн бар восст. заклинаний)"
L.BigSmoke               = "Перетащите (Восст. заклинаний < 12c)"
L["%spell on %player"]	 = "%spell на %player"
L["%spell on %target"]	 = "%spell по %target"
L["%spell: %player on %target"] = "%spell: %player по %target"