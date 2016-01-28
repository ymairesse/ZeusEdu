<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Ecole
require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

$coursGrp = isset($_POST['coursGrp'])?$_POST['coursGrp']:Null;
if ($coursGrp == Null) die();

$listeProfs = $Ecole->listeProfsCoursGrp($coursGrp);
$listeEleves = $Ecole->listeElevesCours($coursGrp, 'alpha');
require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign('coursGrp', $coursGrp);
$smarty->assign('listeProfs', $listeProfs);
$smarty->assign('listeEleves', $listeEleves);
$smarty->display('listeElevesDel.tpl'); 
?>