<?php

function hermes_messages($user){
    require_once INSTALL_DIR.'/hermes/inc/classes/classHermes.inc.php';
    $Hermes = new Hermes();
    $unread = $Hermes->unreadMessages4User($user->acronyme());
    return $unread;
}
