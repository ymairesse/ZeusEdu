<?php

require_once("../../../config.inc.php");

require_once(INSTALL_DIR.'/inc/classes/classApplication.inc.php');
$Application = new Application();

require_once(INSTALL_DIR.'/inc/classes/classEcole.inc.php');
$Ecole = new Ecole();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:Null;
$nomProf = isset($_POST['nomProf'])?$_POST['nomProf']:Null;

$nb = $Ecole->delAttributions($acronyme);
$listeAffectations = $Ecole->listeAffectations($acronyme);

require_once(INSTALL_DIR.'/smarty/Smarty.class.php');
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('listeAffectations', $listeAffectations);
$smarty->assign('acronyme', $acronyme);
$smarty->assign('nomProf', $nomProf);

$smarty->display('../../templates/users/listeAffectations.tpl');
