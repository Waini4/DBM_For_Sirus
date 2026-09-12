if GetLocale() ~= "ruRU" then return end
local L

-----------------
--  Najentus  --
-----------------
L = DBM:GetModLocalization("Najentus")

L:SetGeneralLocalization({
	name = "Верховный Полководец Надж'ентус"
})

L:SetOptionLocalization({
	RangeFrame = "Show range frame (10)" --Translate
})

----------------
-- Supremus --
----------------
L = DBM:GetModLocalization("Supremus")

L:SetGeneralLocalization({
	name = "Супремус"
})

L:SetWarningLocalization({
	WarnPhase     = "%s Phase",    --Translate
	WarnPhaseSoon = "%s Phase in 10", --Translate
	WarnKite      = "Gaze on >%s<" --Translate
})

L:SetTimerLocalization({
	TimerPhase = "Next %s phase" --Translate
})

L:SetOptionLocalization({
	WarnPhase     = "Show warning for next phase",                   --Translate
	WarnPhaseSoon = "Show pre-warning for next phase",               --Translate
	WarnKite      = "Announce Kite targets",                         --Translate
	TimerPhase    = "Show time for next phase",                      --Translate
	KiteIcon      = "Set icon on Kite target",                       --Translate
	KiteWhisper   = "Send whisper to Kite target (requires Raid Leader)" --Translate
})

L:SetMiscLocalization({
	PhaseTank    = "в гневе ударяет по земле!", --Check if Backwards
	PhaseKite    = "Земля начинает раскалываться!", --Check if Backwards
	ChangeTarget = "атакует новую цель!",
	Kite         = "Kite", --Translate
	Tank         = "Tank" --Translate
})

-------------------------
--  Shape of Akama  --
-------------------------
L = DBM:GetModLocalization("Akama")

L:SetGeneralLocalization({
	name = "Тень Акамы"
})

L:SetWarningLocalization({
	WeaponsStatus = "Cнятие оружий включено"
})

L:SetOptionLocalization({
	EqUneqWeapons =
	"Снимать/надевать оружия если в вас кастанулся контроль. Для надевания создайте компл. экип. 'pve'. Для снятия не нужен.",
	EqUneqTimer   = "Снимать оружия по таймеру ВСЕГДА, а не в каст(если высокий пинг). Опция выше должна быть вкл.",
	BlockWeapons  = "Полностью заблокировать функции снятия/надевания выше",
	RaidSay       = "Оповещение о несбитом касте в Рейд чат"
})

L:SetMiscLocalization({
	SummonPepel = "Один из Пеплоустов-чаротворцев выходит из транса и вступает в бой!",
	Groz        = "Пеплоуст-грозоборец",
	Ciao        = "Пеплоуст-чаротворец",
	Dusha       = "Пеплоуст-душелов",
	CrisaTH     = "Пеплоуст-разбойник",
	GigaChad    = "Пеплоуст-защитник",
	YellKill    = "Сломленные из племени Пеплоустов, ваш предводитель говорит!"
})

-------------------------
--  Teron Gorefiend  --
-------------------------
L = DBM:GetModLocalization("TeronGorefiend")

L:SetGeneralLocalization({
	name = "Терон Кровожад"
})

L:SetTimerLocalization({
	TimerVengefulSpirit = "Ghost : %s" --Translate
})

L:SetOptionLocalization({
	TimerVengefulSpirit = "Show timer for Ghost durations", --Translate
	RaidTimer           = "Таймер для всего рейда о начале боя и фазах"
})

L:SetMiscLocalization({
	CamStart =
	"Я был первым. Колесо моей жизни сделало уже не один оборот. Столько времени прошло... Мне нужно столько наверстать."
})
----------------------------
--  Gurtogg Bloodboil  --
----------------------------
L = DBM:GetModLocalization("Bloodboil")

L:SetGeneralLocalization({
	name = "Гуртогг Кипящая Кровь"
})

L:SetWarningLocalization({
	WarnRageEnd = "Fel Rage End", --Translate
})

L:SetTimerLocalization({
	TimerRageEnd = "Fel Rage End" --Translate
})

L:SetOptionLocalization({
	WarnRageEnd  = "Show warning for $spell:40604 ends", --Translate
	TimerRageEnd = "Show timer for $spell:40604 ends" --Translate
})

--------------------------
--  Essence Of Souls  --
--------------------------
L = DBM:GetModLocalization("EssenceOfSouls")

L:SetGeneralLocalization({
	name = "Воплощение Душ"
})

L:SetWarningLocalization({
	WarnEnrage     = "Озверение",
	WarnEnrageSoon = "Озверение скоро",
	WarnEnrageEnd  = "Озверение закончилось",
	WarnMana       = "Ноль маны через 30 сек"
})

L:SetTimerLocalization({
	TimerEnrage     = "Озверение",
	TimerNextEnrage = "Next Озверение", --Translate
	TimerMana       = "Mana 0" --Translate
})

