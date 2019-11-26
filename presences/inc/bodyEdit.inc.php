<?php

session_start();

require_once '../../config.inc.php';
// définition de la class Application
require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$module = $Application->getModule(2);

require_once INSTALL_DIR."/$module/inc/classes/classPresences.inc.php";
$Presences = new Presences();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$listeJustifications = $Presences->listeJustificationsAbsences();
$smarty->assign('listeJustifications', $listeJustifications);

echo $smarty->fetch('bodyEdit.tpl');
