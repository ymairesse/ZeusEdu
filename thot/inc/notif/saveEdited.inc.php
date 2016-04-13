<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>Votre session a expiré. Veuillez vous reconnecter.</div>");
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

require_once (INSTALL_DIR."/inc/classes/classThot.inc.php");
$thot = new Thot();

$nb = $thot->saveEdited($_POST, $acronyme);

echo json_encode($_POST);
