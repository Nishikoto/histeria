local config = Histeria.Configurator;

if config.Menu.enabled then
    local menu = config.Menu;
    RegisterCommand(menu.command, function()
        ESX.TriggerServerCallback('histeria:getifstaff', function(bool)
            if bool then
                lib.showContext('menu-of-histeria-1-0');
            else
                print('Info: Vous n\'avez pas accès à ce menu!')
            end
        end)
    end)
    RegisterKeyMapping(menu.command, 'Histeria System', 'keyboard', menu.bind);
end

lib.registerContext({
    id = 'menu-of-histeria-1-0',
    title = 'Histeria 1.0',
    canClose = true,
    options = {
        {
            title = 'Infos utilisateur',
            icon = 'fa-solid fa-user',
            iconColor = '#0671cf',
            onSelect = function()
                local input = lib.inputDialog('Information utilisateur', {
                    {type = 'input', label = 'Ban ID', description = 'Le BanID du joueur.', icon = 'fa-solid fa-user', required = true}
                })
                if input[1] == nil then
                    TriggerEvent('client:historia:notify', 'Impossible', 'L\'une des cases est vide!', 'error')
                else
                    ESX.TriggerServerCallback('histeria:infosUser', function(result)
                        local res = result
                        for _,v in pairs(res) do
                            lib.alertDialog({
                                header = 'Informations utilisateur',
                                content = '**Ban ID** '..v.banid..'\n\n**Du** '..v.startdate..' **au** '..v.endate..'\n\n**Raison** '..v.reason..'\n\n**Par** '..v.author,
                                size = 'md',
                            })
                        end
                    end, input[1])
                end
            end
        },
        {
            title = 'Bannir un utilisateur',
            icon = 'fa-solid fa-gavel',
            iconColor = '#cf0606',
            onSelect = function()
                local input = lib.inputDialog('Bannir un utilisateur', {
                    {type = 'number', label = 'ID de l\'utilisateur', description = 'Cette option est obligatoire.', icon = 'fa-solid fa-user', required = true},
                    {type = 'number', label = 'Combien de temps (en jours)', description = 'Cette option est obligatoire.', icon = 'fa-solid fa-clock', required = true},
                    {type = 'input', label = 'Raison du bannisement', description = 'Cette option est obligatoire.', required = true, min = 1, max = 500},
                })
                if input[1] == nil or input[2] == nil or input[3] == nil then
                    TriggerEvent('client:historia:notify', 'Impossible', 'L\'une des cases est vide!', 'error')
                else
                    if input[2] > 3650 then
                        TriggerEvent('client:historia:notify', 'Impossible', 'Il est impossible de ban un joueur plus de 10ans.', 'error')
                    else
                        TriggerServerEvent('histeria:banUser', input[1], input[3], input[2])
                    end
                end
                
            end
        },
        {
            title = 'Débannir un utilisateur',
            icon = 'fa-solid fa-scale-unbalanced',
            iconColor = '#06cf2b',
            onSelect = function()
                local input = lib.inputDialog('Débannir un utilisateur', {
                    {type = 'input', label = 'Ban ID de l\'utilisateur', description = 'Cette option est obligatoire.', icon = 'fa-solid fa-user', required = true},
                })
                if input[1] == nil then
                    TriggerEvent('client:historia:notify', 'Impossible', 'L\'une des cases est vide!', 'error')
                else
                    TriggerServerEvent('histeria:unbanUser', input[1])
                end
            end
        },
    }
})

RegisterNetEvent('client:historia:notify', function(title, description, type)
    lib.notify({
        id = 'notify-warning',
        title = title,
        description = description,
        type = type,
        position = 'top-center'
    })
end)