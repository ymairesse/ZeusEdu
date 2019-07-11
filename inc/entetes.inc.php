<?php

// fonctions globales pour l'ensemble de l'application
require_once INSTALL_DIR.'/inc/fonctions.inc.php';

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class Chrono
require_once INSTALL_DIR.'/inc/classes/classChrono.inc.php';
$chrono = new Chrono();

$Application->Normalisation();
$module = $Application->repertoireActuel();

session_start();
$user = $_SESSION[APPLICATION];

// si pas d'utilisateur authentifié en SESSION et répertorié dans la BD, on renvoie à l'accueil
// ce peut-être un utilisateur régulier ou un alias qui a priorité
if (isset($user) && $user->getAlias() != null) {
    $utilisateur = $user->getAlias();
} else {
        $utilisateur = $user;
    }
if (!($utilisateur) || !($utilisateur->islogged($utilisateur->acronyme(), $_SERVER['REMOTE_ADDR']))) {
    header('Location: ../accueil.php');
}

// Vérification de l'autorisation d'accès à l'application et au module en cours
if (!($user->accesApplication(APPLICATION) && $user->accesModule(BASEDIR))) {
    header('Location: ../index.php');
}

// fonctions pour l'application "en cours"; déprécié, remplacé par des classes spécifiques
$file = INSTALL_DIR."/$module/inc/fonctions".ucfirst($module).'.inc.php';
if (file_exists($file)) {
    require_once $file;
}

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
// l'élève sera éventuellement défini ultérieurement par son matricule

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();

$smarty->assign('titre', TITREGENERAL);
$smarty->assign('module', $module);

$smarty->assign('INSTALL_DIR', INSTALL_DIR);

// toutes les informations d'identité, y compris nom, prénom,,...
$smarty->assign('identite', $user->identite());
// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign('identification', $user->identification());
// liste des classes dont le prof est titulaire (prof principal)

$sections = explode(',', SECTIONS);
$sections = "'".implode("','", $sections)."'";
$smarty->assign('titulaire', $user->listeTitulariats($sections));

$userStatus = $user->userStatus($module);
$smarty->assign('userStatus', $userStatus);

// configuration d'un alias éventuel
$alias = $user->getAlias();
if ($alias != '') {
    $alias = $alias->identite();
} else {
        $alias = null;
    }
$smarty->assign('alias', $alias['acronyme']);

// récupération de 'action' et 'mode' qui définissent toujours l'action principale à prendre
// d'autres paramètres peuvent être récupérés plus loin
$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : null;
$mode = isset($_REQUEST['mode']) ? $_REQUEST['mode'] : null;

// durée de validité pour les Cookies
$unAn = time() + 365 * 24 * 3600;
