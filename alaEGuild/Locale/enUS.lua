--[[--
	alex@0
--]]--
----------------------------------------------------------------------------------------------------
local ADDON, NS = ...;
NS.L = NS.L or {};
local L = NS.L;

if L.Locale ~= nil and L.Locale ~= "" then return;end
L.Locale = "enUS";


L.DBIcon_Text = "alaEGuild";

L.online = "Online";
L.year = "y";
L.month = "m";
L.day = "d";
L.hour = "h";
L.lessThanOneHour = "Less than 1h";
L.elements = {
	level = "Lv",
	class = "Class",
	name = "Name",
	online = "LastOnline",
	zone = "Zone",
	rank = "Rank",
	note = "Note",
	oNote = "OfficerNote",
};
L.sortLabel = {
	level = "Lv",
	class = "Class",
	name = "Name",
	online = "LastOnline",
	zone = "Zone",
	rank = "Rank",
};
L.info = {
	level = "Level\n\nBlank for unlimited",
	class = "Class\n\nFuzzy Query, matched if containing string",
	name = "Name\n\nFuzzy Query, matched if containing string",
	online = "LastOnline\n\nBlank for unlimited",
	zone = "Zone\n\nFuzzy Query, matched if containing string",
	rank = "Rank\n\nGuildMaster = 0\nnext rank = 1\nand so on",
};
L.showOffLine = "Show offline members";
L.sumLabel_Shown = "Shown";
L.sumLabel_Online = "Online";
L.sumLabel_All = "Total";
L.lockButton = "Lock Window";
L.editBox_Ok = "OK";
L.editBox_Reset = "Reset";
L.filterButton = "Advanced Filter";
L.resetButton = "Reset All Filter";
L.closeButton = "Close Window";
L.uninviteAllFiltered = "Remove all matching players";
L.promoteAllFiltered = "Downgrade guild rank for all matching players";
L.demoteAllFiltered = "Upgrade guild rank for all matching players";
L.INVITE = "Invite";
L.COPY_NAME = "Copy name";
L.WHISPER = "Whisper";
L.INSPECT_TALENT = "Inspect talents";

BINDING_HEADER_ALAEGUILD = "alaEGuild"
BINDING_NAME_ALAEGUILD_TOGGLE = "Toggle On/Off"
