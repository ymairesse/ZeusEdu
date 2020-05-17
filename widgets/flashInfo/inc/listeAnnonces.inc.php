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

require_once INSTALL_DIR.'/widgets/flashInfo/inc/classes/class.FlashInfo.php';
$FlashInfo = new FlashInfo;

$module = isset($_POST['module']) ? $_POST['module'] : Null;

$listeFlashInfos = $FlashInfo->listeFlashInfos($module);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../templates_c';

$userStatus = $User->userStatus($module);
$smarty->assign('userStatus', $userStatus);
$smarty->assign('listeFlashInfos', $listeFlashInfos);

$smarty->display(INSTALL_DIR."/widgets/flashInfo/templates/listeAnnonces.tpl");
