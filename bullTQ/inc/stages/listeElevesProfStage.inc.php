<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once '../classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();

$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:null;

$listeEleves = $BullTQ->listeStagesSuivis($acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('nomPrenoms', $listeEleves);
echo $smarty->fetch('stages/selectStagesEleves.tpl');
