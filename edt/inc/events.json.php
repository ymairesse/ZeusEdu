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

$unAn = time() + 365 * 24 * 3600;

$start = $_POST['start'];
$end = $_POST['end'];

$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : Null;

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(2);
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classEDT.inc.php';
$Edt = new Edt();

$dateLundi = date('Y-m-d', strtotime('monday this week'));

$eventsList = Null;
$eventsList = $Edt->getEvents4prof($acronyme, $dateLundi);

echo json_encode($eventsList);
