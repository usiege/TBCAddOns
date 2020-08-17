--[[--
	alex@0
--]]--
----------------------------------------------------------------------------------------------------
local ADDON, NS = ...;
NS.L = NS.L or {};
local L = NS.L;

if GetLocale() ~= "zhTW" then return;end
L.Locale = "zhTW";


L.DBIcon_Text = "alaEGuild";

L.online = "在綫";
L.year = "年";
L.month = "月";
L.day = "天";
L.hour = "時";
L.lessThanOneHour = "小於1小時";
L.elements = {
	level = "等級",
	class = "職業",
	name = "名字",
	online = "最後上綫",
	zone = "地區",
	rank = "會階",
	note = "備注",
	oNote = "官員備注",
};
L.sortLabel = {
	level = "等級",
	class = "職業",
	name = "名字",
	online = "最後上綫",
	zone = "地區",
	rank = "會階",
};
L.info = {
	level = "等級範圍\n\n留空為不限制",
	class = "職業\n\n模糊查詢，包含字符串",
	name = "名字\n\n模糊查詢，包含字符串",
	online = "最後上綫時間\n\n留空為不限制",
	zone = "地區\n\n模糊查詢，包含字符串",
	rank = "會階\n\n從0開始\n會長 = 0\n下一級 = 1\n類推",
};
L.showOffLine = "顯示離綫成員";
L.sumLabel_Shown = "顯示";
L.sumLabel_Online = "在綫";
L.sumLabel_All = "全部";
L.lockButton = "鎖定窗體";
L.editBox_Ok = "確定";
L.editBox_Reset = "重置";
L.filterButton = "高級篩選";
L.resetButton = "重置所有篩選";
L.closeButton = "關閉窗體";
L.uninviteAllFiltered = "移除所有匹配玩家";
L.promoteAllFiltered = "給所有匹配玩家提升等級";
L.demoteAllFiltered = "給所有匹配玩家降低等級";
L.INVITE = "邀请组队";
L.COPY_NAME = "复制名字";
L.WHISPER = "悄悄话";
L.INSPECT_TALENT = "查询天赋";

BINDING_HEADER_ALAEGUILD = "alaEGuild"
BINDING_NAME_ALAEGUILD_TOGGLE = "開啓/關閉"
