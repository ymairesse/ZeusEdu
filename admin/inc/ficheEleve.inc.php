<?php
session_start();
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../inc/fonctions.inc.php");
require_once ("../../config/constantes.inc.php");
require_once ("../inc/classes/classEleve.inc.php");

$codeInfo = isset($_GET['codeInfo'])?$_GET['codeInfo']:Null;
// $periodes = $_SESSION['configuration']['periodes'];
$eleve = new Eleve();
$eleve->lireEleve($codeInfo);

/* if ($codeInfo != "") {	
	$eleve = new Eleve();
	$eleve->lireEleve($codeInfo);
    } */

	require_once ("../../smarty/Smarty.class.php");
	$smarty = new Smarty();
	$smarty->template_dir = "../templates";
	$smarty->compile_dir = "../templates_c";	
	
	$smarty->assign("recordingType", "modif");
	
	$smarty->assign("eleve", $eleve);
	$smarty->display("inputEleve.tpl");
?>
