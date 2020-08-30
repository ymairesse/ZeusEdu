<?php


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once('config.inc.php');

// définition de la class USER
require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");
session_start();

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Chrono
require_once (INSTALL_DIR."/inc/classes/classChrono.inc.php");
$chrono = new chrono();

$user = isset($_SESSION[APPLICATION]) ? $_SESSION[APPLICATION] : Null;

if (!isset($user)) {
// if (!isset($user) || !($user->accesApplication(APPLICATION))) {
	header ("Location: accueil.php");
	}
    else {

        require_once(INSTALL_DIR."/smarty/Smarty.class.php");
        $smarty = new Smarty();
        $smarty->assign('titre', TITREGENERAL);
        $smarty->assign('titreApplication', TITREGENERAL);
        $smarty->assign('identification', $user->identification());
        $smarty->assign('applisDisponibles', $user->getApplications());
        $ip = $user->getIP();

        $acronyme = $user->getAcronyme();

        if (($Application->checkIP($ip, $acronyme) == 1) && !(isset($_COOKIE["ZEUSconn1"])))  {  // première connexion
			$hostname = $user->getHostname();
			$smarty->assign('ip',$ip);
			$smarty->assign('hostname',$hostname);
			$smarty->assign('avertissementIP','avertissementIP');

			setcookie("ZEUSconn1","mailOK",time()+24*3600);
			$Application->mailAlerte($acronyme, $user,'newIP');
			}

		// configuration d'un alias éventuel
		$alias = $user->getAlias();
		if ($alias != '')
			$alias = $alias->identite()['acronyme'];
			else $alias = Null;
		$smarty->assign('alias',$alias);

		$smarty->assign('executionTime', round($chrono->stop(),6));
        $smarty->display('index.tpl');
        }
