<?php
session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Bulletin
require_once (INSTALL_DIR."/bullISND/inc/classes/classBulletin.inc.php");
$Bulletin = new Bulletin();

$annee = isset($_POST['annee'])?$_POST['annee']:Null;
$niveau = isset($_POST['niveau'])?$_POST['niveau']:Null;
if (($annee == Null) || ($niveau == Null)) die();

$listeElevesArchives = $Bulletin->listeElevesArchives($annee, $niveau);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign("listeEleves", $listeElevesArchives);
$smarty->display("listeElevesArchives.tpl"); 
?>
