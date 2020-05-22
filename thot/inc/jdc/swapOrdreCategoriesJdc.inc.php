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

$ordre1 = isset($_POST['ordre1']) ? $_POST['ordre1'] : null;
$idCategorie1 = isset($_POST['idCategorie1']) ? $_POST['idCategorie1'] : null;
$ordre2 = isset($_POST['ordre2']) ? $_POST['ordre2'] : null;
$idCategorie2 = isset($_POST['idCategorie2']) ? $_POST['idCategorie2'] : null;

$nb = $Jdc->attribOrdreCategorie($ordre1, $idCategorie2);
$nb = $Jdc->attribOrdreCategorie($ordre2, $idCategorie1);

$usedCateogries = $Jdc->getUsedCategories();
$listeCategories = $Jdc->categoriesTravaux();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeCategories', $listeCategories);
$smarty->assign('usedCategories', $usedCateogries);

$smarty->display('jdc/inc/tableSort.tpl');
