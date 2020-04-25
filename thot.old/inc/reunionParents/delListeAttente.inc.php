<?php
require_once("../../../config.inc.php");

session_start();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$periode = isset($_POST['periode'])?$_POST['periode']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();

// supprimer de la liste d'attente complète
$resultat = $thot->delListeAttenteProf($matricule, $acronyme, $date, $periode);

return $resultat;
