local _, ADDONSELF = ...
print(ADDONSELF)

DEBUG = true

-- global things
_G.OOPrint = OOPrint
_G.OOIsInTable = OOIsInTable
_G.DEBUG = DEBUG


-- utils func
function OOPrint( xxx )
	-- body
	print(xxx)
end

function OOIsInTable(value, tbl)
	for k,v in ipairs(tbl) do
	  if v == value then
	  return true;
	  end
	end
	return false;
end


-- addon utils
-- Raid struct

local OORaid = {
	member_list = {}, --OOMember list 
	username_list = {}, 	-- username list, use this name recognize member, username -> member one by one
	-- random_num_list = {} 	-- random key code list 
}

local OOMember = {
	index = nil,	--在团队中的索引 用于获取在团队中的信息
	is_commander = false, 
	username = "",
	class_id = "",
	random_key = ""
}

local OORecord = {
	raid_id = "",	-- uuid
	item_list = {}	-- list for OOAccount
}

local OOAccount = {
	beneficiary = "",
	type = "",
	costtype = "",
	cost = "",
	Id = "",
	costcache = "",
	detail = {},
	item_id = ""
}

local OOGoods = {
	displayname = "",
	code_id = ""
}

-- class init

function OORecord:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end

function OOAccount:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end

function OOGoods:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end


function OORaid:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end

-- function for raid

function OORaid:MemberCount( ... )
	-- body
	local count = 0
	for k,v in pairs(self.member_list) do
		count = count + 1
	end

	return count
end

function OORaid:MemberNames( ... )
	-- body
	return self.username_list
end

function OORaid:RandomKeylist( ... )
	-- body
	local code_list = {}

	-- get current random key list 
	for k,v in pairs(self.member_list) do
		if v.random_key ~= "" then
			table.insert(code_list, v.random_key)
		end
	end

	return code_list
end

-- 为团员分配随机码
function OORaid:AssignRandomKey( member )
	-- body
	local member = member
	if member == nil then return end
	local username = member.username

	local code = ""
	local code_list = self:RandomKeylist()

	-- generate code 
	code = string.format("%04d", math.random(1, 10000))
	if not OOIsInTable(code, code_list) then
		member.random_key = code or ""
		table.insert(code_list, code)
	end

	return code
end


local function user_class_id( filename )
	return tostring(CAREER_ID[filename])
end

-- 根据成员所在队伍中的索引更新成员信息
function OORaid:UpdateMember( username, index )
	-- body
	local memeber = self:GetMember(username)
	if memeber == nil then return end
	memeber.index = index

	local name, rank, subgroup, level, class, filename, zone, online, isDead, role, isML
	= GetRaidRosterInfo(index)

	-- 各字段见oolib
	memeber.is_commander = (index == 1)
	memeber.user_lv = tostring(level)
	memeber.class_id = user_class_id(filename)



end

-- 添加团队成员
function OORaid:AddMember( ... )
	-- body
	local username, index = ...
	if OOIsInTable(username, self:MemberNames()) then return end

	local new_member = OOMember:new(username)
	self:AssignRandomKey(new_member)
	self:UpdateMember(username, index)

	--print(new_member.username, index)
	--
	self.member_list[username] = new_member
	table.insert(self.username_list, username)
end

function OORaid:GetMember( username )
	-- body
	for k,v in pairs(self.member_list) do
		if k == username then
			return v
		end
	end
	return nil
end

function OORaid:RemoveMember( username )
	-- body
	if not OOIsInTable(username, self:MemberNames()) then return end

	-- remove username 
	-- local member = self:GetMember(username)

	for i,v in ipairs(self.username_list) do
		if v == username then
			table.remove(self.username_list, i)
		end
	end

	-- remove member 
	self.member_list[username] = nil
end

function OORaid:ClearMembers()
	-- body
	for i,v in ipairs(self:MemberNames()) do
		self:RemoveMember(v)
	end
end

-- record for Raid
function OORaid:GetRecord( ... )
	
end

-- member 

function OOMember:new( username )

	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.username = username

	return o
end




-- oo game main event code
do
	local ooraid = OORaid:new()
	ADDONSELF.CURRENT_RAID = ooraid
end


-- dubug code 
if DEBUG then
	print("this should run only one time.")
	-- local raid = OORaid:new()
	-- raid:AddMember("ddd")
	-- raid:AddMember("123")
	-- raid:AddMember("222")
	-- raid:AddMember("123")
	-- raid:AddMember("222")
	-- --raid:RemoveMember("222")

	-- for i,v in ipairs(raid:RandomKeylist()) do
	-- 	print(i,v)
	-- end

	-- for i,v in ipairs(raid.username_list) do
	-- 	print(i,v)
	-- end

end

