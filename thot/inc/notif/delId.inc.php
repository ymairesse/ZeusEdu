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

$notifId = isset($_POST['id']) ? $_POST['id'] : null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

// comptage nes notification de ce type
$nbNotifs = $thot->nbNotifType($notifId, $acronyme);
// suppression de la notification
$nb = $thot->delNotification($notifId, $acronyme);
// suppression des demandes d'accusés de lecture
$nb = $thot->delAccuse($notifId, $acronyme);
// retirer le partage des PJ
$listePJ = $thot->getPj4Notifs($notifId, $acronyme);
if ($listePJ != Null)
    $listePJ = $listePJ[$notifId];
foreach ($listePJ as $shareId => $data) {
    $nb = $thot->unShare4notifId($shareId, $notifId, $acronyme);
    }

echo $nbNotifs - 1;
