<?php
require_once("../../../config.inc.php");

session_start();

$id = isset($_POST['id'])?$_POST['id']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;
$periode = isset($_POST['periode'])?$_POST['periode']:Null;
$userName = isset($_POST['userName'])?$_POST['userName']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();
// max trois rendez-vous
$resultat = $thot->inscriptionEleve($id, $matricule, 3, $userName);
// le cas échéant, supprimer de la liste d'attente
if ($resultat > 0)
    $thot->delListeAttenteProf($matricule, $acronyme, $date, $periode);

echo $resultat;
