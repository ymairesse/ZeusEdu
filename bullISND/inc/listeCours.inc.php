<?php

session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Bulletin
require_once (INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php");
$Bulletin = new Bulletin();

$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
if ($niveau == Null) die();

$listeCours = $Bulletin->listeCoursNiveaux($niveau);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeCoursComp', $listeCours);

$smarty->display('selecteurs/listeCoursComp.tpl');
