<?php

require_once 'config.inc.php';

// fonctions globales pour l'ensemble de l'application
require_once INSTALL_DIR.'/inc/fonctions.inc.php';

// définition de la class USER
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class Chrono
require_once INSTALL_DIR.'/inc/classes/classChrono.inc.php';
$chrono = new chrono();

$Application->Normalisation();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();

$message = isset($_GET['message']) ? $_GET['message'] : null;
$smarty->assign('message', $message);

$acronyme = isset($_COOKIE['acronyme']) ? $_COOKIE['acronyme'] : Null;
$mdp = isset($_COOKIE['mdp']) ? $_COOKIE['mdp'] : Null;
$memory = isset($_COOKIE['memory']) ? $_COOKIE['memory'] : Null;

$smarty->assign('acronyme', $acronyme);
$smarty->assign('mdp', $mdp);
$smarty->assign('memory', $memory);

// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign('identification', user::identification());

$smarty->assign('titre', TITREGENERAL);
$smarty->assign('titreApplication', TITREGENERAL);

$smarty->assign('executionTime', round($chrono->stop(), 6));
$smarty->display('accueil.tpl');
