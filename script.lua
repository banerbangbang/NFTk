-- NFT Battle Script (исправленный)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NFT Battle Script",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by bELKAopex",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local autoSellEnabled = false
local sellInterval = 5
local isFarming = false
local stopFarming = false

-- ============ ВСЕ ВКЛАДКИ В ОДНОЙ ============
local MainTab = Window:CreateTab("Кейсы", "package")
local SettingsTab = Window:CreateTab("Настройки", "settings")
local CreditsTab = Window:CreateTab("Инфо", "info")

-- Функция продажи
local function ServerSell()
    if not autoSellEnabled then return end -- ← фикс: продажа только если включена
    local args = { "Sell", "ALL", false }
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Inventory"):FireServer(unpack(args))
    end)
end

-- Функция открытия кейсов (с кнопкой СТОП)
local function StartFarm(caseName, iterations)
    if isFarming then
        Rayfield:Notify({
            Title = "Уже работает!",
            Content = "Сначала останови текущий фарм",
            Duration = 3
        })
        return
    end
    
    isFarming = true
    stopFarming = false
    local count = 0
    
    Rayfield:Notify({
        Title = "Фарм запущен!",
        Content = "Открываю " .. iterations .. " кейсов " .. caseName,
        Duration = 3
    })
    
    while count < iterations and not stopFarming do
        local success, err = pcall(function()
            local openArgs = { caseName, 10 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("OpenCase"):InvokeServer(unpack(openArgs))
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Ошибка!",
                Content = "Кейс '" .. caseName .. "' не найден!",
                Duration = 5
            })
            break
        end
        
        -- Авто-продажа ТОЛЬКО если включена
        if autoSellEnabled then
            ServerSell()
        end
        
        task.wait(1)
        count = count + 1
    end
    
    isFarming = false
    if stopFarming then
        Rayfield:Notify({
            Title = "Остановлено!",
            Content = "Фарм остановлен. Открыто " .. count .. " кейсов",
            Duration = 3
        })
    else
        Rayfield:Notify({
            Title = "Готово!",
            Content = "Открыто " .. count .. " кейсов",
            Duration = 3
        })
    end
end

-- ============ КНОПКА ОСТАНОВКИ ============
MainTab:CreateButton({
    Name = "❌ СТОП ФАРМ",
    Callback = function()
        if isFarming then
            stopFarming = true
            Rayfield:Notify({
                Title = "Останавливаю...",
                Content = "Подожди, скрипт завершает цикл",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Ничего не работает",
                Content = "Скрипт не запущен",
                Duration = 2
            })
        end
    end
})

MainTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━")

-- ============ НАСТРОЙКИ ============
SettingsTab:CreateToggle({
   Name = "Auto Sell",
   CurrentValue = false,
   Callback = function(Value) 
       autoSellEnabled = Value
       if Value then
           Rayfield:Notify({Title = "Auto Sell", Content = "✅ Включена", Duration = 2})
       else
           Rayfield:Notify({Title = "Auto Sell", Content = "❌ Выключена", Duration = 2})
       end
   end,
})

SettingsTab:CreateSlider({
   Name = "Sell Interval",
   Range = {1, 60},
   Increment = 1,
   Suffix = "sec",
   CurrentValue = 5,
   Callback = function(Value) sellInterval = Value end,
})

SettingsTab:CreateButton({
   Name = "Destroy GUI",
   Callback = function() Rayfield:Destroy() end,
})

-- ============ ФУНКЦИЯ ДОБАВЛЕНИЯ КНОПОК ============
local function AddFarmButton(tab, caseName, displayName)
    tab:CreateButton({
        Name = "Открыть 1000 " .. displayName,
        Callback = function()
            task.spawn(function() StartFarm(caseName, 1000) end)
        end,
    })
    tab:CreateButton({
        Name = "Открыть 100 " .. displayName,
        Callback = function()
            task.spawn(function() StartFarm(caseName, 100) end)
        end,
    })
    tab:CreateButton({
        Name = "Открыть 10 " .. displayName,
        Callback = function()
            task.spawn(function() StartFarm(caseName, 10) end)
        end,
    })
    tab:CreateButton({
        Name = "Открыть 1 " .. displayName,
        Callback = function()
            task.spawn(function() StartFarm(caseName, 1) end)
        end,
    })
    tab:CreateLabel("━━━━━━━━━━━━━━━━━━━━")
end

-- ============ ТВОИ КЕЙСЫ ============
AddFarmButton(MainTab, "Дио", "Дио")  -- ← исправлено с Dno на Дио
AddFarmButton(MainTab, "Dream", "Dream")
AddFarmButton(MainTab, "Bloody Night", "Bloody Night")
AddFarmButton(MainTab, "Ninja Turtles", "Ninja Turtles")
AddFarmButton(MainTab, "Desk Calendars", "Desk Calendars")
AddFarmButton(MainTab, "TSUM", "TSUM")

-- ============ КРЕДИТЫ ============
CreditsTab:CreateButton({
   Name = "GitHub",
   Callback = function()
       setclipboard("https://github.com/banerbangbang/NFTk")
       Rayfield:Notify({Title = "Copied!", Content = "Ссылка скопирована", Duration = 3})
   end,
})

-- ============ ОКНО С ВЫБОРОМ "ДА / НЕТ" ============
Rayfield:Notify({
    Title = "Auto Sell",
    Content = "Включить авто-продажу?",
    Duration = 10,
    Buttons = {
        {
            Name = "Да",
            Callback = function()
                autoSellEnabled = true
                Rayfield:Notify({Title = "Auto Sell", Content = "✅ Включена!", Duration = 2})
            end
        },
        {
            Name = "Нет",
            Callback = function()
                autoSellEnabled = false
                Rayfield:Notify({Title = "Auto Sell", Content = "❌ Выключена", Duration = 2})
            end
        }
    }
})

Rayfield:Notify({Title = "Готово!", Content = "Скрипт загружен! Удачи ♥️", Duration = 3})
