<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
//// définition de la class Ecole
require_once (INSTALL_DIR."/ades/inc/classes/classAdes.inc.php");
$Ades = new Ades();

$type = isset($_POST['type'])?$_POST['type']:Null;
if ($type == Null) die();

$listeRetenues = $Ades->listeRetenues($type, true);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("listeRetenues", $listeRetenues);
$smarty->display("selectListesRetenues.tpl"); 
?>
