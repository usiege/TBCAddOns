-- /script print("hello, world")


--[[
可以处理的文件
.lua .xml .tga/.blp .wav/.mp3 .ttf .m2(3D objects)

wow提供了一个虚拟文件系统，使用户可以使用远程文件，就好像使用本地磁盘一样；
当启动客户端的时候，虚拟文件系统被创建，所以游戏不能识别新的文件直到你重启；
/script ReloadUI() or /reload(安装了DevTools);
虚拟文件系统读取根目录为wow安装目录，在其之外的路径将无法访问，合法的目录如下：
__classic__\Interface\*;
__classic__\*; //一般不这样做，插件相关放在Interface下；
--]]


-- /script PlaySoundFile("Sound/Creature/Illidan/BLACK_Illidan_04.wav")
-- /script PlaySoundFile("Interface/Musics/audio.mp3")

-- /script UIFrameFadeOut(Minimap, 1)
-- /script Minimap:SetAlpha(1)

print("hello, mod")
local _, addons = ...
Hello_Text = {}

SLASH_HELLO1 = "/hello"
SLASH_HELLO2 = "/hm"

SlashCmdList['HELLO'] = function ( msg )
	text = 'hello, ' .. msg
	-- print("hello, " .. msg)
	SendChatMessage(text, "SAY")
	if Hello_Text ~= nil then
		Hello_Text[msg:lower()] = text
	end 
end