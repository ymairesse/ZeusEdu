<?php
// fonctions globales pour l'ensemble de l'application
require_once (INSTALL_DIR."/inc/fonctions.inc.php");
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

session_start();
$user = $_SESSION[APPLICATION];

// si pas d'utilisateur authentifié en SESSION, on renvoie à l'accueil
if (!(isset($user)))
    header ("Location: ../accueil.php");
// Vérification de l'autorisation d'accès à l'application et au module en cours
if (!($user->accesApplication(APPLICATION) && $user->accesModule(BASEDIR)))
	header("Location: ../index.php");

// fonctions pour l'application "en cours"
// déprécié, mais toujours veiller à avoir un fichier fonctionsBidule.inc.php
require_once (INSTALL_DIR."/$module/inc/fonctions".ucfirst($module).".inc.php");

require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

require_once(INSTALL_DIR."/inc/classes/classEleve.inc.php");
// l'élève sera éventuellement défini ultérieurement par son matricule

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->assign("titre", TITREGENERAL);
$smarty->assign("module", $module);

// toutes les informations d'identité, y compris nom, prénom,,...
$smarty->assign("identite",$user->identite());
// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign ("identification", $user->identification());
// liste des classes dont le prof est titulaire (prof principal)
$smarty->assign("titulaire",$user->listeTitulariats());

$userStatus = $user->userStatus($module);
$smarty->assign("userStatus", $userStatus);

// récupération de 'action' et 'mode' qui définissent toujours l'action principale à prendre
// d'autres paramètres peuvent être récupérés plus loin
$action = isset($_REQUEST['action'])?$_REQUEST['action']:Null;
$mode = isset($_REQUEST['mode'])?$_REQUEST['mode']:Null;

/* pas de balise ?> finale, c'est volontaire */
