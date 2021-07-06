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

$unAn = time() + 365 * 24 * 3600;

$start = $_POST['start'];
$end = $_POST['end'];

$idRessource = isset($_POST['idRessource']) ? $_POST['idRessource'] : Null;

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);
require_once INSTALL_DIR.$ds.$module.'/inc/classes/class.reservations.php';
$Reservation = new Reservation();

$eventsList = Null;
$eventsList = $Reservation->getCalendar4ressource($start, $end, $idRessource);

echo json_encode($eventsList);
