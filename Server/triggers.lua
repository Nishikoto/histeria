local config = Histeria.Configurator;

local currently = os.time({
    year = os.date('%Y'),
    month = os.date('%m'),
    day = os.date('%d'),
    hour = os.date('%H'),
    min = os.date('%M'),
    sec = os.date('%S'),
})

local function EndBan(day)
    local endof = os.time({
        year = os.date('%Y'),
        month = os.date('%m'),
        day = tostring(tonumber(os.date('%d')) + tonumber(day)),
        hour = os.date('%H'),
        min = os.date('%M'),
        sec = os.date('%S'),
    })
    return endof
end

local function TranslateMs(ms)
    return os.date('%d/%m/%Y - %H:%M', ms)
end

local function RandomNumb()
    return math.random(99, 99999999999)
end

local function GetIdentifier(player)
    local userInfo = {}

    local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

    for k,v in pairs(GetPlayerIdentifiers(player))do
            
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            userInfo.steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            userInfo.license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            userInfo.xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            userInfo.ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            userInfo.discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            userInfo.liveid = v
        end
        
    end
    return userInfo
end

local HisteriaServer = {
    ---@param SourceID string Server ID [Source or 'Console']
    ---@param SourceESX string ESX ID
    ---@param TargetIdentifier string Identifier ESX 
    ---@param TargetESX string ESX ID
    ---@param Message string Message of ban
    ---@param Time string Time of ban
    BanUser = function(SourceID, SourceESX, TargetIdentifier, TargetESX, Message, Time)
        local xPlayer = SourceESX
        local result = MySQL.scalar.await('SELECT 1 FROM `histeria_ban` WHERE `identifier` = ?', {TargetIdentifier})

        if result then
            if xPlayer == 'Console' then
                print('Ce joueur est déjà banni!')
            else
                xPlayer.triggerEvent('client:historia:notify', 'Impossible', 'Ce joueur est déjà banni!', 'error')
            end 
        else
            local BanID = config.More.prefixBanID..RandomNumb()
    
            local getTableSQL_BanID = MySQL.query.await('SELECT * FROM `histeria_ban` WHERE `banid` = ?', {BanID})
                
            if getTableSQL_BanID then
                if xPlayer == 'Console' then
                    print('Une erreur s\'est produite, veuillez réessayer!')
                else
                    xPlayer.triggerEvent('client:historia:notify', 'Erreur', 'Une erreur s\'est produite, veuillez réessayer!', 'error')
                end
            end
                
            local UserIdentifier = TargetIdentifier;
            if SourceID == 'Console' then
                AuthorName = 'Console';
            else
                AuthorName = GetPlayerName(SourceID);
            end
            local CurrentlyDate = currently;
            local EndOfBanDate = EndBan(Time);
                
            local Insertion = MySQL.insert.await('INSERT INTO `histeria_ban` (`identifier`, `message`, `banid`, `date`, `endate`, `author`) VALUES (?,?,?,?,?,?)', {
                UserIdentifier, Message, BanID, CurrentlyDate, EndOfBanDate, AuthorName
            })
                
            if Insertion then
                if xPlayer == 'Console' then
                    print('Joueur banni avec succès.')
                else
                    xPlayer.triggerEvent('client:historia:notify', 'Top 1', 'Joueur banni avec succès.', 'success')
                end
                Wait(250)
                TargetESX.kick('Vous avez été banni '..Time..' jours! ('..Message..')')
            end
        end
    end,
    UnbanUser = function(xPlayer, banid)
        local result = MySQL.query.await('SELECT * FROM `histeria_ban` WHERE `banid` = ?', {banid})
        local pass = false

        if result then
            for i = 1, #result do
                local v = result[i]
                local identifier = v.identifier;
                MySQL.update('DELETE FROM `histeria_ban` WHERE `identifier` = ?', {identifier}, function(affectedRows)
                    if xPlayer == 'Console' then
                        print('Player unbanned')
                    else
                        xPlayer.triggerEvent('client:historia:notify', 'Top 1', 'Joueur débannis.', 'success')
                    end
                end)
            end
        end
    end
}

