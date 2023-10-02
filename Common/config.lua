Histeria = {}
Histeria.Configurator = {}

Histeria.Language = 'FR'

Histeria.Configurator.Menu = {
    enabled = true,
    command = 'histeria',
    bind = 'F10',
}

Histeria.Configurator.More = {
    canBanStaff = true,
    prefixBanID = 'ENGV_',
    nameServer = 'd\'Engine V',
    commandConsoleBan = 'histeriaban',
    commandConsoleUnban = 'histeriaunban',
    enabledCommandConsoleBan = true,
    discordLink = "https://discord.gg/a2FDvAra4Z",
}

Histeria.Translation = {
    ['FR'] = {
        ['no_access_menu'] = 'Info: Vous n\'avez pas accès à ce menu!',
        ['user_info_title_button'] = 'Infos utilisateur',
        ['input_label_banid'] = 'Ban ID',
        ['input_description_banid'] = 'Le BanID du joueur.',
        ['notif_label_impossible'] = 'Impossible',
        ['notif_description_impossible'] = 'L\'une des cases est vide!',
        ['alertdialog_header_infouser'] = 'Informations utilisateur',
        ['alertdialog_content_infouser'] = '**Ban ID** %s\n\n**Du** %s **au** %s\n\n**Raison** %s\n\n**Par** %s',
        ['contextmenu_alertdialog_title_banuser'] = 'Bannir un utilisateur',
        ['input_label_userid'] = 'ID de l\'utilisateur',
        ['input_label_timeban'] = 'Combien de temps (en jours)',
        ['input_label_reasonban'] = 'Raison du bannisement',
        ['input_description_mandotoryoption'] = 'Cette option est obligatoire',
        ['notif_description_10yearban'] = 'Il est impossible de ban un joueur plus de 10ans.',
        ['contextmenu_alertdialog_title_unbanuser'] = 'Débannir un utilisateur',
        ['inputdialog_label_baniduser'] = 'Ban ID de l\'utilisateur',
        ['inputdialog_label_historybanuser'] = 'Nom de l\'utilisateur',
        ['contextmenu_alertdialog_title_historybanuser'] = 'Historique de Ban',
        ['notif_label_success'] = 'Effectué',
        ['notif_description_success'] = 'Regarder votre Console [F8]',
        ['notif_label_noresult'] = 'Attention',
        ['notif_description_noresult'] = 'Nous avons trouvé aucun résultat.',
    }
}