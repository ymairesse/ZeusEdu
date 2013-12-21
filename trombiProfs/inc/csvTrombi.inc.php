<?php
require_once ("../../inc/fonctions.inc.php");
require_once ("fonctionsTrombi.inc.php");
require_once ("../../config/constantes.inc.php");
$groupe = isset($_GET['groupe'])?$_GET['groupe']:Null;
$cours =  isset($_GET['cours'])?$_GET['cours']:Null;
if (($groupe == Null) && ($cours == Null)) die();

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

if ($groupe) {
	$eleves =  elevesDeClasseFromBulluc($groupe);
	groupe2csv ($eleves, $groupe);
	$smarty->assign("groupe", $groupe);
	}
if ($cours) {
	$eleves = ElevesDuCoursFromBulluc($cours);
	groupe2csv ($eleves, $cours);
	$smarty->assign("cours", $cours);
	}

$smarty->display("telechargercsv.tpl");
?>
