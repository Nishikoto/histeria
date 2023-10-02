local _version = GetResourceMetadata(GetInvokingResource() or GetCurrentResourceName(), 'version', 0)
local _name = GetResourceMetadata(GetInvokingResource() or GetCurrentResourceName(), 'name', 0)
local _license = GetResourceMetadata(GetInvokingResource() or GetCurrentResourceName(), 'license', 0)
local config = Histeria.Configurator;

function _Translation(id)
    local lang = Histeria.Translation[Histeria.Language]
    for k,v in pairs(lang) do
        if k == id then
            return v;
        end
    end
end

if config.Menu.enabled then
    local menu = config.Menu;
    RegisterCommand(menu.command, function()
        ESX.TriggerServerCallback('histeria:getifstaff', function(bool)
            if bool then
                lib.showContext('menu-of-histeria-1-0');
            else
                print(_Translation('no_access_menu'))
            end
        end)
    end)
    RegisterKeyMapping(menu.command, 'Histeria System', 'keyboard', menu.bind);
end

lib.registerContext({
    id = 'menu-of-histeria-1-0',
    title = 'Histeria',
    canClose = true,
    options = {
        {
            title = _Translation('user_info_title_button'),
            icon = 'fa-solid fa-user',
            iconColor = '#0671cf',
            onSelect = function()
                local input = lib.inputDialog(_Translation('user_info_title_button'), {
                    {type = 'input', label = _Translation('input_label_banid'), description = _Translation('input_description_banid'), icon = 'fa-solid fa-user', required = true}
                })
                Wait(250)
                if input[1] == nil then
                    TriggerEvent('client:historia:notify', _Translation('notif_label_impossible'), _Translation('notif_description_impossible'), 'error')
                else
                    ESX.TriggerServerCallback('histeria:infosUser', function(result)
                        local res = result
                        for _,v in pairs(res) do
                            lib.alertDialog({
                                header = _Translation('alertdialog_header_infouser'),
                                content = string.format(_Translation('alertdialog_content_infouser'), v.banid, v.startdate, v.endate, v.reason, v.author),
                                size = 'md',
                            })
                        end
                    end, input[1])
                end
            end
        },
        {
            title = _Translation('contextmenu_alertdialog_title_banuser'),
            icon = 'fa-solid fa-gavel',
            iconColor = '#cf0606',
            onSelect = function()
                local input = lib.inputDialog(_Translation('contextmenu_alertdialog_title_banuser'), {
                    {type = 'number', label = _Translation('input_label_userid'), description = _Translation('input_description_mandotoryoption'), icon = 'fa-solid fa-user', required = true},
                    {type = 'number', label = _Translation('input_label_timeban'), description = _Translation('input_description_mandotoryoption'), icon = 'fa-solid fa-clock', required = true},
                    {type = 'input', label = _Translation('input_label_reasonban'), description = _Translation('input_description_mandotoryoption'), required = true, min = 1, max = 500},
                })
                Wait(250)
                if input[1] == nil or input[2] == nil or input[3] == nil then
                    TriggerEvent('client:historia:notify', _Translation('notif_label_impossible'), _Translation('notif_description_impossible'), 'error')
                else
                    if input[2] > 3650 or input[2] == 0 then
                        TriggerEvent('client:historia:notify', _Translation('notif_label_impossible'), _Translation('notif_description_10yearban'), 'error')
                    else
                        TriggerServerEvent('histeria:banUser', input[1], input[3], input[2])
                    end
                end
                
            end
        },
        {
            title = _Translation('contextmenu_alertdialog_title_unbanuser'),
            icon = 'fa-solid fa-scale-unbalanced',
            iconColor = '#06cf2b',
            onSelect = function()
                local input = lib.inputDialog(_Translation('contextmenu_alertdialog_title_unbanuser'), {
                    {type = 'input', label = _Translation('inputdialog_label_baniduser'), description = _Translation('input_description_mandotoryoption'), icon = 'fa-solid fa-user', required = true},
                })
                Wait(250)
                if input[1] == nil then
                    TriggerEvent('client:historia:notify', _Translation('notif_label_impossible'), _Translation('notif_description_impossible'), 'error')
                else
                    TriggerServerEvent('histeria:unbanUser', input[1])
                end
            end
        },
        {
            title = _Translation('contextmenu_alertdialog_title_historybanuser'),
            icon = 'fa-solid fa-folder',
            iconColor = '#d6d313',
            onSelect = function()
                local input = lib.inputDialog(_Translation('contextmenu_alertdialog_title_historybanuser'), {
                    {type = 'input', label = _Translation('inputdialog_label_historybanuser'), description = _Translation('input_description_mandotoryoption'), icon = 'fa-solid fa-user', required = true},
                })
                Wait(250)
                if input[1] == nil then
                    TriggerEvent('client:historia:notify', _Translation('notif_label_impossible'), _Translation('notif_description_impossible'), 'error')
                else
                    ESX.TriggerServerCallback('histeria:infoBanHistory', function(result)
                        if type(result) == 'string' then
                            TriggerEvent('client:historia:notify', _Translation('notif_label_noresult'), _Translation('notif_description_noresult'), 'error')
                        elseif type(result) == 'table' then
                            TriggerEvent('client:historia:notify', _Translation('notif_label_success'), _Translation('notif_description_success'), 'success')
                            print('Nombre de résultat = '..#result);
                            print('------------------------------------');
                            for _,v in pairs(result) do
                                print('License = '..v.license);
                                print('Ban ID = '..v.banid);
                                print('Raison = '..v.reason);
                                print('Temps = '..v.timeban..' jours');
                                print('Auteur = '..v.author);
                                print('------------------------------------');
                            end 
                        end 
                    end, input[1])
                end
            end
        },
        {
            title = 'Version '.._version..' - '.._name..' - '.._license..' License',
            readOnly = true
        }
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