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

if (isset($_POST['laDate'])) {
    $_POST['start'] = $_POST['laDate'];
    }
$start = $_POST['start'];
$end = $_POST['end'];

$listeCategories = isset($_POST['categories']) ? $_POST['categories'] : Null;
if ($listeCategories != Null) {
    parse_str($listeCategories, $categories);
    $listeCategories = $categories['categories'];
}

$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$eventsList = $Jdc->getEvents2createModele($listeCategories, $start, $end, $acronyme);

echo json_encode($eventsList);
