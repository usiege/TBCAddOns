local _,t = ...
t.extrabar = CreateFrame("Frame",nil,t.main)

t.init:Register("extrabar")

function t.extrabar:Init()
    t.extrabar:Hide()
    t.extrabar:SetPoint("TOPLEFT",t.toolbar,"BOTTOMLEFT",0,-1)
    t.extrabar:SetPoint("TOPRIGHT",t.toolbar,"BOTTOMRIGHT",0,-1)
    t.extrabar:SetHeight(t.constants.BUTTON_SIZE_NORMAL)

    -- lock, font, size, transparency, chat, redo, undo, search, searchbox
    t.extrabar.lockButton = t.buttons:Create(t.extrabar,24,24,4,1,t.extrabar.LockButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.extrabar,relativePoint="TOPRIGHT"},"Lock","Lock or unlock the window, preventing it from being dismissed with the Escape key or moved unless Shift is held.")
    t.extrabar.fontButton = t.buttons:Create(t.extrabar,24,24,4,2,t.extrabar.FontButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.extrabar.lockButton,relativePoint="TOPLEFT",xoff=-1,yoff=0},"Font","Cycle through different fonts.\n\n"..t.constants.TOOLTIP_SUBTEXT_COLOR.."Hold Shift to cycle backwards.")
    t.extrabar.sizeButton = t.buttons:Create(t.extrabar,24,24,0,6,t.extrabar.SizeButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.extrabar.fontButton,relativePoint="TOPLEFT",xoff=-1,yoff=0},"Size","Toggle the size of TinyPad.")
    t.extrabar.transparencyButton = t.buttons:Create(t.extrabar,24,24,2,6,t.extrabar.TransparencyButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.extrabar.sizeButton,relativePoint="TOPLEFT",xoff=-1,yoff=0},"Transparency","Toggle the transparency of TinyPad.")
    t.extrabar.minimapButton = t.buttons:Create(t.extrabar,24,24,4,7,t.extrabar.MinimapButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.extrabar.transparencyButton,relativePoint="TOPLEFT",xoff=-1,yoff=0},"Minimap","Toggle the Minimap button to summon and dismiss TinyPad.")
    t.extrabar.searchButton = t.buttons:Create(t.extrabar,24,24,4,0,t.extrabar.SearchButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.extrabar.minimapButton,relativePoint="TOPLEFT",xoff=-1,yoff=0},"Find","Find the next page with this text.\n\n"..t.constants.TOOLTIP_SUBTEXT_COLOR.."Hold Shift to find the previous page with this text.")

    -- search box is an editbox to the left of the extrabar settings buttons
    t.extrabar.searchBox = CreateFrame("EditBox",nil,t.extrabar,"TinyPadEditBoxWithInstructionsTemplate")
    t.extrabar.searchBox.instructions:SetText("Search")
    t.extrabar.searchBox:SetPoint("TOPLEFT",t.extrabar,"TOPLEFT")
    t.extrabar.searchBox:SetPoint("TOPRIGHT",t.extrabar.searchButton,"TOPLEFT")
    t.extrabar.searchBox:SetAutoFocus(false)
    t.extrabar.searchBox:SetScript("OnEscapePressed",t.extrabar.Toggle)
    t.extrabar.searchBox:SetScript("OnTextChanged",t.extrabar.SearchOnTextChanged)
    t.extrabar.searchBox:SetScript("OnEditFocusLost",t.extrabar.SearchOnEditFocusLost)
    t.extrabar.searchBox:SetScript("OnEnterPressed",t.extrabar.SearchButtonOnClick) -- hitting enter in searchbox will /click the find button
    
    t.extrabar.searchBox.count = t.extrabar.searchBox:CreateFontString(nil,"ARTWORK")
    t.extrabar.searchBox.count:SetFont("Fonts\\ARIALN.ttf",10)
    t.extrabar.searchBox.count:SetPoint("RIGHT",-20,0)
    t.extrabar.searchBox.count:SetTextColor(0.5,0.5,0.5)
    t.extrabar.searchBox.count:SetText("9999 found")

    -- for a visual indicator when search is entered and there are no search hits
    t.extrabar.searchBox.flash = CreateFrame("Frame",nil,t.extrabar.searchBox,"TinyPadFlashTemplate")

    -- add number of search hits to the tooltip of the "Find" button (searchButton)
    t.extrabar.searchButton:HookScript("OnEnter",function(self)
        local count = t.pages:FindCount(t.extrabar.searchBox:GetText())
        GameTooltip:AddLine(format("\n%d matches found",count),1,0.82,0)
        GameTooltip:Show()
    end)
end

