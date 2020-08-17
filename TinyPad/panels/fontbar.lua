local _,t = ...
t.fontbar = CreateFrame("Frame",nil,t.main)

-- you can edit this table to use your own font, but it should REPLACE one of the existing ones
-- in this format: {"Button Label","Full Name","FontFile",size1,size2,size3}
t.fontbar.fonts = {
    {"Serif","Frizt Quadrata","Fonts\\FRIZQT__.TTF",10,12,16},
    {"San Serif","Arial","Fonts\\ARIALN.TTF",12,16,20},
    {"Mono","Inconsolatas","Interface\\AddOns\\TinyPad\\media\\Inconsolata.otf",11,12,14}
}

t.init:Register("fontbar")

function t.fontbar:Init()
    t.fontbar:Hide()
    t.fontbar:SetPoint("TOPLEFT",t.toolbar,"BOTTOMLEFT",0,-1)
    t.fontbar:SetPoint("TOPRIGHT",t.toolbar,"BOTTOMRIGHT",0,-1)
    t.fontbar:SetHeight(t.constants.BUTTON_SIZE_NORMAL)

    t.fontbar.okButton = t.buttons:Create(t.fontbar,24,24,6,1,function() t.layout:Show("extrabar") t.extrabar.searchBox:SetFocus(true) end,{anchorPoint="TOPRIGHT",relativeTo=t.fontbar,relativePoint="TOPRIGHT"})

    -- font size buttons S/M/L to choose the size of the font
    t.fontbar.sizeButtons = {}
    for i=1,3 do
        t.fontbar.sizeButtons[i] = t.buttons:Create(t.fontbar,24,24,i==3 and "L" or i==2 and "M" or "S",nil,t.fontbar.SizeButtonOnClick,{anchorPoint="TOPRIGHT",relativeTo=t.fontbar,relativePoint="TOPRIGHT",xoff=-96+(i*24),yoff=0},i==3 and "Large" or i==2 and "Medium" or "Small")
        t.fontbar.sizeButtons[i].text:SetFont("Fonts\\FRIZQT__.TTF",i==3 and 12 or i==2 and 9 or 8)
        t.fontbar.sizeButtons[i]:SetID(i)
        t.fontbar.sizeButtons[i]:RegisterForClicks("AnyUp")
    end

    -- font family buttons ("Serif", "San Serif", "Mono") to choose the font
    t.fontbar.familyButtons = {}
    for i=1,3 do
        t.fontbar.familyButtons[i] = CreateFrame("Button",nil,t.fontbar,"TinyPadPanelButtonTemplate")
        t.fontbar.familyButtons[i].text:SetText(t.fontbar.fonts[i][1])
        t.fontbar.familyButtons[i].text:SetFont(t.fontbar.fonts[i][3],11)
        t.fontbar.familyButtons[i]:SetID(i)
        t.fontbar.familyButtons[i]:RegisterForClicks("AnyUp")
        t.fontbar.familyButtons[i]:SetPoint("LEFT",i>1 and t.fontbar.familyButtons[i-1],i>1 and "RIGHT")
        t.fontbar.familyButtons[i]:SetScript("OnClick",t.fontbar.FamilyButtonOnClick)
        t.fontbar.familyButtons[i].tooltipTitle = t.fontbar.fonts[i][2]
        t.fontbar.familyButtons[i]:SetScript("OnEnter",t.buttons.OnEnter)
        t.fontbar.familyButtons[i]:SetScript("OnLeave",t.buttons.OnLeave)
    end
end

function t.fontbar:Resize(width,height)
    local familyWidth = (width-12-(24*4))/3 -- width of first 3 buttons with font family
    local smallNames = t.fontbar.familyButtons[1].text:GetText()=="Aa"

    for i=1,3 do
        t.fontbar.familyButtons[i]:SetWidth(familyWidth)
        if width < t.constants.MIN_MEDIUM_WIDTH and not smallNames then
            t.fontbar.familyButtons[i].text:SetText("Aa")
        elseif width >= t.constants.MIN_MEDIUM_WIDTH and smallNames then
            t.fontbar.familyButtons[i].text:SetText(t.fontbar.fonts[i][1])
        end
    end
end

-- locks/unlocks highlights on family and size buttons based on current settings
function t.fontbar:Update()
    for i=1,3 do
        t.fontbar.familyButtons[i][t.settings.saved.FontFamily==i and "LockHighlight" or "UnlockHighlight"](t.fontbar.familyButtons[i])
        t.fontbar.sizeButtons[i][t.settings.saved.FontSize==i and "LockHighlight" or "UnlockHighlight"](t.fontbar.sizeButtons[i])
    end
end

function t.fontbar:FamilyButtonOnClick()
    t.settings.saved.FontFamily = self:GetID()
    t.editor:UpdateFont()
    t.fontbar:Update()
end

function t.fontbar:SizeButtonOnClick()
    t.settings.saved.FontSize = self:GetID()
    t.editor:UpdateFont()
    t.fontbar:Update()
end

