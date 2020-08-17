--[[--
	alex@0
--]]--
----------------------------------------------------------------------------------------------------
local ADDON, NS = ...;
NS.L = NS.L or {};
local L = NS.L;

if GetLocale() ~= "zhCN" then return;end
L.Locale = "zhCN";


L.DBIcon_Text = "alaEGuild";

L.online = "在线";
L.year = "年";
L.month = "月";
L.day = "天";
L.hour = "时";
L.lessThanOneHour = "小于1小时";
L.elements = {
	level = "等级",
	class = "职业",
	name = "名字",
	online = "最后上线",
	zone = "地区",
	rank = "会阶",
	note = "备注",
	oNote = "官员备注",
};
L.sortLabel = {
	level = "等级",
	class = "职业",
	name = "名字",
	online = "最后上线",
	zone = "地区",
	rank = "会阶",
};
L.info = {
	level = "等级范围\n\n留空为不限制",
	class = "职业\n\n模糊查询，包含字符串",
	name = "名字\n\n模糊查询，包含字符串",
	online = "最后上线时间\n\n留空为不限制",
	zone = "地区\n\n模糊查询，包含字符串",
	rank = "会阶\n\n从0开始\n会长=0\n下一级=1\n类推",
};
L.showOffLine = "显示离线成员";
L.sumLabel_Shown = "显示";
L.sumLabel_Online = "在线";
L.sumLabel_All = "全部";
L.lockButton = "锁定窗口";
L.editBox_Ok = "应用";
L.editBox_Reset = "重置";
L.filterButton = "高级筛选";
L.resetButton = "重置所有过滤";
L.closeButton = "关闭窗口";
L.uninviteAllFiltered = "移除所有匹配玩家";
L.promoteAllFiltered = "给所有匹配玩家的提升等级";
L.demoteAllFiltered = "给所有匹配玩家的降低等级";
L.INVITE = "邀请组队";
L.COPY_NAME = "复制名字";
L.WHISPER = "悄悄话";
L.INSPECT_TALENT = "查询天赋";

BINDING_HEADER_ALAEGUILD = "alaEGuild"
BINDING_NAME_ALAEGUILD_TOGGLE = "开启/关闭"
