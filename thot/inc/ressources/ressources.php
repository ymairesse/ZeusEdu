<?php

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$typeRessources = $Reservation->getTypesRessources();
$listeHeuresCours = $Ecole->lirePeriodesCours();

$smarty->assign('typeRessources', $typeRessources);
$smarty->assign('listeHeuresCours', $listeHeuresCours);
$smarty->assign('userStatus', $userStatus);

$smarty->assign('corpsPage', 'ressources/ressources');
