local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("BigBrainTanking", "zhCN")
if not L then return end

-- Addon information
L["BigBrainTanking"] = "BigBrainTanking"
L["Version"] = "Version"
L["BBTEnabled"] = "|cff9933ffBigBrainTanking 已启用"
L["BBTDisabled"] = "|cff9933ffBigBrainTanking 已禁用"

-- Configuration frame name
L["BBT Option"] = "BigBrainTanking"

-- Configuration strings
L["Profiles"] = "配置文件"

L["GeneralSettings"] = "一般设置"
L["BBTDescription"] = [[
BigBrainTanking 是一个坦克助手插件,能帮助你警报各种坦克技能/物品,和其他一些便捷功能
]]

L["BBTDescriptionFooter"] = [[

|cffffd000自动拯救移除|cffffffff
插件可以自动从你身上移除拯救祝福（-30%仇恨）. 你可以使用“/bbt salv on”和“/bbt salv off”快速切换是否要删除它

|cffffd000自动技能警报|cffffffff
你可以设置警告,每当你的关键技能被抵制或miss时,或者当你使用打断技能或激活一个技能/物品时
]]
L["DebugSettings"] = "调试设置"
L["DebugDescription"] = "|cfff00000这些是开发人员的调试设置，除非你知道要做什么，否则不要更改它们"
L["EnableDebugPrint"] = "启用调试打印"
L["INSPIRED_BY"] = "Inspired by"

L["On"] = "On"
L["Off"] = "Off"

L["SlashCommand"] = "Slash Command"

-- General
L["EnableBBT"] = "启用 BigBrainTanking"
L["EnableBBTDescription"] = "启用或禁用 BigBrainTanking 插件"
L["OnDescription"] = "启用插件."
L["OffDescription"] = "禁用插件."
L["ABOUT_VERSION"] = "版本"
L["ABOUT_AUTHOR"] = "作者"
L["ABOUT_TRANSLATORS"] = "翻译"
L["ABOUT_TESTERS"] = "测试者"

-- Salvation 
L["EnableBBTSalvRemoval"] = "启用 拯救移除"
L["EnableBBTSalvRemovalDescription"] = "启用或禁用自动拯救移除功能"
L["SalvRemoved"] = "[BBT] 拯救已移除!"
L["SalvLock"] = "[BBT] cfff00000警告：在战斗中拯救祝福不能被移除!"
L["SalvRemovalOnDescription"] = "启用 拯救移除"
L["SalvRemovalOffDescription"] = "禁用 拯救移除"
L["SalvationCommand"] = "启用/禁用 自动拯救移除"
L["SalvRemovalEnabled"] = "[BBT] 自动拯救移除已启用!"
L["SalvRemovalDisabled"] = "[BBT] 自动拯救移除已禁用!"
L["SalvBuffName"] = "拯救祝福"

-- Warnings
L["WS_CUSTOM_CHANNELS_DESC"] = "输入逗号分隔的频道名称。 (如: 频道1, 频道2, 频道3)"
L["WS_ABILITIES"] = "技能"
L["WS_ITEMS"] = "物品"
L["WS_CUSTOM_CHANNELS"] = "自定义频道"
L["ANNOUNCEMENT_TEXT"] = "通告文本"
L["ANNOUNCEMENT_TEXT_MESSAGE"] = "消息"
L["ANNOUNCEMENT_TEXT_DESCRIPTION"] = [[

|cffffd000特殊符号|cffffffff
公告文本中可以包含特殊符号：

$tn - 目标名字 (包括raid标记)
$sn - 法术名字
$is - 被打断的法术名
$sd - 法术持续时间(秒)
$lshp - 破斧获得的血量
]]

L["AnnouncementSetup"] = "通告设置"
L["WarningSettings"] = "警报设置"
L["WarningSettingsDescription"] = [[
控制是否以及如何显示警告
]]
L["EnableBBTWarnings"] = "启用 警报"
L["EnableBBTWarningsDescription"] = "启用或禁用关于嘲讽抵抗、惩戒痛击未命中等的警告"

L["EnableBBTWarningsExpiration"] = "启用 过期警告"
L["EnableBBTWarningsExpirationDescription"] = "启用或禁用有关盾墙墙和破釜沉舟的过期警告通知"


L["ABILITY_LASTSTAND"] = "破釜沉舟"
L["ABILITY_SHIELDWALL"] = "盾墙"
L["ABILITY_CHALLENGINGSHOUT"] = "挑战怒吼"
L["ABILITY_TAUNT"] = "嘲讽"
L["ABILITY_MOCKINGBLOW"] = "惩戒痛击"
L["ABILITY_CHALLENGINGROAR"] = "挑战咆哮"
L["ABILITY_GROWL"] = "低吼"

--- Interrupts
L["ABILITY_SHIELDBASH"] = "盾击"
L["ABILITY_PUMMEL"] = "拳击"

--- Items
L["ITEM_LIFEGIVINGGEM"] = "生命宝石"

--[[ 
	Special text:
	
	$tn - target name (including mark)
	$sn - spell name
	$is - interrupted spell
	$sd - spell duration in seconds
	$lshp - last stand hp gained
--]]

--- Statuses
--L["ABILITY_ACTIVATED"] = "$sn activated!"
--L["ABILITY_RESISTED"] = "$tn resisted $sn!" -- "Core Hound {skull} resisted Taunt!"
L["ABILITY_EXPIRATION"] = "$sn 会在 $se 后消失!"
--L["ABILITY_INTERRUPT"] = "$tn's -$is- was interrupted by $sn!"

-- Announcments
L["ANNOUNCEMENT_TAUNT_HIT"] = "- 已嘲讽 $tn! - "
L["ANNOUNCEMENT_TAUNT_RESIST"] = "- $tn 抵抗了我的 $sn! -";
L["ANNOUNCEMENT_MB_HIT"] = "- 对 $sn 施放了 $tn! -";
L["ANNOUNCEMENT_MB_FAIL"] = "- 我的 $sn 对 $tn 施放失败! -";
L["ANNOUNCEMENT_PM_HIT"] = "$tn 的 -$is- 被 $sn 打断了!";
L["ANNOUNCEMENT_PM_MISS"] = "$sn 未命中 $tn!";
L["ANNOUNCEMENT_SB_HIT"] = "$tn 的 -$is- 被 $sn 打断了!!";
L["ANNOUNCEMENT_SB_MISS"] = "$sn 未命中 $tn!";
L["ANNOUNCEMENT_LS_ACTIVATION"] = "- 我激活了 $sn! $sd 秒后我会失去 $lshpHP! 加好我!-";
L["ANNOUNCEMENT_SW_ACTIVATION"] = "- 我激活了 $sn! $sd 秒内会降低75%的所有伤害! -";
L["ANNOUNCEMENT_LG_ACTIVATION"] = "- 我激活了生命宝石! $sd 秒后我会失去 $hpHP! 加好我!-";
L["ANNOUNCEMENT_CS_ACTIVATION"] = "- 我激活了 $sn! $sd 秒内我将大出血! 加好我!-";
L["ANNOUNCEMENT_GROWL_RESIST"] = "- $tn 抵抗了 $sn! -";
L["ANNOUNCEMENT_CR_ACTIVATION"] = "- 我激活了 $sn! $sd 秒内我将大出血! 加好我!-";
