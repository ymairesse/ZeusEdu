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

$listeId = isset($_POST['listeId']) ? $_POST['listeId'] : Null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

// récupérer la liste des PJ éventuelles pour la liste des notifications
$listePJ = $Thot->getPj4Notifs(array('typeWTF' => $listeId), $acronyme);

$nb = 0;
$nbNotifs = 0;
// suppression de la notification
if (count($listeId) > 0) {
    foreach ($listeId as $id) {
        if ($nb == 0) {
            // compter le nombre de notifications de ce type au départ
            $nbNotifs = $Thot->nbNotifType($id, $acronyme);
        }
        $nb += $Thot->delNotification($id, $acronyme);
        // suppression des demandes d'accusés de lecture
        $nb += $Thot->delAccuse($id, $acronyme);
        // suppression des shares des PJ
        // $nbPJ = $Thot->unShare4notifId($shareId, $notifId, $acronyme);
        }
    }
// nombre de notifications de ce type restantes
echo $nbNotifs - $nb;
