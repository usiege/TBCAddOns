local _,t = ...
t.bookmarks = CreateFrame("Frame",nil,t.main,BackdropTemplateMixin and "BackdropTemplate")

t.init:Register("bookmarks")

function t.bookmarks:Init()
    t.bookmarks:SetPoint("TOPRIGHT",t.toolbar,"BOTTOMRIGHT",2,0)
    t.bookmarks:SetPoint("BOTTOMRIGHT",t.main,"BOTTOMRIGHT",-4,4)
    t.bookmarks:SetWidth(t.constants.BOOKMARKS_PANEL_WIDTH)

    t.bookmarks:SetBackdrop({bgFile="Interface\\ChatFrame\\ChatFrameBackground",tileSize=16,tile=true,insets={left=4,right=4,top=4,bottom=4},edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=16})
    t.bookmarks:SetBackdropBorderColor(0.5,0.5,0.5)
    t.bookmarks:SetBackdropColor(0.2,0.2,0.2)

    -- wide "Add Bookmark"/"Remove Bookmark" at top of bookmarks
    t.bookmarks.addRemoveButton = CreateFrame("Button",nil,t.bookmarks,"TinyPadPanelButtonWithIconTemplate")
    t.bookmarks.addRemoveButton:RegisterForClicks("AnyUp")
    t.bookmarks.addRemoveButton:SetPoint("TOPLEFT",6,-6)
    t.bookmarks.addRemoveButton:SetPoint("TOPRIGHT",-6,-6)
    t.bookmarks.addRemoveButton.tooltipBody = "When a page is bookmarked you can return to it later by selecting it in the list below this button."
    t.bookmarks.addRemoveButton:SetScript("OnEnter",t.buttons.OnEnter)
    t.bookmarks.addRemoveButton:SetScript("OnLeave",t.buttons.OnLeave)
    t.bookmarks.addRemoveButton:SetScript("OnClick",t.bookmarks.AddRemoveButtonOnClick)

    -- editbox and button to enter a title for a bookmark, in same space that "Add Bookmark" is
    t.bookmarks.titleButton = t.buttons:Create(t.bookmarks,24,24,4,4,t.bookmarks.TitleButtonOnClick,{anchorPoint="RIGHT",relativeTo=t.bookmarks.addRemoveButton,relativePoint="RIGHT",xoff=0,yoff=0},"Add Bookmark","Save this title for the current page.")
    t.bookmarks.titleEditBox = CreateFrame("EditBox",nil,t.bookmarks,"TinyPadEditBoxWithInstructionsTemplate")
    t.bookmarks.titleEditBox.instructions:SetText("Enter Title")
    t.bookmarks.titleEditBox:SetPoint("LEFT",t.bookmarks.addRemoveButton,"LEFT")
    t.bookmarks.titleEditBox:SetPoint("RIGHT",t.bookmarks.titleButton,"LEFT",-2,0)
    t.bookmarks.titleEditBox:SetAutoFocus(false)
    t.bookmarks.titleEditBox:SetScript("OnEnterPressed",t.bookmarks.TitleButtonOnClick)
    t.bookmarks.titleEditBox:SetScript("OnTextChanged",t.bookmarks.TitleEditBoxOnTextChanged)
    t.bookmarks.titleEditBox:SetScript("OnEditFocusLost",t.bookmarks.TitleEditBoxOnEditFocusLost)

    t.bookmarks:ShowAddRemoveButton()

    -- line beneath the addRemoveButton to form a border around the scrollFrame
    t.bookmarks.border = t.bookmarks:CreateTexture(nil,"ARTWORK")
    t.bookmarks.border:SetHeight(7)
    t.bookmarks.border:SetPoint("TOPLEFT",4,-30)
    t.bookmarks.border:SetPoint("TOPRIGHT",-4,-30)
    t.bookmarks.border:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    t.bookmarks.border:SetTexCoord(0.5625,0.6875,0,0.4375)
    t.bookmarks.border:SetVertexColor(0.35,0.35,0.35)

    -- there's a lot of duplication of code here for the editor and bookmarks scrollframe, but I'm keeping these separate
    -- for more freedom to change one without affecting the other (eg. turning this into a hybridscrollframe)

    -- scrollframe that contains the bookmarks
    t.bookmarks.scrollFrame = CreateFrame("ScrollFrame",nil,t.bookmarks,"UIPanelScrollFrameTemplate")
    t.bookmarks.scrollFrame:SetPoint("TOPLEFT",5,-36)
    t.bookmarks.scrollFrame:SetPoint("BOTTOMRIGHT",-6,6)
    t.bookmarks.scrollFrame.scrollBar = t.bookmarks.scrollFrame.ScrollBar

    -- moving the scrollbar inherited from UIPanelScrollFrameTemplate into the inside of the scrollFrame
    t.bookmarks.scrollFrame.scrollBar:ClearAllPoints()
    t.bookmarks.scrollFrame.scrollBar:SetPoint("TOPRIGHT",0,-17)
    t.bookmarks.scrollFrame.scrollBar:SetPoint("BOTTOMRIGHT",0,16)
    t.bookmarks.scrollFrame.scrollBar:Hide()

    -- veritcla border to the left of the scrollbar
    t.bookmarks.scrollFrame.scrollBar.leftBorder = t.bookmarks.scrollFrame.scrollBar:CreateTexture(nil,"OVERLAY")
    t.bookmarks.scrollFrame.scrollBar.leftBorder:SetSize(8,32)
    t.bookmarks.scrollFrame.scrollBar.leftBorder:SetPoint("TOPLEFT",-8,19)
    t.bookmarks.scrollFrame.scrollBar.leftBorder:SetPoint("BOTTOMLEFT",-8,-18)
    t.bookmarks.scrollFrame.scrollBar.leftBorder:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    t.bookmarks.scrollFrame.scrollBar.leftBorder:SetTexCoord(0.4453125,0.5,0,1)
    t.bookmarks.scrollFrame.scrollBar.leftBorder:SetVertexColor(0.5,0.5,0.5)

    -- background of the scrollbar, that should be the same framelevel as the t.bookmarks frame so it draws beneath the rounded border
    t.bookmarks.scrollFrame.scrollBar.gutter = CreateFrame("Frame",nil,t.bookmarks.scrollFrame.scrollBar)
    t.bookmarks.scrollFrame.scrollBar.gutter:SetFrameLevel(t.bookmarks:GetFrameLevel())
    t.bookmarks.scrollFrame.scrollBar.gutter:SetAllPoints(true)
    t.bookmarks.scrollFrame.scrollBar.gutter.left = t.bookmarks.scrollFrame.scrollBar.gutter:CreateTexture(nil,"BACKGROUND",nil,2)
    t.bookmarks.scrollFrame.scrollBar.gutter.left:SetPoint("TOPLEFT",-4,19)
    t.bookmarks.scrollFrame.scrollBar.gutter.left:SetPoint("BOTTOMRIGHT",t.bookmarks.scrollFrame.scrollBar.gutter,"BOTTOM",0,-19)
    t.bookmarks.scrollFrame.scrollBar.gutter.left:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    t.bookmarks.scrollFrame.scrollBar.gutter.left:SetGradient("horizontal",0.07,0.07,0.07,0.1,0.1,0.1)
    -- two gradient textures meeting together
    t.bookmarks.scrollFrame.scrollBar.gutter.right = t.bookmarks.scrollFrame.scrollBar.gutter:CreateTexture(nil,"BACKGROUND",nil,2)
    t.bookmarks.scrollFrame.scrollBar.gutter.right:SetPoint("TOPLEFT",t.bookmarks.scrollFrame.scrollBar.gutter,"TOP",0,19)
    t.bookmarks.scrollFrame.scrollBar.gutter.right:SetPoint("BOTTOMRIGHT",2,-19)
    t.bookmarks.scrollFrame.scrollBar.gutter.right:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    t.bookmarks.scrollFrame.scrollBar.gutter.right:SetGradient("horizontal",0.1,0.1,0.1,0.07,0.07,0.07)

    -- the list of bookmarks will be buttons attached to this scrollChild
    t.bookmarks.scrollFrame.scrollChild = CreateFrame("Frame",nil,t.bookmarks.scrollFrame)
    t.bookmarks.scrollFrame.scrollChild:SetSize(97,20)
    t.bookmarks.scrollFrame.scrollChild.buttons = {} -- list of buttons in the list of bookmarks
    t.bookmarks.scrollFrame:SetScrollChild(t.bookmarks.scrollFrame.scrollChild)
