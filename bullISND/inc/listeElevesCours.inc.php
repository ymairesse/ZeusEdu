<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once ("../inc/classes/classApplication.inc.php");
$Application = new Application();

$date = isset($_POST['date'])?$_POST['date']:Null;
if ($date == Null) die();

$listeEleves = $Application->listeConnectesDate($date);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeEleves', $listeEleves);
$smarty->display('listeEleves.tpl'); 
?>
