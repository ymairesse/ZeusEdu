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

$dateDebut = isset($_POST['dateDebut']) ? $_POST['dateDebut'] : null;
$dateFin = isset($_POST['dateFin']) ? $_POST['dateFin'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

$module = $Application->getModule(3);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$resultat = $Jdc->setDateCharge($matricule, $dateDebut, $dateFin);

// le temps de voir l'ajaxloader
usleep(100000);

echo $resultat;
