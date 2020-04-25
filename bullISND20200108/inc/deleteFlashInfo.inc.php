<?php
session_start();
require_once("../../config.inc.php");
// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Bulletin
require_once (INSTALL_DIR."/inc/classes/classFlashInfo.inc.php");


$id = isset($_POST['id'])?$_POST['id']:Null;
$titre = stripslashes($_POST['titre']);
if ($id == Null) die("no id");

$nb = flashInfo::delFlashInfo($id);
require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("nb", $nb);
$smarty->assign("titre", $titre);
$smarty->display("deleteFlashInfo.tpl"); 
?>
