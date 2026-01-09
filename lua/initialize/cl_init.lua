TranslatedChat.chatText = ""
include("initialize/languages.lua")
hook.Add("StartChat", "OverrideDefaultChatWithTranslated", function(isTeamChat)
    TranslatedChat:EnableChat()
    return true
end)

hook.Add("FinishChat", "CloseTranslatedChat", function()
    TranslatedChat:DisableChat()
end)

hook.Add("ChatTextChanged", "OnChatTextChanged", function(text)
    chatText = text
    TranslatedChat:OnChatInputTextChanged(chatText)
end)

local function broadcastAPIReminder()
    if GetGlobalVar("TranslatedChat.DEEPL_API_KEY") ~= "" then
        timer.Remove("BroadcastAPIReminderTimer")
        return
    end
    chat.AddText("You need to set up your DeepL API key first! To set it up type \"!setAPIKey <your API key>\" (without the <>). Generate an API key at https://www.deepl.com")
end

if not (ULib and ulx) or LocalPlayer():IsSuperAdmin() then
    timer.Create("BroadcastAPIReminderTimer", 60, 0, broadcastAPIReminder)
end