end

function t.bookmarks:Toggle()
    t.bookmarks:ShowAddRemoveButton()
    t.layout:Toggle("bookmarks")
end

-- called when changing a page or opening bookmarks panel
function t.bookmarks:Update()
    t.bookmarks:ShowAddRemoveButton()
    t.bookmarks:UpdateList()
    C_Timer.After(0,t.bookmarks.UpdateScrollBarVisibility) -- wait a frame for hitrect to update
end

-- bookmarks doesn't change width (for now) but it does change height, so scrollbar existence can change without bookmark changes
function t.bookmarks:Resize(width,height)
    t.bookmarks:UpdateScrollBarVisibility(true)
end

-- shows or hides the scrollbar depending on whether there's stuff to scroll; pass force to make the change regardless of last state (like during init)
function t.bookmarks:UpdateScrollBarVisibility(force)
    local minRange,maxRange = t.bookmarks.scrollFrame.scrollBar:GetMinMaxValues()
    local shouldBeShown = not (minRange==0 and maxRange==0)
    if not shouldBeShown and (force or t.bookmarks.scrollFrame.scrollBar.isShown) then
        t.bookmarks.scrollFrame.scrollBar:Hide()
        t.bookmarks.scrollFrame.scrollChild:SetWidth(t.constants.BOOKMARKS_PANEL_WIDTH-11)
        t.bookmarks.scrollFrame.scrollBar.isShown = false
    elseif shouldBeShown and (force or not t.bookmarks.scrollFrame.scrollBar.isShown) then
        t.bookmarks.scrollFrame.scrollBar:Show()
        t.bookmarks.scrollFrame.scrollChild:SetWidth(t.constants.BOOKMARKS_PANEL_WIDTH-t.constants.SCROLLBAR_WIDTH-11)
        t.bookmarks.scrollFrame.scrollBar.isShown = true
    end
