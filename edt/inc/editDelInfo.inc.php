<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$userStatus = $User->userStatus($module);

$id = isset($_POST['id']) ? $_POST['id'] : Null;
$type = isset($_POST['type']) ? $_POST['type'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$info = $Edt->getInfo($id);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('info', $info);
$smarty->assign('type', $type);
$smarty->assign('date', $date);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('userStatus', $userStatus);

$smarty->display('modal/modalEditDelRetard.tpl');
