<?php

require_once("../../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

$acronyme = isset($_POST['acronyme']) ? $_POST['acronyme'] : null;

require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
$User = new User();

// recherche des classes attribuées
$classes = $User->getClassesEduc($acronyme);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
$listeClasses = $Ecole->listeClasses();

require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeClasses', $listeClasses);
$smarty->assign('classes', $classes);
$smarty->display('users/listeGroupes.tpl');
