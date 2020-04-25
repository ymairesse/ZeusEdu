<?php
require_once("../../../config.inc.php");

session_start();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;
$periode = isset($_POST['periode'])?$_POST['periode']:Null;
$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot2.inc.php');
$thot = new Thot();

// introduire dans la liste d'attente complète
$resultat = $thot->setListeAttenteProf($matricule, $acronyme, $date, $periode);
// return array('matricule'=>$matricule, 'acronyme'=>$acronyme, 'date'=>$date);
return $resultat;
