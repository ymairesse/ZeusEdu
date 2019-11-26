<?php

session_start();
require_once '../../config.inc.php';

// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class Ecole
require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$niveau = isset($_POST['niveau']) ? $_POST['niveau'] : null;
if ($niveau != '') {
    $sections = array();
    $listeClasses = $Ecole->listeClassesNiveau($niveau, 'groupe', $sections);

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../templates';
    $smarty->compile_dir = '../templates_c';
    
    $smarty->assign('listeClasses', $listeClasses);
    $smarty->display('selecteurs/listeClasses.tpl');
}
