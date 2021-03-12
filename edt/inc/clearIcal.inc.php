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


$module = $Application->getModule(2);
$ds = DIRECTORY_SEPARATOR;

// répertoire des fichiers .ics
$ics = INSTALL_DIR.$ds.$module.$ds.'ical/*.ics';

$files = glob($ics);
$nInit = count($files);

// effacement des fichiers .ics
foreach ($files as $file) {
    unlink ($file);
}
// recomptage après effacement
$files = glob($ics);
$nFinal =  count($files);

echo $nInit-$nFinal;
