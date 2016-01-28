<?php
session_start();
require_once("../../config.inc.php");

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$date = isset($_POST['date'])?$_POST['date']:Null;
if (($date == Null) || ($matricule == Null)) die();

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Presences
require_once (INSTALL_DIR."/presences/inc/classes/classPresences.inc.php");
$Presences = new Presences();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();

$smarty->assign('matricule',$matricule);
$smarty->assign('date',$date);
$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);
$presences = $Presences->listePresencesElevesDate($date,$matricule);
$smarty->assign('presences',$presences);

$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->display("presencesJour.tpl"); 
?>
