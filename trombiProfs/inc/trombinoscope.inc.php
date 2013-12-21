<?php
require_once ("fonctionsTrombi.inc.php");
require_once ("../../config/constantes.inc.php");

$groupe = isset($_GET['groupe'])?$_GET['groupe']:Null;
$cours =  isset($_GET['cours'])?$_GET['cours']:Null;
if (($groupe == Null) && ($cours == Null)) die();

require ("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

if ($groupe) {	
	$titulaires = titulaires($groupe);
	$tableauEleves = elevesDeClasseFromBulluc ($groupe);
	$smarty->assign("titulaires", $titulaires);	
	};
if ($cours) {
	$tableauEleves = ElevesDuCoursFromBulluc($cours);
	$smarty->assign("cours", $cours);	
	};

$smarty->assign("tableauEleves", $tableauEleves);
$smarty->display("trombinoscope.tpl");

?>
