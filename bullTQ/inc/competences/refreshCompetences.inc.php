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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$listeCompetences = $Bulletin->listeCompetencesListeCours($cours);
$listeUsedCompetences = $Bulletin->getUsedCompetences($listeCompetences[$cours]);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeCompetences', $listeCompetences);
$smarty->assign('listeUsedCompetences', $listeUsedCompetences);

$smarty->display('admin/bodyCompetences.tpl');
