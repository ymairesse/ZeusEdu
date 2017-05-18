<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

session_start();
if (!(isset($_SESSION[APPLICATION]))) {
    die("<div class='alert alert-danger'>".RECONNECT.'</div>');
}

$idTravail = isset($_POST['idTravail']) ? $_POST['idTravail'] : null;
$idCompetence = isset($_POST['idCompetence']) ? $_POST['idCompetence'] : null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

// suppression des cotes chez les élèves
$nb = $Files->delCompTravauxEvaluations($idTravail, $idCompetence);

// effacement de la compétence dans la table travauxCompetences pour le travail donné
$n = $Files->delCompTravaux($idTravail, $idCompetence);

echo $nb;
