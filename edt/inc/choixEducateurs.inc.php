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

$date = isset($_POST['date']) ? $_POST['date'] : Null;
$laPeriode = isset($_POST['laPeriode']) ? $_POST['laPeriode'] : Null;

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(2);
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classEDT.inc.php';
$Edt = new Edt();

$dateSQL = Application::dateMySQL($date);
$dateF = new DateTime($dateSQL);
$noSemaine = $dateF->format("W");

$listeEducs = $Edt->getEducs4date($dateSQL);
// liste des périodes de cours dans l'école
$listePeriodes = $Edt->getPeriodesCours(true, true);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('date', $date);
$smarty->assign('noSemaine', $noSemaine);
$smarty->assign('listePeriodes', $listePeriodes);
$smarty->assign('laPeriode', $laPeriode);
$smarty->assign('listeEducs', $listeEducs);

$smarty->display('modal/modalSelectEducs.tpl');
