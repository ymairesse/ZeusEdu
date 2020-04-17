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

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$startDate = isset($_POST['startDate']) ? $_POST['startDate'] : Null;
$endDate = isset($_POST['endDate']) ? $_POST['endDate'] : Null;


$listeCategories = $Jdc->getListeCategoriesJDC();
$ghostJdc = $Jdc->getGhostJdc($acronyme, $startDate, $endDate, array_keys($listeCategories));

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeCategories', $listeCategories);
$smarty->assign('ghostJdc', $ghostJdc);

$smarty->display('jdc/modal/modalGhost.tpl');
