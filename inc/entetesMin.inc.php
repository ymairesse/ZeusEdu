<?php

/**
* Entêtes suffisantes pour un accès sans authentification
* --------------------------------------------------------
*/

// définition de la class USER utilisée en variable de SESSION
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Chrono
require_once (INSTALL_DIR."/inc/classes/classChrono.inc.php");
$chrono = new chrono();

$Application->Normalisation();
$module = $Application->repertoireActuel();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->assign("titre", TITREGENERAL);
$smarty->assign("module", $module);




// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign ("identification", user::identification());

// récupération de 'action' et 'mode' qui définissent toujours l'action principale à prendre
// d'autres paramètres peuvent être récupérés plus loin
$action = isset($_REQUEST['action'])?$_REQUEST['action']:Null;
$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;

/* pas de balise ?> finale, c'est volontaire */
