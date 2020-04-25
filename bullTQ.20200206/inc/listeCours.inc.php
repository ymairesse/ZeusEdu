<?php

session_start();
require_once '../../config.inc.php';
// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();
// définition de la class BullTQ
require_once INSTALL_DIR.'/bullTQ/inc/classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
if ($niveau == null) {
    die();
}

$listeCours = $BullTQ->listeCoursNiveaux($niveau);
require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';
$smarty->assign('listeCoursComp', $listeCours);
$smarty->display('listeCoursComp.tpl');
