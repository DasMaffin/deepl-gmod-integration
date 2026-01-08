print("Hello, World!")
local PANEL = {}
vgui.Register("TranslatedChatPanel", PANEL, "EditablePanel")

local function generateCornerBox(w, h, cornerSize)
    chatbox =
    {
        { x = cornerSize, y = 0 }, -- technically "0 (most left) + cornerSize" on x.
        { x = w - cornerSize, y = 0 },
        { x = w, y = cornerSize},
        { x = w, y = h - cornerSize },
        { x = w - cornerSize, y = h},
        { x = cornerSize, y = h },
        { x = 0, y = h - cornerSize},
        { x = 0, y = cornerSize}
    }
    return chatbox
end

local cursorBlinkVisible = false
function PANEL:Init()
    self:SetSize(768, 384)
    self:SetPos(32, 376)
    self:SetVisible(false)

    self.chatInputField = vgui.Create("DLabel", self)
    self.chatInputField:Dock(BOTTOM)
    self.chatInputField:SetTall(100)
    self.chatInputField:SetText(TranslatedChat.chatText)
    self.chatInputField:DockMargin(10, 0, 10, 10)
    self.chatInputField:SetTextInset(15, 0)
    self.chatInputField:SetFont("PointMarkerFont")
    self.chatInputField:SetWrap(true)
    local x, y = self.chatInputField:GetTextSize()
    self.chatInputField:SetTall(y + 10)
    self.chatInputField.Paint = function(s, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(25, 25, 35, 255), true, true, true, true)
    end
    function self.chatInputField:Paint(w, h)
        surface.SetDrawColor(148, 119, 93,80)

        surface.DrawPoly(generateCornerBox(w, h, 10))
    end

    timer.Create("CursorBlinkTimer", 0.75, 0, function()
        if cursorBlinkVisible then
            self.chatInputField:SetText(string.sub(self.chatInputField:GetText(), 1, -2))
            cursorBlinkVisible = false
        elseif not cursorBlinkVisible then
            self.chatInputField:SetText(self.chatInputField:GetText() .. "|")
            cursorBlinkVisible = true
        end
    end)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(148, 119, 93,80)

    surface.DrawPoly(generateCornerBox(w, h, 10))
end

function TranslatedChat:OnChatInputTextChanged(text)
    if cursorBlinkVisible then text = text .. "|" end
    local x, y = TranslatedChatPanel.chatInputField:GetTextSize()
    TranslatedChatPanel.chatInputField:SetTall(y + 10)
    TranslatedChatPanel.chatInputField:SetText(text)
end

function TranslatedChat:EnableChat()
    if not IsValid(TranslatedChatPanel) then
        TranslatedChatPanel = vgui.Create("TranslatedChatPanel")
    end
    
    TranslatedChatPanel:SetVisible(true)
end

function TranslatedChat:DisableChat()
    TranslatedChatPanel:SetVisible(false)
end