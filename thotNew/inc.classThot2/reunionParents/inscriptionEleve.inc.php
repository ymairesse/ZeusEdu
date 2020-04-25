<?php

require_once '../../../config.inc.php';

session_start();

$id = isset($_POST['id']) ? $_POST['id'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;
$date = isset($_POST['date']) ? $_POST['date'] : null;
$periode = isset($_POST['periode']) ? $_POST['periode'] : null;
$userName = isset($_POST['userName']) ? $_POST['userName'] : null;

// nombre maximum de RV admissibles pour un élève
DEFINE ("MAX", 3);

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classThot2.inc.php';
$thot = new Thot();
// max MAX rendez-vous
$resultat = $thot->inscriptionEleve($id, $matricule, MAX, $userName);
// le cas échéant, supprimer de la liste d'attente
if ($resultat > 0) {
    $thot->delListeAttenteProf($matricule, $acronyme, $date, $periode);
}

echo $resultat;
