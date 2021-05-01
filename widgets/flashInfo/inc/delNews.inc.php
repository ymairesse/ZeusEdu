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
$module = isset($_POST['module']) ? $_POST['module'] : Null;

require_once INSTALL_DIR.'/widgets/flashInfo/inc/classes/class.FlashInfo.php';
$FlashInfo = new FlashInfo;

$nb = $FlashInfo->delFlashInfo ($id, $module);

echo $nb;
