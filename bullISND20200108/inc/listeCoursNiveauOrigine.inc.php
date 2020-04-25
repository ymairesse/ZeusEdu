<?php
session_start();
require_once("../../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Ecole
require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");


$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;

if ($niveau == Null) die();

$listeCoursGrp = Ecole::listeCoursGrp($niveau);
require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("niveau", $niveau);
$smarty->assign("nom",$niveau);
$smarty->assign("listeCoursGrpOrigine", $listeCoursGrp);
$smarty->display("listeCoursStatiqueOrigine.tpl"); 
?>
