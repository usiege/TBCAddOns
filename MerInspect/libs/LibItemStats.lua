
---------------------------------
-- 經典版物品屬性统计 Author: M
---------------------------------

local MAJOR, MINOR = "LibItemStats.1000", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

local locale = GetLocale()

--Toolip
local tooltip = CreateFrame("GameTooltip", "ClassicLibItemStatsTooltip1", UIParent, "GameTooltipTemplate")
local unittip = CreateFrame("GameTooltip", "ClassicLibItemStatsTooltip2", UIParent, "GameTooltipTemplate")

local strfind  = string.find
local strmatch = string.match
local strupper = string.upper
local tinsert  = table.insert
local strsplit = strsplit

--匹配规则 (规则来自我当年写的MerInspect,年代久远估计有些正则不适用了)
local patterns = {
	ignore = {
		{ zhTW = "^使用",            zhCN = "^使用" },
		{ zhTW = "^擊中時可能",      zhCN = "^击中时可能" },
		{ zhTW = "寵物的攻擊強度",   zhCN = "宠物的攻击强度" },
	},
    multiple = {
        { key1 = "Healing", key2 = "SpellDamage", zhTW = "%+(%d+)治療和%+(%d+)法術傷害(.*)", zhCN = "%+(%d+)治疗和%+(%d+)法术伤害(.*)" },
    },
	recursive = {
		{ zhTW = "(%+%d+.-)和(.+)",  zhCN = "(%+%d+.-)，(%+%d+.+)" },
		{ zhTW = "(初級速度)和(.+)", zhCN = "(初级速度)和(.+)" },
		{ zhTW = "^(.-)及(.+)",      zhCN = "^(.-)及(.+)" },
		{ zhTW = "^(.-)/(.+)",       zhCN = "^(.-)/(.+)" },
	},
	general = {
		{ key = "Armor",     zhTW = "護甲$",  zhCN = "护甲" },
		{ key = "Stamina",   zhTW = "耐力",   zhCN = "耐力" },
		{ key = "Agility",   zhTW = "敏捷",   zhCN = "敏捷" },
		{ key = "Strength",  zhTW = "力量",   zhCN = "力量" },
		{ key = "Intellect", zhTW = "智力",   zhCN = "智力" },
		{ key = "Spirit",    zhTW = "精神",   zhCN = "精神" },
		{ key = "hp",        zhTW = "生命力$", zhCN = "生命值$" },
		{ key = "mp",        zhTW = "法力$", zhCN = "法力值$" },
		{ key = "Resilience", zhTW = "韌性等級", zhCN = "韧性等级" },		
		{ key = "Stamina|Agility|Strength|Intellect|Spirit", zhTW = "所有屬性", zhCN = "所有属性" },
		{ key = "ManaRestore", zhTW = "法力恢復", zhCN = "法力恢复" },
		{ key = "ManaRestore", zhTW = "法力回復", zhCN = "法力回复" },
		{ key = "Resistance_Frost",  zhTW = "冰霜抗性", zhCN = "冰霜抗性" },
		{ key = "Resistance_Shadow", zhTW = "暗影抗性", zhCN = "暗影抗性" },
		{ key = "Resistance_Arcane", zhTW = "祕法抗性", zhCN = "奥术抗性" },
		{ key = "Resistance_Fire",   zhTW = "火焰抗性", zhCN = "火焰抗性" },
		{ key = "Resistance_Nature", zhTW = "自然抗性", zhCN = "自然抗性" },
		{ key = "Resistance_Holy",   zhTW = "神聖抗性", zhCN = "神圣抗性" },
		{ key = "Resistance_Frost|Resistance_Shadow|Resistance_Arcane|Resistance_Fire|Resistance_Nature|Resistance_Holy", zhTW = "所有抗性", zhCN = "所有抗性" },
		
		{ key = "Damage_Frost",  zhTW = "冰霜法術傷害", zhCN = "冰霜法术伤害" },
		{ key = "Damage_Shadow", zhTW = "暗影法術傷害", zhCN = "暗影法术伤害" },
		{ key = "Damage_Arcane", zhTW = "祕法法術傷害", zhCN = "奥术法术伤害" },
		{ key = "Damage_Fire",   zhTW = "火焰法術傷害", zhCN = "火焰法术伤害" },
		{ key = "Damage_Nature", zhTW = "自然法術傷害", zhCN = "自然法术伤害" },
		{ key = "Damage_Holy",   zhTW = "神聖法術傷害", zhCN = "神圣法术伤害" },
		{ key = "Damage_Shadow", zhTW = "陰影法術傷害", zhCN = "阴影法术伤害" },
		
        --魔杖
		{ key = "Damage_Frost",  zhTW = "冰霜傷害", zhCN = "冰霜伤害" },
		{ key = "Damage_Shadow", zhTW = "暗影傷害", zhCN = "暗影伤害" },
		{ key = "Damage_Arcane", zhTW = "祕法傷害", zhCN = "奥术伤害" },
		{ key = "Damage_Fire",   zhTW = "火焰傷害", zhCN = "火焰伤害" },
		{ key = "Damage_Nature", zhTW = "自然傷害", zhCN = "自然伤害" },
		{ key = "Damage_Holy",   zhTW = "神聖傷害", zhCN = "神圣伤害" },
		
		{ key = "SpellDamage",         zhTW = "傷害法術",         zhCN = "伤害法术" },
		{ key = "SpellDamage|Healing", zhTW = "法術傷害和治療",   zhCN = "法术伤害和治疗" },
		{ key = "SpellDamage|Healing", zhTW = "法術治療和傷害",   zhCN = "法术治疗和伤害" },
		{ key = "SpellDamage|Healing", zhTW = "法術能量",         zhCN = "法术能量" },
		{ key = "SpellDamage|Healing", zhTW = "法術傷害",         zhCN = "法术伤害" },
		{ key = "SpellStrike",         zhTW = "法術穿透力",       zhCN = "法术穿透" },
		{ key = "SpellHitRating",      zhTW = "法術命中等級",     zhCN = "法术命中等级" },
		{ key = "SpellCrit",           zhTW = "法術致命一擊等級", zhCN = "法术爆击等级" },
		
		{ key = "Healing", zhTW = "法術治療", zhCN = "法术治疗" },
		{ key = "Healing", zhTW = "治療法術", zhCN = "治疗法术" },
		{ key = "Healing", zhTW = "治療",     zhCN = "治疗" },
		
		{ key = "Dodge",   zhTW = "閃躲等級", zhCN = "躲闪等级" },
		{ key = "Parry",   zhTW = "招架等級", zhCN = "招架等级" },
		{ key = "defense", zhTW = "防禦等級", zhCN = "防御等级" },
		{ key = "HitRating", zhTW = "命中等級", zhCN = "命中等级" },
		{ key = "RangedAttackPower", zhTW = "遠程攻擊強度", zhCN = "远程攻击强度" },		
		{ key = "AttackCrit|RangedAttackCrit", zhTW = "致命一擊等級", zhCN = "爆击等级" },		
		{ key = "AttackPower|RangedAttackPower", zhTW = "攻擊強度", zhCN = "攻击强度" },
		{ key = "Block", zhTW = "格擋等級", zhCN = "格挡等级" },
		{ key = "Block", zhTW = "格擋值", zhCN = "格挡值" },
	},
	extra = {
		--抵抗恐懼效果的機率提高5%		
		{ key = "Armor", zhTW = "(%d+)點護甲$", zhCN = "(%d+)点护甲$" },
		{ key = "Block", zhTW = "(%d+)格擋$", zhCN = "(%d+)格挡$" },
		{ key = "ManaRestore", zhTW = "每5秒恢復(%d+)點法力", zhCN = "每5秒恢复(%d+)点法力" },
		{ key = "ManaRestore", zhTW = "每5秒法力回复%+(%d+)", zhCN = "每5秒法力回复%+(%d+)" },
		{ key = "Resilience", zhTW = "韌性等級提高(%d+)", zhCN = "韧性等级提高(%d+)" },
		{ key = "SpellHitRating", zhTW = "提高法術命中等級(%d+)", zhCN = "法术命中等级提高(%d+)" },
		{ key = "HasteSpell", zhTW = "提高法術加速等級(%d+)", zhCN = "法术急速等级提高(%d+)" },
		{ key = "SpellCrit", zhTW = "提高法術致命一擊等級(%d+)", zhCN = "法术爆击等级提高(%d+)" },
		{ key = "SpellStrike", zhTW = "法術穿透力提高(%d+)", zhCN = "法术穿透提高(%d+)" },		
		{ key = "SpellDamage|Healing", zhTW = "所有法術和魔法效果所造成的傷害和治療效果提高最多(%d+)", zhCN = "所有法术和魔法效果所造成的伤害和治疗效果，最多(%d+)", },
		{ key = "SpellDamage|Healing", zhTW = "所有法術和魔法效果所造成的傷害和治療效果提高最多(%d+)", zhCN = "使法术和魔法效果的治疗和伤害提高最多(%d+)", },
		{ key = "Healing", extra = 0.33, zhTW = "法術和魔法效果所造成的治療效果提高最多(%d+)", zhCN = "使法术治疗提高最多(%d+)", },
		{ key = "Damage_Frost", zhTW = "冰霜法術和效果所造成的傷害提高最多(%d+)", zhCN = "冰霜法术和效果所造成的伤害，最多(%d+)" },
		{ key = "Damage_Shadow", zhTW = "暗影法術和效果所造成的傷害提高最多(%d+)", zhCN = "暗影法术和效果所造成的伤害，最多(%d+)" },
		{ key = "Damage_Arcane", zhTW = "祕法法術和效果所造成的傷害提高最多(%d+)", zhCN = "奥术法术和效果所造成的伤害，最多(%d+)" },
		{ key = "Damage_Fire", zhTW = "火焰法術和效果所造成的傷害提高最多(%d+)", zhCN = "火焰法术和效果所造成的伤害，最多(%d+)" },
		{ key = "Damage_Nature", zhTW = "自然法術和效果所造成的傷害提高最多(%d+)", zhCN = "自然法术和效果所造成的伤害，最多(%d+)" },
		{ key = "Damage_Holy", zhTW = "神聖法術和效果所造成的傷害提高最多(%d+)", zhCN = "神圣法术和效果所造成的伤害，最多(%d+)" },
		{ key = "HasteMelee", zhTW = "提高加速等級(%d+)", zhCN = "急速等级提高(%d+)" },
		{ key = "RangedAttackPower", zhTW = "提高遠程攻擊強度(%d+)", zhCN = "远程攻击强度提高(%d+)" },		
		{ key = "AttackCrit|RangedAttackCrit", zhTW = "提高致命一擊等級(%d+)", zhCN = "爆击等级提高(%d+)" },		
		{ key = "AttackPower|RangedAttackPower", zhTW = "提高攻擊強度(%d+)", zhCN = "攻击强度提高(%d+)" },
		{ key = "HitRating", zhTW = "提高命中等級(%d+)", zhCN = "命中等级提高(%d+)" },
		{ key = "Parry", zhTW = "招架等級提高(%d+)", zhCN = "招架等级提高(%d+)" },
		{ key = "defense", zhTW = "提高防禦等級(%d+)", zhCN = "防御等级提高(%d+)" },
		{ key = "Dodge", zhTW = "閃躲等級提高(%d+)", zhCN = "躲闪等级提高(%d+)" },
		{ key = "Block", zhTW = "盾牌的格擋值提高(%d+)", zhCN = "盾牌格挡值提高(%d+)" },
		{ key = "Block", zhTW = "格擋等級提高(%d+)", zhCN = "格挡等级提高(%d+)" },
		{ key = "Block", zhTW = "盾牌格擋等級(%d+)", zhCN = "盾牌格挡等级(%d+)" },
		{ key = "ReduceResistance", zhTW = "使你法術目標的魔法抗性降低(%d+)點。", zhCN = "使你的法术目标的魔法抗性降低(%d+)点。" },
		{ key = "SpellHitRating", zhTW = "法術命中等級提高(%d+)", zhCN = "提高法术命中等级(%d+)" },
		{ key = "SpellCrit", zhTW = "法術致命一擊等級提高(%d+)", zhCN = "提高法术爆击等级(%d+)" },
		{ key = "RangedAttackPower", zhTW = "遠程攻擊強度提高(%d+)", zhCN = "提高远程攻击强度(%d+)" },		
		{ key = "AttackCrit|RangedAttackCrit", zhTW = "致命一擊等級提高(%d+)", zhCN = "提高爆击等级(%d+)" },		
		{ key = "AttackPower|RangedAttackPower", zhTW = "攻擊強度提高(%d+)", zhCN = "提高攻击强度(%d+)" },
		{ key = "HitRating", zhTW = "命中等級提高(%d+)", zhCN = "提高命中等级(%d+)" },
		{ key = "Parry", zhTW = "提高招架等級(%d+)", zhCN = "提高招架等级(%d+)" },
		{ key = "defense", zhTW = "防禦等級提高(%d+)", zhCN = "提高防御等级(%d+)" },
		{ key = "Dodge", zhTW = "提高閃躲等級(%d+)", zhCN = "提高躲闪等级(%d+)" },
	},
    percent = {
		{ key = "SpellDamage", baseon = "Intellect", zhTW = "法術所造成的傷害提高相當於你總智力的(%d+)%%", zhCN = "法术伤害加成提高,数值最多相当于你的智力总值的(%d+)%%" },
	},
	special = {
		{ key = "Damage_Shadow|Damage_Frost", value = 54, zhTW = "靈魂冰霜$", zhCN = "灵魂冰霜$" },
		{ key = "Damage_Fire|Damage_Arcane", value = 50, zhTW = "烈日火焰$", zhCN = "烈日火焰$" },
		{ key = "Resistance_Coma", value = 5, zhTW = "昏迷抗性", zhCN = "昏迷抗性" },
		{ key = "ManaRestore|HealthRestore", value = 4, zhTW = "活力$", zhCN = "活力$" },
		{ key = "AttackPower|RangedAttackPower", value = 70, zhTW = "野性$", zhCN = "野蛮$" },		
		{ key = "MountSpeed", value = 4, zhTW = "秘銀馬刺", zhCN = "秘银马刺" },
		{ key = "MountSpeed", value = 2, zhTW = "坐騎移動速度略微提升", zhCN = "坐骑移动速度略微提升" },
		{ key = "MountSpeed", value = 10, zhTW = "坐騎速度提高10%%", zhCN = "坐骑速度提高10%%" },
		{ key = "MountSpeed", value = 3, zhTW = "坐騎速度提高3%%", zhCN = "坐骑速度提高3%%" },
		{ key = "RunSpeed", value = 8, zhTW = "略微提高移動速度", zhCN = "略微提高移动速度" },
		{ key = "RunSpeed", value = 8, zhTW = "略微提高奔跑速度", zhCN = "略微提高奔跑速度" },
		{ key = "RunSpeed", value = 8, zhTW = "移動速度略微提升", zhCN = "移动速度略微提升" },
		{ key = "RunSpeed", value = 8, zhTW = "初級速度", zhCN = "初级速度" },		
		{ key = "SpellDamage|Healing", value = 42, zhTW = "超強巫師之油", zhCN = "超强巫师之油" },
		{ key = "SpellDamage|Healing", value = 16, zhTW = "次級巫師之油", zhCN = "次级巫师之油" },
		{ key = "SpellDamage|Healing", value = 8, zhTW = "初級巫師之油", zhCN = "初级巫师之油" },
		{ key = "SpellDamage|Healing", value = 24, zhTW = "巫師之油", zhCN = "巫师之油" },
		{ key = "ManaRestore", value = 14, zhTW = "超強法力之油", zhCN = "超强法力之油" },
		{ key = "ManaRestore", value = 12, continue = true, zhTW = "卓越法力之油", zhCN = "卓越法力之油" },
		{ key = "Healing", value = 24, continue = true, zhTW = "卓越法力之油", zhCN = "卓越法力之油" },
	},
}

