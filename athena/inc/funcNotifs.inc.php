<?php

function athena_notif($user) {
    require_once INSTALL_DIR."/inc/classes/class.Athena.php";
    $Athena = new Athena();
    return count($Athena->getDemandesSuivi());
}
