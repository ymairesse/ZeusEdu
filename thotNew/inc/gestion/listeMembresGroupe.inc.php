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

$nomGroupe = isset($_POST['nomGroupe']) ? $_POST['nomGroupe'] : null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classThot.inc.php';
$Thot = new Thot();

$dataGroupe = $Thot->getData4groupe($nomGroupe);
$listeMembres = $Thot->getListeMembresGroupe($nomGroupe, $acronyme);

$nbProfs = isset($listeMembres['profs']) ? count($listeMembres['profs']) : 0;
$nbEleves = isset($listeMembres['eleves']) ? count($listeMembres['eleves']) : 0;
$nbMembres = $nbProfs + $nbEleves;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('nomGroupe', $nomGroupe);
$smarty->assign('dataGroupe', $dataGroupe);
$smarty->assign('listeMembres', $listeMembres);
$smarty->assign('nbMembres', $nbMembres);

$smarty->display('gestion/inc/listeMembres.tpl');
