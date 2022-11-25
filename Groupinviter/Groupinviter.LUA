function Groupinviter_OnLoad(frame)
  ChatFrame3:AddMessage("Groupinviter onload.")
  frame:RegisterEvent("CHAT_MSG_WHISPER");
end

function Groupinviter_OnEvent(frame, arg1, arg2, ...)
  ChatFrame3:AddMessage("---------------------------")
  ChatFrame3:AddMessage(arg1)
  ChatFrame3:AddMessage(arg2)
  ChatFrame3:AddMessage("---------------------------")
  if (string.find(arg1, "1") ~= nil) or string.find(arg1, "inv") 
  or string.find(arg1, "2") ~= nil then
    InviteUnit(arg2);
    
  elseif string.find(arg1, "组") ~= nil then
    InviteUnit(arg2);
    
  end
  ChatFrame3:AddMessage(arg1)
  --SendChatMessage("", "WHISPER", nil , arg2);
end