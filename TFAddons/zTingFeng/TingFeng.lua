local tingfeng = ...;

-- 
DEFAULT_CHAT_FRAME:AddMessage("TingFeng addons load...")
DEFAULT_CHAT_FRAME:AddMessage(...)


function TFFish()
    T,F=T or 0, F or CreateFrame("frame")
    if X then 
        X=nil 
    else 
        X=function()
            local t=UnitXP("player") 
            AcceptGroup() 
            StaticPopup1Button1:Click() 
            if UnitIsGroupLeader("player") then 
                LeaveParty() 
                T=t 
            end 
        end 
    end 
    F:SetScript("OnUpdate",X)
end


-- 
-- /script talk(1, 5, "内容")
function TFTalk(channel, time_pad, msg)
    T,F=T or 0,F or CreateFrame("frame")
    if TALK then 
        TALK=nil
        ChatFrame4:AddMessage("这是我要说的话。。。")
        --SendChatMessage("talk off","channel",nil,channel)
    else 
        TALK=function()
            local t=GetTime()
            if t-T>time_pad then
                SendChatMessage(msg,"channel",nil,channel)
                T=t
            end 
        end
        ChatFrame3:AddMessage("talk on")
        --SendChatMessage("talk on","channel",nil,channel) 
    end 
    F:SetScript("OnUpdate",TALK)
end


isTesting = true
function HelloWorldCommand(...)
    -- body
    param = ...
    print(param)
    DEFAULT_CHAT_FRAME:AddMessage(param)
    
    if isTesting then
        SendChatMessage("cast 恶魔皮肤","SAY",nil,nil)
        isTesting = false
        print("is true testing")
    else
        SendChatMessage("/cast 恶魔皮肤","SAY",nil,nil)
        isTesting = true
        print("is false testing")
    end
end

_G.SLASH_HELLOWORLD1 = "/helloazeroth"; 
_G.SLASH_HELLOWORLD2 = "/ha"; 
_G.SlashCmdList["HELLOWORLD"] = HelloWorldCommand;


DEFAULT_CHAT_FRAME:AddMessage("TingFeng addons script end ---")

DEFAULT_CHAT_FRAME:AddMessage("/y 这是一个测试")
DEFAULT_CHAT_FRAME:AddMessage("/cast 恶魔皮肤")

--SendChatMessage("cast 恶魔皮肤","channel",nil,"SAY")
--SendChatMessage("/cast 恶魔皮肤","SAY",nil)