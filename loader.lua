local WEBHOOK = "https://discord.com/api/webhooks/1458233274731200585/SXl7LMJWC4ZFEza4aoDt3EwY88gkhDaMoFizR-1MKpDtBbMU0gaMMjsYAfztuC7qW-qh"
local KEY_URL = "https://raw.githubusercontent.com/Fufi1925/Fufiv1/main/keys.lua"
local MAIN_URL = "https://raw.githubusercontent.com/Fufi1925/Fufiv1/main/main.lua"

local key = getgenv().FUFI_KEY
if not key then
    return warn("❌ FUFI_KEY fehlt")
end

local Keys = loadstring(game:HttpGet(KEY_URL))()
if not Keys[key] then
    return warn("❌ Ungültiger Key")
end

pcall(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")

    HttpService:PostAsync(
        WEBHOOK,
        HttpService:JSONEncode({
            username = "Fufi Logger",
            content =
                "📥 Script geladen\n" ..
                "👤 "..Players.LocalPlayer.Name..
                "\n🔑 "..key..
                "\n🕒 "..os.date("%d.%m.%Y %H:%M:%S")
        })
    )
end)

loadstring(game:HttpGet(MAIN_URL))()