--属性对照文字
local L = {
    Strength = { zhCN = "力量", zhTW = "力量" },
    Agility  = { zhCN = "敏捷", zhTW = "敏捷" },
    Stamina = { zhCN = "耐力", zhTW = "耐力" },
    Intellect = { zhCN = "智力", zhTW = "智力" },
    Spirit = { zhCN = "精神", zhTW = "精神" },
    Armor = { zhCN = "护甲", zhTW = "護甲" },
    Resilience = { zhCN = "韧性", zhTW = "韌性" },
    defense = { zhCN = "防御技能", zhTW = "防技" },
    Dodge = { zhCN = "躲闪几率", zhTW = "閃躲幾率" },
    Parry = { zhCN = "招架几率", zhTW = "招架幾率" },
    Block = { zhCN = "格挡几率", zhTW = "格擋幾率" },
    Resistance_Nature = { zhCN = "自然抗性", zhTW = "自然抗性" },
    Resistance_Fire = { zhCN = "火焰抗性", zhTW = "火焰抗性" },
    Resistance_Arcane = { zhCN = "奥术抗性", zhTW = "祕法抗性" },
    Resistance_Shadow = { zhCN = "暗影抗性", zhTW = "暗影抗性" },
    Resistance_Frost = { zhCN = "冰霜抗性", zhTW = "冰霜抗性" },
    Resistance_Holy = { zhCN = "神圣抗性", zhTW = "神聖抗性" },
    Resistance_Coma = { zhCN = "昏迷抵抗", zhTW = "昏迷抗性" },
    Damage_Nature = { zhCN = "自然伤害", zhTW = "自然傷害" },
    Damage_Fire = { zhCN = "火焰伤害", zhTW = "火焰傷害" },
    Damage_Arcane = { zhCN = "奥术伤害", zhTW = "祕法傷害" },
    Damage_Shadow = { zhCN = "暗影伤害", zhTW = "暗影傷害" },
    Damage_Frost = { zhCN = "冰霜伤害", zhTW = "冰霜傷害" },
    Damage_Holy = { zhCN = "神圣伤害", zhTW = "神聖傷害" },
    HitRating = { zhCN = "物理命中", zhTW = "物理命中" },
    AttackDamage = { zhCN = "近战伤害", zhTW = "近戰傷害" },
    AttackSpeed = { zhCN = "近战速度", zhTW = "近戰速度" },
    AttackPower = { zhCN = "近战强度", zhTW = "近戰強度" },
    AttackCrit = { zhCN = "近战爆击", zhTW = "近戰致命" },
    HasteMelee = { zhCN = "加速等级", zhTW = "加速等級" },
    RangedAttackDamage = { zhCN = "远程伤害", zhTW = "遠程傷害" },
    RangedAttackSpeed = { zhCN = "远程速度", zhTW = "遠程速度" },
    RangedAttackPower = { zhCN = "远程强度", zhTW = "遠程強度" },
    RangedAttackCrit = { zhCN = "远程爆击", zhTW = "遠程致命" },
    HasteRanged = { zhCN = "远程加速等级", zhTW = "遠程加速等級" },
    HasteSpell = { zhCN = "法术加速", zhTW = "法術加速" },
    SpellDamage = { zhCN = "法术伤害", zhTW = "法術傷害" },
    Healing = { zhCN = "治疗加成", zhTW = "治療加成" },
    SpellHitRating = { zhCN = "法术命中", zhTW = "法術命中" },
    SpellCrit = { zhCN = "法术爆击", zhTW = "法術致命" },
    SpellStrike = { zhCN = "法术穿透", zhTW = "法術穿透" },
    ManaRestore = { zhCN = "战斗回蓝", zhTW = "戰鬥回魔" },
    HealthRestore = { zhCN = "生命力回复", zhTW = "生命力回復" },
    RunSpeed = { zhCN = "移动速度", zhTW = "移動速度" },
    MountSpeed = { zhCN = "坐骑速度", zhTW = "坐騎速度" },
    talent = { zhCN = "天赋", zhTW = "天賦" },
    base = { zhCN = "基本属性", zhTW = "基本屬性" },
    added = { zhCN = "进阶属性", zhTW = "進階屬性" },
    hpmp = { zhCN = "生命", zhTW = "生命" },
    set = { zhCN = "套装", zhTW = "套裝" },
    Attribute = { zhCN = "属性", zhTW = "屬性" },
    Resistance = { zhCN = "抗性", zhTW = "抗性" },
    Attack = { zhCN = "近战&远程", zhTW = "近戰&遠程" },
    Spell = { zhCN = "法术", zhTW = "法術" },
    Health = { zhCN = "生命&法力", zhTW = "生命&法力" },
    ReduceResistance = { zhCN = "降低抗性", zhTW = "降低抗性" },
    HP = { zhCN = "生命值", zhTW = "生命值" },
    MP = { zhCN = "法力值", zhTW = "法力值" },
    ArmorReduce = { zhCN = "物理免伤", zhTW = "物理免傷" },
    RepairCost = { zhCN = "维修费用", zhTW = "維修費用" },
}

