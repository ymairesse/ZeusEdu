<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Presences
require_once("../inc/classes/classPresences.inc.php");
$Presences = new Presences();

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$matricule = isset($_POST['matricule'])?$_POST['matricule']:Null;
$smarty->assign('matricule',$matricule);

$date = isset($_POST['date'])?$_POST['date']:Null;
$mode = isset($_POST['mode'])?$_POST['mode']:Null;

$dateSuivante = $Application->datesSuivantes($date,1,false);
$dateSuivante = current($dateSuivante);
$smarty->assign('date',$dateSuivante);

$listePeriodes = $Presences->lirePeriodesCours();
$smarty->assign('listePeriodes',$listePeriodes);

$smarty->assign('listePresences',$Presences->listePresencesElevesDate($dateSuivante,$matricule));
// il s'agit d'un ajout d'un jour: ne pas remettre la ligne de titre du tableau
$smarty->assign('ajout',true);
// s'agit-il de gérer les absences annoncées?
if ($mode == 'absence')
	// alors on présente la page complète
	$html = $smarty->display('presencesJourDate.tpl');
	// sinon, on présente la page simplifiée pour les sorties autorisées
	else $html = $smarty->display('presencesJourDateSortie.tpl');

echo $html;
?>