end

--[[ title add/remove button and editbox ]]

-- the Add Bookmark/Remove Bookmark button at the top of the panel
function t.bookmarks:AddRemoveButtonOnClick()
    local mode = t.bookmarks.addRemoveButton.mode
    if mode=="add" then
        t.bookmarks:ShowTitleEditBox()
    elseif mode=="remove" then -- click should delete the bookmark
        t.pages:RemoveTitle()
    end
end

function t.bookmarks:TitleButtonOnClick()
    local title = t.bookmarks.titleEditBox:GetText():trim()
    if title and title:len()>0 then
        t.pages:AddTitle(title)
    end
    t.bookmarks:ShowAddRemoveButton()
end

function t.bookmarks:ShowTitleEditBox()
    t.bookmarks.addRemoveButton:Hide()
    t.bookmarks.titleButton:Show()
    t.bookmarks.titleEditBox:SetText("")
    t.bookmarks.titleEditBox:Show()
    t.bookmarks.titleEditBox:SetFocus(true)
end

function t.bookmarks:ShowAddRemoveButton()
    local _,hasTitle = t.pages:GetPage()
    if hasTitle then
        --t.buttons:SetWideTextAndIcon(t.bookmarks.addRemoveButton,"Remove Bookmark",0.625,0.71875,0.625,0.71875)
        t.bookmarks.addRemoveButton.text:SetText("Remove Bookmark")
        t.bookmarks.addRemoveButton.icon:SetTexCoord(0.625,0.71875,0.625,0.71875)
        t.bookmarks.addRemoveButton.mode = "remove"
        t.bookmarks.addRemoveButton.tooltipTitle = "Remove This Page's Bookmark"
    else
        --t.buttons:SetWideTextAndIcon(t.bookmarks.addRemoveButton,"Add Bookmark",0.5,0.59375,0.625,0.71875)
        t.bookmarks.addRemoveButton.text:SetText("Add Bookmark")
        t.bookmarks.addRemoveButton.icon:SetTexCoord(0.5,0.59375,0.625,0.71875)
        t.bookmarks.addRemoveButton.mode = "add"
        t.bookmarks.addRemoveButton.tooltipTitle = "Bookmark This Page"
    end
    t.bookmarks.addRemoveButton:Show()
    if GetMouseFocus()==t.bookmarks.addRemoveButton then
        t.buttons.OnEnter(t.bookmarks.addRemoveButton) -- update tooltip if mouse is over the button
    end
    t.bookmarks.titleButton:Hide()
    t.bookmarks.titleEditBox:Hide()