do
    for k, v in pairs(patterns) do
        setmetatable(v, {__index = function(_, k) return "#&@!" end})
    end
end

--静态值属性
local function SetStaticValue(stats, value, ...)
    if (not stats["static"]) then stats["static"] = {} end
    for i = 1, select("#", ...) do
		stats["static"][select(i,...)] = (stats["static"][select(i,...)] or 0) + (tonumber(value) or 0)
	end
end

--百分比属性
local function SetPercentValue(stats, value, baseon, key)
    if (not stats["percent"]) then stats["percent"] = {} end
    tinsert(stats["percent"], {key = key, baseon = baseon, value = value})
end

--逐条根据文字解析属性
local function GetStats(text, r, g, b, stats)
    local v, v1, v2, txt, txt1, txt2
    --套装 @todo
    if strfind(text, "%(%d/%d%)") or strfind(text, "（%d/%d）") then
        return 
    end
    --灰色属性不统计
    if r < 0.6 and g < 0.6 and b < 0.6 then return end
    --不用统计的先排除
    for _, p in ipairs(patterns.ignore) do
		if strfind(text, p[locale]) then return end
	end
    --多属性
    for _, p in ipairs(patterns.multiple) do
		if strfind(text, p[locale]) then
            v1, v2, txt = strmatch(text, p[locale])
            SetStaticValue(stats, v1, strsplit("|",p.key1))
            SetStaticValue(stats, v2, strsplit("|",p.key2))
            if (txt and txt ~= "") then
                GetStats("X" .. txt, r, g, b, stats)
            end
            return
        end
	end
    --递归的
    for _, p in ipairs(patterns.recursive) do
		if strfind(text, p[locale]) then
            txt1, txt2 = strmatch(text, p[locale])
            GetStats(txt1, r, g, b, stats)
            GetStats(txt2, r, g, b, stats)
            return
        end
	end
    --常规属性 +xx
    if strfind(text, "%+(%d+)") then		
		v = strmatch(text, "%+(%d+)")
		for _, p in ipairs(patterns.general) do
			if strfind(text, p[locale]) then
				SetStaticValue(stats, v, strsplit("|",p.key))
				break
			end
		end
		return
	end
    --描述属性
    for _, p in ipairs(patterns.extra) do
		if strfind(text, p[locale]) then
            v = strmatch(text, p[locale])
            SetStaticValue(stats, v, strsplit("|",p.key))
            return
        end
	end
    --百分比属性
    for _, p in ipairs(patterns.percent) do
		if strfind(text, p[locale]) then
			v = strmatch(text, p[locale])
            SetPercentValue(stats, v, p.baseon, p.key)
			return
		end
	end
    --特殊值属性
    for _, p in ipairs(patterns.special) do
		if strfind(text, p[locale]) then
            SetStaticValue(stats, p.value, strsplit("|",p.key))
            if (not p.continue) then break end
        end
        return
	end
