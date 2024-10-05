local function getMultiplierAndIcon(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local group = xPlayer.getGroup()

    local groupLabel = "User"
    local multiplier = 1

    if group == "vip" then
        multiplier = 1.5
        groupLabel = "VIP Gold"
    elseif group == "vip2" then
        multiplier = 2
        groupLabel = "VIP Diamond"
    elseif group == "moderator" then
        multiplier = 2.5
        groupLabel = "Moderator"
    elseif group == "admin" then
        multiplier = 3
        groupLabel = "Administrator"
    elseif group == "dev" then
        multiplier = 5
        groupLabel = "Developer"
    end

    return multiplier, icon, iconColor, groupLabel
end

function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(Config.PaycheckInterval)
            for player, xPlayer in pairs(ESX.Players) do
                local jobLabel = xPlayer.job.label
                local salary = xPlayer.job.grade_salary
                local group = xPlayer.getGroup()
                local multiplier, icon, iconColor, groupLabel = getMultiplierAndIcon(player)

                if salary > 0 then
                    local notificationText

                    if xPlayer.job.grade_name == "unemployed" then
                        local payment = salary * multiplier
                        if group ~= 'user' then
                            notificationText = string.format("You have received a government aid of $%d (Multiplier: %.1fx, Group: %s)", payment, multiplier, groupLabel)
                        else
                            notificationText = string.format("You have received a government aid of $%d", payment)
                        end
                        xPlayer.addAccountMoney("bank", payment, "Government Aid")
                        
                        TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), notificationText, "CHAR_BANK_MAZE", 9)

                        if Config.LogPaycheck then
                            ESX.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
                                { name = "Player", value = xPlayer.name, inline = true },
                                { name = "ID", value = xPlayer.source, inline = true },
                                { name = "Amount", value = payment, inline = true },
                            })
                        end
                    else
                        TriggerEvent("esx_society:getSociety", xPlayer.job.name, function(society)
                            if society then
                                TriggerEvent("esx_addonaccount:getSharedAccount", society.account, function(account)
                                    if account.money >= salary then
                                        local payment = salary * multiplier
                                        if group ~= 'user' then
                                            notificationText = string.format("You have received a salary of $%d from the company %s (Multiplier: %.1fx, Group: %s)", payment, jobLabel, multiplier, groupLabel)
                                        else
                                            notificationText = string.format("You have received a salary of $%d from the company %s", salary, jobLabel)
                                        end
                                        xPlayer.addAccountMoney("bank", payment, "Salary")
                                        account.removeMoney(salary)

                                        if Config.LogPaycheck then
                                            ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                                { name = "Player", value = xPlayer.name, inline = true },
                                                { name = "ID", value = xPlayer.source, inline = true },
                                                { name = "Amount", value = payment, inline = true },
                                            })
                                        end

                                        TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), notificationText, "CHAR_BANK_MAZE", 9)
                                    else
                                        notificationText = string.format("The company %s does not have enough money to pay you.", jobLabel)
                                        TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("error"), notificationText, "CHAR_BANK_MAZE", 1)
                                    end
                                end)
                            else
                                local payment = salary * multiplier
                                if group ~= 'user' then
                                    notificationText = string.format("You have received a salary of $%d from a generic job (Multiplier: %.1fx, Group: %s)", salary, multiplier, groupLabel)
                                else
                                    notificationText = string.format("You have received a salary of $%d from a generic job", salary)
                                end
                                xPlayer.addAccountMoney("bank", salary, "Salary")
                                TriggerClientEvent("esx:showAdvancedNotification", player, TranslateCap("bank"), TranslateCap("received_paycheck"), notificationText, "CHAR_BANK_MAZE", 9)

                                if Config.LogPaycheck then
                                    ESX.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
                                        { name = "Player", value = xPlayer.name, inline = true },
                                        { name = "ID", value = xPlayer.source, inline = true },
                                        { name = "Amount", value = salary, inline = true },
                                    })
                                end
                            end
                        end)
                    end
                end
            end
        end
    end)
end
