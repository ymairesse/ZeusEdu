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

$module = $Application->getModule(3);

// identifiant de la ressource
$idRessource = isset($_POST['idRessource']) ? strtoupper($_POST['idRessource']) : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/class.reservations.php';
$Reservation = new Reservation();

$infoRessource = $Reservation->getRessourceById($idRessource);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty;
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

$smarty->assign('idRessource', $idRessource);
$smarty->assign('reference', $infoRessource['reference']);
$smarty->assign('description', $infoRessource['description']);

$smarty->display('ressources/modal/modalViewCalendar.tpl');
