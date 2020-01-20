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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$troubles = isset($form['trouble']) ? $form['trouble'] : array();
$amenagements = isset($form['amenagement']) ? $form['amenagement'] : array();
$matricule = $form['matricule'];
$memo = $form['memo'];

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.'inc/classes/class.Athena.php';
$Athena = new Athena();

$nb = $Athena->saveMemo($matricule, $memo);
$listeTroubles = $Athena->getTroublesEBS();
$nb = $Athena->saveTroubles($matricule, $listeTroubles, $troubles);
$listeAmenagements = $Athena->getAmenagementsEBS();
$nb = $Athena->saveAmenagements($matricule, $listeAmenagements, $amenagements);

echo $nb;
