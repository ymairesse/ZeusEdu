<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once '../classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();

$listeEleves = isset($_POST['listeEleves'])?$_POST['listeEleves']:null;
$acronyme = isset($_POST['acronyme'])?$_POST['acronyme']:null;

$nbInsert = $BullTQ->saveStagesSuivis($listeEleves, $acronyme);

// régénérer la liste complète
$nomPrenoms = $BullTQ->listeStagesSuivis($acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('nomPrenoms', $nomPrenoms);

echo $smarty->fetch('stages/selectStagesEleves.tpl');
