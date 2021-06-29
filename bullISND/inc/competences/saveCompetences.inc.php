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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

$cours = $form['cours'];

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$nb = $Bulletin->saveCompetences($form);

$listeCompetences = $Bulletin->listeCompetencesListeCours($cours);

$listeCompetences = (isset($listeCompetences[$cours])) ? $listeCompetences[$cours] : $listeCompetences;
$listeUsedCompetences = $Bulletin->getUsedCompetences($listeCompetences);

require_once INSTALL_DIR.$ds.'smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('listeUsedCompetences', $listeUsedCompetences);
$smarty->assign('cours', $cours);

$smarty->display('admin/bodyCompetences.tpl');
