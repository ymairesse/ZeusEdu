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

$idRessource = isset($_POST['idRessource']) ? $_POST['idRessource'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;
$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;
$abreviation = isset($_POST['abreviation']) ? $_POST['abreviation'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('idRessource', $idRessource);
$smarty->assign('date', $date);
$smarty->assign('heure', $heure);

if (($abreviation == $acronyme) || ($userStatus == 'admin')) {
    $ds = DIRECTORY_SEPARATOR;
    require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
    $Reservation = new Reservation();

    $abreviation = $Reservation->unReserveRessource($idRessource, $date, $heure, $abreviation);

    $smarty->display('ressources/boutonLibre.tpl');
}