function t.extrabar:Resize(width,height)
    local buttonSize = width >= t.constants.MIN_MEDIUM_WIDTH and t.constants.BUTTON_SIZE_NORMAL or t.constants.BUTTON_SIZE_SMALL
    -- resize buttons based on parent frame width
    for _,button in ipairs(t.extrabar.allButtons) do
        button:SetSize(buttonSize,buttonSize)
    end
    -- resize searchbox and extrabar based on buttonSize based on width
    t.extrabar.searchBox:SetHeight(buttonSize)
    t.extrabar:SetHeight(buttonSize)
    -- the "000 found" in the searchbox changes depending on width
    if width>t.constants.MIN_WIDE_WIDTH then
        t.extrabar.searchBox.countFormat = "%d found" -- at wide widths, display "<count> found"
        t.extrabar.searchBox:SetTextInsets(7,70,1,1)
    elseif width>t.constants.MIN_NARROW_WIDTH then
        t.extrabar.searchBox.countFormat = "%d" -- at medium widths, just display <count>
        t.extrabar.searchBox:SetTextInsets(7,42,1,1)
    else
        t.extrabar.searchBox.countFormat = "" -- at narrow widths, display nothing
        t.extrabar.searchBox:SetTextInsets(7,17,1,1)
    end
end

function t.extrabar:Toggle()
    if t.extrabar.searchBox.flash.animation:IsPlaying() then
        t.extrabar.searchBox.flash.animation:Stop()
    end
    t.layout:Toggle("extrabar")
    if t.layout.currentLayout=="extrabar" then
        t.extrabar.searchBox:SetFocus()
    end
end

--[[ button clicks ]]

function t.extrabar:FontButtonOnClick()
    t.layout:Toggle("fontbar")
end

function t.extrabar:LockButtonOnClick()
    t.settings.saved.Lock = not t.settings.saved.Lock
    t.main:UpdateLock()
    t.extrabar.searchBox:SetFocus()
end

function t.extrabar:SizeButtonOnClick()
    t.settings.saved.LargerScale = not t.settings.saved.LargerScale
    t.main:UpdateScale()
    t.extrabar.searchBox:SetFocus()
end

function t.extrabar:TransparencyButtonOnClick()
    t.settings.saved.Transparency = not t.settings.saved.Transparency
    t.main:UpdateTransparency()
    t.extrabar.searchBox:SetFocus()
end

function t.extrabar:MinimapButtonOnClick()
    t.settings.saved.ShowMinimapButton = not t.settings.saved.ShowMinimapButton
    t.minimap:SetShown(t.settings.saved.ShowMinimapButton)
    t.extrabar.searchBox:SetFocus()
end

function t.extrabar:SearchButtonOnClick()
    local text = t.extrabar.searchBox:GetText():trim()
    if text and text:len()>0 then
        local pageNum = t.pages:FindNext(text,IsShiftKeyDown())
        if pageNum then
            t.extrabar:SearchBoxFlash(0,1,0)
            t.pages:GoToPage(pageNum)
        else
            t.extrabar:SearchBoxFlash(1,0,0)
        end
    end
    t.extrabar.searchBox:SetFocus()
end

--[[ searchbox stuff ]]

function t.extrabar:SearchClearButtonOnClick()
    t.extrabar.searchBox:SetText("")
    t.extrabar.searchBox:SetFocus(true)
end

function t.extrabar:SearchOnTextChanged()
    local hasText = t.extrabar.searchBox:GetText():trim():len() > 0
    t.extrabar.searchBox.instructions:SetShown(not hasText)
    t.extrabar.searchBox.clearButton:SetShown(hasText)
    t.buttons:SetEnabled(t.extrabar.searchButton,hasText)
    t.extrabar.searchBox.count:SetShown(hasText)
    if hasText then
        -- update the number of search hits in the instruction-like text within searchBox
        local count = t.pages:FindCount(t.extrabar.searchBox:GetText())
        t.extrabar.searchBox.count:SetText(format(t.extrabar.searchBox.countFormat,count))
        -- if mouse is over the "Find"/searchButton, then update its tooltip with new count
        if GetMouseFocus()==t.extrabar.searchButton then
            t.extrabar.searchButton:GetScript("OnEnter")(t.extrabar.searchButton)
        end
    end
end

-- clicking elsewhere will lose focus from the editbox; hide extrabar if it hasn't gotten focus back or a button is being clicked
function t.extrabar:SearchOnEditFocusLost()
    C_Timer.After(t.constants.EDIT_FOCUS_TIMER,function()
        local clickingSearchButton = GetMouseFocus()==t.extrabar.searchButton -- special case for potentially disabled search button
        if not t.extrabar.searchBox:HasFocus() and t.extrabar:IsVisible() and not t.buttons.isButtonBeingClicked and not clickingSearchButton and not t.main.isSizing and not t.main.isMoving then
            t.layout:Hide("extrabar")
        elseif clickingSearchButton or t.main.isSizing or t.main.isMoving then -- clickingSearchButton is true if mouse is over a disabled searchButton too
            t.extrabar.searchBox:SetFocus(true)
        end
    end)
end

-- flashes the border of the searchbox the given r,g,b color
function t.extrabar:SearchBoxFlash(r,g,b)
    if t.extrabar.searchBox.flash.animation:IsPlaying() then
        t.extrabar.searchBox.flash.animation:Stop()
    end
    t.extrabar.searchBox.flash.left:SetVertexColor(r,g,b)
    t.extrabar.searchBox.flash.mid:SetVertexColor(r,g,b)
    t.extrabar.searchBox.flash.right:SetVertexColor(r,g,b)
    t.extrabar.searchBox.flash.animation:Play()
end
