local function getMultiplierAndIcon(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local group = xPlayer.getGroup()

    local groupLabel = "User"
    local multiplier = 1
    local icon = "piggy-bank"
    local iconColor = "#006400"

    if group == "vip" then
        multiplier = 1.5
        icon = "star"
        groupLabel = "VIP Gold"
        iconColor = "#FFD700"
    elseif group == "vip2" then
        multiplier = 2
        icon = "star"
        groupLabel = "VIP Diamond"
        iconColor = "#b9f2ff"
    elseif group == "moderator" then
        multiplier = 2.5
        groupLabel = "Moderator"
        icon = "shield-halved"
        iconColor = "#A020F0"
    elseif group == "admin" then
        multiplier = 3
        groupLabel = "Administrator"
        icon = "shield-halved"
        iconColor = "#FF7F7F"
    elseif group == "dev" then
        multiplier = 5
        groupLabel = "Developer"
        icon = "laptop-code"
        iconColor = "white"
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

                if salary > 0 then
                    local notificationText
                    local multiplier, icon, iconColor, groupLabel = getMultiplierAndIcon(player)

                    if xPlayer.job.grade_name == "rsa" then
                        local payment = salary * multiplier
                        notificationText = string.format("You have received a government aid of $%d (Multiplier: %.1fx, Group: %s)", payment, multiplier, groupLabel)
                        xPlayer.addAccountMoney("bank", payment, "Government Aid")
                        ESX.ShowNotification(notificationText, "success", 140)
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
                                    else
                                        notificationText = string.format("The company %s does not have enough money to pay you.", jobLabel)
                                        icon = 'sack-xmark'
                                    end

                                    ESX.ShowNotification(notificationText, "error", 140)
                                end)
                            else
                                if group ~= 'user' then
                                    notificationText = string.format("You have received a salary of $%d from a generic job (Multiplier: %.1fx, Group: %s)", salary, multiplier, groupLabel)
                                else
                                    notificationText = string.format("You have received a salary of $%d from a generic job", salary)
                                end
                                xPlayer.addAccountMoney("bank", salary, "Salary")
                                ESX.ShowNotification(notificationText, "info", 140)
                            end
                        end)
                    end
                end
            end
        end
    end)
end