L:SetOptionLocalization({
	WarnEnrage      = "Show warning for Enrage",                              --Translate
	WarnEnrageSoon  = "Show pre-warning for Enrage",                          --Translate
	WarnEnrageEnd   = "Show warning when Enrage ends",                        --Translate
	WarnMana        = "Show warning from zero mana in Phase 2",               --Translate
	TimerEnrage     = "Show timer for Enrage",                                --Translate
	TimerNextEnrage = "Show timer for next Enrage",                           --Translate
	TimerMana       = "Show timer for zero mana in Phase 2",                  --Translate
	SpiteWhisper    = "Send whisper to $spell:41376 targets (requires Raid Leader)" --Translate
})

L:SetMiscLocalization({
	Enrage       = "%s впадает в ярость!",
	SpiteWhisper = "Злоба на Вас!",
	Suffering    = "Воплощение Страдания", --Translate
	Desire       = "Воплощение Желания", --Translate
	Anger        = "Воплощение Гнева" --Translate
})

-----------------------
--  Mother Shahraz --
-----------------------
L = DBM:GetModLocalization("Shahraz")

L:SetGeneralLocalization({
	name = "Матушка Шахраз"
})

L:SetOptionLocalization({
	PassionThreshold = "Предупреждение на стаках - %d" --Translate
})
----------------------
--  Illidari Council  --
----------------------
L = DBM:GetModLocalization("Council")

L:SetGeneralLocalization({
	name = "Совет Иллидари"
})

L:SetWarningLocalization({
	WarnFadeSoon = "Исчезновение исчезнет через 5 сек",   --Translate
	WarnFaded    = "Исчезновение исчезло",            --Translate
	WarnDevAura  = "Аура Преданности на 30 сек", --Translate
	WarnResAura  = "Аура Сопротивления на 30 сек", --Translate
	Immune       = "Маланда - %s неуязвима в течение 15 сек" --Translate
})

L:SetOptionLocalization({
	WarnFadeSoon = "Показать предупреждение за 5 секунд до исчезновения $spell:41476", --Translate
	WarnFaded    = "Показать предупреждение, когда $spell:41476 исчезнет",            --Translate
	WarnDevAura  = "Показать предупреждение для $spell:41452",                   --Translate
	WarnResAura  = "Показать предупреждение для $spell:41453",                   --Translate
	Immune       = "Показать предупреждение, когда Маланда становится неуязвимой к заклинаниям или атакам в ближнем бою", --Translate
	RaidReportHeal   = "Оповещение о хилке в рейд"
})

L:SetMiscLocalization({
	Gathios       = "Гатиос Изувер",
	Malande       = "Леди Маланда",
	Zerevor       = "Верховный пустомант Зеревор",
	Veras         = "Верас Глубокий Мрак",
	Melee         = "Ближний бой",             --Translate
	Spell         = "Заклинание",             --Translate
	PoisonWhisper = "Смертельный яд на вас!" --Translate
})

-------------------------
--  Illidan Stormrage --
-------------------------
L = DBM:GetModLocalization("Illidan")

L:SetGeneralLocalization({
	name = "Иллидан Ярость Бури"
})

L:SetWarningLocalization({
	WarnPhase2Soon = "Фаза 2 скоро",
	WarnPhase4Soon = "Фаза 4 скоро",
	WarnHuman      = "Обычная Фаза",
	WarnHumanSoon  = "Обычная Фаза скоро",
	WarnDemon      = "Демона Фаза",
	WarnDemonSoon  = "Демона Фаза скоро"
})

L:SetTimerLocalization({
	TimerNextHuman   = "Следующая Обычная Фаза", --Translate
	TimerNextDemon   = "Следующая Демона Фаза", --Translate
	TimerChangeForm  = "Смена Формы" --Translate
})

L:SetOptionLocalization({
	WarnPhase2Soon   = "Show pre-warning for Phase 2 transition (at ~75%)", --Translate
	WarnPhase4Soon   = "Show pre-warning for Phase 4 transition (at ~35%)", --Translate
	WarnHuman        = "Предупреждение до Обычной Фазы",                 --Translate
	WarnHumanSoon    = "Предупреждение до Обычной Фазы скоро",             --Translate
	WarnDemon        = "Предупреждение до Демона Фазы",                 --Translate
	WarnDemonSoon    = "Предупреждение до Демона Фазы скоро",             --Translate
	TimerNextHuman   = "Показать время для следующей Обычной Фазы",               --Translate
	TimerNextDemon   = "Показать время для следующей Демона Фазы",              --Translate
	RangeFrame       = "Show range frame (10 yards) in Phase 3 and 4",  --Translate
	RaidReportHeal   = "Оповещение о хилке в рейд"
})

L:SetMiscLocalization({
	Pull            = "Акама. Я не удивлен твоей двуличностью. Давно нужно было убить тебя и твоих мерзких прихвостней.",
	Pullf          = "Твое правление окончено, Иллидан. Мой народ – и все Запределье – будут свободны!",
	Eyebeam         = "Посмотри в глаза Предателя!",
	Demon           = "Узрите силу... истинного демона!",
	End				= "Вы не готовы!",
	Phase4          = "Это все, смертные? Это и есть вся ваша ярость?",
	ParasiteWhisper = "Теневые создания на вас!" --Translate
})
--23:07:23-23:08:01