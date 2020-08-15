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
$shareId = isset($_POST['shareId']) ? $_POST['shareId'] : null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$Files->unlinkSharedFiles4Notif($notifId, $shareId);

return true;
