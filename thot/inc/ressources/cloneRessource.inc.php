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

$idRessource = isset($_POST['idRessource']) ? $_POST['idRessource'] : Null;
$addEditClone = isset($_POST['addEditClone']) ? $_POST['addEditClone'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$infoRessource = $Reservation->getRessourceById($idRessource);
unset($infoRessource['idRessource']);

$listeTypes = $Reservation->getTypesRessources();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeTypes', $listeTypes);
$smarty->assign('post', $infoRessource);
$smarty->assign('addEditClone', $addEditClone);

$smarty->display('ressources/modal/modalEditRessource.tpl');