end

--读取指定LINK的物品属性
function lib:GetItemStats(link, stats)
    if (type(stats) ~= "table") then stats = {} end
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:ClearLines()
    tooltip:SetHyperlink(link)
    local text, r, g, b
    local n, f = tooltip:NumLines(), tooltip:GetName()
    for i = 2, n do
        text = _G[f.."TextLeft" .. i]:GetText() or ""
        r, g, b = _G[f.."TextLeft" .. i]:GetTextColor()
        GetStats(text, r, g, b, stats)
    end
    return stats
end

--读取UNIT的全身装备属性
function lib:GetUnitItemStats(unit, stats)
    if (type(stats) ~= "table") then stats = {} end
    local text, r, g, b, n, f
    for i = 1, 18 do
        if (i ~= 4) then
            unittip:SetOwner(UIParent, "ANCHOR_NONE")
            unittip:SetInventoryItem(unit, i)
            n, f = unittip:NumLines(), unittip:GetName()
            for j = 2, n do
                text = _G[f.."TextLeft" .. j]:GetText() or ""
                r, g, b = _G[f.."TextLeft" .. j]:GetTextColor()
                GetStats(text, r, g, b, stats)
            end
        end
    end
    return stats
end

--获取属性对应的语种文字
lib.GetStatsName = function(key)
    if (L[key]) then
        return L[key][locale] or _G[strupper(key)] or key
    else
        return _G[strupper(key)] or key
    end
end

--获取属性值
lib.GetStatsValue = function(key, stats, default)
    local v = default or "-"
    if (stats and stats.static) then
        v = stats.static[key] or default or "-"
    elseif (stats) then
        v = stats[key] or default or "-"
    end
    return v == "-" and "-" or "+"..v
end

--是否支持当前语种的属性解析
lib.IsSupported = function(self)
    return locale == "zhCN" or locale == "zhTW"
end
