-- NFT Battle Script (адаптирован под твои кейсы)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NFT Battle Script",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by bELKAopex (адаптирован)",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local autoSellEnabled = false
local sellInterval = 5

-- Вкладки для твоих кейсов (названия на английском)
local DreamTab = Window:CreateTab("Dream", "star")
local BloodyTab = Window:CreateTab("Bloody Night", "star")
local NinjaTab = Window:CreateTab("Ninja Turtles", "star")
local DeskTab = Window:CreateTab("Desk Calendars", "star")
local DnoTab = Window:CreateTab("Dno", "star")
local TsumTab = Window:CreateTab("TSUM", "star") 

local MainTab = Window:CreateTab("Main Settings", "settings")
local CreditsTab = Window:CreateTab("Credits", "info")

-- Функция продажи
local function ServerSell()
    local args = { "Sell", "ALL", false }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Inventory"):FireServer(unpack(args))
    end)
end

-- Функция открытия кейсов
local function StartFarm(caseName, iterations)
    local count = 0
    while count < iterations do
        local openArgs = { caseName, 10 }
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("OpenCase"):InvokeServer(unpack(openArgs))
        end)
        if not autoSellEnabled then
            ServerSell()
        end
        task.wait(1)
        count = count + 1
    end
end

-- Авто-продажа
task.spawn(function()
    while true do
        if autoSellEnabled then
            ServerSell()
        end
        task.wait(sellInterval)
    end
end)

-- Настройки
MainTab:CreateToggle({
   Name = "Auto Sell",
   CurrentValue = false,
   Callback = function(Value) autoSellEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Sell Interval",
   Range = {1, 60},
   Increment = 1,
   Suffix = "sec",
   CurrentValue = 5,
   Callback = function(Value) sellInterval = Value end,
})

MainTab:CreateButton({
   Name = "Destroy GUI",
   Callback = function() Rayfield:Destroy() end,
})

-- Функция добавления кнопок фарма
local function AddFarmButtons(tab, caseName)
    local amounts = {
        {Name = "Open 1000", Val = 1000},
        {Name = "Open 100", Val = 100},
        {Name = "Open 10", Val = 10},
        {Name = "Open 1", Val = 1}
    }
    for _, data in ipairs(amounts) do
        tab:CreateButton({
            Name = data.Name,
            Callback = function()
                task.spawn(function() StartFarm(caseName, data.Val) end)
            end,
        })
    end
end

-- Кнопки для твоих кейсов (всё на английском!)
AddFarmButtons(DreamTab, "Dream")
AddFarmButtons(BloodyTab, "Bloody Night")
AddFarmButtons(NinjaTab, "Ninja Turtles")
AddFarmButtons(DeskTab, "Desk Calendars")
AddFarmButtons(DnoTab, "Dno")
AddFarmButtons(TsumTab, "TSUM")

-- Кредиты
CreditsTab:CreateButton({
   Name = "GitHub",
   Callback = function()
       setclipboard("https://github.com/твой_ник/твой_репозиторий")
       Rayfield:Notify({Title = "Copied!", Content = "Ссылка скопирована", Duration = 3})
   end,
})

-- ============ ОКНО С ВЫБОРОМ "ДА / НЕТ" ПРИ ЗАПУСКЕ ============
Rayfield:Notify({
    Title = "Auto Sell",
    Content = "Включить авто-продажу?",
    Duration = 10,
    Buttons = {
        {
            Name = "Да",
            Callback = function()
                autoSellEnabled = true
                Rayfield:Notify({
                    Title = "Auto Sell",
                    Content = "✅ Включена!",
                    Duration = 2
                })
            end
        },
        {
            Name = "Нет",
            Callback = function()
                autoSellEnabled = false
                Rayfield:Notify({
                    Title = "Auto Sell",
                    Content = "❌ Выключена",
                    Duration = 2
                })
            end
        }
    }
})

Rayfield:Notify({Title = "Готово!", Content = "Скрипт загружен! Удачи ♥️", Duration = 3})
