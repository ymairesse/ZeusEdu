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
//$acronyme = $User->getAcronyme();

// on peut avoir choisi un autre prof
$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : $User->getAcronyme();

$dateLundi = date('Y-m-d', strtotime('monday this week'));

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classJdc.inc.php';
$Jdc = new Jdc();

$eventsList = $Jdc->getEvents4modele($acronyme, $dateLundi);

echo json_encode($eventsList);
