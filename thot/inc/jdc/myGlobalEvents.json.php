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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();
// types d'événements à présenter

$types = isset($_COOKIE['typesJDC']) ? $_COOKIE['typesJDC'] : Null;
$types = json_decode($types);

$lesTypes = array();
if ($types != Null) {
    foreach ($types as $unType => $value) {
        if ($value == 1)
            array_push($lesTypes, $unType);
        }
    }

$start = $_POST['start'];
$end = $_POST['end'];

$eventsList = $Jdc->getMyGlobalEvents($_POST, $acronyme, $lesTypes);

echo json_encode($eventsList);
