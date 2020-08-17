local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("BigBrainTanking", "enUS", true)
if not L then return end

-- Addon information
L["BigBrainTanking"] = "BigBrainTanking"
L["Version"] = "Version"
L["BBTEnabled"] = "|cff9933ffBigBrainTanking addon enabled."
L["BBTDisabled"] = "|cff9933ffBigBrainTanking addon disabled."

-- Configuration frame name
L["BBT Option"] = "BigBrainTanking"

-- Configuration strings
L["Profiles"] = "Profiles"

L["GeneralSettings"] = "General Settings"
L["BBTDescription"] = [[
BigBrainTanking is an addon that is aimed to assist you with tanking chores.
]]

L["BBTDescriptionFooter"] = [[

|cffffd000Salvation|cffffffff
Addon is able to automatically remove Blessing of Salvation (-30% threat buff) from you. You can fast-toggle whether you want it removed or not with "/bbt salv on" and "/bbt salv off".

|cfff00000WARNING: Auto-removal does not function while in combat (Blizzard limitations)!|cffffffff

|cffffd000Warnings|cffffffff
You can setup warnings whenever your key abilities get resisted or missed, when you interrupt spell cast or activate an ability/item. Check out warning settings subcategory in addon's options. 
]]
L["DebugSettings"] = "Debug Settings"
L["DebugDescription"] = "|cfff00000These are debug settings for the developer, do NOT change them unless you know what you are doing."
L["EnableDebugPrint"] = "Enable debug printing"

L["INSPIRED_BY"] = "Inspired by"

L["On"] = "On"
L["Off"] = "Off"

L["SlashCommand"] = "Slash Command"

-- General
L["EnableBBT"] = "Enable BigBrainTanking"
L["EnableBBTDescription"] = "Enables or disables BigBrainTanking both now and also on login."
L["OnDescription"] = "Enables addon."
L["OffDescription"] = "Disables addon."
L["ABOUT_VERSION"] = "Version"
L["ABOUT_AUTHOR"] = "Author"
L["ABOUT_TRANSLATORS"] = "Translators"
L["ABOUT_TESTERS"] = "Testers"

-- Salvation 
L["EnableBBTSalvRemoval"] = "Enable Salvation removal"
L["EnableBBTSalvRemovalDescription"] = "Enables or disables automatic salvation removal."
L["SalvRemoved"] = "[BBT] Salvation removed!"
L["SalvLock"] = "[BBT] cfff00000WARNING: Salvation can't be removed in combat! It is on you!"
L["SalvRemovalOnDescription"] = "Enables salvation removal."
L["SalvRemovalOffDescription"] = "Disables salvation removal."
L["SalvationCommand"] = "Enable/Disable salvation removal"
L["SalvRemovalEnabled"] = "[BBT] Salvation removal enabled!"
L["SalvRemovalDisabled"] = "[BBT] Salvation removal disabled!"
L["SalvBuffName"] = "Blessing of Salvation"

-- Warnings
L["WS_CUSTOM_CHANNELS_DESC"] = "Enter comma separated channel names. (Example: channel1, channel2, channel3)"
L["WS_ABILITIES"] = "Abilities"
L["WS_ITEMS"] = "Items"
L["WS_CUSTOM_CHANNELS"] = "Custom channels"
L["ANNOUNCEMENT_TEXT"] = "Announcement text"
L["ANNOUNCEMENT_TEXT_MESSAGE"] = "Message"
L["ANNOUNCEMENT_TEXT_DESCRIPTION"] = [[

|cffffd000Special text|cffffffff
Announcement text can contain special sequences:

$tn - target name (includes raid mark)
$sn - spell name
$is - interrupted spell
$sd - spell duration in seconds
$lshp - Last Stand hp gained
]]

L["AnnouncementSetup"] = "Announcement Setup"
L["WarningSettings"] = "Warning Settings"
L["WarningSettingsDescription"] = [[
Control whether and how warnings should be shown.
]]
L["EnableBBTWarnings"] = "Enable warnings"
L["EnableBBTWarningsDescription"] = "Enables or disables warnings about taunt resists, mocking blow misses, etc."

L["EnableBBTWarningsExpiration"] = "Enable expiration warnings"
L["EnableBBTWarningsExpirationDescription"] = "Enables or disables expiration warning announcements about shield wall and last stand."


L["ABILITY_LASTSTAND"] = "Last Stand"
L["ABILITY_SHIELDWALL"] = "Shield Wall"
L["ABILITY_CHALLENGINGSHOUT"] = "Challenging Shout"
L["ABILITY_TAUNT"] = "Taunt"
L["ABILITY_MOCKINGBLOW"] = "Mocking Blow"
L["ABILITY_CHALLENGINGROAR"] = "Challenging Roar"
L["ABILITY_GROWL"] = "Growl"

--- Interrupts
L["ABILITY_SHIELDBASH"] = "Shield Bash"
L["ABILITY_PUMMEL"] = "Pummel"

--- Items
L["ITEM_LIFEGIVINGGEM"] = "Lifegiving Gem"


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
L["ABILITY_EXPIRATION"] = "$sn will expire in $se seconds!"
--L["ABILITY_INTERRUPT"] = "$tn's -$is- was interrupted by $sn!"

-- Announcments
L["ANNOUNCEMENT_TAUNT_HIT"] = "- Taunted $tn! - "
L["ANNOUNCEMENT_TAUNT_RESIST"] = "- $tn resisted $sn! -";
L["ANNOUNCEMENT_MB_HIT"] = "- Used $sn against $tn! -";
L["ANNOUNCEMENT_MB_FAIL"] = "- My $sn failed against $tn! -";
L["ANNOUNCEMENT_PM_HIT"] = "$tn's -$is- was interrupted by $sn!";
L["ANNOUNCEMENT_PM_MISS"] = "$sn missed against $tn!";
L["ANNOUNCEMENT_SB_HIT"] = "$tn's -$is- was interrupted by $sn!";
L["ANNOUNCEMENT_SB_MISS"] = "$sn missed against $tn!";
L["ANNOUNCEMENT_LS_ACTIVATION"] = "- I activated $sn! In $sd seconds I will lose $lshpHP! -";
L["ANNOUNCEMENT_SW_ACTIVATION"] = "- I activated $sn and will be taking 75% less damage for $sd seconds! -";
L["ANNOUNCEMENT_LG_ACTIVATION"] = "- I activated Lifegiving Gem! In $sd seconds I will lose $hpHP! -";
L["ANNOUNCEMENT_CS_ACTIVATION"] = "- I activated $sn! I will need a lot of healing for $sd seconds! -";
L["ANNOUNCEMENT_GROWL_RESIST"] = "- $tn resisted $sn! -";
L["ANNOUNCEMENT_CR_ACTIVATION"] = "- I activated $sn! I will need a lot of healing for $sd seconds! -";

