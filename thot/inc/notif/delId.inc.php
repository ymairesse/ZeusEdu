<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$id = isset($_POST['id']) ? $_POST['id'] : null;

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

// comptage nes notification de ce type
$nbNotifs = $thot->nbNotifType($id, $acronyme);
// suppression de la notification
$nb = $thot->delNotification($id, $acronyme);
// suppression des demandes d'accusés de lecture
$nb = $thot->delAccuse($id, $acronyme);

echo $nbNotifs - 1;
