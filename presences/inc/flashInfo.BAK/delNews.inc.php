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

$id = isset($_POST['id']) ? $_POST['id'] : Null;

$module = $Application->getModule(3);

require_once INSTALL_DIR.'/inc/classes/classFlashInfo.inc.php';
$FlashInfo = new FlashInfo;

$resultat = $FlashInfo->delFlashInfo ($id, $module);

echo $resultat;
