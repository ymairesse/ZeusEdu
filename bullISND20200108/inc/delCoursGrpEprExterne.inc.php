<?php
session_start();
require_once("../../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Bulletin
require_once (INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php");
$Bulletin = new Bulletin();

$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
if (($coursGrp == Null) || ($niveau == Null)) die();

// suppresssion effective de la table des épreuves externes
$nb = $Bulletin->delEprExterne($coursGrp,ANNEESCOLAIRE);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

// reconstitution du tableau des épreuves externes existantes
// liste des cours à épreuve externe défjà définis, pour affichage sur la page
$smarty->assign('listeCours', $Bulletin->listeCoursEpreuveExterne($niveau,ANNEESCOLAIRE));
			
// nombre de cotes déjà attribuées par coursGrp (nécessaire pour savoir si la suppression est possible)
$smarty->assign('nbCotesExtCoursGrp', $Bulletin->nbCotesExtCoursGrp($niveau));

$smarty->display("tableEprExterne.tpl"); 
?>
