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

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;
$idCompetence = isset($_POST['idCompetence']) ? $_POST['idCompetence'] : null;

// suppression des cotes chez les élèves
$nb = $Files->delCompTravauxEvaluations($idTravail, $idCompetence);

// effacement de la compétence dans la table travauxCompetences pour le travail donné
$n = $Files->delCompTravaux($idTravail, $idCompetence);

echo $nb;