RegisterNetEvent('histeria:console', function(type, target, msg, time)
    source = 0
    if source == 0 then
        if type == nil then
            print('Type nul')
        else
            if type == 'ban' then
                local xTarget = ESX.GetPlayerFromId(target)
                if not xTarget then return end;
                local id = GetIdentifier(target)
                HisteriaServer.BanUser('Console', 'Console', id.license, xTarget, msg, time)
            elseif type == 'unban' then
                HisteriaServer.UnbanUser('Console', target)
            end
        end
    end
end)

RegisterNetEvent('histeria:banUser', function(target, msg, time)
    local more = config.More;

    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not xPlayer then return end;

    local _trg = target
    local xTarget = ESX.GetPlayerFromId(_trg)
    if not xTarget then return end;

    local sourceIdentifier = GetIdentifier(_src);
    local targetIdentifier = GetIdentifier(_trg);

    local sourceGroup = xPlayer.getGroup()
    local targetGroup = xTarget.getGroup()

    if sourceGroup ~= 'user' then
        if targetGroup ~= 'user' then
            if more.canBanStaff then
                HisteriaServer.BanUser(_src, xPlayer, targetIdentifier.license, xTarget, msg, tonumber(time), false)
            else
                xPlayer.triggerEvent('client:historia:notify', 'Impossible', 'Vous ne pouvez pas bannir un staff!', 'error')
            end
        else
            HisteriaServer.BanUser(_src, xPlayer, targetIdentifier.license, xTarget, msg, tonumber(time), false)
        end
    else
        HisteriaServer.BanUser('Console', 'Console', sourceIdentifier, xPlayer, 'Tentative de triche détecté.', 3650)
    end
end)

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local _src = source
    local identifier = GetIdentifier(_src)
    
    MySQL.query('SELECT * FROM `histeria_ban` WHERE `identifier` = ?', {identifier.license}, function(result)
        if result then
            for i = 1, #result do
                local v = result[i]
                data = {
                    type = "AdaptiveCard",
                    version = "1.6",
                    body = { {
                      type = "Image",
                      id = "img",
                      url = "https://media.discordapp.net/attachments/1129679497013231716/1155200903465406554/logo.png?ex=6517b86d&is=651666ed&hm=47b35180b467008293d3af175a71b9cf1ad7a62b56da1b89993876e810a4ec01&=",
                      spacing = "None",
                      horizontalAlignment = "Center",
                      size = "Small"
                    }, {
                      type = "TextBlock",
                      text = "VOUS AVEZ ÉTÉ BANNI !",
                      wrap = true,
                      id = "banned-title",
                      horizontalAlignment = "Center",
                      size = "ExtraLarge"
                    }, 
                    {
                        type = "TextBlock",
                        text = "               ",
                        wrap = true,
                    },{
                        type = "TextBlock",
                        text = "               ",
                        wrap = true,
                    },
                    {
                        type = "TextBlock",
                        text = "               ",
                        wrap = true,
                    },{
                        type = "TextBlock",
                        text = "               ",
                        wrap = true,
                    },
                    {
                        type = "TextBlock",
                        text = "               ",
                        wrap = true,
                    },{
                      type = "TextBlock",
                      text = "Début : "..TranslateMs(v.date),
                      wrap = true,
                      id = "banned-time1",
                      size = "Medium"
                    }, {
                      type = "TextBlock",
                      text = "Fin : "..TranslateMs(v.endate),
                      wrap = true,
                      id = "banned-time2",
                      size = "Medium"
                    }, {
                      type = "TextBlock",
                      text = "Identifiant : "..v.banid,
                      wrap = true,
                      id = "banned-id",
                      size = "Medium"
                    }, {
                      type = "TextBlock",
                      text = "Raison : "..v.message,
                      wrap = true,
                      id = "banned-message",
                      size = "Medium"
                    },
                    {
                        type = "TextBlock",
                        text = "Auteur : "..v.author,
                        wrap = true,
                        id = "banned-author",
                        size = "Medium"
                      }, {
                      type = "TextBlock",
                      text = "Si vous considérez que le ban est injustifié, veuillez vous référer vers le discord "..config.More.nameServer..".",
                      wrap = true,
                      id = "message",
                      size = "Medium",
                      horizontalAlignment = "Center"
                    }, {
                      type = "ActionSet",
                      id = "link",
                      spacing = "Medium",
                      horizontalAlignment = "Center",
                      actions = { {
                        type = "Action.OpenUrl",
                        title = "Notre discord",
                        id = "discord",
                        url = "https://discord.gg/a2FDvAra4Z"
                      } }
                    } }
                }
            end
        end
    end)

    deferrals.defer()
    Wait(1)
    deferrals.update('Vérification de votre client en cours...')
    Wait(1)
    MySQL.ready(function ()
        local result = MySQL.query.await('SELECT * FROM `histeria_ban` WHERE `identifier` = ?', {identifier.license})
 
        if result then
            if next(result) then
                Wait(1)
                deferrals.presentCard(data)
            else
                Wait(1)
                deferrals.done()
            end
        end
    end)

    

