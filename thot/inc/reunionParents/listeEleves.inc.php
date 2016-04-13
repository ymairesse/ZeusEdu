<?php
require_once("../../../config.inc.php");

session_start();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$statut = isset($_POST['statut'])?$_POST['statut']:Null;

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$thot = new Thot();
$listeEleves = $thot->getElevesDeProf($acronyme, $statut);

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";

$smarty->assign('listeEleves',$listeEleves);
$smarty->display('../../templates/reunionParents/listeElevesProf.tpl');
