-- 
local _, ADDONS_SELF = ...

local L = setmetatable({}, {
		__index = function(table, key)
			if key then
				table[key] = tostring(key)
			end
			return tostring(key)
		end
	})

ADDONS_SELF.L = L


local locale = GetLocale()

if locale == 'enUs' then
	
elseif locale == 'zhCN' then
	L['title'] = 'Turst me'
	L['interface lock'] = '界面锁定'
	L['colse button'] = '关闭'

	L['basic introduce'] = '基本介绍'
	L['action prompt settings'] = '技能提示设置'
	L['career attribute equipments'] = '职业属性配装'
	L['wechat group'] = '职业微信群'

	L['addon introduce detial'] = [[插件介绍：\n
		
	]]
	L['update address']

end