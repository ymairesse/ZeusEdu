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
$date = isset($_POST['date']) ? $_POST['date'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.reservations.php';
$Reservation = new Reservation();

$listeModifs = $Reservation->reserveAllRessource4date($idRessource, $date, $acronyme);

if (count($listeModifs) > 0)
    echo $acronyme;
    else echo '';
