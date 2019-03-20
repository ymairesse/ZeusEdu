<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

$idCollection = isset($_POST['idCollection']) ? $_POST['idCollection'] : null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

$listeQuestions = $thot->detailQuestionsParCollection($idCollection);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('listeQuestions', $listeQuestions);
$smarty->assign('idCollection', $idCollection);

echo $smarty->fetch('exercices/listeQuestions.tpl');
