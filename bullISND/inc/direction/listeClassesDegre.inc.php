<?php

session_start();
require_once '../../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();
// définition de la class Ecole
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$degre = isset($_POST['degre']) ? $_POST['degre'] : Null;

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$listeClasses = $Ecole->listeClassesNiveau($degre);

$smarty->assign('listeClasses', $listeClasses);

echo $smarty->fetch('direction/listeClasses.tpl');
