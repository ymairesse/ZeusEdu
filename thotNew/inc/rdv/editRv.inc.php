<?php

require_once '../../../config.inc.php';

require_once '../../../inc/classes/classApplication.inc.php';
$Application = new Application();

$id = isset($_POST['id']) ? $_POST['id'] : null;

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$rv = $thot->getRvById($id);
$smarty->assign('rv', $rv);

$form = $smarty->fetch('../../templates/rdv/formEdit.tpl');
echo $form;
