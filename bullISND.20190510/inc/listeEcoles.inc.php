<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();

// définition de la class Bulletin
require_once ("classes/classBulletin.inc.php");
$Bulletin = new Bulletin();


$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
if ($niveau == Null) die();
$listeEcoles = $Bulletin->listeEcoles($niveau);

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("listeEcoles", $listeEcoles);
$smarty->display("listeEcoles.tpl");
?>
