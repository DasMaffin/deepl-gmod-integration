TranslatedChat = {}
TranslatedChat.DEEPL_API_KEY = "f4de8ca8-5b64-454f-896e-a3c8e697eb93:fx"
TranslatedChat.Messages = {}
if SERVER then
    print("----------========== Loading translator! ==========----------")
    AddCSLuaFile("vgui/chat.lua")
    util.AddNetworkString("DeepL_TranslateRequest")
    util.AddNetworkString("DeepL_TranslateResponse")

    local DEEPL_URL = "https://api-free.deepl.com/v2/translate"    

    local TARGET_LANG = "EN" -- change if you want (DE, FR, ES, etc.)
    
    local function translate(text, ply)

        if not isstring(text) or #text < 2 then return end
        if #text > 500 then return end -- avoid spam / cost
        if not IsValid(ply) then return end

        local now = CurTime()

        HTTP({
            url = DEEPL_URL,
            method = "POST",
            headers = {
                ["Authorization"] = "DeepL-Auth-Key " .. TranslatedChat.DEEPL_API_KEY,
                ["Content-Type"] = "application/x-www-form-urlencoded"
            },
            body = "text=" .. text ..
                   "&target_lang=" .. TARGET_LANG,
            success = function(code, body)
                print("success")
                local data = util.JSONToTable(body)
                if not data or not data.translations or not data.translations[1] then return end
                PrintTable(data)

                return data.translations[1].text
            end,
            failed = function(reason)
                print("HTTP request failed", reason)
            end
        })
    end


    -- First we need to cache the message so we only have to ask for the translation once and not per player.
    hook.Add("PlayerSay", "DeepL_Translate", function(ply, text, team)
        local message = {
            original = text,
            translation = {}
        }
        table.insert(TranslatedChat.Messages, message)
        PrintTable(TranslatedChat.Messages)
        -- local translation = translate(text, ply)
        return "Translated: " .. text
    end)

elseif CLIENT then
    include("vgui/chat.lua")

    TranslatedChat.chatText = ""

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
end