end

AddEventHandler("playerConnecting", OnPlayerConnecting)

if config.More.enabledCommandConsoleBan then
    RegisterCommand(config.More.commandConsoleBan, function(source, args, raw)
        if source == 0 then
            local user = tonumber(args[1]);
            local time = args[2];
            local msg = args[3];
    
            if user == nil then
                print('Joueur non-identifie')
                print('1')
            else
                if type(user) == 'number' then
                    if time == nil then
                        print('Le temps (en jour) est obligatoire!')
                    else
                        if msg == nil then
                            msg = 'Banni par Console sans raison envoyé!'
                        end
                        local target = ESX.GetPlayerFromId(user);
                        if not target then
                            print('Joueur non-identifie')
                            print('3')
                        end
                        local id = GetIdentifier(user);
                        HisteriaServer.BanUser('Console', 'Console', id.license, target, msg, time)
                    end
                else
                    print('Joueur non-identifie')
                end
            end
        end
    end)
    RegisterCommand(config.More.commandConsoleUnban, function(source, args, raw)
        if source == 0 then
            local banid = args[1];

            if banid == nil then
                print('BanID non renseigné')
            else
                HisteriaServer.UnbanUser('Console', config.More.prefixBanID..banid)
            end
        end
    end)
end

RegisterNetEvent('histeria:unbanUser', function(banid)
    local more = config.More;

    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not xPlayer then return end;

    local sourceIdentifier = GetIdentifier(_src);
    local sourceGroup = xPlayer.getGroup()

    if sourceGroup ~= 'user' then
        HisteriaServer.UnbanUser(xPlayer, config.More.prefixBanID..banid)
        xPlayer.triggerEvent('client:historia:notify', 'Information', 'Le joueur à été débannis.', 'inform')
    else

    end
end)

ESX.RegisterServerCallback('histeria:infosUser', function(source, cb, banid)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end;

    local Send = {}

    local result = MySQL.query.await('SELECT * FROM `histeria_ban` WHERE `banid` = ?', {config.More.prefixBanID..banid})
 
    if result then
        for k,v in pairs(result) do
            table.insert(Send, {
                license = v.identifier,
                reason = v.message,
                banid = v.banid,
                startdate = TranslateMs(v.date),
                endate = TranslateMs(v.endate),
                author = v.author,
            })
        end
        if next(result) then
            cb(Send)
        else
            xPlayer.triggerEvent('client:historia:notify', 'Information', 'Ce Ban ID n\'existe pas', 'inform')
        end
    end 
end)

CreateThread(function()
    while true do
        local result = MySQL.query.await('SELECT * FROM `histeria_ban`', {})
        if result then
            for k,v in pairs(result) do
                if v.endate == nil then
                    print('Anti-Bug')
                else
                    if currently >= v.endate then
                        HisteriaServer.UnbanUser('Console', config.More.prefixBanID..v.banid)
                    end
                end
            end
        end
        Wait(500)
    end
end)

ESX.RegisterServerCallback('histeria:getifstaff', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end;
    local group = xPlayer.getGroup()

    if group == 'user' then
        cb(false)
    else
        cb(true)
    end
end)