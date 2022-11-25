-- main frame of the addon

local _,t = ...
t.main =  CreateFrame("Frame","TinyPad",UIParent,BackdropTemplateMixin and "BackdropTemplate")

t.main:SetSize(400,400) -- setting basic position here to allow client to handle per-character positioning
t.main:SetPoint("CENTER")
t.main:SetMovable(true)
t.main:SetResizable(true)
t.main:Hide()

t.init:Register("main")

function t.main:Init()

    -- finish defining main UI
    t.main:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",tileSize=16,tile=true,insets={left=4,right=4,top=4,bottom=4},edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize=16})
    t.main:SetBackdropBorderColor(.5,.5,.5)
    t.main:SetClampedToScreen(true)
    t.main:SetToplevel(true)
    t.main:SetFlattensRenderLayers(true)
    t.main:SetHitRectInsets(-8,-8,-8,-8) -- make edges easier to grip for dragging
    
    -- movement
    t.main:SetScript("OnMouseDown",function(self,button,...)
        if not t.settings.saved.Lock or IsShiftKeyDown() then
            self:StartMoving()
            t.main.isMoving = true
        end
    end)
    t.main:SetScript("OnMouseUp",function(self,button,...)
        if not t.settings.saved.Lock or t.main.isMoving then
            self:StopMovingOrSizing()
            t.main.isMoving = false
        end
    end)

    -- OnMouseOver doesn't respect HitRectInsets, so setting a flag when noticing mouse entering HitRectInset
    t.main:SetScript("OnEnter",function(self)
        self.isOver = true
    end)

    t.main:SetScript("OnLeave",function(self)
        self.isOver = false
    end)

    -- resizing
    t.main:SetMinResize(t.constants.MIN_WINDOW_WIDTH,t.constants.MIN_WINDOW_HEIGHT)
    t.main.resizeGrip = CreateFrame("Button",nil,t.main)
    t.main.resizeGrip:SetSize(t.constants.RESIZE_GRIP_SIZE,t.constants.RESIZE_GRIP_SIZE)
    t.main.resizeGrip:SetPoint("BOTTOMRIGHT",-2,2)
    t.main.resizeGrip:SetHitRectInsets(-2,-8,-2,-8)
    t.main.resizeGrip:SetFrameStrata("HIGH")
    t.buttons:SetTextures(t.main.resizeGrip,{texture="Interface\\AddOns\\TinyPad\\media\\buttons",coords={0,0.0625,0.25,0.3125}},
                                            {texture="Interface\\AddOns\\TinyPad\\media\\buttons",coords={0,0.0625,0.25,0.3125},blend="ADD"},
                                            {texture="Interface\\AddOns\\TinyPad\\media\\buttons",coords={0,0.0625,0.25,0.3125},blend="ADD"})

    -- MouseIsOver doesn't respect HitRectInsets, so using an OnEnter/OnLeave to capture larger HitRectInset
    t.main.resizeGrip:SetScript("OnEnter",function(self)
        self.isOver = true
    end)
    t.main.resizeGrip:SetScript("OnLeave",function(self)
        self.isOver = false
    end)

    t.main.resizeGrip:SetScript("OnMouseDown",function(self,button,...)
        if not t.settings.saved.Lock then
            self:GetParent():StartSizing()
            t.main.isSizing = true
        end
    end)
    t.main.resizeGrip:SetScript("OnMouseUp",function(self,button,...)
        if not t.settings.saved.Lock then
            self:GetParent():StopMovingOrSizing()
            t.main.isSizing = false
        end
    end)

    -- when the window size changes, call every module with a Resize function
    t.main:SetScript("OnSizeChanged",function(self,width,height)
        t.init:ResizeAll()
    end)

    -- setup fadein/fadeout when mouse not over window
    t.main:SetAlpha(0)
    t.main.isFadedOut = true
    t.main.fadeTimer = 0
    t.main:SetScript("OnUpdate",t.main.OnUpdate)

    t.main:SetScript("OnHide",function(self)
        t.main.isFadedOut = true
        t.main:SetAlpha(0)
    end)

    -- creates fadeout/fadein animations t.main.fadeout and t.main.fadein
    for k,v in pairs({"fadeout","fadein"}) do
        t.main[v] = t.main:CreateAnimationGroup()
        t.main[v].alpha = t.main[v]:CreateAnimation("alpha")
        t.main[v].alpha:SetFromAlpha(2-k)
        t.main[v].alpha:SetToAlpha(k-1)
        t.main[v].alpha:SetDuration(t.constants.FADE_INOUT_DURATION)
        t.main[v].alpha:SetTarget(t.main)
        t.main[v]:SetScript("OnFinished",function() t.main:SetAlpha(k-1) end)
    end

    t.main:UpdateLock()
    t.main:UpdateScale()
    t.main:UpdateTransparency()

end

function t.main:UpdateLock()
    if t.settings.saved.Lock then
        t.main.resizeGrip:Hide()
        t.main:SetBackdropBorderColor(0.25,0.25,0.25)
    else
        t.main.resizeGrip:Show()
        t.main:SetBackdropBorderColor(.5,.5,.5)
    end
end

function t.main:UpdateScale()
    t.main:SetScale(t.settings.saved.LargerScale and t.constants.LARGE_SCALE or t.constants.SMALL_SCALE)
end

function t.main:UpdateTransparency()
    if t.settings.saved.Transparency then
        t.editor:SetAlpha(0.5)
    else
        t.editor:SetAlpha(1)
    end
end

-- fading is set up in t.main:Init()
function t.main:OnUpdate(elapsed)
    t.main.fadeTimer = t.main.fadeTimer + elapsed
    if t.main.fadeTimer > t.constants.FADE_TICKER_DURATION then
        t.main.fadetimer = 0
        -- if mouse is over the frame or resize grip, or a panel is open, or the main editbox has focus
        local isOver = MouseIsOver(t.main) or t.main.isOver or t.main.resizeGrip.isOver or t.layout.currentLayout~="default" or t.editor.editBox:HasFocus()
        if isOver and t.main.isFadedOut then
            t.main.isFadedOut = false
            t.main.fadein:Play()
        elseif not isOver and not t.main.isFadedOut then
            t.main.isFadedOut = true
            t.main.fadeout:Play()
        end
    end
end
