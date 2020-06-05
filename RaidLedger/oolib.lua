local _, ADDONSELF = ...

DEBUG = false

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
local OORaid = {
	member_list = {}, 						-- OOMember list 
	username_list = {}, 					-- username list, use this name recognize member, username -> member one by one
	-- random_num_list = {} 				-- random key code list 
	record = nil
}

local OORecord = {
	g_raid_id = "",							-- raid uuid
	g_raid_number_of_people  = 0,			-- number of member 
	g_raid_record = {},						-- OOAccount list
	g_member_list = {}						-- OOMember list
}

local OOMember = {
	index = nil,	--在团队中的索引 用于获取在团队中的信息
	is_commander = false, 
	username = "",
	class_id = "",
	random_key = ""
}


local OOAccount = {
	payment = false,
	beneficiary = "",
	type = "",
	costtype = "",
	cost = 0,
	Id = "",
	costcache = 0,
	detail = {
		displayname = "",
		count = 1,
		type = "",
		item = "",
		item_id = "",
	},
}


-- class init
function OORaid:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end


function OORecord:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.g_raid_id = uuid()

	return o
end

function OOAccount:new(o)
	-- body
	local o = o or {}
	setmetatable(o, self)
	self.__index = self

	return o
end


-- function for record


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
function OORaid:UpdateMember( memeber, index )
	-- body
	if memeber == nil then return end
	if index == nil then return end
	local username = memeber.username
	
	memeber.index = index 
	memeber.username = username

	local name, rank, subgroup, level, class, filename, zone, online, isDead, role, isML
	= GetRaidRosterInfo(index)

	-- 各字段见oolib
	memeber.is_commander = (index == 1)
	memeber.user_lv = tostring(level)
	memeber.class_id = user_class_id(filename)

	self.member_list[username] = memeber
end

-- 添加团队成员
function OORaid:AddMember( ... )
	-- body
	local username, index = ...
	if OOIsInTable(username, self:MemberNames()) then return end

	local new_member = OOMember:new(username)
	self:AssignRandomKey(new_member)
	self:UpdateMember(new_member, index)

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
	
	local result = ""

	local record = self.record or OORecord:new()
	--print("uuid ----> " .. record.g_raid_id)
	record.g_raid_id 				= record.g_raid_id -- why need this ?
	record.g_raid_number_of_people 	= #self:MemberNames() or 0
	record.g_member_list 			= self.member_list or {}
	
	local db_items = OO.db:GetCurrentLedger()["items"]
	if db_items == nil then return luajson.table2json(record) end

	local account_lsit = {}
	for k,v in pairs(db_items) do
		--print(v)
		local account = OOAccount:new()
		account.Id 				= k
		account.beneficiary 	= v.beneficiary
		account.type 			= v.type
		account.costtype 		= v.costtype
		account.cost 			= v.cost or 0
		account.costcache		= v.costcache
		account.payment			= v.payment				-- account.cost > 0
		account.detail			= v.detail
		account_lsit[k] = account
	end

	record.g_raid_record = account_lsit
	-- to json result
	result = luajson.table2json(record)

	if DEBUG then print(result) end
	return result
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
	local record = OORecord:new()
	ooraid.record = record


	_G.OO = ooraid
end


-- dubug code 
if DEBUG then
	print(OO.record.g_raid_id)
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

