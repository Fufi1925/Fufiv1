--==============================
-- FufiV1 | Secure Loader
--==============================

local WEBHOOK = "https://discord.com/api/webhooks/1458233274731200585/SXl7LMJWC4ZFEza4aoDt3EwY88gkhDaMoFizR-1MKpDtBbMU0gaMMjsYAfztuC7qW-qh"
local KEY_URL = "https://raw.githubusercontent.com/Fufi1925/Fufiv1/main/keys.lua"
local MAIN_URL = "https://raw.githubusercontent.com/Fufi1925/Fufiv1/main/main.lua"

--==============================
-- Key prüfen
--==============================
local key = getgenv().FUFI_KEY
if not key then
    warn("❌ FUFI_KEY fehlt")
    return
end

local Keys = loadstring(game:HttpGet(KEY_URL))()
if not Keys[key] then
    warn("❌ Ungültiger Key")
    return
end

--==============================
-- Discord Webhook Log
--==============================
pcall(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")

    local data = {
        content =
            "📥 **FufiV1 Script geladen**\n" ..
            "👤 User: **" .. Players.LocalPlayer.Name .. "**\n" ..
            "🔑 Key: `" .. key .. "`\n" ..
            "🎮 Game: " .. game.PlaceId .. "\n" ..
            "🕒 Zeit: " .. os.date("%d.%m.%Y %H:%M:%S")
    }

    HttpService:PostAsync(
        WEBHOOK,
        HttpService:JSONEncode(data),
        Enum.HttpContentType.ApplicationJson
    )
end)

--==============================
-- Main Script laden
--==============================
loadstring(game:HttpGet(MAIN_URL))()
