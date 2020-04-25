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

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);

$notifId = isset($_POST['notifId']) ? $_POST['notifId'] : Null;
$shareId = isset($_POST['shareId']) ? $_POST['shareId'] : Null;

require_once INSTALL_DIR.$ds.'inc/classes/classThot2.inc.php';
$Thot = new thot();

require_once INSTALL_DIR.$ds.'inc/classes/class.Files.php';
$Files = new Files();

// suppression des éventuels espions sur le document
$nb = $Files->delSpy4ShareId($shareId, $acronyme);

// suppression du partage du fichier $shareId
// suppression du lien avec la notification $notifId de $acronyme
$resultat = $Thot->unShare4notifId($shareId, $notifId, $acronyme);

echo $resultat;
