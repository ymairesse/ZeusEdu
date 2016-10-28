<?php

session_start();
require_once '../../config.inc.php';

// définition de la class Ecole
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
if ($niveau == null) {
    die('no level');
}
$listeCoursGrp = $Ecole->listeCoursGrp($niveau);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('niveau', $niveau);
$smarty->assign('listeCoursGrp', $listeCoursGrp);
$smarty->display('listeCours.tpl');
