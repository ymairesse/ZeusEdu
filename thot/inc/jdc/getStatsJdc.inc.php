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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$listeProfs = isset($form['profs']) ? $form['profs'] : Null;
$idCategories = isset($form['idCategories']) ? $form['idCategories'] : Null;
$debut = isset($form['debut']) ? $form['debut'] : Null;
$fin = isset($form['fin']) ? $form['fin'] : Null;

$listeStats = $Jdc->getStatsJDC($listeProfs, $idCategories, $debut, $fin);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeCoursProfs = $Ecole->getListeCoursGrp4listeProfs($listeProfs);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeStats', $listeStats);
$smarty->assign('listeCoursProfs', $listeCoursProfs);

$smarty->display('jdc/pageStatsJdc.tpl');
