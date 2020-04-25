<?php

require_once '../../../config.inc.php';

session_start();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

$listeProfsCours = $thot->listeProfsCoursEleve($matricule);
$listeDirection = $thot->listeStatutsSpeciaux();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeProfsCours', $listeProfsCours);
$smarty->assign('listeStatutsSpeciaux', $listeDirection);
$smarty->display('reunionParents/selectProfs.tpl');
