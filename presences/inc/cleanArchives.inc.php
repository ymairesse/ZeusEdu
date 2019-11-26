<?php

require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$module = $Application->getModule(2);

require_once INSTALL_DIR.'/'.$module.'/inc/classes/classPresences.inc.php';
$Presences = new presences();

$month = isset($_POST['month']) ? $_POST['month'] : Null;
$year = isset($_POST['year']) ? $_POST['year'] : Null;

echo $Presences->cleanTables($year, $month);
