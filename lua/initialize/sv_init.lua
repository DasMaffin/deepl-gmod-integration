SetGlobalVar("TranslatedChat.DEEPL_API_KEY", "")

local dir = "TranslatedChat"
local path = dir .. "/apikey.json"
local DEEPL_URL = "https://api-free.deepl.com/v2/translate"    

local TARGET_LANG = "EN" -- change if you want (DE, FR, ES, etc.)    

if file.Exists(path, "DATA") then
    local key = util.JSONToTable(file.Read(path))
    SetGlobalVar("TranslatedChat.DEEPL_API_KEY", key.value)
end

local function translate(text, ply)

    if not isstring(text) or #text < 2 then return end
    if #text > 500 then return end -- avoid spam / cost
    if not IsValid(ply) then return end

    local now = CurTime()
    HTTP({
        url = DEEPL_URL,
        method = "POST",
        headers = {
            ["Authorization"] = "DeepL-Auth-Key " .. GetGlobalVar("TranslatedChat.DEEPL_API_KEY"),
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        body = "text=" .. text ..
                "&target_lang=" .. TARGET_LANG,
        success = function(code, body)
            local data = util.JSONToTable(body)
            if not data or not data.translations or not data.translations[1] then return end

            return data.translations[1].text
        end,
        failed = function(reason)
            print("HTTP request failed", reason)
        end
    })
end


-- First we need to cache the message so we only have to ask for the translation once and not per player.
hook.Add("PlayerSay", "DeepL_Translate", function(ply, text, team)
    local commandArguments = string.Split(text, " ")
    if table.HasValue(commandArguments, "!setAPIKey") then
        local key = { value = commandArguments[2]}
        if not file.IsDir(dir, "DATA") then
            file.CreateDir(dir)
        end
        file.Write(path, util.TableToJSON(key))   
        SetGlobalVar("TranslatedChat.DEEPL_API_KEY", key.value)
        return ""
    end

    local message = {
        original = text,
        translation = {}
    }
    table.insert(TranslatedChat.Messages, message)
    -- local translation = translate(text, ply)
    return "Translated: " .. text
end)