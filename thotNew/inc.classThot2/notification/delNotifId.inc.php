<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classThot2.inc.php';
$Thot = new Thot();

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : null;
$type = $Thot->getType4notif($notifId);

// Suppression d'une notification comprenant éventuellement des PJ
// et des demandes d'accusés de lecture

// suppression des demandes d'accusés de lecture
$nb = $Thot->delAccuse($notifId, $acronyme);

// les PJ éventuelles seront toujours répertoriées dans la table thotShares
// mais sont déconnectées des notifications dans la table thotNotifPJ
// elles restent donc acessibles après suppression de la notification
// retirer le partage des PJ
//
$shares = array_keys($Thot->getPJ4singleNotif($notifId, $acronyme));

$nb = 0;
foreach ($shares as $shareId){
    $nb += $Thot->unlinkNotifShare($shareId, $notifId);
}

// suppression de la notification
$type = $Thot->delNotification($notifId, $acronyme);

echo $type;
