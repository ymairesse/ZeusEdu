<?php

require_once("../../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeClasses = $Ecole->listeClasses();

require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeClasses', $listeClasses);
$smarty->display('users/inputUnGroupe.tpl');