end

function t.bookmarks:TitleEditBoxOnTextChanged()
    local hasText = t.bookmarks.titleEditBox:GetText():trim():len() > 0
    t.bookmarks.titleEditBox.instructions:SetShown(not hasText)
    t.bookmarks.titleEditBox.clearButton:SetShown(hasText)
    t.buttons:SetEnabled(t.bookmarks.titleButton,hasText)
end

function t.bookmarks:TitleEditBoxOnEditFocusLost()
    C_Timer.After(t.constants.EDIT_FOCUS_TIMER,function()
        if not t.bookmarks.titleEditBox:HasFocus() and t.bookmarks.titleEditBox:IsVisible() then
            t.bookmarks:ShowAddRemoveButton()
        end
    end)
end

--[[ bookmark list ]]

-- updates the list of bookmarks
function t.bookmarks:UpdateList()
    local buttonIdx = 1
    local buttons = t.bookmarks.scrollFrame.scrollChild.buttons
    for pageNum=1,#t.pages.saved do
        local text,title = t.pages:GetPage(pageNum)
        if title then
            if not buttons[buttonIdx] then -- create new list button if one doesn't already exist
                buttons[buttonIdx] = CreateFrame("Button",nil,t.bookmarks.scrollFrame.scrollChild,"TinyPadBookmarkButtonTemplate")
                buttons[buttonIdx]:SetPoint("TOPLEFT",0,(buttonIdx-1)*t.constants.BOOKMARK_HEIGHT*(-1))
                buttons[buttonIdx]:SetPoint("TOPRIGHT",0,(buttonIdx-1)*t.constants.BOOKMARK_HEIGHT*(-1))
                buttons[buttonIdx]:SetScript("OnMouseUp",t.bookmarks.BookmarkButtonOnMouseUp)
                buttons[buttonIdx]:SetScript("OnMouseDown",t.bookmarks.BookmarkButtonOnMouseDown)
                buttons[buttonIdx]:SetScript("OnShow",t.bookmarks.BookmarkButtonOnMouseUp)
                buttons[buttonIdx]:SetScript("OnClick",t.bookmarks.BookmarkButtonOnClick)
                buttons[buttonIdx]:SetScript("OnEnter",t.bookmarks.BookmarkButtonOnEnter)
                buttons[buttonIdx]:SetScript("OnLeave",t.bookmarks.BookmarkButtonOnLeave)
            end
            buttons[buttonIdx].text:SetText(title)
            buttons[buttonIdx].pageNum = pageNum
            buttons[buttonIdx]:Show()
            if pageNum==t.pages:GetCurrentPageNum() then
                buttons[buttonIdx]:LockHighlight()
            else
                buttons[buttonIdx]:UnlockHighlight()
            end
            -- color button based on whether bookmarks pinned
            t.bookmarks:ColorBookmarkButton(buttons[buttonIdx])
            buttonIdx = buttonIdx + 1
        end
    end
    for i=buttonIdx,#buttons do
        buttons[i]:Hide()
    end
    t.bookmarks.scrollFrame.scrollChild:SetHeight((buttonIdx-1)*t.constants.BOOKMARK_HEIGHT)

