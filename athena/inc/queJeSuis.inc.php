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

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$tri = isset($_POST['tri']) ? $_POST['tri'] : Null;

$unAn = time() + 365 * 24 * 3600;
setcookie('tri', $tri, $unAn, '/', null, false, true);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('ANNEESCOLAIRE', ANNEESCOLAIRE);

// liste des élèves suivis par l'utililisateur courant
$elevesSuivis = Athena::getEleveUser($acronyme, null, null, $tri);
$smarty->assign('elevesSuivis', $elevesSuivis);

// liste des élèves sans RV
$elevesSansRV = Athena::getEleveUser($acronyme, null, null, $tri, null, true);
$smarty->assign('elevesSansRV', $elevesSansRV);

$anneesScolaires = $Athena->getListeAnneesScolaires();
$smarty->assign('anneesScolaires', $anneesScolaires);

$smarty->assign('tri', $tri);
$smarty->display('queJeSuis.tpl');
