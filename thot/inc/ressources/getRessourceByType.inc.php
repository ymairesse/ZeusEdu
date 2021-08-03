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

$userStatus = $User->userStatus($module);

$idType = isset($_POST['idType']) ? $_POST['idType'] : Null;
$listeChecked = isset($_POST['listeChecked']) ? $_POST['listeChecked'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$listeRessources = $Reservation->getRessourceByType($idType);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeRessources', $listeRessources);
$smarty->assign('listeChecked', $listeChecked);
$smarty->assign('userStatus', $userStatus);

$smarty->display('ressources/selectRessource.tpl');
