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

$type = isset($_POST['type']) ? $_POST['type'] : Null;
$info = isset($_POST['info']) ? $_POST['info'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(2);
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classEDT.inc.php';
$Edt = new Edt();

if ($info != '') {
    $dateSQL = Application::dateMySQL($date);
    $nb = $Edt->saveInfo($type, $info, $dateSQL, $acronyme);
}

// on recharge tout pour pouvoir équilibrer les deux colonnes
$listeInfos = $Edt->getInfos4date('info', $dateSQL);
$listeRetards = $Edt->getInfos4date('retard', $dateSQL);

$size = count($listeInfos);
$mid = intdiv($size, 2);
$listeInfos1 = array_slice($listeInfos, 0, $mid+1);
$listeInfos2 = array_slice($listeInfos, $mid+1);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeInfos1', $listeInfos1);
$smarty->assign('listeInfos2', $listeInfos2);
$smarty->assign('listeRetards', $listeRetards);

echo $smarty->display('listeInfos.tpl');
