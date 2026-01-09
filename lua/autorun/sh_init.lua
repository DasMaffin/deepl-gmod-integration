print("----------========== Loading translator! ==========----------")

TranslatedChat = {}
TranslatedChat.Messages = {}

if SERVER then
    AddCSLuaFile("initialize/cl_init.lua")
    AddCSLuaFile("vgui/chat.lua")

    include("initialize/sv_init.lua")
elseif CLIENT then
    include("vgui/chat.lua")
    include("initialize/cl_init.lua")
end