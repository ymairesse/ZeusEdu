<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(3);

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}
$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$unAn = time() + 365 * 24 * 3600;
$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classBulletin.inc.php";
$Bulletin = new Bulletin();

$niveau = Application::postOrCookie('niveau', $unAn);
$listeNiveaux = $Ecole->listeNiveaux();

require_once INSTALL_DIR."/smarty/Smarty.class.php";
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('niveau', $niveau);
$smarty->assign('listeNiveaux', $listeNiveaux);

$ponderations = ($niveau != Null) ? $Bulletin->getPonderationsNiveau($niveau) : NUll;
$listeCoursNiveau = ($niveau != Null) ? $Ecole->listeCoursNiveau($niveau) : Null;

$smarty->assign('ponderations', $ponderations);
$smarty->assign('listeCours', $listeCoursNiveau);
$smarty->assign('listePeriodes', range(1,NBPERIODES));
$arrayPeriodes = explode(',', NOMSPERIODES);
$smarty->assign('NOMSPERIODES', $arrayPeriodes);

$smarty->display('admin/listePonderations.tpl');
