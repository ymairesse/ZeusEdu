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
// ne pas utiliser l'acronyme du user actif ici...
// $acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

$idRV = isset($_POST['idRV']) ? $_POST['idRV'] : null;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

$periode = isset($_POST['periode']) ? $_POST['periode'] : null;
// $userName = isset($_POST['userName']) ? $_POST['userName'] : null;
// ne pas confondre avec l'acronyme de l'utilisateur!!!!!
$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;

// nombre maximum de RV admissibles pour un élève
DEFINE ("MAX", 3);

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$Thot = new Thot();

// max MAX rendez-vous
$resultat = $Thot->inscriptionEleve($idRP, $idRV, $matricule, MAX);

// le cas échéant, supprimer de la liste d'attente
if ($resultat > 0) {
    $Thot->delListeAttenteProf($matricule, $acronyme, $idRP, $periode);
}

echo $resultat;
