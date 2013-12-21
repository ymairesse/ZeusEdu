<?php
require_once('config.inc.php');

// fonctions globales pour l'ensemble de l'application
require_once (INSTALL_DIR."/inc/fonctions.inc.php");

// définition de la class USER 
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application;
$debut = $Application->chrono();

$Application->Normalisation();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();

// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign ("identification", user::identification());

$smarty->assign("titre", TITREGENERAL);
$smarty->assign("titreApplication", TITREGENERAL);

$smarty->assign("executionTime",round($Application->chrono()-$debut,6));
$smarty->display("accueil.tpl");
?>
