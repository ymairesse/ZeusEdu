<?php

require_once '../../../config.inc.php';

session_start();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$date = isset($_POST['date']) ? $_POST['date'] : null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();
$listeRV = $thot->getRVeleve($matricule, $date);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$smarty->assign('listeRV', $listeRV);

echo $matricule;
// $smarty->display('../../templates/reunionParents/microListeRvEleve.tpl');
