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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;
$laDate = isset($_POST['laDate']) ? $_POST['laDate'] : Null;
$dateSQL = $Application::dateMysql($laDate);
$statutAbs = $Edt->getFirstStatutAbs($abreviation, $dateSQL);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$nomProf = $Ecole->abr2name($abreviation);

$smarty->assign('acronyme', $abreviation);
$smarty->assign('nomProf', $nomProf);
$smarty->assign('laDate', $laDate);
$smarty->assign('statutAbs', $statutAbs);

$smarty->display('modal/selectDatesAdd.tpl');
