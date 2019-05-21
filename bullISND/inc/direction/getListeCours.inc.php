<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

// retrouver le nom du module actif
$module = $Application->getModule(3);

$listeIdCours = isset($_POST['listeIdCours']) ? $_POST['listeIdCours'] : Null;
$listeIdCours = explode(',', $listeIdCours);

// retrouver le nom du module actif
$module = $Application->getModule(3);
$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

// renvoie une chaîne de caractères (nombres séparés par des virgules)
$listeCoursPrincipaux = $Ecole->getListeCoursPrincipaux();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('listeIdCours', $listeIdCours);
$smarty->assign('listeCoursPrincipaux', $listeCoursPrincipaux);

$smarty->display('direction/coursPrincipaux.tpl');
