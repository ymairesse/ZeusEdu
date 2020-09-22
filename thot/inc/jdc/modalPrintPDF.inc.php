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

$dateDepuis = isset($_POST['dateDepuis']) ? $_POST['dateDepuis'] : Null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : Null;

$listeCoursProf = $User->listeCoursProf();

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$categories = $Jdc->categoriesTravaux();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('categories', $categories);
$smarty->assign('listeCoursProf', $listeCoursProf);
$smarty->assign('dateDepuis', $dateDepuis);

$smarty->display('jdc/modal/modalPrint.tpl');
