<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

$abreviation = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;
$date = isset($_POST['date']) ? $_POST['date'] : Null;
$dateSQL = Application::dateMySQL($date);
$heure = isset($_POST['heure']) ? $_POST['heure'] : Null;
// startTime nécessaire pour rétablir le statut de la période originale
$startTime = isset($_POST['startTime']) ? $_POST['startTime'] : Null;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

$nb = $Edt->delAbsenceDeplacee($abreviation, $dateSQL, $heure, $startTime);

echo $nb;