end

-- in "normal" state, top and right border is light and backdrop is medium
function t.bookmarks:BookmarkButtonOnMouseUp()
    t.bookmarks:ColorBookmarkButton(self,false)
    self.text:SetPoint("TOPLEFT",5,-2)
    self.text:SetPoint("BOTTOMRIGHT",-3,2)
    self.text:SetTextColor(1,1,1)
end

-- in "pushed" state, top and right border are black and backdrop is near black (highlight texture will lighten this)
function t.bookmarks:BookmarkButtonOnMouseDown()
    t.bookmarks:ColorBookmarkButton(self,true)
    self.text:SetPoint("TOPLEFT",4,-3)
    self.text:SetPoint("BOTTOMRIGHT",-4,1)
    self.text:SetTextColor(0.5,0.5,0.5)
end

-- click of a bookmark will go to that page
function t.bookmarks:BookmarkButtonOnClick()
    if self.pageNum and t.pages:GetPage(self.pageNum) then
        t.pages:GoToPage(self.pageNum)
        if not IsControlKeyDown() then -- if Ctrl is held, keep bookmarks open
            t.layout:Hide("bookmarks")
        end
        if IsShiftKeyDown() then -- if Shift is held, run the page we just went to
            t.toolbar:RunPageButtonOnClick()
        end
    end
end

function t.bookmarks:BookmarkButtonOnEnter()
    local text,title = t.pages:GetPage(self.pageNum)
    if title then
        GameTooltip_SetDefaultAnchor(GameTooltip,UIParent)
        GameTooltip:AddLine(title)
        GameTooltip:AddLine(format("Page %d",self.pageNum),.65,.65,.65)
        GameTooltip:AddLine(text:sub(1,128):gsub("\n"," "),.9,.9,.9,1)
        GameTooltip:AddLine("Hold Shift to run this page as a script.",.65,.65,.65,1)
        if not t.settings.saved.PinBookmarks then
            GameTooltip:AddLine("Hold Ctrl to keep bookmarks open.",.65,.65,.65,1)
        end
    
        if self.tooltipBody then
            GameTooltip:AddLine(self.tooltipBody,0.95,0.95,0.95,true)
        end
        GameTooltip:Show()
    end
end

function t.bookmarks:BookmarkButtonOnLeave()
    GameTooltip:Hide()
end

-- colors the given bookmark list button depending on pinned state and whether it's pressed down or not
function t.bookmarks:ColorBookmarkButton(button,down)
    local light,back,dark
    if t.settings.saved.PinBookmarks then
        light = down and t.constants.BOOKMARK_DOWN_PINNED_LIGHT or t.constants.BOOKMARK_UP_PINNED_LIGHT
        back = down and t.constants.BOOKMARK_DOWN_PINNED_BACK or t.constants.BOOKMARK_UP_PINNED_BACK
        dark = down and t.constants.BOOKMARK_DOWN_PINNED_DARK or t.constants.BOOKMARK_UP_PINNED_DARK
    else
        light = down and t.constants.BOOKMARK_DOWN_LIGHT or t.constants.BOOKMARK_UP_LIGHT
        back = down and t.constants.BOOKMARK_DOWN_BACK or t.constants.BOOKMARK_UP_BACK
        dark = down and t.constants.BOOKMARK_DOWN_DARK or t.constants.BOOKMARK_UP_DARK
    end
    button.left:SetColorTexture(dark,dark,dark)
    button.bottom:SetColorTexture(dark,dark,dark)
    button.top:SetColorTexture(light,light,light)
    button.right:SetColorTexture(light,light,light)
    button.back:SetColorTexture(back,back,back)
end