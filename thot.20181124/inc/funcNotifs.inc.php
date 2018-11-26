<?php

function thot_notif($user){
    require_once INSTALL_DIR.'/thot/inc/classes/classJdc.inc.php';
    $Jdc = new Jdc();

    $titulaire = $user->listeTitulariats();
    $listeCours = $user->listeCoursProf();

    return count($Jdc->getApprobations($listeCours, $titulaire));
}
