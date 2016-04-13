<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$listeId = isset($_POST['listeId'])?$_POST['listeId']:Null;

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once (INSTALL_DIR."/inc/classes/classThot.inc.php");
$thot = new Thot();

$nb = 0;
// suppression de la notification
foreach ($listeId as $id) {
    $nb += $thot->delNotification($id, $acronyme);
    // suppression des demandes d'accusés de lecture
    $nb += $thot->delAccuse($id, $acronyme);
    }
echo $nb;
