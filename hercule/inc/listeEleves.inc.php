<?php

session_start();
require_once("../../config.inc.php");

// définition de la class Application
require_once (INSTALL_DIR."/inc/classes/classApplication.inc.php");
$Application = new Application();
// définition de la class Ecole
require_once (INSTALL_DIR."/inc/classes/classEcole.inc.php");
$Ecole = new Ecole();

$classe = isset($_POST['classe'])?$_POST['classe']:Null;
if ($classe == Null) die();

$partis = isset($_POST['partis'])?$_POST['partis']:false;
$listeEleves = $Ecole->listeEleves($classe,'groupe',$partis);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign("listeEleves", $listeEleves);
$smarty->display("selecteurs/listeEleves.tpl");
