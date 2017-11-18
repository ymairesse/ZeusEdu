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

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : null;
$form = isset($_POST['form']) ? $_POST['form'] : Null;
$sharesConserves = array();
parse_str($form, $sharesConserves);
if ($sharesConserves != Null)
    $sharesConserves = $sharesConserves['shareId'];

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

// comptage des notifications de ce type
$nbNotifs = $thot->nbNotifType($notifId, $acronyme);
// suppression de la notification
$nb = $thot->delNotification($notifId, $acronyme);
// suppression des demandes d'accusés de lecture
$nb = $thot->delAccuse($notifId, $acronyme);
// suppression des espions sur les fichiers partagés
$listePJ = $thot->getPj4Notifs($notifId, $acronyme);
if ($listePJ != Null) {
    require_once INSTALL_DIR.'/inc/classes/class.Files.php';
    $Files = new Files();
    $listePJ = $listePJ[$notifId];
    $shares2Delete = array_diff(array_keys($listePJ), $sharesConserves);
    foreach ($shares2Delete as $shareId) {
        $nb = $Files->delSpy4ShareId ($shareId, $acronyme);
        }
    }

// retirer le partage des PJ
$nb = $thot->delPJ4notif ($notifId, $acronyme, $sharesConserves);

echo $nbNotifs - 1;
