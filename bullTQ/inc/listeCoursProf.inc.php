<?php
session_start();

require_once("../../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Bulletin
require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
if ($acronyme == Null) die();
$listeCoursGrp = $Ecole->listeCoursProf($acronyme);
require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("listeCoursGrp", $listeCoursGrp);
$smarty->display("listeCoursProf.tpl"); 
?>
