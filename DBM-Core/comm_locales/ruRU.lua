if GetLocale() ~= "ruRU" then return end
if not DBM_COMMON_L then DBM_COMMON_L = {} end

local CL = DBM_COMMON_L

CL.NONE         = "Нет"
CL.RANDOM       = "Случайно"
CL.NEXT         = "След. %s"
CL.COOLDOWN     = "Восст. %s"
CL.UNKNOWN      = "неизвестно"
CL.LEFT         = "Налево"
CL.RIGHT        = "Направо"
CL.BOTH         = "Оба"
CL.BEHIND       = "Сзади"
CL.BACK         = "Назад"
CL.SIDE         = "Сторона"
CL.TOP          = "Верх"
CL.BOTTOM       = "Низ"
CL.MIDDLE       = "Середина"
CL.FRONT        = "Вперёд"
CL.EAST         = "Восток"
CL.WEST         = "Запад"
CL.NORTH        = "Север"
CL.SOUTH        = "Юг"
CL.INTERMISSION = "Переходная фаза" --No blizz global for this, and will probably be used in most end tier fights with intermission stages
CL.ORB          = "Сфера"
CL.ORBS         = "Сферы"
CL.RING         = "Кольцо"
CL.RINGS        = "Кольца"
CL.CHEST        = "сундука" --As in Treasure 'Chest'. Not Chest as in body part.
CL.NO_DEBUFF    = "Нет %s" --For use in places like info frame where you put "Not Spellname"
CL.ALLY         = "Союзник" --Such as "Move to Ally"
CL.ALLIES       = "Союзники" --Such as "Move to Allies"
CL.ADD          = "Адд" --A fight Add as in "boss spawned extra adds"
CL.ADDS         = "Адды"
CL.BIG_ADD      = "Большой адд"
CL.BOSS         = "Босс"
CL.ENEMIES      = "Противники"
CL.EDGE         = "Край комнаты"
CL.FAR_AWAY     = "Далеко"
CL.BREAK_LOS    = "Break LOS"
CL.RESTORE_LOS  = "Maintain LOS"
CL.SAFE         = "Безопасно"
CL.NOTSAFE      = "Не безопасно"
CL.SHIELD       = "Щит"
CL.PILLAR       = "Столп"
CL.SHELTER      = "Укрытие"
CL.INCOMING     = "Прибытие %s"
CL.BOSSTOGETHER = "Боссы вместе"
CL.BOSSAPART    = "Боссы отдельно"
CL.TANKCOMBO    = "Tank Combo"
CL.AOEDAMAGE    = "AoE урон"

local EJIconPath = "AddOns\\DBM-Core\\textures"
--Role Icons
CL.TANK_ICON     = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:6:21:7:27|t" -- NO TRANSLATE
CL.DAMAGE_ICON   = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:39:55:7:27|t" -- NO TRANSLATE
CL.HEALER_ICON   = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:70:86:7:27|t" -- NO TRANSLATE

CL.TANK_ICON_SMALL   = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:6:21:7:27|t" -- NO TRANSLATE
CL.DAMAGE_ICON_SMALL = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:39:55:7:27|t" -- NO TRANSLATE
CL.HEALER_ICON_SMALL = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:70:86:7:27|t" -- NO TRANSLATE
--Importance Icons
CL.HEROIC_ICON       = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:22:22:0:0:255:66:102:118:7:27|t" -- NO TRANSLATE
CL.DEADLY_ICON       = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:22:22:0:0:255:66:133:153:7:27|t" -- NO TRANSLATE
CL.IMPORTANT_ICON    = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:168:182:7:27|t" -- NO TRANSLATE
CL.MYTHIC_ICON       = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:22:22:0:0:255:66:133:153:40:58|t" -- NO TRANSLATE

CL.HEROIC_ICON_SMALL    = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:14:14:0:0:255:66:102:118:7:27|t" -- NO TRANSLATE
CL.DEADLY_ICON_SMALL    = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:14:14:0:0:255:66:133:153:7:27|t" -- NO TRANSLATE
CL.IMPORTANT_ICON_SMALL = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:168:182:7:27|t" -- NO TRANSLATE
--Type Icons
CL.INTERRUPT_ICON       = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:198:214:7:27|t" -- NO TRANSLATE
CL.MAGIC_ICON           = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:229:247:7:27|t" -- NO TRANSLATE
CL.CURSE_ICON           = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:6:21:40:58|t" -- NO TRANSLATE
CL.POISON_ICON          = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:39:55:40:58|t" -- NO TRANSLATE
CL.DISEASE_ICON         = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:70:86:40:58|t" -- NO TRANSLATE
CL.ENRAGE_ICON          = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:102:118:40:58|t" -- NO TRANSLATE
CL.BLEED_ICON           = "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:168:182:40:58|t" -- NO TRANSLATE

CL.RefreshedBefore = " обновлено перед исчезновением. Ожидаемое время : "
CL.PlsREport = ". Напишите на форум о этом баге"
