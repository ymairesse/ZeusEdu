<?php

require_once '../../../config.inc.php';

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

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : Null;
$memo = isset($_POST['memo']) ? $_POST['memo'] : Null;

$module = $Application->getModule(3);

require_once INSTALL_DIR."/$module/inc/classes/classAdes.inc.php";
$Ades = new Ades();

$resultat = $Ades->saveMemo($matricule, $memo, $module);

if ($resultat) {
    echo "Enregistré le " . date('d/m/Y à H:i:s');
}
else echo "Problème durant l'enregistrement";
