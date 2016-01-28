<?php
require_once('config.inc.php');
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
$debut = $Application->chrono();

require_once (INSTALL_DIR."/inc/classes/classUser.inc.php");

session_start();
$user = $_SESSION[APPLICATION];

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();

// toutes les informations d'identité, y compris nom, prénom,,...
$smarty->assign("identite",$user->identite());
// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign ("identification", $user->identification());

// toutes les informations d'identification réseau (adresse IP, jour et heure)
$smarty->assign("titre", TITREGENERAL);
$smarty->assign("ip", $_SERVER['REMOTE_ADDR']);

$smarty->assign("executionTime",round($Application->chrono()-$debut,6));
$smarty->display("info.tpl");
?>
